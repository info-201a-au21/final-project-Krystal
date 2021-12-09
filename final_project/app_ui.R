# App UI

# Load Packages
library(shiny)
source("app_server.R")
library(lintr)

# Define ui variables
intro_panel <- tabPanel(
  "Introduction",
  img(src="https://fdn.gsmarena.com/imgroot/news/20/10/netflix-india-free-weekend/-1200/gsmarena_001.jpg", 
          height = "450px", align = "center"),
  includeCSS("style.css"), 
  h1("Netflix Analysis", align = "center"), 
  tags$p(id= "paragraph1", "Netflix is one of the most trending platforms 
        that people use to watch TV shows and movies. Although Netflix produces 
        and holds hundreds of shows and films, the quality of these movies and 
        shows fluctuate. In this analysis, we are seeking the average IMBD score 
        for each genre each year. We also want to use a map to give the 
        visualization of the number of movies in each country. Moreover, we want 
        to see the trend of IMBD scores for each genre throughout the years."),
  tags$p(id = "paragraph2", class = "blackborder", "In this analysis, I found 
         that the average IMDB score of all movies is ", strong(avg_score), 
         ". The average runtime of all movies is ",  strong(avg_runtime), 
         "minutes. The most common language on Netflix is ",
         strong(most_pop_language), ". The genre with the most number of movies 
         and shows is ", strong(most_num_genre), ". The country with the most 
         movies on Netflix is ", strong(most_movie_country), ", which in total 
         they have ", strong(max_movie_number, " movies.")),
  h2("Research Questions: "),
  tags$p(id = "paragraph3", 
        "1. What is the average IMBD score for each genre per year?", tags$br(),
        "2. What is the number of movies per country?", tags$br(),
        "3. What is trend of average IMDB score throughout the year for different genres?"),
) 

genre_rating_chart <- tabPanel(
  "Genre vs. Rating",
  sidebarLayout(
    sidebarPanel(
      select_color <- selectInput(
        inputId = "color",
        choices = c("blue", "red", "green", "black", "pink", "orange"),
        label = "Select a color"
      ),
      
     #app.R wont run because "the object year_added was not found" so I put 
     #quotes around it as a placeholder
      select_year <- selectInput(
        inputId = "year",
        label = "Select a year",
        choices = "year_added",
        selected = "2016"
      )
    ),
    
    mainPanel(
      plotlyOutput(outputId = "chart1"),
      p("This bar chart shows the average ratings of genres of media
          on Netflix's platform. In this interactive visualization, 
          viewers can select the color from six choices, and can also
          filter through the four years that the films were added to
          Netflix to see and analyze how the trends change.")
    )
  )
)

chart_3 <- tabPanel(
  "Ratings Trends",
  h1("Ratings over the years of each genre"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "start_year",
        label = "Choose starting year",
        min = 1942,
        max = 2020,
        value = 1942
      ),
      sliderInput(
        inputId = "end_year",
        label = "Choose ending year",
        min = 1942,
        max = 2020,
        value = 2020
      ),
      selectInput(
        inputId = "color_input",
        label = "Choose a set of colors for chart",
        choices = list(
          "Light" = "Set3",
          "Bold" = "Paired",
          "Spectral" = "Spectral",
          "Gradient" = "YlGnHu"
        ),
        selected = "Bold"
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "chart_3_plot")
    )
  )
) 

ui <- navbarPage(
  "Netflix",
  intro_panel,
  genre_rating_chart,
  chart_3)
