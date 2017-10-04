#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny)

ui <- fluidPage(
                titlePanel("Title"), 
                sidebarLayout(
                              sidebarPanel("Sidebar Panel"), 
                              mainPanel("Main Panel")
                              )
                )

server <- function(input, output) {}

shinyApp(ui = ui, server = server)