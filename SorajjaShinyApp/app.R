library(readr)
library(shiny)
library(rsconnect)
library(tidyverse)
library(corrplot)

climberpeak <- read_csv("climberpeak.csv")
climber_stripped <- climberpeak %>%
  select(SMTDAYS, TOTDAYS, HIGHPOINT, TOTMEMBERS, MDEATHS, CAMPS, SMTMEMBERS, SEASON, YEAR, SKI, TRAVERSE)

ui <- fluidPage(
  sliderInput(inputId = "YEAR", label = "Year Range",
              min = 1969, max = 2018, value = c(1969,2018),sep = ""),
  textInput("NATION", "Nation", value = "", placeholder = "S Korea or USA"),
  selectInput("SUCCESS1", "1st Peak Reached", choices = list("Failed" = "FALSE", "Success" = "TRUE")),
  selectInput("SUCCESS2", "2nd Peak Reached", choices = list("Failed" = "FALSE", "Success" = "TRUE")),
  selectInput("SUCCESS3", "3rd Peak Reached", choices = list("Failed" = "FALSE", "Success" = "TRUE")),
  selectInput("SUCCESS4", "4th Peak Reached", choices = list("Failed" = "FALSE", "Success" = "TRUE")),
  selectInput("O2USED", "Oxygen Used", choices = list("Did Not Use Oxygen" = "FALSE", "Used Oxygen Tank" = "TRUE")),
  submitButton(text = "Create my plot!"),
  plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
  output$timeplot <- renderPlot({
    p1 <- climberpeak %>% 
      filter(NATION == input$NATION, 
             SUCCESS1 == input$SUCCESS1, 
             SUCCESS2 == input$SUCCESS2,
             SUCCESS3 == input$SUCCESS3,
             SUCCESS4 == input$SUCCESS4,
             O2USED == input$O2USED) %>% 
      ggplot(aes(x = YEAR, y = MDEATHS)) +
      scale_x_continuous(limits = input$YEAR) +
      geom_col() +
      theme_minimal()
    p2 <- climber_stripped %>%
      cor(climber_stripped, use="pairwise.complete.obs")
    corrplot(p2, type="upper", col=brewer.pal(n=8, name="BuPu"))
  })
}

shinyApp(ui = ui, server = server)

