# Lista de paquetes requeridos
required_packages <- c(
  "rmarkdown", 
  "knitr", 
  "tidyverse", 
  "quarto",
  "ggplot2",
  "dplyr"
)

# Instalar paquetes faltantes
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages, repos = "https://cloud.r-project.org/")