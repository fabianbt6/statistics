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
- **matematica-economistas** — EC-620 Matemática para Economistas
  (Universidad Fidélitas, Bachillerato en Economía). Programa
  institucional oficial en `content/docs/programa.qmd`; fuente original
  en `fuente/`.
- **economia-innovacion** — EC-910 Economía de la Innovación
  (Universidad Fidélitas, Licenciatura en Economía). Docente: Marianne
  Pérez Gómez. Cronograma propio (7 sesiones presenciales, teórico-
  práctico) — ver `claude/plan-economia-innovacion.md` en el Project de
  Claude. Programa oficial y malla en `fuente/`.
- **evaluacion-proyectos** — EC-912 Evaluación Económica y Social de
  Proyectos (Universidad Fidélitas, Licenciatura en Economía). Docente:
  Marianne Pérez Gómez. Formato tutorías: **5 sesiones**, cada una un
  paso del proyecto final (que vale el 100% de la nota), con
  bibliografía reemplazada por manuales de acceso abierto de CEPAL/ILPES
  y MIDEPLAN — ver `claude/plan-evaluacion-proyectos.md` en el Project
  de Claude. Programa oficial en `fuente/`.

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

No hace falta tocar `_quarto.yml` para que el contenido se renderice —
`materias/**` ya cubre cualquier materia nueva que agregues. Sí hay que
agregar la línea del `.bib` de la materia nueva a la lista `bibliography:`
de `_quarto.yml` (ver los cuatro `.bib` ya listados ahí como ejemplo).
