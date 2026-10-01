rm(list = ls())

#Libs-----------
library(tidyverse)
library(ggplot2)
library(lmtest)
library(lubridate)
library(readxl)

#Preparar data-----------
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

data_WB <- read_xlsx(path = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/III Cuatrimestre/Clases/15/DATOS.xlsx", 
          sheet = "Hoja1") |> 
  mutate(
    Fecha1 = as.Date(Fecha, origin = "1899-12-30"), 
    Fecha = ceiling_date(Fecha1, unit = "month") - 1
  ) |> 
  select(-Fecha1)
  
  
datos_bccr_g1 <- datos_bccr |> 
  filter(id == "317" | id == "89638") |> 
  mutate(Fin_mes = Fecha == lubridate::ceiling_date(Fecha, unit = "month") - 1) |> 
  filter(Fin_mes == TRUE) |> 
  filter(Fecha >= "2015-01-01") |> 
  select(Fecha, Serie, Valor) |> 
  pivot_wider(id_cols = Fecha, names_from = Serie, values_from = Valor)

datos_g1 <- datos_bccr_g1 |> 
  left_join(data_WB)

#Calcular tasas de variación---------------------

datos_tc <- datos_g1 |> 
  select(Fecha, `Tipo cambio compra`) |> 
  mutate(Fecha_referencia = add_with_rollback(Fecha, -months(12))) 
datos_tc_yoy <- left_join(x = datos_tc, y = datos_tc, by = join_by(Fecha_referencia == Fecha)) |> 
  mutate("Tipo de Cambio YoY" = (`Tipo cambio compra.x` / `Tipo cambio compra.y` - 1)  * 100) |> 
  select(Fecha, `Tipo de Cambio YoY`)

datos_crudo <- datos_g1 |> 
  select(Fecha, `Crudo`) |> 
  mutate(Fecha_referencia = add_with_rollback(Fecha, -months(12))) 
datos_crudo_yoy <- left_join(x = datos_crudo, y = datos_crudo, by = join_by(Fecha_referencia == Fecha)) |> 
  mutate("Crudo YoY" = (`Crudo.x` / `Crudo.y` - 1) * 100) |> 
  select(Fecha, `Crudo YoY`)

datos_granos <- datos_g1 |> 
  select(Fecha, `Granos`) |> 
  mutate(Fecha_referencia = add_with_rollback(Fecha, -months(12)))
datos_granos_yoy <- left_join(x = datos_granos, y = datos_granos, by = join_by(Fecha_referencia == Fecha)) |> 
  mutate("Granos YoY" = (`Granos.x` / `Granos.y` - 1) * 100) |> 
  select(Fecha, `Granos YoY`)

datos_covariables <-  datos_tc_yoy |> 
  left_join(datos_crudo_yoy) |> 
  left_join(datos_granos_yoy)

datos_grupo1 <- datos_bccr_g1 |> 
  select(Fecha, `IPC, variación interanual (%)`) |> 
  left_join(datos_covariables)

save(datos_grupo1, 
  file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/III Cuatrimestre/Clases/15/datos_grupo1.Rdata")

#estimación del modelo
modelo1 <- lm( `IPC, variación interanual (%)` ~ `Tipo de Cambio YoY` +  `Crudo YoY` + `Granos YoY`, data = datos_grupo1)

summary(modelo1)

#Diagnóstico del modelo

#Multicolinealidad
datos_covariables |>
  select(-Fecha) |> 
  na.omit() |> 
  cor() |> 
  round(4)

#Heterocedasticidad
bptest(modelo1) #H0: Residuo es homocedástico

#Autocorrelación
bgtest(modelo1, order = 1) #H0: Residuo no tiene autocorrelación

#Normalidad en los residuos
modelo1$residuals |> 
  ggplot(aes(x = residuo)) +
  geom_histogram()

shapiro.test(modelo1$residuals) #H0: Residuo sigue una distribución normal