#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import leaflet
#' @import sf
#' @noRd
app_server <- function( input, output, session ) {
  ## List the first level callModules here
  #base map moduel
  callModule(mod_base_leaflet_server, "base_leaflet_ui_1") 
}
