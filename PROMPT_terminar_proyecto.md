# PROMPT: Terminar la implementación en Go — "Microcursos Adaptativos"

## 0. Rol y forma de trabajar

Eres un ingeniero senior en **Go y concurrencia**. Ayúdame a terminar la **implementación en Go** de un sistema de recomendación de microcursos (UPC, *Programación Concurrente y Distribuida*). El dataset, el pseudocódigo y la verificación en Promela/Spin **ya están hechos**: **ignora Promela por completo** (no lo modifiques, no lo menciones en el código).

Reglas:

1. **Primero lee el repo** (`psudocode/algorithm.md`, `src/go.mod`, `src/main.go`, `src/shared/*`, y las cabeceras de los CSV en `dataset/data/`). Responde con un resumen breve de lo que entendiste y tus dudas. Si algo es ambiguo, **pregunta**; no inventes.
2. **`psudocode/algorithm.md` es la fuente de verdad del algoritmo**, con **una única excepción deliberada**: la aritmética. El pseudocódigo usa enteros 0–100 porque se escribió pensando en Promela; **en Go usamos `float`** (más preciso). Ver 3.2.
3. Trabaja **por fases** (sección 6) y detente al final de cada una con instrucciones para verificarla.
4. **No hagas `git commit`, no crees ramas, no toques `main`.** Solo sugiere nombres de rama `feature/...` y mensajes `tipo: descripción en imperativo`. Divide el trabajo en tareas que puedan repartirse entre 3 personas.
5. Código y comentarios en **español**. Cuando digas que algo funciona, **ejecútalo** (`go run`, `go test`) y muestra la salida; si no puedes ejecutarlo, dilo.

---

## 1. Contexto

Para cada estudiante se recomiendan los cursos que **no ha aprobado**, cuyos **prerrequisitos ya cumple**, ordenados por puntaje. Se devuelven las **3** mejores.

```
puntaje = 0.25 * afinidad(núcleo del curso)
        + 0.25 * habilidad(núcleo del curso)
        + 0.50 * (vecinos que aprobaron el curso / K)

similitud entre estudiantes = Jaccard sobre cursos aprobados
vecinos = los K=5 estudiantes más similares (distintos del objetivo)
```

Constantes actuales (`src/shared/constants.go`): `NUM_NEIGHBORS=5`, `NUM_RECOMMENDATIONS=3`, pesos `0.25 / 0.25 / 0.50`.

### Dataset (sintético, en `dataset/data/`)
- **25,000** estudiantes, **180** cursos (**60 por núcleo**), 3 núcleos (`0=Matematica, 1=Lectura, 2=Ciencias`), 197 aristas de prerrequisito, **1,200,000** interacciones.
- Cabeceras:
  - `cursos.csv`: `course_id,nucleo,nivel,titulo,duracion_min`
  - `dag_prerequisitos.csv`: `prerequisito_id,course_id,nucleo`
  - `estudiantes.csv`: `student_id,grado,afinidad_matematica,afinidad_lectura,afinidad_ciencias,habilidad_matematica,habilidad_lectura,habilidad_ciencias` (floats en [0,1])
  - `interacciones.csv`: `interaction_id,student_id,course_id,nucleo,nivel_curso,intento,nota,aprobado,tiempo_dedicado_min,dispositivo,timestamp`
- IDs son strings: `STU_000000`, `MAT_0000`, `LEC_0080`, `CIE_0132`. Los `course_id` parecen **globales** (0–179), no por núcleo.
- Un estudiante **aprobó** un curso si existe **al menos una** fila con `aprobado=1` para ese `(student_id, course_id)`, sin importar el intento.

### Código existente (`src/shared`)
`bitmask.go` (`BoolToBitmask`), `constants.go`, `core.go` (`Core{Affinity, Skill float32; Completed uint64}`), `id.go` (`type ID int`), `jaccard.go` (`Jaccard(a, b []uint64) (float32, error)`, suma sobre las palabras), `student.go` (`Student{ID, Math, Reading, Science Core}` + `NextID` global).

---

## 2. Arquitectura objetivo

