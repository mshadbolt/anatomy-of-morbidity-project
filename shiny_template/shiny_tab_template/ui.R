library(shiny)


# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("The Anatomy of Morbidity in Canada"),
  p("The data in these visualisations is taken from ", a("Deaths, causes of death and life expectancy, 2016 dataset ",
       href = "https://www150.statcan.gc.ca/n1/daily-quotidien/180628/dq180628b-eng.htm"), "."),
  
  tabsetPanel(
    type = "tabs",
    tabPanel("How we die",
             sidebarLayout(
               
               sidebarPanel(
                 p("Relative proportions of different causes of death. The user can select which sex they are interested in, what age group and the year."),
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
                 width = 3
                 ),
                 mainPanel(
                   htmlOutput("death_total"),
                   htmlOutput("plot_cause_new"),
                   p("This visualisation was created using a derivative of:  Table  13-10-0392-01   Deaths and age-specific mortality rates, by selected grouped causes")
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
                         plotOutput("plot_female"),
                         p("This visualisation was created using a derivative of:  Table 13-10-0392 Deaths and age-specific mortality rates, by selected grouped causes"))
             )),
    tabPanel("When we die", 
             sidebarLayout(
               sidebarPanel(width = 3),
               mainPanel(plotOutput("plot_expec"))
               )),
    tabPanel("Life by Province", 
             sidebarLayout(
               sidebarPanel(selectInput(inputId = "age", 
                                        label = "Age category", 
                                        choices = levels(cause_of_death_rates$age_factor), 
                                        selected = NULL, multiple = FALSE,
                                        selectize = TRUE, width = NULL, size = NULL),
                            sliderInput(inputId = "year",
                                        label = "Year:",
                                        value = 2000,
                                        min = min(cause_of_death_rates$year),
                                        max = max(cause_of_death_rates$year), 
                                        step = 1,
                                        sep = ""),
                            width = 3),
               mainPanel(leafletOutput("plot_map")))) #,
    #tabPanel("Summary", verbatimTextOutput("summary")),
    #tabPanel("Table", tableOutput("table")
  )
)
