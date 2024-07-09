
source(here::here("./prep/prep.R"))

#the user interface
ui <- fluidPage(
  titlePanel("Sentiment Analyzer"),
  sidebarLayout(
   sidebarPanel(fileInput(inputId = "file"
            , label = "Drag your file here or browse for it:"
            , multiple = FALSE)
            , checkboxGroupInput(inputId = "column_names"
                                 , label = "Select text columns"
                                 , inline = FALSE
                                 , choices = names(file))
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
  rtable <- eventReactive(input$file, {
    read_xlsx(input$file$datapath
              , col_names = TRUE)
  })
  
  output$DT_table <- DT::renderDT({
    rtable()
  })
  
  output$DT_table <- DT::renderDT({
    df <- readxl::read_xlsx(input$file
                      , col_names = TRUE) 
    return(df)
    })
  
  output$table <- renderTable({
    input$file 
  })
}
  
  
  

#build the app
shinyApp(ui=ui, server=server)