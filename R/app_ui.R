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

      mod_base_leaflet_ui("base_leaflet_ui_1"), #base map moduel
      
      mod_inputs_panel_ui("inputs_panel_ui_1"), #input panel
      
      mod_zip_detail_panel_ui("zip_detail_panel_ui_1"), #zip detail panel
      
      mod_top_zipcodes_panel_ui("top_zipcodes_panel_ui_1"), #top zip panel
      
      mod_metric_selection_ui("metric_selection_ui_1") # metric select panel
   # )
    #  mod_title_panel_ui("title_panel_ui_1") #title panel
  ))
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
    tags$link(rel="stylesheet", type="text/css", href="www/out_panels.css"),  tags$link(
      rel = "stylesheet", 
      href="http://fonts.googleapis.com/css?family=Open+Sans"
    ),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'lzdm'
    )
    
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

