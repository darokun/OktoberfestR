library(shiny)

ui <- fluidPage(
  
  # Application title
  titlePanel("OktobeRfest!"),
  
  # Sidebar with a slider input for range of years 
  sidebarLayout(
    sidebarPanel(
      sliderInput(
      )
    ),
  
  
    # Show a plot of the generated distribution
    mainPanel(
      
    )
  )
)

server <- function(input, output) {

  
}

shinyApp(ui = ui, server = server)