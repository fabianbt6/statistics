# Catálogo de patrones

Esto documenta cómo resolver, en Quarto, cada patrón de slide que
aparece a lo largo del curso. No es una migración completa de las 4
unidades de muestra — es la referencia para migrar cualquier unidad
(esta u otra futura) de forma consistente.

Los primeros 5 patrones ya están en uso en
`materias/estadistica/content/semanas/unidad-02-probabilidad.qmd`. Los siguientes son
nuevos, encontrados en Unidad 1, Unidad 4, Unidad 5 y Series de tiempo.

## Ya establecidos (Unidad 2)

- **Portada** — `{{< include ../../../../shared/portada.qmd >}}`
- **Divisor de sección** — `## Título {.divisor}` (fondo de marca, solo título)
- **Definición** — `## Definición` normal, el acento bajo el título es automático
- **Ejercicio + solución** — dos slides consecutivas, sin clase especial
- **Bibliografía** — `{{< include ../blocks/bibliografia.qmd >}}`

## Nuevos

### Tabla de datos

Para tablas reales (matrices de confusión, criterios de rechazo, etc.)
— nunca como imagen, siempre editable:

```markdown
| $H_0$ | $H_1$ | Región crítica |
|---|---|---|
| $\mu = \mu_0$ | $\mu > \mu_0$ | $Z \geq z_\alpha$ |
| $\mu = \mu_0$ | $\mu < \mu_0$ | $Z \leq -z_\alpha$ |
```

Si quieres el estilo con colores/formato condicional que ya usas en tus
reportes de LAC_FinData, se puede hacer con un chunk de R + `kableExtra`
en vez de markdown puro — dime si prefieres esa ruta para alguna tabla
en particular.

### Código R mostrado en la slide

Nunca como texto plano — usa un bloque de código con resaltado de
sintaxis real:

````markdown
```r
W <- c(0.28, 0.01, 0.13, 0.33, -0.03, 0.07, -0.18, -0.14,
       -0.33, 0.01, 0.22, 0.29, -0.08, 0.23, 0.08, 0.04,
       -0.30, -0.08, 0.09, 0.70, 0.33, -0.34, 0.50, 0.06)
```
````

Si además quieres que el código se **ejecute** al renderizar (mostrar
el resultado en vivo, no solo el texto), cambia el chunk a ` ```{r} `
en vez de ` ```r ` — pero eso requiere que los datos/paquetes estén
disponibles al momento de renderizar.

### Pregunta de discusión / opción múltiple

Se revela una opción a la vez con clic, en vez de mostrarlas todas de
una:

```markdown
## Para datos económicos, ¿cuál es mejor utilizar?

::: {.incremental}
- Del objetivo del análisis
- De la distribución de los datos
- Del público con el que se está interactuando
- Del tipo de datos que se está analizando
:::
```

### Slide destacada (caso de estudio / aplicación real)

A diferencia del divisor (que es solo título), esta sí lleva contenido
— bullets, texto, enlaces — sobre fondo de marca:

```markdown
## Transmisión de la tasa de política monetaria al mercado {.destacado}

- Tasa de política monetaria es el principal instrumento del BCCR
- Los movimientos de esta tasa no son completos y tienen un rezago
- [Más información en este enlace](https://ejemplo.com)
```

### Comparación de dos columnas

```markdown
## Evaluar región crítica

:::: {.columns}
::: {.column width="50%"}
**Opción 1**

$|t| \geq t_{\alpha/2}(n-1)$
:::
::: {.column width="50%"}
**Opción 2**

$|\bar{x} - \mu_0| \geq t_{\alpha/2}(n-1) \cdot s/\sqrt{n}$
:::
::::
```

### Figura de referencia con fuente citada

```markdown
![Distribución normal estándar](../../../../images/diagramas/tabla-z.png){fig-align="center"}

*Fuente: Hogg, Tanis y Zimmerman (2015), p. 366*
```

### Bibliografía por unidad (cuando no es la base del curso)

La mayoría de unidades usan `{{< include ../blocks/bibliografia.qmd >}}`
(Hogg + Sahu). Si una unidad usa textos distintos (como Series de
Tiempo, que cita Metcalfe/Cowpertwait y Shumway/Stoffer), simplemente
no uses el include — escribe la sección directo en esa unidad:

```markdown
## Bibliografía

- Metcalfe, A.; Cowpertwait, P. 2009. *Introductory Time Series with R*.
  Springer New York.
- Shumway, R.; Stoffer, D. 2011. *Time Series Analysis and Its
  Applications*. Springer New York.
```

## Un estilo de divisor, no dos

En el material actual hay dos variantes de divisor (fondo amarillo con
chevron, fondo navy con mancha decorativa) — probablemente por cambios
de plantilla a través del tiempo, no una decisión deliberada. Como esto
ya es tu marca personal, `styles.scss` define un solo `.divisor`
consistente (color indigo de tu paleta). Si preferías mantener dos
variantes a propósito (ej. uno para inicio de unidad y otro para
sub-secciones), dime y agrego una segunda clase.

## Gráficos de R pegados como imagen

Los gráficos de Series de Tiempo (PIB real, correlogramas) son salidas
de R pegadas como imagen. Funcionan bien así, pero si en algún momento
me compartes el script o los datos que los generan, se pueden convertir
en chunks de R que se ejecutan al renderizar — la ventaja es que se
actualizan solos si cambian los datos (ej. cuando salga el PIB de un
trimestre nuevo).
