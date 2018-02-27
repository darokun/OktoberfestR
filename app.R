library(shiny)
library(tidyverse)
library(datasets)

data_file <- 'https://www.opengov-muenchen.de/dataset/8d6c8251-7956-4f92-8c96-f79106aab828/resource/e0f664cf-6dd9-4743-bd2b-81a8b18bd1d2/download/oktoberfestgesamt19852016.csv'
data <- read_csv(data_file)

# translate variable names to English
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
  h1("OktoberfestR"),
  h3("A web application to analyze Oktoberfest data"),
  
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("year", "Select a range of years:",
                  min = min(data$year), max = max(data$year), 
                  value = c(min(data$year), max(data$year)),
                  step = 1),
      
      selectInput("variable", "Select a variable to analyze:",
                  choices = names(data[,-1]))
      
    ),
    
    
    mainPanel(
      DT::dataTableOutput("table")
    )
  )
)
  

  

server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- subset(data, year >= input$year[1] & year <= input$year[2])
  })
  
  output$table <- DT::renderDataTable({
    data <- filtered_data()
    data
  })
  
}

shinyApp(ui, server)