ui <- fluidPage(
                titlePanel("Title"), 
                sidebarLayout(
                              sidebarPanel("Sidebar Panel",
                                            sliderInput(
                                                        inputId="bins",
                                                        label="Slider Label", 
                                                        min=1,
                                                        max=30,
                                                        value=15
                                                        )
                                            ),
                              mainPanel("Main Panel")
                              )
                )