# `R/` — orquestador de render del repo

Estos tres scripts son todo el código R del repo (no es un paquete
formal, solo `source()`s). Se queda en `R/` porque es la convención
estándar en proyectos y paquetes de R.

- **`nuevo_curso.R`** — crea el `_variables.yml` de un curso nuevo
  (universidad + periodo) y las 3 subcarpetas de salida. Se corre una
  vez por cuatrimestre.
- **`render_curso.R`** — el orquestador: renderiza el contenido de una
  materia para un curso específico. Es el que se usa seguido — ver
  detalle abajo.
- **`script_maestro.R`** — punto de entrada de trabajo diario: se edita
  la materia/universidad/año/cuatri de arriba y de ahí se corren las
  líneas que se necesiten, sin tocar los otros dos archivos. **Nota:**
  hoy tiene `MATERIA <- "teoria-estadistica"`, que no existe en
  `materias/` (la carpeta real es `estadistica/`) — es el scratch
  personal del usuario, corregir antes de usarlo para ese curso.

No se documenta acá el detalle de cada materia (calendario,
bibliografía, diseño visual) — eso vive en `materias/<materia>/README.md`.
Este README es sobre **cómo funciona el mecanismo de render**, genérico
para cualquier materia, y sobre los acuerdos/bugs encontrados al
usarlo — para que cualquier instancia de Claude (u otra persona) que
retome este repo entienda el sistema sin tener que releer todo el
historial de cambios.

## Flujo de trabajo típico

1. **Una vez por cuatrimestre:** `nuevo_curso()` — crea
   `materias/<materia>/cursos/<universidad>/<periodo>/_variables.yml`
   y las 3 subcarpetas de salida (`presentaciones/`, `documentos/`,
   `laboratorios/`).
2. **Mientras se escribe/corrige contenido:** `render_curso()` con
   `unidades = <número>` (o el archivo puntual) para renderizar rápido
   solo lo que se está trabajando, sin esperar el curso completo.
3. **Cuando el curso ya está completo:** `render_curso()` sin filtros,
   para generar todo de una vez.

## Cómo funciona `render_curso()`

```r
source("R/render_curso.R")
render_curso(materia = "estadistica", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3)
```

Por cada curso (`materia` + `universidad` + `anio` + `cuatri`) existe un
`_variables.yml` (creado por `nuevo_curso()`). `render_curso()`:

1. Lee ese `_variables.yml` completo a una lista (`vars`).
2. Arma la lista de archivos `.qmd` a renderizar: `content/unidades/`
   (o `content/semanas/` si `unidades/` no existe — ver más abajo, o la
   carpeta que diga `carpeta_contenido`), `content/tareas/`,
   `content/docs/` y `content/preparacion/` — cada uno controlado por
   su booleano (`incluir_tareas`, `incluir_docs`, `incluir_programa`,
   `incluir_preparacion`; el contenido temático por el argumento
   `unidades`).
3. **Por cada archivo**, mira qué `params:` declara ese `.qmd`
   específico (`parametros_declarados()`, lee el YAML del archivo) y le
   pasa como `execute_params` solo la intersección entre esos nombres y
   lo que hay en `vars` (`vars_archivo`). Esto es lo importante:
   **cualquier clave nueva que agregues a `_variables.yml` se propaga
   sola a cualquier `.qmd` que la declare en su propio `params:`, sin
   tocar `render_curso.R`** — así funciona `formato` (ver abajo), y así
   funcionaría cualquier clave nueva que necesites a futuro.
4. Renderiza cada archivo con `quarto::quarto_render()` y mueve el
   `.html` resultante a la subcarpeta que le corresponde (ver abajo) —
   autocontenido (`embed-resources: true`, siempre que el `.qmd` de
   origen use el YAML estándar, ver la sección del bug más abajo).

## Estructura de un curso renderizado: 3 subcarpetas

`materias/<materia>/cursos/<universidad>/<periodo>/` se organiza en:

