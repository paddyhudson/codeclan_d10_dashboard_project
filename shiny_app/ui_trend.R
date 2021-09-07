#--------------------------------------------------------------------------#
# UI for Trend Page                                                        #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba    | Initial Version                          #
#--------------------------------------------------------------------------#


ui <- fluidPage(
  #style = "background-color: #a6cbe3" ,
  #titlePanel(tags$h2("Trend")),
  
  sidebarLayout(
    sidebarPanel(#style = "background-color: #a6cbe3" ,
      #Input the Topic
      fluidRow(
        selectInput("topic_input",
                    "Select topic",
                    choices = c("Life Expectancy", "Drug Abuse","Smoking")

        )),
      fluidRow(
        selectInput("area_input",
                    "Select Data Zone",
                    choices = NULL
                    
        )),
      
      fluidRow(
        selectInput("name_input",
                    "Select Region:",
                    choices = NULL
        ),
      ),
      fluidRow(
        selectInput("breakdown_input",
                    "Select breakdown:",
                    choices = c("Age", "Gender")
        )
      ),
      
      fluidRow(
          checkboxGroupInput("demographic_input",
                             "Select one or more breakdown",
                             choices = NULL,
                             inline = TRUE)
          ),
       
      ),
  mainPanel(
    #Content to display the plot
    fluidRow(
             box(   
               title = tags$h3(textOutput("topic", inline = TRUE),
                               " based on ",
                               textOutput("name", inline = TRUE),
                               " for the ",
                               textOutput("breakdown", inline = TRUE),
                               " Category  "
               ),
               width = 12, status = "primary",
               plotOutput("distPlot")
               )
             
    ),
  #Content to display the table
        fluidRow(
          box(
            width = 12,
            title = tags$h3("Table"),
            dataTableOutput("output_table")
          )
        )
      
    )
  )
)
