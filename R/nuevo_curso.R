# R/nuevo_curso.R
#
# Crea un nuevo "curso" (una combinación universidad + cuatrimestre) para
# una materia específica, generando su archivo de parámetros en
# materias/<materia>/cursos/<universidad>/<periodo>/_variables.yml
#
# Esto es TODO lo que hay que crear a mano cada cuatri — nunca se duplica
# contenido de materias/<materia>/content/.
#
# Ejemplo de uso:
#   source("R/nuevo_curso.R")
#   nuevo_curso(
#     materia      = "estadistica",
#     universidad  = "UCR",
#     anio         = 2026,
#     cuatri       = 1,
#     fecha_inicio = "2026-01-19",
#     feriados     = c("2026-04-03", "2026-05-01"),
#     logo_path    = "images/logos/ucr.png"
#   )
#
# `semanas`: la mayoría de las materias siempre usan TODO su contenido
# (todas las semanas que existen en materias/<materia>/content/semanas/),
# así que se deja en NULL y no hace falta tocarlo. Pero una misma materia
# puede impartirse en distintas modalidades según el curso — ej.
# "estadistica" completa (15 semanas) en un curso, y solo 10 sesiones en
# otro porque comparte horario con otra materia ese cuatri. Para esos
# casos, `semanas` guarda el subconjunto real de números de semana que
# ESE curso en particular usa (ej. `semanas = 1:10`), y `render_curso()`
# lo aplica automáticamente sin que haya que pasarlo a mano cada vez —
# ver R/render_curso.R. Decidir CUÁLES semanas/unidades entran en un
# subconjunto reducido es una decisión de contenido (qué se combina o se
# omite), no algo que este script resuelva solo.

nuevo_curso <- function(materia = "estadistica",
                         universidad,
                         anio,
                         cuatri,
                         fecha_inicio,
                         feriados = character(0),
                         docente = "Fabián Brenes",
                         logo_path = NULL,
                         semanas = NULL) {

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Instala el paquete 'yaml': install.packages('yaml')")
  }

  ruta_materia <- file.path("materias", materia)
  if (!dir.exists(ruta_materia)) {
    stop("No existe la materia '", materia, "' en materias/. ",
         "Revisa el nombre o crea la carpeta primero (ver materias/README.md).")
  }

  periodo <- paste0(anio, "-C", cuatri)
  carpeta <- file.path(ruta_materia, "cursos", universidad, periodo)
  dir.create(carpeta, recursive = TRUE, showWarnings = FALSE)

  # Las 3 subcarpetas de salida que usa render_curso() para organizar los
  # HTML renderizados: "presentaciones/" (unidades + guías docente),
  # "documentos/" (programa + resto de content/docs/ + tareas/evaluaciones)
  # y "laboratorios/" (prácticas y labs -- hoy sin fuente en content/ que
  # rinda acá, se crea igual para cuando haga falta). Se crean acá, al
  # crear el curso, para que ya estén listas desde el principio -- ver
  # R/render_curso.R para el detalle de qué va en cada una.
  for (sub in c("presentaciones", "documentos", "laboratorios")) {
    dir.create(file.path(carpeta, sub), recursive = TRUE, showWarnings = FALSE)
  }

  if (is.null(logo_path)) {
    logo_path <- file.path("images/logos", paste0(tolower(universidad), ".png"))
  }

  variables <- list(
    universidad  = universidad,
    anio         = anio,
    cuatri       = cuatri,
    fecha_inicio = fecha_inicio,
    feriados     = as.list(feriados),
    docente     = docente,
    logo_path    = logo_path
  )

  if (!is.null(semanas)) {
    variables$semanas <- as.list(as.integer(semanas))
  }

  ruta_salida <- file.path(carpeta, "_variables.yml")
  yaml::write_yaml(variables, ruta_salida)

  message("Curso creado: ", ruta_salida)
  if (!file.exists(logo_path)) {
    message("Recuerda colocar el logo en: ", logo_path)
  }
  if (!is.null(semanas)) {
    message("Este curso usa solo las semanas: ", paste(semanas, collapse = ", "),
            " — render_curso() las va a tomar automáticamente de _variables.yml.")
  }

  invisible(carpeta)
}