| Subcarpeta | Qué cae ahí | De dónde sale |
|---|---|---|
| `presentaciones/` | Unidades (slides para estudiantes) y guías docente | `content/unidades/*-presentacion.qmd` + `content/preparacion/*-guia.qmd` |
| `documentos/` | Programa del curso y evaluaciones | `content/docs/programa.qmd`, resto de `content/docs/` (ej. `guia-lecturas.qmd`), y todo `content/tareas/` (estudio de caso, portafolio, tarea-01, etc.) |
| `laboratorios/` | Prácticas y laboratorios | Hoy nada — los tutoriales `learnr` viven en `materias/<materia>/tutoriales/` y corren aparte, sin pasar por `render_curso()`. La carpeta se crea igual, lista para cuando haga falta. |

`nuevo_curso()` crea las 3 subcarpetas al crear el curso; `render_curso()`
las vuelve a crear si hiciera falta (idempotente, no rompe nada si ya
existen).

**Importante:** esto solo aplica a renders nuevos. Un curso que ya fue
renderizado antes de esta convención (con `.html` sueltos en la raíz
del curso, ej. algún `FIDELITAS/2026-C3` viejo) no se reorganiza solo
— hay que volver a renderizarlo o mover los archivos a mano.

## Por qué el nombre de salida nunca lleva el número de unidad

Cada archivo de `content/unidades/` lleva un número en el nombre
(`7_<tematica>-presentacion.qmd`) — pero ese número es **solo** un
dato de orden interno para que `unidades = c(...)` pueda filtrar, no
algo con significado real en un programa institucional (una unidad
puede terminar con un número que no corresponde a ningún tema concreto,
ej. "unidad 25" para un tema agregado después). El archivo que se
comparte con estudiantes/docentes se llama solo
`<tematica>-presentacion.html` / `<tematica>-guia.html` — sin el
prefijo numérico. `render_curso()` se lo quita automáticamente al
mover el `.html` a su subcarpeta de salida.

**Convención de nombres (unificada desde 2026-09-29):** `N_<tematica>-
presentacion.qmd` / `N_<tematica>-guia.qmd`, numeración consecutiva
desde 0 (la intro es la unidad 0). `estadistica` usó este esquema desde
su migración a unidades granulares; `matematica-economistas` usaba
antes `unidad-N-<tematica>-presentacion.qmd` (sin número para la
intro) y se renombró el 2026-09-29 para quedar igual — ver
`materias/matematica-economistas/README.md`. `render_curso()` acepta
ambos prefijos (`N_` y el viejo `unidad-N-`) por compatibilidad, pero
todo el repo usa `N_` hoy.

## `unidades` (antes `semanas`) — qué contenido renderizar

`unidades = c(1, 3)` filtra `content/unidades/` por el primer número
que aparece en el nombre del archivo. Cada archivo es una unidad
temática autocontenida (un "lego"): no se fusiona con otras, y el mismo
archivo se reutiliza sin importar cuántas sesiones tenga el curso ese
cuatrimestre. Ambas materias (`matematica-economistas` y `estadistica`)
usan este esquema hoy.

`semanas` sigue existiendo como **alias retrocompatible** de `unidades`
(mismo filtro exacto) — nombre viejo de cuando `estadistica` numeraba
por semana de calendario en vez de unidad de contenido. Ningún curso
del repo lo necesita ya, pero `render_curso()` lo sigue aceptando por
si algún script viejo lo usa; no se puede pasar `unidades` y `semanas`
a la vez (error explícito). `nuevo_curso()` todavía guarda el
subconjunto bajo el nombre `semanas:` en `_variables.yml` — no hace
falta cambiarlo, `render_curso()` lee indistintamente `unidades:` o
`semanas:` de ahí.

Si el curso fue creado con un subconjunto guardado (`nuevo_curso(...,
semanas = ...)`), `render_curso()` lo usa automáticamente cuando no se
pasa `unidades`/`semanas` en la llamada. Pasarlo explícito en la
llamada siempre gana sobre lo guardado (útil para renderizar una sola
unidad suelta mientras se revisa contenido).

## `carpeta_contenido` — carpeta de unidades alterna

