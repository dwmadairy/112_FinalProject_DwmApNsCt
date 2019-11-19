library(rsconnect)
library(shiny)
library(tidyverse)

rsconnect::setAccountInfo(name='andrew-polk',
                          token='F18507D56BCA0C73692811CF155D5878',
                          secret='wxkv197ukbZBbhv/8wiY0I6P5Tg83vc0rqnSYpGb')

climberpeak <- read.csv("climberpeak.csv")

ui <- fluidPage(
      sliderInput(inputId = "Years", label = "Year Range", min = 1960, 
                  max = 2018, value = c(1960, 2018), sep = ""),
      selectInput("peak", "Peak", choices = list(Everest = "Everest", 
                  Makalu = "Makalu", Pumori = "Pumori")),
      submitButton(text = "Create Plot!"),
      plotOutput(outputId = "expedplot")
    )

server <- function(input, output) {
  output$expedplot <- renderPlot({
    climberpeak %>%
      group_by(PKNAME, YEAR) %>%
      summarise(expeditions = sum(n())) %>%
      ggplot()+
      geom_line(aes(x = YEAR, y = expeditions)) +
      scale_x_continuous(limit = input$Years)
  })
}

shinyApp(ui = ui, server = server)