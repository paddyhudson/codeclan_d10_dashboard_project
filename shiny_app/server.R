#--------------------------------------------------------------------------#
# Server file                                                              #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created Observe Event   #
#                 |             | for TabsetPanel                          #
#--------------------------------------------------------------------------#

server <- function(input, output, session) {

# Server for Home Page ------------------------------------------------------
  
  observeEvent(input$jumpToTrend, {
    updateTabsetPanel(session, "inTabset",
                      selected = "trend_panel")
  })
  observeEvent(input$jumpToRank, {
    updateTabsetPanel(session, "inTabset",
                      selected = "rank_panel")
  })
  observeEvent(input$jumpToMap, {
    updateTabsetPanel(session, "inTabset",
                      selected = "map_panel")
  })
  
  #This output variable is used in UI to display the plot title
  
  output$topic <- renderText({ input$topic_input})
  output$area <- renderText({ input$area_input})
  output$name <- renderText({ input$name_input})
  output$demographic <- renderText({ input$demographic_input})
  output$breakdown <- renderText({ input$breakdown_input})
  
  
# Server script for Trend Page  ----------------------------------------------

  # observeEvent to update area selection with local authorities and health boards
  observeEvent(c(input$area_input, 
                 input$topic_input), {
    
    if( input$topic_input == "Life Expectancy")
      {input_table <- life_expectancy_clean }
    else{
      if(input$topic_input == "Drug Abuse")
        {input_table <- sdmd_combined_plus_zones}
      else 
        {input_table <- smoking_clean }
    }
    
    #Fetch Zone data dynamically
    zone_selection <- input_table %>%
      distinct(type) %>% 
      filter(!(is.na(type))) %>% 
      arrange(type)
    
    updateSelectInput(
      inputId = "area_input",
      choices = zone_selection$type,
      session = getDefaultReactiveDomain()
    )
    
    #Fetch Region data dynamically
    area_selection <- input_table %>%
      filter(type == input$area_input) %>%
      distinct(name) %>% 
      arrange(name)
    
    updateSelectInput(
      inputId = "name_input",
      choices = area_selection$name,
      session = getDefaultReactiveDomain()
    )

  })

  #The breakdown choices are listed dynamically
  choices_demographic_input <- reactive({
    if(input$breakdown_input == "Age")
    {
      choices_demographic_input <- unique(sort(life_expectancy_clean$age))
    }
    else{
      choices_demographic_input <- unique(sort(life_expectancy_clean$sex))
    }

  })
  # Update the breakdown type dynamically
  observe({
    updateCheckboxGroupInput(session = session,
                             inputId = "demographic_input",
                             choices = choices_demographic_input(),
                             selected = max(choices_demographic_input()),
                             inline = TRUE
    )
  })
  # Server script for life expectancy -------------------------------------
  
        filtered_data <- reactive(
          select_life_data(input$breakdown_input,input$name_input,input$demographic_input )
        )
        
        # Function to create ggplot
        plot <- reactive(
          plot_life_object(data = filtered_data(), input$breakdown_input)
        )
        
        # create plot
        output$distPlot <- renderPlot({
          plot()
        })
        
        # data table to show the data displayed in the life expectancy plot
        output$output_table <- renderDataTable({
          filtered_data()
        })  
  
# Server script for Drug Abuse ------------------------------------------
  
        filtered_drugs_data <- reactive(
          select_drug_data(input$breakdown_input,input$name_input,input$demographic_input )
        )
        
          # Function to create ggplot
          plot_drugs <- reactive(
            plot_drugs_object(data = filtered_drugs_data(), input$breakdown_input)
          )
          
          # create plot
          output$distPlot <- renderPlot({
            plot_drugs()
          })
        
        # data table to show the data displayed in the life expectancy plot
        output$output_table <- renderDataTable({
          filtered_drugs_data()
        })  
        
# Server script for Smoking  --------------------------------------------
  
}