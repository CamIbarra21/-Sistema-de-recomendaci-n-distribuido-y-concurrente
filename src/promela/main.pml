/*
 * ============================================================================
 *  MODELO PROMELA: Sistema de Recomendación de Microcursos (Modo Concurrente)
 *  Version con 3 componentes de puntaje: afinidad (25%) + habilidad (25%)
 *  + filtrado colaborativo (50%)
 * ============================================================================
 *
 *  Este modelo traduce directamente el pseudocódigo de la documentación
 *  (secciones 3 a 6 y 8) a un caso pequeño y simulado, pensado para
 *  verificar con SPIN que el diseño concurrente (productor, workers,
 *  recolector) no tiene deadlocks ni pierde mensajes.
 *
 *  No se recalculan datos reales de los CSV: los valores de afinidad,
 *  habilidad, aprobados y prerrequisitos están precalculados a mano en
 *  el bloque init, como un caso de prueba pequeño y legible.
 * ============================================================================
 */


/* ----------------------------------------------------------------------
 * SECCION 1: CONSTANTES DEL MODELO (caso pequeño y simulado)
 * ---------------------------------------------------------------------- */

#define CANTIDAD_ESTUDIANTES   3   // estudiantes simplificados para el modelo
#define CANTIDAD_CURSOS        4   // microcursos simplificados para el modelo
#define CANTIDAD_NUCLEOS       2   // 0 = Matematica, 1 = Lectura (simplificado a 2 para el ejemplo)
#define CANTIDAD_WORKERS       2   // workers recomendadores en paralelo
#define CANTIDAD_VECINOS       2   // vecinos considerados por estudiante
#define CANTIDAD_RECOMENDACIONES 2 // top-N de cursos a recomendar
#define VALOR_CENTINELA       255  // "no hay más estudiantes" / "sin prerequisito"
#define PESO_AFINIDAD          25  // 25%
#define PESO_HABILIDAD         25  // 25%
#define PESO_COLABORATIVO      50  // 50%


/* ----------------------------------------------------------------------
 * SECCION 2: ESTRUCTURAS DE DATOS GLOBALES (MATRICES APLANADAS)
 * ----------------------------------------------------------------------
 * Igual que en el modelo anterior: toda matriz de FILAS x COLUMNAS se
 * guarda como un array 1D de tamaño FILAS * COLUMNAS, y la celda
 * (fila, columna) vive en fila * COLUMNAS + columna.
 * ---------------------------------------------------------------------- */

// cursos_aprobados_por_estudiante[estudiante]: bitmask de cursos aprobados.
// El bit "c" está encendido si el estudiante aprobó el curso c.
byte cursos_aprobados_por_estudiante[CANTIDAD_ESTUDIANTES];

// afinidad_por_nucleo, aplanada: la posición (estudiante, nucleo) vive en
// el índice estudiante * CANTIDAD_NUCLEOS + nucleo. Valores 0-100.
byte afinidad_por_nucleo[CANTIDAD_ESTUDIANTES * CANTIDAD_NUCLEOS];

// habilidad_por_nucleo, aplanada de la misma forma. Valores 0-100.
byte habilidad_por_nucleo[CANTIDAD_ESTUDIANTES * CANTIDAD_NUCLEOS];

// nucleo_del_curso[curso]: a qué núcleo pertenece cada curso (0 o 1 aquí).
byte nucleo_del_curso[CANTIDAD_CURSOS];

// prerequisitos_del_curso, aplanada: hasta 2 prerrequisitos por curso.
// La posición (curso, 0) vive en curso * 2 + 0; (curso, 1) en curso * 2 + 1.
// VALOR_CENTINELA significa que no hay prerrequisito en esa posición.
byte prerequisitos_del_curso[CANTIDAD_CURSOS * 2];


/* ----------------------------------------------------------------------
 * SECCION 3: "FUNCIONES" DE INDEXADO Y CALCULO (inline)
 * ---------------------------------------------------------------------- */

// Escribe en "valor_obtenido" la afinidad del estudiante por el núcleo dado.
inline obtener_afinidad(id_estudiante, id_nucleo, valor_obtenido) {
    valor_obtenido = afinidad_por_nucleo[id_estudiante * CANTIDAD_NUCLEOS + id_nucleo];
}

// Escribe en "valor_obtenido" la habilidad del estudiante en el núcleo dado.
inline obtener_habilidad(id_estudiante, id_nucleo, valor_obtenido) {
    valor_obtenido = habilidad_por_nucleo[id_estudiante * CANTIDAD_NUCLEOS + id_nucleo];
}

