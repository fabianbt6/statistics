# Materias

Cada materia es un curso completo independiente — su propio programa,
sus propias unidades semanales, sus propias tareas, y sus propios
cursos por universidad+cuatri. Lo único que se comparte entre materias
es lo que vive **fuera** de `materias/`: tu marca personal
(`_brand.yml`, `styles.scss`) y la plantilla de portada (`shared/portada.qmd`).

## Estructura de una materia

```
materias/<materia>/
├── content/
│   ├── blocks/
│   │   └── bibliografia.qmd   ← específica de esta materia
│   ├── semanas/
│   ├── tareas/
│   └── docs/
└── cursos/
    └── <universidad>/<periodo>/_variables.yml
```

## Materias disponibles

- **estadistica** — Teoría Estadística y Métodos Cuantitativos

## Agregar una materia nueva

```r
dir.create("materias/series-de-tiempo/content/blocks", recursive = TRUE)
dir.create("materias/series-de-tiempo/content/semanas", recursive = TRUE)
dir.create("materias/series-de-tiempo/content/tareas", recursive = TRUE)
dir.create("materias/series-de-tiempo/content/docs", recursive = TRUE)
```

Copia `materias/estadistica/content/blocks/bibliografia.qmd` como punto
de partida y cámbialo por los textos de la materia nueva. Copia también
una unidad existente (ej. `unidad-02-probabilidad.qmd`) como plantilla
de estructura — el patrón de bloques (`.divisor`, `.destacado`, etc.) y
`{{< include ../../../../shared/portada.qmd >}}` funcionan igual sin
cambios, porque son de tu marca personal, no de la materia.

Luego, en R:

```r
source("R/nuevo_curso.R")
nuevo_curso(materia = "series-de-tiempo", universidad = "UCR",
            anio = 2026, cuatri = 2, fecha_inicio = "2026-05-04")

source("R/render_curso.R")
render_curso(materia = "series-de-tiempo", universidad = "UCR", anio = 2026, cuatri = 2)
```

No hace falta tocar `_quarto.yml` — `materias/**` ya cubre cualquier
materia nueva que agregues.
