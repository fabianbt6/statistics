rm(list = ls())

#Libs---------------
library(tidyverse)
library(ggplot2)

#Cargar datos-------------
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

#Ejercicio interés de préstamo------------
bancos <- c("A", "B", "C", "D", "E", "F", "G")
share <- c(0.10, 0.20, 0.15, 0.14, 0.17, 0.04, 0.20)
ints <- c(0.25, 0.05, 0.30, 0.15, 0.07, 0.14, 0.07) 

#Cálculo manual
prob_tot1 <- share[1] * ints[1] + share[2] * ints[2] + share[3] * ints[3] + share[4] * ints[4] + share[5] * ints[5] + share[6] * ints[6] + share[7] * ints[7]
prob_tot1 <- 0.10 * 0.25 + 0.20 * 0.05 + share[3] * ints[3] + share[4] * ints[4] + share[5] * ints[5] + share[6] * ints[6] + share[7] * ints[7]
prob_a1 <- (share[1] * ints[1]) / prob_tot1

#Cálculo semimanual
prob_tot2 <- share %*% ints 
prob_a2 <- (share[1] * ints[1]) / prob_tot2

#Cálculo automático
calculo_probabilidad_bayes <- function(names, share, ocurrence) {

  prob_total <- share %*% ocurrence

  data <- tibble(
    noms = names,
    part = share,
    ocur = ocurrence,
    prob_post = part * ocur / as.vector(prob_total)
  ) 

  return(data)

}

calculo_probabilidad_bayes(bancos, share, ints) |> 
  filter(noms == "A")

#Gráfico-----------------
indicadores <- datos_bccr |> 
  select(id, Serie) |> 
  distinct()

datos_bccr |> 
  filter(id == 89638) |> 
  ggplot(aes(x = Fecha, y = Valor)) + 
  geom_line()

datos_bccr |> 
  filter(id == 23630) |> 
  ggplot(aes(x = Fecha, y = Valor)) + 
  geom_line()

datos_bccr |> 
  filter(id == 87961) |> 
  ggplot(aes(x = Fecha, y = Valor)) + 
  geom_line()


datos_bccr |> 
  filter(
    id == 89638, 
    Fecha >= "2010-01-01",
    Fecha <= "2026-01-01"
  ) |> 
  ggplot(aes(x = Fecha, y = Valor)) + 
  geom_line()

graf_lin <- function(indicador, fecha_min, fecha_max, Titulo) {

  data <- datos_bccr |> 
    filter(
      id == indicador,
      Fecha >= fecha_min,
      Fecha <= fecha_max
  ) 
  
  graf <- data |> 
    ggplot(aes(x = Fecha, y = Valor)) + 
    ggtitle(Titulo) 

  return(graf)
}

graf_lin(423, "2025-01-01", "2026-01-01", "Tasa Básica Pasiva")

#Práctica---------------------------------------

# Ejercicio 1: Crear una función que calcule el 
# total de permutaciones o combinaciones,
# con argumentos n y r, y una variable 
# booleana que sea TRUE para calcular 
# permutaciones, FALSE para combinaciones  

#Hint:
factorial(5)
conteo <- function(n, r, Perm = TRUE) {
  resultado <- factorial(n) / factorial(n - r)
}

#Crear una funcion que calcule estadísticas descriptivas 
# para un indicador seleccionado

stats_descrip <- function(indicador, fecha_min, fecha_max) {

}
