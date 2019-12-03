library(shiny)
library(foreign)
library(tidyverse)
library(ggplot2)
library(readr)

peaks <- read_csv("peaks.csv")

climber <- read_csv("climber.csv")

nation <-
  unique(climber$NATION) %>% 
  str_split(pattern = '/') %>% 
  unlist() %>% 
  unique() %>% 
  str_sort()

ui <- fluidPage(
  selectInput("nations", "Nation of Origin", nation),
  submitButton(text = "Create my plot!"),
  plotOutput(outputId = "timeplot")
  )

server <- function(input, output){
  output$timeplot <- renderPlot({
    climber %>% 
      filter(NATION == input$nations) %>% 
      ggplot() +
      geom_point(aes(YEAR, HIGHPOINT)) +
      geom_smooth(aes(YEAR, HIGHPOINT))
  })
}

shinyApp(ui = ui, server = server)
