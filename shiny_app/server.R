#--------------------------------------------------------------------------#
# Server file                                                              #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created Observe Event   #
#                 |             | for TabsetPanel                          #
#--------------------------------------------------------------------------#
source("helper.R")

server <- function(input, output, session) {

  # updateTabsetPanel -------------------------------------------------------
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
}