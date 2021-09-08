#--------------------------------------------------------------------------#
# UI for Rank Page                                                         #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             |Prathiba     | Initial Version                          #
# 1.1             |Derek        | Updated Code
#--------------------------------------------------------------------------#

ui <- fluidPage(
  #style = "background-color: #a6cbe3" ,
  titlePanel(tags$h2("Rank")),
  
  sidebarLayout(
    sidebarPanel(#style = "background-color: #a6cbe3" ,
      #Input the Topic
      fluidRow(
        selectInput("rank_topic_input",
                    "Select topic",
                    choices = c("Life Expectancy", "Drug Abuse", "Smoking")
                    
        )),
      fluidRow(
        selectInput("rank_area_input",
                    "Select Data Zone",
                    choices = c("Local Authority", "NHS Health Board")
                    
        )),
      
      fluidRow(
        selectInput("sex_input",
                    "Select Sex",
                    choices = c("All", "Male", "Female")
        )
      ),
      
      fluidRow(
        selectInput("select_input",
                    "Selection",
                    choices = c("Top 5", "Bottom 5")
        )
      )
      
      # dropdown(
      #   label = "Select one or more breakdown", status = "default",
      #   checkboxGroupInput("rank_demographic_input",
      #                      "",
      #                      choices = NULL,
      #                      inline = TRUE)
      # )
    ),
    mainPanel(
      #Content to display the plot
      fluidRow(
        box(   
          title = tags$h3(textOutput("rank_topic", inline = TRUE),
                          " based on ",
                          textOutput("rank_name", inline = TRUE),
                          " for the ",
                          textOutput("rank_breakdown", inline = TRUE),
                          " Category  "
          ),
          width = 12, status = "primary",
          plotOutput("rank_distPlot")
        )
        
      ),
      #Content to display the table
      fluidRow(
        box(
          width = 12,
          title = tags$h3("Table"),
          tableOutput("rank_output_table")
        )
      )
      
    )
  )
)
