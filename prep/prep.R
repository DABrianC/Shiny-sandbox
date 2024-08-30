

packages <- c("bsicons", "bslib", "cowplot", "DT", "extrafont", "extrafontdb", "flextable", "gt"
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


cards <- list(
  card(
    card_header("Map"),
    tmapOutput("map_sites")
  ),
  
  card(
    card_header("Imported Data"),
    DT::DTOutput("DT_table")
  ),
  
  card(card_header("Sites Visited Table"),
       DT::DTOutput('sites_visited')
       ),
  
  card(card_header("placeholder1"),
       plotOutput("Placeholder1")
       ),
  
  card(card_header("placeholder2"),
       plotOutput("Placeholder2")
      )
  )
    
  

