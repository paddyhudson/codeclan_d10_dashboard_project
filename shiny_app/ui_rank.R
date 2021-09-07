#--------------------------------------------------------------------------#
# UI for Trend Page                                                        #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             |             | Initial Version                          #
#--------------------------------------------------------------------------#

ui <- fluidPage(
  titlePanel(tags$h2("Rank")),
  
  sidebarLayout(
    
    sidebarPanel(#style = "background-color: #a6cbe3" ,
      
      #Input the Topic
      fluidRow(
        selectInput("topic_input",
                    "Select topic",
                    choices = c("Life Expectancy", "Drug abuse","Smoking")
                    
        )),
      
    )
  )
  
)