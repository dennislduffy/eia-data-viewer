library(tidyverse)

elec_monthly <- function(){
  
  #read in api cleanup function
  
  source("function-files/api-cleanup.R")

  #define read function 
  
  read_data <- function(series_id, fuel_type){
    
    x <- api_cleanup(series_id)
    
    x <- mutate(x, fuel_type = fuel_type)
    
    return(x)
    
  }
  
  # Read in data from EIA API at https://www.eia.gov/opendata/qb.php. API key = da4308b986243ab76873b46db95cbfa0 --------
  
  coal_data <- read_data("ELEC.GEN.COW-MN-99.M", "Coal")
  
  gas_data <- read_data("ELEC.GEN.NG-MN-99.M", "Natural Gas")
  
  nuclear_data <- read_data("ELEC.GEN.NUC-MN-99.M", "Nuclear")
  
  hydro_data <- read_data("ELEC.GEN.HYC-MN-99.M", "Hydro")
  
  wood_data <- read_data("ELEC.GEN.WWW-MN-99.M", "Wood")
  
  solar_data <- read_data("ELEC.GEN.SUN-MN-98.M", "Solar")
  
  wind_data <- read_data("ELEC.GEN.WND-MN-99.M", "Wind")
  
  biomass_data <- read_data("ELEC.GEN.WAS-MN-99.M", "Biomass")
  
  total_data <- read_data("ELEC.GEN.ALL-MN-99.M", "Total")
  
  other_data <- read_data("ELEC.GEN.OTH-MN-99.M", "Other")
  
  petro_data <- read_data("ELEC.GEN.PEL-MN-99.M", "Petroleum")
  
  
  combined_data <- hydro_data %>% # start by totaling renewables
    bind_rows(wood_data, biomass_data, wind_data, solar_data) %>%
    group_by(year) %>%
    summarise(value = sum(value)) %>%
    mutate(fuel_type = "Renewables") %>%
    bind_rows(coal_data, gas_data, nuclear_data, other_data, petro_data) %>%
    group_by(year) %>%
    mutate(percent = round(value / sum(value, na.rm = T), digits = 3)) %>%
    select(year, fuel_type, value, percent) %>%
    arrange(desc(year, percent))
  
  return(combined_data)
  
}

#create function to skip every other tick mark


monthly_gen <- function(){
  
  data_use <- elec_monthly() %>%
  mutate(month = str_sub(year, 5, 6),
    year = str_sub(year, 1, 4), 
    date = paste(year, month, sep = "-")) %>%
  filter(as.numeric(year) >= 2020, 
         fuel_type != "Other" & fuel_type != "Petroleum")
  
  xlabels <- sort(unique(data_use$date))
  xlabels[seq(2, length(xlabels), 2)] <- ""
  
  p <- data_use %>%
    ggplot() + aes(x = date, y = value, group = fuel_type, color = fuel_type) + geom_line() + 
    scale_color_manual(values = c("#000000", "#A4BCC2", "#008EAA", "#78BE21")) + 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
    ylab("Thousand Megawatt Hours") + 
    scale_x_discrete(labels = xlabels)
  
  return(p)
}




