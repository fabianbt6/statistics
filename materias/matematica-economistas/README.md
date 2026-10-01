# Matemática para Economistas (EC-620) — bitácora de decisiones

Este README vive junto al contenido de la materia
(`materias/matematica-economistas/README.md`) y guarda los **acuerdos
concretos** tomados con el profesor sobre este curso específico —
cosas que no están en el programa oficial ni en la línea de diseño
compartida del repo, y que se pierden fácil si solo quedan en el
historial de una conversación. El plan de proyecto
(`claude/plan-matematica-economistas.md`, en el Project de Claude)
sigue siendo la bitácora completa y cronológica de todo el trabajo;
este README es el resumen vivo y corto que responde "¿qué se acordó
para esta materia, ahora mismo?" — se actualiza cada vez que cambia
un acuerdo, no se van acumulando versiones viejas como en el plan.

## Curso

EC-620, Universidad Fidélitas, Bachillerato en Economía, 4 créditos,
V cuatrimestre. Programa oficial completo en `content/docs/programa.qmd`
(migrado del docx institucional en `fuente/`). Repo local en
`Documents/repos/personal/statistics` (antes en la carpeta de
OneDrive — el usuario movió el repo).

## El curso se dicta en dos formatos — ambos vigentes, no uno reemplaza al otro

`programa.qmd` genera el programa en **dos versiones** según el
parámetro `formato` (antes se llamaba `duracion`, renombrado en la
Actualización 11 para dejar espacio a futuras modalidades que no sean
solo de duración), porque el curso a veces se da en 15 sesiones y otras
en 10 sesiones.

**Vía normal (recomendada): `render_curso()`.** El formato del curso
queda guardado en su `_variables.yml`
(`cursos/FIDELITAS/2026-C3/_variables.yml` → `formato: "10-sesiones"`)
y `render_curso()` lo usa automáticamente — no hay que pasar nada:

```r
source("R/render_curso.R")
render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3)
```

Para probar el otro formato una sola vez sin editar el `_variables.yml`
del curso:

```r
render_curso(materia = "matematica-economistas", universidad = "FIDELITAS",
             anio = 2026, cuatri = 3, formato = "15-sesiones")
```

**Vía manual (`quarto render` directo, sin pasar por `render_curso()`):**

```
quarto render materias/matematica-economistas/content/docs/programa.qmd -P formato:10-sesiones
quarto render materias/matematica-economistas/content/docs/programa.qmd -P formato:15-sesiones -o programa-15-sesiones.html
```

El documento (info general, cronograma) cambia según ese parámetro;
el resto del contenido (descripción, unidades, evaluación,
bibliografía) es igual en ambas versiones. Detalle completo de la
implementación en el plan de proyecto, Actualizaciones 10 y 11.

### Calendario vigente cuando se usa `formato: "10-sesiones"` — 2026-C3

Rediseñado por completo en la Actualización 13 (reemplaza el
calendario de viernes de la Actualización 5/6, que quedó obsoleto): el
curso ya **no puede usar viernes** (restricción del profesor), así que
las 10 sesiones se acomodan sobre los mismos jueves que usa "Economía
de la Innovación" (el curso de la esposa del profesor, mismos
estudiantes, jueves cada dos semanas). En las semanas donde ambos
cursos coincidirían en horario, esta materia usa una sesión
**asincrónica** en vez de presencial; el cierre (jueves 17 de
diciembre de 2026) sí coincide con el cierre de Economía de la
Innovación, en una sesión conjunta. Detalle completo del razonamiento
(por qué solo 1 asincrónica y no 4, por qué la sesión 1 no imparte
materia) en el plan de proyecto, Actualización 13.

