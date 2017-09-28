library(shiny)
library(tidyverse)

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
      
      radioButtons(inputId = "variableInput",
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
  output$distPlot <- renderPlot({
    filtered <-
      data %>%
      filter(year >= input$yearInput[1],
             year <= input$yearInput[2]) %>%
      select(
        # visitor_day == input$variableInput[1],
             visitor_year == input$variableInput[2],
             beer_price == input$variableInput[3],
             beer_sold == input$variableInput[4],
             chicken_price == input$variableInput[5],
             chicken_sold == input$variableInput[6]
             )

    ggplot(filtered) + 
      geom_bar(aes(input$yearInput, input$variableInput)) +
      scale_y_continuous(
        labels = scales::comma, 
        limits = c(0, 8000000),
        breaks = seq(0, 8000000, by = 1000000)) +
      scale_x_continuous(breaks = seq(1985, 2016, by = 1))

    })
  
}

shinyApp(ui = ui, server = server)