Si una materia necesita una versión de su contenido totalmente distinta
(no un subconjunto, sino contenido reorganizado), `_variables.yml`
puede declarar `carpeta_contenido: "<nombre>"` y `render_curso()` la
usa en vez de `unidades/`+`preparacion/`. `estadistica` usó esto
(`sesiones-10`, contenido fusionado por sesión) hasta su migración a
unidades granulares — el mecanismo queda disponible pero ninguna
materia del repo lo usa hoy; el contenido viejo de esa modalidad quedó
en `_to_delete/estadistica-sesiones-10-viejo/` pendiente de borrado
manual.

## `formato` — modalidad del curso

`matematica-economistas` se dicta en dos versiones — 10 sesiones o 15
sesiones — y ambas están vigentes (ninguna reemplaza a la otra).
`content/docs/programa.qmd` declara `params: formato:`, así que basta
con que `_variables.yml` tenga `formato: "10-sesiones"` para que se
propague solo, por el mecanismo general del paso 3 de arriba.

- **Nombre:** `formato`, no `duracion` — deja espacio a futuras
  modalidades que no sean de duración (ej. virtual, intensivo).
- **Valor por defecto:** vive en `_variables.yml` del curso (el curso
  "recuerda" en qué formato se dicta). `render_curso(..., formato =
  "15-sesiones")` pisa ese valor solo para ese render puntual, sin
  tocar el archivo — mismo patrón que `unidades`.
- **`incluir_programa` es un booleano separado de `incluir_docs`**:
  `incluir_docs` controla el resto de `content/docs/` (ej.
  `guia-lecturas.qmd`), `incluir_programa` controla solo
  `programa.qmd`. Se separaron porque en la práctica se necesita
  re-renderizar el programa solo (mientras se ajusta cronograma o
  evaluación) sin tocar el resto de la documentación.
- **`formato` es genérico, no específico de una materia**: cualquier
  otra materia que necesite algo similar solo declara `params:
  formato:` en su propio `.qmd` y agrega `formato: "..."` a su
  `_variables.yml` — no requiere tocar `render_curso.R`.

## El bug de render encontrado, y el formato estándar que lo corrige

Al renderizar `programa.qmd` y los `.qmd` de `content/tareas/` de
`matematica-economistas` aparecieron dos problemas reales:

1. **Expresiones sin evaluar** — `` `r params$universidad` `` aparecía
   literal en el HTML en vez de evaluarse, porque el archivo dependía
   solo del `engine: knitr` declarado a nivel de proyecto (`_quarto.yml`)
   en vez de declararlo también en su propio YAML.
2. **"Formato corrido" / título duplicado** — el HTML salía con el
   theme institucional sin aplicar bien y con el título repetido, por
   faltar `embed-resources: true` + `title-block-banner: false` en el
   `.qmd`, combinado con un encabezado manual redundante (`#
   Título...`, líneas de metadata a mano) que duplicaba lo que Quarto
   ya genera a partir de `title:`/`params`.

**El YAML estándar que corrige ambos problemas**, ya aplicado a
`materias/matematica-economistas/content/docs/programa.qmd` y
`materias/matematica-economistas/content/tareas/estudio-de-caso.qmd`
(y `portafolio.qmd`):

```yaml
---
title: "Nombre del documento"
engine: knitr
format:
  html:
    embed-resources: true
    title-block-banner: false
params:
  universidad: "..."
  docente: "..."
  anio: 2026
  cuatri: 1
---
```

Con ese YAML, `` `r params$universidad` `` etc. se evalúan
correctamente y el título/theme salen limpios sin necesidad de ningún
encabezado manual adicional en el cuerpo del documento — el `title:`
del YAML ya es el encabezado.

**Cualquier `.qmd` nuevo de tipo "documento" (programa, tarea, estudio
de caso, portafolio, etc.) debe copiar este YAML desde el principio**,
en vez de repetir el mismo bug.

### Pendiente: aplicar este fix en `estadistica`

