# App UI

# Load Packages
library(shiny)
source("app_server.R")
library(lintr)

# Define ui variables
intro_panel <- tabPanel(
  "Introduction",
  img(src = "img.jpg", height = "350px", align = "center"),
  includeCSS("style.css"), 
  h1("Netflix Analysis", align = "center"), 
  tags$p(id= "paragraph1", "Netflix is one of the most trending platform 
        that people user to watch shows and movies. Although netflix prodcue and 
        hold hundrends of shows, the quality of these movies and show fluctuate. 
        In this analysis, we are seeking for the average IMBD score for each 
        genre each year. We also want to use a map to give the visualization of 
        the number of movies in each country. Moreover, we want to see the IMBD 
        score trend for each genre throughout the years."),
  tags$p(id = "paragraph2", class = "blackborder", "In this analysis, I found 
         the average IMDB score of all movies is ", strong(avg_score), 
         ". The average runtime of all movies is ",  strong(avg_runtime), 
         "minutes. The most common language on Netflix is ",
         strong(most_pop_language), ". The genre with the most number of movies 
         and shows is ", strong(most_num_genre), ". The country with the most 
         movies on Nextflix is ", strong(most_movie_country), ", which they have 
         in total of ", strong(max_movie_number, " movies."))
) 

ui <- navbarPage(
  "Netflix",
  intro_panel)
  