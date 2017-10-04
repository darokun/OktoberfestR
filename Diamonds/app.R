#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny) 
library(ggplot2)
library(RColorBrewer)

ui <- fluidPage(
  titlePanel("Example Shiny App: Tool for Exploring Diamond Data"), 
  sidebarLayout(
    
    sidebarPanel(
      selectInput(
        inputId="cut",
        label="Select Cut of Diamond:", 
        choices = c("Fair", "Good", "Very Good"),
        selected = "Good")
    ), 
    
    mainPanel(
      tabsetPanel( 
        tabPanel("Price vs Carat",
                 plotOutput(outputId = "scatter")
        ),
        tabPanel("Volume by Clarity class",
                 plotOutput(outputId = "bar")
        )
      )
    )
  )
)

server <- function(input, output){ 
  getDataset <- reactive({
    if (input$cut=="Fair") {
      return(diamonds[diamonds$cut=="Fair", ])
    } else if (input$cut=="Good") {
      return(diamonds[diamonds$cut=="Good", ])
    } else {
      return(diamonds[diamonds$cut=="Very Good", ])
    }
  })
  
  output$scatter <- renderPlot({
    ggplot(data=getDataset(), aes(x=price, y=carat)) + geom_point(aes(colour=color)) + scale_color_brewer(palette="Blues")
  })
  
  output$bar <- renderPlot({
    ggplot(data=getDataset(), aes(x=clarity)) + geom_bar(aes(fill=color)) + scale_fill_brewer(palette="Spectral")
  })
}

shinyApp(ui=ui, server=server)


