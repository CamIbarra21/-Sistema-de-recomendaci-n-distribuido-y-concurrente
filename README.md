# Microcursos Adaptativos — Recomendación Concurrente por Grafos de Competencias

**Curso:** Programación Concurrente y Distribuida (1ACC0065) — NRC 8800

**Trabajo Parcial 2026-20** · Universidad Peruana de Ciencias Aplicadas (UPC)

**Docente:** Montalvo García, Peter Jonathan

## Equipo

| Integrante | Código |
|---|---|
| Almeida Aguilar, Ivan Antonio | u20231b49 |
| Ibarra Cabrera, Camila Adriana | u202317287 |
| Toledo Mamani, Wilber Franz | u202320608 |

## Descripción del proyecto

Este proyecto propone una plataforma de aprendizaje adaptativo basada en la atomización curricular y el aprendizaje guiado por rutas de interés. El sistema estructura el conocimiento en microcursos organizados en tres núcleos fundamentales (razonamiento cuantitativo, comprensión lectora y pensamiento crítico) y modela las dependencias entre ellos como un **grafo acíclico dirigido (DAG) de competencias**.

Sobre esta base se implementa un **sistema de recomendación distribuido y concurrente** que, mediante filtrado colaborativo y procesamiento en paralelo del grafo de competencias, analiza el desempeño, las preferencias y las trayectorias de estudiantes afines para sugerir dinámicamente nuevos módulos formativos, evitando recomendaciones repetitivas o poco personalizadas.

**ODS al que contribuye:** ODS 4 — Educación de calidad.

## Objetivo general

Diseñar e implementar un sistema distribuido y concurrente de recomendación de microcursos adaptativos, capaz de procesar en tiempo real el historial académico, el rendimiento y las preferencias de múltiples usuarios concurrentes, garantizando alta disponibilidad, baja latencia y escalabilidad horizontal.

## Objetivos específicos

- Revisar el estado del arte sobre modelado de dependencias curriculares mediante DAG y su aplicación en sistemas de recomendación educativa concurrentes.
- Seleccionar y depurar un dataset de interacciones estudiante-curso con más de 1,000,000 de registros.
- Diseñar la estructura del grafo de competencias con mecanismos de control de concurrencia (sincronización no bloqueante o bloqueo de grano fino) para lecturas masivas y actualizaciones seguras del progreso de los estudiantes.
- Implementar y optimizar de forma concurrente el algoritmo de recomendación (similitud coseno en filtrado colaborativo) mediante goroutines organizadas en patrones como Worker Pools o Pipelines.

## Stack técnico

| Componente | Tecnología |
|---|---|
| Generación y limpieza del dataset | Python (pandas, NumPy) — Jupyter/Colab |
| Modelado de sincronización | Promela (verificado con Spin) |
| Implementación secuencial y concurrente | Go — goroutines, `sync.Mutex`, `sync.WaitGroup` |
| Control de versiones | Git / GitHub — flujo GitFlow |

## Estructura del repositorio

```
.
├── docs/
│   ├── CC65-PC1-202620.pdf        # Informe PC1: investigación, caso de uso, dataset
│   ├── CC65-PC2-202620.pdf        # Informe PC2 (Semana 5)
│   └── CC65-TP-202620.pdf         # Informe final (Semana 7)
├── dataset/
│   ├── notebook_generacion.ipynb  # Generación y depuración del dataset sintético
│   └── data/                      # Datasets generados (microcursos, DAG, estudiantes, interacciones)
├── src/
│   ├── sequential/                # Implementación secuencial del algoritmo de recomendación (Go)
│   └── concurrent/                # Implementación concurrente (Go) — worker pools / pipelines
├── promela/
│   └── modelo.pml                 # Modelado y verificación formal en Promela/Spin
├── benchmarks/
│   └── resultados_speedup.md      # Tabla y estadísticas de Speedup (T-Secuencial / T-Concurrente)
└── README.md
```

> La estructura anterior es la propuesta inicial del equipo; se actualizará a medida que avance la implementación en PC2 y TP.

## Dataset

El dataset de interacciones estudiante-microcurso es **sintético**, generado con autorización del docente del curso, dado que no existe un dataset público que combine simultáneamente una estructura de DAG de prerrequisitos, más de 1,000,000 de registros y variables de afinidad/desempeño comparables al caso de uso propuesto.

- **25,000** estudiantes simulados
- **180** microcursos distribuidos en 3 núcleos y 6 niveles de profundidad
- **197** relaciones de prerrequisito (aristas del DAG), verificadas formalmente como acíclicas
- **1,200,000** interacciones estudiante-microcurso, depuradas en 6 pasos (duplicados, integridad referencial, rangos válidos, tipos consistentes, orden cronológico, verificación de volumen)

El detalle completo del procedimiento está documentado en `docs/CC65-PC1-202620.pdf` y en el notebook `dataset/notebook_generacion.ipynb`.

## Flujo de trabajo — GitFlow

Este repositorio sigue el modelo **GitFlow**:

- **`main`** — versión estable, lista para entrega. Solo recibe merges desde `develop` en cada hito (PC1, PC2, TP).
- **`develop`** — rama de integración activa del equipo.
- **`feature/<nombre-corto>`** — una rama por tarea o funcionalidad (ej. `feature/generacion-dataset`, `feature/algoritmo-knn-secuencial`, `feature/worker-pool-concurrente`). Se crea desde `develop` y se fusiona de vuelta a `develop` vía Pull Request.
- **`release/<version>`** — opcional, para preparar una entrega antes de fusionar a `main`.

### Convención de commits

```
tipo: descripción breve en imperativo

Ejemplos:
feat: agregar generación del catálogo de microcursos
fix: corregir validación de rangos en depuración del dataset
docs: actualizar README con estructura del repositorio
refactor: extraer función de verificación de DAG
```

Tipos sugeridos: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.

### Reglas del equipo

1. Ningún integrante hace commit directo a `main`. Todo cambio pasa por una rama `feature/*` y un Pull Request revisado por al menos otro integrante.
2. Cada Pull Request debe tener una descripción breve de qué resuelve y, si aplica, referenciar el objetivo específico o entregable al que corresponde.
3. El historial de commits debe evidenciar la participación de los tres integrantes (requisito explícito de la rúbrica del curso).
4. No se debe editar el repositorio después de la fecha de entrega de cada hito (PC1, PC2, TP) — se penaliza si se detecta.

## Cómo ejecutar

### Generación del dataset

```bash
# Abrir dataset/notebook_generacion.ipynb en Jupyter o Google Colab
# Ejecutar todas las celdas en orden; genera microcursos.csv, dag.csv,
# estudiantes.csv e interacciones.csv en dataset/data/
```

### Implementación en Go (se agregará en PC2)

```bash
cd src/sequential && go run main.go
cd src/concurrent && go run main.go
```

## Estado de las entregas

| Entregable | Semana | Estado |
|---|---|---|
| PC1 — Investigación, caso de uso, dataset | 3 | ✅ Entregado |
| PC2 — Modelado Promela, implementación Go, speedup | 5 | ⏳ En desarrollo |
| TP — Verificación Spin, informe con IA, sustentación | 7 | ⏳ Pendiente |

## Referencias

Ver la bibliografía completa en `docs/CC65-PC1-202620.pdf`.

## Licencia

Proyecto académico desarrollado para el curso CC65 — Programación Concurrente y Distribuida, UPC. Uso educativo.