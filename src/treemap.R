library(tidyverse)
library(googleVis)

source("src/data_clean_up.R")

# Select data for a specific year, for both sexes and all ages
data <- data_top_category_filtered %>%
  filter(
    Sex=="Both sexes", 
    `Age at time of death`=="all ages", 
    Characteristics=="Number of deaths", 
    REF_DATE==2000)

# Assign an ID to each cause of death
data$cause_id <- data %>% group_indices(`Cause of death (ICD-10)`)

# Select a specific number of columns
tree_data <- data %>%
  select(`Cause of death (ICD-10)`, Characteristics, VALUE, cause_id)

# Create a new row for the parent
# https://stackoverflow.com/questions/44399496/rstudio-treemap-idvar-does-not-match-parentvar
tree_data_add <- tibble(
  `Cause of death (ICD-10)`=c("Number of deaths"),
  Characteristics=c(NA),
  VALUE=sum(tree_data$VALUE),
  cause_id=c(NA)
)

# Join the dataframes
tree_data <- rbind(tree_data, tree_data_add) %>%
  filter(VALUE > 0)

# Plot!
tree <-
  gvisTreeMap(
    tree_data,
    "Cause of death (ICD-10)",
    "Characteristics",
    "VALUE",
    "cause_id"
  )

plot(tree)