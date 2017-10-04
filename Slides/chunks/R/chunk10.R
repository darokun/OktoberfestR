#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny) 
library(ggplot2)

ui <- fluidPage(
  titlePanel("Example Shiny App: Distribution of Diamond stock by Price Bands"), 
  sidebarLayout(
    
    sidebarPanel(
      sliderInput(
        inputId="bands",
        label="Select No. of Price Bands", 
        min=1,
        max=30,
        value=15)
    ), 
    
    mainPanel(
      plotOutput(outputId="plot") 
    )
  )
)

server <- function(input, output){ 
  output$plot <- renderPlot({
    ggplot(data=diamonds, aes(x=price)) + geom_histogram() + stat_bin(bins=input$bands)
  })
} 

shinyApp(ui=ui, server=server)


