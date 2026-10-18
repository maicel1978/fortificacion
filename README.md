# Plataforma e-learning de fortificación de alimentos

Sitio Quarto con los módulos de capacitación de la consultoría. Corresponde a
los puntos 9 a 17 de las notas metodológicas de los términos de referencia. El
análisis de la ENGIH 2018 y sus informes viven en el repositorio
`analisis_ENGIH2018` y tienen su propia hoja de ruta.

## Abrir en local

```
git clone https://github.com/maicel1978/fortificacion.git
```

Abrir `fortificacion.Rproj` en RStudio. El proyecto está configurado como sitio
web, de modo que el panel **Build → Render Website** funciona sin más ajustes.

Dependencias de R, la primera vez:

```r
source("install_packages.R")
```

Requiere además Quarto instalado y en el `PATH`.

## Trabajar

```
quarto preview
```

Levanta el sitio en el navegador y recarga al guardar. Para una compilación
completa:

```
quarto render
```

La salida va a `docs/`, que **no se versiona**: la construye Netlify.

### El caché de ejecución, que es lo que más confunde

El entorno de compilación de Netlify **no tiene R**. Cualquier módulo con
código R se sirve desde el resultado congelado en `_freeze/`, que sí se
versiona.

La consecuencia práctica: si usted toca un módulo con código R, tiene que
**renderizarlo en local y subir su carpeta de `_freeze/` junto con el `.qmd`**.
Si sube solo el `.qmd`, el sitio publicado seguirá mostrando el resultado
anterior sin avisar.

```
quarto render contenido/actividades/tema05/modulo24.qmd
git add contenido/actividades/tema05/modulo24.qmd _freeze/
```

## Datos

Los microdatos de la ENGIH 2018 no se versionan ni se publican. Para compilar
el módulo 24 se solicitan a la Oficina Nacional de Estadística y se colocan en
`_datos/`, carpeta excluida por `.gitignore` y que Quarto no publica. Las
tablas de factores de conversión y de porción comestible están en
`static/data/referencia/` y se publican: no contienen información de hogares.

## Estructura

```
contenido/actividades/   módulos 01-17 y 24-30, por tema
contenido/ejercicios/    ejercicios interactivos de los módulos 01-17
contenido/recursos/      scripts y material de apoyo
_entregables/            guion técnico-pedagógico, banco de preguntas y
                         presentaciones por módulo (PPTX y PDF)
_freeze/                 resultados de ejecución congelados (se versiona)
static/                  imágenes, tablas de referencia y scripts
```

Los documentos de `_entregables/` son Quarto. Se compilan a Word con
`quarto render _entregables/guion_tecnico_pedagogico.qmd` y
`quarto render _entregables/banco_preguntas.qmd`.

## Publicación

Netlify compila desde `main` con el plugin de Quarto y publica `docs/`. Un
cambio llega al sitio al fusionar a `main`.
