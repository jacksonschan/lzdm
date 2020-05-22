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
mod_base_leaflet_server <- function(input, output, session, r){
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
  
  colorpal <- 
    reactive({
      metric <- as.numeric(r$metric_selection_server$MetricSelect)
      metric_data <- metric + 6
      metric_palette <- c("Greens" , "Purples", "Blues", "Reds")
      colorNumeric(palette = metric_palette[metric], #colour palatte
                   domain = lac_zctas_data@data[metric_data]) #data for bins
    })
  
  
  labels <- reactive({ 
    metric <- as.numeric(r$metric_selection_server$MetricSelect)
    metric_data <- metric + 6
    metric_palette <- c("Home Prices: " , "Household Income: ", "Education: ", "Safety: ")
    paste0(
      "Zip Code: ",
      lac_zctas_data@data$GEOID10, "<br/>",
      metric_palette[metric],
      if(metric %in% c(1,2)){scales::dollar(lac_zctas_data@data[[metric_data]])}
      else{scales::percent(lac_zctas_data@data[[metric_data]])}
      ) %>%
      lapply(htmltools::HTML) })
  
  #add Polygon layer with reactive color/sorting
  observe({
    pal <- colorpal()
    labels <- labels()
    metric <- as.numeric(r$metric_selection_server$MetricSelect)
    metric_data <- metric + 6
    leafletProxy("generateMap", data = lac_zctas_data) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(lac_zctas_data@data[[metric_data]]),
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
    metric <- as.numeric(r$metric_selection_server$MetricSelect)
    metric_data <- metric + 6
    metric_palette <- c("Home Prices", "Household Income", "Education", "Safety")
    leafletProxy("generateMap", data = lac_zctas_data) %>%
      clearControls() %>%
      addLegend(pal = pal, 
                values = lac_zctas_data@data[[metric_data]], 
                opacity = 0.7, 
                bins = 6,
              #  className = "info legend leaf-legend",
                title = metric_palette[metric],
                position = "bottomright")
  })
}
    
## To be copied in the UI
# mod_base_leaflet_ui("base_leaflet_ui_1")
    
## To be copied in the server
# callModule(mod_base_leaflet_server, "base_leaflet_ui_1")
 