| Sesión | Fecha | Formato | Actividad clave |
|---|---|---|---|
| 1 | jue 17 set 2026 | Presencial (sin materia nueva — actividad institucional 1:30 h + presentación del curso) | — |
| 2 | jue 1 oct 2026 | Presencial — clase completa | — |
| 3 | jue 8 oct 2026 | Presencial — mitad clase / mitad práctica | Ejercicio 1 |
| 4 | jue 15 oct 2026 | **Asincrónica** (coincide con Economía de la Innovación) | Ejercicio 2 |
| 5 | jue 22 oct 2026 | Presencial — clase completa | — |
| 6 | jue 5 nov 2026 | Presencial — mitad clase / mitad práctica | Ejercicio 3 |
| 7 | jue 12 nov 2026 | Presencial — clase completa | — |
| 8 | jue 26 nov 2026 | Presencial — clase completa | — |
| 9 | jue 10 dic 2026 | Presencial — mitad clase / mitad práctica | Ejercicio 4 |
| 10 | **jue 17 dic 2026** | Presencial — **cierre conjunto con Economía de la Innovación** | Foro + entrega final de portafolio |

Evaluación condensada para este formato (distinta a la de 15 sesiones,
ver más abajo): 4 ejercicios prácticos 10% c/u (40%), estudio de caso
10% (fecha libre, sin sesión asignada), Foro 10%, portafolio
avance+entrega final 40%.

### Cuando se usa `formato: "15-sesiones"`

Se usa el cronograma original del programa oficial (una semana por
sub-tema, sin fusiones) — sin cambios respecto al programa
institucional migrado en la Actualización 1.

## Bibliografía — una sola, ya no la del programa institucional

No hay ningún requisito institucional que obligue a citar los textos
del programa original (Martínez, Samuelson y Nordhaus, Agudelo,
Escobar, Infante, Ugarte, Vidaurri, Arya y Lardner, Cachanosky) — eso
fue un supuesto incorrecto de una versión anterior de este README, ya
corregido. Se reemplazó por decisión del usuario, con el criterio de
que el curso sea reutilizable en cualquier universidad/periodo sin
depender de accesos institucionales de Fidélitas. Es la única
bibliografía del curso, tanto en el contenido de las sesiones como en
`programa.qmd` (en ambos formatos, `formato: "10-sesiones"` y
`formato: "15-sesiones"`). La agrupación de abajo sigue las **unidades
oficiales del programa** (1-6, ver `programa.qmd`) — no coincide con
la numeración interna de `content/unidades/` (1-15, ver sección
siguiente), que es más granular:

- **Unidad oficial 1 (álgebra lineal)** — internamente unidades 1-2
  (`1_operaciones-matrices`, `2_sistemas-ecuaciones` — la antigua
  unidad 3, `equilibrio-mercado`, se retiró el 2026-09-29, ver más
  abajo): Kuttler (2021) — acceso abierto (CC BY).
- **Unidades oficiales 2-4 (cálculo, optimización, funciones de varias
  variables)** — internamente unidades 4-11: Stewart (2021) — *no* es
  de acceso abierto (ejemplar propio del profesor, no se redistribuye);
  Business Calculus, Calaway/Hoffman/Lippman (2013) — acceso abierto
  (CC BY 3.0), cubre el puente cálculo-economía.
- **Unidad oficial 5 (ecuaciones diferenciales)** — internamente
  unidades 12-14: Trench (2013) — distribución gratuita autorizada por
  el autor.
- **Unidad oficial 6 (ética)** — internamente unidad 15: sin libro
  asignado — contenido y preguntas de reflexión propias.
- **Complementario/opcional:** Axler (2024) — acceso abierto, solo
  para profundidad teórica en álgebra lineal.

Citekeys en `referencias/MatEconomistas.bib`: `@stewart2021`,
`@kuttler2021`, `@buscalc2013`, `@trench2013`, `@axler2024` (ese
archivo tiene la nota completa de licencia y cobertura por unidad).
Cualquier `nocite:` nuevo (en `content/unidades/unidad-*.qmd` o en
`programa.qmd`) debe usar estas claves.

## Contenido granular y autocontenido ("lego") — Actualización 17

