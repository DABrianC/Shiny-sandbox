

packages <- c("bsicons", "bslib", "cowplot", "DT", "extrafont", "extrafontdb"
              , "flextable", "gt", "here", "lubridate", "patchwork", "readxl", "shiny"
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
  #1
  card( 
    width = 1/2,
    card_header("Map"),
    tmapOutput("map_sites"),
    full_screen = TRUE
  ),
  
  #2
  card(
    width = 1/2,
    card_header("Relevant information"
                ),
    card_body(
      markdown("This is a racing bar chart [link](https://github.com/DABrianC/ACLED-Sandbox/blob/main/WestAfricaEventsSumming.gif)")
    )
  ),
  
  #3
  card(
    card_header("Imported Data"),
    DT::DTOutput("DT_table"),
    full_screen = TRUE
  ),
  
  #4
  #card(card_header("Sites Visited Table"),
   #    DT::DTOutput('sites_visited'),
    #   full_screen = TRUE
     #  ),
  
  #card(card_header("Sites Visited"),
   #    DT::DTOutput("sites_visited"),
    #   full_screen = TRUE
     #  ),
  
  #4
  card(
       width = 1/2,
       card_header("Sites Visited",
                   #class = "d-flex justify-content-between",
                  #  shiny::downloadLink(
                   #  outputId="download",
                    # label=bslib::tooltip(
                     #  bsicons::bs_icon("file-earmark-image"),
                      # "Click to download table",
                      # placement = "right"
                     ),
                   gt_output("sites_visited_gt"),
                   full_screen = TRUE
       ),
       
  
  #5
  card(
       width = 1/2,
       card_header("Placeholder2"),
       markdown("This is a placeholder")
       , full_screen = TRUE),
  
  #6
  card(card_header("Sites Visited by Type of Visit"),
       gt_output("sites_visited_type_gt")
       , full_screen = TRUE)
  )
  
    
  

