# Materia: Teoría Estadística y Métodos Cuantitativos (EC-720)

Resumen vivo y corto de lo acordado para esta materia — no repite lo
que ya es compartido a nivel de repo (diseño visual, `_brand.yml`,
`styles.scss`, convenciones generales de `render_curso.R`). La
bitácora completa y cronológica vive en `claude/plan-estadistica.md`
(Claude Project "Statistics").

## Estructura del contenido: unidades autocontenidas, no semanas

Desde la migración de septiembre de 2026, el contenido de la materia
vive en `content/unidades/` — una unidad por tema real, sin fusionar
varios temas en un solo archivo. Cada unidad es una pieza modular
independiente ("como un lego"): se incluye en un curso solo si ese
curso decide cubrirla, sin que su existencia dependa de ninguna
semana de calendario específica. El número de unidad en el nombre del
archivo es solo el argumento interno que lee
`render_curso(unidades = ...)` para filtrar qué renderizar — el
título/portada visible para estudiantes **no** muestra ese número,
solo la temática.

Esto reemplaza por completo el esquema anterior de `content/semanas/`
(un archivo por semana de calendario, con numeración de "Unidad N"
tomada del programa oficial de 8 unidades). El contenido viejo se
movió a `_to_delete/estadistica-semanas-viejo/` y
`_to_delete/estadistica-preparacion-semanas-viejo/` (pendiente de
borrado manual — el bridge de la computadora del usuario no puede
borrar archivos).

### Las 12 unidades + 3 archivos especiales

| Archivo | Unidad | Tema |
|---|---|---|
| `intro-presentacion.qmd` | — | Presentación del curso e introducción a R |
| `unidad-1-descripcion-datos-presentacion.qmd` | 1 | Descripción de datos |
| `unidad-2-probabilidad-conceptos-presentacion.qmd` | 2 | Probabilidad — conceptos y técnicas de conteo |
| `unidad-3-probabilidad-reglas-bayes-presentacion.qmd` | 3 | Probabilidad — reglas (condicional, independencia, Bayes) |
| `unidad-4-distribuciones-discretas-presentacion.qmd` | 4 | Distribuciones — Bernoulli, binomial, Poisson |
| `unidad-5-distribuciones-continuas-presentacion.qmd` | 5 | Distribuciones — normal, t, F, ji-cuadrada |
| `unidad-6-pruebas-hipotesis-presentacion.qmd` | 6 | Pruebas de hipótesis |
| `unidad-7-pruebas-hipotesis-laboratorio-caso1-presentacion.qmd` | 7 | Pruebas de hipótesis — laboratorio y Caso 1 |
| `unidad-8-intervalos-confianza-presentacion.qmd` | 8 | Intervalos de confianza |
| `unidad-9-anova-presentacion.qmd` | 9 | ANOVA |
| `unidad-10-series-tiempo-componentes-presentacion.qmd` | 10 | Series de tiempo — componentes y descomposición |
| `unidad-11-series-tiempo-modelos-presentacion.qmd` | 11 | Series de tiempo — regresión espuria y modelos básicos |
| `unidad-12-numeros-indice-actividad-presentacion.qmd` | 12 | Números índice — actividad participativa (Caso 3) |
| `repaso-presentacion.qmd` | — | Repaso e integración — Caso 2 |
| `investigacion-final-presentacion.qmd` | — | Presentación de la investigación final |

Cada `unidad-N-*-presentacion.qmd` tiene su guía de preparación
docente equivalente en `content/preparacion/unidad-N-*-guia.qmd`
(mismo criterio para los 3 archivos especiales: `intro-guia.qmd`,
`repaso-guia.qmd`, `investigacion-final-guia.qmd`).

**Nota importante sobre nombres de archivo:** el mecanismo de
`render_curso()` detecta el número de unidad tomando el primer grupo
de dígitos que aparece en el nombre del archivo — por eso el archivo
de repaso se llama `repaso-presentacion.qmd` y no
`repaso-caso2-presentacion.qmd` (ese "2" de "Caso 2" se habría leído
por error como número de unidad 2). Si en el futuro se agrega un
archivo especial sin número, evitar dígitos sueltos en su nombre por
la misma razón.

## El HTML final nunca muestra el número de unidad en su nombre de archivo

`render_curso()` renombra el HTML de salida de cada unidad quitándole
el prefijo `unidad-N-` antes de dejarlo en
`cursos/<universidad>/<periodo>/` — por ejemplo,
`unidad-3-probabilidad-reglas-bayes-presentacion.qmd` se renderiza
como `probabilidad-reglas-bayes-presentacion.html`, sin el "3". Motivo
(a pedido explícito del usuario): el número de unidad es solo un dato
de orden interno para que `unidades = c(...)` pueda filtrar contenido
— no tiene por qué coincidir con ningún número de unidad de un
programa institucional concreto, así que no tiene sentido que aparezca
en el nombre del archivo que de verdad se comparte con
estudiantes/docentes. Los archivos especiales sin número (`intro-`,
`repaso-`, `investigacion-final-`) no tienen prefijo que quitar y
quedan igual. Esto aplica también a `matematica-economistas/` (mismo
mecanismo en `R/render_curso.R`, compartido entre ambas materias).

