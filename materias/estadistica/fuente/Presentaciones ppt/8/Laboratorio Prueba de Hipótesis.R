
rm(list = ls())

#libs-----------
library(tidyverse)
library(ggplot2)
library(scales)
library(BSDA)
library(haven)

#Ejercicio prueba de una media---------

W <- c(0.28, 0.01, 0.13, 0.33, -0.03, 0.07, -0.18, -0.14, 
       -0.33, 0.01, 0.22, 0.29, -0.08, 0.23, 0.08, 0.04,
       -0.30, -0.08, 0.09, 0.70, 0.33, -0.34, 0.50, 0.06)

w_media <- mean(W)
w_var <- var(W)
w_sd <- sd(W)
w_n <- length(W)

t <- (w_media - 0) / ((w_sd) / sqrt(w_n))
t_0.05 <- qt(p = 0.05, w_n - 1, lower.tail = F)
t_0.10 <- qt(p = 0.10, w_n - 1, lower.tail = F)
pvalue <- pt(t, df = w_n - 1, lower.tail = F)


t >= t_0.05
t >= t_0.10

t.test(W, alternative = "greater", conf.level = 0.95)

set.seed(198604)
tibble(x = rt(2400, w_n - 1)) |> 
  ggplot(aes(x = x)) +
  geom_density() +
  geom_vline(xintercept = t, linetype = 2) + 
  geom_vline(xintercept = t_0.10, color = "red")

z.test(W, alternative = "greater", sigma.x = w_sd, conf.level = 0.95)  

#Gráfico de densidad de una variable normal estandar--------------

x1 <- tibble(x1 = rnorm(1000, 0, 1)) 
x1 |> 
  ggplot(aes(x1)) +
  geom_density() + 
  geom_vline(xintercept = 2, linetype = 2) + 
  geom_vline(xintercept = -2, , linetype = 2)

qnorm(0.50, 0, 1) #Teórico 
quantile(x1$x1, 0.50) #Observado
median(x1$x1)

q95 <- replicate(1000, {
  quantile(rnorm(1000, 0, 1), 0.95)  
}
)

tibble(q95) |>
  mutate(cons = 1:n()) |>
  ggplot(aes(x = cons, y = q95)) + 
  geom_point() + 
  geom_hline(yintercept = qnorm(0.95, 0, 1), color = "red")

#Simulación para evaluar cuantil teórico vrs el cuantil empírico
data1 <- tibble(n = 1:1000, 
                qteorico = qnorm(0.5, 0, 1), 
                qempirico_norm = NA, 
                qempirico_gamma = NA)

for(i in (1:1000)) {
  x <- tibble(x1 = rnorm(100, 0, 1), 
              x2 = scale(rgamma(100, 0.5, rate =  0.85))[, 1]
  )
              
  data1[i, 3] <- quantile(x$x1, 0.50)
  data1[i, 4] <- quantile(x$x2, 0.50)
}

data1_long <- data1 |> 
  pivot_longer(-n, names_to = "Cuantile", values_to = "Valor") 

data1_long |> 
  group_by(Cuantile) |> 
  summarise(promedio = mean(Valor))

tibble(xgamma = scale(rgamma(100, 0.5, rate =  0.85))[, 1]) |> 
  ggplot(aes(x = xgamma)) + 
  geom_density() + 
  geom_vline(xintercept = quantile(rgamma(100, 0.5, rate =  0.85), 0.95), linetype = 2) + 
  geom_vline(xintercept = qnorm(0.95, 0, 1), color = "red")


#Funcion para estandarizar variables----------
estandarizar <- function(data) {
  mu <- mean(data)
  s <- sd(data)
  
  return((data - mu) / s)
}

wz <- estandarizar(W)

wdata <- tibble(w = W,
                wz = wz)

round(mean(wz), 5)
sd(wz)
var(wz)

cor(W, wz)

wz1 <- scale(W)[, 1]

xnorm <- tibble(xnrom = rnorm(1000, 0, 1)) 

xnorm |> 
  ggplot(aes(x = xnrom)) + 
  geom_density()
  
#Simulación para reflejar que conforme se aumenta el valor de la muestra, la distribución T-Student tiende a la distribución normal-----------
data2 <- tibble(n = 1:(1000 - 9), 
                pvalue_t = NA, 
                pvalue_z = NA)

for(i in 10:1000) {
  x <- rt(i, i - 1)
  data2[i - 9, 2] <- t.test(x, alternative = "greater", conf.level = 0.95)$p.value
  data2[i - 9, 3] <- z.test(x, alternative = "greater", sigma.x = sd(x), conf.level = 0.95)$p.value
}

data2 |> 
  mutate(diff = pvalue_t - pvalue_z)|> 
  ggplot(aes(x = n, y = diff)) +
  geom_line() +
  geom_hline(yintercept = 0, linetype = 2, colour = "red")
