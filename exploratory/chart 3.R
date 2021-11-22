# Chart 3 - Yearly Average IMDB Trend

library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)

# Get useful datafram for average IMDB score per year
imdb_avg_year <- originals %>%
  separate(Premiere, into = c("date", "year"), sep="([,.])") %>%
  select(year, IMDB.Score) %>% 
  group_by(year) %>% 
  summarise(IMDB.Score = mean(IMDB.Score, na.rm = TRUE))

# Line_Dot graph for average IMDB score each year
year_imdb_trend <- ggplot(data = imdb_avg_year, 
                          aes(x = year, y = IMDB.Score, group = 1)) + 
  geom_point() +
  geom_line(color = "red") +
  labs(x = "Year", y = "Average IMDB Score", 
       title = "Average IMDB Score Year Trend")

