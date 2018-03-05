server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(data=diamonds, aes(x=price)) + geom_histogram()
  })
  output$plot2 <- renderPlot({
    ggplot(data=diamonds, aes(x=carat)) + geom_histogram()
  })
}