## Informe de análisis de GAPs

**Modelo de IA utilizado:** Claude Code (Claude Sonnet 4.5)
**Fecha del análisis:** 2026-10-09
**Alcance:** repositorio completo — paquetes `shared/`, `sequential/`, `concurrent/`, `benchmark/`, CLI `main.go` y modelo Promela.

### 1. Prompt estructurado utilizado

```text
Actúa como revisor senior de Go y de sistemas concurrentes. Analiza el
repositorio completo del proyecto "Sistema de Recomendación Distribuido y
Concurrente" (curso CC65, UPC) y reporta GAPs en cuatro categorías:
(1) calidad de código, (2) seguridad, (3) patrones de concurrencia y
(4) rendimiento, mantenibilidad y testing. Para cada hallazgo indica:
archivo/línea, descripción breve, severidad (alta/media/baja) y
recomendación concreta. Al final, prioriza los hallazgos que deben
corregirse primero y da una conclusión sobre la madurez del código.
Considera como invariantes del proyecto: (a) el modo secuencial y el
concurrente deben producir salida idéntica byte a byte; (b) el Dataset
es inmutable tras la carga; (c) solo se permite la librería estándar de Go.
```

### 2. Resumen ejecutivo

Se identificaron **16 GAPs**: 3 de severidad alta, 7 medias y 6 bajas. El más importante es una **divergencia entre la documentación y el código**: el README declara "similitud coseno" como métrica del filtrado colaborativo, pero la implementación real usa **similitud de Jaccard** sobre los bitmasks de cursos aprobados (`shared/jaccard.go`). El código Go está **maduro** en lo concurrente (sin carreras detectables, salida determinista verificada por tests), pero la documentación arrastra inconsistencias y hay puntos de robustez en el loader y en el generador de gráficos.

### 3. GAPs por categoría

#### 3.1 Calidad de código

| # | Archivo / línea | Hallazgo | Severidad | Recomendación |
|---|---|---|---|---|
| C1 | `README.md` (Objetivos específicos) | Declara "similitud coseno en filtrado colaborativo" pero `shared/jaccard.go` implementa **Jaccard** sobre bitmasks. | **Alta** | Corregir el README para decir "similitud de Jaccard sobre bitmasks de cursos aprobados" o justificar la divergencia respecto a la PC1. |
| C4 | `shared/loader.go` (`readCSV`) | Si el CSV tiene **columnas duplicadas** en el header, `pos[i]` queda apuntando a la **última** coincidencia sin avisar (el `for` interno no hace `break`). | Baja | Romper el bucle al encontrar la columna (`break`) o error explícito si hay duplicados. |
| C5 | `shared/loader.go` (`parseUnit`) | Acepta `NaN` e `Inf` silenciosamente: `strconv.ParseFloat("NaN", 64)` no falla y pasa la comparación `v < 0 \|\| v > 1`. | **Alta** | Añadir `if math.IsNaN(v) \|\| math.IsInf(v, 0) { return 0, fmt.Errorf(...) }` antes de la comprobación de rango. |
| C6 | `shared/loader.go` (`loadInteractions`) | `d.NumInteractions++` ocurre **antes** de validar el campo `aprobado`; si el valor es inválido, el contador ya se incrementó (aunque el error descarta el `Dataset` al final). | Baja | Mover el incremento después del `switch` o contar solo filas válidas. |
| C7 | `benchmark/charts.go` | Índices `c.lines[0]`, `c.lines[1]` y `byName["canal"]` **sin comprobación de longitud**; si cambia el número de series, el benchmark hace `panic` (index out of range). | Media | Validar `len(c.lines) >= 2` y `len(byName["canal"]) > 0` antes de graficar, o derivar las series del `slice` en lugar de por nombre fijo. |

#### 3.2 Seguridad