## La salida de cada curso se organiza en 3 subcarpetas

`cursos/<universidad>/<periodo>/` ya no deja todos los `.html` sueltos
en la raíz — a pedido explícito del usuario, `nuevo_curso()` crea (y
`render_curso()` refuerza) 3 subcarpetas:

- **`presentaciones/`** — unidades (`-presentacion.qmd`) y guías
  docente (`-guia.qmd` de `content/preparacion/`).
- **`documentos/`** — `programa.qmd`, el resto de `content/docs/`, y
  `content/tareas/` (evaluaciones — hoy en esta materia solo
  `tarea-01.qmd`).
- **`laboratorios/`** — prácticas y laboratorios. Hoy ningún archivo
  de `content/` rinde acá — los tutoriales `learnr` de
  `materias/estadistica/tutoriales/` son un sistema aparte que corre
  directo (no pasan por `render_curso()`) — pero la carpeta se crea
  igual, lista para cuando haga falta. Mismo mecanismo en
  `R/render_curso.R`, compartido con `matematica-economistas/`.

## Cómo se arma un curso real: seleccionando unidades, no fusionando contenido

A diferencia del mecanismo viejo (`carpeta_contenido: sesiones-10`,
retirado — ver más abajo), un curso de 10 sesiones no tiene un
conjunto de archivos aparte con contenido fusionado. Simplemente se
decide, al momento de preparar cada clase, qué unidad o unidades entran
en esa sesión, y se renderizan con `render_curso(unidades = c(...))`
— `unidades` acepta un vector, así que una sesión que cubre dos temas
simplemente renderiza dos archivos (dos `.html` separados), sin
necesidad de un archivo condensado especial.

### Sugerencia de agrupación para el curso real 2026-C3 (FIDELITAS, 10 sesiones)

Documentada también como comentario en
`cursos/FIDELITAS/2026-C3/_variables.yml`:

| Sesión | Fecha | Unidades sugeridas |
|---|---|---|
| 1 | 18 set | intro + unidad 1 (descripción de datos) |
| 2 | 25 set | unidades 2 y 3 (probabilidad completa) |
| 3 | 2 oct | unidades 4 y 5 (distribuciones) |
| 4 | 16 oct | unidades 6 y 7 (pruebas de hipótesis + Caso 1) |
| 5 | 23 oct | unidad 8 (intervalos de confianza) |
| 6 | 30 oct | unidad 9 (ANOVA) |
| 7 | 13 nov | unidad 10 (series de tiempo I) |
| 8 | 20 nov | unidad 11 + repaso (series de tiempo II, Caso 2) |
| 9 | 4 dic | unidad 12 (números índice, Caso 3) |
| 10 | 11 dic | investigación final |

Esta es solo una sugerencia de referencia (para no perder el trabajo
de planeación ya hecho) — no está impuesta por ningún código; el
profesor puede agrupar distinto sesión a sesión sin tocar `content/`.

## Mecanismo retirado: `content/sesiones-10/` / `carpeta_contenido`

Antes de la migración a unidades, el curso de 10 sesiones usaba una
carpeta aparte (`content/sesiones-10/`) con 10 pares de archivos
(presentación + guía) que fusionaban físicamente el contenido de 2-3
semanas en un solo documento condensado por sesión, seleccionada vía
`carpeta_contenido: sesiones-10` en `_variables.yml`. Este mecanismo
quedó **retirado** — el contenido viejo se movió a
`_to_delete/estadistica-sesiones-10-viejo/` (pendiente de borrado
manual) y `_variables.yml` ya no tiene el campo `carpeta_contenido`.
El mecanismo de `render_curso.R` sigue existiendo en el código por si
hace falta a futuro para otra materia, pero ninguna materia del repo
lo usa hoy.

## Pendiente

- Verificar el render real de los 15 archivos de `content/unidades/`
  y de `content/preparacion/` migrados (este entorno de trabajo no
  tiene Quarto/R disponible).
- Borrar a mano (el bridge no puede): `content/semanas/` (vacía),
  `_to_delete/estadistica-semanas-viejo/`,
  `_to_delete/estadistica-preparacion-semanas-viejo/`, y
  `_to_delete/estadistica-sesiones-10-viejo/`, una vez confirmado que
  la nueva estructura renderiza bien.
- Pendiente histórico: los laboratorios `learnr` en
  `materias/estadistica/tutoriales/` siguen organizados por semana
  (`semana-NN-slug/`) — son un sistema aparte del contenido de clase
  (`content/`), no se tocaron en esta migración. Evaluar si conviene
  renombrarlos también a `unidad-N-slug/` para consistencia.
- Diseñar el documento propio de la actividad participativa de la
  Unidad 12 (números índice / Caso 3) — sigue pendiente desde antes de
  esta migración.
- Aplicado (después de esta migración, ver `claude/plan-matematica-economistas.md`
  y `claude/plan-estadistica.md`): próximo paso solicitado por el
  usuario — convertir también las unidades de `matematica-economistas`
  (hoy varias fusionadas en un solo archivo, ej.
  `unidad-1-algebra-lineal-presentacion.qmd` combina 3 subtemas) en
  archivos igual de granulares y autocontenidos, para que ambas
  materias sigan la misma lógica modular de "lego" — pendiente de
  hacer.
