# Manual técnico — Evaluación de la cobertura, el consumo y la contribución de alimentos fortificables y fortificados a partir de encuestas de gasto y consumo de los hogares

**Aplicación a la ENGIH 2018 de República Dominicana**
Borrador de estructura — versión 0.1 — septiembre de 2026
Extensión prevista: 20–30 páginas (ítem 18 del TdR)

Este borrador fija la estructura, el contenido de cada sección y sus fuentes. Los pasajes marcados como **[Pendiente]** se completan con los resultados del análisis de la ENGIH 2018; no se incluye ninguna cifra que no provenga de ese análisis.

---

## 1. Introducción (1 página)

Propósito del manual, relación con los módulos e-learning y con el sistema de evaluación de programas de fortificación a gran escala. Destinatarios: equipos técnicos que repliquen el análisis en otra encuesta o país.

## 2. Marco conceptual (2 páginas)

- Fortificación a gran escala como estrategia de salud pública; vehículos y micronutrientes de interés (hierro, ácido fólico, vitamina A, zinc, vitamina B12).
- Los cuatro indicadores del sistema de evaluación: cobertura de vehículos, consumo de vehículos, ingesta aparente de micronutrientes y contribución de los alimentos fortificados a la adecuación. **[Pendiente: definición operativa final a entregar por el PMA.]**
- Fuentes: Allen et al. 2006; Dwyer et al. 2015; Beal et al. 2017.

## 3. Fuente de datos: la ENGIH 2018 (3 páginas)

- Diseño muestral: estratos, unidades primarias de muestreo, factor de expansión, dominios de representatividad.
- Secciones 2 y 3A: estructura, periodo de referencia, variables de cantidad y unidad.
- Variables disponibles, no disponibles y adaptaciones requeridas. **[Pendiente: síntesis del informe de factibilidad.]**
- Decisión sobre el tratamiento conjunto o separado de las secciones 2 y 3A. **[Pendiente: decisión del equipo técnico.]**
- Fuentes: Fiedler et al. 2012; Fiedler, Carletto y Dupriez 2012; Murphy, Ruel y Carriquiry 2012.

## 4. Procesamiento de los datos de consumo (4 páginas)

- Estandarización de unidades a gramos: fuentes de equivalencias, unidades locales, supuestos documentados.
- Ajuste por porción comestible.
- Conversión a cantidad diaria por hogar.
- Tratamiento de valores extremos y faltantes: criterio, método de imputación y justificación (Nota Metodológica 6). **[Pendiente: criterios aplicados en el pipeline.]**
- Control de calidad: verificaciones realizadas y resultados. **[Pendiente: informe R1.]**
- Fuentes: Smith y Subandoro 2007; Moltedo et al. 2014; Tang et al. 2022.

## 5. Ajuste por equivalente de mujer adulta (2 páginas)

- Justificación de la unidad de referencia (mujer de 18 a 29 años).
- Cálculo de factores por edad y sexo a partir de los requerimientos energéticos; total de EMA por hogar.
- Limitación: ajustes por embarazo y lactancia condicionados a la disponibilidad del módulo demográfico. **[Pendiente: confirmación.]**
- Fuentes: FAO/OMS/UNU 2004; Weisell y Dop 2012; Claro et al. 2010.

## 6. Composición de alimentos y equivalencias (3 páginas)

- Jerarquía de fuentes de composición y criterios de equivalencia entre alimentos de la encuesta y de la tabla.
- Alimentos sin equivalencia directa y su tratamiento. **[Pendiente: decisión sobre ~21 alimentos sin equivalencia.]**
- Línea base de fortificación: supuestos por vehículo. **[Pendiente: línea base normativa.]**
- Fuentes: Kovalskys et al. 2015; Tang et al. 2022.

## 7. Cálculo de los indicadores (5 páginas)

- 7.1 Cobertura de vehículos: proporción de hogares que consumen cada vehículo, nacional y por dominio, con error estándar. **[Pendiente: resultados R3.]**
- 7.2 Consumo de vehículos: cantidad por EMA y día entre consumidores. **[Pendiente: resultados R3.]**
- 7.3 Ingesta aparente de micronutrientes por EMA. **[Pendiente: resultados R2.]**
- 7.4 Adecuación: método del punto de corte del EAR; enfoque probabilístico para hierro; supuestos y limitaciones al aplicarlos a ingesta aparente de hogar. **[Pendiente: resultados R4.]**
- Fuentes: Institute of Medicine 2000; OMS/FAO 2004.

