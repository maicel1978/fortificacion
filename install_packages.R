options(repos = c(CRAN = "https://cloud.r-project.org"))

# Paquetes requeridos para el sitio web y análisis estadístico en R
pkgs <- c(
  "knitr",
  "rmarkdown",
  "dplyr",
  "tidyr",
  "readr",
  "ggplot2",
  "stringr",
  "purrr",
  "tibble",
  "lubridate",
  "janitor",
  "shiny",
  "DT",
  "plotly",
  "tidyverse",
  "readxl",
  "here",
  "srvyr",
  "survey",
  "gt",
  "gtsummary",
  "pak"
)

to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) {
  install.packages(to_install, dependencies = TRUE)
}

# Comentario para paquetes de GitHub / especializados (descomentar si es necesario instalar desde fuentes específicas):
# if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")
# if (!requireNamespace("nutriR", quietly = TRUE)) try(pak::pkg_install("nutriR"), silent = TRUE)
# if (!requireNamespace("SPADE.RIVM", quietly = TRUE)) try(pak::pkg_install("SPADE.RIVM"), silent = TRUE)
