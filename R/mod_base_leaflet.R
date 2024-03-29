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
    yind <- 12 + as.numeric(r$user_inputs_server$years)
    zip_dataset$yoy <- zip_dataset[[yind]]*100
    zip_dataset[
      zip_dataset@data$home_prices >= r$user_inputs_server$HomePrices[1] 
      & zip_dataset@data$home_prices <= r$user_inputs_server$HomePrices[2]
      & zip_dataset@data$forecast >= r$user_inputs_server$forecast[1]#/100
      & zip_dataset@data$forecast <= r$user_inputs_server$forecast[2]#/100
      & zip_dataset@data$yoy >= r$user_inputs_server$YoY[1]#/100
      & zip_dataset@data$yoy <= r$user_inputs_server$YoY[2]#/100
      ,]
  })
  
  
  #print(r$user_inputs_server$YoY[1])

  
## heatmap color palette selector (based on metric selected)
  colorpal <- 
    reactive({
      d <- dataInput()
      metric <- as.numeric(r$metric_selection_server$MetricSelect) 
      metric_data <- metric + 9
      metric_palette <- c("Purples", "","Blues","Greens")
      
      #check for negative values in metric data
      negative <- sum(d@data[,metric_data]<0)
      positive <- sum(d@data[,metric_data]>=0)
   
      #defining divergent color ramp
      negcol <- if(metric==4){c("#de2d26", "#fc9272")}else if(metric==3){c("#e6550d", "#fee6ce")}else{"purple"}
      poscol <- if(metric==4){c("white","#edf8e9","#bae4b3","#74c476","#31a354","#006d2c","#006d2c")}else if(metric==3){c("white","#bdd7e7","#6baed6", "#3182bd","#08519c","#08519c")}else{"purple"} 
      
      # Make vector of colors for values below threshold
      rc1 = grDevices::colorRampPalette(colors = negcol, space="Lab")(if(negative<1){1}else{negative})  
      # Make vector of colors for values above thresholds
      rc2 = grDevices::colorRampPalette(colors = poscol, space="Lab")(if(positive>0){positive}else{1})
      
      #color ramp
      rampcols = if(negative==0){metric_palette[metric]}else{c(rc1, rc2)}
      colorNumeric(if(metric==1 || length(d)==0){metric_palette[metric]}else{rampcols},
                   domain = d@data[,metric_data])

      
    })


## zip labels for heatmap hover 
  labels <- reactive({ 
    d <- dataInput() 
    paste0(
      "<b>",
      d@data$name,
      "<br/>",
      "Zip Code: </b>",
      d@data$GEOID20, 
      "<br/>",
      "<b>Home Values: </b>",
      scales::dollar(d@data$home_prices),
      "<br/>",
      "<b> ",
      as.character(r$user_inputs_server$years),
      "YR Value Change: </b>",
      scales::percent(d$yoy/100, accuracy=0.1),
      "<br/>",
      "<b>1YR Forecast (%): </b>",
      scales::percent(d$forecast/100, accuracy=0.1),
      "<br/>"
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
    metric <- as.numeric(r$metric_selection_server$MetricSelect) #place holder for v1 (one available metric)
    metric_data <- metric + 9
    leafletProxy("generateMap", data = d) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(d@data[,metric_data]), 
                  layerId = ~GEOID20,
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
    metric <- as.numeric(r$metric_selection_server$MetricSelect)  #place holder for v1 (one available metric)
    metric_data <- metric + 9
    metric_palette <- c("Home Prices", "","1YR Forecast", paste0(r$user_inputs_server$years,"YR % Change"))
    leafletProxy("generateMap", data = d) %>%
    clearControls() %>%
      
    addLegend(pal = pal, 
                values = d@data[,metric_data], 
                opacity = 0.8, 
              labFormat = if(metric_palette[metric]=="Home Prices"){labelFormat(prefix = "$")}else{labelFormat(suffix = "%")},
                bins = 8,
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
    d1 <- d[as.numeric(d@data$GEOID20)==as.numeric(r$mod_base_leaflet$shape_click),]
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
 