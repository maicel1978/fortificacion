# ==============================================================================
# TÍTULO: Script Maestro - Flujo Completo MIMI (Cantidad a Nutrientes)
# FECHA: 2025-12-14
# DESCRIPCIÓN: Implementación de la fórmula de Ingesta Diaria:
#              (Q * FC * PC * FND) / PM, usando datos simulados de la ENGIH.
#              Incluye FASE 1 (AWE) hasta FASE 5 (Agregación Final).
# ==============================================================================

# --- 1. CONFIGURACIÓN DEL ENTORNO ---
# Carga de librerías esenciales del Tidyverse.
library(tidyverse)
library(readxl)
library(here) 
options(scipen = 999) # Desactiva la notación científica para mayor claridad.

# Las rutas deben configurarse para el ambiente de producción (datos reales)
# ruta_base <- here("static/data/")
# ruta_demo_file <- file.path(ruta_base, "Sociodemograficas_e_ingresos.xlsx")
# ruta_cantidad_file <- file.path(ruta_base, "Registros_Cuestionario_B.xlsx") 

# ------------------------------------------------------------------------------
## FASE 1: CÁLCULO DEL EQUIVALENTE DE MUJER ADULTA (AWE)
# ------------------------------------------------------------------------------
# Objetivo: Estandarizar el consumo per cápita del hogar.

# 1.1. Datos demográficos de personas (SIMULADOS PARA EJECUCIÓN DOCENTE)
# REEMPLAZAR con datos reales: 
# datos_persona <- read_excel(ruta_demo_file, sheet = "Base") %>%
#   select(HHID_VIV = VIVIENDA, HHID_HOG = HOGAR, SEXO = A402, EDAD = A403)
datos_persona <- tribble(
  ~HHID_VIV, ~HHID_HOG, ~SEXO, ~EDAD,
  1, 1, 1, 45, 1, 1, 2, 43, 1, 1, 2, 10, # Hogar 1 (Familia de 3)
  2, 1, 1, 30, 2, 1, 2, 28,             # Hogar 2 (Pareja)
  3, 1, 2, 50, 3, 1, 1, 55, 3, 1, 1, 15  # Hogar 3 (Familia de 3)
)

# 1.2. Factores de conversión AWE (Tabla estándar INCAP)
awe_factors <- tribble(
  ~edad_min, ~edad_max, ~SEXO, ~awe_factor,
  0, 0, 1, 0.33, 0, 0, 2, 0.33, 1, 2, 1, 0.46, 1, 2, 2, 0.46,
  18, 59, 1, 1.05, 18, 59, 2, 1.00, # La mujer adulta (18-59) es el factor base (1.00)
  60, 150, 1, 0.84, 60, 150, 2, 0.77
)

# 1.3. Cálculo del AWE total por hogar
datos_awe_hogar <- datos_persona %>%
  left_join(awe_factors, by = join_by(between(EDAD, edad_min, edad_max), SEXO)) %>%
  group_by(HHID_VIV, HHID_HOG) %>%
  summarise(Total_AWE_Hogar = sum(awe_factor, na.rm = TRUE), .groups = 'drop')

cat("FASE 1: Cálculo de AWE por hogar completado.\n")


# ------------------------------------------------------------------------------
## FASE 2: CARGA Y FILTRADO DE CANTIDAD FÍSICA (Q)
# ------------------------------------------------------------------------------
# Objetivo: Obtener Q, el código de alimento y filtrar por consumo propio.

