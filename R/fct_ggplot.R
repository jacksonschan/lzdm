gg <- function(g){
## build ggplot
g <- ggplot2::ggplot(data=g, ggplot2::aes(x=month,y=home_prices,group=zip_code,text=paste("Month: ", month, '<br>Home Value: ', scales::dollar(home_prices)))) + 
  ggplot2::geom_line() + ggplot2::scale_x_date(date_breaks = "3 month", date_labels = "%m/%y") + 
  ggplot2::theme(plot.title = ggplot2::element_text(size = 13, face = "bold",  ggplot2::margin(b=1), family="Open Sans", color="gray20", hjust=-0.45), 
    text = ggplot2::element_text(size=11),
    axis.title.x = ggplot2::element_blank(),  
    axis.title.y = ggplot2::element_blank(), 
    plot.background = ggplot2::element_rect(fill = "transparent",colour = NA), 
    panel.background = ggplot2::element_rect(fill = "transparent",colour = NA)
    ) + 
  ggplot2::scale_y_continuous(breaks=scales::pretty_breaks(n = 5), labels = scales::dollar_format(scale=0.001,suffix="K")) 
  
## make interactive with plotly
plotly::ggplotly(g,tooltip = c("text")) %>% 
  plotly::layout(plot_bgcolor='transparent') %>% 
  plotly::layout(paper_bgcolor='transparent') %>% 
  plotly::config(displayModeBar = F)
}

