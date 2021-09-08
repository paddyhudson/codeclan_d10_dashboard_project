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
  titlePanel(tags$h2("Map")),

  sidebarLayout(
    sidebarPanel(#style = "background-color: #a6cbe3" ,
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
    mainPanel(
      #Content to display the map
      fluidRow(
        box(
          title = tags$h3(textOutput("map_input_topic", inline = TRUE),
                          " based on ",
                          textOutput("map_input_name", inline = TRUE),
                          " for the ",
                          textOutput("map_input_breakdown", inline = TRUE),
                          " Category  "
          ),
          width = 12, status = "primary",
          leafletOutput("my_map")
        )

      ),

      #Content to display the table
      fluidRow(
        box(
          width = 12,
          title = tags$h3("Table"),
          dataTableOutput("map_output_table")
        )
      )

    )
  )
)