# 2.1. Datos de Consumo (SIMULADOS PARA EJECUCIÓN DOCENTE)
# REEMPLAZAR con datos reales: 
# datos_consumo <- read_excel(ruta_cantidad_file, sheet = "Cuest. B Sec 3A") %>%
#   select(HHID_VIV = VIVIENDA, HHID_HOG = HOGAR, CODI_ALIMENTO = ID_VARIEDAD, 
#          Q = CANTIDAD_ADQUIRIDA, UNIDAD_MEDIDA = ID_UNIDAD_MEDIDA, 
#          DESTINO_HOGAR = DESTINO_PROPIO_HOGAR)
datos_consumo <- tribble(
  ~HHID_VIV, ~HHID_HOG, ~CODI_ALIMENTO, ~Q, ~UNIDAD_MEDIDA, ~DESTINO_HOGAR,
  1, 1, 1, 5, 1, 1,     # Hogar 1: Alimento 1 (ej. Harina), 5 unidades (Kg)
  1, 1, 588, 10, 2, 1,   # Hogar 1: Alimento 588 (ej. Fruta), 10 unidades (Libras)
  2, 1, 20, 2, 3, 1,    # Hogar 2: Alimento 20 (ej. Leche), 2 unidades (Litros)
  3, 1, 4919, 1, 7, 1,   # Hogar 3: Alimento 4919 (ej. Sal Fort.), 1 unidad
  1, 1, 1, 10, 1, 2,    # Dato basura: Consumo NO destinado al propio hogar (DEBE SER FILTRADO)
) %>%
  # Limpieza y filtrado: Solo consumo del propio hogar (DESTINO_HOGAR = 1)
  filter(
    !is.na(Q) & !is.na(UNIDAD_MEDIDA) & !is.na(CODI_ALIMENTO) & DESTINO_HOGAR == 1
  )

cat("\nFASE 2: Consumo Físico cargado y filtrado.\n")


# ------------------------------------------------------------------------------
## FASE 3: SIMULACIÓN TCA: FACTORES DE CONVERSIÓN (FC, PC) Y CÁLCULO DE CANTIDAD
# ------------------------------------------------------------------------------

# 3.1. Factor de Conversión (FC): Convierte la unidad de medida a Kilogramos (SIMULADO)
# REEMPLAZAR con TCA real: read_excel(ruta_tca_fc_file)
factores_conversion_fc <- tribble(
  ~UNIDAD_MEDIDA, ~FACTOR_CONVERSION_KG, 
  1, 1.000,   # Unidad 1: Kilogramo (1 kg)
  2, 0.4536,  # Unidad 2: Libra (0.4536 kg)
  3, 1.000,   # Unidad 3: Litro (1 kg, asumiendo densidad de agua)
  7, 1.000    # Unidad 7: Unidad de conteo (1 kg, asumiendo unidad grande)
)

# 3.2. Porción Comestible (PC): Descuenta cáscaras, huesos, etc. (SIMULADO)
# REEMPLAZAR con TCA real: read_excel(ruta_tca_pc_file)
factores_comestibles_pc <- tribble(
  ~CODI_ALIMENTO, ~PORCION_COMESTIBLE_PC, 
  1, 0.98,     # Harina: 98% comestible
  20, 1.00,     # Leche: 100% comestible
  588, 0.85,    # Fruta/Verdura: 85% comestible
  4919, 1.00    # Sal Fortificada: 100% comestible
)


# 3.3. Aplicación de la fórmula Cantidad: Q * FC * PC / PM
PM_Dias <- 30 # Periodo de Medición de la ENGIH (Mensual = 30 días)

consumo_cantidad_diario <- datos_consumo %>%
  # 1. Ajustar tipos de datos para la unión
  mutate(
    CODI_ALIMENTO = as.numeric(CODI_ALIMENTO),
    UNIDAD_MEDIDA = as.numeric(UNIDAD_MEDIDA)
  ) %>%
  
  # 2. Unir: FC (Factor de Conversión)
  left_join(factores_conversion_fc, by = "UNIDAD_MEDIDA") %>%
  # 3. Unir: PC (Porción Comestible)
  left_join(factores_comestibles_pc, by = "CODI_ALIMENTO") %>%
  
  # 4. CALCULAR: Aplicación Q * FC * PC / PM
  mutate(
    # Manejo de N/A: Asumir 0kg si no hay FC. Si no hay PC, asumimos 1.0 (100% comestible).
    FACTOR_CONVERSION_KG = replace_na(FACTOR_CONVERSION_KG, 0),
    PORCION_COMESTIBLE_PC = replace_na(PORCION_COMESTIBLE_PC, 1.00),
    
    # Cantidad comestible en Gramos (Q * FC * PC * 1000)
    CANTIDAD_COMESTIBLE_G = Q * FACTOR_CONVERSION_KG * PORCION_COMESTIBLE_PC * 1000,
    # Consumo Diario en Gramos (Q * FC * PC / PM)
    CONSUMO_DIARIO_G = CANTIDAD_COMESTIBLE_G / PM_Dias
  ) %>%
  
  # 5. AGREGAR: Consumo Diario Total por Hogar y Alimento
  group_by(HHID_VIV, HHID_HOG, CODI_ALIMENTO) %>%
  summarise(Total_Consumo_Diario_G = sum(CONSUMO_DIARIO_G, na.rm = TRUE), .groups = 'drop') %>%
  
  # 6. UNIR: Con el AWE del hogar y calcular el consumo per AWE
  left_join(datos_awe_hogar, by = c("HHID_VIV", "HHID_HOG")) %>%
  mutate(Consumo_per_AWE_G = Total_Consumo_Diario_G / Total_AWE_Hogar) %>%
  
  # Filtrar para dejar solo los registros con consumo > 0
  filter(Total_Consumo_Diario_G > 0)

