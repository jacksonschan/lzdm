#' user_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_user_inputs_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(class = "user-input",
    sliderInput(
                ns("HomePrices"),
                label = "Median Home Price ($):",
                min = 0,
                max = 6000000,
                value = c(0,6000000),
                step = 100000))
  )
}
    
#' user_inputs Server Function
#'
#' @noRd 
mod_user_inputs_server <- function(input, output, session){
  ns <- session$ns
  UserInputs <- reactive({
    ins <- list(
      Homeprices <- input$HomePrices
    )
  })
}
    
## To be copied in the UI
# mod_user_inputs_ui("user_inputs_ui_1")
    
## To be copied in the server
# callModule(mod_user_inputs_server, "user_inputs_ui_1")
 
