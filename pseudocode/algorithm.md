# SISTEMA DE RECOMENDACION DE MICROCURSOS

### RESUMEN DEL ENFOQUE:
Para cada estudiante, se recomiendan los cursos que no ha aprobado
todavia, cuyos prerrequisitos ya cumple, ordenados por un puntaje
que combina tres señales:
    25% -> afinidad del estudiante por el nucleo del curso (interes)
    25% -> habilidad del estudiante en el nucleo del curso (desempeño)
    50% -> cuantos de sus vecinos mas parecidos ya aprobaron ese curso
    (filtrado colaborativo)

Todo se calcula con aritmetica entera (0-100), sin numeros
flotantes, para que el mismo diseño pueda modelarse tanto en el
lenguaje de implementacion real como en Promela para verificacion
de concurrencia.

### ALCANCE DELIBERADAMENTE NO CUBIERTO:
- "nivel_curso" (progresion dentro de un nucleo) no se usa para
  priorizar candidatos; solo se usa el prerrequisito directo.
- No se recalculan similitudes de forma incremental; se asume que
  el bitmask de cursos aprobados ya esta actualizado antes de correr
  una recomendacion.

## SECCION 0: CONSTANTES GLOBALES

```lua
CONSTANTES:
    CANTIDAD_VECINOS         = 5      -- cuantos estudiantes similares se consideran
    CANTIDAD_RECOMENDACIONES = 3      -- cuantos cursos se recomiendan al final
    PESO_AFINIDAD            = 25     -- 25%
    PESO_HABILIDAD           = 25     -- 25%
    PESO_COLABORATIVO        = 50     -- 50%
    SIN_PREREQUISITO         = -1     -- centinela: "no hay prerrequisito en esta posicion"
```

## SECCION 1: PREPROCESAMIENTO (se ejecuta UNA VEZ, antes de recomendar)
Estas funciones transforman los datasets crudos (interacciones.csv,
estudiantes.csv, cursos.csv, dag_prerequisitos.csv) en las
estructuras de datos simples que usa el algoritmo de recomendacion.
No son parte del algoritmo concurrente en si: se corren antes de
lanzar el sistema, tipicamente en un script de preparacion de datos.

### 1.1. Bitmask de cursos aprobados por estudiante
Regla de aprobacion: un estudiante "aprobo" un curso si existe AL
MENOS UNA fila en interacciones.csv para ese (student_id, course_id)
con aprobado = 1, sin importar en que intento ni cuantas veces lo
intento antes.

```lua
FUNCION ConstruirCursosAprobadosPorEstudiante(lista_interacciones):
    para cada fila_interaccion en lista_interacciones:
        si fila_interaccion.aprobado == 1:
            cursos_aprobados_por_estudiante[fila_interaccion.student_id] |=
                bit(fila_interaccion.course_id)
    return cursos_aprobados_por_estudiante
```

### 1.2. Afinidad por nucleo (interes del estudiante), escalada a 0-100
estudiantes.csv trae afinidad_matematica, afinidad_lectura y
afinidad_ciencias como valores decimales entre 0 y 1.

```lua
FUNCION ConstruirAfinidadPorNucleo(lista_estudiantes):
    para cada fila_estudiante en lista_estudiantes:
        afinidad_por_nucleo[fila_estudiante.student_id][0] =
            redondear(fila_estudiante.afinidad_matematica * 100)
        afinidad_por_nucleo[fila_estudiante.student_id][1] =
            redondear(fila_estudiante.afinidad_lectura * 100)
        afinidad_por_nucleo[fila_estudiante.student_id][2] =
            redondear(fila_estudiante.afinidad_ciencias * 100)
    return afinidad_por_nucleo
```

### 1.3. Habilidad por nucleo (desempeño del estudiante), escalada a 0-100
estudiantes.csv trae habilidad_matematica, habilidad_lectura y
habilidad_ciencias como valores decimales entre 0 y 1.

> [!NOTE]: interes y desempeño no son lo mismo. Un estudiante puede tener
alta afinidad por Ciencias pero baja habilidad, y viceversa. Por eso
se modelan como dos componentes independientes del puntaje.

