# App

# load packages
library(shiny)

# source r files
source("app_server.R")
source("app_ui.R")

shinyApp(server = server, ui = ui) 


