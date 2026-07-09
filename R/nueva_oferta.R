# R/nueva_oferta.R
#
# Crea una nueva "oferta" (una combinación universidad + cuatrimestre)
# generando su archivo de parámetros en ofertas/<universidad>/<periodo>/_variables.yml
#
# Esto es TODO lo que hay que crear a mano cada cuatri — nunca se duplica
# contenido de content/.
#
# Ejemplo de uso:
#   source("R/nueva_oferta.R")
#   nueva_oferta(
#     universidad  = "UCR",
#     anio         = 2026,
#     cuatri       = 1,
#     fecha_inicio = "2026-01-19",
#     feriados     = c("2026-04-03", "2026-05-01"),
#     logo_path    = "images/logos/ucr.png"
#   )

nueva_oferta <- function(universidad,
                          anio,
                          cuatri,
                          fecha_inicio,
                          feriados = character(0),
                          profesor = "Fabián Brenes",
                          logo_path = NULL) {

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Instala el paquete 'yaml': install.packages('yaml')")
  }

  periodo <- paste0(anio, "-C", cuatri)
  carpeta <- file.path("ofertas", universidad, periodo)
  dir.create(carpeta, recursive = TRUE, showWarnings = FALSE)

  if (is.null(logo_path)) {
    logo_path <- file.path("images/logos", paste0(tolower(universidad), ".png"))
  }

  variables <- list(
    universidad  = universidad,
    anio         = anio,
    cuatri       = cuatri,
    fecha_inicio = fecha_inicio,
    feriados     = as.list(feriados),
    profesor     = profesor,
    logo_path    = logo_path
  )

  ruta_salida <- file.path(carpeta, "_variables.yml")
  yaml::write_yaml(variables, ruta_salida)

  message("Oferta creada: ", ruta_salida)
  if (!file.exists(logo_path)) {
    message("Recuerda colocar el logo en: ", logo_path)
  }

  invisible(carpeta)
}
