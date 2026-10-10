# Resultados de speedup

Generado con `go run ./benchmark` el 2026-10-09 22:44.

## Entorno

- Hardware: AMD Ryzen 7 7435HS (8 núcleos / 16 hilos), 23.7 GB RAM, Windows 11 Pro
- Go: go1.27.1 (windows/amd64), `runtime.NumCPU()` = 16
- Datos: 25000 estudiantes, 180 cursos, K=5 vecinos, 3 recomendaciones
- Método: 1 corrida de calentamiento + 10 repeticiones por configuración, intercaladas. El tiempo mide solo la fase de recomendación (sin la carga de CSV); incluye ordenar los resultados. Antes de medir se verificó que todas las configuraciones dan resultados idénticos al secuencial.
- **Media recortada:** se descarta el 10% de las mediciones en cada extremo (la más rápida y la más lenta de 10) y se promedia el resto.
- **speedup = T_sec / T_conc** y **eficiencia = speedup / workers**, ambos con la **media recortada**. `f` es la fracción serial estimada con la métrica de Karp-Flatt: f = (1/S − 1/p) / (1 − 1/p).

## Gráficos

![Tiempos](tiempos.svg)

![Speedup](speedup.svg)

![Eficiencia](eficiencia.svg)

## Secuencial

| media recortada (s) | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) |
|---|---|---|---|---|---|
| 4.575 | 4.010 | 4.717 | 1.506 | 3.540 | 7.035 |

## Concurrente: productor / workers / recolector (canal de resultados)

| workers | media recortada (s) | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 4.711 | 4.140 | 4.924 | 1.723 | 3.552 | 7.992 | 0.97x | 0.97 | — |
| 2 | 2.524 | 2.583 | 2.655 | 0.831 | 1.819 | 4.543 | 1.81x | 0.91 | 0.103 |
| 4 | 1.306 | 1.484 | 1.396 | 0.489 | 0.940 | 2.569 | 3.50x | 0.88 | 0.047 |
| 8 | 0.757 | 0.822 | 0.806 | 0.243 | 0.588 | 1.416 | 6.04x | 0.76 | 0.046 |
| 16 | 0.552 | 0.521 | 0.576 | 0.127 | 0.504 | 0.841 | 8.29x | 0.52 | 0.062 |

## Concurrente: variante con slice pre-asignado (sin canal de resultados)

| workers | media recortada (s) | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 4.377 | 4.153 | 4.703 | 1.738 | 3.567 | 8.448 | 1.05x | 1.05 | — |
| 2 | 2.629 | 2.696 | 2.755 | 1.063 | 1.825 | 4.691 | 1.74x | 0.87 | 0.149 |
| 4 | 1.438 | 1.514 | 1.502 | 0.620 | 0.945 | 2.565 | 3.18x | 0.80 | 0.086 |
| 8 | 0.830 | 0.821 | 0.864 | 0.306 | 0.584 | 1.419 | 5.51x | 0.69 | 0.065 |
| 16 | 0.560 | 0.521 | 0.579 | 0.113 | 0.501 | 0.810 | 8.17x | 0.51 | 0.064 |

## Uso de recursos de cómputo

Medido en cada repetición (media recortada). **Núcleos usados** = tiempo de CPU del proceso / tiempo real: indica cuántos núcleos estuvieron ocupados en promedio. **Asignado** son los MiB reservados por el programa durante la corrida (incluye los resultados) y **memoria del SO** es lo que el proceso le pidió al sistema operativo (`runtime.MemStats.Sys`). **Ganancia marginal** es cuánto sube el speedup por cada worker añadido respecto a la configuración anterior de la misma variante.

| modo | workers | tiempo (s) | CPU (s) | núcleos usados | asignado (MiB) | ciclos GC | memoria del SO (MiB) | ganancia marginal |
|---|---|---|---|---|---|---|---|---|
| secuencial | 1 | 4.575 | 4.541 | 0.99 | 21.0 | 2.0 | 33 | — |
| canal | 1 | 4.711 | 5.014 | 1.06 | 21.0 | 2.0 | 33 | — |
| canal | 2 | 2.524 | 5.268 | 2.09 | 21.0 | 2.2 | 33 | 0.84 |
| canal | 4 | 1.306 | 5.395 | 4.13 | 21.0 | 2.5 | 33 | 0.84 |
| canal | 8 | 0.757 | 6.162 | 8.14 | 21.0 | 2.9 | 33 | 0.64 |
| canal | 16 | 0.552 | 7.766 | 14.07 | 21.0 | 3.0 | 33 | 0.28 |
| prealloc | 1 | 4.377 | 4.682 | 1.07 | 21.0 | 2.0 | 33 | — |
| prealloc | 2 | 2.629 | 5.496 | 2.09 | 21.0 | 2.1 | 33 | 0.69 |
| prealloc | 4 | 1.438 | 5.926 | 4.12 | 21.0 | 2.4 | 33 | 0.72 |
| prealloc | 8 | 0.830 | 6.715 | 8.09 | 21.0 | 2.6 | 33 | 0.58 |
| prealloc | 16 | 0.560 | 8.186 | 14.61 | 21.0 | 3.0 | 33 | 0.33 |

