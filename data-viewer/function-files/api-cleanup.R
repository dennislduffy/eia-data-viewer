#This function cleans up raw data from EIA API requests

library(tidyverse)
library(jsonlite)
library(httr)

api_key <- "da4308b986243ab76873b46db95cbfa0"

api_cleanup <- function(series_id){
  
  data_use <- GET(paste0("https://api.eia.gov/series/?api_key=", api_key, "&series_id=", series_id))
  
  data_use <- fromJSON(rawToChar(data_use$content)) #parse JSON
  
  data_location <- match("data", names(data_use$series)) #find location of data
  
  data_use <- tibble(data.frame(data_use$series[[data_location]][1])) #pull table and format as tibble 
  
  colnames(data_use) <- c("year", "value")
  
  data_use <- mutate(data_use, value = as.numeric(value))
  
  return(data_use)
  
}