# This script prepares the data and saves it in the shiny directory

path_to_git_repo <- "~/Desktop/github_repos/anatomy-of-morbidity-project/"
setwd(path_to_git_repo)
source("src/data_clean_up.R")

cause_of_death_rates <- data_top_category_filtered %>%
  filter(str_detect(Characteristics, "^Age-specific")) %>%
  rename(year = REF_DATE, age = `Age at time of death`, cause = `Cause of death (ICD-10)`,
         rate_per_100k = VALUE) %>%
  mutate(age_factor = factor(age)) 

cause_of_death_rates$age_factor <- ordered(cause_of_death_rates$age_factor,
                                           levels = c("under 1 year",
                                                      "1 to 4 years", 
                                                      "5 to 9 years",
                                                      "10 to 14 years",
                                                      "15 to 19 years",
                                                      "20 to 24 years",
                                                      "25 to 29 years",
                                                      "30 to 34 years",
                                                      "35 to 39 years",
                                                      "40 to 44 years",
                                                      "45 to 49 years",
                                                      "50 to 54 years",
                                                      "55 to 59 years",
                                                      "60 to 64 years",
                                                      "65 to 69 years",
                                                      "70 to 74 years",
                                                      "75 to 79 years",
                                                      "80 to 84 years",
                                                      "85 to 89 years",
                                                      "90 years and over"       
                                           ))

saveRDS(cause_of_death_rates, "shiny_template/shiny_tab_template/cause_of_death_rates.rds")
