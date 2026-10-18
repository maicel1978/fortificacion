# Consumo aparente por equivalente de mujer adulta con la ENGIH 2018, Sección 3A.
# Código del módulo 24 de la plataforma, en un solo archivo. Requiere los
# microdatos en _datos/ y las tablas de static/data/referencia/; véase el módulo.
# Escrito para la estructura de la ENGIH 2018: otra encuesta exige adaptarlo.

library(readxl)
library(dplyr)
library(tidyr)
library(janitor)
library(ggplot2)
library(here)

ruta_microdatos <- here("_datos")
ruta_referencia <- here("static", "data", "referencia")

archivos <- c(
  consumo = file.path(ruta_microdatos, "Registros_Cuestionario_B.xlsx"),
  hogares = file.path(ruta_microdatos, "Sociodemograficas_e_ingresos.xlsx")
)

faltan <- archivos[!file.exists(archivos)]
if (length(faltan) > 0) {
  stop("No se encuentran los microdatos: ", paste(basename(faltan), collapse = ", "),
       ". Véase el recuadro «Datos» al inicio del módulo.")
}

menores <- tribble(
  ~edad, ~Masculino, ~Femenino,
   1,  948,  865,   2, 1129, 1047,   3, 1252, 1156,   4, 1360, 1241,
   5, 1467, 1330,   6, 1573, 1428,   7, 1692, 1554,   8, 1830, 1698,
   9, 1978, 1854,  10, 2150, 2006,  11, 2341, 2149,  12, 2548, 2276,
  13, 2770, 2379,  14, 2990, 2449,  15, 3178, 2491,  16, 3322, 2503,
  17, 3410, 2503
) |>
  pivot_longer(-edad, names_to = "sexo", values_to = "kcal")

PAL <- 1.76
adultos <- tribble(
  ~desde, ~hasta, ~sexo,       ~kcal,
  18,  30, "Masculino", (15.057 * 65 + 692.2) * PAL,
  30,  60, "Masculino", (11.472 * 65 + 873.1) * PAL,
  60, 150, "Masculino", (11.711 * 65 + 587.7) * PAL,
  18,  30, "Femenino",  (14.818 * 55 + 486.6) * PAL,
  30,  60, "Femenino",  (8.126  * 55 + 845.6) * PAL,
  60, 150, "Femenino",  (9.082  * 55 + 658.5) * PAL
)

KCAL_REFERENCIA <- adultos$kcal[adultos$sexo == "Femenino" & adultos$desde == 18]
KCAL_MENOR_1    <- c(Masculino = 649, Femenino = 600)

requerimiento <- function(edad, sexo) {
  case_when(
    is.na(edad) | is.na(sexo) ~ NA_real_,
    edad < 1  ~ unname(KCAL_MENOR_1[sexo]),
    edad < 18 ~ menores$kcal[match(paste(floor(edad), sexo),
                                   paste(menores$edad, menores$sexo))],
    TRUE      ~ adultos$kcal[mapply(function(e, s) which(adultos$sexo == s &
                                    e >= adultos$desde & e < adultos$hasta)[1],
                                    edad, sexo)]
  )
}

personas <- read_excel(archivos["hogares"], sheet = "Base", guess_max = 10000) |>
  clean_names() |>
  transmute(
    id_hogar = paste(vivienda, hogar, sep = "_"),
    sexo = case_when(a402 == 1 ~ "Masculino", a402 == 2 ~ "Femenino"),
    edad = as.numeric(a403)
  ) |>
  mutate(ema = requerimiento(edad, sexo) / KCAL_REFERENCIA)

ema_hogar <- personas |>
  group_by(id_hogar) |>
  summarise(ema_hogar = sum(ema, na.rm = TRUE),
            sin_ema = sum(is.na(ema)), .groups = "drop")

c(personas = nrow(personas), hogares = nrow(ema_hogar),
  personas_sin_ema = sum(ema_hogar$sin_ema))

conv_universal <- read_excel(file.path(ruta_referencia, "factores_conversion.xlsx"),
                             sheet = "diccionario_conversion", na = "NA") |>
  filter(!is.na(fc)) |>
  select(unidad = id_unidad_medida_presentacion, fc_universal = fc)

conv_especifico <- read_excel(file.path(ruta_referencia, "factores_conversion.xlsx"),
                              sheet = "Cuest. B Sec 3A", na = "NA") |>
  filter(!is.na(fc)) |>
  select(descripcion, unidad = id_unidad_medida_presentacion, fc_especifico = fc)

porcion <- read_excel(file.path(ruta_referencia, "porcion_comestible.xlsx"),
                      sheet = "Cuest. B Sec 3A") |>
  transmute(id_variedad = as.character(id_variedad),
            pc = as.numeric(gsub(",", ".", as.character(edible))))

# Una clave duplicada multiplicaría filas en la unión sin dar error.
stopifnot(!anyDuplicated(conv_especifico[c("descripcion", "unidad")]),
          !anyDuplicated(porcion$id_variedad))

adquisiciones <- read_excel(archivos["consumo"], sheet = "Cuest. B Sec 3A",
                            col_types = "text") |>
  clean_names() |>
  transmute(
    id_hogar = paste(vivienda, hogar, sep = "_"),
    dia, id_variedad, descripcion,
    q = as.numeric(cantidad_adquirida),
    unidad = coalesce(as.numeric(id_unidad_medida_presentacion),
                      as.numeric(id_unidad_medida))
  )

dias <- adquisiciones |>
  group_by(id_hogar) |>
  summarise(dias_hogar = n_distinct(dia), .groups = "drop")

consumo <- adquisiciones |>
  left_join(conv_universal, by = "unidad") |>
  left_join(conv_especifico, by = c("descripcion", "unidad")) |>
  left_join(porcion, by = "id_variedad") |>
  left_join(dias, by = "id_hogar") |>
  mutate(fc = coalesce(fc_universal, fc_especifico),
         g_dia = q * fc * pc / dias_hogar)

summary(dias$dias_hogar)

consumo |>
  summarise(
    registros   = n(),
    sin_fc      = mean(is.na(fc)),
    sin_pc      = mean(is.na(pc)),
    calculables = mean(!is.na(g_dia))
  ) |>
  mutate(across(sin_fc:calculables, \(x) scales::percent(x, accuracy = 0.1)))

consumo_ema <- consumo |>
  filter(!is.na(g_dia)) |>
  group_by(id_hogar, id_variedad, descripcion) |>
  summarise(g_dia = sum(g_dia), .groups = "drop") |>
  inner_join(ema_hogar |> filter(ema_hogar > 0), by = "id_hogar") |>
  mutate(g_dia_ema = g_dia / ema_hogar)

arroz <- consumo_ema |>
  filter(grepl("^arroz", descripcion, ignore.case = TRUE)) |>
  group_by(id_hogar) |>
  summarise(g_dia_ema = sum(g_dia_ema), .groups = "drop")

ggplot(arroz, aes(g_dia_ema)) +
  geom_histogram(bins = 40, fill = "grey60", colour = "white") +
  scale_x_log10() +
  labs(x = "Gramos comestibles por EMA y día", y = "Hogares") +
  theme_minimal()
