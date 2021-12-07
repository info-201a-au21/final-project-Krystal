# App Server

# load packages
library(tidyverse)
library(shiny)
library(plotly)

# Load Data frame
originals <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_originals.csv?token=ARGUFDBNARBNM6LULBRMFJDBW7YXU")
movies <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_movies.csv?token=ARGUFDHDQBS4EW54JRXSZZTBW73CM")

# Relavent variables
# Average IMDB score of all movies.
avg_score <- mean(originals$IMDB.Score)

# Average runtime of all movies.
avg_runtime <- mean(originals$Runtime)

# Most common language of all the movies.
most_pop_language <- originals %>%
  group_by(Language) %>%
  count() %>%
  summarise(n) %>%
  filter(n == max(n)) %>%
  pull(Language)

# Genre with the most number of movies.
most_num_genre <- originals %>%
  group_by(Genre) %>%
  count() %>%
  summarise(n) %>%
  filter(n == max(n)) %>%
  pull(Genre)

# Useful darafram for number of movies per country 
num_movies_country <- movies %>%
  mutate(primary_country = gsub(",.*", "", movies$country)) %>%
  group_by(primary_country) %>%
  mutate(movie_count = length(primary_country)) %>%
  select(primary_country, movie_count) %>%
  slice(1)

# Country with most movies
max_movie_number <- max(num_movies_country$movie_count)

most_movie_country <- num_movies_country %>%
  filter(movie_count == max_movie_number) %>%
  pull(primary_country)

# Useful datafram for average IMDB score per year
imdb_avg_year <- originals %>%
  separate(Premiere, into = c("date", "year"), sep="([,.])") %>%
  select(year, IMDB.Score) %>% 
  group_by(year) %>% 
  summarise(IMDB.Score = mean(IMDB.Score, na.rm = TRUE))


# Define a server
server <- function(input, output) {
  
}

# 1. What is the average IMBD for each genre per year? 
# (x = Genre, y Genre, dropdown = year)
# 2. What is the number of movies per country? (Map)
# 3. What is trend of average IMDB score throughout the year 
# for different genre? (x = years, y = Average score, dropdown = Genre)