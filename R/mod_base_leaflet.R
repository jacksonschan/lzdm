#' base_leaflet UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_base_leaflet_ui <- function(id){
  ns <- NS(id)
  tagList(
 #   col_6(
      leafletOutput(ns("generateMap"),width = "100%", height = "60%"
                    ))
   # )
  
}
    
#' base_leaflet Server Function
#'
#' @noRd 
mod_base_leaflet_server <- function(input, output, session){
  ns <- session$ns
  output$generateMap <- renderLeaflet({
    # graph leaflet
    lac_zctas_data %>%
      leaflet %>% 
      # add base map
      addProviderTiles("CartoDB") %>%
      #addTiles() %>%
      addPolygons()
    # add zip codes
  })
}
    
## To be copied in the UI
# mod_base_leaflet_ui("base_leaflet_ui_1")
    
## To be copied in the server
# callModule(mod_base_leaflet_server, "base_leaflet_ui_1")
 
