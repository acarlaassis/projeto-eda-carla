library(shiny)
library(ggplot2)
library(dplyr)

df <- read.csv("Lifestyle_and_Health_Risk_Prediction_Synthetic_Dataset.csv")

df_num <- df |>
  select(age, bmi, sleep, weight)

ui <- fluidPage(
  
  selectInput("variavel", "Escolha a variável:",
              choices = names(df_num)),
  
  selectInput("cor", "Escolha a cor:",
              choices = c("blue", "red", "green")),
  
  sliderInput("x", "Limite do eixo X:",
              min = 1, max = nrow(df_num),
              value = c(1, 100)),
  
  sliderInput("y", "Limite do eixo Y:",
              min = 0, max = max(df_num, na.rm = TRUE),
              value = c(0, 100)),
  
  plotOutput("grafico")
)

server <- function(input, output) {
  
  output$grafico <- renderPlot({
    
    dados <- df_num |>
      mutate(index = row_number())
    
    ggplot(dados, aes(x = index, y = .data[[input$variavel]])) +
      geom_line(color = input$cor) +
      xlim(input$x[1], input$x[2]) +
      ylim(input$y[1], input$y[2])
    
  })
}

shinyApp(ui = ui, server = server)