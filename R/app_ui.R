#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import leaflet
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    #fluidPage(
     # h1("lzdm"),
    bootstrapPage(
      tags$style(type = "text/css", "html, body {width:100%;height:100%}"), 
    mod_base_leaflet_ui("base_leaflet_ui_1") #base map moduel
   # )
  )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'lzdm'
    )
    
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

