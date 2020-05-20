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
    tags$head(
      tags$style(type = "text/css", "html, body {width:100%;height:100%}")
    ) , ## html styles
 #   col_6(
      leafletOutput(ns("generateMap"),width = "100%", height = "100%"
                    ))
   # )
  
}
    
#' base_leaflet Server Function
#'
#' @noRd 
mod_base_leaflet_server <- function(input, output, session){
  ns <- session$ns
  output$generateMap <- renderLeaflet({
    # generate base leaflet
    lac_zctas_data %>%
      leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      htmlwidgets::onRender("function(el, x) {L.control.zoom({ position: 'topright' }).addTo(this)}")  %>%
      # add base map
      addProviderTiles("CartoDB") %>%
      # set default map psoition
      setView(lat = 34.027497, lng = -118.411887, zoom = 9.5) %>%
      addPolygons()

  })
  
  #add Polygon layer with reactive color/sorting
  observe({
    pal <- colorpal()
    labels <- labels()
    leafletProxy("generateMap", data = lac_zctas_data) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(home_prices),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(weight = 2,
                                               color = "#666",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = labels)
  })
  
  ## observer for legend
  observe({
    pal <- colorpal()
    leafletProxy("generateMap", data = lac_zctas_data) %>%
      clearControls() %>%
      addLegend(pal = pal, 
                values = ~home_prices, 
                opacity = 0.7, 
                bins = 6,
              #  className = "info legend leaf-legend",
                title = htmltools::HTML("Home Prices <br> 
                                    by Zip Code <br>
                                    Q1 2020"),
                position = "bottomright")
  })
}
    
## To be copied in the UI
# mod_base_leaflet_ui("base_leaflet_ui_1")
    
## To be copied in the server
# callModule(mod_base_leaflet_server, "base_leaflet_ui_1")
 