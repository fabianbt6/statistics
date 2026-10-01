rm(list = ls())

#Libs---------------
library(tidyverse)
library(ggplot2)

#Datos-----------
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

#filtar por PIB Cons---------

cc <- datos_bccr |> 
  filter(
     id == "23999" | id == "96993"
  ) |> 
  select(Serie, Fecha, Valor) |> 
  pivot_wider(id_cols = Fecha, names_from = Serie, values_from = Valor) |> 
  unnest()



#Graficos de la serie

