#--------------------------------------------------------------------------#
# UI script                                                                #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version                          #
#--------------------------------------------------------------------------#


ui <- fluidPage(
  
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow("<< Overview>>"),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(
  box(
    width = 12,
    fluidRow(
      column(
        width = 4,
        actionButton(style = "padding-top : 25% ;
                              padding-left : 25% ;
                              padding-right : 25% ;
                              padding-bottom :25% ;  
                              color: #ffffff;
                              background-color: #a6cbe3; 
                              border-color: #ffffff",
                     inputId = 'jumpToTrend',
                     label = tags$h3("Trend"), 
                     icon = icon("graph-up",lib = "glyphicon")
        
        )
      ),
      column(
        width = 4,
        actionButton(style = "  padding-top : 25% ;
                                padding-left : 25% ;
                                padding-right : 25% ;
                                padding-bottom :25% ;   
                                color: #ffffff;
                                background-color: #e3a6a6; 
                                border-color:  #ffffff ;",
                     inputId = 'jumpToRank',
                     label = tags$h3("Rank"),
                     icon = icon("bar-chart-o", "fa-3x")
               )
      ),
      column(
        width = 4,
        actionButton(style = "padding-top : 25% ;
                        padding-left : 25% ;
                        padding-right : 25% ;
                        padding-bottom :25% ;   
                        color: #ffffff;
                        background-color: #a6e3ac; 
                        border-color:  #ffffff",
                    inputId ='jumpToMap',
                    label = tags$h3("Map"),
                    icon = icon("globe", "fa-3x")
      )
      )
    )
  )
  ),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br())
)