```lua
FUNCION ConstruirHabilidadPorNucleo(lista_estudiantes):
    para cada fila_estudiante en lista_estudiantes:
        habilidad_por_nucleo[fila_estudiante.student_id][0] =
            redondear(fila_estudiante.habilidad_matematica * 100)
        habilidad_por_nucleo[fila_estudiante.student_id][1] =
            redondear(fila_estudiante.habilidad_lectura * 100)
        habilidad_por_nucleo[fila_estudiante.student_id][2] =
            redondear(fila_estudiante.habilidad_ciencias * 100)
    return habilidad_por_nucleo
```

### 1.4. Nucleo de cada curso (directo desde cursos.csv)

```lua
FUNCION ConstruirNucleoDelCurso(lista_cursos):
    para cada fila_curso en lista_cursos:
        nucleo_del_curso[fila_curso.course_id] = fila_curso.nucleo
    return nucleo_del_curso
```

### 1.5. Prerrequisitos de cada curso (hasta 2, desde dag_prerequisitos.csv)
Un curso puede tener 0, 1 o 2 prerrequisitos en el dataset real.
Si tiene menos de 2, la posicion sobrante se llena con el centinela
SIN_PREREQUISITO.

```lua
FUNCION ConstruirPrerequisitosDelCurso(lista_dag_prerequisitos, lista_cursos):
    para cada fila_curso en lista_cursos:
        prerequisitos_del_curso[fila_curso.course_id][0] = SIN_PREREQUISITO
        prerequisitos_del_curso[fila_curso.course_id][1] = SIN_PREREQUISITO

    para cada fila_prerequisito en lista_dag_prerequisitos:
        id_curso_destino       = fila_prerequisito.course_id
        id_curso_prerequisito  = fila_prerequisito.prerequisito_id

        si prerequisitos_del_curso[id_curso_destino][0] == SIN_PREREQUISITO:
            prerequisitos_del_curso[id_curso_destino][0] = id_curso_prerequisito
        sino:
            prerequisitos_del_curso[id_curso_destino][1] = id_curso_prerequisito

    return prerequisitos_del_curso
```

## SECCION 2: ESTRUCTURAS DE DATOS DE ENTRADA (ya preparadas)
cursos_aprobados_por_estudiante[CANTIDAD_ESTUDIANTES]
    -> bitmask de cursos aprobados por cada estudiante

afinidad_por_nucleo[CANTIDAD_ESTUDIANTES][3]
    -> interes del estudiante en cada nucleo (0-100): 0=Matematica, 1=Lectura, 2=Ciencias

habilidad_por_nucleo[CANTIDAD_ESTUDIANTES][3]
    -> desempeño del estudiante en cada nucleo (0-100)

nucleo_del_curso[CANTIDAD_CURSOS]
    -> a que nucleo pertenece cada curso

prerequisitos_del_curso[CANTIDAD_CURSOS][2]
    -> hasta 2 prerrequisitos por curso (SIN_PREREQUISITO si no hay)


## SECCION 3: FILTRADO COLABORATIVO - VECINOS MAS SIMILARES

```lua
FUNCION ObtenerVecinosMasSimilares(id_estudiante_objetivo,
                                    cursos_aprobados_por_estudiante,
                                    cantidad_vecinos):

    lista_similitudes = []

    para cada id_estudiante_vecino != id_estudiante_objetivo:
        porcentaje_similitud = CalcularSimilitudJaccard(
            cursos_aprobados_por_estudiante[id_estudiante_objetivo],
            cursos_aprobados_por_estudiante[id_estudiante_vecino]
        )
        lista_similitudes.agregar( (id_estudiante_vecino, porcentaje_similitud) )

    ordenar lista_similitudes descendente por porcentaje_similitud
    return primeros cantidad_vecinos elementos de lista_similitudes


FUNCION CalcularSimilitudJaccard(bitmask_cursos_estudiante_a, bitmask_cursos_estudiante_b):
    cantidad_cursos_en_comun = contar_bits(bitmask_cursos_estudiante_a AND bitmask_cursos_estudiante_b)
    cantidad_cursos_en_total = contar_bits(bitmask_cursos_estudiante_a OR  bitmask_cursos_estudiante_b)

    si cantidad_cursos_en_total == 0:
        return 0

    return (cantidad_cursos_en_comun * 100) / cantidad_cursos_en_total
```

## SECCION 4: SELECCION DE CURSOS CANDIDATOS

