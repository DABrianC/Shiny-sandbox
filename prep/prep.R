

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

# Poland shapefile

#pol <- st_read("./data/poland/gadm41_POL_1.shp") |> 
 # filter(NAME_1 == "Lubelskie" | NAME_1 == "Opolskie")

#tmap_mode("view") +
 # tm_shape(pol) +
  #tm_borders(col = "#BA0C2F", alpha = .3) +
  #tm_shape(df$geometry) +
  #tm_dots(col = "#002F6C", alpha = .6)
