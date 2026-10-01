
rm(list = ls())


#libs---------------------
library(tidyverse)
library(ggplot2)


#Generar datos-----------

dat <- tibble(
  id = 1:100, 
  chi = rchisq(100, 30), 
  t = rt(100, 30), 
  f = rf(100, 30, 60)
)

dat |> 
  pivot_longer(-id, names_to = "Dist", values_to = "Valor") |> 
  ggplot(aes(x = Valor, fill = Dist)) +
  geom_density() + 
  facet_grid(~ Dist, scales = "free")
