
source(here::here("./prep/prep.R"))

#the user interface
ui <- fluidPage(
  titlePanel("Simple Sentiment Analyzer"),
  sidebarLayout(
   sidebarPanel(fileInput(inputId = "file"
            , label = "Drag your file here or browse for it:"
            , multiple = FALSE)
            , checkboxGroupInput(inputId = "column_names"
                                 , label = "Select text columns"
                                 , inline = FALSE
                                 , choices = c())
),
  mainPanel(
    tabsetPanel(
      tabPanel(
        DT::DTOutput('DT_table')
 ),
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

  text_react <- reactive({
    req(input$column_names)
    
    rtable() |> 
      select_at(input$column_names) |>
      mutate(respondent = row_number()) |>
      unnest_tokens(word, text_response) |> 
      inner_join(get_sentiments("bing")) |> 
      mutate(value = case_when(sentiment == "positive" ~ 1
                               , sentiment == "negative" ~ 2)) |> 
      group_by(respondent) |> 
      summarize(score = sum(value))
      
      
      
      
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
    rtable()
  })


#Testing out the live filter checkboxes  
output$DT_table_react <- DT::renderDT({
  req(input$column_names)
  
  DT::datatable(
    text_react()
  )
})  
  
}
#build the app
shinyApp(ui=ui, server=server)