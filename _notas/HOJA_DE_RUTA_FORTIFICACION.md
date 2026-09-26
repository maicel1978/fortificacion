# Hoja de ruta — Plataforma e-learning de fortificación (repo `fortificacion`)

**Creada:** 2026-09-26
**Última actualización:** 2026-09-26
**Fecha límite contractual (NTE):** 2026-10-25
**Alcance:** entregables del TdR que viven en este repositorio (ítems 9–17 de las notas metodológicas y categorías 1–5 de "Structure and Content"). El análisis de la ENGIH 2018 y sus informes se rigen por la hoja de ruta del repo `analisis_ENGIH2018`.

Este documento es la referencia de estado. Al retomar una sesión se contrasta con el último commit de `main`; si no coinciden, manda el repositorio.

---

## 1. Estado verificado al 2026-09-26

| Commit | Contenido |
|---|---|
| `946d1a0` | Configuración de navegación, `install_packages.R` e índices recuperados de la copia local previa |
| `4a1190e` | Modelo del asistente embebido actualizado (`openai/gpt-oss-20b`, reemplazo del modelo retirado por el proveedor); terminología unificada a EMA en módulos 10 y 24 |
| `2700632` | Resultado de ejecución de R del módulo 24 congelado en `_freeze` |
| `257dbad` | Erratas en títulos y descripciones de los módulos 01–17 |
| `d0d6447`, `e70d6eb`, `5f47e1a` | Auditoría de referencias de los módulos 01–17 |

Entorno de trabajo: clon en `C:\proyectos\fortificacion`, fuera de carpetas sincronizadas. Despliegue: Netlify, con el plugin de Quarto, renderizando desde `main` y publicando `docs/`. El entorno de build de Netlify no dispone de R: todo módulo con código R cuyo caché se invalide debe renderizarse localmente y subirse junto con su carpeta en `_freeze/`.

## 2. Correspondencia con la estructura del TdR

| TdR | Contenido exigido | Módulos | Estado |
|---|---|---|---|
| 1.1 | Introducción a la fortificación | 01, 02 | Existe |
| 1.2 | Evaluación dietética con encuestas de gasto y consumo | 06 | Existe |
| 1.3 | Procesamiento de datos de consumo | 09, 10 | Existe |
| 1.4 | Ajuste por EMA | 11, 12 | Existe |
| 1.5 | Tablas de composición | 07, 08 | Existe |
| 1.6 | Adecuación: punto de corte del EAR y enfoque probabilístico para hierro | 03, 04 | Existe |
| 2.1 | Políticas de fortificación | 02, 05, 14–17 | Existe |
| 3.1 | Introducción a R | — (curso propio externo, temas I–IV) | Contenido existe fuera de la plataforma; falta integrarlo |
| 3.2 | Visualización con ggplot2 | — (curso propio externo, tema VI) | Parcial: el curso usa ggstatsplot; falta ggplot2 explícito |
| 3.3 | Análisis de encuestas con srvyr | — | Falta (solo uso incidental en 23) |
| 3.4 | Mapas en R | — | Falta |
| 4.0 | Introducción a la base de datos | — | Falta |
| 4.1–4.4 | Aplicación con la ENGIH 2018 | 18–21, 23, 24 | Existe sin datos reales: 18, 20, 21, 22 y 23 usan datos simulados; 19 usa ENHOGAR con datos hipotéticos |
| 5.1 | Síntesis de aprendizajes | — | Falta |

Observaciones técnicas abiertas:

