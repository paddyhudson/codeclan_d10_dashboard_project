#--------------------------------------------------------------------------#
# Server file to select the data and plots required for drug abuse         #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | JP          | Updated the contents of the function     #
#--------------------------------------------------------------------------#

# Function to select the data based on user choice

select_drug_data <- function(user_choice, input_name, input_demographic) {
  
    if(user_choice == "Age")
    {
      sdmd_combined_plus_zones %>%
        filter(name == input_name,
               age %in% input_demographic,
               sex == "All") %>% 
        filter(number_assessed != 0) %>% 
        filter(!is.na(number_assessed)) %>% 
        arrange(year) %>% 
        group_by(year, age) %>% 
        summarise(number_assessed_total = sum(number_assessed), .groups = "drop")
               # simd_quintiles == "All",
               # urban_rural_classification == "All"
        
    }
    else{
      sdmd_combined_plus_zones %>%
        # group_by(name, date_code, sex) %>% 
        # summarise(mean_le = mean(le_value),
        #           mean_le_lower_ci = mean(le_lower_ci),
        #           mean_le_upper_ci = mean(le_upper_ci),
        #           .groups = "drop"
        # ) %>% 
        filter(name == input_name,
               sex %in% input_demographic) %>% 
        filter(number_assessed != 0) %>% 
        filter(!is.na(number_assessed)) %>% 
        arrange(year) %>% 
        group_by(year, sex) %>% 
        summarise(number_assessed_total = sum(number_assessed), .groups = "drop")
    }
}

# Function to plot the data based on selected data from user choice

plot_drugs_object <- function(data, user_choice) {
  
  if(user_choice == "Age"){
  
    data %>% 
      ggplot(aes(x = year, y = number_assessed_total, group = age, colour = age)) +
      geom_point() +
      geom_line()
    
      # ggplot() +
      # aes(x = date_code, y = le_value, group = age, colour = age) +
      # geom_line() +
      # geom_point() +
      # geom_ribbon(aes(ymax = le_upper_ci, ymin = le_lower_ci), alpha = 0.25, colour = NA) +
      # theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      # labs(
      #   x = "\n\nYear",
      #   y = "Life Expectancy (years)\n",
      #   colour = "Age"
      # ) +
      # color_theme()  
  }
  else {
    
    data %>% 
      ggplot(aes(x = year, y = number_assessed_total, group = sex, colour = sex)) +
      geom_point() +
      geom_line()
      
      # ggplot() +
      # aes(x = date_code, y = mean_le, group = sex, colour = sex) +
      # geom_line() +
      # geom_point() +
      # geom_ribbon(aes(ymax = mean_le_lower_ci, ymin = mean_le_lower_ci), alpha = 0.25, colour = NA) +
      # theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      # labs(
      #   x = "\n\nYear",
      #   y = "Life Expectancy (years)\n",
      #   colour = "Sex"
      # )+
      # color_theme()
    
  }
}


