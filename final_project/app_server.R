# App Server

# load packages
library(tidyverse)
library(shiny)
library(plotly)
library(lintr)

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

# Chart 1: avg IMDB for genre per year
year_was_added <- str_sub(movies$enter_in_netflix, -4, -1)

rating_genre_year <- movies %>%
  mutate(year_added = year_was_added) %>%
  group_by(genre, year_added) %>%
  mutate(mean_scores = round(mean(rating), 1)) %>%
  select(genre, mean_scores, year_added)

# Define a server
server <- function(input, output) {
  
  #Chart 1
  output$chart1 <- renderPlotly({
    selected_year <- input$year_added
    
    score_data <- rating_genre_year %>%
      filter(!grepl(",", genre))
    
    chart1 <- ggplot(data = score_data) +
      geom_col(mapping = aes(x = genre, y = mean_scores, 
               fill = input$color, na.rm = FALSE)) +
      coord_flip() +
      labs(
        x = "Genres",
        y = "Average IMDB Scores",
        title = paste("Average IMDB Scores for each Genre Based on Year")
      )
    ggplotly(chart1)
  })
}

# 1. What is the average IMBD for each genre per year? 
# (x = Genre, y Genre, dropdown = year)
# 2. What is the number of movies per country? (Map)
# 3. What is trend of average IMDB score throughout the year 
# for different genre? (x = years, y = Average score, dropdown = Genre)