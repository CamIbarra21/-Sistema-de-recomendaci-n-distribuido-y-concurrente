# Verificación formal con Spin

Dos modelos Promela, verificados con Spin 6.5.2.

| Archivo | Qué modela |
|---|---|
| `src/main.pml` | El modo concurrente: **productor / workers / recolector** con canales y espera tipo `WaitGroup` (`concurrent.Run`). Caso pequeño: 3 estudiantes, 4 cursos, 2 workers. |
| `src/progreso.pml` | La **exclusión mutua del progreso** de un estudiante con un `RWMutex` (`shared.LiveDataset`): 2 escritores (`MarkApproved`) y 2 lectores (`Snapshot`) a la vez. |

## Cómo verificar

```bash
cd promela
./verificar.sh              # todo, con 2 workers: ~30 segundos
./verificar.sh --3workers   # además main.pml con 3 workers: ~5 minutos y mucha memoria
```

El script usa `spin` y `gcc` si están instalados; si no, usa Docker con la imagen `spin-verif`
(se construye sola a partir de `promela/Dockerfile`). Compila en un directorio temporal, así que no
genera archivos `pan.*` en el repositorio.

Comandos a mano (equivalentes), dentro de `promela/src`:

```bash
spin -a main.pml
gcc -O2 -DNOCLAIM -o pan_s pan.c && ./pan_s          # deadlock + aserciones
gcc -O2 -o pan pan.c
./pan -a -f -N todos_los_workers_terminan            # vivacidad (equidad débil)
./pan -a -N exclusion_mutua_resultados               # seguridad
./pan -a -N resultados_completos                     # seguridad
```

> **Por qué `-DNOCLAIM`:** cuando el archivo contiene fórmulas `ltl`, Spin desactiva por defecto la
> revisión de *estados finales inválidos* (que es la que detecta los deadlocks). Para comprobar
> deadlock hay que compilar sin la cláusula; las propiedades LTL se comprueban en otra corrida con `-N nombre`.

## Qué se verifica

### `main.pml` (productor / workers / recolector)
| Propiedad | Tipo | Resultado |
|---|---|---|
| Ausencia de deadlock (sin estados finales inválidos) | seguridad | cumple (`errors: 0`) |
| Cada estudiante lo procesa **un solo worker, una sola vez** (`procesado[e] == 1`) | aserción | cumple |
| Cada resultado llega **una sola vez** al recolector (`recibido[e] == 1`) | aserción | cumple |
| Al terminar llegaron los 3 resultados (`resultados_recibidos == 3`) | aserción | cumple |
| `exclusion_mutua_resultados`: nunca dos workers sobre el mismo estudiante ni resultado duplicado | LTL seguridad | cumple |
| `resultados_completos`: si el recolector terminó, no se perdió ningún resultado | LTL seguridad | cumple |
| `todos_los_workers_terminan`: si el productor terminó, todos los workers terminan | LTL vivacidad (`-f`) | cumple |

Con 2 workers: unos 2.0 millones de estados. Con 3 workers también `errors: 0` (160 millones de estados).

### `progreso.pml` (RWMutex)
| Propiedad | Resultado esperado | Resultado |
|---|---|---|
| Sin deadlock + aserciones (exclusión escritor/escritor y escritor/lector, lecturas consistentes, ninguna actualización perdida) | cumple | cumple (3,313 estados) |
| `exclusion_mutua` (LTL) | cumple | cumple |
| `sin_actualizaciones_perdidas` (LTL) | cumple | cumple |
| `lectores_son_exclusivos` (LTL de **control**) | **falla**: un `RWMutex` permite lectores simultáneos | falla, como se esperaba |
| **Sin lock** (`-DSIN_LOCK`, control negativo) | **falla** | falla: violación de exclusión mutua en 74 estados |

El control negativo demuestra que las aserciones sí detectan el problema cuando falta el lock.

## Hallazgo: deadlock en el modelo original (corregido)

El modelo que teníamos de la PC2 **tenía un deadlock** que la verificación anterior no detectaba.
Al recibir el centinela, el worker ponía `trabajo_terminado = true`, pero el `do` solo tenía la opción
`!trabajo_terminado`, así que no quedaba ninguna opción habilitada: el worker se bloqueaba para siempre,
nunca avisaba que terminó y el recolector esperaba eternamente. Spin lo muestra como *invalid end state*
con los dos workers detenidos en `main.pml:234` y el recolector en el bucle de `init`.

Corrección (una línea, no cambia el algoritmo): agregar la salida `:: trabajo_terminado -> break` al `do`.
Si se quita esa línea, `verificar.sh` vuelve a reportar el deadlock. No se detectaba antes porque la
verificación se corría con la fórmula LTL activa, y con ella Spin no revisa estados finales inválidos.

## Otros cambios al modelo (no tocan el cálculo de recomendaciones)

- Aserciones y variables de seguridad: `procesado[]`, `recibido[]`, `resultados_recibidos`, comprobación final en `init`.
- Dos propiedades LTL nuevas (`exclusion_mutua_resultados`, `resultados_completos`).
- `CANTIDAD_WORKERS` configurable con `-DCANTIDAD_WORKERS=N`; los workers se lanzan con un `for`.
- Los pasos A, B y C del worker (vecinos, candidatos y puntaje) están dentro de un `atomic`: solo tocan
  variables locales y datos de solo lectura, por lo que sus pasos internos no aportan entrelazados relevantes.
  Esto bajó el espacio de estados de 32 millones a 2 millones sin cambiar los resultados.
- Instrucciones de verificación corregidas (el comentario citaba un archivo que no existe, y la LTL se
  ejecutaba sin elegir la fórmula con `-N`).

## Limitaciones

- Son **modelos reducidos** (3 estudiantes, 4 cursos, 2 núcleos): verifican el diseño de sincronización,
  no los 25,000 estudiantes reales. Spin explora todos los entrelazados, pero solo de esa instancia
  (más la de 3 workers). El resultado se generaliza por la estructura simétrica del patrón, no por prueba formal para cualquier N.
- La aritmética es entera (0-100), como en el pseudocódigo. El Go usa `float64`; el modelo no verifica el
  redondeo, solo la concurrencia.
- `RWMutex` se modela con sus garantías de exclusión (no con su política de prioridad de escritores de Go).
- El modelo de `main.pml` es el patrón con centinela del pseudocódigo; el Go usa `close(canal)`. Son
  equivalentes en la terminación, pero no es una traducción literal línea por línea.
- Los archivos `pan.*` y `bin/pan` que había versionados corresponden a una versión anterior del modelo
  y a Linux; ya no se generan en el repositorio.
