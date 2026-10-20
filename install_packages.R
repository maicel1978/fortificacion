# Paquetes de R necesarios para compilar los módulos con código (24 a 30).
# Se ejecuta una vez: source("install_packages.R")

options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c(
  "knitr", "rmarkdown",            # compilación con Quarto
  "readxl", "dplyr", "tidyr",      # lectura y transformación
  "janitor", "here", "scales",
  "ggplot2",                       # gráficos
  "dlookr",                        # módulo 25: control de calidad
  "srvyr",                         # módulo 27: diseño muestral complejo
  "sf"                             # módulo 28: cartografía
)

faltan <- setdiff(pkgs, rownames(installed.packages()))
if (length(faltan) > 0) install.packages(faltan)
