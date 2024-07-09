
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

  observeEvent(input$file, {
    req(rtable()) #we need rtable()
    
    #update input$column_names with colnames of selected dataset, rtable()
    updateCheckboxGroupInput(
      session, 
      "column_names",
      choices = colnames(rtable()),
      selected = colnames(rtable())
    )
  })
  
    
  output$DT_table <- DT::renderDT({
    rtable()
  })

}
  
  
  

#build the app
shinyApp(ui=ui, server=server)