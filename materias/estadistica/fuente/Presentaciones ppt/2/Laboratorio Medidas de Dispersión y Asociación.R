
rm(list = ls())

#libs------------
library(tidyverse)
library(ggplot2)
library(lubridate)
library(tseries)
library(scales)

#Cargar datos-----

load(file = "C:/Users/FBrenes/OneDrive - Habitat for Humanity International/Estadística/Docencia/Teoría Estadística/datos_bccr.rdata")

data_long <- datos_bccr |> 
  filter(id == "423" | id == "3541") |>
  filter(Fecha > "2007-01-01") |> 
  mutate(Fin_mes = ifelse(Fecha == ceiling_date(ymd(Fecha), 'month') - days(1), 
                       T, F), 
         Tasa = ifelse(Serie == "Tasa política monetaria", "TPM", "TBP"))

data_wide <- data_long |> 
  select(-c(id, Serie)) |> 
  pivot_wider(id_cols = c(Fecha, Fin_mes), names_from = Tasa, values_from = Valor) |> 
  arrange(Fecha) 

#Análisis descriptivo-----------------
#Gráfico de líneas de las tasas

graf <- data_long |> 
  filter(Fin_mes == T) |> 
  ggplot(aes(x = Fecha, y = Valor, linetype = Tasa, color = Tasa)) +
  geom_line(size = 1) 

graf +
  scale_x_date( 
    NULL,
    breaks = scales::breaks_width("2 years"),
    labels = scales::label_date("'%y")
  ) +
  theme(legend.position = "bottom")

#Cálculo de Promedio y Mediana

estadisticos <- data_long |>
  group_by(Tasa) |>
  filter(Fin_mes == T) |> 
  summarise(Media = mean(Valor), 
            Mediana = median(Valor), 
            Varianza = var(Valor), 
            SD = sd(Valor),
            CV = SD / Media,
            p25 = quantile(Valor, 0.25), 
            p75 = quantile(Valor, 0.75), 
            P50 =quantile(Valor, 0.50), 
            IQR = p75 - p25,
            Min = min(Valor),
            Max = max(Valor),
            Rango = Max - Min
          )
          

#Gráfico Dispersión por variable
data_long |> 
  mutate(Año = as_factor(year(Fecha))) |> 
  filter(Fin_mes == T) |>
  filter(Tasa == "TPM") |> 
  filter(Fecha > "2020-01-01" & Fecha < "2026-01-01") |> 
  ggplot(aes(x = Año, y = Valor, group = Año, fill = Año)) +
  geom_boxplot()

#Gráfico de Asociación
data_wide |> 
  filter(Fin_mes == T) |> 
  ggplot(aes(y = TBP, x = TPM)) + 
  geom_point(size = 2) +
  geom_smooth(method = "lm", 
              se = F)

data2 <- data_wide |> na.omit()

cor(data2$TPM, data2$TBP)

#Estandarización de variables
tpm_estandarizada <- data |>
  filter(Fin_mes == T, Fecha > "2018-01-01") |> 
  select(Fecha, TPM) |> 
  mutate(promedio = mean(TPM), 
         desv.est = sd(TPM), 
         ztpm = (TPM - promedio) / desv.est
         )

tbp_estandarizada <- data |>
  filter(Fin_mes == T) |> 
  select(Fecha, TBP) |> 
  mutate(promedio = mean(TBP), 
         desv.est = sd(TBP), 
         ztbp = (TBP - promedio) / desv.est
  )

valores_extremos_tbp <- tbp_estandarizada |> 
 filter(abs(ztbp) > 2) 

round(mean(tbp_estandarizada$ztbp), 10)
sd(tbp_estandarizada$ztbp)

scale(data$TBP)

