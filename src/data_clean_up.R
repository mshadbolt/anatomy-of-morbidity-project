# This is code that shows our process for cleaning up the complete data table 
# 'Table  13-10-0392-01   Deaths and age-specific mortality rates, by selected grouped causes'
# From the Statistics Canada Dataset 'Death, causes of death, and life expectancy, 2016' 
# accessed 12th October, 2018.
#
# Prerequisites:
# It assumes you have downloaded the complete csv from https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310039201 
# to a directory data within your working directory.

# Author: Katarina 

library(tidyverse)

#Read in data
data_deaths_and_age_specific_mortality <- read_csv("data/13100392.csv")

# Get top categories 
# These categories are the top categories within the hierarchy of ICD10-CA
categories=read.delim("resources/categories.txt", header = FALSE)

#Select only relevant columns
data_relevant_columns <- data_deaths_and_age_specific_mortality %>%
  select(REF_DATE, `Age at time of death`, Sex, `Cause of death (ICD-10)`, Characteristics, VALUE) %>%
  mutate(`Age at time of death`= str_sub(`Age at time of death`,23))
  
#Filter to include only data in top categories
data_top_category_filtered <- filter(data_relevant_columns, `Cause of death (ICD-10)` %in% categories$V1) 