`content/unidades/` tiene **un archivo de presentación por tema real y
autocontenido**, no por unidad oficial del programa ni por semana del
calendario. Esto reemplaza el esquema de la Actualización 16 (un
archivo por unidad oficial, 6 archivos fusionados con hasta 3 subtemas
cada uno) por el mismo criterio ya aplicado a `estadistica/` en esta
misma sesión, a pedido explícito del usuario: *"Lo que vamos a tener en
content son presentaciones con temáticas autocontenidas. Por ejemplo,
si en algún momento quiero incluir alguna temática de teoría de juegos
en el curso de matemática, solo lo incluyo en content, y si es
necesario la convoco en caso de que quiera cubrirlo en algún momento.
[...] eso permite que la conformación del curso sea completamente
modular, es como un lego que puede variar."*

Reglas del esquema (idénticas a las de `estadistica/`, ver ese
README para el detalle completo):

- **Cada archivo es independiente** — nunca se fusionan dos temas en un
  mismo archivo, aunque la unidad oficial del programa los agrupe.
  Agregar un tema nuevo (el ejemplo del usuario: teoría de juegos) es
  simplemente agregar un archivo nuevo a `content/unidades/`; no hace
  falta tocar ningún otro archivo para que el curso pueda "convocarlo"
  el día que se quiera cubrir.
- **El número de unidad es solo interno** — vive únicamente en el
  nombre del archivo (`N_slug-presentacion.qmd`, numeración consecutiva
  desde 0 — mismo esquema ya usado en `estadistica/`, ver la
  Actualización del 2026-09-29 más abajo) y es el argumento que lee
  `render_curso(unidades = c(...))` para filtrar qué archivos renderizar
  (por el primer número que aparece en el nombre, ver
  `R/render_curso.R`). El título/subtítulo visible en cada presentación
  **no** muestra "Unidad N" — solo el nombre del tema.
- **La agrupación en sesiones de clase es flexible** — un curso de 10
  sesiones no tiene 10 archivos de contenido: cada sesión simplemente
  selecciona qué unidades cubre, vía `unidades = c(...)`. El mapeo
  vive en `programa.qmd` (tabla de cronograma), no en el nombre de los
  archivos.

### Las 15 unidades granulares (+ intro)

| # | Slug | Tema | Corresponde a la unidad oficial |
|---|---|---|---|
| 0 | `intro` | Presentación del curso (sesión 1, sin materia nueva) | — |
| 1 | `operaciones-matrices` | Operaciones con matrices (suma/resta/escalar, transponer, matriz identidad, determinante 2×2, multiplicación) + aplicación: matriz de costos | Unidad oficial 1 |
| 2 | `sistemas-ecuaciones` | Sistemas de ecuaciones lineales (Jordan-Gauss), tipos de solución + aplicación: equilibrio de mercado | Unidad oficial 1 |
| ~~3~~ | ~~`equilibrio-mercado`~~ | **Retirada el 2026-09-29** — su aplicación económica ahora cierra la unidad 2 (ver Actualización más abajo). El número 3 queda sin usar a propósito, no se renumeró el resto. | — |
| 4 | `limites-derivadas` | Límites y derivadas (propiedades, exponenciales/logarítmicas, orden superior) | Unidad oficial 2 |
| 5 | `maximos-minimos-analisis-marginal` | Máximos, mínimos y análisis marginal | Unidad oficial 2 |
| 6 | `integrales-tecnicas` | Integrales definidas, indefinidas y técnicas de integración | Unidad oficial 3 |
| 7 | `funciones-marginales-valor-presente` | Aplicaciones a la economía: funciones marginales y valor presente | Unidad oficial 3 |
| 8 | `lorenz-superavit-domar` | Curva de Lorenz, superávit y modelo de Domar | Unidad oficial 3 |
| 9 | `derivadas-parciales` | Representación gráfica y derivadas parciales | Unidad oficial 4 |
| 10 | `optimizacion-implicitas-homogeneas` | Optimización, funciones implícitas y homogéneas | Unidad oficial 4 |
| 11 | `productividad-marginal-fijacion-precios` | Aplicaciones a la economía: productividad marginal y fijación de precios | Unidad oficial 4 |
| 12 | `ecuaciones-separables-homogeneas` | Ecuaciones diferenciales: definición, separables y homogéneas | Unidad oficial 5 |
| 13 | `lineales-primer-orden-bernoulli-ricatti` | Ecuaciones lineales de primer orden, Bernoulli y Ricatti | Unidad oficial 5 |
| 14 | `segundo-orden-aplicaciones` | Ecuaciones de segundo orden y aplicaciones a la economía | Unidad oficial 5 |
| 15 | `etica` | Ética — sesión del foro evaluado, sin contenido matemático | Unidad oficial 6 |

