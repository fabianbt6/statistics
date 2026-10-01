rm(list = ls())

#libs-----------
library(tidyverse)
library(ggplot2)

#Cargar datos-------
load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

#Seleccionar variables-----------
data <- datos_bccr |> 
  filter(id == "89638" | id == "23630")

#Agrega una variable para identificar régimen cambiario y estandariza las variables

data_wide <- data |>
  select(-id) |> 
  pivot_wider(id_cols = Fecha, names_from = Serie, values_from = Valor) |>   
  filter(Fecha >= "2000-01-01") |> 
  mutate('Régimen Cambiario' = ifelse(Fecha >= "2018-01-01", "Flotación Administrada",
                                      ifelse(Fecha >= "2006-01-01", "Banda Cambiaria",
                                             "Minidevaluaciones"))) |> 
  mutate(Inf_z = scale(`IPC, variación interanual (%)`)[, 1], 
         Desempleo_z = scale(`Tasa de desempleo`)[, 1])
          
data_long <- data_wide |> 
  select(Fecha,`Régimen Cambiario`, `IPC, variación interanual (%)`, `Tasa de desempleo`) |> 
  pivot_longer(-c(Fecha, `Régimen Cambiario`), names_to = "Indicador", values_to = "Valor")

data_long_z <- data_long |>
  filter(Fecha > "2011-01-01") |> 
  na.omit() |> 
  group_by(Indicador) |> 
  mutate(
    Estandarizado = scale(Valor)[, 1]
  )
#funciones personalizadas--------- 

#Función para crear estadísticas descriptivas
descriptivos <- function(data, var1) {
  data1 <- data |> 
    summarize(
      promedio = mean({{ var1 }}),
      mediana = median({{ var1 }}),
      desv.estandar = sd({{ var1 }}),
      var = var({{ var1 }}), 
      cv = desv.estandar / promedio,
      p02 = quantile({{ var1 }}, 0.02),
      p75 = quantile({{ var1 }}, 0.75),
      p90 = quantile({{ var1 }}, 0.90), 
      minino = min({{ var1 }}), 
      maximo = max({{ var1 }})
      )
  return(data1)
}

#Análisis descriptivo inflación--------------
descriptivos(na.omit(data_wide), `IPC, variación interanual (%)`)
descriptivos(na.omit(data_wide), `Tasa de desempleo`)

data_wide |> 
  group_by(`Régimen Cambiario`) |> 
  summarize(Media = mean(`IPC, variación interanual (%)`), 
            Mediana = median(`IPC, variación interanual (%)`),
            p75 = quantile(probs = 0.75, `IPC, variación interanual (%)`),
            p25 = quantile(probs = 0.25, `IPC, variación interanual (%)`),
            Desv.Est = sd(`IPC, variación interanual (%)`), 
            CV = Desv.Est / Media * 100,
            min = min(`IPC, variación interanual (%)`), 
            max = max(`IPC, variación interanual (%)`)
          ) |> 
  arrange(desc(Media))

data_wide |> 
  ggplot(aes(x = Fecha, y = `IPC, variación interanual (%)`, colour = `Régimen Cambiario`)) +
  geom_line(linewidth = 0.7) +
  theme_minimal() %+%
  theme(legend.position = "bottom")

data_wide |> 
  ggplot(aes(x = `IPC, variación interanual (%)`)) +
  geom_density() +
  theme_minimal() 

data_wide |> 
  ggplot(aes(x = `IPC, variación interanual (%)`, fill = `Régimen Cambiario`)) +
  geom_density(alpha = 1/3) +
  theme_minimal() %+%
  theme(legend.position = "bottom")

data_wide |> 
  ggplot(aes(x = `IPC, variación interanual (%)`, fill = `Régimen Cambiario`)) +
  geom_density(alpha = 1/3) +
  facet_grid(~ `Régimen Cambiario`) +
  theme_minimal() %+%
  theme(legend.position = "bottom")

data_wide |> 
  ggplot(aes(x = `IPC, variación interanual (%)`, y = `Régimen Cambiario`, colour = `Régimen Cambiario`)) +
  geom_boxplot() +
  facet_grid(. ~`Régimen Cambiario`, scales = "free") +
  theme(legend.position  =  "none")

#Prueba de hipótesis------------
#H0: La inflación promedio es igual a mu0
#H1: La inflación promedio es menor a mu0

datos_p <- data_wide |> 
  filter(`Régimen Cambiario` == "Minidevaluaciones") |> 
  summarize(mu = mean(`IPC, variación interanual (%)`), 
            theta = sd(`IPC, variación interanual (%)`))

datos_m <- data_wide |> 
  filter(`Régimen Cambiario` != "Minidevaluaciones") |> 
  summarize(n = n(), 
            xbarra = mean(`IPC, variación interanual (%)`), 
            s = sd(`IPC, variación interanual (%)`))

zcal <- (datos_m$xbarra - datos_p$mu) / (datos_m$s / sqrt(datos_m$n)) 
z <- qnorm(0.975, 0, 1, lower.tail = F)
pnorm(zcal, 0, 1)

data_wide |> 
  filter(`Régimen Cambiario` != "Minidevaluaciones") |>
  select(`IPC, variación interanual (%)`) |> 
  t.test(mu = datos_p$mu, alternative = "less", conf.level = .95)

lim <- qnorm(p = 0.95, 0, 1, lower.tail = T)
data_wide |> 
  filter(`Régimen Cambiario` == "Minidevaluaciones") |> 
  mutate(inf_z = scale(`IPC, variación interanual (%)`)[, 1]) |> 
  ggplot(aes(x  = inf_z)) +
  geom_density() + 
  geom_vline(xintercept = -lim, linetype = 2, color = "red") +
  geom_vline(xintercept = zcal, linetype = 2)

pnorm(2, 0, 1) * 100

#Prueba de hipótesis para contrastar si el promedio de inflación en flot administrada disminuyó con respecto a banda cambiaria

mu <- data_wide |> 
  filter(`Régimen Cambiario` == "Banda Cambiaria") |> 
  summarize(mu = mean(`IPC, variación interanual (%)`))

data_wide |> 
  filter(`Régimen Cambiario` == "Flotación Administrada") |>
  select(`IPC, variación interanual (%)`) |> 
  t.test(mu = mu$mu, alternative = "less")

data_wide |> 
  filter(`Régimen Cambiario` == "Flotación Administrada") |> 
  mutate(inf_z = scale(`IPC, variación interanual (%)`)[, 1]) |> 
  ggplot(aes(x = Fecha, y = inf_z)) + 
  geom_line() +
  geom_hline(yintercept = c(-2, 2), linetype = 2, colour = "red")

#Gráfico Inflación y desempleo------------

#Gráficos separados
data_long |> 
  na.omit() |> 
  filter(Fecha > "2015-01-01") |> 
  ggplot(aes(Fecha, Valor, colour = Indicador)) +
  geom_line(linewidth = 0.75) +
  facet_grid(Indicador ~ ., scales = "free") +
  theme(legend.position = "top")

data_wide |>
  na.omit() |>
  filter(Fecha > "2022-01-01") |> 
  ggplot(aes(x = `IPC, variación interanual (%)`, y = `Tasa de desempleo`)) +
  geom_point() +
  geom_smooth(method = "lm", se = F ) + 
  theme(legend.position = "top")

data_wide |> 
  na.omit() |> 
  filter(Fecha > "2020-01-01") |> 
  summarise(Corr = cor(`IPC, variación interanual (%)`, `Tasa de desempleo`))

