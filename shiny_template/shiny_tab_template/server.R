# Define server logic for random distribution app ----

server <- function(input, output) {

  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  
  output$plot_cause <- renderPlot({
    year_input <- input$year
    sex_input <- input$sex
    age_input <- input$age
    
    filtered_cause_of_death_rates <- cause_of_death_rates %>%
      filter(year == year_input,
             Sex %in% sex_input,
             age_factor == age_input)
    
    treemap(filtered_cause_of_death_rates, #Your data frame object
            index="cause",  #A list of your categorical variables
            vSize = "rate_per_100k",  #This is your quantitative variable
            type="index", #Type sets the organization and color scheme of your treemap
            # palette = "Reds",  #Select your color palette from the RColorBrewer presets or make your own.
            title="Causes of Death Canada", #Customize your title
            fontsize.title = 14 #Change the font size of the title
            )
  })
  
  output$plot_male <- renderPlot({
    year_input <- input$yearMF
    sex_input <-  "Males"
    age_input <-  input$ageMF
    
    filtered_cause_of_death_rates <- cause_of_death_rates %>%
      filter(year == year_input,
             Sex %in% sex_input,
             age_factor == age_input)
    
    treemap(filtered_cause_of_death_rates, #Your data frame object
            index="cause",  #A list of your categorical variables
            vSize = "rate_per_100k",  #This is your quantitative variable
            type="index", #Type sets the organization and color scheme of your treemap
            palette = "Blues",  #Select your color palette from the RColorBrewer presets or make your own.
            title="Male leading causes of death", #Customize your title
            fontsize.title = 14 #Change the font size of the title
    )
  })
  
  output$plot_female <- renderPlot({
    year_input <- input$yearMF
    sex_input <-  "Females"
    age_input <-  input$ageMF
    
    filtered_cause_of_death_rates <- cause_of_death_rates %>%
      filter(year == year_input,
             Sex %in% sex_input,
             age_factor == age_input)
    
    treemap(filtered_cause_of_death_rates, #Your data frame object
            index="cause",  #A list of your categorical variables
            vSize = "rate_per_100k",  #This is your quantitative variable
            type="index", #Type sets the organization and color scheme of your treemap
            palette = "PuRd",  #Select your color palette from the RColorBrewer presets or make your own.
            title="Female leading causes of death", #Customize your title
            fontsize.title = 14 #Change the font size of the title
    )
  })
  
  # Generate a summary of the data ----
  # output$summary <- renderPrint({
  #   summary(d())
  # })
  
  # Generate an HTML table view of the data ----
  # output$table <- renderTable({
  #   datatable(cause_of_death_rates)
  # })
  
}
