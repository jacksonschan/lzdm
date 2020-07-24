#' title_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_title_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      id = "title-panel"
      , class = "panel panel-default"
      , fixed=TRUE
      , h1("LA County Desirability Map")
      , p(id="title-body-text", textOutput(ns("TitlePanel",)))
    )
  )
}
    
#' title_panel Server Function
#'
#' @noRd 
mod_title_panel_server <- function(input, output, session){
  ns <- session$ns
  output$TitlePanel <- renderText({'Adjust the filters below to your desired values and click "Submit" to update the map:'})
}
    
## To be copied in the UI
# mod_title_panel_ui("title_panel_ui_1")
    
## To be copied in the server
# callModule(mod_title_panel_server, "title_panel_ui_1")