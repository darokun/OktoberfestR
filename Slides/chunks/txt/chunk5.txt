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