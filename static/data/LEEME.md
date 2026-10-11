# Datos de esta carpeta

## Qué hay aquí

- `Registros_Cuestionario_B.xlsx` — microdatos de la ENGIH 2018, Banco Central
  de la República Dominicana. Registros a nivel de hogar.
- `Sociodemograficas_e_ingresos.xlsx` — características sociodemográficas e
  ingresos de los hogares de la misma encuesta.
- `tabla_coposicion_alimentos.xlsx` — tabla de composición de alimentos.
  Material docente, sin registros de hogares.

## Quién los usa

Solo dos piezas, y ninguna en el sitio publicado:

- `contenido/actividades/tema05/modulo24.qmd`
- `static/r/cantidad_alimentos.R`

El tema 5 está congelado en `_freeze/`, de modo que el build de Netlify **no
ejecuta** ese código y no necesita estos archivos. Hacen falta únicamente para
rerenderizar el módulo 24 en local.

## Por qué los dos primeros no se sirven en la web

Son microdatos de hogares. `netlify.toml` tiene una regla que devuelve 404 para
esos dos archivos, con `force = true` para que tenga prioridad sobre el archivo
estático. La tabla de composición sí queda disponible.

## Decisión pendiente

Que no se sirvan en la web no resuelve que estén **versionados en un
repositorio público**. Eso depende de las condiciones bajo las que se recibieron
los archivos y se decide aparte. Las opciones, de menor a mayor costo:

1. Dejarlos, si su licencia permite la redistribución.
2. Sacarlos del seguimiento de git y conservarlos solo en local. No los borra
   de la historia: siguen descargables desde cualquier commit anterior.
3. Reescribir la historia con `git filter-repo` y pedir a soporte de GitHub que
   recoja los objetos sueltos. Cambia el hash de todos los commits.
4. Sustituirlos por un extracto derivado suficiente para el módulo. El módulo 24
   enseña un procedimiento; no necesita los 342.046 registros completos.
