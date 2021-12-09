# App

library(shiny)
library(ggplot2)
library(dplyr)
library (broom)
library(DT)
library(tidyr)
library(tidyverse)
library(maps)


# source r files
source("app_server.R")
source("app_ui.R")

shinyApp(server = server, ui = ui) 