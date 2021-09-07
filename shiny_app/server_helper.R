
choose_area <- function (topic_input)
  {
                 
     if( topic_input == "Life Expectancy")
     {input_table <- life_expectancy_clean }
     else{
       if(topic_input == "Drug Abuse")
       {input_table <- sdmd_by_ca_and_demo_clean}
       else 
       {input_table <- smoking_clean }
     }
     
     #Fetch Zone data dynamically
     area_selection <- input_table %>%
       distinct(type) %>% 
       filter(!(is.na(type))) %>% 
       arrange(type) %>% 
       flatten_chr()
    return (area_selection)
}

choose_name <- function (topic_input, area_input)
{
  
  if( topic_input == "Life Expectancy")
  {input_table <- life_expectancy_clean }
  else{
    if(topic_input == "Drug Abuse")
    {input_table <- sdmd_by_ca_and_demo_clean}
    else 
    {input_table <- smoking_clean }
  }
  
  #Fetch Region data dynamically
  name_selection <- input_table %>%
    filter(type %in% area_input) %>%
    distinct(name) %>% 
    arrange(name)
  return (name_selection)
}

choose_breakdown <- function(topic_input, break_down, area_input, name_input)
{
  if( topic_input == "Life Expectancy")
  {input_table <- life_expectancy_clean }
  else{
    if(topic_input == "Drug Abuse")
    {input_table <- sdmd_by_ca_and_demo_clean}
    else 
    {input_table <- smoking_clean }
  }

if(break_down == "Age")
{
  choices <- input_table %>%
    filter(type %in% area_input,
           name %in% name_input) %>%
    distinct(age) %>% 
    arrange(age) %>% 
    flatten_chr()
  
  return (choices)
}
if(break_down == "Gender"){
  choices <- input_table %>%
    filter(type %in% area_input,
           name %in% name_input) %>%
    distinct(sex) %>% 
    arrange(sex) %>% 
    flatten_chr()
  
  return (choices)
}
}