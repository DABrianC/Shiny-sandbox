

packages <- c("cowplot", "DT", "extrafont", "extrafontdb", "flextable", "gt"
              , "here", "lubridate", "patchwork", "readxl", "shiny"
              , "shinydashboard", "sf", "tidytext", "tidyverse", "tmap"
              , "tmaptools", "writexl")
              
              

#Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
# Packages loading
lapply(packages, library, character.only = TRUE) |>
  invisible()

# custom colors

