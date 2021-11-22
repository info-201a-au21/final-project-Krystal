# Chart 2 - Language Count Stack

library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)

# Filter useful dataframe that the language count at are at least 5 
count_language <- originals %>%
  #group_by(Genre) %>%
  arrange(Language) %>%
  group_by(Language) %>%
  mutate(language_sum = length(Language)) %>%
  filter(n() >= 5) %>% 
  filter(row_number() == 1) %>%
  select(Language, language_sum)

# Stack bar chart for count of each language
stack_bar <- ggplot(count_language, aes(x = "", y = language_sum, fill = Language))+
  geom_bar(width = 1, stat = "identity") + labs(y = "Sum of language")



