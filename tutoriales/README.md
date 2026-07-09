# Tutoriales (learnr)

Estos son tutoriales interactivos con ejercicios de código y quizzes,
usando el paquete `learnr`. **No son Quarto** — son `.Rmd` con
`runtime: shiny_prerendered`, un motor distinto que necesita R
corriendo en vivo para que los ejercicios funcionen.

Por eso viven separados de `content/` y `temas/`, y **no** se
renderizan con `quarto render` ni con los scripts de `R/` — `_quarto.yml`
excluye esta carpeta explícitamente de cualquier render de proyecto.

## Cómo correr un tutorial (localmente, para ti)

```r
install.packages("learnr")  # una sola vez

learnr::run_tutorial("probabilidad-basica", package = NULL,
                      shiny_args = list(launch.browser = TRUE))
```

O más simple: abre `tutorial.Rmd` en Positron/RStudio y usa el botón
**Run Document** — se abre en una pestaña con el tutorial corriendo.

## Agregar un tutorial nuevo

```r
dir.create("tutoriales/nombre-tutorial", recursive = TRUE)
# copia tutorial.Rmd de probabilidad-basica/ como plantilla
```

## Si algún día quieres compartirlo con otros

Esto no corre en GitHub Pages (es hosting estático, sin servidor R
detrás). Necesitarías desplegarlo en shinyapps.io o Posit Connect —
avísame cuando llegues a ese punto y lo configuramos.
