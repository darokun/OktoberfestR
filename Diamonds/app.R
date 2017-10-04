#Remember to load & define variables for the global environment, e.g. packages, objects
library(shiny)

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

server <- function(input, output) {}

shinyApp(ui = ui, server = server)