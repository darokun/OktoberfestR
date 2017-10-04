#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny)

ui <- pageWithSidebar(
                      titlePanel("Title"), 
                      sidebarPanel("Sidebar Panel"), 
                      mainPanel("Main Panel")
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)