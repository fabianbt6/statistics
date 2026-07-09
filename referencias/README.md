# Referencias

`Estadistica.bib` es el archivo de bibliografía **compartido** entre
toda la materia, `temas/`, y eventuales artículos que decidas mantener
aquí. Quarto lo lee a nivel de proyecto (`bibliography:` en
`_quarto.yml`), así que cualquier `.qmd` puede citar con `[@clave]` sin
configurar nada adicional.

## Conectarlo a tu Zotero real

1. En Zotero, crea (o usa) una colección específica — ej. "Estadística".
2. Clic derecho sobre la colección → **Export Collection**.
3. Formato: **Better BibTeX**. Marca **Keep Updated**.
4. Guarda el archivo apuntando directo a:
   `C:\Users\FBrenes\...\repos\statistics\referencias\Estadistica.bib`
   (sobreescribe el placeholder que ya está aquí).

Esto es una exportación **independiente** de la que ya tienes hacia
`Biblioteca/` — no interfieren entre sí. El mismo ítem puede estar en
ambas colecciones sin duplicar tu librería.

## Citekeys

Como usas Better BibTeX, tus citekeys reales van a depender de tu
fórmula configurada (Zotero → Settings → Better BibTeX → Citation Keys)
— pueden no coincidir con los placeholder de este archivo
(`hogg2015`, `sahu2024`, etc.). Cuando conectes tu colección real:

1. Revisa las claves reales que generó Better BibTeX.
2. Ajusta los `[@clave]` en los `.qmd` que citan (por ahora, solo
   `materias/estadistica/content/blocks/bibliografia.qmd`) para que
   coincidan.

## Uso en un documento

```markdown
## Bibliografía

::: {#refs}
:::
```

Con `nocite: | @hogg2015, @sahu2024` en el YAML del documento que
incluye este bloque — ver el comentario en `bibliografia.qmd` para el
porqué de este patrón.