```
src/
├── go.mod
├── main.go            # CLI mínimo: elige sequential o concurrent con flags
├── shared/            # TODO lo común: carga de datos + lógica del algoritmo
├── sequential/        # SOLO lo que es distinto: el bucle secuencial
└── concurrent/        # SOLO lo que es distinto: productor / workers / recolector
```

### 2.1 `shared/` — carga de datos **y** funciones compartidas
Aquí vive **todo** lo que no depende de la estrategia de ejecución:

1. **Carga de datos (lo que hoy falta):** código que lee los 4 CSV con `encoding/csv` (sin dependencias externas) y los convierte a las estructuras en memoria que usa el algoritmo (Sección 1 del pseudocódigo):
   - Mapeo `string → índice denso` **determinista** (orden de aparición en `estudiantes.csv` y `cursos.csv`) y tabla inversa para imprimir.
   - Bitmask de cursos aprobados por estudiante (ver 3.1).
   - Afinidad y habilidad por estudiante y núcleo (floats tal cual vienen del CSV).
   - Núcleo de cada curso y **prerrequisitos de cada curso (máx. 2)**.
   - Lectura eficiente de `interacciones.csv` (1.2M filas): `csv.Reader` con `ReuseRecord`, sin `ReadAll`, sin parsear columnas innecesarias.
   - Validaciones con error claro: IDs inexistentes, **>2 prerrequisitos** en algún curso, **cada núcleo con exactamente 60 cursos**, prerrequisitos del mismo núcleo que su curso (o, si no, soporte para el cruce), y DAG **acíclico**.
2. **Estructura inmutable `Dataset`** (o similar) con todo lo anterior. Tras cargar, **nadie la modifica** durante la recomendación → no necesita locks.
3. **Funciones del algoritmo compartidas** (idénticas en ambos modos): vecinos más similares (Sección 3), candidatos y `CumplePrerequisitos` (Sección 4), puntaje (Sección 5) y **`Recomendar(idEstudiante) []Recomendacion`** (Sección 6).
4. **Tipos de resultado** y escritura de `recomendaciones.csv` (`student_id,rec1,rec2,rec3,score1,score2,score3`), **ordenado por estudiante** para poder comparar salidas.

### 2.2 `sequential/` — solo la diferencia
Únicamente `ModoLineal`: recorre los estudiantes en orden y llama a `shared.Recomendar`. Debe ser **muy corto**.

### 2.3 `concurrent/` — solo la diferencia
Únicamente el patrón **productor / workers / recolector** (Sección 8 del pseudocódigo) que llama a la **misma** `shared.Recomendar`. Nada del algoritmo se duplica aquí.

### 2.4 `main.go` — CLI pequeño
Con el paquete `flag` de la librería estándar:

| Flag | Significado |
|---|---|
| `-sequential` | corre el modo secuencial |
| `-concurrent` | corre el modo concurrente |
| `-workers N` | nº de workers (default `runtime.NumCPU()`) |
| `-data ruta` | carpeta de los CSV (default `../dataset/data`) |
| `-out archivo` | CSV de salida (opcional) |

Comportamiento: carga los datos **una vez**, ejecuta el/los modo(s) pedido(s) y **imprime el tiempo de cada uno** (medido solo sobre la fase de recomendación, no sobre la carga). Si se pasan **ambos** flags, corre los dos, **verifica que los resultados son idénticos** e imprime el speedup. Si no se pasa ninguno, muestra el uso y sale con código ≠ 0. Mantén `main.go` corto (< ~100 líneas).

---

## 3. Decisiones de diseño

### 3.1 Bitmask por núcleo (se mantiene el diseño actual)
180 cursos / 3 núcleos = **60 cursos por núcleo**, así que **un `uint64` por núcleo** alcanza (60 bits) y `Core.Completed` es correcto. `Jaccard([]uint64, []uint64)` sumando `common` y `total` sobre las 3 palabras equivale al Jaccard sobre un bitmask global de 180 bits.
- Define el **índice local (0..59)** de cada curso dentro de su núcleo. No uses el `course_id` global como número de bit sin comprobar cómo están numerados (p. ej. `LEC_0080` → local 20 si Lectura empieza en 60).
- Si todos los prerrequisitos son del mismo núcleo, `CumplePrerequisitos` solo necesita la palabra de ese núcleo.
- `BoolToBitmask` conserva su guarda de ≥64; adáptalo para validar `≤ 60`.