Estado del contenido:

- **Unidad 1** (operaciones con matrices): completa (teoría, ejemplo y
  ejercicio después de cada tema — suma/resta, transponer, identidad,
  determinante, multiplicación —, aplicación económica, práctica en R)
  y con guía docente exhaustiva en
  `content/preparacion/1_operaciones-matrices-guia.qmd`.
- **Unidad 2** (sistemas de ecuaciones lineales, Gauss-Jordan):
  completa desde el 2026-09-29 (antes era un TODO) — forma matricial,
  matriz aumentada, método de Gauss-Jordan con ejemplo y ejercicio,
  tipos de solución con ejercicio, y cierra con la aplicación
  económica de equilibrio de mercado (la que antes vivía en la unidad
  3, retirada). Guía docente en
  `content/preparacion/2_sistemas-ecuaciones-guia.qmd`.
- **Unidad 15** (ética): completa — es la sesión del foro evaluado.
- **Unidades 4-14**: solo placeholders con la lista de subtemas a
  cubrir y un TODO — contenido pendiente de desarrollo, igual que en el
  esquema anterior (nada de contenido nuevo se perdió: los TODO
  conservan exactamente los mismos "contenido a cubrir" que tenían los
  archivos fusionados de la Actualización 16). No tienen guía docente
  propia todavía — se agrega cuando se desarrolle el contenido de cada
  una.

Los archivos del esquema anterior (6 archivos fusionados
`unidad-1-algebra-lineal-presentacion.qmd` ... `unidad-6-etica-
presentacion.qmd`, y la guía `unidad-1-algebra-lineal-guia.qmd`) se
movieron a
`_to_delete/matematica-economistas-unidades-fusionadas-viejo/` (el
bridge no puede borrar archivos) — quedan ahí para que el usuario los
borre a mano cuando quiera.

**Esto ya se aplicó también a `estadistica/`**, en la misma sesión y
con el mismo criterio (12 unidades granulares + intro/repaso/
investigación final, en vez de 8 unidades oficiales fusionadas) — ver
`materias/estadistica/README.md` para el detalle de esa migración,
incluyendo una advertencia de naming importante para ambas materias:
**evitar dígitos sueltos en nombres de archivos especiales** (ej. no
`repaso-caso2-presentacion.qmd`) porque `render_curso()` filtra
unidades con una expresión regular que toma el primer número que
encuentra en el nombre del archivo — un dígito suelto no relacionado
con el número de unidad puede hacer que el archivo se filtre por error
bajo esa unidad.

## El HTML final nunca muestra el número de unidad en su nombre de archivo

