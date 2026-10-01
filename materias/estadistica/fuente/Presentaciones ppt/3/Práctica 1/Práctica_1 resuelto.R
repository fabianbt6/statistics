rm(list = ls())

#Libs----------
library(tidyverse)
library(ggplot2)

#Seleccionar datos-----
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

data <- datos_bccr |> 
  filter(id == "87961", Fecha > "2023-01-01") 

#Pregunta 1: Graficar serie

data |> 
  ggplot(aes(x = Fecha, y = Valor)) + 
  geom_line()

# Pregunta 2: Calcular estadísticas descriptivas

stats <- data |> 
  summarise(
    media = mean(Valor),
    mediana = median(Valor),
    varianza = var(Valor),
    desv.est = sd(Valor),
    Coef.Var = desv.est / media
)

# Pregunta 3: Gráfico de cajas por periodo

data |> 
  mutate(Periodo = factor(year(Fecha))) |> 
  ggplot(aes(x = Valor, y = Periodo)) + 
  geom_boxplot(aes(fill = Periodo), alpha = 2 /3 )

