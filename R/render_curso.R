# R/render_curso.R
#
# Renderiza todas las semanas, tareas y docs de materias/<materia>/content/
# para UN curso específico (universidad + periodo), inyectando sus
# parámetros y dejando los HTML autocontenidos listos para compartir en
# _output/<materia>/<universidad>/<periodo>/
#
# Ejemplo de uso:
#   source("R/render_curso.R")
#   render_curso(materia = "estadistica", universidad = "UCR", anio = 2026, cuatri = 1)

render_curso <- function(materia = "estadistica", universidad, anio, cuatri) {

  if (!requireNamespace("quarto", quietly = TRUE)) {
    stop("Instala el paquete 'quarto': install.packages('quarto')")
  }
  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Instala el paquete 'yaml': install.packages('yaml')")
  }

  ruta_materia <- file.path("materias", materia)
  periodo <- paste0(anio, "-C", cuatri)
  ruta_variables <- file.path(ruta_materia, "cursos", universidad, periodo, "_variables.yml")

  if (!file.exists(ruta_variables)) {
    stop("No existe ", ruta_variables, ". Corre nuevo_curso() primero.")
  }

  vars <- yaml::read_yaml(ruta_variables)
  # yaml::read_yaml devuelve las fechas de feriados como lista; quarto_render
  # espera un vector plano si el .qmd lo va a usar como tal.
  if (!is.null(vars$feriados)) vars$feriados <- unlist(vars$feriados)

  salida <- file.path("_output", materia, universidad, periodo)
  dir.create(salida, recursive = TRUE, showWarnings = FALSE)

  content_dir <- file.path(ruta_materia, "content")
  fuentes <- c(
    list.files(file.path(content_dir, "semanas"), pattern = "\\.qmd$", full.names = TRUE),
    list.files(file.path(content_dir, "tareas"),  pattern = "\\.qmd$", full.names = TRUE),
    list.files(file.path(content_dir, "docs"),    pattern = "\\.qmd$", full.names = TRUE)
  )

  for (archivo in fuentes) {
    message("Renderizando: ", archivo)

    quarto::quarto_render(input = archivo, execute_params = vars, as_job = FALSE)

    html_generado <- sub("\\.qmd$", ".html", archivo)
    html_destino  <- file.path(salida, basename(html_generado))

    if (file.exists(html_generado)) {
      file.rename(html_generado, html_destino)
    } else {
      warning("No se encontró el HTML esperado para ", archivo)
    }
  }

  message("\nCurso '", materia, " / ", universidad, " ", periodo, "' renderizado en: ", salida)
  message("Estos archivos .html son autocontenidos (embed-resources: true) ",
          "y listos para compartir directamente.")

  invisible(salida)
}
