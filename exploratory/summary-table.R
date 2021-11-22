#aggregate table

library(data.table)
library(dplyr)

genre_grouping <- originals %>%
  group_by(Genre) %>%
  summarize(mean_scores = mean(IMDB.Score))

num_genre <- originals %>%
  group_by(Genre) %>%
  summarise(n())
  
  
avg_scores_table <- data.table(genre_grouping$Genre, genre_grouping$mean_scores)
avg_scores_table$V2 <- round(avg_scores_table$V2, digit = 2)
avg_scores_table$V3 <- num_genre[, 2]
colnames(avg_scores_table) <- c("Genre", "Average IMDB Score", "Count")
avg_scores_table <- avg_scores_table[, c(1, 3, 2)]
