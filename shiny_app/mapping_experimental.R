#-------------------------------------------------------------------------------
#Paddy Hudson
#This script is to produce a leaflet map object with health board zones
#And LE data
#-------------------------------------------------------------------------------

#First load libraries

library(leaflet)
library(sf)
library(tidyverse)

#load data - update filepath as necessary

hb_zones <- read_sf(here("clean_data/hb_zones/hb_zones_simple.shp"))
le <- read_csv("clean_data/life_expectancy.csv")

#filter le data

le_filtered <- le %>% 
  filter(
    date_code == "2017-2019" &
      age == 0 &
      type == "NHS Health Board" &
      sex == "All"
  )
  
#Join spatial data to health data

map_data <- hb_zones %>% 
  left_join(le_filtered, by = c("hb_code" = "feature_code")) %>% 
  select(-name)

#Create colour palette

map_palette <- colorNumeric("plasma", domain = range(map_data$le_value))
  
#Create map object with polygons and name popups
  
hb_map <- map_data %>% 
  leaflet() %>% 
  #addTiles() %>% #uncomment this line to add background map
  addPolygons(
    popup = ~str_c(hb_name, le_value, sep = " "),
    color = ~map_palette(le_value)
  )