
rm(list = ls())

#libs-----------
library(tidyverse)
library(ggplot2)
library(haven)
library(scales)

ece2025 <- read_sav(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/III Cuatrimestre/Clases/4/II Trimestre 2025.sav")

#Gráfico de densidad de la variable ingreso
ece2025 |> 
  ggplot(aes(x = Ingreso_total)) +
  geom_density()

#Estadísticas descriptivas

#Calculo del intervalo de confianza para variable ingreso total-------------