### 3.2 Aritmética: **float en Go** (decisión del equipo)
El pseudocódigo usa enteros 0–100 solo por compatibilidad con Promela, que no tiene floats. **En Go se usa `float`** (el código actual ya usa `float32`; decide entre `float32` y `float64` y justifícalo brevemente, pero sé consistente en todo el proyecto).
- Afinidad y habilidad se usan **tal cual** del CSV en [0,1] (sin multiplicar por 100 ni redondear).
- `Jaccard` devuelve `float` en [0,1] (`common / total`); si `total == 0`, devuelve 0.
- Puntaje: `0.25*afinidad + 0.25*habilidad + 0.50*(aprobaron/K)`.
- **Importante:** los dos modos deben dar **exactamente** el mismo resultado. Para eso, **ambos usan las mismas funciones de `shared`** y las operaciones en punto flotante se hacen siempre en el mismo orden. No sumes puntajes en paralelo con reducciones que cambien el orden. Documenta esta decisión en un comentario.
- Actualiza `constants.go` (constantes tipadas si hace falta) y `Jaccard`/`Core`/`Student` para que sean coherentes.

### 3.3 Desempates (obligatorio)
Con floats y bitmasks habrá empates (por ejemplo, estudiantes sin cursos aprobados tienen Jaccard 0 con todos). Si el orden de empate depende del orden de llegada, secuencial y concurrente discreparán. **Regla única, en `shared`:** mayor valor primero y, en empate, **menor índice primero**, tanto para vecinos como para cursos recomendados.

### 3.4 Top-K en vez de ordenar todo
El pseudocódigo ordena toda la lista de similitudes por estudiante (25,000 × O(N log N)). Está permitido usar **selección top-K** (arreglo de tamaño K con inserción, o heap) **siempre que el resultado sea idéntico** (incluido el desempate de 3.3). Documenta la decisión.

---

## 4. Correcciones al pseudocódigo al pasarlo a Go

1. **Recolector sin deadlock.** El pseudocódigo hace `Wait()` y *después* drena el canal de resultados; con un canal sin buffer los workers se bloquean y nunca hacen `Done()`. En Go: `go func(){ wg.Wait(); close(resultados) }()` y el recolector hace `for r := range resultados`.
2. **Fin del trabajo con `close`, no con centinela.** El productor hace `close(pendientes)` al terminar y los workers usan `for id := range pendientes`. No hace falta reenviar `CENTINELA_FIN`.
3. **Más de 2 prerrequisitos:** el pseudocódigo sobrescribiría el 2.º en silencio. El cargador debe **fallar** con un error claro.
4. **Casos borde que deben tener test:** estudiante sin cursos aprobados; estudiante con menos de 3 candidatos (devolver las que haya); curso aprobado en el intento 2+; K ≥ N−1.
5. **El resultado final se ordena por estudiante** antes de compararlo o escribirlo (el recolector recibe en orden no determinista).

---

## 5. Requisitos técnicos

- Go según `go.mod` **[TODO: versión]**. Solo librería estándar.
- Los datos son de solo lectura durante la recomendación: **no pongas mutex donde no hay estado mutable compartido** (solo lo haría más lento).
- Implementa el pool de workers con canales + `WaitGroup` (como en el pseudocódigo). Como **variante opcional** para comparar, workers que escriben en `resultados[idEstudiante]` (slice pre-asignado, sin canal de resultados) y di cuál es más rápido.
- `go build ./... && go vet ./... && go test -race ./...` deben pasar limpios.
- **Tests:**
  - Unitarios de `shared` con casos pequeños hechos a mano (Jaccard, `CumplePrerequisitos`, puntaje, desempate, top-K).
  - Test de **equivalencia**: `sequential` == `concurrent` sobre el dataset real y con distintos nº de workers (1, 2, 4, `NumCPU`).
  - Tests del cargador (con CSV mínimos de ejemplo en `testdata/`).
