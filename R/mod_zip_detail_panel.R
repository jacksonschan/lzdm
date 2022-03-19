#' zip_detail_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_zip_detail_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      id = "zip-detail"
      , class = "out-panel" 
      , fixed=TRUE
      , uiOutput(ns("zipdetail"))
      , uiOutput(ns("rank"))
      , fluidRow(
        column(3,
              uiOutput(ns("homeprice"))
              ,uiOutput(ns("forecast"))
              ,div(class="out-text",uiOutput(ns("ziplink")))
              ),
        column(3,
              uiOutput(ns("yoy_value"))
              ,uiOutput(ns("max_zhvi"))
              )
        )
      )
    # ghost container for percise chart positioning
    , absolutePanel(id="plot-container"
                    , class= "out-panel"
                    , h2(class="out-header",id="filler", paste0("."))
                    , div(id="plot-text",uiOutput(ns("plot_title")))
                    , fixed=TRUE
                    , plotly::plotlyOutput(ns("value_plot"),width="100%", height="75%")
                    )
    )
}

#' zip_detail_panel Server Function
#'
#' @noRd 
mod_zip_detail_panel_server <- function(input, output, session,r){
  ns <- session$ns
  
  ## all data
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
  
  
  ## reactive for map zip polygon clicks
  link <- reactive({
    r$mod_base_leaflet$shape_click
    })
  
  ## pulls zip data map zip polygon clicks
  click_data <- reactive({
    l <- link()
    zip_dataset@data[zip_dataset@data$GEOID20==l,]
  })
  
  ## generating ranking statemnt
  rank_data <- reactive({
    l <- link()
    d <- dataInput()
    pop <- d@data %>%
    dplyr::select(.,GEOID20,home_prices) %>%
    dplyr::mutate(
        perc_rank = dplyr::percent_rank(home_prices)
        ,num_rank = dplyr::dense_rank(home_prices)
        ,rows = nrow(.)) 
    selected <- data.frame(
      perc_rank=1-pop[pop$GEOID20==l,c("perc_rank")], 
      num_rank=pop[pop$GEOID20==l,c("num_rank")],
      num_zips=pop[pop$GEOID20==l,c("rows")]
      )
  })
 
  ## link for zillow listings
  output$ziplink <- renderUI({
    l <- link()
    if(is.null(l))
      return()
    else{tagList(a(href=paste0("https://www.zillow.com/los-angeles-ca-",l,"/"),"Zillow listings for this Zip",target="_blank"))}
    })
  
  ## zip code + zip name
  output$zipdetail <- renderUI({
    d <- click_data()
    da <- dataInput()
    l <- link()
    if(is.null(l))
    {
      if(nrow(da@data)==0){p(id="out-header-no-selection","There are no Zips in your selected criteria")}else{p(id="out-header-no-selection","Click on a Zip to see data")}
    }
   else{h2(class="out-header",paste0(d$name," (",l,")" ))}
    })
  
  ## title for home value time series plot
  output$plot_title <- renderUI({
  l <- link()
  if(is.null(l))
    return()
  else{HTML(paste0("<b>", "5YR Home Value Trend", "<b/>"))}
  })

  ## home value 
  output$homeprice <- renderUI({
    d <- click_data()
    l <- link()
    if(is.null(l))
      return()
    else{
      tagList(
        p(id="out-bigtext-title","ZHVI (Home Values)")
        , h2(id="out-bigtext",scales::dollar(d$home_prices))
      )
      }
})
  
  ## output for forecast
  output$forecast <- renderUI({
    d <- click_data()
    l <- link()
    if(is.null(l))
     return()
    else{
     tagList(
       p(id="out-bigtext-title","ZHVF (1YR Forecast %)")
       , h2(id="out-bigtext",scales::percent(as.numeric(d$forecast)/100,accuracy=0.2))
     )
      }
})
  
  ## output for home value rank
  output$rank <- renderUI({
    d <- rank_data()
    l <- link()
    if(is.null(l))
      return()
    else{
      tagList(
      if(nrow(d)==0) {p(id="rank-text",paste("Selected zipcode is not in filtered results"))}
      else{
        tagList(
          div(id="rank-text",HTML(paste0("Zip with the ","<b>",scales::ordinal(as.numeric(d[,2])),"</b>"," lowest home values in your selection (of ",as.numeric(d[,3]), " zips)")))
        )}
      )}
    })

  ## output for home value time series plot
  output$value_plot <- plotly::renderPlotly({
    l <- link()
    if(is.null(l))
      return()
    else{
      d <- zillow_historicals[zillow_historicals$zip_code==l,]
      gg(d)
      }
    })

  ## output for year over year home value change
  output$yoy_value <- renderUI({
    d <- click_data()
    l <- link()
    if(is.null(l))
      return()
    else{
      yind <- as.numeric(r$user_inputs_server$years) + 12
      yoy <- d[,yind]
      #yoy <- unlist(d[nrow(d),c("home_prices")]/d[nrow(d)-y,c("home_prices")]-1)
      tagList(
        p(id="out-bigtext-title",paste0(r$user_inputs_server$years,"YR ZHVI Change"))
        , h2(id="out-bigtext", scales::percent(as.numeric(yoy),accuracy=0.01))
        )}
    })

  ## output for max 
  output$max_zhvi <- renderUI({
    l <- link()
    d <- click_data()
    if(is.null(l))
      return()
    else{
        tagList(
          p(id="out-bigtext-title","All-Time Highest ZHVI")
          , h2(id="out-bigtext", scales::dollar(as.numeric(d$max_price)))
          , em(id="max-smalltext",paste0("Observed on ",substr(as.character(d$max_month),1,7)))
        )
      }
    })
  
  }
## To be copied in the UI
# mod_zip_detail_panel_ui("zip_detail_panel_ui_1")
    
## To be copied in the server
# callModule(mod_zip_detail_panel_server, "zip_detail_panel_ui_1")