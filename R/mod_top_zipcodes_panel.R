#' top_zipcodes_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_top_zipcodes_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      id = "top-zips"
      , class = "out-panel" 
      , fixed=TRUE
      , h2("Top 5 Zips")
      , textOutput(ns("TopZips"))
    )
  )
}
    

#' top_zipcodes_panel Server Function
#'
#' @noRd 
mod_top_zipcodes_panel_server <- function(input, output, session){
  ns <- session$ns
  output$TopZips <- renderText({'lorem ipselum'})
}
    
## To be copied in the UI
# mod_top_zipcodes_panel_ui("top_zipcodes_panel_ui_1")
    
## To be copied in the server
# callModule(mod_top_zipcodes_panel_server, "top_zipcodes_panel_ui_1")
 