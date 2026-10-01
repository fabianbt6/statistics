rm(list = ls())

#Libs------
library(tidyverse)
library(lubridate)
library(ggplot2)
library(readxl)
library(scales)
library(tseries)
library(urca)

#Datos-----

load("C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

data <- datos_bccr |> 
  filter(id == "87031") |> 
  mutate(Nombre = "PIB")

#Gráficos---
data |> 
  ggplot(aes(x = Fecha, y = Valor)) +
  geom_line(linewidth = 0.55, colour = "darkblue") +
  scale_x_date(
    "Periodo",
    breaks = scales::breaks_width("5 years"), 
    labels = scales::label_date("%Y")
  ) + 
  scale_y_continuous(
    "PIB real",
    labels = scales::label_number(scale_cut = scales::cut_short_scale())) +
  ggtitle(label = "PIB Real Trimestral", 
          subtitle = "Volumen a precios del año anterior encadenado, referencia 2017")

data |>
  filter(Fecha > "2010-01-01") |> 
  group_by(quarter(Fecha)) |> 
  ggplot(aes(x = quarter(Fecha), y = Valor, group = quarter(Fecha))) +
  geom_boxplot()
  
data <- data |> 
  mutate(M2 = stats::filter(Valor, 
                            filter = rep( 1 / 2, 2), 
                            method = "convolution", 
                            sides = 1),    
         M4 = stats::filter(Valor, 
                            filter = rep( 1 / 4, 4), 
                            method = "convolution", 
                            sides = 1)
         ) 

data |>
  select(-c(Serie, Nombre, id)) |> 
  pivot_longer(-Fecha, names_to = "Indicador", values_to = "Valor") |> 
  filter(Indicador != "M4") |> 
  ggplot(aes(x = Fecha, y = Valor, colour = Indicador)) +
  geom_line(linewidth = 0.55) +
  scale_x_date(
    "Periodo",
    breaks = scales::breaks_width("5 years"), 
    labels = scales::label_date("%Y")
  ) + 
  scale_y_continuous(
    "PIB real",
    labels = scales::label_number(scale_cut = scales::cut_short_scale())) +
  ggtitle(label = "PIB Real Trimestral", 
          subtitle = "Volumen a precios del año anterior encadenado, referencia 2017") + 
  theme(legend.position = "bottom")
  
#Autocorrelograma--------

data <- data |> 
  mutate(ruido_blanco = rnorm(n(), 0, 1),
         PIB_lag1 = lag(Valor, 1),
         PIB_lag2 = lag(Valor, 2),
         PIB_diff1 = Valor - PIB_lag1, 
         PIB_diff1_calc = c(NA, diff(data$Valor)))

cor(data$Valor, data$Valor)
cor(data$Valor[-c(1, 2)], data$PIB_lag1[-c(1, 2)])
cor(data$Valor[-c(1, 2)], data$PIB_lag2[-c(1, 2)])

select(data, Fecha, Valor, PIB_lag1, PIB_lag2) |> view()

acf(data$ruido_blanco, plot = T) 
acf(data$Valor, plot = T) 
acf(na.omit(data$PIB_diff1_calc), plot = T) 
  
#Prueba de raíz unitaria

summary(ur.df(data$ruido_blanco, type = "trend", selectlags = "BIC")) #H1: La serie es estacionaria
summary(ur.df(na.omit(data$Valor), type = "trend", selectlags = "BIC")) #H1: La serie es estacionaria
summary(ur.df(na.omit(data$PIB_diff1), type = "drift", selectlags = "AIC")) #H1: La serie es estacionaria

data2000 <- data |> 
  filter(Fecha > "2000-01-01")

summary(ur.df(na.omit(data2000$Valor), type = "trend", selectlags = "BIC")) #H1: La serie es estacionaria
