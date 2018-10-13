
library(treemap)
library(tidyverse)
library(shiny)
# library(DT)
library(googleVis)
library(jsonlite)

source("gvis.R")
source("gvisTreeMap.R")

tree_data <- readRDS("tree_data.rds")

cause_of_death_rates <- readRDS("cause_of_death_rates.rds")