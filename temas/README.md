# Temas

Base de consulta personal — cualquier tema estadístico, no solo los
de un curso específico. Cada tema sigue el mismo patrón de 3 archivos:

- `resumen.qmd` — la teoría, fórmulas clave, cuándo se usa
- `practica.qmd` — ejercicios autocontenidos con solución colapsable
- `laboratorio.qmd` — código R para explorar el concepto

Todo dentro de `temas/` renderiza como documento HTML normal (no
slides) — ver `_metadata.yml` en esta carpeta.

## Temas disponibles

- [Probabilidad condicional](probabilidad-condicional/resumen.qmd)

## Agregar un tema nuevo

```r
dir.create("temas/nombre-del-tema", recursive = TRUE)
# copia los 3 .qmd de un tema existente como plantilla
```

No hace falta tocar `_quarto.yml` ni ningún script de R — el
`_metadata.yml` de esta carpeta ya aplica a cualquier subcarpeta nueva.
