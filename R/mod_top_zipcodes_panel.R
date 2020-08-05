#' top_zipcodes_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_top_zipcodes_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      id = "top-zips"
      , class = "out-panel" 
      , fixed= TRUE
      , h5(id="zip-table-title","Filtered Zips Table")
      , div(id= "data-table",DT::dataTableOutput(ns("ziptable"), width="95%"))
      )
    )
}
    

#' top_zipcodes_panel Server Function
#'
#' @noRd 
mod_top_zipcodes_panel_server <- function(input, output, session,r){
  ns <- session$ns
  
  # import and transform zip data for table
  data <- reactive({
    d <- zip_dataset@data %>%
    # filter data per selected home value params
    dplyr::filter(., home_prices >= r$user_inputs_server$HomePrices[1], home_prices <= r$user_inputs_server$HomePrices[2]) %>%
    # shorten zip names thta are too long 
    dplyr::mutate(.,name=unlist(lapply(name,function(x)if(stringr::str_length(gsub("/.*$","",x)) < 20){gsub("/.*$", "",x)} else{stringr::str_c(substr(gsub("/.*$", "",x),1,17),"...")}))
                  ,market_rent = stringr::str_replace_na(as.character(scales::dollar(market_rent)),"No Data")
) %>%
    dplyr::select(.,GEOID10,name,home_prices,market_rent) 
  })

  # build zip table
  output$ziptable <- DT::renderDataTable({
    d <- data()
    DT::datatable(d, options = list(
      lengthMenu= 10
      , pageLength= 10
      , lengthChange = FALSE
      , scrollY = '80%'
      , pageLength = FALSE
      , columnDefs = list(list(className = 'dt-left', targets = 0:3))
      , order = list(2, 'asc')
      ) 
      , colnames = c('Zip', 'Name', 'Home Value', 'Rent')
      , rownames = FALSE
      , selection = 'single'
      ) %>% 
      DT::formatCurrency(columns=c('home_prices'),digits = 0)
  })
  
  # listener for zip row clicks (enables detail/map highlight changes)
  observeEvent(input$ziptable_rows_selected,
               {
                d <- data()
                if(is.null(input$ziptable_rows_selected))
                  return()
                else{
                 r$mod_base_leaflet$shape_click <- d[input$ziptable_rows_selected,c("GEOID10")]}
               }, ignoreNULL = FALSE)  
  
}
    
## To be copied in the UI
# mod_top_zipcodes_panel_ui("top_zipcodes_panel_ui_1")
    
## To be copied in the server
# callModule(mod_top_zipcodes_panel_server, "top_zipcodes_panel_ui_1")