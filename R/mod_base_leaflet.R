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
  
  dataInput <- reactive({
    #r$user_inputs_server$HomePrices[1] 
    filtered <- lac_zctas_data[
      lac_zctas_data@data$home_prices >= r$user_inputs_server$HomePrices[1] 
      & lac_zctas_data@data$home_prices <= r$user_inputs_server$HomePrices[2]
       # & lac_zctas_data@data$household_income >= r$user_inputs_server$HouseholdIncome[1]
       # & lac_zctas_data@data$household_income <= r$user_inputs_server$HouseholdIncome[2]
       # & lac_zctas_data@data$education <= r$user_inputs_server$Education[1]
       # & lac_zctas_data@data$safety <= r$user_inputs_server$Crime[1],
      , ]
    lac_zctas_data <- filtered
    lac_zctas_data
  })
  
  colorpal <- 
    reactive({
      d <- dataInput()
    #  metric <- as.numeric(r$metric_selection_server$MetricSelect)
      metric <- 1
      metric_data <- metric + 6
      metric_palette <- c("Greens" , "Purples", "Reds", "Blues")
      colorNumeric( metric_palette[metric], #colour palatte
                   #palette = "Greens",
                   domain = d@data[,metric_data
                                   ]) #data for bins
    })
  
  
  labels <- reactive({ 
    d <- dataInput() 
    #metric <- as.numeric(r$metric_selection_server$MetricSelect)
    metric <- 1
    metric_data <- metric + 6
    metric_palette <- c("Home Prices: ", "Household Income: ", "Education: ", "Safety: ")
    paste0(
      d@data$name,
      "<br/>",
      "Zip Code: ",
      d@data$GEOID10, "<br/>",
      metric_palette[metric],
      if(metric %in% c(1,4)){scales::dollar(d@data[,metric_data])}
      else if(metric == 2){scales::number(d@data[,metric_data],prefix="#")}
      else if(metric == 3){scales::number(d@data[,metric_data], suffix="%")}
    ) %>%
      lapply(htmltools::HTML) })
  
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
    d <- dataInput()
    pal <- colorpal()
    labels <- labels()
    metric <- 1#as.numeric(r$metric_selection_server$MetricSelect)
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
    metric <- 1#as.numeric(r$metric_selection_server$MetricSelect)
    metric_data <- metric + 6
    metric_palette <- c("Home Prices", "Household Income", "Education", "Safety")
    leafletProxy("generateMap", data = d) %>%
      clearControls() %>%
      addLegend(pal = pal, 
                values = d@data[,metric_data], 
                opacity = 0.7, 
                bins = 7,
              #  className = "info legend leaf-legend",
                title = metric_palette[metric],
                position = "bottomright")
  })
  
  observeEvent(input$generateMap_shape_click,
               {r$mod_base_leaflet$shape_click <- input$generateMap_shape_click$id
               }, ignoreNULL = FALSE)


observe({
  d <- dataInput()
  d1 <- d[d@data$GEOID10==r$mod_base_leaflet$shape_click,]
  leafletProxy("generateMap", data = d1) %>%
    clearGroup("highlight") %>%
    addPolygons(#layerId = ~GEOID10,
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
 # }
})

}

## observer for legend


    
## To be copied in the UI
# mod_base_leaflet_ui("base_leaflet_ui_1")
    
## To be copied in the server
# callModule(mod_base_leaflet_server, "base_leaflet_ui_1")
 