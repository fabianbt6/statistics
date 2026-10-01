rm(list = ls())

#Libs---------------
library(tidyverse)
library(ggplot2)

#Datos-----------
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

#filtar por Inflación---------
infl <- datos_bccr |> 
  filter(
    id == "89638", 
    Fecha >= "2000-01-01"
  ) 

#Estadísticas descriptivas--------
infl |> 
  summarise(
    Promedio = mean(Valor),
    Mediana = median(Valor), 
    Mínimo = min(Valor),
    Máximo = max(Valor),
    Desv.Est = sd(Valor), 
    Coef.Var = Desv.Est / Promedio 
)

#Gráfico de líneas---------

infl |> 
  ggplot(aes(x = Fecha, y = Valor)) +
  geom_line()

#Agregar campo para identificar inicio esquema metas de inflación----

infl <- infl |>
  mutate(Esquema = ifelse(Fecha > "2008-01-01", "Metas de Inflación", "Minidevaluaciones"))

#Estadísticas descriptivas por régimen----------------

infl |> 
  group_by(Esquema) |> 
    summarise(
    Promedio = mean(Valor),
    Mediana = median(Valor), 
    Mínimo = min(Valor),
    Máximo = max(Valor),
    Desv.Est = sd(Valor), 
    Coef.Var = Desv.Est / Promedio 
)

 infl |> 
   ggplot(aes(x = Fecha, y = Valor, color = Esquema)) +
   geom_line()

 infl |> 
   ggplot(aes(x = Valor, fill = Esquema)) +
   geom_density(alpha = 2/3) +
   facet_grid(~ Esquema) + 
   theme(legend.position = "none")
