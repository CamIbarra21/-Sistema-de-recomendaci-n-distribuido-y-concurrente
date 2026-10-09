# Resultados de speedup

Generado con `go run ./benchmark` el 2026-10-09 16:45.

## Entorno

- Hardware: AMD Ryzen 7 7435HS (8 núcleos / 16 hilos), 23.7 GB RAM, Windows 11 Pro
- Go: go1.27.1 (windows/amd64), `runtime.NumCPU()` = 16
- Datos: 25000 estudiantes, 180 cursos, K=5 vecinos, 3 recomendaciones
- Método: 1 corrida de calentamiento + 10 repeticiones por configuración, intercaladas. El tiempo mide solo la fase de recomendación (sin la carga de CSV); incluye ordenar los resultados. Antes de medir se verificó que todas las configuraciones dan resultados idénticos al secuencial.
- **speedup = T_sec / T_conc** y **eficiencia = speedup / workers**, ambos con la **mediana**. `f` es la fracción serial estimada con la métrica de Karp-Flatt: f = (1/S − 1/p) / (1 − 1/p).

## Secuencial

| mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) |
|---|---|---|---|---|
| 7.327 | 7.070 | 1.018 | 4.232 | 7.801 |

## Concurrente: productor / workers / recolector (canal de resultados)

| workers | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |
|---|---|---|---|---|---|---|---|---|
| 1 | 7.972 | 7.704 | 1.098 | 4.911 | 8.631 | 0.92x | 0.92 | — |
| 2 | 4.668 | 4.479 | 0.587 | 2.838 | 4.802 | 1.57x | 0.78 | 0.274 |
| 4 | 2.547 | 2.427 | 0.352 | 1.521 | 2.662 | 2.88x | 0.72 | 0.130 |
| 8 | 1.396 | 1.250 | 0.282 | 0.639 | 1.435 | 5.25x | 0.66 | 0.075 |
| 16 | 0.801 | 0.776 | 0.087 | 0.548 | 0.857 | 9.15x | 0.57 | 0.050 |

## Concurrente: variante con slice pre-asignado (sin canal de resultados)

| workers | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |
|---|---|---|---|---|---|---|---|---|
| 1 | 7.994 | 7.719 | 1.433 | 3.843 | 8.907 | 0.92x | 0.92 | — |
| 2 | 4.791 | 4.626 | 0.528 | 3.139 | 4.932 | 1.53x | 0.76 | 0.308 |
| 4 | 2.629 | 2.531 | 0.320 | 1.635 | 2.698 | 2.79x | 0.70 | 0.145 |
| 8 | 1.399 | 1.337 | 0.177 | 0.854 | 1.438 | 5.24x | 0.65 | 0.075 |
| 16 | 0.792 | 0.788 | 0.094 | 0.552 | 0.900 | 9.25x | 0.58 | 0.049 |

## Discusión

**Variabilidad de las medidas.** En un laptop la frecuencia de la CPU cambia con la temperatura y el plan de energía, así que la desviación estándar es alta y a veces hay dos "regímenes" de velocidad (mínimo y máximo muy separados). Por eso se reporta la **mediana** y se intercalan las repeticiones entre configuraciones. Para resultados más estables conviene correr con el equipo conectado a la corriente, en plan de máximo rendimiento y sin otras aplicaciones abiertas. Un speedup menor que 1 con 1 worker (si aparece) no indica que "un worker sea más lento por diseño", sino ruido más el costo fijo del canal; el secuencial y el concurrente con 1 worker hacen el mismo trabajo.

**Ley de Amdahl.** El speedup máximo con `p` workers es `1 / (f + (1-f)/p)`, donde `f` es la fracción serial. Aquí la parte serial es pequeña: el productor que reparte IDs por el canal, el recolector que ordena los 25,000 resultados y la creación de goroutines. Casi todo el tiempo está en `Recommend`, que es independiente por estudiante. La columna `f` (Karp-Flatt) mide cuánto de la pérdida de eficiencia se explica por esa parte serial; si `f` baja al aumentar los workers, la pérdida no se debe a una porción serial fija sino a otros factores (contención de memoria, hilos lógicos, ruido de medición).

**Granularidad (1 tarea = 1 estudiante).** Cada tarea recorre ~25,000 estudiantes para calcular Jaccard, es decir, cientos de microsegundos de cómputo, mucho más que el costo de pasar un ID por un canal (cientos de nanosegundos). El balanceo de carga es automático: cada worker toma el siguiente estudiante cuando termina, y las tareas son parecidas entre sí, por lo que no hay un worker que se quede con trabajo desproporcionado. Con tareas mucho más pequeñas el canal sería el cuello de botella.

**Hilos físicos frente a lógicos.** La CPU tiene 8 núcleos físicos y 16 hilos (SMT). Pasar de 8 a 16 workers comparte unidades de ejecución y caché entre dos hilos de un mismo núcleo, así que no se duplica el rendimiento: la eficiencia (`speedup / workers`) cae con 16 workers aunque el tiempo siga bajando.

**Memoria y caché.** Cada `Recommend` recorre linealmente los bitmasks de todos los estudiantes (25,000 × 3 palabras de 64 bits = 600 KB), que cabe en la caché L2/L3 y se comparte en solo lectura entre workers. Al no haber escrituras compartidas ni mutex, no hay invalidación de líneas de caché entre núcleos. El límite pasa a ser el ancho de banda de caché/memoria cuando muchos hilos recorren los mismos datos a la vez.

**Canal de resultados frente a slice pre-asignado.** La variante con slice pre-asignado evita el canal de resultados y la ordenación final, pero a 25,000 resultados ese costo es despreciable frente al cómputo. Las diferencias entre ambas variantes quedan dentro del ruido de la medición, así que ninguna es claramente más rápida; se prefiere la versión con canal porque sigue el patrón productor / workers / recolector del pseudocódigo.
