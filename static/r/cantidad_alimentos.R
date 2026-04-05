# ==============================================================================
# SCRIPT DE ANÁLISIS NUTRICIONAL POR EQUIVALENTE DE MUJER ADULTA (AWE)
# Versión de Validación Lógica (Usa datos reales AWE, Q, FND y datos TOY para FC y PC)
# ==============================================================================

# --- 1. CONFIGURACIÓN DEL ENTORNO Y LIBRERÍAS ---
# Instala y carga las librerías esenciales para el análisis de datos.
library(tidyverse) # Colección de paquetes (ggplot2, dplyr, etc.) para manipulación de datos.
library(readxl)    # Necesario para leer archivos de Excel (.xlsx).
library(here)      # Ayuda a construir rutas de archivo relativas, mejorando la portabilidad.
options(scipen = 999) # Desactiva la notación científica para números grandes.

# --- 2. CONFIGURACIÓN DE RUTAS ---
# Las rutas base están confirmadas y son funcionales.
ruta_base <- here("static/data/")
ruta_demo_file <- file.path(ruta_base, "Sociodemograficas_e_ingresos.xlsx") # Fuente de Demografía
ruta_tabla_composicion <- file.path(ruta_base, "tabla_coposicion_alimentos.xlsx") # Fuente de Factores Nutricionales (FND)

# ------------------------------------------------------------------------------
## FASE 1: CÁLCULO DEL EQUIVALENTE DE MUJER ADULTA (AWE)
# ------------------------------------------------------------------------------
# 1.1. Carga de Datos Demográficos (Real)
# Se selecciona la hoja "Base" y se renombran las variables clave.
datos_persona <- read_excel(ruta_demo_file, sheet = "Base") %>%
  select(HHID_VIV = VIVIENDA, HHID_HOG = HOGAR, SEXO = A402, EDAD = A403)

# 1.2. Factores de Conversión AWE (Tabla Estándar INCAP)
# Tabla estándar para asignar un peso de consumo a cada individuo según edad y sexo.
awe_factors <- tribble(
  ~edad_min, ~edad_max, ~SEXO, ~awe_factor,
  0, 0, 1, 0.33, 0, 0, 2, 0.33, 1, 2, 1, 0.46, 1, 2, 2, 0.46,
  18, 59, 1, 1.05, 18, 59, 2, 1.00, # La mujer adulta (SEXO=2, 18-59 años) es la base (1.00).
  60, 150, 1, 0.84, 60, 150, 2, 0.77
)

# 1.3. Cálculo del AWE total por hogar
# Se une la edad/sexo con el factor AWE y se suma para obtener el AWE total por hogar.
datos_awe_hogar <- datos_persona %>%
  left_join(awe_factors, by = join_by(between(EDAD, edad_min, edad_max), SEXO)) %>%
  group_by(HHID_VIV, HHID_HOG) %>%
  summarise(Total_AWE_Hogar = sum(awe_factor, na.rm = TRUE), .groups = 'drop')

cat("FASE 1: AWE completado con datos reales.\n")


# ------------------------------------------------------------------------------
## FASE 2 y 3: CÁLCULO DE CONSUMO DIARIO EN GRAMOS POR AWE
# NOTA DOCENTE: Esta sección usa datos consolidados (TOY data) para la cantidad (Q) y los factores
# de conversión (FC y PC) que faltan, para asegurar que la lógica de cálculo sea correcta.
# ------------------------------------------------------------------------------
PM_Dias <- 30 # Periodo de Medición (e.g., los últimos 30 días)

# *** Bloque de Sustitución: Datos de Consumo, FC y PC (TOY Data) ***
# Si los archivos reales de FC y PC son encontrados, este bloque DEBE ser reemplazado
# por el siguiente proceso: Carga de Q (Real) -> Carga de FC (Real) -> Carga de PC (Real) -> Unión.

