
#Operaciones matemáticas sencillas--------

1 + 4
x <- 9
8 * x

#Asignar un vector a una variable--------
vect1 <- c(3, 5, 50, 7, 90, 20, 14, 12, 90, 50)

#Operaciones sencillas a un conjunto de datos-----
mean(vect1)
median(vect1)

#Operaciones matriciales-----------
vect1 * x
mat1 <- matrix(vect1)
mat2 <- matrix(vect1 * x)

mat1 %*% mat2

