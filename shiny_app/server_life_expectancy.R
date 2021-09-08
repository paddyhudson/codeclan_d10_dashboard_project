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
        colour = "SIMD\nQuintiles"
      )+
      color_theme()
  }
}


