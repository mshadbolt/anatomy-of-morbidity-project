library(shiny)



# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("The anatomy of Morbidity"),
  
  tabsetPanel(
    type = "tabs",
    tabPanel("How we die",
             sidebarLayout(
               
               sidebarPanel(
                 # Input: Select the random distribution type ----
                 checkboxGroupInput(inputId = "sex", 
                                    label = "Sex:",
                                    choices = list("Male" = "Males",
                                                   "Female" = "Females"),
                                    selected = "Males"),
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
                             step = 1)
                 ),
                 mainPanel(
                   plotOutput("plot_cause")
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
                                        step = 1)
               ),
               mainPanel(plotOutput("plot_male"),
                         plotOutput("plot_female"))
             )),
    tabPanel("When we die", 
             sidebarLayout(
               sidebarPanel(),
               mainPanel(plotOutput("plot_expec"))
               )),
    tabPanel("Where we die", 
             sidebarLayout(
               sidebarPanel(),
               mainPanel(plotOutput("plot_map")))) #,
    #tabPanel("Summary", verbatimTextOutput("summary")),
    #tabPanel("Table", tableOutput("table")
  )
)
