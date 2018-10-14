library(shiny)

# <link href="https://fonts.googleapis.com/css?family=Roboto|Source+Sans+Pro" rel="stylesheet">

# Define UI for random distribution app ----
ui <- fluidPage(theme="shiny.css",
  
  
  # App title ----
  titlePanel("The Anatomy of Morbidity in Canada"),
  p("The data in these visualisations is taken from the ", a("Deaths, causes of death and life expectancy, 2016 dataset ",
       href = "https://www150.statcan.gc.ca/n1/daily-quotidien/180628/dq180628b-eng.htm")),
  
  tabsetPanel(
    type = "tabs",
    tabPanel("How we die",
             sidebarLayout(
               
               sidebarPanel(
                 p("Relative proportions of different causes of death. Filter by sex, age group or year below."),
                 # Input: Select the random distribution type ----
                 radioButtons(inputId ="sex",
                              label ="Sex:",
                              c("Both sexes" = "Both sexes",
                                "Male" = "Males",
                                "Female" = "Females"),
                              selected = "Both sexes",
                              inline = FALSE,
                              width = NULL),
                 # br() element to introduce extra vertical spacing ----
                 br(),
                 selectInput(inputId = "age", 
                             label = "Age category", 
                             choices = levels(cause_of_death_rates$age_factor), 
                             selected = NULL, multiple = FALSE,
                             selectize = TRUE, width = NULL, size = NULL),
                 # Input: Slider for the number of observations to generate ----
                 br(),
                 sliderInput(inputId = "year",
                             label = "Year:",
                             value = 2000,
                             min = min(cause_of_death_rates$year),
                             max = max(cause_of_death_rates$year), 
                             step = 1,
                             sep = ""),
                 width = 3,
                 p("This visualisation was created using a derivative of: ",
                    a("Deaths and age-specific mortality rates, by selected grouped causes",
                      href="https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310039201")
                   )
                 ),
                 mainPanel(
                   htmlOutput("death_total"),
                   htmlOutput("plot_cause_new")
               )
            )),
    tabPanel("Males vs Females", 
             sidebarLayout(
               sidebarPanel(selectInput(inputId = "ageMF", 
                                        label = "Age category", 
                                        choices = levels(cause_of_death_rates$age_factor), 
                                        selected = NULL, multiple = FALSE,
                                        selectize = TRUE, width = NULL, size = NULL),
                            # Input: Slider for the number of observations to generate ----
                            br(),
                            sliderInput(inputId = "yearMF",
                                        label = "Year:",
                                        value = 2000,
                                        min = min(cause_of_death_rates$year),
                                        max = max(cause_of_death_rates$year), 
                                        step = 1,
                                        sep = ""),
                            width = 3
               ),
               mainPanel(plotOutput("plot_male"),
                         plotOutput("plot_female")
                )
             )),
    tabPanel("Life by Province", 
             sidebarLayout(
               sidebarPanel(selectInput(inputId = "age", 
                                        label = "Age category", 
                                        choices = levels(df$Age_group), 
                                        selected = NULL, multiple = FALSE,
                                        selectize = TRUE, width = NULL, size = NULL),
                            sliderInput(inputId = "year_map",
                                        label = "Year:",
                                        value = 1980,
                                        min = min(df$YEAR),
                                        max = max(df$YEAR), 
                                        step = 1,
                                        sep = ""),
                            width = 3),
               mainPanel(leafletOutput("plot_map")))) #,
    #tabPanel("Summary", verbatimTextOutput("summary")),
    #tabPanel("Table", tableOutput("table")
  )
)
