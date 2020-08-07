#' base_leaflet UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 

options(digits=9)

mod_base_leaflet_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$head(
      tags$style(type = "text/css", "html, body {width:100%;height:100%}")), 
      leafletOutput(ns("generateMap"),width = "100%", height = "100%")
    )
  
}

#' base_leaflet Server Function
#'
#' @noRd 
mod_base_leaflet_server <- function(input, output, session, r){
  ns <- session$ns

## import data file  
  dataInput <- reactive({
    zip_dataset[
      zip_dataset@data$home_prices >= r$user_inputs_server$HomePrices[1] 
      & zip_dataset@data$home_prices <= r$user_inputs_server$HomePrices[2]
      , ]
  })
  
## heatmap color palette selector (based on metric selected)
  colorpal <- 
    reactive({
      d <- dataInput()
      metric <- 1 #place holder for v1 (one available metric)
      metric_data <- metric + 6
      metric_palette <- c("Blues" , "Purples", "Reds", "Blues")
      colorNumeric(metric_palette[metric],
                   domain = d@data[,metric_data]) #data for bins
                    
    })
  
## zip labels for heatmap hover 
  labels <- reactive({ 
    d <- dataInput() 
    metric <- 1 #place holder for v1 (one available metric)
    metric_data <- metric + 6
    metric_palette <- c("Home Prices: ", "Household Income: ", "Education: ", "Safety: ")
    paste0(
      d@data$name,
      "<br/>",
      "Zip Code: ",
      d@data$GEOID10, "<br/>",
      if(metric_palette[metric]=="Home Prices: "){"Home Values: "}else{metric_palette[metric]},
      if(metric %in% c(1,4)){scales::dollar(d@data[,metric_data])}
      else if(metric == 2){scales::number(d@data[,metric_data],prefix="#")}
      else if(metric == 3){scales::number(d@data[,metric_data], suffix="%")},
      "<br/>",
      "Rent: ",
      stringr::str_replace_na(as.character(scales::dollar(d$market_rent)),"No Data")
    ) %>%
      lapply(htmltools::HTML)})
  
  output$generateMap <- renderLeaflet({
    # generate base leaflet
    zip_dataset %>%
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
    d <- dataInput()
    pal <- colorpal()
    labels <- labels()
    metric <- 1 #place holder for v1 (one available metric)
    metric_data <- metric + 6
    leafletProxy("generateMap", data = d) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(d@data[,metric_data]), 
                  layerId = ~GEOID10,
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(weight = 2,
                                               color = "#666",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = FALSE),
                  label = labels)
  })
  
  ## observer for legend
  observe({
    d <- dataInput() 
    pal <- colorpal()
    metric <- 1 #place holder for v1 (one available metric)
    metric_data <- metric + 6
    metric_palette <- c("Home Prices", "Household Income", "Education", "Safety")
    leafletProxy("generateMap", data = d) %>%
    clearControls() %>%
    addLegend(pal = pal, 
                values = d@data[,metric_data], 
                opacity = 0.7, 
                bins = 7,
                title = if(metric_palette[metric]=="Home Prices"){"Home Values"}else{metric_palette[metric]},
                position = "bottomright")
  })
  
  ## observe event for zip polygon clicks
  observeEvent(input$generateMap_shape_click,
               {r$mod_base_leaflet$shape_click <- input$generateMap_shape_click$id
               }, ignoreNULL = FALSE)

  ## observer for zip polygon clicks to higlight clicked polygons
  observe({
    d <- dataInput()
    d1 <- d[d@data$GEOID10==r$mod_base_leaflet$shape_click,]
    leafletProxy("generateMap", data = d1) %>%
    clearGroup("highlight") %>%
    addPolygons(
                group = "highlight",
                fillColor = "black",
                weight = 5,
                opacity = 1,
                color = "black",
                dashArray = "3",
                highlight = highlightOptions(weight = 2,
                                             color = "#666",
                                             dashArray = "",
                                             fillOpacity = 1,
                                             bringToFront = TRUE)
    )
})

}

    
## To be copied in the UI
# mod_base_leaflet_ui("base_leaflet_ui_1")
    
## To be copied in the server
# callModule(mod_base_leaflet_server, "base_leaflet_ui_1")
 