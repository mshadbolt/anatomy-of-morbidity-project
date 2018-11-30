library(d3treeR)
library (tidyverse)
library(treemap)

source("/Users/adilimtiaz/hackseq18/anatomy-of-morbidity-project/src/data_clean_up.R")
data_all <- data_top_category_filtered %>%
  filter(Characteristics =="Number of deaths")
data_f <- data_all %>%
  filter(Sex =="Females")
data_m <- data_all %>%
  filter(Sex =="Males")

map_all <- treemap(data_all, index = c("Cause of death (ICD-10)"), vSize="VALUE")
d3tree3(map_all)

map_f <- treemap(data_f, index = c("Cause of death (ICD-10)"), vSize="VALUE")
d3tree3(map_f)

map_m <- treemap(data_m, index = c("Cause of death (ICD-10)"), vSize="VALUE")
d3tree3(map_m)

