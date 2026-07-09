# statistics

Tu repo de estadística: entrega de cursos (presentaciones, tareas)
automatizada por materia + universidad + cuatri, **más** una base de
consulta personal (resúmenes, prácticas, laboratorios) y tutoriales
interactivos — todo convive sin pisarse.

## Terminología

- **materia** — un curso completo independiente (ej. "estadística",
  "series de tiempo"), con su propio programa, unidades, tareas.
- **curso** — una combinación puntual universidad + cuatrimestre de una
  materia (ej. "estadística en la UCR, 2026-C1").

## Las cuatro partes del repo

| Carpeta | Para qué | Se renderiza como |
|---|---|---|
| `materias/<materia>/content/` + `cursos/` | Dar clases de esa materia, por universidad+cuatri | revealjs (slides) |
| `shared/` | Lo único que se reutiliza ENTRE materias (portada) | — |
| `temas/` | Consulta personal: cualquier tema, cruza cualquier materia | html (documento) |
| `tutoriales/` | Ejercicios interactivos (learnr) | Shiny, local — ver su README |

```
statistics/
├── _quarto.yml              # config del proyecto (revealjs, embed-resources)
├── _brand.yml                # tu paleta de colores y tipografía personal
├── R/
│   ├── nuevo_curso.R          # crea materias/<materia>/cursos/<universidad>/<periodo>/_variables.yml
│   └── render_curso.R         # renderiza ese curso a HTML autocontenido
├── shared/
│   └── portada.qmd            # plantilla de portada — reusable entre TODAS las materias
├── materias/
│   ├── README.md              # cómo agregar una materia nueva
│   └── estadistica/
│       ├── content/
│       │   ├── blocks/bibliografia.qmd   # específica de esta materia
│       │   ├── semanas/
│       │   ├── tareas/
│       │   └── docs/
│       └── cursos/EJEMPLO-UCR/2026-C1/_variables.yml
├── temas/                    # consulta personal, libre — ver temas/README.md
│   └── probabilidad-condicional/{resumen,practica,laboratorio}.qmd
├── tutoriales/                # learnr — motor distinto, ver tutoriales/README.md
│   └── probabilidad-basica/tutorial.Rmd
├── images/logos/              # un logo por universidad
└── _output/                  # HTML generados: _output/<materia>/<universidad>/<periodo>/
```

## Por qué existe `materias/`

Al principio el repo asumía una sola materia (todo en `content/` y
`cursos/` a nivel raíz). Eso se rompe en cuanto impartes un curso
completo distinto (ej. Series de Tiempo, con sus propias unidades y
bibliografía) — no solo una nota de repaso. `materias/` agrega ese
nivel; ver `materias/README.md` para el patrón exacto de cómo agregar
una nueva.

`shared/portada.qmd` es la única pieza que de verdad se reutiliza
entre materias, porque está 100% parametrizada (universidad, logo,
docente, materia, unidad) y no tiene contenido propio de ninguna
materia específica.

## Contenido modular: bloques estructurales, no temáticos

Al migrar el primer PPT real (Unidad 2: Probabilidad) quedó claro que
el contenido de fondo (qué es probabilidad condicional, qué es Bayes)
**no se repite** entre unidades — lo que se repite es el **patrón**:
portada, agenda, divisor de sección, definición, ejercicio+solución,
bibliografía.

- `shared/portada.qmd` — plantilla real, los datos cambian por parámetro
- `materias/<materia>/content/blocks/bibliografia.qmd` — los textos de
  esa materia (varían entre materias, y a veces entre unidades — ver
  `PATRONES.md`)

El resto del patrón (divisores, definiciones, ejercicios) se logra con
**clases CSS reutilizables** definidas en `styles.scss`, aplicadas
directo en el `.qmd` de cada unidad:

```markdown
## Probabilidad Condicional {.divisor}     <!-- fondo de marca, slide completa -->

## Definición                              <!-- acento bajo el título, automático -->

Sean $A$ y $B$ ...
```

Para una unidad nueva, copias
`materias/estadistica/content/semanas/unidad-02-probabilidad.qmd` como
plantilla y cambias el contenido — la *forma* (divisores, acentos,
portada, bibliografía) se hereda sola.

Para patrones adicionales (tablas, código R, preguntas de discusión,
slides destacadas, comparaciones de dos columnas, bibliografía que
varía por unidad), ver **`PATRONES.md`**.

## Marca personal vs. logo de universidad

- `_brand.yml` (raíz): tu paleta de colores y tipografía **personal**,
  aplica a **todas** las materias por igual. Trae una paleta
  indigo/terracota como punto de partida; cámbiala cuando quieras.
- `styles.scss`: define `.divisor`, `.destacado` y el acento bajo los
  títulos — usa las variables `$brand-*` que Quarto genera
  automáticamente desde `_brand.yml`.
- Logo de universidad: **no** vive en `_brand.yml` porque cambia por
  curso. Se inyecta como parámetro (`params$logo_path`) en
  `shared/portada.qmd`, y su valor real viene del `_variables.yml` de
  cada curso.

## Flujo para un cuatri nuevo

```r
source("R/nuevo_curso.R")
nuevo_curso(
  materia      = "estadistica",
  universidad  = "UCR",
  anio         = 2026,
  cuatri       = 1,
  fecha_inicio = "2026-01-19",
  feriados     = c("2026-04-03", "2026-05-01"),
  logo_path    = "images/logos/ucr.png"
)

source("R/render_curso.R")
render_curso(materia = "estadistica", universidad = "UCR", anio = 2026, cuatri = 1)
```

Esto deja los `.html` autocontenidos en `_output/estadistica/UCR/2026-C1/`,
listos para compartir. Ninguna carpeta de `content/` se duplica ni se
sobrescribe entre materias, universidades o cuatris.

## Publicar en GitHub Pages (a futuro)

Por ahora se comparten los `.html` directamente. Cuando quieras activar
publicación en línea, `embed-resources: true` no es incompatible con
Pages — simplemente se agrega un workflow de GitHub Actions que llame a
`quarto publish` sin tocar nada de esta estructura.

## Pendientes / TODO

- [ ] Ajustar la paleta indigo/terracota en `_brand.yml` si prefieres otros tonos
- [ ] Agregar logos reales de universidad en `images/logos/`
- [ ] Revisar `materias/estadistica/content/semanas/unidad-02-probabilidad.qmd`
- [ ] Migrar el resto de unidades de Estadística siguiendo el mismo patrón
- [ ] Completar `materias/estadistica/content/docs/programa.qmd` con el programa real
- [ ] Cuando Series de Tiempo sea un curso real, seguir `materias/README.md`
- [ ] Agregar más temas en `temas/` según los vayas necesitando consultar
- [ ] Instalar `learnr` (`install.packages("learnr")`) para correr `tutoriales/`
