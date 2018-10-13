library(shiny)



# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Tabsets"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
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
                  selectize = TRUE, width = NULL, size = NULL)
      ,
      
      # Input: Slider for the number of observations to generate ----
      sliderInput(inputId = "year",
                  label = "Year:",
                  value = 2000,
                  min = min(cause_of_death_rates$year),
                  max = max(cause_of_death_rates$year), 
                  step = 1),
      
      br() #,
      
      # sliderInput(inputId = "age",
      #             label = "Age:",
      #             value = 25,
      #             min = min(cause_of_death_rates$age),
      #             max = max(cause_of_death_rates$), 
      #             step = 1)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("How we die", plotOutput("plot_cause")),
                  tabPanel("When we die", plotOutput("plot_expec")),
                  tabPanel("Where we die", plotOutput("plot_map")),
                  tabPanel("Summary", verbatimTextOutput("summary")) #,
                  #tabPanel("Table", tableOutput("table"))
      )
      
    )
  )
)
