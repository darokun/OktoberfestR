library(shiny)
library(tidyverse)
library(plotly)
library(colourpicker)

data_file <- 'https://www.opengov-muenchen.de/dataset/8d6c8251-7956-4f92-8c96-f79106aab828/resource/e0f664cf-6dd9-4743-bd2b-81a8b18bd1d2/download/oktoberfestgesamt19852016.csv'
data <- read_csv(data_file)

# translate variable names to English
data <- rename(data, year = jahr, 
               duration_days = dauer,
               visitors_year = besucher_gesamt, 
               visitors_day = besucher_tag, 
               beer_price = bier_preis,
               beer_sold = bier_konsum,
               chicken_price = hendl_preis,
               chicken_sold = hendl_konsum)

# unify measures
data$visitors_year <- data$visitors_year * 1000000
data$visitors_day <- data$visitors_day * 1000
data$beer_sold <- data$beer_sold * 100


ui <- fluidPage(
  
  ####   source for the header and parts of css: https://github.com/remyzum/Paris-Accidentologie-ShinyApp
  
  ####   It uses Javascript to detect the browser window size (initial size and any resize), 
  ####   and use Shiny.onInputChange to send the data to the server code for processing. 
  ####   It uses shiny:connected event to get the initial window size, as Shiny.onInputChange 
  ####   is not ready for use until shiny is connected.
  tags$head(tags$script('
                        var dimension = [0, 0];
                        $(document).on("shiny:connected", function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        $(window).resize(function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        ')),
  
  title = "OktoberfestR",
  
  shinyjs::useShinyjs(),
  
  tags$head(includeCSS(file.path("www", "app.css"))),
  
  div(id = "header",
      
      div(id = "title",
          "OktoberfestR"),
      
      div(id = "subsubtitle",
          "A web application to analyze Oktoberfest data",
          HTML("&bull;"),
          "Data available from the",
          tags$a(href = "https://www.opengov-muenchen.de/dataset/oktoberfest","Munich Open Data Portal")
      )
  ),
  
  sidebarLayout(
    sidebarPanel(
      
      h2("OktoberfestR"),
      h6("Code available on", tags$a(href = "https://github.com/darokun/OktoberfestR", "GitHub")),
      h6("Code license:", tags$a(href = "https://github.com/darokun/OktoberfestR/blob/master/LICENSE", "MIT")),
      
      hr(),
      sliderInput("year", "Select a range of years:",
                  min = min(data$year), max = max(data$year), 
                  value = c(min(data$year), max(data$year)),
                  step = 1),
      
      radioButtons("analysis", "Choose which plot you would like to generate:",
                  choices = c("Number of visitors per year" = "visitors",
                              "Divergence of visitors compared to the mean" = "visitors_lag",
                              "Beer price per year" = "beer_price_year",
                              "Beer price compared to previous year" = "beer_price_prev",
                              "Beer sold on average (Liters/day)" = "beer_sold_year",
                              "Beer sold per visitor per day (Liters/day)" = "beer_visitor_day",
                              "Chicken price per year" = "chicken_price_year",
                              "Chicken price compared to previous year" = "chicken_price_prev"
                              ),
                  selected = "visitors"),
      
      colourInput("col", "Select a color for your plots:", value = "#27A366")
      
    ),
    
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(
          title = "Dataset",
          icon = icon("table"),
          id = "table",
          br(),
          br(),
          br(),
          DT::dataTableOutput("table")
        ),
        
        tabPanel(
          title = "Plot",
          icon = icon("bar-chart-o"),
          id = "plot",
          br(),
          br(),
          br(),
          plotlyOutput("plot")
        ),
        
        tabPanel(
          title = "About",
          icon = icon("info-circle"),
          id = "about",
          includeMarkdown("README.md")
        )
      )
    )
  ),
  
  hr(),
  div(id = "footer",
      div(id = "subsubtitle",
          "2018 |", 
          tags$a(href ="https://drmolina.netlify.com/", "Daloha Rodriguez-Molina"), 
          " |", 
          tags$a(href ="https://twitter.com/darokun", "@darokun"))
      )
)
  

  

server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- subset(data, year >= input$year[1] & year <= input$year[2])
  })
  
  mutated_data_beer <- reactive({
    filtered_data() %>%
      mutate(increase = beer_price - lag(beer_price, default = NA))
  })

  mutated_data_chicken <- reactive({
    filtered_data() %>%
      mutate(increase = chicken_price - lag(chicken_price, default = NA))
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
          geom_bar(aes(year, visitors_year), 
                   stat = "identity",
                   fill = input$col) + 
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
          scale_x_continuous(breaks = seq(min(data$year), max(data$year), by = 1)) +
          theme(axis.text.x = element_text(angle = 90, hjust = 1))
      )
    
      } else if (input$analysis == "visitors_lag") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, visitors_year - mean(visitors_year)), 
                     stat = "identity",
                     fill = input$col) + 
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
              breaks = seq(min(data$year), max(data$year), by = 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      } else if (input$analysis == "beer_price_year") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, beer_price), 
                     stat = "identity",
                     fill = input$col) + 
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
              breaks = seq(min(data$year), max(data$year), by = 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      } else if (input$analysis == "beer_price_prev") {
        ggplotly(
          ggplot(mutated_data_beer()) + 
            geom_bar(aes(year, increase), 
                     stat = "identity",
                     fill = input$col) + 
            labs(
              title = "There were steep beer price increases in 1991, 2000, 2007, and 2008 compared to the former years",
              subtitle = "Beer price increase compared to former year -- Oktoberfest",
              x = "Year",
              y = "Beer price increase compared to year before"
            ) +
            scale_y_continuous(
              labels = scales::dollar_format(suffix = "€", prefix = ""), 
              breaks = seq(-10, +10, by = 0.05)) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1), 
              limits = c(min(data$year) - 1, max(data$year) + 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      } else if (input$analysis == "beer_sold_year") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, beer_sold / duration_days), 
                     stat = "identity",
                     fill = input$col) + 
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
              limits = c(min(data$year) - 1, max(data$year) + 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      } else if (input$analysis == "beer_visitor_day") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, beer_sold / duration_days / visitors_day), 
                     stat = "identity",
                     fill = input$col) + 
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
              limits = c(min(data$year) - 1, max(data$year) + 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      } else if (input$analysis == "chicken_price_year") {
        ggplotly(
          ggplot(data) + 
            geom_bar(aes(year, chicken_price), 
                     stat = "identity",
                     fill = input$col) + 
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
              breaks = seq(min(data$year), max(data$year), by = 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      } else if (input$analysis == "chicken_price_prev") {
        ggplotly(
          ggplot(mutated_data_chicken()) + 
            geom_bar(aes(year, increase), 
                     stat = "identity",
                     fill = input$col) + 
            labs(
              title = "Oktoberfest chicken price increased 46% in the year 2000",
              subtitle = "Overview of chicken price compared to year before",
              x = "Year",
              y = "Chicken price increase compared to year before"
            ) +
            scale_y_continuous(
              labels = scales::dollar_format(suffix = "€", prefix = ""), 
              breaks = seq(-10, +10, by = 0.25)) +
            scale_x_continuous(
              breaks = seq(min(data$year), max(data$year), by = 1), 
              limits = c(min(data$year) - 1, max(data$year) + 1)) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
        )
        
      }
    
  })
  
}























shinyApp(ui, server)