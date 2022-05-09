library(tidyverse)
library(lubridate)

henry_data <- function(){
  
  #read in api cleanup function
  
  source("function-files/api-cleanup.R")
  
  henry_data <- api_cleanup("NG.RNGWHHD.W")
  
  henry_data <- henry_data %>%
    mutate(date = ymd(year)) %>%
    rename("dollars_per_million_btu" = "value") %>%
    select(date, dollars_per_million_btu)
  
  return(henry_data)
  
}

henry_plot <- function(){
  
  p <- henry_data() %>%
    slice(1:100) %>%
    ggplot() + aes(x = date, y = dollars_per_million_btu) + geom_line(size = 1.5) + 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
    ylab("Dollars Per Million BTU") 
  
  return(p)
  
}