`materias/estadistica/content/docs/programa.qmd` y
`materias/estadistica/content/tareas/tarea-01.qmd` **todavía tienen el
formato viejo** (sin `engine: knitr`, sin `embed-resources`/
`title-block-banner`, con encabezado manual redundante) — no se les
aplicó el fix todavía. Esto es exactamente lo que falta para poder
generar los documentos del curso de estadística sin repetir el bug:
abrir esos dos archivos, reemplazar su bloque YAML por el estándar de
arriba (manteniendo `title:` y los valores de `params:` que ya tienen),
y quitar cualquier encabezado manual redundante en el cuerpo si lo
hubiera. `materias/estadistica/content/unidades/` y
`content/preparacion/` (las presentaciones y guías) no tienen este
problema — son `revealjs`/formato distinto y ya renderizan bien; el bug
es específico de los documentos `html` de `docs/`+`tareas/`.

## Estructura de contenido de origen (`content/`)

- `content/unidades/` — presentaciones de estudiante, una por unidad
  temática (`-presentacion.qmd`).
- `content/preparacion/` — guías docente, una por unidad
  (`-guia.qmd`).
- `content/docs/` — documentos generales del curso: `programa.qmd` +
  cualquier otro (ej. `guia-lecturas.qmd`).
- `content/tareas/` — evaluaciones: estudio de caso, portafolio,
  tareas puntuales.
- `content/blocks/` — bloques de contenido reutilizables entre
  archivos (no renderiza directo, se incluye desde otros `.qmd`).

## Formato estándar de rúbrica (`content/tareas/*.qmd`)

Todo archivo de `content/tareas/` que incluya una rúbrica de
evaluación usa el mismo formato de tabla, sin importar la materia
(decisión del usuario, 2026-09-25 — ejemplo canónico:
`materias/estadistica/content/tareas/investigacion-final.qmd` y
`materias/estadistica/content/tareas/caso-1.qmd`):

```
| # | Criterio | Descripción | Puntos |
|---|---|---|---|
| 1 | <nombre corto> | <qué se evalúa en este criterio> | <puntos> |
| ... | ... | ... | ... |
| | **Total** | | **100** |
```

Los puntos de cada criterio suman siempre 100, y el documento cierra
con una línea `**Puntaje total:** 100 puntos → equivalen al <X>% de la
nota final (regla de 3).` — así el criterio de mayor peso queda
explícito en el número de puntos, no solo en un "cumple/no cumple"
binario, y la conversión a porcentaje es la misma fórmula (regla de 3)
en cualquier materia.

`materias/matematica-economistas/content/tareas/estudio-de-caso.qmd` y
`portafolio.qmd` todavía usan un formato anterior (checklist a tres
niveles: Cumple / Cumple parcialmente / No cumple, 2 puntos por
criterio) — quedaron sin migrar al formato nuevo por ahora; al crear
una rúbrica nueva en cualquier materia, usar el formato de puntos de
arriba, no el checklist viejo.

## Ejemplos de uso completos

```r
source("R/nuevo_curso.R")
source("R/render_curso.R")

# Crear el curso (una vez por cuatri)
nuevo_curso(materia = "estadistica", universidad = "FIDELITAS",
            anio = 2026, cuatri = 3, fecha_inicio = "2026-09-11",
            feriados = character(0), logo_path = "images/logos/fidelitas.jpg")

# Render completo
render_curso(materia = "estadistica", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3)

# Solo una unidad puntual, sin tareas/docs/preparación
render_curso(materia = "estadistica", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3, unidades = 2,
             incluir_tareas = FALSE, incluir_docs = FALSE,
             incluir_programa = FALSE, incluir_preparacion = FALSE)

# Varias unidades a la vez (una sesión de clase real puede cubrir más de una)
render_curso(materia = "estadistica", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3, unidades = c(2, 3))

# Solo el programa (mientras se ajusta cronograma/evaluación)
render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3, unidades = integer(0),
             incluir_tareas = FALSE, incluir_docs = FALSE,
             incluir_programa = TRUE, incluir_preparacion = FALSE)

# Un formato puntual, sin tocar _variables.yml
render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3, formato = "15-sesiones")
```

## Aviso: cambios en curso en las presentaciones — NO REVERTIR (2026-09-18)

