rm(list = ls())

#Libs----------
library(tidyverse)
library(ggplot2)

#Seleccionar datos-----
load(file = "ruta/datos_bccr.rdata")

#Parte 1-----------------
data <- datos_bccr |> 
  filter(id == "87961", Fecha > "2023-01-01") 


# Parte 2: Calcular estadísticas descriptivas

stats <- data |> 
  summarise(
    media = mean(),
    mediana = median(),
    varianza = var(),
    desv.est = sd(),
    Coef.Var = desv.est / media
)

# Parte 3: Gráfico de cajas por periodo

data |> 
  mutate(Periodo = factor(year(Fecha))) |> 
  ggplot(aes(x = Valor, y = Periodo)) + 
  geom_boxplot(aes(fill = Periodo), alpha = 2 /3 )


#Extra: Graficar serie

data |> 
  ggplot(aes(x = , y = )) + 
  geom_line()