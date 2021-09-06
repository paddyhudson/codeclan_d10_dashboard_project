#-------------------------------------------------------------------------------
#Paddy Hudson
#This script is to produce a leaflet map object with health board zones
#It will not function as standalone - it is intended for use in server.R
#-------------------------------------------------------------------------------

#First load leaflet library

library(leaflet)
library(sf)

#load data - update filepath as necessary

hb_zones <- read_sf(here("clean_data/hb_zones/hb_zones_simple.shp"))

#Create map object with polygons and name popups

hb_map <- hb_zones %>% 
  leaflet() %>% 
  #addTiles() %>% #uncomment this line to add background map
  addPolygons(popup = ~hb_name)