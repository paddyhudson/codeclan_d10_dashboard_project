# #--------------------------------------------------------------------------#
# # UI for Map Page                                                          #
# #--------------------------------------------------------------------------#
# # Version         | Name        | Remarks                                  #
# #--------------------------------------------------------------------------#
# # 1.0             | Paddy       | Initial Version                          #
# #--------------------------------------------------------------------------#

library (shinyWidgets)

ui <- fluidPage(
  #style = "background-color: #a6cbe3" ,
  #titlePanel(tags$h2("Map")),
  
  sidebarLayout(
    sidebarPanel(width = 3,#style = "background-color: #a6cbe3" ,
      #Input the Topic
      fluidRow(
        selectInput("map_topic_input",
                    "Select topic",
                    choices = c("Life Expectancy", "Drug Abuse","Smoking")
                    
        )),
      fluidRow(
        selectInput("map_area_input",
                    "Select Data Zone",
                    choices = c("NHS Health Board", "Local Authority")
                    
        )),
      fluidRow(
        selectInput("map_breakdown_input",
                    "Select breakdown:",
                    choices = c("All", "Age", "Gender")
        )
      ),
      fluidRow(tags$br()),
      fluidRow(tags$br())
    ),
    mainPanel(width = 9,
      #Content to display the map
      fluidRow(
        leafletOutput("my_map")
      ),
      #Content to display the table
      fluidRow(style = "padding-top: 2%",
        dataTableOutput("map_table")
      )
      
    )
  )
)
