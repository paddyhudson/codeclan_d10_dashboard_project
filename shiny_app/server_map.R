get_map_data <- function(topic_input, area_input)
{  
  
  #choose spatial data
  
  spatial_data <- switch(area_input,
                         "NHS Health Board" = hb_zones,
                         "Local Authority" = la_zones)
  
  #choose topic data
  topic_data <- switch(
    topic_input,
    "Life Expectancy" = life_expectancy_clean,
    "Drug Abuse" = sdmd_combined_plus_zones,
    "Smoking" = smoking_clean
  ) %>%
    filter(type == area_input,
           sex == "All",
           age == switch(
             topic_input,
             "Life Expectancy" = 0,
             "Drug Abuse" = "All",
             "Smoking" = "All"
           )) %>%
    select(-name)
  
  if (topic_input == "Life Expectancy") {
    topic_data <- topic_data %>%
      filter(date_code == "2017-2019") %>%
      rename(value = le_value) %>%
      mutate(label = "Life Expectancy")
  } else if (topic_input == "Drug Abuse") {
    topic_data <- topic_data %>%
      filter(year == "2017/18") %>%
      rename(value = number_assessed) %>%
      mutate(label = "Number Assessed")
  } else if (topic_input == "Smoking") {
    topic_data <- topic_data %>%
      filter(
        date_code == 2019,
        long_term_condition == "All",
        type_of_tenure == "All",
        household_type == "All",
        smokes == "Yes"
      ) %>%
      rename(value = sm_percent) %>%
      mutate(label = "Percentage of Population who are Smokers")
  }
  
  #join to get map data
  map_data <- spatial_data %>%
    left_join(topic_data, by = c("code" = "feature_code"))
  
  #Create colour palette
  
  if (topic_input == "Life Expectancy"){
    map_palette <- colorNumeric("viridis", domain = range(map_data$value), reverse = TRUE)
    map_data <- map_data %>% arrange(desc(value))
  } else {
    map_palette <- colorNumeric("viridis", domain = range(map_data$value))
    map_data <- map_data %>% arrange(value)
  }
  
  map_data <- map_data %>% 
    mutate(colour = map_palette(value))
  
  return(map_data)
}