`render_curso()` renombra el HTML de salida de cada unidad quitándole
el prefijo numérico antes de dejarlo en `cursos/<universidad>/<periodo>/`
— por ejemplo, `7_funciones-marginales-valor-presente-presentacion.qmd`
se renderiza como `funciones-marginales-valor-presente-presentacion.html`,
sin el "7". Motivo (a pedido explícito del usuario): el número de
unidad es solo un dato de orden interno para que `unidades = c(...)`
pueda filtrar contenido — no tiene por qué coincidir con ningún número
de unidad de un programa institucional concreto (ej. si en el futuro
se agrega un tema nuevo como teoría de juegos y termina siendo la
unidad 25 de `content/unidades/`, ese "25" no tiene ningún significado
en el curso real), así que no tiene sentido que aparezca en el nombre
del archivo que de verdad se comparte con estudiantes/docentes. Este
mecanismo vive en `R/render_curso.R` (que acepta tanto el prefijo
`N_` como el viejo `unidad-N-`, ver esa sección), compartido con
`estadistica/`.

## Actualización 2026-09-29 — numeración consecutiva `N_slug`, igual que `estadistica/`

A pedido del usuario, se renombraron los 16 archivos de
`content/unidades/` y el de `content/preparacion/` para usar el mismo
esquema de numeración consecutiva ya adoptado en `estadistica/`:
prefijo `N_` en vez de `unidad-N-`, con la intro pasando de no tener
número a ser la unidad `0`. Renombrado 1 a 1 (mismo slug, mismo
número), sin fusionar ni reordenar nada:

`intro-presentacion.qmd` → `0_intro-presentacion.qmd`,
`unidad-1-operaciones-matrices-presentacion.qmd` →
`1_operaciones-matrices-presentacion.qmd`, y así consecutivamente hasta
`unidad-15-etica-presentacion.qmd` → `15_etica-presentacion.qmd`; la
única guía existente, `unidad-1-operaciones-matrices-guia.qmd` →
`1_operaciones-matrices-guia.qmd`.

Se hizo con `mv` directo (no copia), así que no quedaron archivos
viejos sueltos que borrar. Se revisaron y corrigieron las referencias
cruzadas dentro de los `.qmd` (comentarios de docente que mencionaban
el nombre de archivo viejo, incluyendo una referencia a
`estadistica/content/unidades/unidad-3-...` que ya estaba desactualizada
desde la propia migración de `estadistica`) y las de este README (ver
arriba). `render_curso.R` ya soportaba ambos prefijos (`N_` y
`unidad-N-`) desde antes, así que no requirió cambios de código — el
render de esta materia funciona igual que antes del rename, solo
cambian los nombres de archivo de origen.

Como la intro ahora es la unidad `0` (antes no tenía número y quedaba
fuera del filtro), `render_curso(unidades = c(...))` ya la incluye
automáticamente si `0` está en el vector — antes se renderizaba siempre
que `unidades = NULL`, sin filtro. Tenerlo en cuenta al armar el
`unidades = c(...)` de la Sesión 1.

## Actualización 2026-09-29 (2) — Unidad 1 replanteada, Unidad 2 desarrollada, Unidad 3 retirada

El usuario pidió replantear la Unidad 1: solo cubría operaciones
básicas (suma, escalar, multiplicación), pero el programa oficial pide
también transponer, matriz identidad, determinante, y —para esta misma
sesión de clase— sistemas de ecuaciones lineales (Gauss-Jordan) y
aplicaciones a la economía. Antes de tocar nada se preguntó
explícitamente (el usuario invitó dudas/objeciones): ¿esto implica
fusionar las unidades 1, 2 y 3 en un solo archivo (rompiendo el
esquema "lego"), o mantenerlas separadas? El usuario respondió:
**2 archivos separados** (no 3) — Unidad 1 = operaciones (incluyendo
transponer, identidad, determinante), Unidad 2 = Gauss-Jordan, y
**ambas cierran con su propia aplicación económica** en vez de tener
una tercera unidad dedicada solo a aplicaciones. El usuario confirmó
además que **este debe ser el patrón para el resto de las
presentaciones del curso**: cada unidad temática cierra con su propia
aplicación a la economía, no se agrupan aparte.

