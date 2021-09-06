#--------------------------------------------------------------------------
# This script is to load and clean the life expectancy data.
#--------------------------------------------------------------------------

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

source(here("data_cleaning_wrangling/datazonelookup.R"))

# Read the data file ------------------------------------------------------

life_expectancy_clean <- read_csv(here("original_data/life_expectancy_raw_data.csv")) %>% clean_names()

# Data Cleaning -----------------------------------------------------------

# Tidy the data and rename the colummn names
life_expectancy_clean <- life_expectancy_clean %>%
  pivot_wider(
    names_from = measurement,
    values_from = value
  ) %>%
  rename(
    le_lower_ci = "95% Lower Confidence Limit",
    le_upper_ci = "95% Upper Confidence Limit",
    le_value = "Count"
  )
# Update the age column
life_expectancy_clean <- life_expectancy_clean %>%
  mutate(age = str_replace(age, " years", ""))

# Lookup the Area name using data_zone_lookup_code
life_expectancy_clean <- life_expectancy_clean %>%
  left_join(data_zone_lookup_code_names, by = c("feature_code" = "code")) %>%
  select(feature_code, name, type, date_code, sex, age, simd_quintiles,
         urban_rural_classification, le_lower_ci, le_upper_ci, le_value)

# Rename the type
life_expectancy_clean <- life_expectancy_clean %>%
  mutate(type = recode(type,
    "la" = "Local Authority",
    "hb" = "NHS Health Board",
    "country" = "Scotland",
    "spc" = "Scottish Parliamentary Constituencies"
  ))

# Create and append the aggregated data for all sexes
life_expectancy_clean <- life_expectancy_clean %>%
  arrange(feature_code, date_code, age) %>% 
  mutate(le_value = (le_value + lag(le_value))/2,
         le_lower_ci = (le_lower_ci + lag(le_lower_ci))/2,
         le_upper_ci = (le_upper_ci + lag(le_upper_ci))/2,
  ) %>% 
  filter(sex == "Female") %>% 
  mutate(sex = "All") %>% 
  bind_rows(life_expectancy_clean)

# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data/folder
write_csv(life_expectancy_clean, here("clean_data/life_expectancy.csv"))

# End of code -------------------------------------------------------------