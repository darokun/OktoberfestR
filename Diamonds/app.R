#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny)

ui <- fluidPage(
                titlePanel("Title"), 
                sidebarLayout(
                              sidebarPanel("Sidebar Panel",
                                            selectInput(
                                                        inputId="list",
                                                        label="List Label", 
                                                        choices=c("Fair","Good","Very Good"),
                                                        selected="Good"
                                                        )
                                            ),
                              mainPanel("Main Panel")
                              )
                )

server <- function(input, output) {}

shinyApp(ui = ui, server = server)