Como consecuencia, la antigua Unidad 3 (`equilibrio-mercado`, que era
solo un TODO) quedó redundante — su aplicación económica se absorbió
en el cierre de la Unidad 2. Se movió a
`_to_delete/matematica-economistas-unidad-3-equilibrio-mercado-viejo/`
(el bridge no puede borrar archivos; queda ahí para que el usuario la
borre a mano cuando quiera). El número `3` queda intencionalmente sin
usar — no se renumeró el resto de unidades (4 a 15), consistente con
que el número interno no tiene que ser contiguo ni tener significado
real (ver la sección "Por qué el nombre de salida nunca lleva el
número de unidad" en `R/README.md`).

**Contenido nuevo de la Unidad 1** (además de lo que ya tenía):
transponer ($A^T$), matriz identidad ($I_n$, neutro multiplicativo) y
determinante $2\times2$ ($\det(A)=ad-bc$, interpretado como anticipo de
si un sistema va a tener solución única). Cada tema nuevo sigue el
patrón definición → ejemplo resuelto en conjunto → ejercicio para el
estudiante → solución, a pedido explícito del usuario porque esta
sesión cubre la clase completa (3 horas).

**Contenido nuevo de la Unidad 2** (antes un TODO vacío): forma
matricial $Ax=b$, matriz aumentada, las tres operaciones elementales
de fila, el método de Gauss-Jordan con un ejemplo y un ejercicio
resueltos paso a paso, los tres tipos de solución (única/infinitas/
ninguna) con un ejercicio, y cierra con la aplicación económica de
equilibrio de mercado (sistema de oferta/demanda linealizado, resuelto
con Gauss-Jordan para precio y cantidad de equilibrio) — contenido que
antes iba a vivir en la unidad 3 retirada.

Se creó `content/preparacion/2_sistemas-ecuaciones-guia.qmd` (no
existía antes) y se actualizó `1_operaciones-matrices-guia.qmd` para
cubrir el contenido nuevo, ambas con la misma profundidad y estilo que
el resto de guías docente del curso (desarrollo matemático completo,
capítulos sugeridos, distribución de tiempo). La distribución de
tiempo de la Unidad 1 quedó más ajustada (buffer de ~45 min en vez de
~67) por el contenido agregado a la misma duración de sesión — ver el
detalle en esa guía.

## Actualización 2026-10-01 — objeción del usuario, contenido ahora grounded en el PDF real de Kuttler

El usuario revisó la Unidad 1 replanteada (actualización anterior) y
planteó tres objeciones, todas atendidas:

1. **"¿Por qué no se incluyó nada sobre matriz inversa?"** — no se
   había incluido; se agregó. Definición, condición de existencia
   ($\det(A)\neq0$) y fórmula directa para $2\times2$, con ejemplo y
   ejercicio, en `1_operaciones-matrices-presentacion.qmd` (nueva
   sección, justo después del determinante) y su guía.
2. **"Creo importante mencionar el cálculo del determinante para
   matrices de 3×3 y explicar métodos para órdenes superiores"** — se
   agregó: determinante $3\times3$ por expansión de cofactores/Laplace
   (con ejemplo y ejercicio), y una sección conceptual sobre órdenes
   superiores ($4\times4$ en adelante) explicando las dos salidas
   reales: expansión de Laplace recursiva (crece como $O(n!)$) y
   triangulación por filas (el método que realmente se usa, y que
   conecta directamente con Gauss-Jordan de la Unidad 2).
3. **"¿No se basó en el libro de Kuttler?"** — respuesta honesta: la
   versión del 2026-09-29 **no se verificó contra el PDF real**, se
   escribió de memoria general sobre álgebra lineal. Se corrigió:
   se extrajo el texto completo del PDF
   (`bibliografia/A first Course in Linear Algebra_Kuttler.pdf`, 90MB)
   con `pdftotext -layout` y el contenido nuevo (y las referencias de
   sección de todo el archivo) están verificados contra el texto real:
   sección 2.6 "The Identity and Inverses", 2.7 "Finding the Inverse
   of a Matrix", 3.1 "Basic Techniques" (menores, cofactores, Laplace,
   matrices triangulares) y 3.2 "Properties of Determinants" (efecto
   de las operaciones elementales sobre el determinante). El algoritmo
   general de Kuttler para invertir matrices $n>2$ usa la matriz
   aumentada $[A\mid I]$ reducida con Gauss-Jordan — se decidió NO
   duplicarlo en la Unidad 1 y dejarlo para la Unidad 2, una vez que
   el grupo ya domina Gauss-Jordan.

