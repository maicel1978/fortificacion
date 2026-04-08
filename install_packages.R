options(repos = c(CRAN = "https://cloud.r-project.org"))

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
  "plotly"
)

to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)