**Punto de equilibrio.** Se define como la mayor cantidad de workers cuya eficiencia sigue siendo al menos 0.50 (más allá, más de la mitad de la capacidad añadida se pierde). En esta ejecución, con el canal de resultados, es **16 workers** (eficiencia 0.52, ganancia marginal 0.28 por worker añadido). Si la eficiencia está cerca de 0.50 o la ganancia marginal es baja, agregar más workers rinde poco: el límite lo ponen los núcleos físicos.

## Discusión

**Variabilidad de las medidas.** En un laptop la frecuencia de la CPU cambia con la temperatura y el plan de energía, así que entre corridas completas el tiempo absoluto puede variar bastante (el secuencial ha tardado entre 4 s y 8 s en corridas distintas). Por eso se reporta la **media recortada** (se descartan la repetición más rápida y la más lenta), se intercalan las repeticiones entre configuraciones y se muestra la desviación estándar y el rango mín-máx. Para comparar valores hay que usar siempre tablas y gráficos de **la misma corrida**. Para resultados más estables conviene correr con el equipo conectado a la corriente, en plan de máximo rendimiento y sin otras aplicaciones abiertas. Un speedup menor que 1 con 1 worker indica el costo fijo del canal y de las goroutines frente al bucle secuencial; ambos hacen el mismo trabajo.

**Ley de Amdahl.** El speedup máximo con `p` workers es `1 / (f + (1-f)/p)`, donde `f` es la fracción serial. Aquí la parte serial es pequeña: el productor que reparte IDs por el canal, el recolector que ordena los 25,000 resultados y la creación de goroutines. Casi todo el tiempo está en `Recommend`, que es independiente por estudiante. La columna `f` (Karp-Flatt) mide cuánto de la pérdida de eficiencia se explica por esa parte serial; si `f` baja al aumentar los workers, la pérdida no se debe a una porción serial fija sino a otros factores (hilos lógicos, contención de memoria, ruido de medición).

**Granularidad (1 tarea = 1 estudiante).** Cada tarea recorre ~25,000 estudiantes para calcular Jaccard, es decir, cientos de microsegundos de cómputo, mucho más que el costo de pasar un ID por un canal (cientos de nanosegundos). El balanceo de carga es automático: cada worker toma el siguiente estudiante cuando termina, y las tareas son parecidas entre sí, por lo que no hay un worker que se quede con trabajo desproporcionado. Con tareas mucho más pequeñas el canal sería el cuello de botella.

**Uso de CPU.** La columna "núcleos usados" (tiempo de CPU / tiempo real) crece casi linealmente hasta 8 workers (la CPU tiene 8 núcleos físicos): cada worker mantiene un núcleo ocupado, así que la paralelización es efectiva. Con 16 workers (hilos lógicos / SMT) los núcleos usados suben menos que los workers y, además, el **tiempo total de CPU aumenta** respecto al secuencial: el mismo trabajo consume más segundos de CPU porque dos hilos comparten las unidades de ejecución y la caché de un mismo núcleo físico. Por eso la eficiencia cae aunque el tiempo real siga bajando.

**Memoria.** El consumo de memoria es prácticamente **constante** con cualquier cantidad de workers: el `Dataset` es de solo lectura y se comparte entre todos, y cada worker solo asigna listas pequeñas (vecinos y recomendaciones). Los MiB asignados y los ciclos de GC casi no cambian entre modos; el paralelismo no tiene un costo de memoria apreciable. La memoria no es el factor limitante: lo es el cómputo.

**Punto de equilibrio.** Se define como la mayor cantidad de workers cuya eficiencia sigue siendo al menos 0.50. Pasado ese punto, más de la mitad de la capacidad que se añade se pierde y la ganancia marginal por worker cae (ver tabla de recursos). Usar más workers que núcleos físicos todavía reduce el tiempo, pero a un costo de CPU creciente.

**Memoria y caché.** Cada `Recommend` recorre linealmente los bitmasks de todos los estudiantes (25,000 × 3 palabras de 64 bits = 600 KB), que cabe en la caché L2/L3 y se comparte en solo lectura entre workers. Al no haber escrituras compartidas ni mutex, no hay invalidación de líneas de caché entre núcleos. El límite pasa a ser el ancho de banda de caché cuando muchos hilos recorren los mismos datos a la vez.

**Canal de resultados frente a slice pre-asignado.** La variante con slice pre-asignado evita el canal de resultados y la ordenación final, pero a 25,000 resultados ese costo es despreciable frente al cómputo. Las diferencias entre ambas variantes quedan dentro del ruido de la medición, así que ninguna es claramente más rápida; se prefiere la versión con canal porque sigue el patrón productor / workers / recolector del pseudocódigo.

**Sobre los mecanismos de sincronización.** El camino de recomendación **no usa `sync.Mutex`**, a propósito: los datos son de solo lectura, y poner un lock sobre ellos solo añadiría contención. La sincronización necesaria la dan los canales (reparto y recolección) y el `sync.WaitGroup` (cierre del canal de resultados). El `sync.RWMutex` se usa donde sí hay estado mutable compartido: el módulo de progreso concurrente (`shared.LiveDataset`), que está fuera del camino medido y se verifica con `go test -race` y con el modelo `promela/src/progreso.pml`.