// Escribe en "valor_obtenido" el prerrequisito en la posición 0 o 1 del curso.
inline obtener_prerequisito(id_curso, posicion, valor_obtenido) {
    valor_obtenido = prerequisitos_del_curso[id_curso * 2 + posicion];
}

// Escribe 1 en "resultado" si el bit "id_curso" está encendido en el bitmask,
// 0 en caso contrario. Se usa tanto para "aprobados" como para chequeos varios.
inline bit_esta_encendido(bitmask, id_curso, resultado) {
    resultado = (bitmask >> id_curso) & 1;
}

// Calcula la similitud de Jaccard (0-100) entre dos bitmasks de cursos
// aprobados, contando bits en comun (AND) sobre bits totales (OR).
// CANTIDAD_CURSOS es pequeña (4), así que se cuenta bit a bit con un for.
inline calcular_similitud_jaccard(bitmask_a, bitmask_b, similitud_obtenida) {
    byte interseccion;
    byte union_total;
    byte indice_bit;
    byte bit_a;
    byte bit_b;

    interseccion = 0;
    union_total = 0;

    for (indice_bit : 0 .. CANTIDAD_CURSOS - 1) {
        bit_esta_encendido(bitmask_a, indice_bit, bit_a);
        bit_esta_encendido(bitmask_b, indice_bit, bit_b);

        if
        :: (bit_a == 1 && bit_b == 1) -> interseccion++
        :: else -> skip
        fi

        if
        :: (bit_a == 1 || bit_b == 1) -> union_total++
        :: else -> skip
        fi
    }

    if
    :: union_total == 0 -> similitud_obtenida = 0
    :: else -> similitud_obtenida = (interseccion * 100) / union_total
    fi
}

// Verifica si el estudiante cumple los (hasta 2) prerrequisitos del curso.
// Escribe 1 en "cumple" si los cumple todos (o no tiene), 0 si falta alguno.
inline cumple_prerequisitos(id_estudiante, id_curso_candidato, cumple) {
    byte id_prerequisito_0;
    byte id_prerequisito_1;
    byte bit_prerequisito;

    obtener_prerequisito(id_curso_candidato, 0, id_prerequisito_0);
    obtener_prerequisito(id_curso_candidato, 1, id_prerequisito_1);

    cumple = 1; // se asume que sí, y se descarta si falta alguno

    if
    :: id_prerequisito_0 != VALOR_CENTINELA ->
        bit_esta_encendido(cursos_aprobados_por_estudiante[id_estudiante],
                            id_prerequisito_0, bit_prerequisito);
        if
        :: bit_prerequisito == 0 -> cumple = 0
        :: else -> skip
        fi
    :: else -> skip
    fi

    if
    :: id_prerequisito_1 != VALOR_CENTINELA ->
        bit_esta_encendido(cursos_aprobados_por_estudiante[id_estudiante],
                            id_prerequisito_1, bit_prerequisito);
        if
        :: bit_prerequisito == 0 -> cumple = 0
        :: else -> skip
        fi
    :: else -> skip
    fi
}


/* ----------------------------------------------------------------------
 * SECCION 4: CANALES DE COMUNICACION ENTRE PROCESOS
 * ---------------------------------------------------------------------- */

// El productor envía aquí los identificadores de estudiantes a procesar.
chan canal_estudiantes_pendientes = [CANTIDAD_ESTUDIANTES] of { byte };

// Cada worker envía aquí su recomendación calculada:
// (estudiante, curso_recomendado_1, curso_recomendado_2).
chan canal_recomendaciones_calculadas =
        [CANTIDAD_ESTUDIANTES] of { byte, byte, byte };

// Equivalente a un WaitGroup: cada worker, al terminar, avisa aquí con su propio id.
chan canal_aviso_worker_finalizado = [CANTIDAD_WORKERS] of { byte };


/* ----------------------------------------------------------------------
 * SECCION 5: VARIABLES DE ESTADO GLOBAL PARA VERIFICACION (LTL)
 * ---------------------------------------------------------------------- */

bool productor_termino_de_enviar = false;
byte cantidad_workers_finalizados = 0;


/* ----------------------------------------------------------------------
 * SECCION 6: PROCESO PRODUCTOR
 * ---------------------------------------------------------------------- */

