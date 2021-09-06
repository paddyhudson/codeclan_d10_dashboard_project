library(shiny)
library(tidyverse)

life_expectancy_clean <- read_csv("data/life_expectancy.csv")

ui <- fluidPage(

    titlePanel("Life Expectancy Data"),

    sidebarLayout(
        
        sidebarPanel(
            
            # need to order the age range 
            selectInput("age_input",
                        "Age Range:",
                        choices = unique(sort(life_expectancy_clean$age))
            ),
            
            radioButtons("area_input",
                        "Area:",
                        choices = c("Scotland", "Local Authority", "NHS Health Board")
            ),
            
            selectInput("name_input",
                        "Area:",
                        choices = c("Scotland")
            ),
            
            tags$a("Data provided by Scottish Government", href = "https://statistics.gov.scot/home/")
            
        ),
        
        mainPanel(
            
           plotOutput("distPlot"),
           
           dataTableOutput("life_expectancy_table")
           
        )
    )
)
    
server <- function(input, output, session) {
    
    # years vector created to avoid overlap of even and odd date ranges
    years_odd <- c("1991-1993", "1993-1995", "1995-1997", "1997-1999", 
                   "1999-2001", "2001-2003", "2003-2005", "2005-2007", 
                   "2007-2009", "2009-2011", "2011-2013", "2013-2015",
                   "2015-2017", "2017-2019")
    
    # years_even <- c("1992-1994", "1994-1996", "1996-1998", "1998-2000",
    #                   "2000-2002", "2002-2004", "2004-2006", "2006-2008",
    #                    "2008-2010", "2010-2012", "2012-2014", "2014-2016",
    #                    "2016-2018")
    
    # observeEvent to update area selection with local authorities and health boards
    observeEvent(input$area_input, {
        area_selection <- life_expectancy_clean %>%
            filter(type == input$area_input) %>%
            distinct(name) %>% 
            arrange(name)

        updateSelectInput(
            inputId = "name_input",
            choices = area_selection$name,
            session = getDefaultReactiveDomain()
        )
    })
    
    # filtered data for ggplot & data table
    filtered_data <- reactive({life_expectancy_clean %>%
        filter(name == input$name_input,
               age == input$age_input,
               simd_quintiles == "All",
               urban_rural_classification == "All",
               date_code %in% years_odd)
    })
    
    # line graph to display how life expectancy changes over time by age range
    output$distPlot <- renderPlot({
        filtered_data() %>% 
            ggplot() +
            aes(x = date_code, y = le_value, group = sex, colour = sex) +
            geom_line() +
            geom_point() +
            geom_ribbon(aes(ymax = le_upper_ci, ymin = le_lower_ci), alpha = 0.25, colour = NA) +
            theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
            labs(
                x = "\n\nYear",
                y = "Life Expectancy (years)\n",
                colour = "Sex"
            ) +
            ggtitle(paste("Life Expectancy in Years for", input$area_input))
    })
    
    # data table to show the data displayed in the life expectancy plot
    output$life_expectancy_table <- renderDataTable({
        filtered_data() %>%  
            select(name, date_code, sex, age, le_lower_ci, le_upper_ci, le_value) %>% 
            arrange(desc(date_code))
    })
    
}

shinyApp(ui = ui, server = server)
