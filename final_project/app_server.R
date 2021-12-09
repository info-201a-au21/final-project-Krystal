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

# Useful dataframe for average IMDB score per year
imdb_avg_year <- originals %>%
  separate(Premiere, into = c("date", "year"), sep="([,.])") %>%
  select(year, IMDB.Score) %>% 
  group_by(year) %>% 
  summarise(IMDB.Score = mean(IMDB.Score, na.rm = TRUE))

# Chart 1: avg IMDB for genre per year
year_added <- str_sub(movies$enter_in_netflix, -4, -1)

rating_genre_year <- movies %>%
  mutate(year_added = year_added) %>%
  select(genre, rating, year_added)

chart_1 <- rating_genre_year %>%
  group_by(genre) %>%
  filter(!grepl(",", genre)) %>%
  summarize(num = n_distinct(genre), mean_scores = mean(rating)) %>%
  ggplot(aes(x = genre, y = mean_scores)) +
  geom_col() +
  geom_text(aes(label = round(mean_scores, 1), hjust = -0.2)) +
  coord_flip() +
  theme(legend.position = "none") +
  labs(
    x = "Genres",
    y = "Average IMDB Scores",
    title = paste("Average IMDB Scores for each Genre Based on Year")
  )

chart_1 <- ggplotly(chart_1)

chart_1 %>% style(
  marker = list(
    list(
      type = "buttons",
      x = 0.2,
      y = 0.4,
      buttons = list(
        
        list(method = "restyle",
             args = list("bar.color", "blue"),
             label = "Blue"),
        
        list(method = "restyle",
             args = list("bar.color", "red"),
             label = "Red")))
  ),
  hoverinfo = genre, mean_scores
)
# Chart 3: Ratings of each genre over the years
# Table for chart 3
raw_data_chart_3 <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_movies.csv?token=AV5INKLWJQDKBOVKPFKPB63BXEDEG")
old_data <- data_frame(
  year = raw_data_chart_3$year,
  raw_genre = raw_data_chart_3$genre,
  rating = raw_data_chart_3$rating
)

data_chart_3 <- mutate(old_data, "Genre" = str_extract(old_data$raw_genre, "[A-Za-z]+"))

sum_table <- data_chart_3 %>%
  group_by(Genre) %>%
  group_by(year) %>%
  summarize(Genre, year, rating = mean(rating))

# Define a server
server <- function(input, output) {
  output$chart_3 <- renderText({
    chart_3_plot <- ggplot(sum_table, aes(
      x = year,
      y = rating,
      group = Genre,
      color = Genre,
      text = paste(
        "Genre:", Genre,
        "\n Year:", year,
        "\n Rating:", rating
      )
    )) +
      geom_point() +
      scale_x_continuous(limits = range(sliderInput1:sliderInput2)) +
      labs(
        x = "Year",
        y = "Rating",
        title = "Ratings of each genre over the years"
      )
    
    chart_3_plotly <- ggplotly(chart_3_plot, tooltip = c("text"))
  })
}

# 1. What is the average IMBD for each genre per year? 
# (x = Genre, y Genre, dropdown = year)
# 2. What is the number of movies per country? (Map)
# 3. What is trend of average IMDB score throughout the year 
# for different genre? (x = years, y = Average score, dropdown = Genre)