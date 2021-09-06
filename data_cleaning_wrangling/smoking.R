#--------------------------------------------------------------------------
# This script is to load and clean the life expectancy data.
# Cleaned by John Paul
#--------------------------------------------------------------------------

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

source(here("data_cleaning_wrangling/datazonelookup.R"))

# Read the data file ------------------------------------------------------
smoking<- read_csv(here("original_data/smoking_core_questions_raw_data.csv")) %>% clean_names()


# Data Cleaning -----------------------------------------------------------

# Tidy the data and rename some column names
smoking_clean <- smoking %>%
  pivot_wider(
    names_from = measurement,
    values_from = value
  ) %>%
  rename(
    date = "date_code",
    smokes = "currently_smokes_cigarettes",
    sex = "gender",
    long_term_condition = "limiting_long_term_physical_or_mental_health_condition",
    smok_lower_ci = "95% Lower Confidence Limit, Percent",
    smok_upper_ci = "95% Upper Confidence Limit, Percent",
    smok_percent = "Percent"
  )

# Tidy the age column 
smoking_clean <- smoking_clean %>%
  mutate(age = str_replace(age, " years", ""))

# Lookup the Area name using data_zone_lookup_code
smoking_clean <- smoking_clean %>%
  left_join(data_zone_lookup_code_names, by = c("feature_code" = "code")) %>%
  select(feature_code, name, type, date, smokes, household_type, sex,
         long_term_condition, age, smok_lower_ci, smok_upper_ci, smok_percent)

# Rename the authority type
smoking_clean <- smoking_clean %>%
  mutate(type = recode(type,
                       "la" = "Local Authority",
                       "hb" = "NHS Health Board",
                       "country" = "Scotland",
                       "spc" = "Scottish Parliamentary Constituencies"
  )) 

# Change 3 columns from List to Char type,so csv can be written
smoking_clean <- smoking_clean %>% 
  mutate(across(everything(), as.character))


# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data folder

write_csv(smoking_clean, here("clean_data/smoking.csv"))

# End of code -------------------------------------------------------------
