
## to load the treemaps 
library(treemap)
library(tidyverse)
library(shiny)
# library(DT)
library(googleVis)
library(jsonlite)

# scripts below override some functions in the gvis package to allow tooltip to be generated
source("gvis.R")
source("gvisTreeMap.R")

# filtered and cleaned number of deaths data
tree_data <- readRDS("tree_data.rds")

# filtered and cleaned rate data
cause_of_death_rates <- readRDS("cause_of_death_rates.rds")

### To load the interactive map
library(leaflet)
library(rgdal)

load("provinces.RData")
