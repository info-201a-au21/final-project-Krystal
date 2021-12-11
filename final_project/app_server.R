# App Server

# load packages
library("tidyverse")
library("shiny")
library("plotly")
library("lintr")



# Load Data frame
originals <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_originals.csv?token=ARGUFDBNARBNM6LULBRMFJDBW7YXU")
movies <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_movies.csv?token=ARGUFDHDQBS4EW54JRXSZZTBW73CM")
countryproduced_data <- read.csv(
  "https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/data/netflix_movies.csv?token=ATTAO3KJZM5POJTHNQD7AH3BXKHBI", 
  stringsAsFactors = FALSE
)
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

# Chart 1: media for genre per year
year_was_added <- str_sub(movies$enter_in_netflix, -4, -1)

genre_year <- movies %>%
  mutate(year_added = year_was_added) %>%
  group_by(genre, year_added) %>%
  filter(year_added == year_added, na.rm = TRUE) %>%
  select(genre, year_added)

years <- unique(genre_year$year_added)

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
  summarize(Genre, year, rating = round(mean(rating), 2), .groups = "drop")

#Page 3 - Country Analysis
# make df with continents, country
countryproduced_data <- countryproduced_data %>%
  rename (Movie = movie_name) %>% 
  rename (Country = country)

filteredcountryproduced_data <- countryproduced_data %>%
  select (Country)

individualcountry <- filteredcountryproduced_data %>% 
  group_by(Country) %>% 
  mutate(Country = strsplit(gsub("[][\"]", "", Country), ", ")) %>%
  unnest(Country)

continentdata <- read.csv("https://raw.githubusercontent.com/info-201a-au21/final-project-SimritaGopalan/main/final_project/countrycontinent.csv?token=ATTAO3MV2KHAU3QJAXMK4LTBXWAFU")


allcontinents <- str_sub(continentdata$Continent)

countrycontinent <- continentdata %>%
  mutate(Continent = allcontinents) %>%
  group_by(Country, Continent) %>%
  filter(Continent == Continent, na.rm = TRUE) %>%
  select(Country, Continent)

continentnames <- unique(countrycontinent$Continent)


# Define a server
server <- function(input, output) {
    
    #Chart 1
    output$chart1 <- renderPlotly({
      selected_year <- input$year_added
      
      score_data <- genre_year %>%
        filter(!grepl(",", genre)) %>%
        filter(year_added == selected_year)
      
      chart1 <- ggplot(data = score_data) +
        geom_bar(mapping = aes(x = genre),
                 fill = input$color, show.legend = FALSE) +
        coord_flip() +
        labs(
          x = "Genres",
          y = "Number of Media",
          title = paste("Numbers of Media for each Genre")
        )
      ggplotly(chart1)
    })
  
  #Chart 3
  output$chart_3_plot <- renderPlotly({
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
      scale_x_continuous(limits = range(input$start_year:input$end_year)) +
      labs(
        x = "Year",
        y = "Rating",
        title = "Rating trend of each genre over the years"
      ) + theme(
        plot.title = element_text(size = rel(1.5)),
        plot.background = element_rect(
          fill = input$backgroundInput,
          colour = "grey50"
        ),
        panel.grid.major = element_line(colour = input$gridInput)
      )
    
    chart_3_plotly <- ggplotly(chart_3_plot, tooltip = c("text"))
    return(chart_3_plotly)
  })

#Chart 2
  
  output$chart2 <- renderPlotly({
    selected_continent <- input$Continent
    
    ccdata <- countrycontinent %>%
      filter(!grepl(",", Country)) %>%
      filter(Continent == selected_continent)
    
    chart2 <- ggplot(data = ccdata) +
      geom_bar(mapping = aes(x = Country),
               fill = input$Color, show.legend = FALSE) +
      coord_flip() +
      labs(
        x = "Countries",
        y = "Number of Movies Produced",
        title = paste("Number of Movies Produced in Each Country per Continent on Netflix")
      )
    ggplotly(chart2)
  })
}

