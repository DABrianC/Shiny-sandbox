
source(here::here("./prep/prep.R"))

#the user interface
ui <- fluidPage(
  titlePanel("Sentiment Analyzer"),
  sidebarLayout(
   sidebarPanel(fileInput(inputId = "file"
            , label = "Upload file:"
            , multiple = FALSE)
),
  mainPanel(
    tabsetPanel(
      tabPanel(
    DT::DTOutput('DT_table')
 ),
  tabPanel(tableOutput('table'))
)
)))
#the server side  
server <- function(input, output, session) {
  
  # You can access the value of the widget with input$file, e.g.
  output$DT_table <- DT::renderDT({
    input$file |> 
      
    
  })
  
  output$table <- renderTable({
    input$file 
  })
}
  
  
  

#build the app
shinyApp(ui=ui, server=server)