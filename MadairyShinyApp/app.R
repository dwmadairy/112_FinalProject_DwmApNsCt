library(rsconnect)
library(shiny)
library(tidyverse)

rsconnect::setAccountInfo(name='dwmadairy',
                          token='4DC38EC759B3580D2756976F3DBC39CA',
                          secret='eLKEkx/W1shlKvObffSU6HS39Wb5O19U9vqatQ7p')

climberpeak <- read_csv("climberpeak.csv")

ui <- fluidPage(
  sliderInput(inputId = "years", label="Range", min=1900, max=2019, value=c(1900,2019), sep=""),
  textInput(inputId = "peakSelect", label="Peak", value="", placeholder = "Enter Peak: without 'Mt.'"),
  submitButton(text = "Create Plot"),
  plotOutput(outputId = "peakplot")
)

server <- function(input, output) {
  output$peakplot <- renderPlot({
    climberpeak %>%
      filter(PKNAME==input$peakSelect) %>% 
      group_by(PKNAME, YEAR) %>% 
      summarize(deaths=sum(HDEATHS+MDEATHS)) %>% 
      ggplot()+
      geom_line(aes(x=YEAR, y=deaths))+
      scale_x_continuous(limit=input$years)
    
  })
   
}


shinyApp(ui = ui, server = server)