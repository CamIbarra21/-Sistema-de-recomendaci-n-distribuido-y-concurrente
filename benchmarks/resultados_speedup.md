# Resultados de speedup

Generado con `go run ./benchmark` el 2026-10-09 17:11.

## Entorno

- Hardware: AMD Ryzen 7 7435HS (8 núcleos / 16 hilos), 23.7 GB RAM, Windows 11 Pro
- Go: go1.27.1 (windows/amd64), `runtime.NumCPU()` = 16
- Datos: 25000 estudiantes, 180 cursos, K=5 vecinos, 3 recomendaciones
- Método: 1 corrida de calentamiento + 10 repeticiones por configuración, intercaladas. El tiempo mide solo la fase de recomendación (sin la carga de CSV); incluye ordenar los resultados. Antes de medir se verificó que todas las configuraciones dan resultados idénticos al secuencial.
- **speedup = T_sec / T_conc** y **eficiencia = speedup / workers**, ambos con la **mediana**. `f` es la fracción serial estimada con la métrica de Karp-Flatt: f = (1/S − 1/p) / (1 − 1/p).

## Gráficos

![Speedup](speedup.svg)

![Eficiencia](eficiencia.svg)

## Secuencial

| mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) |
|---|---|---|---|---|
| 7.548 | 7.154 | 1.250 | 4.058 | 8.380 |

## Concurrente: productor / workers / recolector (canal de resultados)

| workers | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |
|---|---|---|---|---|---|---|---|---|
| 1 | 8.070 | 7.260 | 1.762 | 4.177 | 8.894 | 0.94x | 0.94 | — |
| 2 | 4.664 | 4.195 | 0.893 | 2.824 | 4.902 | 1.62x | 0.81 | 0.236 |
| 4 | 2.552 | 2.270 | 0.505 | 1.505 | 2.637 | 2.96x | 0.74 | 0.118 |
| 8 | 1.371 | 1.221 | 0.265 | 0.830 | 1.420 | 5.50x | 0.69 | 0.065 |
| 16 | 0.795 | 0.745 | 0.132 | 0.549 | 0.891 | 9.50x | 0.59 | 0.046 |

## Concurrente: variante con slice pre-asignado (sin canal de resultados)

| workers | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |
|---|---|---|---|---|---|---|---|---|
| 1 | 8.024 | 7.295 | 1.696 | 4.703 | 8.845 | 0.94x | 0.94 | — |
| 2 | 4.708 | 4.219 | 0.834 | 2.823 | 4.822 | 1.60x | 0.80 | 0.247 |
| 4 | 2.535 | 2.226 | 0.620 | 0.984 | 2.682 | 2.98x | 0.74 | 0.115 |
| 8 | 1.372 | 1.243 | 0.245 | 0.831 | 1.430 | 5.50x | 0.69 | 0.065 |
| 16 | 0.810 | 0.786 | 0.131 | 0.502 | 0.949 | 9.32x | 0.58 | 0.048 |

## Discusión

**Variabilidad de las medidas.** En un laptop la frecuencia de la CPU cambia con la temperatura y el plan de energía, así que la desviación estándar es alta y a veces hay dos "regímenes" de velocidad (mínimo y máximo muy separados). Por eso se reporta la **mediana** y se intercalan las repeticiones entre configuraciones. Para resultados más estables conviene correr con el equipo conectado a la corriente, en plan de máximo rendimiento y sin otras aplicaciones abiertas. Un speedup menor que 1 con 1 worker (si aparece) no indica que "un worker sea más lento por diseño", sino ruido más el costo fijo del canal; el secuencial y el concurrente con 1 worker hacen el mismo trabajo.

**Ley de Amdahl.** El speedup máximo con `p` workers es `1 / (f + (1-f)/p)`, donde `f` es la fracción serial. Aquí la parte serial es pequeña: el productor que reparte IDs por el canal, el recolector que ordena los 25,000 resultados y la creación de goroutines. Casi todo el tiempo está en `Recommend`, que es independiente por estudiante. La columna `f` (Karp-Flatt) mide cuánto de la pérdida de eficiencia se explica por esa parte serial; si `f` baja al aumentar los workers, la pérdida no se debe a una porción serial fija sino a otros factores (contención de memoria, hilos lógicos, ruido de medición).

**Granularidad (1 tarea = 1 estudiante).** Cada tarea recorre ~25,000 estudiantes para calcular Jaccard, es decir, cientos de microsegundos de cómputo, mucho más que el costo de pasar un ID por un canal (cientos de nanosegundos). El balanceo de carga es automático: cada worker toma el siguiente estudiante cuando termina, y las tareas son parecidas entre sí, por lo que no hay un worker que se quede con trabajo desproporcionado. Con tareas mucho más pequeñas el canal sería el cuello de botella.

**Hilos físicos frente a lógicos.** La CPU tiene 8 núcleos físicos y 16 hilos (SMT). Pasar de 8 a 16 workers comparte unidades de ejecución y caché entre dos hilos de un mismo núcleo, así que no se duplica el rendimiento: la eficiencia (`speedup / workers`) cae con 16 workers aunque el tiempo siga bajando.

**Memoria y caché.** Cada `Recommend` recorre linealmente los bitmasks de todos los estudiantes (25,000 × 3 palabras de 64 bits = 600 KB), que cabe en la caché L2/L3 y se comparte en solo lectura entre workers. Al no haber escrituras compartidas ni mutex, no hay invalidación de líneas de caché entre núcleos. El límite pasa a ser el ancho de banda de caché/memoria cuando muchos hilos recorren los mismos datos a la vez.

**Canal de resultados frente a slice pre-asignado.** La variante con slice pre-asignado evita el canal de resultados y la ordenación final, pero a 25,000 resultados ese costo es despreciable frente al cómputo. Las diferencias entre ambas variantes quedan dentro del ruido de la medición, así que ninguna es claramente más rápida; se prefiere la versión con canal porque sigue el patrón productor / workers / recolector del pseudocódigo.
