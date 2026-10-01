# R/render_curso.R
#
# Renderiza el contenido (unidades/semanas, tareas, docs y preparación
# docente) de materias/<materia>/content/ para UN curso específico
# (universidad + periodo), inyectando sus parámetros y dejando los HTML
# autocontenidos listos en
# materias/<materia>/cursos/<universidad>/<periodo>/<subcarpeta>/ — junto
# al _variables.yml de ese mismo curso. Las 3 subcarpetas (creadas también
# por nuevo_curso() al crear el curso) son:
#   - "presentaciones/": unidades (-presentacion.qmd) + guías docente
#     (-guia.qmd de content/preparacion/).
#   - "documentos/": programa.qmd, el resto de content/docs/ (ej.
#     guia-lecturas.qmd), y content/tareas/ (evaluaciones -- estudio de
#     caso, portafolio, tarea-01, etc.).
#   - "laboratorios/": prácticas y laboratorios. Hoy ningún archivo de
#     content/ rinde acá -- los tutoriales learnr viven aparte, en
#     materias/<materia>/tutoriales/, y corren directo desde ahí (no pasan
#     por render_curso()) -- pero la carpeta se crea igual para cuando
#     haga falta.
#
# El HTML de salida de cada unidad NUNCA lleva el número de unidad en su
# nombre de archivo (aunque el .qmd de origen sí -- "N_<tematica>-
# presentacion.qmd", numeración consecutiva desde 0 para poder incluir
# la intro, esquema unificado desde el 2026-09-29 para ambas materias
# del repo -- matematica-economistas usaba antes "unidad-N-<tematica>-
# presentacion.qmd", ya renombrado; el sub("^(unidad-[0-9]+-|[0-9]+_)",
# ...) de abajo sigue aceptando ambos prefijos por si algún .qmd viejo
# no se renombró) -- ese número es solo un dato de orden interno para
# que `unidades = c(...)` pueda filtrar (presentaciones Y guías), no
# algo con significado en un curso real (una unidad puede quedar con un
# número que no corresponde a ningún tema concreto de un programa
# institucional). El archivo que se comparte con estudiantes/docentes
# se llama solo "<tematica>-presentacion.html" / "<tematica>-guia.html".
#
# Ejemplos de uso:
#   source("R/render_curso.R")
#
#   render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3)
#
#   # `unidades`: qué archivos de contenido renderizar, filtrando por el
#   # primer número que aparece en el nombre del archivo. Cada archivo de
#   # content/unidades/ es una unidad temática autocontenida (un "lego"),
#   # sin fusionar con otras -- el mismo archivo se reutiliza sin importar
#   # cuántas sesiones tenga el curso ese cuatrimestre. Ambas materias
#   # (matematica-economistas desde su Actualización 16, estadistica desde
#   # su migración posterior) usan este esquema:
#   render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3, unidades = 1)
#
#   render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3, unidades = 1:3,
#                incluir_tareas = FALSE, incluir_docs = FALSE,
#                incluir_programa = FALSE, incluir_preparacion = FALSE)
#
#   # Una sesión de clase real puede cubrir varias unidades a la vez --
#   # no hace falta un archivo fusionado aparte, `unidades` acepta un
#   # vector y renderiza cada unidad como su propio .qmd/.html:
#   render_curso(materia = "estadistica", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3, unidades = c(2, 3))
#
#   # `semanas` sigue existiendo como alias retrocompatible de `unidades`
#   # (mismo filtro, nombre viejo de cuando estadistica todavía numeraba
#   # por semana de calendario) -- ya no hace falta para ninguna materia
#   # del repo, pero no se quitó por si algún script viejo lo usa:
#   render_curso(materia = "estadistica", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3, semanas = 1:3)
#
#   # `formato`: para materias cuyos .qmd declaran un params$formato propio
#   # (hoy, programa.qmd de matematica-economistas: "10-sesiones" o
#   # "15-sesiones"). Si el curso ya tiene `formato:` guardado en su
#   # _variables.yml, no hace falta repetirlo -- se usa automáticamente.
#   # Pasarlo acá pisa ese valor solo para este render (no edita el archivo):
#   render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3, formato = "15-sesiones")
#
#   # `incluir_programa`: SOLO el programa del curso (programa.qmd), sin
#   # tocar nada más -- separado de `incluir_docs` (que cubre el resto de
#   # content/docs/, ej. guia-lecturas.qmd) porque suele necesitarse solo,
#   # sin re-renderizar todo lo demás:
#   render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
#                anio = 2026, cuatri = 3, unidades = integer(0),
#                incluir_tareas = FALSE, incluir_docs = FALSE,
#                incluir_programa = TRUE, incluir_preparacion = FALSE)
#
# Si el curso fue creado con nuevo_curso(..., unidades = ...) (o, en
# cursos viejos, ..., semanas = ...), ese subconjunto queda guardado en
# su _variables.yml y se usa AUTOMÁTICAMENTE cuando no se pasa `unidades`
# (ni `semanas`) acá — no hay que repetirlo cada vez que se renderiza el
# mismo curso. Pasar `unidades` (o `semanas`) explícitamente en esta
# llamada siempre gana sobre lo guardado (útil para renderizar solo una
# unidad suelta mientras se revisa contenido).
#

