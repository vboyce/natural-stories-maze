 library(tidyverse)
library(urltools)
#function reads in data from a maze file plus demographic, other questions.
read_in_data <- function(filename){
  #reads data in generically because different format for different controllers
#filename="../Data/raw_data"
  data <- read_csv(filename, comment="#", col_names=c("time", "MD5", "controller", "item", "elem",
                                                      "type", "group", "col_8", "col_9", "col_10", "col_11", "col_12", "col_13", "col_14", "col_15"), col_types=cols(
                                                        time=col_integer(),
                                                        MD5=col_character(),
                                                        controller=col_character(),
                                                        item=col_integer(),
                                                        elem=col_integer(),
                                                        type=col_character(),
                                                        group=col_character(),
                                                        col_8=col_character(),
                                                        col_9=col_character(),
                                                        col_10=col_character(),
                                                        col_11=col_character(),
                                                        col_12=col_character(),
                                                        col_13=col_character(),
                                                        col_14=col_character(),
                                                        col_15=col_character()
                                                      )) %>% mutate_all(url_decode) #deal with %2C issue
  
  #split off non-maze, participant level stuff and process them
  other <- filter(data, type %in% c("questionnaire")) %>% 
    select(time, MD5, col_8, col_9) %>% 
    group_by(time, MD5) %>%
    pivot_wider(names_from=col_8, values_from=col_9) %>% 
    rename(gender=`Please select your gender.`) %>% 
    type_convert()
  #TODO:read for comments
  
  comp_q <- filter(data, type %in% c("practice_question","question_critical1","question_critical2",
                                     "question_critical3","question_critical4","question_critical5",
                                     "question_critical6","question_critical7","question_critical8","question_critical9","question_critical10")) %>% 
    select(time, MD5, type, question=col_8, answer=col_9, correct_answer=col_10, q_time=col_11) %>% 
    type_convert(col_types=cols(
      time=col_integer(),
      MD5=col_character(),
      type=col_character(),
      question=col_character(),
      answer=col_character(),
      correct_answer=col_integer(),
      q_time=col_integer()
    )) %>% 
     group_by(time, MD5, type) %>%
       mutate(question_num=row_number(),
              question_num=ifelse(type=="practice_question", str_c("prac_",question_num),str_c("",question_num))) %>% 
              ungroup() %>% 
    select(-question, -answer, -type) %>% 
    pivot_wider(names_from=question_num, values_from=c(correct_answer,q_time)) %>% 
    mutate(num_correct=(correct_answer_1+correct_answer_2+correct_answer_3+correct_answer_4+correct_answer_5+correct_answer_6))
    
  
  #take the Maze task results, relabel and type appropriately
  maze<- filter(data, controller=="Maze") %>% 
    select(time, MD5, type,word_num=col_8, word=col_9, distractor=col_10, on_right=col_11, correct=col_12, rt=col_13, sentence=col_14, total_rt=col_15) %>% 
    type_convert(col_types=cols(
      time=col_integer(),
      MD5=col_character(),
      type=col_character(),
      word_num=col_integer(),
      word=col_character(),
      distractor=col_character(),
      on_right=col_logical(),
      correct=col_character(),
      rt=col_integer(),
      sentence=col_character(),
      total_rt=col_integer()
    )) %>% 
    left_join(other, by=c("time", "MD5")) %>% 
    left_join(comp_q, by=c("time","MD5"))
  maze
}

#note: more comprehension questions data, such as time to answer exists, but we don't write it here b/c i don't care about it
natural_stories_1 <- read_in_data("../Data/raw_data") %>%
  mutate(subject=paste(MD5, time),
         subject=factor(subject, levels=unique(subject), labels=1:length(unique(subject)))) %>%
  select(-MD5, -time) %>%
  write_rds("../Data/cleaned.rds")
