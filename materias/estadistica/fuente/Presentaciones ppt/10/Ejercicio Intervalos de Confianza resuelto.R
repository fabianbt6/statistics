
rm(list = ls())

#libs-----------
library(tidyverse)
library(ggplot2)
library(readxl)
library(BSDA)
library(haven)
library(scales)

ece2025 <- read_sav(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/III Cuatrimestre/Clases/4/II Trimestre 2025.sav")

write.csv(ece2025, file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/2025/III Cuatrimestre/Clases/4/II Trimestre 2025.csv")

ece2025 |> 
  ggplot(aes(x = Ingreso_total)) +
  geom_density()

media_muestral <- mean(na.omit(ece2025$Ingreso_total))
s <- sd(na.omit(ece2025$Ingreso_total))
n <- length(na.omit(ece2025$Ingreso_total))
med <- median(na.omit(ece2025$Ingreso_total))
cv <-  s / media_muestral

#Calculo del intervalo de confianza para variable ingreso total-------------

t1 <- qt(0.025, n - 1, lower.tail = T)

qnorm(0.025, 0, 1)

media_muestral + t1 * s / sqrt(n)
media_muestral - t1 * s / sqrt(n)

t.test(ece2025$Ingreso_total, conf.level = 0.95)
