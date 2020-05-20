#' inputs_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_inputs_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
      absolutePanel( #input panel
        id = "controls"
        , class = "panel panel-default"
        , h2(id="input-header", "Inputs")
        , tags$div(id='demo',
                   class="collapse in"
                   , div(
                         div(id="in-text",textOutput(ns("InputPanel")))
                         , mod_user_inputs_ui(ns("HomePrices"))
                        )
                   
                   )
        ### ZHVI price slider

      ),
      absolutePanel( #adding seperate minimize button
        id = "minimize-button"
        , class = "panel panel-default"
        , HTML('<button 
                    data-toggle="collapse" 
                    data-target="#demo">Collapse/Expand
                    </button>')
      )
      
  )
}
    
#' inputs_panel Server Function
#'
#' @noRd 
mod_inputs_panel_server <- function(input, output, session){
  ns <- session$ns
  output$InputPanel <- renderText({'Zorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidi'})
  callModule(mod_user_inputs_server, "user_inputs_ui_1")
}

    
## To be copied in the UI
# mod_inputs_panel_ui("inputs_panel_ui_1")
    
## To be copied in the server
# callModule(mod_inputs_panel_server, "inputs_panel_ui_1")
 