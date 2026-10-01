# Tutoriales (learnr)

Estos son los laboratorios semanales del curso: tutoriales interactivos
con ejercicios de código y quizzes, usando el paquete `learnr`. **No
son Quarto** — son `.Rmd` con `runtime: shiny_prerendered`, un motor
distinto que necesita R corriendo en vivo para que los ejercicios
funcionen.

Por eso viven separados de `content/` y `temas/`, y **no** se
renderizan con `quarto render` ni con los scripts de `R/` — `_quarto.yml`
excluye esta carpeta explícitamente de cualquier render de proyecto.

## Por qué learnr y no quarto-live/webR

Se evaluaron ambas opciones. `quarto-live` (webR, R compilado a
WebAssembly) tiene la ventaja de correr en el navegador sin que el
estudiante instale nada — pero el soporte de paquetes en WebAssembly es
limitado, y varios paquetes con dependencias compiladas pesadas
(`arrow` para leer datos en formato parquet, por ejemplo) no están
garantizados ahí. Como el curso trabaja con datos reales del BCCR (ver
`shared/bccr/extract_bccr.R`) y se prefiere guardar esos datos en formato
parquet, se optó por `learnr` en su lugar: corre con R real (local, en
Positron/RStudio), así que cualquier paquete que instales en tu propia
máquina funciona sin restricciones — incluyendo `arrow`/`nanoparquet`.
La contrapartida es que el estudiante sí necesita tener R/RStudio
instalado — pero eso ya lo instalan en la semana 1 del curso para todo
lo demás, así que no es un requisito adicional real.

## Cómo correr un tutorial (localmente, para ti o para un estudiante)

**Forma recomendada — funciona siempre, sin depender de la interfaz:**

```r
install.packages("learnr")  # una sola vez

rmarkdown::run("materias/estadistica/tutoriales/semana-02-descripcion-datos/tutorial.Rmd")
```

Esto imprime en la consola una línea como
`Listening on http://127.0.0.1:XXXX` (el número de puerto cambia cada
vez que lo corrés). Copiá **esa dirección exacta** y abrila en una
pestaña **nueva** del navegador.

**Importante — errores comunes que parecen "no funciona" pero no lo son:**

- **No uses el botón "Render"** (ni `rmarkdown::render()` a secas): un
  tutorial `learnr` no es HTML estático, es una mini app Shiny — hace
  falta un proceso de R corriendo detrás en todo momento. "Render"
  genera solo una foto fija: se ve el diseño pero ningún botón
  reacciona. Usá siempre "Run Document" o `rmarkdown::run()`.
- **En Positron, el soporte para documentos Shiny/interactivos todavía
  está en desarrollo** — el botón "Run Document" puede no aparecer o
  no funcionar de forma confiable. Si te pasa, `rmarkdown::run()` desde
  la consola es la alternativa que sí funciona siempre, sin depender de
  ningún botón de la interfaz.
- **Si ya usaste "Render" alguna vez sobre ese `tutorial.Rmd`**, va a
  quedar un `tutorial.html` (y a veces una carpeta `tutorial_files/`)
  residual en esa misma carpeta — un archivo estático, sin servidor
  detrás. Si tu navegador reabre una pestaña vieja o vas a ese archivo
  por error, vas a ver exactamente el mismo síntoma (diseño roto,
  nada reacciona) aunque la sesión en vivo esté funcionando bien en
  otra dirección. Borrá ese `tutorial.html` residual y usá siempre la
  dirección `http://127.0.0.1:...` que imprime `rmarkdown::run()` en
  una pestaña nueva.

`learnr::run_tutorial()` (buscando el tutorial por nombre en vez de por
ruta) solo funciona bien cuando los tutoriales están empaquetados en un
paquete de R — como acá no lo están, `rmarkdown::run()` apuntando
directo al archivo es la forma confiable.

## Convención de nombres

Una carpeta por semana, con el mismo slug que ya usan las
presentaciones y guías de esa semana en `materias/estadistica/content/`
(`semanas/semana-NN-*-presentacion.qmd`, `preparacion/semana-NN-*-guia.qmd`):

