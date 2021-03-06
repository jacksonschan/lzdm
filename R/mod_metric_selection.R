#' metric_selection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_metric_selection_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel( #input panel
      id = "metric-panel"
      , class = "panel panel-default"
      , div(id = "metric-select" 
      , selectInput(
        ns("MetricSelect")
        , label = "Select Heatmap Metric"
        , choices = list("Current Home Values" = 1,  "% Change (vs Selected Year)" =4,  "1YR Forecast (%)" =3), 
                  selected = 1)),
      )
  )
}
    
#' metric_selection Server Function
#'
#' @noRd 
mod_metric_selection_server <- function(input, output, session, r){
  ns <- session$ns
  
 # r$metric_selection_server <- reactiveValues()
  
  observeEvent( input$MetricSelect , {
    r$metric_selection_server$MetricSelect <- input$MetricSelect
  })
}
    
## To be copied in the UI
# mod_metric_selection_ui("metric_selection_ui_1")
    
## To be copied in the server
# callModule(mod_metric_selection_server, "metric_selection_ui_1")
 