```lua
FUNCION CumplePrerequisitos(id_estudiante_objetivo, id_curso_candidato,
                             cursos_aprobados_por_estudiante,
                             prerequisitos_del_curso):

    para cada id_curso_prerequisito en prerequisitos_del_curso[id_curso_candidato]:
        -- esta lista tiene como maximo 2 posiciones

        si id_curso_prerequisito != SIN_PREREQUISITO:
            si bit(id_curso_prerequisito) NO esta en
               cursos_aprobados_por_estudiante[id_estudiante_objetivo]:
                return falso   -- falta ese prerrequisito puntual

    return verdadero   -- todos los prerrequisitos que existen ya estan aprobados


FUNCION ObtenerCursosCandidatos(id_estudiante_objetivo,
                                 cursos_aprobados_por_estudiante,
                                 lista_todos_los_cursos,
                                 prerequisitos_del_curso):

    lista_candidatos = []

    para cada id_curso_candidato en lista_todos_los_cursos:

        si bit(id_curso_candidato) NO esta en
           cursos_aprobados_por_estudiante[id_estudiante_objetivo]:
            -- el estudiante todavia no aprobo este curso

            si CumplePrerequisitos(id_estudiante_objetivo, id_curso_candidato,
                                    cursos_aprobados_por_estudiante,
                                    prerequisitos_del_curso):
                lista_candidatos.agregar(id_curso_candidato)

    return lista_candidatos
```

## SECCION 5: CALCULO DEL PUNTAJE (3 componentes: 25% + 25% + 50%)

```lua
FUNCION CalcularPuntajeCurso(id_estudiante_objetivo, id_curso_candidato,
                              lista_vecinos_con_similitud,
                              cursos_aprobados_por_estudiante,
                              afinidad_por_nucleo,
                              habilidad_por_nucleo,
                              nucleo_del_curso):

    id_nucleo_del_curso_candidato = nucleo_del_curso[id_curso_candidato]

    --- Componente 1 (25%): afinidad del estudiante por el nucleo del curso ---
    aporte_afinidad =
        (afinidad_por_nucleo[id_estudiante_objetivo][id_nucleo_del_curso_candidato]
         * PESO_AFINIDAD) / 100

    --- Componente 2 (25%): habilidad del estudiante en el nucleo del curso ---
    aporte_habilidad =
        (habilidad_por_nucleo[id_estudiante_objetivo][id_nucleo_del_curso_candidato]
         * PESO_HABILIDAD) / 100

    --- Componente 3 (50%): proporcion de vecinos que aprobaron este curso ---
    cantidad_vecinos_que_aprobaron_el_curso = 0

    para cada (id_estudiante_vecino, porcentaje_similitud) en lista_vecinos_con_similitud:
        si bit(id_curso_candidato) esta en
           cursos_aprobados_por_estudiante[id_estudiante_vecino]:
            cantidad_vecinos_que_aprobaron_el_curso += 1

    aporte_colaborativo = (cantidad_vecinos_que_aprobaron_el_curso * PESO_COLABORATIVO)
                           / CANTIDAD_VECINOS

    --- Puntaje final: suma de los tres componentes ---
    puntaje_curso = aporte_afinidad + aporte_habilidad + aporte_colaborativo
    return puntaje_curso
```

## SECCION 6: FUNCION PRINCIPAL - RECOMENDAR

```lua
FUNCION Recomendar(id_estudiante_objetivo,
                    cursos_aprobados_por_estudiante,
                    lista_todos_los_cursos,
                    afinidad_por_nucleo,
                    habilidad_por_nucleo,
                    nucleo_del_curso,
                    prerequisitos_del_curso):

    lista_vecinos_con_similitud = ObtenerVecinosMasSimilares(
        id_estudiante_objetivo, cursos_aprobados_por_estudiante, CANTIDAD_VECINOS)

    lista_candidatos = ObtenerCursosCandidatos(
        id_estudiante_objetivo, cursos_aprobados_por_estudiante,
        lista_todos_los_cursos, prerequisitos_del_curso)

    lista_cursos_con_puntaje = []

    para cada id_curso_candidato en lista_candidatos:
        puntaje_curso = CalcularPuntajeCurso(
            id_estudiante_objetivo, id_curso_candidato,
            lista_vecinos_con_similitud, cursos_aprobados_por_estudiante,
            afinidad_por_nucleo, habilidad_por_nucleo, nucleo_del_curso)

        lista_cursos_con_puntaje.agregar( (id_curso_candidato, puntaje_curso) )

    ordenar lista_cursos_con_puntaje descendente por puntaje_curso
    return primeros CANTIDAD_RECOMENDACIONES elementos de lista_cursos_con_puntaje
```

