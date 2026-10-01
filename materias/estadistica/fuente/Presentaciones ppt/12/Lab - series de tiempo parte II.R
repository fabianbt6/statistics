rm(list = ls())

#Libs------
library(tidyverse)
library(lubridate)
library(ggplot2)
library(readxl)
library(scales)
library(tseries)
library(urca)
library(forecast)

#Datos-----
data_pibr <- read_xlsx("C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/II Cuatrimestre/Clases/12/PIBr.xlsx", 
                   sheet = "Data") |> 
  mutate(Fecha = as.Date(Fecha, origin = "1899-12-30"))

data_tc <- read_xlsx(path = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/I Cuatrimestre/Clases/12/Tipo de Cambio.xlsx", 
                  sheet = "Data") |> 
  mutate(Fecha = as.Date(Fecha, origin = "1899-12-30"),
         Año = year(Fecha),
         Fin_mes = ifelse(Fecha == ceiling_date(ymd(Fecha), 'month') - days(1), 
                          T, F)) |> 
  filter(Año >= 2015, 
         Fin_mes == T) |> 
  select(Fecha, `Tipo de Cambio`)

data_ipc <- read_xlsx(path = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/II Cuatrimestre/Clases/5/Data lab repaso.xlsx",
                           sheet = "Hoja2") |>
  mutate(Fecha = as.Date(Fecha, origin = "1899-12-30")) |> 
  select(Fecha, IPC)
 
#Descomposición de series de tiempo-----------

pibr_ts <- ts(data_pibr$PIBr, start = c(1991, 1), frequency = 4)

str(pibr_ts)

pibr_comps <- pibr_ts |> 
  stl(t.window = NULL, s.window = "periodic", robust = TRUE) 

pibr_comps |> autoplot()
pibr_res <- pibr_comps$time.series[, 3]

plot(pibr_res)

acf(pibr_res)
summary(ur.df(pibr_res, type = "trend", selectlags = "AIC"))

data_tc |>
  ggplot(aes(x = Fecha, y = `Tipo de Cambio`)) +
  geom_line()

tc_ts <- ts(data_tc$`Tipo de Cambio`, start = c(2015, 1), frequency = 12)

tc <- data_tc |>
  filter(Fecha <= "2021-12-31") 

tc |> 
 ggplot(aes(x = Fecha, y = `Tipo de Cambio`)) + geom_line() 


tc_ts <- ts(tc$`Tipo de Cambio`, start = c(2015, 1), frequency = 12)
  
tc_comps <- tc_ts |> 
  stl(t.window = NULL, s.window = "periodic", robust = TRUE) 

tc_comps |> autoplot()
  
tc_comps

residuo_tc <- tc_comps$time.series[, 3]

plot(residuo_tc)

acf(residuo_tc)
summary(ur.df(residuo_tc, type = "none", selectlags = "AIC"))

rnorm(1000, 0, 1) |> 
  acf() 


xnorm <- tibble(n = 1:100, 
)  |> 
  ggplot()

#Regresión Espuria-----------

data_reg <- 
  data_pibr |> 
  left_join(data_ipc, by = "Fecha")

#Estacionarierad de las series
#PIBr es integrado de orden 1
summary(ur.df(data_reg$PIBr, type = "drift", selectlags = "AIC")) 
acf(data_reg$PIBr)
summary(ur.df(diff(data_reg$PIBr), type = "trend", selectlags = "AIC" ))
acf(diff(data_reg$PIBr))

#IPC es integrado de orden 1
summary(ur.df(data_reg$IPC, type = "drift", selectlags = "AIC")) 
summary(ur.df(diff(data_reg$IPC), type = "drift", selectlags = "AIC" ))
acf(data_reg$IPC)
acf(diff(data_reg$IPC))

#Análisis descriptivo
cor(data_reg$PIBr, data_reg$IPC)

#Gráficos de las series
data_reg |> 
  mutate(
    pibr_z = scale(PIBr)[, 1], 
    ipc_z = scale(IPC)[, 1]
) |> 
  select(Fecha, pibr_z, ipc_z) |> 
  pivot_longer(-Fecha, names_to = "Indicador", values_to = "Valor") |> 
  ggplot(aes(x = Fecha, y = Valor, colour = Indicador)) + 
  geom_line()
 
#Modelo de regresion

mod1 <- lm(PIBr ~ IPC, data = data_reg) 

summary(mod1)

#Orden de integración del residuo
summary(ur.df(mod1$residuals, type = "none", selectlags = "AIC")) 
acf(mod1$residuals)

summary(ur.df(diff(mod1$residuals), type = "none", selectlags = "AIC")) 
acf(diff(mod1$residuals))
