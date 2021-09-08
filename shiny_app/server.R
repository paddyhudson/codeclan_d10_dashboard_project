#--------------------------------------------------------------------------#
# Server file                                                              #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Server script for       #
#                 |             | Home Page, Trend Page & Rank Page        #
#                 |             |                                          #
# 1.1             | Derek       | Server script for Life Expectancy        #
#--------------------------------------------------------------------------#

server <- function(input, output, session) {

# Server script for Home Page -----------------------------------------------
  

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
  #Multiple assignment for each tabset


# Server script for Trend Page ------------------------------------------------
  
    #This output variable is used in UI to display the plot title in Trend Tab

    output$topic <- renderText({ input$topic_input})
    output$area <- renderText({ input$area_input})
    output$name <- renderText({ input$name_input})
    output$demographic <- renderText({ input$demographic_input})
    output$breakdown <- renderText({ input$breakdown_input})

    output$rank_topic<- renderText({ input$rank_topic_input})
    output$rank_area <- renderText({ input$rank_area_input})
    output$rank_name <- renderText({ input$rank_name_input})
    output$rank_demographic <- renderText({input$rank_demographic_input})
    output$rank_breakdown  <- renderText({input$rank_breakdown_input})

# Update Inputs for Trend Page  ----------------------------------------------

    
# Update Inputs for Trend Page
    
    # Event to populate the area dynamically    

    observeEvent( input$topic_input, {
      updateSelectInput(
        inputId = "area_input",
        choices = choose_area(input$topic_input),
        session = getDefaultReactiveDomain()
      )
    })

    # Event to populate the name dynamically    
    observeEvent(c( input$area_input, 
                    input$topic_input), {
                      updateSelectInput(
                        inputId = "name_input",
                        choices = choose_name(input$topic_input,input$area_input),
                        session = getDefaultReactiveDomain()
                      )                 
                    })
    
    # Event to populate the breakdown topic dynamically  
    observeEvent(input$topic_input, {
      updateSelectInput(
        inputId = "breakdown_input",
        choices = choose_breakdown_topic(input$topic_input),
        session = getDefaultReactiveDomain()
      )
    })

  
    # Event to populate the choices of breakdown dynamically    
    observeEvent(c(input$breakdown_input,
                   input$area_input,
                   input$name_input,
                   input$topic_input), {

                     choice <- choose_breakdown( input$topic_input,
                                                 input$breakdown_input,
                                                 input$area_input,
                                                 input$name_input )

                     updateCheckboxGroupInput(session = session,
                                              inputId = "demographic_input",
                                              choices = choice,
                                              selected = sort(choice),
                                              inline = TRUE
                     )
                   })

# Server script for Rank Page 
    
    #This output variable is used in UI to display the plot title in Rank Tab
    output$rank_topic<- renderText({ input$rank_topic_input})
    output$rank_area <- renderText({ input$rank_area_input})
    output$rank_name <- renderText({ input$rank_name_input})
    output$rank_demographic <- renderText({input$rank_demographic_input})
    output$rank_breakdown  <- renderText({input$rank_breakdown_input})
    
# Update Inputs for Rank Page 
    
  # Event to populate the area dynamically    

  # observeEvent( input$rank_topic_input, {
  #   updateSelectInput(
  #         inputId = "rank_area_input",
  #         choices = choose_area(input$rank_topic_input),
  #         session = getDefaultReactiveDomain()
  #       )
  #     })

  # Event to populate the name dynamically  
  # observeEvent(c( input$rank_area_input, 
  #                   input$rank_topic_input), {
  # updateSelectInput(
  #   inputId = "rank_name_input",
  #   choices = choose_name(input$rank_topic_input,input$rank_area_input),
  #   session = getDefaultReactiveDomain()
  # )
  # })
  
  # Event to populate the breakdown topic dynamically  
  # observeEvent(input$rank_topic_input, {
  #   updateSelectInput(
  #     inputId = "rank_breakdown_input",
  #     choices = choose_breakdown_topic(input$rank_topic_input),
  #     session = getDefaultReactiveDomain()
  #   )                 
  # })
  
  # Event to populate the choices of breakdown dynamically
  # observeEvent(c(input$rank_breakdown_input,
  #                 input$rank_area_input,
  #                 input$rank_name_input,
  #                 input$rank_topic_input), {
  # 
  # 
  #     choice <- choose_breakdown(input$rank_topic_input,
  #                                input$rank_breakdown_input,
  #                                input$rank_area_input,
  #                                input$rank_name_input )
  # 
  #     updateCheckboxGroupInput(session = session,
  #                        inputId = "rank_demographic_input",
  #                        choices = choice,
  #                        selected = choice,
  #                        inline = TRUE
  #                   )
  #                 })

  # Server script for life expectancy -------------------------------------

      filtered_data <- reactive(
          select_life_data(input$breakdown_input,input$name_input,input$demographic_input )
        )

        # Function to create ggplot
        plot <- reactive(
          plot_life_object(data = filtered_data(), input$breakdown_input)
        )
        

# Server script for Drug Abuse ------------------------------------------

        filtered_drugs_data <- reactive(
          select_drug_data(input$breakdown_input,input$name_input,input$demographic_input )
        )

          # Function to create ggplot
          plot_drugs <- reactive(
            plot_drugs_object(data = filtered_drugs_data(), input$breakdown_input)
          )
# Observe Event for Plots and Data------------------------------------------        
observeEvent(input$topic_input, {
  if(input$topic_input == "Life Expectancy")
  {
    # create plot
    output$distPlot <- renderPlot({
      plot()
    })
    
    # data table to show the data displayed in the life expectancy plot
    output$output_table <- renderDataTable({
      filtered_data()
    })
  }
  else 
  {
    # create plot
    output$distPlot <- renderPlot({
      plot_drugs()
    })
    
    # data table to show the data displayed in the life expectancy plot
    output$output_table <- renderDataTable({
      filtered_drugs_data()
    })
  }             
})
        

# Server script for Smoking  --------------------------------------------

# Server script for Map  ------------------------------------------------
map_area_input <- reactive(input$map_area_input)
map_topic_input <- reactive(input$map_topic_input)
map_data <- reactive(get_map_data(map_topic_input(), map_area_input()))

          #Create colour palette
          map_palette <- reactive(
            colorNumeric("magma", domain = range(map_data()$value)))

          #get the map
          output$my_map <- renderLeaflet({
            map_data() %>%
              leaflet() %>%
              #addTiles() %>% #uncomment this line to add background map
              addPolygons(
                popup = ~ str_c(name, "<br>", label, " = ", round(value, 2), sep = ""),
               # color = ~ map_palette(value)
              )
          })
          
# Download script   -----------------------------------------------------        
output$download_report <- downloadHandler(
  
  filename = "my_report.html",
  
  content = function(file) {
    src <- normalizePath('report.Rmd')
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src, 'report.Rmd', overwrite = TRUE)
    #all the info you need to pass to the output file            
    params <- list( output$distPlot, output$output_table)
    
    out <- render('report.Rmd',
                  output_format = pdf_document(),
                  params = params,
                  envir = new.env(parent = globalenv())
    )
    
    file.rename(out, file)
  }
)     
}

