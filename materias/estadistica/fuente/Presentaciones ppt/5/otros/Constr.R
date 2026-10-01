rm(list = ls())

#Libs---------------
library(tidyverse)
library(ggplot2)

#Datos-----------
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

#filtar por PIB Cons---------

datos_PIB_cons <- datos_bccr |> 
  filter(
    id == "97473", 
    Fecha >= "2015-01-01"
  ) |> 
  mutate(
    Valores_Estandarizados = scale(Valor),
    Valor_Extremo = ifelse(abs(Valores_Estandarizados) > 1.9, T, F) 
  )

datos_PIB_cons |> 
  filter(Valor_Extremo == T)

#Gráficos--------------
#Graficos de la serie
datos_PIB_cons |> 
  ggplot(aes(x = Fecha, y = Valor)) + 
  geom_line()

#Gráfico de Densidad
datos_PIB_cons |> 
  ggplot(aes(x = Valor)) + 
  geom_density()

