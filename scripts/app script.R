
source(here::here("./prep/prep.R"))

#the user interface
ui <- page_navbar(
  title = "Simple Data Dashboard",
  theme = bs_theme(
    bootswatch = "litera",
    version = 5,
    base_font = font_google("Inter"),
    #navbar_bg = "#002F6C"
  ),
  sidebar = sidebar(fileInput(inputId = "file"
            , accept = c(".xlsx", ".csv")
            , label = "Drag your file here or browse for it:"
            , multiple = TRUE),
          checkboxGroupInput(inputId = "column_names"
                       , label = "Select columns"
                       , inline = FALSE
                       , choices = c())
          ),
  navset_card_underline(
  nav_panel("Dashboard",
            layout_column_wrap(
              width = 1/2,
              height = 300,
              cards[[1]],
              cards[[2]]
            ),
              cards[[3]]),
  nav_panel("Report Components",
            layout_column_wrap(
              width = 1/2,
              height = 300,
              cards[[4]],
              cards[[5]]
            ),
            cards[[6]],
        ),
  #nav_spacer(),
  #nav_panel("Body Mass", cards[[3]]),
  #nav_items(
   # title = "Links",
   # align = "right")
))


#the server side  
server <- function(input, output, session) {

#Reactive variables  
  # You can access the value of the widget with input$file, e.g.
  rtable <- eventReactive(input$file, {
    read_xlsx(input$file$datapath
              , col_names = TRUE)
  })

  text_react <- eventReactive(input$run_columns, {
    req(input$column_names)
    
    rtable() |> 
      select_at(input$column_names) |>
      mutate(respondent = row_number()) |>
      unnest_tokens(word, text_response) |> 
      inner_join(get_sentiments("bing")) |> 
      mutate(value = case_when(sentiment == "positive" ~ 1
                               , sentiment == "negative" ~ -1)) |> 
      group_by(respondent) |> 
      summarize(score = mean(value))
      
  })
  
  data_sfr <- eventReactive(input$file, {
    req(input$file)
    
    data <- read_xlsx(input$file$datapath)
    st_as_sf(data
             , coords = c("long", "lat")
             , crs = 4326) 
  })
  
  
  rsites_visited <- eventReactive(input$file, {
    rtable() |> 
      group_by(location, gender) |> 
      count() |> 
      pivot_wider(names_from = gender
                  , values_from = n) |> 
      mutate(Total = M + F
             , `Female Participation (%)` = paste0(F/Total * 100, "%")) |> 
      rename("Location" = location
             , "Male" = M
             , "Female" = F
      )
  })

  rsites_visited_type <- eventReactive(input$file, {
    req(rtable())
    
    df <- rtable() 
    
    df$type_visit <- df$type_visit |> 
      recode(`in person` = "In person"
              , remote = "Remote"
              , telephone = "Telephone")

    df <- df |> 
      group_by(location, type_visit, gender) |> 
      count() |> 
      pivot_wider(names_from = gender
                  , values_from = n) |> 
      rename("Location" = location
             , "Male" = M
             , "Female" = F
             , "Type of Visit" = type_visit)
   
    })  
  
 
#Observable variables
  observeEvent(input$file, {
    req(rtable()) #we need rtable()
    
    #update input$column_names with colnames of selected dataset, rtable()
    updateCheckboxGroupInput(
      session, 
      "column_names",
      choices = colnames(rtable()),
      selected = ""
    )
  })
  
    
output$DT_table <- DT::renderDT({
  req(input$file)
  
  DT::datatable(rtable())
})


output$sites_visited <- DT::renderDT({
  DT::datatable(rsites_visited())
})
#Sites Visited static table
output$sites_visited_gt <- render_gt({
  gt(rsites_visited())
})

#Sites visited by type static table
output$sites_visited_type_gt <- render_gt({
    gt(rsites_visited_type(),
        rowname_col = "Location"
          , groupname_col = "Type of Visit") |> 
       sub_missing(missing_text = 0) |> 
       row_group_order(c("In person", "Remote", "Telephone")) |>
       tab_style(
         locations = cells_row_groups(),
         style = cell_text(weight = "bold")) |> 
       tab_stub_indent(rows = everything()) |> 
       summary_rows(
         fns =  list(label = md("**Total**"), id = "totals", fn = "sum"),
         side = "bottom"
       ) |> 
      tab_style(
         locations = cells_summary(),
         style = list(cell_fill(color = "lightgrey" |> adjust_luminance(steps = +1))
                      , cell_text(weight = "bold")
         )
       )
})

#Tmap 
tmap_mode("view")
output$map_sites <- tmap::renderTmap({
    tm_shape(data_sfr()) +
      tm_dots()
      })

#download function for table


output$download <- downloadHandler(
  filename = function(){},
  content = function(file){
    writexl::write_xlsx(data(), path = file)
  }
)

#Testing out the live filter checkboxes  
output$DT_table_react <- DT::renderDT({
    DT::datatable(text_react() 
  )
})


#output$DT_table_react <- DT::renderDT({
 # req(input$column_names)
  
 # DT::datatable(eventReactive(
   # text_react())
#  )
#})  
  
}
#build the app
shinyApp(ui=ui, server=server)
