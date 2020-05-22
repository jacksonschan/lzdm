#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import leaflet
#' @import sf
#' @import htmltools
#' @noRd
app_server <- function( input, output, session ) {
  ## List the first level callModules here
  r <- reactiveValues()
  # metric selection module
  callModule(mod_metric_selection_server, "metric_selection_ui_1",r)
  #base map module
  callModule(mod_base_leaflet_server, "base_leaflet_ui_1",r) 
  #zip detail panel
  callModule(mod_zip_detail_panel_server, "zip_detail_panel_ui_1")
  #top zip panel
  callModule(mod_top_zipcodes_panel_server, "top_zipcodes_panel_ui_1")
  #input panel
  callModule(mod_inputs_panel_server, "inputs_panel_ui_1")
  
  #title panel
  #callModule(mod_title_panel_server, "title_panel_ui_1")
}
