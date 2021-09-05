#--------------------------------------------------------------------------
# This script is to load and clean the Scottish Drug Misuse Database data.
#--------------------------------------------------------------------------

# cleaned by Derek H

# Information on the number of individuals presenting for assessment at specialist drug 
# treatment services in Scotland presented at council area level, broken down by age and sex.

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

# Read the data file ------------------------------------------------------

source(here("data_cleaning_wrangling/datazonelookup.R"))

sdmd_by_ca_and_demo_clean <- read_csv(here("original_data/sdmd_by_council_area_and_demographics.csv")) %>% 
  clean_names()

# Data Cleaning -----------------------------------------------------------

# joined sdmd dataset with data_zone_lookup_code dataset
# select relevant variables
# Rename variables to make them more descriptive
# Recode type column

sdmd_by_ca_and_demo_clean <- sdmd_by_ca_and_demo_clean %>% 
  left_join(data_zone_lookup_code_names, by = c("ca" = "code")) %>% 
  select(ca, name, type, financial_year, age_group, sex, number_assessed) %>% 
  rename(feature_code = ca, year = financial_year) %>% 
  mutate(type = recode(type,
                       "la" = "Local Authority",
                       "hb" = "NHS Health Board",
                       "country" = "Scotland",
                       "spc" = "Scottish Parliamentary Constituencies"
  ))

# commented out code to convert 20XX/XX to YYYY
# year = as.integer(recode(year, "2006/07" = "2006",
#                          "2007/08" = "2007",
#                          "2008/09" = "2008",
#                          "2009/10" = "2009",
#                          "2010/11" = "2010",
#                          "2011/12" = "2011",
#                          "2012/13" = "2012",
#                          "2013/14" = "2013",
#                          "2014/15" = "2014",
#                          "2015/16" = "2015",
#                          "2016/17" = "2016",
#                          "2017/18" = "2017",
#                          "2018/19" = "2019"))

# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data/folder
write_csv(sdmd_by_ca_and_demo_clean, here("clean_data/sdmd_by_ca_and_demo_clean.csv"))

# End of code -------------------------------------------------------------