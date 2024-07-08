
source(here::here("./prep/prep.R"))

#the user interface
ui <- fluidPage(
  titlePanel("Sentiment Analyzer"),
  sidebarLayout(
   sidebarPanel(fileInput(inputId = "file"
            , label = "Upload file:"
            , multiple = FALSE)
),
  mainPanel(DT::DTOutput('DT_table')
 )
)
)
#the server side  
server <- function(input, output, session) {
  
  # You can access the value of the widget with input$file, e.g.
  output$DT_table <- DT::renderDT({
    input$file |> 
      readxl::read_xlsx()
    
  })
  
}
  
  
  

#build the app
shinyApp(ui=ui, server=server)