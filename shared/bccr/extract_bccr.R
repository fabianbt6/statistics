# extract_bccr.R
#
# Pipeline de descarga de indicadores economicos del BCCR (API SDDE) para
# uso en los cursos de Habitat_LAC. Este script se comparte directamente
# con estudiantes -- por eso NUNCA debe contener credenciales en texto
# plano. La API key se lee de una variable de entorno (ver abajo).
#
# --- Configuracion inicial (una sola vez por maquina) ------------------
#
# 1. Abri tu .Renviron personal:
#      install.packages("usethis")  # si no lo tenes
#      usethis::edit_r_environ()
#
# 2. Agrega esta linea (con tu API key real del BCCR) y guarda el archivo:
#      BCCR_API_KEY=eyJhbGciOiJIUzI1NiIs...
#
# 3. Reiniciando la sesion de R (o corriendo `.rs.restartR()` /
#    reiniciando Positron), la variable queda disponible para este y
#    cualquier otro script sin volver a escribirla.
#
# El .Renviron vive fuera del repo (en tu carpeta de usuario), asi que
# nunca se sube a git ni se comparte con nadie al compartir esta carpeta.
# -------------------------------------------------------------------------

#libs-------------------
library(tidyverse)
library(httr2)
library(jsonlite)
library(glue)
library(readxl)
library(purrr)
library(lubridate)
library(here)
library(arrow)  # para guardar en formato parquet

#Credenciales (desde variable de entorno, nunca en el codigo)----------
api_key <- Sys.getenv("BCCR_API_KEY")

if (identical(api_key, "")) {
  stop(
    "Falta la variable de entorno BCCR_API_KEY.\n",
    "Configurala con usethis::edit_r_environ() -- ver instrucciones al ",
    "inicio de este script -- y reinicia R antes de volver a correrlo."
  )
}

base_url <- "https://apim.bccr.fi.cr/SDDE"

#Comandos personalizados----------
request_bccr <- function(url, token) {
  request(url) |>
  req_auth_bearer_token(token) |>
  req_headers("Accept" = "application/json")
}

get_data_bccr <- function(cod, fechaFin) {

  endpoint <- "/api/Bccr.GE.SDDE.Publico.Indicadores.API/indicadoresEconomicos/{cod}/series?fechaInicio=1987%2F01%2F31&fechaFin={fecha_final}&idioma=es"
  url <- glue(base_url, endpoint)

  request_bccr(url, api_key) |>
  req_perform() |>
  resp_body_json() |>
  unlist() |>
  as_tibble() |>
  mutate(Serie = value[4]) |>
  slice(-c(1:4)) |>
  mutate(
    Index = row_number(),
    Tipo = ifelse(Index %% 2 == 0, "Valor", "Fecha"),
    id  = ifelse(Tipo == "Valor", Index - 1, Index)
) |>
  select(-Index) |>
  pivot_wider(id_cols = c(id, Serie), names_from = Tipo, values_from = value) |>
  mutate(Valor = as.numeric(Valor))  |>
  drop_na(Valor) |>
  select(-id)
}

# Version segura de get_data_bccr(): si un indicador falla (por ejemplo,
# un codigo que ya no existe o un problema de red puntual), avisa cual
# fallo y por que, pero no interrumpe la descarga de los demas.
get_data_bccr_segura <- possibly(
  get_data_bccr,
  otherwise = NULL,
  quiet = FALSE
)

#variables globales------------------
fecha_final <- str_replace_all(format(today(), "%Y/%m/%d"), "/", "%2F")

indicadores <- tibble(
  id = c(
    "317",   #Tipo de Cambio de Compra"
    "87031",
    "87703",
    "87961",
    "3541",  #TPM diaria
    "423",   #TBP diaria
    "89638", #Inflacion
    "23630", #Desempleo
    "38208", #Exportaciones FOB Regimen Definitivo)
    "94967", #IMAE Construccion
    "97473", #PIB Construccion YoY
    "23999", # CC BP
    "96993",  # PIB Nominal en USD
    "25243", # CUENTA CORRIENTE
    "3044",  # Reservas Internacionales netas
    "94931",  #IMAE Serie original
    "94990", #IMAE Regimen Especial
    "94992" #Regimen definitivo
  ))

#Extraccion de la data------------
resultado <- indicadores |>
  mutate(
    data = map(
      id,
      ~ get_data_bccr_segura(
        cod = .x,
        fechaFin = fecha_final
      )
    )
  )

indicadores_fallidos <- resultado |> filter(map_lgl(data, is.null)) |> pull(id)
if (length(indicadores_fallidos) > 0) {
  warning(
    "No se pudieron descargar estos indicadores (revisa el codigo o tu ",
    "conexion): ", paste(indicadores_fallidos, collapse = ", ")
  )
}

datos_bccr <- resultado |>
  filter(!map_lgl(data, is.null)) |>
  unnest(data) |>
  mutate(Fecha = ymd(Fecha))

#Verificacion rapida (un valor conocido, para confirmar que la descarga tiene sentido)------------
datos_bccr |>
  filter(id == "25243" & Fecha == "2025-12-31") |>
  print()

#Guardado------------
# Ruta relativa a la raiz del repo (funciona igual en cualquier maquina
# donde clones el repo, sin depender de una ruta fija de OneDrive).
salida_dir <- here("shared", "bccr")
dir.create(salida_dir, recursive = TRUE, showWarnings = FALSE)
salida_parquet <- file.path(salida_dir, "datos_bccr.parquet")

# Parquet: formato columnar, comprimido y legible desde R, Python, etc.
# Para leerlo: datos_bccr <- arrow::read_parquet(here("shared", "bccr", "datos_bccr.parquet"))
write_parquet(datos_bccr, salida_parquet)
message("Datos guardados en: ", salida_parquet)
