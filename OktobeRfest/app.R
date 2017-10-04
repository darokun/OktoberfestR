library(shiny)
library(tidyverse)

rawDataUrl <- "https://www.opengov-muenchen.de/dataset/8d6c8251-7956-4f92-8c96-f79106aab828/resource/e0f664cf-6dd9-4743-bd2b-81a8b18bd1d2/download/oktoberfestgesamt19852016.csv"

# read data
data <- read.csv(rawDataUrl)

# rename variables DEU-ENG
data <- rename(data, year = jahr, 
               duration_days = dauer,
               visitor_year = besucher_gesamt, 
               visitor_day = besucher_tag, 
               beer_price = bier_preis,
               beer_sold = bier_konsum,
               chicken_price = hendl_preis,
               chicken_sold = hendl_konsum)

# unify measures
data$visitor_year <- data$visitor_year * 1000000
data$visitor_day <- data$visitor_day * 1000
data$beer_sold <- data$beer_sold * 100

ui <- fluidPage(
  
  # Application title
  titlePanel("OktobeRfest!"),
  
  # Sidebar with a slider input for range of years 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "yearInput",
                  label = "Choose a range of years",
                  value = NULL,
                  min = NULL,
                  max = NULL),
      
      selectInput(inputId = "variableInput",
                  label = "What do you want to visualize?",
                  selected = "")
    ),
  
  
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput(outputId = "table1")
      # ,
      # plotOutput(outputId = "distPlot"),
      # br(), br(),
      # tableOutput(outputId = "summaryTable")
    )
  )
)

server <- shinyServer(function(input, output, session) {
  
  updateSliderInput(session, inputId = 'yearInput', label = 'Year',
                    min = 1985,
                    max = 2016,
                    value = c(min(data$year), max(data$year)),
                    sep = "")
  updateSelectInput(session, inputId = 'variableInput', label = 'What do you want to visualize?',
                    choices = names(data), selected = names(data))
  
  
  # data$visitor_day == input$variableInput[1]
  # data$visitor_year == input$variableInput[2]
  # data$beer_price == input$variableInput[3]
  # data$beer_sold == input$variableInput[4]
  # data$chicken_price == input$variableInput[5]
  # data$chicken_sold == input$variableInput[6]
  
  df_subset <- reactive({
    a <- tibble(data$year, input$variableInput)
    # a <- a %>%
    #       filter(data$year >= input$yearInput[1],
    #              data$year <= input$yearInput[2])
    return(a)
  })
  
  output$table1 <- renderTable(df_subset())
  
  # output$distPlot <- renderPlot({
  #   filtered <- df_subset() %>%
  #     filter(year >= input$yearInput[1],
  #            year <= input$yearInput[2])
  # 
  #   ggplot(filtered) + 
  #     geom_bar(aes(c(input$yearInput[1], input$yearInput[2]), input$variableInput)) +
  #     scale_y_continuous(
  #       labels = scales::comma, 
  #       limits = c(0, 8000000),
  #       breaks = seq(0, 8000000, by = 1000000)) +
  #     scale_x_continuous(breaks = seq(1985, 2016, by = 1))
  # 
  #   })
  
})

shinyApp(ui = ui, server = server)