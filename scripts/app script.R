
source(here::here("./prep/prep.R"))

#the user interface
ui <- fluidPage(
  titlePanel("Simple Data Tool"),
  sidebarLayout(
   sidebarPanel(fileInput(inputId = "file"
            , label = "Drag your file here or browse for it:"
            , multiple = FALSE)
            , checkboxGroupInput(inputId = "column_names"
                                 , label = "Select columns"
                                 , inline = FALSE
                                 , choices = c()),
            actionButton("run_columns", label = "ACTION!!")
),
  mainPanel(
    tabsetPanel(
      tabPanel(DT::DTOutput('DT_table')),
      
      
      tabPanel(
        DT::DTOutput('DT_table_react'))
)
)))
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
