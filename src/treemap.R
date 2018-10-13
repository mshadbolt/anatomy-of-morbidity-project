library(tidyverse)
library(googleVis)

source("src/data_clean_up.R")

# Select data for a specific year, for both sexes and all ages
data <- data_top_category_filtered %>%
  filter(
    `Age at time of death`=="all ages", 
    Characteristics=="Number of deaths",
    Sex=="Both sexes",
    REF_DATE==2000)

# Add one to each value so that we never have zero
data <- rename(data, cause=`Cause of death (ICD-10)`) %>%
  mutate(value_plus=VALUE+1)

# Assign a unique index for each cause  
data$cause_id <- data %>% group_indices(cause)

# Select a specific number of columns
tree_data <- data %>%
  select(cause, Characteristics, value_plus, cause_id, Sex, REF_DATE)

# Create a new row for the parent
# https://stackoverflow.com/questions/44399496/rstudio-treemap-idvar-does-not-match-parentvar
tree_data_add <- tibble(
  cause=c("Number of deaths"),
  Characteristics=c(NA),
  value_plus=sum(tree_data$value_plus),
  cause_id=c(NA),
  Sex=c(NA),
  REF_DATE=c(NA)
)

# Join the dataframes
tree_data <- rbind(tree_data, tree_data_add)

# Plot!
gvisTreeMap(
  tree_data,
  "cause",
  "Characteristics",
  "value_plus",
  "cause_id",
  options=list(
    minColor='#ee0979',
    # midColor='#D76D77',
    maxColor='#ff6a00',
    highlightOnMouseOver=TRUE
    )
  ) %>% plot()
