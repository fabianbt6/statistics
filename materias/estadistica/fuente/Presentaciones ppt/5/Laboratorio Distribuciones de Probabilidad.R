rm(list = ls())

#Librerías-----------
library(tidyverse)
library(ggplot2)

#Distribución de Bernoulli
xbern <- rbinom(n = 1000, size = 1,  p = 0.5)

sum(xbern)

sum(xbern) / length(xbern)

p <- mean(xbern)
q <- 1 - p 
var_bern <- p * q
var(xbern)
sqrt(var(xbern))
sd_bern <- sd(xbern)

tib_xbern <- tibble(xbern = as.factor(xbern))

ggplot(data = tib_xbern, aes(x = xbern)) +
  geom_histogram(stat = "count")  

tib_xbern |>
  ggplot(aes(x = xbern)) + 
  geom_histogram(stat = "count")

ggplot(data = tibble(xbern = xbern), aes(x = xbern)) + 
  geom_histogram(stat = "count")

#Distribución Binomial
s <- 4
p <- 0.75
xbinom <- rbinom(50000, s, p)
mean(xbinom)
s * p

#Ejemplo de la lotería
(factorial(8) /  (factorial(2) * factorial(8 - 2)) * 0.2 ^ 2 * (1 - 0.2) ^ (8 - 2))

tibble(xbinom = as_factor(xbinom)) |> 
  ggplot(aes(x = xbinom)) + 
  geom_histogram(stat = "count")

#Distribución de Poisson
iter <- 1000
npois <- 10
lambda <- 12
xpois <- tibble(
  iter = 1:iter, 
  promedio = NA 
)

for(iter in 1:nrow(xpois)) { 
  data <- rpois(npois, lambda)
  xpois[iter, 2] = mean(data)
}

xpois |> 
  ggplot(aes(x = iter, y = promedio)) +
  geom_point() +
  geom_hline(yintercept = lambda, color = "red")

mean(xpois$xpois)
var(xpois$xpois)

xpois |> 
  ggplot(aes(x = xpois)) + 
  geom_density()

#Distribución Normal
xnorm <- rnorm(500, 0, 1)
mean(xnorm)
sd(xnorm)
var(xnorm)

tibble(xnorm = xnorm) |> 
ggplot(aes(x = xnorm)) + 
  geom_density()

#Ley de los grandes números

mean(rnorm(40, 20, 20))

mu.poblacion <- 5
mu <- NA

for(i in 1:1000) {
  mu[i] <- mean(rnorm(i, mu.poblacion, 200))
}
mu

tibble(mu = mu) |>
  mutate(n = 1:n()) |> 
  ggplot(aes(x = n, y = mu)) + 
  geom_point() +
  geom_hline(yintercept = mu.poblacion, linetype = 2, colour = "red")

#Ejercicio

xpois1 <- tibble(x = rpois(n = 10, lambda = 15))
xpois2 <- tibble(x = rpois(n = 14, lambda = 15))
xpois3 <- tibble(x = rpois(n = 10000, lambda = 15))

ggplot() +
  geom_density(data = xpois1, aes(x), color = "red") +
  geom_density(data = xpois2, aes(x), color = "green") + 
  geom_density(data = xpois3, aes(x), color = "darkblue")

