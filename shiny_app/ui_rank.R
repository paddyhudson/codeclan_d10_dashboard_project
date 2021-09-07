#--------------------------------------------------------------------------#
# UI for Rank Page                                                        #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             |             | Initial Version                          #
#--------------------------------------------------------------------------#

library(shiny)
library(tidyverse)
library(here)

life_expectancy <- read_csv(here("clean_data/life_expectancy.csv"))

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("datazone_input",
                  "Select Data Zone",
                  choices = c("Local Authority", "NHS Health Board")
      ),
      
      selectInput("date_input",
                  "Date",
                  choices = c("1991-1993", "1993-1995", "1995-1997", "1997-1999", 
                              "1999-2001", "2001-2003", "2003-2005", "2005-2007", 
                              "2007-2009", "2009-2011", "2011-2013", "2013-2015",
                              "2015-2017", "2017-2019")
      ),
      
    ),
    
    mainPanel(
      
      plotOutput("distPlot"),
      
      dataTableOutput("dataTable")

    )
    
  )
  
)

server <- function(input, output, session) {
  
  # filtered data for plot and data table
  filtered_data <- reactive({
    life_expectancy %>% 
      filter(type == input$datazone_input,
             simd_quintiles == "All",
             urban_rural_classification == "All",
             date_code == input$date_input)
  })
  
  # create bar graph for both local authority and health board
  output$distPlot <- renderPlot({
    filtered_data() %>%
      ggplot() +
      aes(x = name, y = le_value, fill = sex) +
      geom_col(position = "dodge") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Local authority",
        y = "Life Epectancy (years)\n",
        fill = "Sex"
      )
  })
  
  # create data table for select type
  output$dataTable <- renderDataTable({
    filtered_data() %>% 
      select(name, date_code, sex, age, le_lower_ci, le_upper_ci, le_value) %>% 
      arrange(name)
  })
  
  # life_expectancy %>%
  #   filter(age == 0,
  #          urban_rural_classification == "All",
  #          sex == "Male",
  #          simd_quintiles != "All") %>%
  #   arrange(date_code) %>% 
  #   ggplot() +
  #   aes(x = date_code, y = le_value, group = simd_quintiles, colour = simd_quintiles) +
  #   geom_line() +
  #   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  #   labs(
  #     x = "\nYear",
  #     y = "Life Expenctancy (Years)\n",
  #     colour = "SIMD\nQuintiles"
  #   )
  
}

shinyApp(ui, server)