#--------------------------------------------------------------------------
# This script is to load and clean the Scottish Drug Misuse Database data.
#--------------------------------------------------------------------------

# Information on the number of individuals presenting for assessment at specialist drug 
# treatment services in Scotland presented at council area level, broken down by age and sex.

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

# Read the data file ------------------------------------------------------

sdmd_by_ca_and_demo_clean <- read_csv(here("original_data/sdmd_by_council_area_and_demographics.csv")) %>% 
  clean_names()

# Data Cleaning -----------------------------------------------------------

# select relevant variables
# Rename variables to make them more descriptive
# council_area variable recoded from 9 digit area code to council area name
# year recoded from 20XX/XX format to YYYY and type changed to integer

sdmd_by_ca_and_demo_clean <- sdmd_by_ca_and_demo_clean %>% 
  select(id, financial_year, ca, age_group, sex, number_assessed, percent_assessed) %>% 
  rename(year = financial_year, council_area = ca) %>% 
  mutate(council_area = recode(council_area, "S92000003" = "Scotland",
                               "S12000033" = "Aberdeen City",
                               "S12000034" = "Aberdeenshire",
                               "S12000041" = "Angus",
                               "S12000035" = "Argyll and Bute",
                               "S12000008" = "East Ayrshire", 
                               "S12000021" = "North Ayrshire",
                               "S12000028" = "South Ayrshire",
                               "S12000026" = "Scottish Borders",
                               "S12000005" = "Clackmannanshire",
                               "S12000006" = "Dumfries and Galloway",
                               "S12000045" = "East Dunbartonshire",
                               "S12000039" = "West Dunbartonshire",
                               "S12000042" = "Dundee City",
                               "S12000036" = "City of Edinburgh",
                               "S12000013" = "Na h-Eileanan Siar",
                               "S12000014" = "Falkirk",
                               "S12000047" = "Fife",
                               "S12000049" = "Glasgow City",
                               "S12000017" = "Highlands",
                               "S12000018" = "Inverclyde",
                               "S12000050" = "North Lanarkshire",
                               "S12000029" = "South Lanarkshire",
                               "S12000010" = "East lothian",
                               "S12000040" = "West Lothian",
                               "S12000019" = "Midlothian",
                               "S12000020" = "Moray",
                               "S12000023" = "Orkey Islands",
                               "S12000048" = "Perth and Kinross",
                               "S12000038" = "Renfrewshire",
                               "S12000011" = "East Renfrewshire",
                               "S12000027" = "Shetland Islands",
                               "S12000030" = "Stirling"),
         year = as.integer(recode(year, "2006/07" = "2006",
                                  "2007/08" = "2007",
                                  "2008/09" = "2008",
                                  "2009/10" = "2009",
                                  "2010/11" = "2010",
                                  "2011/12" = "2011",
                                  "2012/13" = "2012",
                                  "2013/14" = "2013",
                                  "2014/15" = "2014",
                                  "2015/16" = "2015",
                                  "2016/17" = "2016",
                                  "2017/18" = "2017",
                                  "2018/19" = "2019"))
  )

# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data/folder
write_csv(sdmd_by_ca_and_demo_clean, here("clean_data/sdmd_by_ca_and_demo_clean.csv"))

# End of code -------------------------------------------------------------