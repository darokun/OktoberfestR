#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny)
library(ggplot2)

ui <- fluidPage(titlePanel("Title"),
                sidebarLayout(
                   sidebarPanel("Sidebar Panel",
                                 selectInput(inputId="list",
                                             label="List Label", 
                                             choices=c("price", "carat"), 
                                             selected="price"
                                            )
                                ),
                   mainPanel("Main Panel",
                                 tabsetPanel(
                                   tabPanel(title="1st Plot", plotOutput(outputId = "plot1")) 
                                            )
                            )
              )
 
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(data=diamonds, aes_string(x=input$list)) + geom_histogram()
  })
}

shinyApp(ui = ui, server = server)