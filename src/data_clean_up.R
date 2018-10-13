#Read in data
data_deaths_and_age_specific_mortality <- read_csv("data/13100392.csv")

#Get top categories
categories=read.delim("resources/categories.txt", header = FALSE)

#Filter to include only data in top categories, and only necessary columns
data_top_category_filtered = filter(data_deaths_and_age_specific_mortality, `Cause of death (ICD-10)` %in% categories$V1) %>%
  select(REF_DATE, `Age at time of death`, Sex, `Cause of death (ICD-10)`, Characteristics, VALUE) %>%
  mutate(`Age at time of death`= str_sub(`Age at time of death`,23))