| # | Archivo / línea | Hallazgo | Severidad | Recomendación |
|---|---|---|---|---|
| S1 | `shared/loader.go` (`parseUnit`) | Ya listado en C5: valores `NaN`/`Inf` entran al `Dataset` y se propagan a `Score` y `Jaccard`, donde las comparaciones devuelven siempre `false` y rompen silenciosamente el orden top-k. | **Alta** | Validar `NaN`/`Inf` en el loader (defensa en profundidad). Añadir un test que verifique que un CSV con `NaN` se rechaza. |
| S2 | `src/main.go` / `src/benchmark/main.go` | No hay **cota superior** al flag `-workers`; un valor absurdo (p. ej. `-workers 100000`) crea 100 000 goroutines y puede agotar memoria del sistema. | Media | Rechazar `workers` por encima de, digamos, `4 * runtime.NumCPU()` con un mensaje claro. |
| S3 | `shared/output.go` (`WriteCSV`) | Escribe en cualquier ruta recibida sin canonicalizar; si el CSV de salida apunta a una ruta con `..` se sobrescribe silenciosamente un archivo existente. | Baja | Documentar el comportamiento en el `-h` del CLI. Si se quisiera endurecer: abrir con `os.O_CREATE\|os.O_EXCL` para no sobrescribir por accidente. |
| S4 | `benchmark/main.go` | Escribe el reporte **al final** de 10+ repeticiones; si la ruta de salida no es escribible, se pierde todo el cómputo. | Baja | Hacer un "dry run" de escritura (`os.MkdirAll` + `os.Create` de un archivo temporal) antes de arrancar el benchmark. |

#### 3.3 Patrones de concurrencia

| # | Archivo / línea | Hallazgo | Severidad | Recomendación |
|---|---|---|---|---|
| P1 | `concurrent/concurrent.go` (`Run`, `RunPrealloc`) | El productor **no está cubierto por el `WaitGroup`**: se lanza en una goroutine anónima y, si un worker entrara en `panic`, el productor quedaría bloqueado en `pending <-` (leak). | Media | `wg.Add(1)` también para el productor y `defer wg.Done()`; además, envolver cada worker con `defer func(){ recover() ... }()` si se quiere resiliencia. |
| P2 | `concurrent/concurrent.go` | El canal `pending` es **sin buffer**: cada ID que pasa de productor a worker implica un context switch. Con 25 000 estudiantes × 8 workers es medible. | Media | `make(chan shared.ID, workers*64)` o similar; medir con el benchmark antes/después. |
| P3 | `concurrent/concurrent.go` | No hay `context.Context` ni forma de cancelar; si el dataset crece, no se puede abortar desde fuera. | Baja | Añadir variante `RunContext(ctx, d, workers)` con `select { case <-ctx.Done(): return }` en productor y workers. |
| P4 | `concurrent/concurrent.go` (`RunPrealloc`) | La seguridad depende de que cada worker escriba en **índices disjuntos**; el comentario lo dice, pero si alguien cambia `results[s] = ...` por `append`, aparece una carrera silenciosa. | Media | Añadir test con `-race` que verifique explícitamente el caso (ya lo cubre `TestEquivalenceWithSequential` con `raceEnabled`) y un comentario `// IMPORTANTE:` en el sitio de la escritura. |
| P5 | `concurrent/concurrent_test.go` (`BenchmarkRun`) | Solo mide con `runtime.NumCPU()`; no barre distintos `workers` en el benchmark de Go, así que la curva de speedup solo queda en el reporte de `benchmark/main.go`. | Baja | Añadir sub-benchmarks `-workers=1,2,4,8` para poder comparar con `benchstat`. |
| P6 | `benchmark/main.go` | `runtime.GC()` antes de cada corrida **no garantiza** que el GC no corra durante la medición; el primer `i` del benchmark suele salir más lento. | Baja | Descartar el primer resultado o anotarlo en `discusion.md`; considerar `debug.SetGCPercent(-1)` durante la ventana medida y restaurar después. |

#### 3.4 Rendimiento, mantenibilidad y testing

