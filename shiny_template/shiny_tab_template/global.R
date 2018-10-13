
library(treemap)
library(tidyverse)
library(shiny)
# library(DT)
library(googleVis)

tree_data <- readRDS("tree_data.rds")

cause_of_death_rates <- readRDS("cause_of_death_rates.rds")