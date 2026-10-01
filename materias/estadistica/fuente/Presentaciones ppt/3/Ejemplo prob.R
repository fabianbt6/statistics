rm(list = ls())

#Libs--------
library(tidyverse)
library(ggplot2)

#Ejemplo de probs

p <- 0.25

data <- tibble(
  n = c(1:10000),
  freq = 0
)

for(i in 1:nrow(data)) {
  data[i, 2] = sum((rbinom(i, 1, p)))
}

data |> 
  mutate(freq_rel = freq / n) |> 
  ggplot(aes(x = n, y = freq_rel)) +
  geom_point() + 
  geom_hline(yintercept = p, color = "red")
