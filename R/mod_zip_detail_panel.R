#' zip_detail_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_zip_detail_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      style = "background-color: grey"
      , top = "auto"
      , bottom = 10
      , left = 20
      , width = "48vw"
      , height = "35vh"
      , class = "panel panel-default" 
     # , fixed = TRUE
      , h2("Zip Detail")
      , textOutput(ns("ZipDetail"))
    )
  )
}
    

#' zip_detail_panel Server Function
#'
#' @noRd 
mod_zip_detail_panel_server <- function(input, output, session){
  ns <- session$ns
  output$ZipDetail <- renderText({'lorem ipselum'})
}

## To be copied in the UI
# mod_zip_detail_panel_ui("zip_detail_panel_ui_1")
    
## To be copied in the server
# callModule(mod_zip_detail_panel_server, "zip_detail_panel_ui_1")
 