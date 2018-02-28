library(shiny)
library(tidyverse)
library(datasets)
library(plotly)

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
      
      radioButtons("analysis", "Choose which plot you would like to generate:",
                  choices = c("Number of visitors per year" = "visitors",
                              "Divergence of visitors compared to the mean" = "visitors_lag",
                              "Beer price per year" = "beer_price_year",
                              # "Beer price compared to previous year" = "beer_price_prev",
                              "Beer sold on average (Liters/day)" = "beer_sold_year",
                              "Beer sold per visitor per day (Liters/day)" = "beer_visitor_day",
                              "Chicken price per year" = "chicken_price_year"
                              # ,
                              # "Chicken price compared to previous year" = "chicken_price_prev"
                              ),
                  selected = "visitors")
      
    ),
    
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(
          title = "Dataset",
          id = "table",
          br(),
          br(),
          br(),
          DT::dataTableOutput("table")
        ),
        
        tabPanel(
          title = "Plot",
          id = "plot",
          br(),
          br(),
          br(),
          plotlyOutput("plot")
        )
      )

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
  
  
  
  output$plot <- renderPlotly({
    data <- filtered_data()
    
    if(input$analysis == "visitors") {
      ggplotly(
        ggplot(data) + 
          geom_bar(aes(year, visitor_year), 
                   stat = "identity",
                   fill = "#27A366") + 
          labs(
            title = "Number of visitors to the Oktoberfest vary and are currently in decline since 2011",
            subtitle = "Number of visitors to the Oktoberfest",
            x = "Year",
            y = "Visitors per year"
          ) +
          scale_y_continuous(
            labels = scales::comma, 
            limits = c(0, 8000000),
            breaks = seq(0, 8000000, by = 1000000)) +
          scale_x_continuous(breaks = seq(min(data$year), max(data$year), by = 1))
      )
    
      } else if (input$analysis == "visitors_lag") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, visitor_year - mean(visitor_year)), 
                     stat = "identity",
                     fill = "#27A366") + 
            labs(
              title = "Number of visitors to the Oktoberfest vary and are currently in decline since 2011",
              subtitle = "Divergence of visitors compared to the mean ",
              x = "Year",
              y = "Divergence from mean visitors per year"
            ) +
            scale_y_continuous(
              labels = scales::comma, 
              limits = c(-1000000, 1000000),
              breaks = seq(-1000000, 1000000, by = 100000)
            ) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1))
        )
        
      } else if (input$analysis == "beer_price_year") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, beer_price), 
                     stat = "identity",
                     fill = "#27A366") + 
            labs(
              title = "Oktoberfest beer price increases 0.24 € per year, on average",
              subtitle = "Overview of beer price development -- Oktoberfest",
              x = "Year",
              y = "Price for one liter beer"
            ) +
            scale_y_continuous(
              labels = scales::dollar_format(suffix = "€", prefix = ""), 
              limits = c(0, 11.5), 
              breaks = seq(0, 11.5, by = 0.5)) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1))
        )
        
      } else if (input$analysis == "beer_sold_year") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, beer_sold / duration_days), 
                     stat = "identity",
                     fill = "#27A366") + 
            labs(
              title = "Regardless of fewer visitors in recent years, the amount of sold beer is higher than in the nineties",
              subtitle = "Overview of beer sold in Liter per day, on average -- Oktoberfest",
              x = "Year",
              y = "Beer sold per day (Liter)"
            ) +
            scale_y_continuous(
              labels = scales::comma, 
              breaks = seq(0, 500000, by = 50000)) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1), 
              limits = c(min(data$year) - 1, max(data$year) + 1))
        )
        
      } else if (input$analysis == "beer_visitor_day") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, beer_sold / duration_days / visitor_day), 
                     stat = "identity",
                     fill = "#27A366") + 
            labs(
              title = "On average, Oktoberfest visitors drink more beer -- over 1.2 Liter in 2015",
              subtitle = "Overview of beer sold in Liter per day per visitor, on average",
              x = "Year",
              y = "Beer sold per day (Liter)"
            ) +
            scale_y_continuous(
              labels = scales::comma, 
              breaks = seq(0, 1.5, by = 0.1)) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1), 
              limits = c(min(data$year) - 1, max(data$year) + 1))
        )
        
      } else if (input$analysis == "chicken_price_year") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, chicken_price), 
                     stat = "identity",
                     fill = "#27A366") + 
            labs(
              title = "Oktoberfest chicken price increases over the years with a steep increase in 2000",
              subtitle = "Overview of chicken price",
              x = "Year",
              y = "Chicken price"
            ) +
            scale_y_continuous(
              labels = scales::dollar_format(suffix = "€", prefix = ""), 
              limits = c(0, 11.5), 
              breaks = seq(0, 11.5, by = 1)) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1))
        )
        
      }
    
  })
  
}























shinyApp(ui, server)