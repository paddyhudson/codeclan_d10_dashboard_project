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
    background = "teal",
    fluidRow(style = "padding-left : 10% ;",
      column(
        width = 4,
        use_hover(),
        hover_action_button(style = "padding-top : 25% ;
                              padding-left : 25% ;
                              padding-right : 25% ;
                              padding-bottom :25% ;  
                              color: #ffffff;
                              background-color: #a6cbe3; 
                              border-color: #ffffff",
                     inputId = 'jumpToTrend',
                     label = tags$h1("Trend"), 
                     icon = icon("line-chart", "fa-3x"),
                     title="Explore how indicators change over Time",
                     button_animation = "bounce-in",
                     icon_animation = "icon-pulse-grow")
      ),

      column(
        width = 4,
        use_hover(),
        hover_action_button(style = "  padding-top : 25% ;
                                padding-left : 25% ;
                                padding-right : 25% ;
                                padding-bottom :25% ;   
                                color: #ffffff;
                                background-color: #e3a6a6; 
                                border-color:  #ffffff",
                     inputId = 'jumpToRank',
                     label = tags$h1("Rank"),
                     icon = icon("bar-chart-o", "fa-3x"),
                     title = "Compare the indicators using Bar Chart" ,
                     button_animation = "bounce-in",
                     icon_animation = "icon-pulse-grow")
      ),
      column(
        width = 4,
        use_hover(),
        hover_action_button(style = "padding-top : 25% ;
                        padding-left : 25% ;
                        padding-right : 25% ;
                        padding-bottom :25% ;   
                        color: #ffffff;
                        background-color: #a6e3ac; 
                        border-color:  #ffffff",
                    inputId ='jumpToMap',
                    label = tags$h1("Map"),
                    icon = icon("globe", "fa-3x"),
                    title = "Compare indicators between geographies using Map",
                    button_animation = "bounce-in",
                    icon_animation = "icon-pulse-grow")
      
      )
    )
  )
  ),

  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(tags$br())
)
