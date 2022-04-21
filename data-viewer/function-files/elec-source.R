# This script generates the data necessary to reproduce Figure 1-G Electricity generation within Minnesota’s borders is transforming from the 
# 2021 quadrennial report as well as 4-N Minnesota Electricity Generation by Source


elec_gen <- function(){
  
  #read in api cleanup function
  
  source("function-files/api-cleanup.R")
  
  #define read function 
  
  read_data <- function(series_id, fuel_type){
    
    x <- api_cleanup(series_id)
    
    x <- mutate(x, fuel_type = fuel_type)
    
    return(x)
    
  }
  
  # Read in data from EIA API at https://www.eia.gov/opendata/qb.php. API key = da4308b986243ab76873b46db95cbfa0 --------
  
  coal_data <- read_data("ELEC.GEN.COW-MN-99.A", "Coal")
  
  gas_data <- read_data("ELEC.GEN.NG-MN-99.A", "Gas")
  
  nuclear_data <- read_data("ELEC.GEN.NUC-MN-99.A", "Nuclear")
  
  hydro_data <- read_data("ELEC.GEN.HYC-MN-99.A", "Hydro")
  
  wood_data <- read_data("ELEC.GEN.WWW-MN-99.A", "Wood")
  
  solar_data <- read_data("ELEC.GEN.SUN-MN-98.A", "Solar")
  
  wind_data <- read_data("ELEC.GEN.WND-MN-99.A", "Wind")
  
  biomass_data <- read_data("ELEC.GEN.WAS-MN-99.A", "Biomass")
  
  total_data <- read_data("ELEC.GEN.ALL-MN-99.A", "Total")
  
  other_data <- read_data("ELEC.GEN.OTH-MN-99.A", "Other")
  
  petro_data <- read_data("ELEC.GEN.PEL-MN-99.A", "Petroleum")
  
  
  # Combine hydro,  wood,  biomass,  wind,  and solar for renewables --------
  
  combined_data <- hydro_data %>% # start by totaling renewables
    bind_rows(wood_data, biomass_data, wind_data, solar_data) %>%
    group_by(year) %>%
    summarise(value = sum(value)) %>%
    mutate(fuel_type = "Renewables") %>%
    bind_rows(coal_data, gas_data, nuclear_data, other_data, petro_data) %>%
    group_by(year) %>%
    mutate(percent = round(value / sum(value), digits = 3)) %>%
    select(year, fuel_type, value, percent) %>%
    arrange(desc(year, percent))
  
  return(combined_data)
  
}

elec_gen_bar_plot <- function(year1, year2){
  
  x <- elec_gen() %>%
    filter(year == year1 | year == year2, 
           fuel_type != "Other", 
           fuel_type != "Petroleum")
  
  p <- ggplot(x, aes(fill = fuel_type, x = year, y = percent)) +
    geom_bar(position = "fill", stat = "identity")
  
  return(p)
  
}