proctype Productor() {
    byte indice_estudiante_actual;

    for (indice_estudiante_actual : 0 .. CANTIDAD_ESTUDIANTES - 1) {
        canal_estudiantes_pendientes ! indice_estudiante_actual;
        printf("Productor: enviado estudiante %d\n", indice_estudiante_actual);
    }

    canal_estudiantes_pendientes ! VALOR_CENTINELA;
    productor_termino_de_enviar = true;
}


/* ----------------------------------------------------------------------
 * SECCION 7: PROCESO WORKER RECOMENDADOR
 * ----------------------------------------------------------------------
 * Traduce ObtenerVecinosMasSimilares + ObtenerCursosCandidatos +
 * CalcularPuntajeCurso + top-N, todo dentro de un mismo worker, para
 * cada estudiante recibido del canal.
 * ---------------------------------------------------------------------- */

proctype WorkerRecomendador(byte identificador_worker) {
    byte id_estudiante_recibido;

    // --- variables para el top-CANTIDAD_VECINOS de vecinos mas similares ---
    byte id_vecino_actual;
    byte similitud_actual;
    byte mejor_vecino_1, mejor_similitud_1;
    byte mejor_vecino_2, mejor_similitud_2;

    // --- variables para recorrer cursos candidatos y su puntaje ---
    byte id_curso_candidato;
    byte bit_ya_aprobado;
    byte curso_cumple_prerequisitos;
    byte id_nucleo_del_curso;
    byte valor_afinidad, valor_habilidad;
    byte aporte_afinidad, aporte_habilidad, aporte_colaborativo;
    byte cantidad_vecinos_que_aprobaron;
    byte bit_vecino_aprobo;
    byte puntaje_curso;

    // --- variables para el top-CANTIDAD_RECOMENDACIONES de cursos ---
    byte mejor_curso_1, mejor_puntaje_1;
    byte mejor_curso_2, mejor_puntaje_2;

    bool trabajo_terminado = false;

    do
    :: !trabajo_terminado ->
        canal_estudiantes_pendientes ? id_estudiante_recibido;

        if
        :: id_estudiante_recibido == VALOR_CENTINELA ->
            canal_estudiantes_pendientes ! VALOR_CENTINELA; // relevo para otros workers
            trabajo_terminado = true;

        :: else ->
            /* ---- Paso A: ObtenerVecinosMasSimilares (top-2 de similitud) ---- */
            mejor_vecino_1 = VALOR_CENTINELA; mejor_similitud_1 = 0;
            mejor_vecino_2 = VALOR_CENTINELA; mejor_similitud_2 = 0;

            for (id_vecino_actual : 0 .. CANTIDAD_ESTUDIANTES - 1) {
                if
                :: id_vecino_actual != id_estudiante_recibido ->
                    calcular_similitud_jaccard(
                        cursos_aprobados_por_estudiante[id_estudiante_recibido],
                        cursos_aprobados_por_estudiante[id_vecino_actual],
                        similitud_actual);

                    if
                    :: similitud_actual > mejor_similitud_1 ->
                        mejor_similitud_2 = mejor_similitud_1; mejor_vecino_2 = mejor_vecino_1;
                        mejor_similitud_1 = similitud_actual;  mejor_vecino_1 = id_vecino_actual;
                    :: similitud_actual > mejor_similitud_2 ->
                        mejor_similitud_2 = similitud_actual;  mejor_vecino_2 = id_vecino_actual;
                    :: else -> skip
                    fi
                :: else -> skip
                fi
            }

            /* ---- Paso B + C: candidatos + puntaje, quedandonos con el top-2 ---- */
            mejor_curso_1 = VALOR_CENTINELA; mejor_puntaje_1 = 0;
            mejor_curso_2 = VALOR_CENTINELA; mejor_puntaje_2 = 0;

            for (id_curso_candidato : 0 .. CANTIDAD_CURSOS - 1) {
                bit_esta_encendido(cursos_aprobados_por_estudiante[id_estudiante_recibido],
                                    id_curso_candidato, bit_ya_aprobado);

                if
                :: bit_ya_aprobado == 1 -> skip // ya lo aprobo, no es candidato
                :: else ->
                    cumple_prerequisitos(id_estudiante_recibido, id_curso_candidato,
                                          curso_cumple_prerequisitos);
                    if
                    :: curso_cumple_prerequisitos == 1 ->
                        id_nucleo_del_curso = nucleo_del_curso[id_curso_candidato];

                        // --- Componente 1 (25%): afinidad ---
                        obtener_afinidad(id_estudiante_recibido, id_nucleo_del_curso,
                                          valor_afinidad);
                        aporte_afinidad = (valor_afinidad * PESO_AFINIDAD) / 100;

                        // --- Componente 2 (25%): habilidad ---
                        obtener_habilidad(id_estudiante_recibido, id_nucleo_del_curso,
                                           valor_habilidad);
                        aporte_habilidad = (valor_habilidad * PESO_HABILIDAD) / 100;

                        // --- Componente 3 (50%): colaborativo, sobre los 2 vecinos ---
                        cantidad_vecinos_que_aprobaron = 0;

                        if
                        :: mejor_vecino_1 != VALOR_CENTINELA ->
                            bit_esta_encendido(
                                cursos_aprobados_por_estudiante[mejor_vecino_1],
                                id_curso_candidato, bit_vecino_aprobo);
                            if
                            :: bit_vecino_aprobo == 1 -> cantidad_vecinos_que_aprobaron++
                            :: else -> skip
                            fi
                        :: else -> skip
                        fi

                        if
                        :: mejor_vecino_2 != VALOR_CENTINELA ->
                            bit_esta_encendido(
                                cursos_aprobados_por_estudiante[mejor_vecino_2],
                                id_curso_candidato, bit_vecino_aprobo);
                            if
                            :: bit_vecino_aprobo == 1 -> cantidad_vecinos_que_aprobaron++
                            :: else -> skip
                            fi
                        :: else -> skip
                        fi

                        aporte_colaborativo = (cantidad_vecinos_que_aprobaron * PESO_COLABORATIVO) / CANTIDAD_VECINOS;

                        // --- Puntaje final: suma de los tres componentes ---
                        puntaje_curso = aporte_afinidad + aporte_habilidad + aporte_colaborativo;

                        // --- Actualizar el top-2 de cursos recomendados ---
                        if
                        :: puntaje_curso > mejor_puntaje_1 ->
                            mejor_puntaje_2 = mejor_puntaje_1; mejor_curso_2 = mejor_curso_1;
                            mejor_puntaje_1 = puntaje_curso;   mejor_curso_1 = id_curso_candidato;
                        :: puntaje_curso > mejor_puntaje_2 ->
                            mejor_puntaje_2 = puntaje_curso;   mejor_curso_2 = id_curso_candidato;
                        :: else -> skip
                        fi
                    :: else -> skip // no cumple prerrequisitos, se descarta
                    fi
                fi
            }

            canal_recomendaciones_calculadas !
                id_estudiante_recibido, mejor_curso_1, mejor_curso_2;

            printf("Worker %d: estudiante %d -> cursos [%d, %d] (puntajes %d, %d)\n",
                   identificador_worker, id_estudiante_recibido,
                   mejor_curso_1, mejor_curso_2, mejor_puntaje_1, mejor_puntaje_2);
        fi
    od;

    canal_aviso_worker_finalizado ! identificador_worker;
    printf("Worker %d: terminado\n", identificador_worker);
}


