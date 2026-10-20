# Plataforma e-learning de fortificación de alimentos

Sitio Quarto con los módulos de capacitación sobre cobertura, consumo y
contribución de alimentos fortificados y fortificables, publicado en
<https://fortificacion.netlify.app>. Corresponde a los puntos 9 a 17 de los
términos de referencia de la consultoría del Programa Mundial de Alimentos.

La cadena de análisis de la ENGIH 2018, el informe analítico y el manual
técnico están en <https://github.com/maicel1978/analisis_ENGIH2018>.

## Abrir en local

```
git clone https://github.com/maicel1978/fortificacion.git
```

Abrir `fortificacion.Rproj` en RStudio. El proyecto está configurado como sitio
web, de modo que el panel **Build → Render Website** funciona sin más ajustes.

Dependencias de R, la primera vez (solo para los módulos con código):

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

### Caché de ejecución

El entorno de compilación de Netlify no tiene R. Cualquier módulo con
código R se sirve desde el resultado congelado en `_freeze/`, que sí se
versiona.

Al modificar un módulo con código R se renderiza en local y se sube su carpeta
de `_freeze/` junto con el `.qmd`; si se sube solo el `.qmd`, el sitio
publicado conserva el resultado anterior.

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
contenido/recursos/      tablas, podcast y archivos descargables
_entregables/            guion técnico-pedagógico, banco de preguntas y
                         presentaciones por módulo (PPTX y PDF)
_freeze/                 resultados de ejecución congelados (se versiona)
static/                  imágenes, tablas de referencia y scripts
_footer.html             asistente de consulta (se incluye en todas las páginas)
netlify/functions/       función intermediaria del asistente
```

Los documentos de `_entregables/` son Quarto. Se compilan a Word con
`quarto render _entregables/guion_tecnico_pedagogico.qmd` y
`quarto render _entregables/banco_preguntas.qmd`.

## Publicación

Netlify compila desde `main` con el plugin de Quarto y publica `docs/`. Un
cambio llega al sitio al fusionar a `main`.

## Asistente de consulta

`_footer.html` contiene la interfaz; `netlify/functions/groq-proxy.mjs`
reenvía las consultas a la API de Groq. La clave no está en el repositorio: la
función la lee de la variable de entorno `GROQ_API_KEY` de Netlify (Site
configuration → Environment variables), que debe tener habilitado el alcance
*Functions*. El modelo se fija en la función (`llama-3.3-70b-versatile`) y puede
cambiarse sin tocar el código definiendo la variable `GROQ_MODEL`. Si Groq
retira el modelo, basta con cambiar ese valor por uno de la lista de modelos
vigentes de Groq.

En la vista previa local (`quarto preview`) el asistente aparece, pero no
responde: la función solo existe en Netlify.