```
materias/estadistica/tutoriales/
  semana-02-descripcion-datos/tutorial.Rmd
  semana-03-probabilidad-conceptos/tutorial.Rmd
  semana-04-probabilidad-reglas-bayes/tutorial.Rmd
  ...
```

Cada materia tiene su propia carpeta `tutoriales/` (por ejemplo, si
algún día `matematica-economistas` suma laboratorios learnr, irían en
`materias/matematica-economistas/tutoriales/`) — así queda igual de
scoped por materia que `content/`, `fuente/` y `cursos/`.

Cada `tutorial.Rmd` sigue el mismo patrón: bloque `setup` con los datos
de la sesión, secciones con un bloque de código demostrativo
(`exercise=FALSE`) seguido de 1-3 ejercicios (`exercise=TRUE` +
`-solution`), y 1-3 preguntas de quiz (`question()`) por sección que
refuerzan el concepto clave.

## Agregar un tutorial nuevo

```r
dir.create("materias/estadistica/tutoriales/semana-NN-slug", recursive = TRUE)
# copiá tutorial.Rmd de una semana ya hecha como plantilla
```

## Cómo compartirlo con los estudiantes

**Compartí la carpeta completa de la semana**, no solo el
`tutorial.Rmd` suelto — aunque hoy ninguno de los tutoriales existentes
depende de archivos externos, cualquier semana que use datos reales
(ver abajo) sí los va a necesitar junto al `.Rmd`, en la misma carpeta.
Mantener siempre "toda la carpeta" como unidad de entrega evita tener
que acordarte cuál semana necesita más que el `.Rmd` y cuál no.

Cada estudiante corre su propia copia local con `rmarkdown::run()` (ver
arriba) — no hace falta ningún servidor ni cuenta. El único requisito
es tener R y el paquete `learnr` instalados, que ya hacen en la semana
1 del curso.

## Cargar datos reales del BCCR (u otra fuente)

Como estos tutoriales corren con R real, no hay ninguna restricción
para leer datos: `read.csv()`, `arrow::read_parquet()`,
`nanoparquet::read_parquet()`, todo funciona igual que en cualquier
script de R. Pero **el pipeline de descarga y el dato ya limpio y
listo para una semana específica son cosas distintas, con lugares
distintos**:

- `shared/bccr/extract_bccr.R` + su output maestro
  (`.rdata`/`.parquet` con el histórico completo de indicadores) es tu
  pipeline personal — vive en `shared/bccr/` (en la raíz del repo, no
  dentro de `materias/estadistica/`, porque otras materias como
  `matematica-economistas` también lo pueden usar), tiene tus
  credenciales (o las necesita para correr), y **nunca se comparte con
  los estudiantes**.
- Para que una semana use datos reales, guardá un **CSV chico y
  curado** con solo la porción que esa semana necesita, directo dentro
  de la carpeta de ese tutorial — por ejemplo
  `semana-11-series-tiempo/pib_costa_rica.csv` — y leelo con ruta
  relativa desde el bloque `setup`:

  ```r
  pib <- read.csv("pib_costa_rica.csv")
  ```

  Como `rmarkdown::run()` corre con el directorio de trabajo puesto en
  la carpeta del tutorial, la ruta relativa funciona igual en tu
  máquina y en la del estudiante — mientras compartas la carpeta
  completa (ver arriba), el CSV viaja junto con el `.Rmd` sin que haga
  falta ninguna configuración extra.

## Si algún día querés compartirlo con otros sin que instalen R

Evaluado (2026-09-03) y descartado por ahora: shinyapps.io gratuito
solo soporta 3-5 usuarios conectados a la vez de forma confiable
(según la documentación oficial de `learnr`) — insuficiente para una
clase completa. El plan pago que sí escala (shinyapps.io Basic o
superior) ronda los $49/mes. Posit Cloud es otra alternativa, pero
requiere que cada estudiante tenga su propia cuenta y corra el
tutorial en su propia sesión (no es un link único ya corriendo). Si
más adelante conviene reconsiderar alguna de estas, avisame y lo
retomamos.
