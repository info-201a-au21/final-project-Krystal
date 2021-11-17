library("tidyverse")
library("dplyr")
originals <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_originals.csv?token=AV5INKOEACOPFRW43Q4PN2TBTXP7K")
View(originals)

# 1. Mean of IMDB score of all movies. 
avg_score <- mean(originals$IMDB.Score)
# 2. Median of IMDB score of all movies
median_score <- median(originals$IMDB.Score)
# 3. Average runtime of all movies.
avg_runtime <- mean(originals$Runtime)
# 4. Most common language of all the movies.
most_pop_language <- originals %>%
  group_by(Language) %>%
  count() %>%
  summarise(n) %>%
  filter(n == max(n)) %>%
  pull(Language)
# 5. Genre with the most number of movies.
num_movies <- originals %>%
  group_by(Genre) %>%
  count() %>%
  summarise(n) %>%
  filter(n == max(n)) %>%
  pull(Genre)


