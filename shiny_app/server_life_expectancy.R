#--------------------------------------------------------------------------#
# Server file to select the data and plots required for life expectancy    #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | Derek       | Updated the contents of the function     #
#--------------------------------------------------------------------------#

# Function to select the data based on user choice

select_life_data <- function( user_choice, input_name, input_demographic) {
  
    if(user_choice == "Gender")
    {
      life_expectancy_clean %>%
        group_by(name,date_code, sex) %>% 
        summarise(mean_le = mean(le_value),
                  mean_le_lower_ci = mean(le_lower_ci),
                  mean_le_upper_ci = mean(le_upper_ci),
                  .groups = "drop"
        ) %>% 
        filter(name == input_name,
               sex %in% input_demographic,
        )
        
    }
    else{
      life_expectancy_clean %>%
        filter(sex != "All",
               sex %in% input_demographic,
               urban_rural_classification == "All",
               simd_quintiles != "All") %>%
        arrange(date_code)
    }
}

# Function to plot the data based on selected data from user choice

plot_life_object <- function(data, user_choice) {
  
  if(user_choice == "Gender"){
    
    data %>% 
      ggplot() +
      aes(x = date_code, y = mean_le, group = sex, colour = sex) +
      geom_line() +
      geom_point() +
      geom_ribbon(aes(ymax = mean_le_lower_ci, ymin = mean_le_lower_ci), alpha = 0.8, colour = NA) +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "\n\nYear",
        y = "Life Expectancy (years)\n",
        colour = "Sex"
      )+
      color_theme()
  }
  else {
    
    data %>% 
    ggplot() +
      aes(x = date_code, y = le_value, group = simd_quintiles, colour = simd_quintiles) +
      geom_line() +
      facet_wrap(~sex)+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = "\nYear",
        y = "Life Expenctancy (Years)\n",
      )+
      color_theme()
  }
}

select_life_rank_data <- function(sex_input, rank_area_input) {
  
  life_expectancy_clean %>% 
    filter(type == rank_area_input,
           simd_quintiles == "All",
           urban_rural_classification == "All",
           date_code == "2017-2019",
           sex == sex_input,
           age == 0) %>%
    arrange(desc(le_value))
  
}

# Function to plot the data based on selected data from user choice

plot_life_rank_object <- function(data, select_input, rank_area_input) {
  
  if (select_input == "Top 5 Areas"){
  # Five Highest Areas for Life Expectancy 
  data %>%
    head(n = 5) %>%
    ggplot() +
    aes(x = reorder(name, le_value), y = le_value) +
    geom_col() +
    ylim(0, 100) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
    labs(
      x = paste("\n"),
      y = "Life Expectancy (years)\n"
    )
  } else{
  # Five Lowest Areas for Life Expectancy by
  data %>%
    tail(n = 5) %>%
    ggplot() +
    aes(x = reorder(name, -le_value), y = le_value) +
    geom_col() +
    ylim(0, 100) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
    labs(
      x = paste("\n"),
      y = "Life Expectancy (years)\n"
    )}
  
}

select_drugs_rank_data <- function(sex_input, rank_area_input) {
  
    sdmd_combined_clean %>%
        filter(type == rank_area_input,
               year == "2018/19",
               sex == sex_input) %>%
        arrange(desc(number_assessed)) 
}

# Function to plot the data based on selected data from user choice

plot_drugs_rank_object <- function(data, select_input, rank_area_input) {
  
  if (select_input == "Top 5 Areas"){
    # Five Highest Areas for drug abuse
    data %>%
      head(5) %>%
      ggplot() +
      aes(x = reorder(name, number_assessed), y = number_assessed) +
      geom_col() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n"),
        y = "Number of Patients Assessed\n"
      )
  } else{
    # Five Lowest Areas for drug abuse
    data %>%
      tail(5) %>%
      ggplot() +
      aes(x = reorder(name, -le_value), y = le_value) +
      geom_col() +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n"),
        y = "Life Expectancy (years)\n"
      )}
  
}

select_sm_rank_data <- function(rank_area_input, sex_input) {
  
  smoking_clean %>%
        filter(type == rank_area_input,
               date_code == "2019",
               sex == sex_input,
               household_type == "All",
               long_term_condition == "All",
               age == "All",
               smokes == "Yes") %>% 
        arrange(desc(sm_percent)) 

}

# Function to plot the data based on selected data from user choice

plot_sm_rank_object <- function(data, select_input, rank_area_input) {
  
  if (select_input == "Top 5 Areas"){
    # Five Highest Areas for drug abuse
    data %>%
      head(5) %>%
      ggplot() +
      aes(x = reorder(name, sm_percent), y = sm_percent) +
      geom_col() +
      ggtitle(paste("Five Highest Areas by Percentage of Smokers by", rank_area_input)) +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n"),
        y = "Number of Smokers (%)\n"
      )
  } else{
    # Five Lowest Areas for drug abuse
    data %>%
      tail(5) %>%
      ggplot() +
      aes(x = reorder(name, -sm_percent), y = sm_percent) +
      geom_col() +
      ggtitle(paste("Five Lowest Areas by Percentage of Smokers by", rank_area_input)) +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n"),
        y = "Number of Smokers (%)\n"
      )
  }
}