parametros_declarados <- function(archivo) {
  lineas <- readLines(archivo, warn = FALSE)
  marcas <- which(lineas == "---")

  if (length(marcas) < 2) return(character(0))

  bloque_yaml <- lineas[(marcas[1] + 1):(marcas[2] - 1)]
  yaml_parseado <- yaml::yaml.load(paste(bloque_yaml, collapse = "\n"))

  if (is.null(yaml_parseado$params)) return(character(0))
  names(yaml_parseado$params)
}

render_curso <- function(materia = "estadistica", universidad, anio, cuatri,
                          unidades = NULL,
                          semanas = NULL,
                          formato = NULL,
                          incluir_tareas = TRUE,
                          incluir_docs = TRUE,
                          incluir_programa = TRUE,
                          incluir_preparacion = TRUE) {

  if (!requireNamespace("quarto", quietly = TRUE)) {
    stop("Instala el paquete 'quarto': install.packages('quarto')")
  }
  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Instala el paquete 'yaml': install.packages('yaml')")
  }

  # `semanas` es un alias retrocompatible de `unidades` -- mismo filtro,
  # nombre viejo de cuando el argumento seleccionaba semanas de calendario
  # en vez de unidades de contenido (ver Actualización 16 del plan de
  # matematica-economistas, y la migración equivalente de estadistica).
  # Ninguna materia del repo lo necesita hoy, pero se mantiene por si
  # algún script viejo lo usa.
  if (!is.null(semanas)) {
    if (!is.null(unidades)) {
      stop("Pasá 'unidades' o 'semanas', no ambos (son el mismo filtro; ",
           "'semanas' es un alias retrocompatible de 'unidades').")
    }
    message("'semanas' es un alias retrocompatible de 'unidades' -- ",
            "funcionan igual, preferí 'unidades' en código nuevo.")
    unidades <- semanas
  }

  ruta_materia <- file.path("materias", materia)
  periodo <- paste0(anio, "-C", cuatri)
  ruta_curso <- file.path(ruta_materia, "cursos", universidad, periodo)
  ruta_variables <- file.path(ruta_curso, "_variables.yml")

  if (!file.exists(ruta_variables)) {
    stop("No existe ", ruta_variables, ". Corre nuevo_curso() primero.")
  }

  vars <- yaml::read_yaml(ruta_variables)
  if (!is.null(vars$feriados)) vars$feriados <- unlist(vars$feriados)
  # `_variables.yml` puede tener guardado "unidades:" (cursos nuevos) o
  # "semanas:" (cursos viejos, ej. estadistica) -- se acepta cualquiera
  # de los dos nombres del campo, mismo significado.
  if (!is.null(vars$unidades)) vars$unidades <- unlist(vars$unidades)
  if (!is.null(vars$semanas))  vars$semanas  <- unlist(vars$semanas)
  unidades_guardadas <- if (!is.null(vars$unidades)) vars$unidades else vars$semanas

  if (is.null(unidades) && !is.null(unidades_guardadas)) {
    unidades <- unidades_guardadas
    message("Usando el subconjunto de unidades guardado en _variables.yml: ",
            paste(unidades, collapse = ", "))
  }

  # `formato` (opcional): modalidad del curso cuando un .qmd de la materia
  # declara un params$formato propio (ej. programa.qmd de
  # matematica-economistas, con valores "10-sesiones"/"15-sesiones"). NO
  # es específico de ningún .qmd, es solo un valor más que se inyecta vía
  # el mecanismo general de abajo (parametros_declarados + vars_archivo) en
  # cualquier archivo que lo declare en su propio params:. Un curso "recuerda"
  # su formato guardándolo en _variables.yml; pasar `formato` acá pisa ese
  # valor para este render puntual (mismo patrón que `unidades` arriba), sin
  # modificar el archivo.
  if (!is.null(formato)) {
    vars$formato <- formato
  }
  if (!is.null(vars$formato)) {
    message("Formato del curso: ", vars$formato)
  }

  salida <- ruta_curso
  dir.create(salida, recursive = TRUE, showWarnings = FALSE)

  # Las 3 subcarpetas de salida (ver header de este archivo). nuevo_curso()
  # ya las crea al crear el curso -- esto es un refuerzo por si el curso es
  # de antes de esta convención, o si alguien creó la carpeta a mano.
  for (sub in c("presentaciones", "documentos", "laboratorios")) {
    dir.create(file.path(salida, sub), recursive = TRUE, showWarnings = FALSE)
  }

  content_dir <- file.path(ruta_materia, "content")

  # `carpeta_contenido` (opcional, en _variables.yml): permite que un curso
  # use una carpeta de contenido distinta a "unidades"/"preparacion". Ya
  # no la usa ninguna materia del repo -- estadistica usó una carpeta
  # "sesiones-10" con contenido fusionado por sesión hasta su migración a
  # unidades granulares (retirada, ver claude/plan-estadistica.md; el
  # contenido viejo quedó en _to_delete/estadistica-sesiones-10-viejo/) --
  # pero el mecanismo se deja disponible por si hace falta a futuro (ambos
  # tipos de archivo, presentacion/guia, se distinguen por su sufijo de
  # nombre, así que funcionan igual estén en una carpeta compartida o en
  # dos carpetas separadas). Sin `carpeta_contenido`, se usa "unidades" si
  # existe esa carpeta, o "semanas" como último recurso (esquema viejo).
  carpeta_contenido_default <- if (dir.exists(file.path(content_dir, "unidades"))) "unidades" else "semanas"
  carpeta_unidades <- if (!is.null(vars$carpeta_contenido)) vars$carpeta_contenido else carpeta_contenido_default
  carpeta_preparacion_efectiva <- if (!is.null(vars$carpeta_contenido)) vars$carpeta_contenido else "preparacion"

  fuentes_unidades <- list.files(file.path(content_dir, carpeta_unidades),
                                  pattern = "-presentacion\\.qmd$", full.names = TRUE)

  # Filtro numérico compartido por presentaciones y guías: el número de
  # unidad es el primer número que aparece en el nombre del archivo (ej.
  # "0_intro-presentacion.qmd" -> 0, "unidad-7-...-presentacion.qmd" -> 7).
  # Se aplica a `fuentes_unidades` y, más abajo, a `fuentes_preparacion` --
  # antes solo filtraba las presentaciones, así que incluir_preparacion =
  # TRUE siempre traía TODAS las guías sin importar `unidades`.
  filtrar_por_unidades <- function(archivos, unidades, tipo) {
    if (is.null(unidades) || length(archivos) == 0) return(archivos)
    numeros <- as.integer(regmatches(
      basename(archivos),
      regexpr("[0-9]+", basename(archivos))
    ))
    encontrados <- archivos[numeros %in% unidades]

    faltantes <- setdiff(unidades, numeros)
    if (length(faltantes) > 0) {
      warning("No se encontró archivo de ", tipo, " para: ",
              paste(faltantes, collapse = ", "))
    }
    encontrados
  }

  fuentes_unidades <- filtrar_por_unidades(fuentes_unidades, unidades, "unidad (presentación)")

  fuentes_tareas <- if (incluir_tareas) {
    list.files(file.path(content_dir, "tareas"), pattern = "\\.qmd$", full.names = TRUE)
  } else character(0)

  # `incluir_docs` / `incluir_programa` -- separados a pedido del usuario:
  # el programa del curso (programa.qmd, el documento institucional que se
  # comparte con estudiantes) se controla aparte del resto de content/docs/
  # (ej. guia-lecturas.qmd), porque suele necesitarse renderizar solo
  # cuando el resto del contenido no cambió.
  ruta_docs <- file.path(content_dir, "docs")
  ruta_programa <- file.path(ruta_docs, "programa.qmd")

  fuentes_docs <- if (incluir_docs) {
    todos_docs <- list.files(ruta_docs, pattern = "\\.qmd$", full.names = TRUE)
    todos_docs[basename(todos_docs) != "programa.qmd"]
  } else character(0)

  fuentes_programa <- if (incluir_programa && file.exists(ruta_programa)) {
    ruta_programa
  } else character(0)

  fuentes_preparacion <- if (incluir_preparacion) {
    todas_guias <- list.files(file.path(content_dir, carpeta_preparacion_efectiva), pattern = "-guia\\.qmd$", full.names = TRUE)
    filtrar_por_unidades(todas_guias, unidades, "unidad (guía)")
  } else character(0)

  # Cada fuente sabe a qué subcarpeta de salida va (ver header del archivo):
  # unidades + guías docente -> "presentaciones"; programa + resto de docs
  # + tareas (evaluaciones) -> "documentos". Nada rinde a "laboratorios"
  # todavía -- la carpeta se crea igual, ver más arriba.
  fuentes <- c(fuentes_unidades, fuentes_preparacion,
               fuentes_docs, fuentes_programa, fuentes_tareas)
  subcarpeta_de <- c(
    rep("presentaciones", length(fuentes_unidades)),
    rep("presentaciones", length(fuentes_preparacion)),
    rep("documentos",     length(fuentes_docs)),
    rep("documentos",     length(fuentes_programa)),
    rep("documentos",     length(fuentes_tareas))
  )

  if (length(fuentes) == 0) {
    stop("No hay nada que renderizar con estos filtros (revisa 'unidades', ",
         "'incluir_tareas', 'incluir_docs', 'incluir_programa', 'incluir_preparacion').")
  }

  # La slide de título nativa de reveal.js de cada archivo de unidad SOLO
  # muestra title + subtitle (nombre del curso + contenido de la
  # sesión) — a pedido explícito, sin autor ni fecha/universidad/
  # cuatrimestre. Por eso ya no se inyecta ningún "metadata" de
  # author/date desde acá: title/subtitle viven literales en el YAML
  # de cada archivo (fijos por materia/unidad, no por curso), y no
  # hace falta nada que cambie por curso en esta slide.

  for (i in seq_along(fuentes)) {
    archivo <- fuentes[i]
    subcarpeta <- subcarpeta_de[i]
    message("Renderizando: ", archivo)

    declarados <- parametros_declarados(archivo)
    vars_archivo <- vars[intersect(names(vars), declarados)]

    if (length(vars_archivo) == 0) {
      quarto::quarto_render(input = archivo, as_job = FALSE)
    } else {
      quarto::quarto_render(input = archivo, execute_params = vars_archivo, as_job = FALSE)
    }

    html_generado <- sub("\\.qmd$", ".html", archivo)

    # El nombre de archivo de origen lleva el número de unidad
    # ("N_<tematica>-presentacion.qmd") solo para que
    # render_curso(unidades = ...) pueda filtrarlo por ese número -- es
    # un dato de orden interno, no algo que tenga significado en el
    # curso real (la unidad 25 de la carpeta de contenido puede no
    # existir como "unidad 25" en ningún programa concreto). El HTML
    # final que se comparte con estudiantes/docentes NO debe mostrar
    # ese número: se le quita el prefijo al nombre de archivo de
    # salida, dejando solo la temática (+ sufijo
    # "-presentacion"/"-guia"). Archivos especiales sin número
    # (intro-, repaso-, investigacion-final-, etc., del esquema viejo)
    # no tienen ese prefijo y quedan igual.
    nombre_salida <- sub("^(unidad-[0-9]+-|[0-9]+_)", "", basename(html_generado))
    html_destino  <- file.path(salida, subcarpeta, nombre_salida)

    if (file.exists(html_generado)) {
      file.rename(html_generado, html_destino)
    } else {
      warning("No se encontró el HTML esperado para ", archivo)
    }
  }

  message("\nCurso '", materia, " / ", universidad, " ", periodo, "' renderizado en: ", salida)
  message("Organizado en subcarpetas: presentaciones/, documentos/, laboratorios/.")
  message("Estos archivos .html son autocontenidos (embed-resources: true) ",
          "y listos para compartir directamente.")
  message("Nunca quedan .html sueltos dentro de content/ — si ves uno ahí, ",
          "es un residuo de una prueba manual y se puede borrar.")

  invisible(salida)
}
