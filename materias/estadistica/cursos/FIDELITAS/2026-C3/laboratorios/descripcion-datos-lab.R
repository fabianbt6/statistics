
#libs---------
library(tidyverse)
library(ggplot2)
library(scales)

#Cargar datos--------
datos_bccr <- arrow::read_parquet(here::here("shared/bccr", "datos_bccr.parquet"))

rin <- datos_bccr |>
  filter(id == '3044') |> 
  select(-id)

#Calculo de variables descriptivas-------
median(rin$Valor)
mean(rin$Valor)

descriptivos <- 
  rin |> 
  summarize(
    promedio = mean(Valor), 
    median = median(Valor), 
    desv.st = sd(Valor), 
    Max = max(Valor), 
    Min = min(Valor),
    CV = desv.st / promedio
  )

#Gráfico-----------
rin |> 
  ggplot(aes(Fecha, Valor)) + 
  geom_line(color = 'blue')