datos_consumo_simulado <- tribble(
  ~HHID_VIV, ~HHID_HOG, ~CODI_ALIMENTO, ~Q, ~FACTOR_CONVERSION_KG, ~PORCION_COMESTIBLE_PC,
  # HOGAR 1: Pan (1kg) y Arroz (2lbs)
  1, 1, 1, 1, 1.000, 0.98,        # ID=1 (Pan): 1kg * 1.0 * 0.98 (PC)
  1, 1, 20, 2, 0.4536, 1.00,       # ID=20 (Arroz): 2lbs * 0.4536 (FC) * 1.00 (PC)
  # HOGAR 2: Pollo (3kg) y Frijoles (0.5kg)
  2, 1, 588, 3, 1.000, 0.85,       # ID=588 (Pollo): 3kg * 1.0 * 0.85 (PC)
  2, 1, 4919, 0.5, 1.000, 1.00     # ID=4919 (Frijoles): 0.5kg * 1.0 * 1.00 (PC)
) %>% 
  # CÁLCULO: Cantidad (Q) * Factor Conversión (FC) * Porción Comestible (PC) / PM
  mutate(
    # Q * FC * PC * 1000 (para convertir a gramos)
    CANTIDAD_COMESTIBLE_G = Q * FACTOR_CONVERSION_KG * PORCION_COMESTIBLE_PC * 1000, 
    # Cantidad Comestible en Gramos / Días del Período de Medición
    CONSUMO_DIARIO_G = CANTIDAD_COMESTIBLE_G / PM_Dias
  ) %>%
  # AGREGACIÓN Y UNIÓN CON AWE
  group_by(HHID_VIV, HHID_HOG, CODI_ALIMENTO) %>%
  summarise(Total_Consumo_Diario_G = sum(CONSUMO_DIARIO_G, na.rm = TRUE), .groups = 'drop') %>%
  # Estandarización por AWE
  left_join(datos_awe_hogar, by = c("HHID_VIV", "HHID_HOG")) %>%
  mutate(Consumo_per_AWE_G = Total_Consumo_Diario_G / Total_AWE_Hogar) %>%
  filter(Total_Consumo_Diario_G > 0) # Se eliminan los registros con consumo cero

cat("\nFASE 2/3: Consumo Diario (en gramos) calculado con TOY Data consolidado.\n")


# ------------------------------------------------------------------------------
## FASE 4: CÁLCULO DE INGESTA DE NUTRIENTES (FND)
# ------------------------------------------------------------------------------

# 4.1. Factor Nutricional Diario (FND) - (Real)
# Se carga la tabla de composición y se selecciona solo el ID del alimento y los nutrientes deseados.
factores_nutricionales_fnd <- read_excel(ruta_tabla_composicion, sheet = "tabla_alimentos") %>%
  select(CODI_ALIMENTO = ID_ALIMENTO, 
         FND_HIERRO_mg = HIERRO_MG, 
         FND_VIT_A_mcg = VIT_A_MCG) %>%
  mutate(CODI_ALIMENTO = as.numeric(CODI_ALIMENTO)) # Asegura que la clave sea numérica

# 4.2. Cálculo de la Ingesta de Nutrientes per AWE y Agregación (FASE 5)
# Se unen los datos de consumo (en gramos/día) con el factor nutricional (FND) y se calcula la ingesta.
ingesta_total_hogar <- datos_consumo_simulado %>%
  left_join(factores_nutricionales_fnd, by = "CODI_ALIMENTO") %>%
  mutate(
    across(starts_with("FND_"), ~replace_na(., 0)),
    # Ingesta por día: Gramos consumidos * (mg o mcg por 100 gramos) / 100
    Ingesta_Hierro_mg_dia = Total_Consumo_Diario_G * (FND_HIERRO_mg / 100),
    Ingesta_VitA_mcg_dia = Total_Consumo_Diario_G * (FND_VIT_A_mcg / 100),
    # Estandarización Final por AWE
    Ingesta_Hierro_per_AWE_mg = Ingesta_Hierro_mg_dia / Total_AWE_Hogar,
    Ingesta_VitA_per_AWE_mcg = Ingesta_VitA_mcg_dia / Total_AWE_Hogar
  ) %>%
  group_by(HHID_VIV, HHID_HOG) %>%
  summarise(
    Total_Hierro_mg_per_AWE = sum(Ingesta_Hierro_per_AWE_mg, na.rm = TRUE),
    Total_VitA_mcg_per_AWE = sum(Ingesta_VitA_per_AWE_mcg, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nFASE 4/5: RESULTADO FINAL - Ingesta total de nutrientes por hogar (AWE) calculada.\n")
print(ingesta_total_hogar)

# ==============================================================================
# ¡FIN DEL SCRIPT!
# ==============================================================================