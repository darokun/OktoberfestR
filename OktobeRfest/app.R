library(shiny)

data <- read.csv("dataOktoberfest.csv")

ui <- fluidPage(
  
  # Application title
  titlePanel("OktobeRfest!"),
  
  # Sidebar with a slider input for range of years 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "yearInput",
                  label = "Choose a range of years",
                  min = 1985,
                  max = 2016,
                  value = c(1985, 2016),
                  sep = ""),
      
      selectInput(inputId = "variableInput",
                  label = "What do you want to visualize?",
                  choices = c("Mean visitors per day",
                              "Visitors per year",
                              "Beer price",
                              "Amount of beer sold",
                              "Chicken price",
                              "Amount of chicken sold"),
                  selected = "Beer price")
    ),
  
  
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(outputId = "distPlot"),
      br(), br(),
      tableOutput(outputId = "summaryTable")
    )
  )
)

server <- function(input, output) {

  
}

shinyApp(ui = ui, server = server)