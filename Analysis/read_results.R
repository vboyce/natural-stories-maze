library(tidyverse)
library(stringr)
library(urltools)
#function reads in data from a maze file plus demographic, other questions.
read_in_data <- function(filename){
  #reads data in generically because different format for different controllers
#filename="pilot_1_raw"
  data <- read_csv(filename, comment="#", col_names=c("time", "MD5", "controller", "item", "elem",
                                                      "type", "group", "col_8", "col_9", "col_10", "col_11", "col_12", "col_13", "col_14"), col_types=cols(
                                                        time=col_integer(),
                                                        MD5=col_character(),
                                                        controller=col_character(),
                                                        item=col_integer(),
                                                        elem=col_integer(),
                                                        type=col_character(),
                                                        group=col_integer(),
                                                        col_8=col_character(),
                                                        col_9=col_character(),
                                                        col_10=col_character(),
                                                        col_11=col_character(),
                                                        col_12=col_character(),
                                                        col_13=col_character(),
                                                        col_14=col_character()
                                                      )) %>% mutate_all(url_decode) #deal with %2C issue
  
  order_seen <- data %>% 
    select(time, MD5, group) %>% 
    filter(!is.na(group)) %>% 
    unique() %>% 
    group_by(time, MD5) %>% 
    mutate(trial_num = 1:n()) %>% 
    type_convert()
  
  #split off non-maze, participant level stuff and process them
  other <- filter(data, controller %in% c("Form", "Question")) %>% 
    select(time, MD5, col_8, col_9) %>% 
    group_by(time, MD5) %>%
    pivot_wider(names_from=col_8, values_from=col_9) %>% 
    rename(gender=`Please select your gender.`,
           native=`Are you a native speaker of English?`,
           residence=`Do you currently reside in the United States?`) %>% 
    type_convert()
  #TODO:read for comments
  
  #take the Maze task results, relabel and type appropriately
  maze<- filter(data, controller=="Maze") %>% 
    select(time, MD5, type, group, word_num=col_8, word=col_9, distractor=col_10, on_right=col_11, correct=col_12, rt=col_13, sentence=col_14) %>% 
    type_convert(col_types=cols(
      time=col_integer(),
      MD5=col_character(),
      type=col_character(),
      group=col_integer(),
      word_num=col_integer(),
      word=col_character(),
      distractor=col_character(),
      on_right=col_logical(),
      correct=col_character(),
      rt=col_integer(),
      sentence=col_character()
    )) %>% 
    left_join(order_seen, by=c("time", "MD5", "group")) %>% 
    left_join(other, by=c("time", "MD5"))
  maze
}


provo_1_pilot <- read_in_data("../Data/pilot_1_raw") %>% 
  mutate(subject=paste(MD5, time),
         subject=factor(subject, levels=unique(subject), labels=1:length(unique(subject)))) %>% 
  select(-MD5, -time)

write_rds(provo_1_pilot, "../Data/provo_pilot_1.rds")
