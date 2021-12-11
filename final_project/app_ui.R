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
         movies on Netflix is ", strong(most_movie_country), ", which in total 
         they have ", strong(max_movie_number, " movies.")),
  h2("Research Questions: "),
  tags$p(id = "paragraph3", 
         "1. What is the number of media for each genre per year?", tags$br(),
         "2. What is the number of movies per country?", tags$br(),
         "3. What is the trend of average IMDB scores throughout the year for 
         different genres?"),
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

page_two <- tabPanel(
  #label for the tab in navbar
  "Where are Movies Produced World Map", 
  p(h2("Which country is this movie produced in?")),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "Movie", label = "Search for a movie's name:"),
      textOutput(outputId = "message"),
    ),
    mainPanel(
      # Second Tab is the Plot
      # Added heading for the Plot
      # Displayed ggplot created in the server
      # Displayed reactive caption for the plot created in the server
      p(h3(strong("Country produced"))),
      p("This world map attempts to display the country/countries a specific Netflix movie is produced in."),
      plotlyOutput("Plot"), 
      p(h4(strong("Findings"))),
      textOutput(outputId = "analysis"),
      br()
    )
  )
)

summary_panel <- tabPanel(
  "Analysis Conclusion",
  h1("Conclusion Page", align = "center"), 
  tags$p(id= "paragraph1", "Presents 3+ specific takeaways from the analysis, tying the project back to the intention set out in the introduction.."),
)

ui <- navbarPage(
  "Netflix",
  intro_panel,
  chart_1,
  chart_3,
  page_two,
  summary_panel,
  )