cat("\nFASE 3: Cantidad de Alimentos (en gramos) por AWE completada.\n")
print(head(consumo_cantidad_diario))


# ------------------------------------------------------------------------------
## FASE 4: CÁLCULO DE INGESTA DE NUTRIENTES (FND)
# ------------------------------------------------------------------------------
# Objetivo: Multiplicar el consumo diario (en gramos) por el Factor Nutricional
#           para obtener la ingesta.

# 4.1. Factor Nutricional Diario (FND) - mg o mcg por 100 gramos (SIMULADO)
# REEMPLAZAR con TCA real: read_excel(ruta_tca_fnd_file)
# Nota: La TCA del INCAP tiene estos factores.
factores_nutricionales_fnd <- tribble(
  ~CODI_ALIMENTO, ~FND_HIERRO_mg, ~FND_VIT_A_mcg, # FND por 100 gramos
  1, 4.0,           5,      # Harina: Fortificada con Hierro
  20, 0.1,          68,     # Leche
  588, 0.8,         400,    # Fruta/Verdura: Buena fuente de Vitamina A
  4919, 10.0,        0      # Sal Fortificada: Alta concentración de hierro (o Yodo)
)

# 4.2. Cálculo de la Ingesta de Nutrientes per AWE
ingesta_nutrientes_awe <- consumo_cantidad_diario %>%
  # 1. Unir: FND (Factor Nutricional Diario)
  left_join(factores_nutricionales_fnd, by = "CODI_ALIMENTO") %>%
  
  # 2. CALCULAR: Ingesta (mg) = Consumo_Diario_G * (FND / 100)
  mutate(
    # Manejar N/A en FND: Si el alimento no está en la TCA, asumimos 0 nutriente.
    across(starts_with("FND_"), ~replace_na(., 0)),
    
    # Ingesta total por hogar (diaria)
    Ingesta_Hierro_mg_dia = Total_Consumo_Diario_G * (FND_HIERRO_mg / 100),
    Ingesta_VitA_mcg_dia = Total_Consumo_Diario_G * (FND_VIT_A_mcg / 100),
    
    # Ingesta por AWE
    Ingesta_Hierro_per_AWE_mg = Ingesta_Hierro_mg_dia / Total_AWE_Hogar,
    Ingesta_VitA_per_AWE_mcg = Ingesta_VitA_mcg_dia / Total_AWE_Hogar
  ) %>%
  
  select(HHID_VIV, HHID_HOG, CODI_ALIMENTO, Total_AWE_Hogar, Ingesta_Hierro_per_AWE_mg, Ingesta_VitA_per_AWE_mcg)

cat("\nFASE 4: Cálculo de Ingesta de Nutrientes (mg/mcg) por alimento completada.\n")
print(head(ingesta_nutrientes_awe))


# ------------------------------------------------------------------------------
## FASE 5: AGREGACIÓN FINAL POR HOGAR
# ------------------------------------------------------------------------------
# Objetivo: Sumar el consumo de todos los alimentos para obtener la Ingesta Total 
#           Diaria de un nutriente por AWE.

ingesta_total_hogar <- ingesta_nutrientes_awe %>%
  group_by(HHID_VIV, HHID_HOG) %>%
  summarise(
    Total_Hierro_mg_per_AWE = sum(Ingesta_Hierro_per_AWE_mg, na.rm = TRUE),
    Total_VitA_mcg_per_AWE = sum(Ingesta_VitA_per_AWE_mcg, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nFASE 5: RESULTADO FINAL - Ingesta total de nutrientes por hogar (AWE).\n")
print(ingesta_total_hogar)

# FIN DEL SCRIPT
# ==============================================================================