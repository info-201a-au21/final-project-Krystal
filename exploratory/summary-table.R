#aggregate table

library(ggplot2)
library(tidyverse)
library(dplyr)

originals %>%
  group_by(Genre) %>%
  filter(n() >= 5) %>%
  summarize(mean_scores = mean(IMDB.Score)) %>%
  ggplot(aes(x = Genre, y = mean_scores, fill = Genre)) +
    geom_col() +
    geom_text(aes(label = round(mean_scores, 1), hjust = -0.2)) +
    coord_flip() +
    theme(legend.position = "none") +
    labs(
      x = "Genres",
      y = "Average IMDB Scores",
      title = paste("Average IMDB Scores for each Genre of Netflix Originals")
    )
