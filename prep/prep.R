

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
    width = 1/2,
    card_header("Map"),
    tmapOutput("map_sites"),
    full_screen = TRUE
  ),
  
  card(
    width = 1/2,
    card_header("Relevant information"
                ),
    card_body(
      markdown("This is a racing bar chart [link](https://github.com/DABrianC/ACLED-Sandbox/blob/main/WestAfricaEventsSumming.gif)")
    )
  ),
  
  card(
    card_header("Imported Data"),
    DT::DTOutput("DT_table"),
    full_screen = TRUE
  ),
  
  card(card_header("Sites Visited Table"),
       DT::DTOutput('sites_visited'),
       full_screen = TRUE
       ),
  
  #card(card_header("Sites Visited"),
   #    DT::DTOutput("sites_visited"),
    #   full_screen = TRUE
     #  ),
  
  card(card_header("placeholder2"),
       plotOutput("Placeholder2"),
       full_screen = TRUE
      )
  )
    
  