- Estructuras en slices planos (`[]` indexados por índice denso) en lugar de `map` en el camino caliente; el orden de iteración de `map` no debe afectar el resultado.

### Módulo opcional: progreso concurrente
El README promete "sincronización no bloqueante o bloqueo de grano fino para lecturas masivas y actualizaciones seguras del progreso". El algoritmo solo lee. **Si hay tiempo**, añade en `shared` (o un paquete aparte) una función para **marcar un curso aprobado mientras otras goroutines recomiendan**, usando una sola técnica (`sync.RWMutex` por estudiante, `atomic` con CAS sobre la palabra del núcleo, o copy-on-write con `atomic.Pointer`), justificada y con un test bajo `-race`. Debe quedar **fuera del camino de medición**. Si no cabe, déjalo documentado como trabajo futuro.

---

## 6. Plan por fases (detente al final de cada una)

- **Fase 0 — Lectura y preguntas.** Resumen, inconsistencias que veas, respuestas a mis TODO, y propuesta final de nombres de paquetes/archivos.
- **Fase 1 — `shared`: tipos y carga de datos.** Refactor de `Core/Student/ID`, eliminar `NextID` global, floats coherentes, cargador con todas las validaciones, tests del cargador. `go run` que imprima un resumen del dataset cargado (nº estudiantes, cursos, aristas, aprobados totales, tiempo de carga).
- **Fase 2 — `shared`: algoritmo.** Jaccard, vecinos (top-K), candidatos, puntaje, `Recomendar`, desempates, escritura de CSV. Tests unitarios.
- **Fase 3 — `sequential` + `main.go`.** `-sequential` funcionando de punta a punta, con tiempo.
- **Fase 4 — `concurrent`.** Worker pool, `-concurrent` y `-workers`, test de equivalencia, `-race` limpio.
- **Fase 5 — Comparación y speedup.** `-sequential -concurrent` juntos verifican igualdad e imprimen speedup. Script o test de benchmark que genere `benchmarks/resultados_speedup.md`: **speedup = T_sec / T_conc** y **eficiencia = speedup / workers** para `1, 2, 4, 8, …, NumCPU`, mínimo **10 repeticiones** + 1 de calentamiento, con **mediana, media, desviación estándar, mín y máx**, y el hardware **[TODO]** documentado. Incluye una breve discusión (Amdahl, granularidad de 1 tarea = 1 estudiante, memoria/caché).
- **Fase 6 — Documentación.** Actualiza el README (estructura real, "Cómo ejecutar" con los flags, estado de entregas) y propón un `.gitignore` (binarios Go, salidas, etc.).

---

## 7. Criterios de aceptación

- [ ] `go build ./... && go vet ./... && go test -race ./...` pasan.
- [ ] `go run . -sequential` y `go run . -concurrent` funcionan y muestran su tiempo.
- [ ] `go run . -sequential -concurrent` confirma resultados idénticos e imprime speedup.
- [ ] La salida es idéntica byte a byte (ordenada por estudiante) entre ambos modos, para varios nº de workers.
- [ ] `sequential/` y `concurrent/` **no duplican** lógica del algoritmo; todo lo común está en `shared/`.
- [ ] Resultados reproducibles (sin dependencia del orden de `map` ni del scheduler).
- [ ] Benchmark reproducible con estadísticas y hardware documentado.
- [ ] El pseudocódigo no se modifica sin mi aprobación.
- [ ] La IA no hizo ningún commit.

## 8. No hagas

- No toques el dataset, el notebook ni nada de Promela.
- No uses `time.Sleep` ni trabajo artificial para mejorar el speedup.
- No pongas locks sobre datos de solo lectura.
- No duplicar el algoritmo en `sequential` y `concurrent`.
- No reportes un speedup de una sola corrida.
- No afirmes que algo funciona si no lo ejecutaste.

## 9. Datos que debo completar antes de enviarte este prompt

- Versión de Go: **[TODO]**
- Hardware (CPU / núcleos / RAM / SO): **[TODO]**
- Fecha de entrega de PC2 / TP: **[TODO]**
- Reparto entre Ivan, Camila y Wilber: **[TODO]**
