rm(list = ls())

#Primera operación en R
1 + 2 

#Asignar valor a una variable
x <- 4
x

#Asignar valores a un vector
vect <- c(1, 2, 3, 4, 5, 6, 7, 8, 10)
vect1 <- c(1:100)

#Operaciones con vectores 
x %*% vect

#Operaciones estadísticas básicas
#Promedio
mean(vect1)

#Mediana
median(vect1)

#Desviación Estándar
sd(vect1) 

#maximo
min(vect1)

#minimo
max(vect1)

#Primer ejercicio con R
x1 <- rnorm(100, 20, 5000)
mean(x1)
sd(x1)

hist(x1)

x2 <- rpois(10, 20)
mean(x2)
sd(x2)





