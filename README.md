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

## Qué no se sube

- `docs/`, `.quarto/`, `node_modules/`: generados.
- **Microdatos de la encuesta.** `static/data/` contiene hoy
  `Registros_Cuestionario_B.xlsx` y `Sociodemograficas_e_ingresos.xlsx`, que
  son registros de hogar. Están rastreados desde antes de esta regla y su
  retirada es una decisión abierta, registrada en la hoja de ruta del análisis.
  No se añaden más.
- La tabla de composición de alimentos sí es material docente y puede estar.

## Estructura

```
contenido/actividades/   módulos e-learning, por tema
contenido/ejercicios/    ejercicios interactivos
contenido/recursos/      scripts y material de apoyo
_entregables/            presentaciones de síntesis por módulo
_freeze/                 resultados de ejecución congelados (se versiona)
_notas/                  hoja de ruta de este repositorio
static/                  datos y scripts que los módulos leen
```

## Publicación

Netlify compila desde `main` con el plugin de Quarto y publica `docs/`. Hay
además dos flujos de trabajo en `.github/workflows/`.

Un cambio llega al sitio al fusionar a `main`. Las ramas de trabajo no publican.

## Estado

El estado verificado, la correspondencia con los términos de referencia y la
cola de trabajo están en `_notas/HOJA_DE_RUTA_FORTIFICACION.md`. Al retomar una
sesión se contrasta ese documento con el último commit de `main`; si no
coinciden, manda el repositorio.
