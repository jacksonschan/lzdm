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
      , div(id="title-text",class="body-text",
            h1("LA County Desirability Map"),
            textOutput(ns("TitlePanel")))
    )
  )
}
    
#' title_panel Server Function
#'
#' @noRd 
mod_title_panel_server <- function(input, output, session){
  ns <- session$ns
  output$TitlePanel <- renderText({'Filter zip codes with the Inputs Panel below and click on a zip on the map to see more details about the neighborhood'})
}
    
## To be copied in the UI
# mod_title_panel_ui("title_panel_ui_1")
    
## To be copied in the server
# callModule(mod_title_panel_server, "title_panel_ui_1")