/* ----------------------------------------------------------------------
 * SECCION 8: PROCESO PRINCIPAL (init) — INICIALIZACION Y RECOLECTOR
 * ---------------------------------------------------------------------- */

init {
    byte id_worker_que_aviso;
    byte estudiante_resultado;
    byte curso_uno_resultado;
    byte curso_dos_resultado;

    /* --- 8.1. Cursos aprobados por estudiante (bitmask, caso de ejemplo) ---
     * Núcleos usados en este caso pequeño: curso 0 y 1 = Matematica (nucleo 0),
     * curso 2 y 3 = Lectura (nucleo 1).
     *
     * Estudiante 0: aprobó cursos 0 y 1        -> bitmask 0011 = 3
     * Estudiante 1: aprobó cursos 0 y 2        -> bitmask 0101 = 5
     * Estudiante 2: aprobó cursos 0, 1 y 2     -> bitmask 0111 = 7
     */
    cursos_aprobados_por_estudiante[0] = 3;
    cursos_aprobados_por_estudiante[1] = 5;
    cursos_aprobados_por_estudiante[2] = 7;

    /* --- 8.2. Afinidad por núcleo (0-100), 2 núcleos: 0=Matematica, 1=Lectura --- */
    afinidad_por_nucleo[0 * CANTIDAD_NUCLEOS + 0] = 80; // estudiante 0, Matematica
    afinidad_por_nucleo[0 * CANTIDAD_NUCLEOS + 1] = 30; // estudiante 0, Lectura
    afinidad_por_nucleo[1 * CANTIDAD_NUCLEOS + 0] = 20;
    afinidad_por_nucleo[1 * CANTIDAD_NUCLEOS + 1] = 70;
    afinidad_por_nucleo[2 * CANTIDAD_NUCLEOS + 0] = 60;
    afinidad_por_nucleo[2 * CANTIDAD_NUCLEOS + 1] = 60;

    /* --- 8.3. Habilidad por núcleo (0-100) --- */
    habilidad_por_nucleo[0 * CANTIDAD_NUCLEOS + 0] = 70; // estudiante 0, Matematica
    habilidad_por_nucleo[0 * CANTIDAD_NUCLEOS + 1] = 40; // estudiante 0, Lectura
    habilidad_por_nucleo[1 * CANTIDAD_NUCLEOS + 0] = 35;
    habilidad_por_nucleo[1 * CANTIDAD_NUCLEOS + 1] = 85;
    habilidad_por_nucleo[2 * CANTIDAD_NUCLEOS + 0] = 55;
    habilidad_por_nucleo[2 * CANTIDAD_NUCLEOS + 1] = 50;

    /* --- 8.4. Núcleo de cada curso --- */
    nucleo_del_curso[0] = 0; // Matematica
    nucleo_del_curso[1] = 0; // Matematica
    nucleo_del_curso[2] = 1; // Lectura
    nucleo_del_curso[3] = 1; // Lectura

    /* --- 8.5. Prerrequisitos (hasta 2 por curso, VALOR_CENTINELA si falta) ---
     * Curso 0: sin prerrequisitos.
     * Curso 1: requiere el curso 0.
     * Curso 2: sin prerrequisitos.
     * Curso 3: requiere los cursos 1 y 2 (caso con 2 prerrequisitos reales).
     */
    prerequisitos_del_curso[0 * 2 + 0] = VALOR_CENTINELA;
    prerequisitos_del_curso[0 * 2 + 1] = VALOR_CENTINELA;

    prerequisitos_del_curso[1 * 2 + 0] = 0;
    prerequisitos_del_curso[1 * 2 + 1] = VALOR_CENTINELA;

    prerequisitos_del_curso[2 * 2 + 0] = VALOR_CENTINELA;
    prerequisitos_del_curso[2 * 2 + 1] = VALOR_CENTINELA;

    prerequisitos_del_curso[3 * 2 + 0] = 1;
    prerequisitos_del_curso[3 * 2 + 1] = 2;

    /* --- 8.6. Lanzamiento de procesos concurrentes --- */
    run Productor();
    run WorkerRecomendador(0);
    run WorkerRecomendador(1);

    /* --- 8.7. Recolección de resultados + espera tipo WaitGroup --- */
    do
    :: (cantidad_workers_finalizados < CANTIDAD_WORKERS) ||
       (len(canal_recomendaciones_calculadas) > 0) ->
        if
        :: canal_recomendaciones_calculadas ?
                estudiante_resultado, curso_uno_resultado, curso_dos_resultado ->
            printf("Recolector: estudiante %d recomendado con cursos %d y %d\n",
                   estudiante_resultado, curso_uno_resultado, curso_dos_resultado);

        :: canal_aviso_worker_finalizado ? id_worker_que_aviso ->
            cantidad_workers_finalizados++;
            printf("Recolector: worker %d finalizó (%d/%d)\n",
                   id_worker_que_aviso, cantidad_workers_finalizados, CANTIDAD_WORKERS);
        fi
    :: else -> break;
    od;

    printf("Sistema finalizado correctamente.\n");
}


/* ----------------------------------------------------------------------
 * SECCION 9: PROPIEDADES A VERIFICAR CON SPIN
 * ----------------------------------------------------------------------
 * 9.1. Ausencia de deadlock:
 *          spin -a sistema_recomendacion_v2.pml
 *          gcc -o pan pan.c
 *          ./pan
 *      "errors: 0" confirma que no hay deadlocks ni violaciones de
 *      aserción en ningún entrelazado explorado.
 *
 * 9.2. Propiedad LTL: si el productor terminó de enviar, eventualmente
 *      todos los workers finalizan.
 *          spin -a -N todos_los_workers_terminan sistema_recomendacion_v2.pml
 *          gcc -o pan pan.c
 *          ./pan -a
 * ---------------------------------------------------------------------- */

ltl todos_los_workers_terminan {
    [] (productor_termino_de_enviar ->
          <> (cantidad_workers_finalizados == CANTIDAD_WORKERS))
}