Fabián está editando a mano el contenido de las presentaciones (los
archivos `-presentacion.qmd` de `content/unidades/`, materia
`estadistica`, y sus guías docente asociadas en `content/preparacion/`)
directamente en el repo, fuera de este flujo de trabajo asistido. Esos
cambios son intencionales y están en curso — si en una sesión futura
alguien (incluida una IA) ve una diferencia entre el contenido de esos
`.qmd` y lo que aparece documentado en `claude/plan-estadistica.md` (el
plan del proyecto), el archivo real en el repo es la fuente de verdad:
no revertir, sobrescribir, ni "corregir" ese contenido para que
coincida con el plan sin confirmar antes con Fabián. Si hace falta,
actualizar el plan del proyecto para reflejar el contenido nuevo, no al
revés.

## ⚠️ `render_curso.R` se ha revertido solo, varias veces — causa real encontrada (2026-09-29)

Este archivo se ha encontrado revertido a versiones viejas (sin las 3
subcarpetas, sin el fix de nomenclatura) **al menos 3 veces** en
sesiones distintas, cada vez detectado porque el HTML de salida
aparecía suelto en la raíz del curso en vez de en
`presentaciones/`/`documentos/`/`laboratorios/`. Cada vez se restauró
el código a mano desde el historial de la conversación, pero nunca se
había investigado la causa real hasta ahora.

**Causa encontrada:** `git log` muestra que este repo tiene solo 3
commits, el último que tocó `R/render_curso.R` es del **2026-07-09**
— casi 3 meses antes de todo el trabajo de subcarpetas, numeración
consecutiva, y todas las guías/presentaciones desarrolladas desde
entonces. Es decir: **nada de este trabajo está protegido por git** —
vive únicamente en el árbol de trabajo (working tree) del repo en el
disco. `git status` muestra decenas de archivos modificados/nuevos sin
commitear. Sin un commit, cualquier mecanismo que restaure una copia
vieja del archivo — un conflicto de sincronización de OneDrive (el
repo tiene DOS carpetas conectadas: una bajo `OneDrive - Habitat for
Humanity International\...` y otra bajo `Documents\...`; si Windows
tiene redirigida la carpeta `Documents` hacia OneDrive, ambas rutas
pueden terminar siendo la misma carpeta sincronizada, y un conflicto
de sync puede restaurar una versión cacheada vieja), un editor que
restaura un autoguardado viejo, o una herramienta de backup — puede
sobrescribir el trabajo sin que quede ningún rastro para recuperarlo
aparte de la memoria de la sesión de Claude que lo escribió.

**Recomendación fuerte:** hacer `git add` + `git commit` de todo el
trabajo pendiente cuanto antes (y periódicamente de ahí en adelante,
no solo al final de una sesión larga). Un commit no evita que el
archivo en disco se sobrescriba, pero si pasa, `git diff`/`git
checkout` lo recuperan al instante — ya no dependería de que quede
registrado en una conversación de Claude. Vale la pena revisar
también, fuera de esta sesión, por qué hay dos carpetas del mismo repo
conectadas (OneDrive y Documents) y si eso está causando conflictos de
sincronización activos.

## Pendiente

- **Hacer el primer commit real de todo este trabajo** (ver sección de
  arriba) — es la prioridad más alta, antes de seguir agregando
  contenido nuevo sobre una base sin protección.
- **Aplicar el fix de YAML a `estadistica/content/docs/programa.qmd` y
  `estadistica/content/tareas/tarea-01.qmd`** (ver sección del bug
  arriba) — esto es lo que falta para generar los documentos de ese
  curso sin arrastrar el bug.
- Verificar con un render real (Quarto/R no están disponibles en el
  entorno de trabajo remoto) que unidades + subcarpetas + el fix de
  YAML funcionan juntos correctamente sobre contenido real.
- `script_maestro.R` tiene `MATERIA <- "teoria-estadistica"`, que no
  coincide con ninguna carpeta real de `materias/` (la real es
  `estadistica/`) — corregir antes de usarlo para ese curso.
- Borrado manual de `_to_delete/estadistica-sesiones-10-viejo/`,
  `_to_delete/matematica-economistas-unidad-3-equilibrio-mercado-viejo/`
  y cualquier otra carpeta `_to_delete/` pendiente (el bridge no puede
  borrar archivos en la computadora del usuario).
- Desarrollar contenido pendiente de `matematica-economistas` unidades
  4-14 (fuera del alcance de este README, ver el plan de proyecto de
  esa materia).