## 8. Escenarios de fortificación (2 páginas)

- Construcción de escenarios con niveles factibles de fortificación y efecto sobre la prevalencia de ingesta inadecuada. **[Pendiente: resultados R4.]**
- Fuente: Allen et al. 2006.

## 9. Análisis de equidad (2 páginas)

- Resultados por quintil, zona y provincia. **[Pendiente: resultados R5.]**

## 10. Supuestos, limitaciones y portabilidad (2 páginas)

- Supuestos principales y su efecto esperado sobre las estimaciones.
- Limitaciones de las encuestas de gasto para estimar ingesta: consumo fuera del hogar, distribución intrahogar, desperdicio.
- Adaptación del código a otras encuestas y países (ítem 9 del TdR).

## 11. Reproducibilidad (1 página)

- Estructura del código, versión de R y paquetes, orden de ejecución, datos no incluidos y cómo obtenerlos de la fuente oficial.

## Referencias

1. Allen L, de Benoist B, Dary O, Hurrell R, editores. *Guidelines on food fortification with micronutrients*. Ginebra: OMS; FAO; 2006.
2. Beal T, Massiot E, Arsenault JE, Smith MR, Hijmans RJ. Global trends in dietary micronutrient supplies and estimated prevalence of inadequate intakes. *PLoS One*. 2017;12(4):e0175554. doi:10.1371/journal.pone.0175554
3. Claro RM, Levy RB, Bandoni DH, Mondini L. Per capita versus adult-equivalent estimates of calorie availability in household budget surveys. *Cad Saude Publica*. 2010;26(11):2188-95. doi:10.1590/S0102-311X2010001100020
4. Dwyer JT, Wiemer KL, Dary O, Keen CL, King JC, Miller KB, et al. Fortification and health: challenges and opportunities. *Adv Nutr*. 2015;6(1):124-31. doi:10.3945/an.114.007443
5. FAO, OMS, UNU. *Human energy requirements*. FAO Food and Nutrition Technical Report Series 1. Roma: FAO; 2004.
6. Fiedler JL, Carletto C, Dupriez O. Still waiting for Godot? Improving Household Consumption and Expenditures Surveys (HCES) to enable more evidence-based nutrition policies. *Food Nutr Bull*. 2012;33(3 Suppl):S242-51. doi:10.1177/15648265120333S214
7. Fiedler JL, Lividini K, Bermudez OI, Smitz MF. Household Consumption and Expenditures Surveys (HCES): a primer for food and nutrition analysts in low- and middle-income countries. *Food Nutr Bull*. 2012;33(3 Suppl):S170-84. doi:10.1177/15648265120333S205
8. Institute of Medicine. *Dietary Reference Intakes: applications in dietary assessment*. Washington, DC: National Academy Press; 2000. doi:10.17226/9956
9. Kovalskys I, Fisberg M, Gómez G, Rigotti A, Cortés LY, Yépez MC, et al. Standardization of the food composition database used in the Latin American Nutrition and Health Study (ELANS). *Nutrients*. 2015;7(9):7914-24. doi:10.3390/nu7095373
10. Moltedo A, Troubat N, Lokshin M, Sajaia Z. *Analyzing food security using household survey data: streamlined analysis with ADePT software*. Washington, DC: World Bank; 2014. doi:10.1596/978-1-4648-0133-4
11. Murphy S, Ruel M, Carriquiry A. Should Household Consumption and Expenditures Surveys (HCES) be used for nutritional assessment and planning? *Food Nutr Bull*. 2012;33(3 Suppl). doi:10.1177/15648265120333S213
12. OMS, FAO. *Vitamin and mineral requirements in human nutrition*. 2.ª ed. Ginebra: OMS; 2004.
13. Smith LC, Subandoro A. *Measuring food security using household expenditure surveys*. Food Security in Practice Technical Guide Series 3. Washington, DC: IFPRI; 2007.
14. Tang K, Adams KP, Ferguson EL, Woldt M, Yourkavitch J, Pedersen S, et al. Systematic review of metrics used to characterise dietary nutrient supply from household consumption and expenditure surveys. *Public Health Nutr*. 2022;25(5):1153-65. doi:10.1017/S1368980022000118
15. Weisell R, Dop MC. The adult male equivalent concept and its application to Household Consumption and Expenditures Surveys (HCES). *Food Nutr Bull*. 2012;33(3 Suppl):S157-62.
