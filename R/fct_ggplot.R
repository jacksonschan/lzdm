gg <- function(g){
  
library(ggplot2)
library(plotly)
## build ggplot
g <- ggplot2::ggplot(data=g, aes(x=month,y=home_prices,group=zip_code,text=paste("Month: ", month, '<br>Home Value: ', scales::dollar(home_prices)))) + 
  geom_line() + scale_x_date(date_breaks = "3 month", date_labels = "%m/%y") + 
  theme(plot.title = element_text(size = 13, face = "bold",  margin(b=1), family="Open Sans", color="gray20", hjust=-0.45), 
    text = element_text(size=11),
    axis.title.x = element_blank(),  
    axis.title.y = element_blank(), 
    plot.background = element_rect(fill = "transparent",colour = NA), 
    panel.background = element_rect(fill = "transparent",colour = NA)
    ) + 
  scale_y_continuous(breaks=scales::pretty_breaks(n = 5), labels = scales::dollar_format(scale=0.001,suffix="K")) 
  
## make interactive with plotly
plotly::ggplotly(g,tooltip = c("text")) %>% 
  layout(plot_bgcolor='transparent') %>% 
  layout(paper_bgcolor='transparent') %>% 
  config(displayModeBar = F)
}

