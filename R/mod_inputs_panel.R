#' inputs_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_inputs_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
      absolutePanel(
        id = "in-panel"
        , class = "panel panel-default"
        , fixed=TRUE
        , h2("Inputs")
        , p(textOutput(ns("InputPanel")))
      )
  )
}
    
#' inputs_panel Server Function
#'
#' @noRd 
mod_inputs_panel_server <- function(input, output, session){
  ns <- session$ns
  output$InputPanel <- renderText({'lorem ipselum'})
}
    
## To be copied in the UI
# mod_inputs_panel_ui("inputs_panel_ui_1")
    
## To be copied in the server
# callModule(mod_inputs_panel_server, "inputs_panel_ui_1")
 