- Módulo 21: SPADE estima ingesta usual a partir de mediciones individuales repetidas. Los datos de gasto se registran por hogar y no permiten separar varianza intra e interpersona. Revisar su pertinencia frente al enfoque probabilístico sobre ingesta aparente ajustada por EMA.
- Módulo 22 (calidad de la dieta): sin correspondencia en el TdR. Decidir si se mantiene como complementario o se retira.
- Módulo 13: menciona AME y AFE como equivalentes en el cálculo aplicado; el resto del material usa solo EMA. Requiere corrección de contenido, no de terminología.
- Categoría 3, decisión propuesta: el desarrollo genérico de R (entorno, tidyverse, ggplot2, srvyr, mapas) se mantiene y amplía en el curso propio externo, fuera del plazo contractual; la plataforma incluye una versión mínima aplicada a la ENGIH (tarea B3). Pendiente de validación con los supervisores.
- Categoría 3, antecedentes: el curso propio "Análisis de datos en fortificación de alimentos a gran escala con R" (bioestadisticaedu.com/teaching/r) cubre importación, orden, manipulación, tablas y gráficos. No cubre srvyr ni mapas. Su licencia actual (CC BY-NC-ND 4.0) y el traspaso de los entregables al PMA requieren que el contenido se integre en la plataforma con una licencia compatible; un enlace externo no constituye entrega.
- Módulo 20: usa `nutriR::calc_prevalencia_rpe`; el paquete no se localiza en CRAN. Sustituir por implementación verificada.
- Referencias: el módulo 06 asigna PMID a documentos no indexados en PubMed (Banco Mundial, IFPRI). Todas las listas de referencias requieren auditoría antes de cualquier presentación externa.
- Erratas en títulos visibles: "Biblografía" en 17 módulos; "Importacia" (05), "procedimeintos" (12), "introdución" (04), "sumario" en minúscula (04), "Bibliografia" sin tilde (13).
- Uso de datos: categorías 1 y 2 sin datos; categoría 4 y unidades 3.x con la ENGIH real. Para el participante se publican tablas derivadas agregadas (provincia, quintil) que no identifican hogares.
- Microdatos: la ENGIH 2018 no se publica en el repositorio. Los ejercicios deben indicar cómo obtener los datos de la fuente oficial y trabajar con rutas locales, o con agregados que no identifiquen hogares.

## 3. Criterios de calidad aplicables a todo entregable

- Toda cifra procede de la ENGIH 2018 procesada en `analisis_ENGIH2018`; no se usan datos simulados (Nota Metodológica 5).
- Toda referencia bibliográfica se verifica contra la fuente (DOI, sitio del editor u organismo) antes de incorporarse.
- Todo cambio con código R se renderiza localmente antes del commit; el commit incluye su `_freeze`.
- Registro técnico y sobrio; sin nombres de personas en código ni documentación.
- Cada módulo incluye la advertencia de portabilidad del ítem 9 del TdR donde contenga código.

## 4. Plan por fases

Orden de ejecución por impacto visible y dependencia. Las tareas marcadas (M) son mecánicas y sirven para bloques cortos; las marcadas (C) exigen criterio y no deben iniciarse si la sesión se va a interrumpir.

### Fase A — Entregables sin dependencia de datos (semana del 28/09)

- [x] **A1 (C). Guion instruccional y técnico-pedagógico (GITP), Word.** Borrador v0.1 generado el 2026-09-26; pendiente de revisión propia y envío. Ítem 14 del TdR. Por módulo: objetivos de aprendizaje, contenidos, flujo, recursos, evaluación y estado. Incluye la tabla de la sección 2 y una propuesta de reorganización justificada (A2). Entregable para la reunión de inicio de semana.
- [ ] **A2 (C). Reorganización de la navegación del sitio por categorías del TdR.** Solo `_quarto.yml`, listados e índices; sin renombrar archivos, para no romper enlaces ni videos ya publicados. Se implementa en una rama con vista previa de Netlify y se presenta a los supervisores antes de fusionar con `main`.
- [ ] **A3 (M). Nota de portabilidad del código** (ítem 9) en los módulos de los temas 03–05.
- [x] **A0 (M). Corrección de erratas en títulos visibles.** Módulos 01–17 cerrados (`257dbad`). Las erratas de los módulos 18–24 se corrigen en la reescritura (B1), porque editarlos invalida el caché de R. Lista en la sección 2. Prioridad máxima por visibilidad; bloque de 20 minutos.
- [x] **A4 (M). Auditoría de referencias por módulo** (ítem 13). Verificar cada referencia contra DOI, PubMed o sitio del editor; retirar o corregir identificadores incongruentes (empezar por el módulo 06). Referencias de los temas 05 y siguientes, después de la reescritura. Cerrada para los módulos 01–17: referencias no localizadas retiradas, autores y datos corregidos, PMID sin verificar eliminados. Retiradas sin reemplazo por no verificarse: Yoo et al. 2019 y Deharveng et al. 1999 (08), guía OMS de harina de maíz (15). En el módulo 01 se retiraron cifras de anemia regional no localizadas en la fuente citada; incorporar un dato verificado si se considera necesario.
- [ ] **A5 (M). Completar autoevaluaciones de los ejercicios 01–17 hasta 3–5 preguntas con clave** (ítem 17); conteo preliminar por debajo del mínimo en 02, 04, 05 y 08.
- [ ] **A6 (M). Corrección de contenido del módulo 13** (AME/AFE).

