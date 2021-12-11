# App UI

# Load Packages
library(shiny)
#source("app_server.R")
library(lintr)

# Define ui variables
intro_panel <- tabPanel(
  "Introduction",
  img(src="https://fdn.gsmarena.com/imgroot/news/20/10/netflix-india-free-weekend/-1200/gsmarena_001.jpg", 
          height = "450px", align = "center"),
  #includeCSS("style.css"), 
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
         movies on Netflix is ", strong(most_movie_country)),
  h2("Research Questions: "),
  tags$p(id = "paragraph3", 
         "1. What is the number of media for each genre per year?", tags$br(),
         "2. What is the number of movies per Country (in each Continent) available on Netflix?", tags$br(),
         "3. What is the trend of average ratings for each genre throughout the year?"),
) 

chart_1 <- tabPanel(
  "Number per Genre",
  sidebarLayout(
    sidebarPanel(
      select_color <- selectInput(
        inputId = "color",
        choices = c("blue", "red", "green", "black", 
                    "pink", "orange", "purple", "yellow"),
        label = "Select a color"
      ),
      
      select_year <- selectInput(
        inputId = "year_added",
        label = "Select a year",
        choices = years,
        selected = "2020"
      )
    ),
    
    mainPanel(
      plotlyOutput(outputId = "chart1"),
      p("This bar chart shows the numbers of media of each genre
          on Netflix's platform. In this interactive visualization, 
          viewers can select the color from eight choices, and can also
          filter through the years from 2008 to 2020 that the films were 
          added to Netflix to see and analyze how the trends change. It should 
          be noted that because this is not a complete list of films, there
          are no values in the 2008 and 2010 graphs.")
    )
  )
)

chart_3 <- tabPanel(
  "Ratings Trends",
  h2("Rating trends over the years."),
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
        inputId = "backgroundInput",
        label = "Choose a background color for chart",
        choices = list(
          "White" = "white",
          "Gray" = "grey70",
          "Blue" = "lightsteelblue",
          "Cyan" = "lightcyan3",
          "Pink" = "mistyrose3"
        ),
        selected = "white"
      ),
      
      selectInput(
        inputId = "gridInput",
        label = "Display grid on chart",
        choices = list(
          "Yes" = "white",
          "No" = "grey93"
        ),
        selected = "white"
        )
      ),
    mainPanel(
      plotlyOutput(outputId = "chart_3_plot"),
      p(em("Click on a genre on the legend to hide its data on the graph.")),
      p("This chart shows the average rating trend of each genre over the years.
        User can select a starting year and an ending year from the left panel. 
        User can also choose a specific background color and whether they want 
        to display the grid on chart or not.")
    )
  )
) 

#page3chart2
chart_2 <- tabPanel(
  "Number of Movies Produced",
  sidebarLayout(
    sidebarPanel(
      select_color <- selectInput(
        inputId = "Color",
        choices = c("Red", "Green", "Blue", "Yellow", "Orange", "Purple"),
        label = "Select a Color"
      ),
      select_year <- selectInput(
        inputId = "Continent",
        label = "Select a Continent",
        choices = continentnames,
        selected = "South America"
      )
    ),
    
    mainPanel(
      plotlyOutput(outputId = "chart2"),
      p("Explanation and Analysis:"),
      p("This bar chart shows how many movies available on Netflix are produced in the countries of each respective continent. Note that not all every country in the continent is included, as Netflix did not have a movie that was produced in that country. Through this interactive visualization, you can change the bar graph to be 6 different colors. You are also able to choose between a dropdown menu of continents, and see how many movies were produced in each country in the corresponding continent. When hovering over the bars, you can see the Count (number of movies produced in that country on Netflix), and the name of the country.
Through this bar graph, you are able to see that the United States is the country where the most movies available on Netflix are produced, with a total of 1400. Second is India, with 695. You are also able to see the Countries with the greatest movie production per Continent. North America: United States, South America: Argentina, Asia: India, Africa: Egypt, Europe: United Kingdom, Oceania and Australia: Australia. 
This highlights the pattern that the countries with the highest movie production (as available on Netflix) are the countries with a large GDP, and strong film industry. You can also see the disparity between countries and movies produced, as many countries only have 1 movie produced in their country available on Netflix, such as Guatemala and Algeria. 
The data is updated as of 2020. Created by Navya Garg
")
    )
  )
)

summary_panel <- tabPanel(
  "Conclusion Page",
  h1("Conclusion", align = "center"),
  p(em("Specific Takeaways")),
  tags$p(id= "paragraph1", "Through this analysis, we answered the following questions:"),
  p(em("What is the number of media for each genre per year?")),
  p("We found that Stand-up Comedy remains to be the genre with the most numbers of media. Though, in 2020, the both Dramas and Action & Adventure were recorded to have the highest numbers of media, followed by Stand-up Comedy"),
  p(em("What is the trend of average ratings for each genre throughout the year?")),
  p("From the Ratings Trends chart, we found that since the 1990s, the average rating for all genres start to decline significantly."),
  p(em("What is the number of movies per Country (in each Continent) available on Netflix? ")),
  p("Through the bar chart for Number of Movies Produced per Country in each Continent, we found that the most movies are produced in the United States, with India second. Countries with a major film industry and higher GDP than others in the Continent tended to produce more Movies."),
  p(em("Created by Navya Garg, Uyen, Simrita, Krystal")),
)

ui <- navbarPage(
  "Netflix",
  intro_panel,
  chart_1,
  chart_3,
  chart_2,
  summary_panel,
  )