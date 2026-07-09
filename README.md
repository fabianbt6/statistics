# statistics

Sistema para generar y mantener el material del curso de Estadística
(presentaciones, tareas, docs) en Quarto, de forma modular y automatizada
cuatri a cuatri — y para distintas universidades.

## Idea central

El contenido vive **una sola vez** en `content/`. Cada oferta (una
combinación universidad + cuatrimestre) es solo un archivo de parámetros
en `ofertas/<universidad>/<periodo>/_variables.yml`. Renderizar una oferta
inyecta esos parámetros (fechas, feriados, universidad, logo, docente) en
el contenido fijo y genera HTML autocontenido en `_output/`, listo para
compartir por correo/Drive/plataforma — sin depender de un link público.

```
statistics/
├── _quarto.yml              # config del proyecto (revealjs, embed-resources)
├── _brand.yml                # tu paleta de colores y tipografía personal
├── R/
│   ├── nueva_oferta.R         # crea ofertas/<universidad>/<periodo>/_variables.yml
│   └── render_oferta.R        # renderiza esa oferta a HTML autocontenido
├── content/                  # el núcleo — se edita UNA vez
│   ├── blocks/                # piezas modulares (portada, temas, ejercicios...)
│   ├── semanas/                # cada semana ensambla los bloques que necesita
│   ├── tareas/
│   └── docs/                  # programa, rúbricas, etc.
├── ofertas/
│   └── EJEMPLO-UCR/2026-C1/_variables.yml
├── images/logos/              # un logo por universidad
└── _output/                  # HTML generados (no se versiona en git)
```

## Contenido modular

Cada bloque en `content/blocks/` es una pieza independiente (portada,
tipos de datos, distribuciones de probabilidad, ejercicios, referencias).
Una semana simplemente los ensambla con `{{< include >}}`:

```markdown
{{< include ../blocks/portada.qmd >}}
{{< include ../blocks/tipos-de-datos.qmd >}}
{{< include ../blocks/distribuciones-probabilidad.qmd >}}
{{< include ../blocks/ejercicios.qmd >}}
{{< include ../blocks/referencias.qmd >}}
```

Para armar otra semana con otra combinación de temas, copias
`content/semanas/semana-01.qmd` y cambias qué bloques incluye — el
contenido de cada bloque no se duplica.

Editas un bloque una vez (ej. `tipos-de-datos.qmd`) y el cambio se
refleja en todas las semanas que lo incluyan.

## Marca personal vs. logo de universidad

- `_brand.yml` (raíz): tu paleta de colores y tipografía. Se aplica sola
  a todo — revealjs, html, pdf — sin tocar cada archivo. **Edítalo con tus
  colores reales**, ahora tiene placeholders.
- Logo de universidad: **no** vive en `_brand.yml` porque cambia por
  oferta. Se inyecta como parámetro (`params$logo_path`) directamente en
  `content/blocks/portada.qmd`, y su valor real viene del
  `_variables.yml` de cada oferta.

## Flujo para un cuatri nuevo

```r
source("R/nueva_oferta.R")
nueva_oferta(
  universidad  = "UCR",
  anio         = 2026,
  cuatri       = 1,
  fecha_inicio = "2026-01-19",
  feriados     = c("2026-04-03", "2026-05-01"),
  logo_path    = "images/logos/ucr.png"
)

source("R/render_oferta.R")
render_oferta(universidad = "UCR", anio = 2026, cuatri = 1)
```

Esto deja los `.html` autocontenidos en `_output/UCR/2026-C1/`, listos
para compartir. Ninguna carpeta de `content/` se duplica ni se
sobrescribe entre universidades o cuatris.

## Publicar en GitHub Pages (a futuro)

Por ahora se comparten los `.html` directamente. Cuando quieras activar
publicación en línea, `embed-resources: true` no es incompatible con
Pages — simplemente se agrega un workflow de GitHub Actions que llame a
`quarto publish` sin tocar nada de esta estructura.

## Pendientes / TODO

- [ ] Reemplazar los colores placeholder en `_brand.yml`
- [ ] Agregar logos reales en `images/logos/`
- [ ] Migrar el contenido real de las presentaciones PPT a los bloques de
      `content/blocks/`
- [ ] Revisar/completar `content/docs/programa.qmd`