### Fase B — Contenido dependiente de resultados de la ENGIH 2018 (semana del 05/10)

Requiere el informe de factibilidad y los informes R1–R5 de `analisis_ENGIH2018`.

- [ ] **B0 (M). Unidad 4.0, introducción a la base de datos**, a partir del informe de factibilidad.
- [ ] **B1 (C). Reescritura del tema 05 con resultados reales**, empezando por el módulo 19 (retirar ENHOGAR y el caso hipotético); incluye sustituir el paquete del módulo 20 y los datos simulados de 18, 20, 21, 22 y 23. Donde la línea base normativa no esté resuelta, se presentan escenarios, como en R4.
- [ ] **B2 (C). Decisión sobre los módulos 21 y 22** según las observaciones de la sección 2.
- [ ] **B3 (M). Categoría 3, versión mínima aplicada.** Una página por subtema 3.1–3.4: objetivo, explicación breve, ejemplo resuelto sobre la ENGIH, script, 3–5 preguntas y remisión al curso propio como versión ampliada. Código de 3.3 (diseño muestral) y 3.4 (mapas provinciales) extraído del flujo ya validado en `analisis_ENGIH2018`. Los PDF y scripts que se citen se copian dentro del repositorio.
- [ ] **B4 (M). Banco de preguntas del tema 05 y de los módulos nuevos.**
- [ ] **B5 (C). Módulo 5.1 de síntesis.**

### Fase C — Materiales descargables y consolidación (semanas del 12/10 y 19/10)

- [ ] **C1 (M). Presentaciones de síntesis por módulo** (ítem 15). Un archivo Quarto por módulo con salida `pptx` (editable, cumple el formato PPT del TdR) y exportación a PDF. Carpeta `entregables/presentaciones/`, enlazada desde cada módulo como material descargable.
- [ ] **C2 (C). Manual técnico consolidado, 20–30 páginas** (ítem 18): metodología, procedimientos, supuestos y referencias.
- [ ] **C3. Video-lecciones.** Existen enlaces de YouTube para 17 módulos. Confirmar con los supervisores si los enlaces satisfacen el formato MP4 del TdR; producir los de los módulos nuevos o reescritos.
- [ ] **C4 (M). Paquete final de entregables y README del repositorio.**
- [ ] **C5. Traspaso a repositorios propiedad del PMA**, según el Plan de Trabajo.

## 5. Decisiones que corresponden a los supervisores

1. Reorganización del sitio según la numeración del TdR (A2).
2. Pertinencia de SPADE (módulo 21) y permanencia del módulo 22.
3. Formato aceptado para video-lecciones (enlace de YouTube o archivo MP4).
4. Alcance de la categoría 3 en la plataforma: versión mínima aplicada, con remisión al curso propio externo para el desarrollo genérico de R.
5. Las decisiones pendientes del análisis (línea base normativa, Sección 2 vs. 3A, fuentes de composición) se registran en la hoja de ruta de `analisis_ENGIH2018` y afectan a B1.

## 6. Registro de cambios de esta hoja

| Fecha | Cambio |
|---|---|
| 2026-09-26 | A0 y A4 cerradas para los módulos 01–17. |
| 2026-09-26 | Hallazgos de la revisión para el GITP: datos simulados en todo el tema 05, paquete no localizado (módulo 20), referencias con identificadores incongruentes, erratas, autoevaluaciones incompletas, unidad 4.0 ausente. Regla de uso de datos. A1 en borrador. |
| 2026-09-26 | Categoría 3: desarrollo genérico de R trasladado al curso propio; en la plataforma, versión mínima aplicada (B3 pasa a tarea mecánica). |
| 2026-09-26 | Categoría 3 actualizada: 3.1 y 3.2 cubiertas por material propio externo pendiente de integración. |
| 2026-09-26 | Creación. Corrige la afirmación de la hoja del 2026-09-23 según la cual los módulos cubrían las cinco categorías del TdR: faltan la categoría 3 completa y el ítem 5.1. |
