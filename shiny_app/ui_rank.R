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
smoking <- read_csv(here("clean_data/smoking.csv"))
drugs <- read_csv(here("clean_data/sdmd_by_ca_and_demo_clean.csv"))

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      # selection input for what subject to view
      fluidRow(
        selectInput("health_input",
                    "Select Data",
                    choices = c("Life Expectancy", "Drug Misuse", "Smoking")
        )),
      
      # selector for choosing local authority or NHS health board levels
      fluidRow(
        selectInput("datazone_input",
                    "Select Data Zone",
                    choices = c("Local Authority", "NHS Health Board")
        )),
      
      # selection of date range
      fluidRow(
        selectInput("date_input",
                    "Date",
                    choices = case_when(
                      health_input == "Life Expectancy" ~ unique(life_expectancy$date_code),
                      health_input == "Drug Misuse" ~ unique(drugs$year),
                      health_input == "Smoking" ~ unique(smoking$date_code))
        )),
      
      fluidRow(
        # these radio buttons are for the sex of the top 5 / bottom 5 areas
        radioButtons("sex_input",
                     "Sex",
                     choices = c("All", "Male", "Female"),
                     inline = TRUE
        ))
      
    ),
    
    mainPanel(
      
      fluidRow(
        plotOutput("distPlot")),
      
      fluidRow(
        column(6, offset = 2,
               tableOutput("dataTable_top")),
        
        column(6, offset = 2,
               tableOutput("dataTable_bottom")))
      
    )
    
  )
)


server <- function(input, output, session) {
  
  filtered_data_le <- reactive({life_expectancy %>% 
      filter(type == input$datazone_input,
             simd_quintiles == "All",
             urban_rural_classification == "All",
             date_code == input$date_input,
             age == 0)
  })
  
  # create plots for both local authority and health board
  output$distPlot <- renderPlot({
    
    if (input$health_input == "Life Expectancy"){
      
      # plot life expectancy vs local authority/health board
      plot <- filtered_data_le() %>%
        ggplot() +
        aes(x = name, y = le_value, fill = sex) +
        geom_col(position = "dodge") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
        labs(
          x = paste("\n", input$datazone_input),
          y = "Life Expectancy (years)\n",
          fill = "Sex"
        )
      
      # create data table for selected type - top 5
      output$dataTable_top <- renderTable({
        filtered_data_le() %>%
          filter(sex == input$sex_input) %>% 
          select(name, date_code, sex, age, le_lower_ci, le_upper_ci, le_value) %>%
          arrange(desc(le_value)) %>% 
          head(5)
      })
      
      # create data table for selected type - bottom 5
      output$dataTable_bottom <- renderTable({
        filtered_data_le() %>%
          filter(sex == input$sex_input) %>% 
          select(name, date_code, sex, age, le_lower_ci, le_upper_ci, le_value) %>%
          arrange(desc(le_value)) %>% 
          tail(5)
      })
      
    }
    
    if (input$health_input == "Drug Misuse") {
      
      # create filtered data for drug misuse
      
      # this plot is just a placeholder
      plot <- drugs %>% 
        filter(type == input$datazone_input) %>% 
        filter(number_assessed != 0) %>%
        filter(!is.na(number_assessed)) %>%
        group_by(name) %>% 
        summarise(number_assessed_total = sum(number_assessed)) %>% 
        ggplot(aes(x = name, y = number_assessed_total)) +
        geom_col() +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
      
    }
    
    if (input$health_input == "Smoking") {
      
      # this plot is just a placeholder
      plot <- smoking %>% 
        filter(type == input$datazone_input,
               date_code == "2013",
               age == "All",
               sex == "All",
               long_term_condition == "All",
               household_type == "All") %>% 
        ggplot() +
        aes(x = name, y = sm_percent, fill = smokes) +
        geom_col() +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
      
    }
    
    plot
    
  })
  
}

shinyApp(ui, server)