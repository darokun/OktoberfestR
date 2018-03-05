#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Title"), 
  sidebarLayout(
    sidebarPanel("Sidebar Panel"),
    mainPanel("Main Panel",
              tabsetPanel(
                tabPanel(title="1st Plot", plotOutput(outputId = "plot1")),
                tabPanel(title = "2nd Plot", plotOutput(outputId = "plot2"))
              )
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(data=diamonds, aes(x=price)) + geom_histogram()
  })
}

shinyApp(ui = ui, server = server)