## SECCION 7: MODO LINEAL (sin concurrencia, referencia de base)
Recorre todos los estudiantes de forma secuencial, uno tras otro.
Sirve como version de comparacion contra el modo concurrente:
mismo resultado, sin paralelismo.

```lua
FUNCION ModoLineal(lista_todos_los_estudiantes,
                    cursos_aprobados_por_estudiante,
                    lista_todos_los_cursos,
                    afinidad_por_nucleo,
                    habilidad_por_nucleo,
                    nucleo_del_curso,
                    prerequisitos_del_curso):

    resultados = []

    para cada id_estudiante_objetivo en lista_todos_los_estudiantes:
        recomendaciones_del_estudiante = Recomendar(
            id_estudiante_objetivo, cursos_aprobados_por_estudiante,
            lista_todos_los_cursos, afinidad_por_nucleo,
            habilidad_por_nucleo, nucleo_del_curso, prerequisitos_del_curso)

        resultados.agregar( (id_estudiante_objetivo, recomendaciones_del_estudiante) )

    return resultados
```

## SECCION 8: MODO CONCURRENTE (productor / workers / recolector)
La misma logica de Recomendar() se reparte entre varios workers que
trabajan en paralelo, coordinados mediante un canal de trabajo
pendiente y un canal de resultados. Un productor alimenta el canal
de trabajo, y un recolector espera a que todos los workers terminen
(equivalente a un WaitGroup).

```lua
FUNCION Productor(lista_todos_los_estudiantes, canal_estudiantes_pendientes):
    para cada id_estudiante_objetivo en lista_todos_los_estudiantes:
        canal_estudiantes_pendientes <- id_estudiante_objetivo
    canal_estudiantes_pendientes <- CENTINELA_FIN   -- avisa que no hay mas trabajo


FUNCION WorkerRecomendador(canal_estudiantes_pendientes,
                            canal_resultados,
                            cursos_aprobados_por_estudiante,
                            lista_todos_los_cursos,
                            afinidad_por_nucleo,
                            habilidad_por_nucleo,
                            nucleo_del_curso,
                            prerequisitos_del_curso,
                            grupo_de_espera):

    mientras verdadero:
        id_estudiante_objetivo = <- canal_estudiantes_pendientes

        si id_estudiante_objetivo == CENTINELA_FIN:
            canal_estudiantes_pendientes <- CENTINELA_FIN   -- reenvio para otros workers
            salir del bucle

        recomendaciones_del_estudiante = Recomendar(
            id_estudiante_objetivo, cursos_aprobados_por_estudiante,
            lista_todos_los_cursos, afinidad_por_nucleo,
            habilidad_por_nucleo, nucleo_del_curso, prerequisitos_del_curso)

        canal_resultados <- (id_estudiante_objetivo, recomendaciones_del_estudiante)

    grupo_de_espera.Done()   -- avisa al recolector que este worker termino


FUNCION Recolector(canal_resultados, grupo_de_espera, cantidad_workers):
    resultados = []

    grupo_de_espera.Wait()   -- espera a que todos los workers terminen

    mientras canal_resultados tenga elementos pendientes:
        (id_estudiante_objetivo, recomendaciones_del_estudiante) = <- canal_resultados
        resultados.agregar( (id_estudiante_objetivo, recomendaciones_del_estudiante) )

    return resultados


FUNCION ModoConcurrente(lista_todos_los_estudiantes,
                         cursos_aprobados_por_estudiante,
                         lista_todos_los_cursos,
                         afinidad_por_nucleo,
                         habilidad_por_nucleo,
                         nucleo_del_curso,
                         prerequisitos_del_curso,
                         cantidad_workers):

    canal_estudiantes_pendientes = crear_canal()
    canal_resultados             = crear_canal()
    grupo_de_espera               = crear_grupo_de_espera()

    lanzar_proceso Productor(lista_todos_los_estudiantes, canal_estudiantes_pendientes)

    para cada indice_worker en 0 .. cantidad_workers - 1:
        grupo_de_espera.Add(1)
        lanzar_proceso WorkerRecomendador(
            canal_estudiantes_pendientes, canal_resultados,
            cursos_aprobados_por_estudiante, lista_todos_los_cursos,
            afinidad_por_nucleo, habilidad_por_nucleo, nucleo_del_curso,
            prerequisitos_del_curso, grupo_de_espera)

    return Recolector(canal_resultados, grupo_de_espera, cantidad_workers)
```