**El usuario también editó el archivo directamente**: eliminó el
ejercicio de "Matriz identidad" (quedó solo definición + ejemplo). Se
respetó ese cambio — no se restauró ni se reinterpretó — siguiendo el
mismo criterio que ya regía para `estadistica/` (ver el aviso "NO
REVERTIR" en `R/README.md`): el archivo real, editado a mano por el
profesor, es la fuente de verdad por encima de cualquier plan o
versión anterior generada por Claude.

**Costo en tiempo:** el contenido nuevo (determinante 3×3, órdenes
superiores, inversa) agrega ~25 minutos a una sesión que ya estaba
ajustada. El buffer de la Unidad 1 bajó de ~45 min a ~23 min — ver la
sección "Distribución de tiempo" de `1_operaciones-matrices-guia.qmd`
para el detalle y las opciones de recorte si el grupo va lento.
Siguiente vez que se replantee una unidad de este curso, vale la pena
preguntar primero el tiempo disponible, no solo el contenido.

## La salida de cada curso se organiza en 3 subcarpetas

`cursos/<universidad>/<periodo>/` ya no deja todos los `.html` sueltos
en la raíz — a pedido explícito del usuario, `nuevo_curso()` crea (y
`render_curso()` refuerza) 3 subcarpetas:

- **`presentaciones/`** — unidades (`-presentacion.qmd`) y guías
  docente (`-guia.qmd` de `content/preparacion/`).
- **`documentos/`** — `programa.qmd`, el resto de `content/docs/`, y
  `content/tareas/` (evaluaciones — hoy `estudio-de-caso.qmd` y
  `portafolio.qmd`).
- **`laboratorios/`** — prácticas y laboratorios. Hoy ningún archivo
  de `content/` rinde acá — la carpeta se crea igual, lista para
  cuando haga falta. Mismo mecanismo en `R/render_curso.R`,
  compartido con `estadistica/`.

## Estilo visual del programa — institucional, no la marca personal

`programa.qmd` es el único documento de la materia con identidad
visual **institucional** (logo de Fidélitas, azul `#2F5496`, tablas
estilo docx) en vez de la marca personal índigo del resto del repo —
es el documento que se comparte con estudiantes, así que replica el
formato del programa oficial en Word. Vive en
`content/docs/institucional.scss` (`theme:` propio de este archivo +
`brand: false`, no afecta a `_brand.yml`/`styles.scss` del resto del
repo). El resto de la materia (slides, notas de orador) sigue usando
la marca personal sin cambios — ver Actualización 3 del plan.

## Diseño visual y convenciones de contenido (slides, no el programa)

No se repiten aquí — son compartidas con `estadistica/` y viven en el
plan de proyecto (Actualización 3): paleta `_brand.yml`, clases
`.divisor`/`.destacado`/`.idea-clave`/`.agenda`, slide de título nativa
de reveal.js, notas de orador como guion, doc de preparación docente
exhaustivo por unidad.

## Orquestación del render — `render_curso()`, no comandos sueltos

Todo el render de la materia (unidades, tareas, docs, preparación) se
centraliza en `R/render_curso.R` — no se corren comandos `quarto
render` sueltos por archivo. Relevante para esta materia:

- `incluir_docs = TRUE/FALSE` controla el resto de `content/docs/`
  (ej. `guia-lecturas.qmd`), y `incluir_programa = TRUE/FALSE` controla
  `programa.qmd` por separado (Actualización 13 — reemplaza la decisión
  anterior de mantenerlos juntos): sirve para re-renderizar solo el
  programa sin tocar el resto de la documentación, algo que se necesita
  seguido mientras se ajusta el cronograma/evaluación.
- `formato` (ver arriba) sigue el mismo patrón que `unidades`: se
  guarda en el `_variables.yml` del curso y se puede pisar puntualmente
  pasándolo a `render_curso()` sin editar el archivo.
- `unidades` (Actualización 16, antes `semanas`; granular desde la
  Actualización 17): selecciona qué archivos de `content/unidades/`
  renderizar, por el número en el nombre del archivo. Como ahora las
  unidades son granulares, una sesión que cubre varios temas pasa un
  vector, por ejemplo `unidades = c(1, 2, 3)` para la Sesión 2 (que
  cubre operaciones con matrices, sistemas de ecuaciones y equilibrio
  de mercado según el cronograma de `programa.qmd`), no un solo número
  como antes. `semanas` sigue funcionando como alias retrocompatible
  en `render_curso()` (ya no lo usa ninguna materia, se mantiene por si
  hace falta a futuro), pero en código nuevo de esta materia usar
  `unidades`.

## Pendiente

- Verificar el render real de `programa.qmd` en ambos formatos, y de
  todos los archivos de `content/unidades/` y `content/preparacion/`
  (este entorno de trabajo no tiene Quarto/R instalado para probarlo)
  — esto incluye probar `render_curso()` con `unidades = c(...)`
  (varias unidades a la vez) y con el `formato` nuevo, no solo el
  `quarto render` manual.
- Confirmar duración exacta de cada sesión bajo el esquema de 10
  sesiones (el campo queda "Por confirmar" en el HTML mientras tanto).
- Desarrollar el contenido pendiente de las unidades 4 a 14 (ver la
  tabla de arriba para el detalle de qué cubre cada una) y sus guías
  docentes correspondientes en `content/preparacion/` — siguiendo el
  patrón acordado el 2026-09-29: cada unidad cierra con su propia
  aplicación económica.
- Verificar con un render real el contenido nuevo de las unidades 1 y 2
  (transponer/identidad/determinante 2×2 y 3×3/inversa, Gauss-Jordan) —
  no se pudo probar en este entorno de trabajo (sin Quarto/R). Revisar
  en particular el chunk de R de la Unidad 1 (construcción de la matriz
  `A` con `matrix(..., byrow = TRUE)`, y que `solve(A)` no truene con
  la matriz de ejemplo, antes de proyectarlo en clase).
- Decidir si la Unidad 1 (ahora con determinante 3×3, órdenes
  superiores e inversa agregados el 2026-10-01) sigue cabiendo en una
  sola sesión de 180 min con un buffer de ~23 min, o si conviene
  partirla en dos sesiones — ver la alerta de tiempo en
  `1_operaciones-matrices-guia.qmd`.
- Borrar a mano
  `_to_delete/matematica-economistas-unidad-3-equilibrio-mercado-viejo/`
  una vez confirmado que el contenido nuevo de la Unidad 2 cubre bien
  lo que tenía esa unidad retirada.
- Borrar a mano
  `_to_delete/matematica-economistas-unidades-fusionadas-viejo/` una
  vez confirmado que el contenido nuevo en `content/unidades/` y
  `content/preparacion/` renderiza bien.
- Verificar que no queden referencias sueltas a los nombres de archivo
  viejos (`unidad-1-algebra-lineal-*`, etc., del esquema fusionado
  retirado en la Actualización 17) en otros documentos del repo aparte
  de los ya revisados.
- Verificar con un render real que el rename del 2026-09-29 (prefijo
  `N_` en vez de `unidad-N-`, intro como unidad `0`) funciona igual que
  antes — no se pudo probar en este entorno de trabajo (sin Quarto/R).
