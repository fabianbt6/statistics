# R/render_oferta.R
#
# Renderiza todas las semanas, tareas y docs de content/ para UNA oferta
# específica (universidad + periodo), inyectando sus parámetros y dejando
# los HTML autocontenidos listos para compartir (sin depender de un link
# público) en _output/<universidad>/<periodo>/
#
# Ejemplo de uso:
#   source("R/render_oferta.R")
#   render_oferta(universidad = "UCR", anio = 2026, cuatri = 1)

render_oferta <- function(universidad, anio, cuatri) {

  if (!requireNamespace("quarto", quietly = TRUE)) {
    stop("Instala el paquete 'quarto': install.packages('quarto')")
  }
  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Instala el paquete 'yaml': install.packages('yaml')")
  }

  periodo <- paste0(anio, "-C", cuatri)
  ruta_variables <- file.path("ofertas", universidad, periodo, "_variables.yml")

  if (!file.exists(ruta_variables)) {
    stop("No existe ", ruta_variables, ". Corre nueva_oferta() primero.")
  }

  vars <- yaml::read_yaml(ruta_variables)
  # yaml::read_yaml devuelve las fechas de feriados como lista; quarto_render
  # espera un vector plano si el .qmd lo va a usar como tal.
  if (!is.null(vars$feriados)) vars$feriados <- unlist(vars$feriados)

  salida <- file.path("_output", universidad, periodo)
  dir.create(salida, recursive = TRUE, showWarnings = FALSE)

  fuentes <- c(
    list.files("content/semanas", pattern = "\\.qmd$", full.names = TRUE),
    list.files("content/tareas",  pattern = "\\.qmd$", full.names = TRUE),
    list.files("content/docs",    pattern = "\\.qmd$", full.names = TRUE)
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

  message("\nOferta '", universidad, " ", periodo, "' renderizada en: ", salida)
  message("Estos archivos .html son autocontenidos (embed-resources: true) ",
          "y listos para compartir directamente.")

  invisible(salida)
}
