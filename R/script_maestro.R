# R/script_maestro.R
#
# Punto de entrada único para trabajar un curso: cambiás las 4 variables
# de abajo (materia/universidad/año/cuatrimestre) y de ahí corrés las
# líneas que necesites — no hace falta tocar nuevo_curso.R ni
# render_curso.R directamente.
#
# Pensado para abrir este archivo y ejecutar línea por línea (o bloque
# por bloque) según lo que quieras hacer en el momento: crear el curso
# una vez, y después renderizar semana por semana mientras vas
# escribiendo el contenido, o todo de una vez cuando ya esté completo.

# ---- 1. Configuración del curso actual — EDITÁ ESTO cuando cambies
#         de periodo, universidad, o de materia ---------------------

MATERIA     <- "matematica-economistas"
UNIVERSIDAD <- "FIDELITAS"
ANIO        <- 2026
CUATRI      <- 3

# ---- 2. Carga las funciones (no hace falta tocar esto) -------------

source("R/nuevo_curso.R")
source("R/render_curso.R")

# ---- 3. Crear el curso — se corre UNA VEZ por periodo --------------
#
# Ya existe materias/matematica-economistas/cursos/FIDELITAS/2026-C3/
# _variables.yml para el curso actual — no hace falta correr esto de
# nuevo salvo que cambien las fechas, los feriados, o el logo. Si vas a
# dar el curso en un periodo nuevo (ej. 2027-C1), actualizá las
# variables de la sección 1 arriba y descomentá este bloque:

# nuevo_curso(
#   materia      = MATERIA,
#   universidad  = UNIVERSIDAD,
#   anio         = ANIO,
#   cuatri       = CUATRI,
#   fecha_inicio = "2026-09-18",
#   feriados     = character(0),
#   logo_path    = "/images/logos/fidelitas.jpg"
# )

# ---- 4. Renderizar — la parte que vas a usar más seguido -----------
#
# Mientras estás escribiendo/corrigiendo una unidad puntual, renderizá
# solo esa (mucho más rápido que esperar las 13). `unidades = c(0, 1)`
# abajo es la Sesión 1 de hoy (18 set): intro (0) + Unidad 1 -
# Descripción de datos (1). incluir_preparacion = TRUE acá porque
# también querés la guía docente de esas mismas unidades.

render_curso(
  materia = MATERIA, 
  universidad = UNIVERSIDAD,
  anio = 2026, cuatri = 3, formato = "10-sesiones",
  unidades = c(1, 2),  
  incluir_tareas = TRUE,
  incluir_docs = FALSE, 
  incluir_programa = FALSE,
  incluir_preparacion = TRUE
)

# Un rango de unidades puntual:

# render_curso(materia = MATERIA, universidad = UNIVERSIDAD,
#              anio = ANIO, cuatri = CUATRI,
#              unidades = 0:3,
#              incluir_tareas = FALSE, incluir_docs = FALSE,
#              incluir_preparacion = FALSE)

# Solo los documentos de preparación docente (para estudiar antes de
# una unidad puntual, sin re-renderizar la presentación):

# render_curso(materia = MATERIA, universidad = UNIVERSIDAD,
#              anio = ANIO, cuatri = CUATRI,
#              unidades = integer(0),
#              incluir_tareas = FALSE, incluir_docs = FALSE,
#              incluir_preparacion = TRUE)

# Cuando el curso ya esté completo, corrida completa (todas las
# unidades + tareas + docs + preparación docente):

# render_curso(materia = MATERIA, universidad = UNIVERSIDAD,
#              anio = ANIO, cuatri = CUATRI)

# ---- Dónde queda todo -------------------------------------------------
#
# Nunca en materias/<materia>/content/ — si ves un .html suelto ahí, es
# un residuo de una prueba manual (ej. correr quarto_render() a mano
# sin pasar por render_curso()) y se puede borrar sin problema.
