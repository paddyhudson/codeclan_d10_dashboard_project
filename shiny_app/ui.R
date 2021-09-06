
ui <- dashboardPage(skin = "yellow",
  dashboardHeader( disable = TRUE ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    
    # css ---------------------------------------------------------------------
    
    tags$head(
      tags$style(HTML(" @import url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@1,600&display=swap');
                                          body {
                                          }
                                          h1 {
                                            font-family: 'Crimson Text', serif;
                                            color:639fbf;
                                          }
                                          h2 {
                                            font-family: 'Acme', cursive;
                                            color:#639fbf;
                                          }
                                          h3 {
                                            font-family: 'Acme', cursive;
                                            color:#000000;
                                          }
                                          .shiny-input-container {
                                            color: #474747;
                                          }
                                        .tabbable > .nav > li > a 
                                        {color:#000000}
                                        .tabbable > .nav > li[class=active] > a 
                                        {background-color: #639fbf; color:white}
                                        .main-header .logo {
                                                            font-family: 'Georgia', Times, 'Times New Roman', serif;
                                                            font-weight: bold;
                                                            font-size: 24px;
                                        }
                                        "
                      
      )
      )
    ),
    

# Main Page ---------------------------------------------------------------

    
  box(title = tags$h1("Public Health Priorities for Scotland"), 
      width = 12,
      tabsetPanel(id = "inTabset",
                 tabPanel(title  = tags$h3("Home"), value = "home_panel",
                               source("ui_home.R", local = TRUE)$value
                           ),
                 tabPanel(title = tags$h3("Trend", icon = icon("bar-chart-o")),
                          value = "trend_panel", 
                          source("ui_trend.R", local = TRUE)$value),
                 tabPanel(title = tags$h3("Rank"), value = "rank_panel" ,
                          source("ui_rank.R", local = TRUE)$value),
                 tabPanel(title = tags$h3("Map"),value = "map_panel",  
                          source("ui_map.R", local = TRUE)$value)
               )
   
  )
)
)