| # | Archivo / línea | Hallazgo | Severidad | Recomendación |
|---|---|---|---|---|
| R1 | `shared/neighbors.go` (`TopNeighbors`) | La complejidad es **O(N²·C)** sobre los 25 000 estudiantes (todos contra todos), sin nota en el código. Es correcto para el dataset actual, pero limita la escalabilidad horizontal. | Media | Documentar la complejidad y, si se quiere escalar, considerar LSH (MinHash sobre bitmasks) o precomputar vecinos por núcleo. |
| R2 | `shared/recommend.go` (`Score`) | El divisor es **siempre `NumNeighbors`**, incluso si hay menos vecinos; con `N < K` (dataset chico) el colaborativo queda subestimado y las recomendaciones se sesgan hacia afinidad/habilidad. | Media | Documentar como decisión de diseño explícita (el comentario actual es breve) o normalizar por `len(neighbors)` cuando sea menor a K. |
| R3 | `.github/workflows/` | **No hay CI**. `go test ./...`, `go vet` y `go test -race` dependen de que alguien los corra a mano; el `-race` requiere `gcc` y suele olvidarse en Windows. | Media | Añadir un workflow mínimo que corra `go build ./... && go vet ./... && go test ./...` en cada push a `develop`. |
| R4 | `shared/output.go` | No hay **golden file** para el CSV de salida; `TestWriteCSVAndSort` valida un caso de 3 estudiantes, pero un cambio de formato (p. ej. más decimales) pasaría inadvertido. | Baja | Añadir `testdata/expected_output.csv` con los primeros 100 estudiantes del dataset real. |
| R5 | `benchmark/charts.go` | Sin tests: un cambio en la lógica de layout puede romper el SVG sin que nada falle. | Baja | Test que genere el SVG en memoria y verifique que contiene las cadenas esperadas (`<svg`, `<polyline`, nombres de series). |
| R6 | `benchmark/main.go` (`report`) | Si `discusion.md` no existe, **se salta en silencio** (`if _, err := os.ReadFile(...); err == nil`). Fácil olvidar añadirlo al repo y no darse cuenta. | Baja | Imprimir en `stderr` "discusion.md no encontrado, se omite" para que se vea en el log del benchmark. |
| R7 | `docs/` | El informe de PC1 (`CC65-PC1-202620.pdf`) es la única referencia bibliográfica; no hay `CITATION.cff` ni `docs/REFERENCIAS.md`. | Baja | Añadir `docs/REFERENCIAS.md` con la bibliografía en texto plano para facilitar citas desde otros documentos. |

### 4. Priorización

Orden sugerido de corrección:

1. **C1 / S1 (Altas)** — Corregir el README ("coseno" → "Jaccard") y endurecer `parseUnit` contra `NaN`/`Inf`. Son baratas y evitan reclamos en la sustentación. Añadir test de regresión.
2. **C7 (Media)** — Validar `len(c.lines)` y `byName["canal"]` en `charts.go`. Un `panic` en plena generación del reporte es visible y molesto.
3. **R1 / R2 (Media)** — Documentar complejidad O(N²) y la decisión de dividir siempre por `NumNeighbors`. Son observaciones que un jurado puede hacer; tenerlas escritas las convierte en decisiones de diseño defendibles.
4. **P1 / P2 (Media)** — `WaitGroup` también para el productor y buffer en `pending`. Bajo riesgo, mejora medible en el benchmark.
5. **R3 (Media)** — CI mínimo. En la recta final sirve para no subir código que no compila.
6. **C4 / C5 / C6 / S2 / S3 / S4 / P3–P6 / R4–R7 (Bajas)** — Buenas para una siguiente iteración o para dejar anotadas como "trabajo futuro".

### 5. Conclusión

El código Go está **maduro para el alcance del curso**: la arquitectura es limpia (todo lo reutilizable en `shared`, los modos secuencial y concurrente como cáscaras delgadas), el `Dataset` es inmutable tras la carga, la salida es determinista byte a byte y hay cobertura razonable de tests unitarios e integración, incluyendo `-race`. Las **tres severidades altas** son de bajo costo: una es documental (C1) y dos son la misma validación faltante en el loader (C5 = S1). Las medias son mayormente **de robustez y de documentación**, no de corrección. Con las 3 altas y las 4 medias de mayor retorno (C7, R1, R2, P1) resueltas, el proyecto queda sin hallazgos relevantes para sustentación; el resto son mejoras deseables que pueden quedar listadas como trabajo futuro sin afectar la entrega del TP.
