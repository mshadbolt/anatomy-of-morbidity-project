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
               Sex == sex_input,
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

  cause_of_death_treemap <- function(year, sex, age){
    year_input <- year
    sex_input <- sex
    age_input <- age
    
    filtered_tree_data <- tree_data %>%
      filter(year == year_input,
             Sex == sex_input,
             age_factor == age_input)
    
    # Create a new row for the parent
    # https://stackoverflow.com/questions/44399496/rstudio-treemap-idvar-does-not-match-parentvar
    
    filtered_tree_data_add <- tibble(
      cause=c("Number of deaths"),
      Characteristics=c(NA),
      value_plus=c(1), #sum(tree_data$value_plus),
      cause_id=c(NA),
      Sex=c(NA),
      year=c(NA),
      age_factor = c(NA),
      total_deaths = c(NA)
    )
    
    # Join the dataframes
    filtered_tree_data <- bind_rows(filtered_tree_data, filtered_tree_data_add)
    
    gvisTreeMap(
      filtered_tree_data,
      "cause",
      "Characteristics",
      "value_plus",
      "cause_id",
      options=list(
        minColor='#ee0979',
        # midColor='#D76D77',
        maxColor='#ff6a00',
        highlightOnMouseOver=TRUE,
        fontFamily="system-ui",
        generateTooltip = "function(row, size, value) { 
        return '<div style=\"background:#fd9; padding:10px; border-style:solid\">' + data.getValue(row, 3) + '</div>'; 
  }"
      )
      )
  }
  
  output$death_total <- renderText({
    year_input <- input$year
    sex_input <- input$sex
    age_input <- input$age
    
    filtered_tree_data <- tree_data %>%
      filter(year == year_input,
             Sex == sex_input,
             age_factor == age_input)
    
    death_total = filtered_tree_data %>%
      summarize(sum=sum(total_deaths))
    
    paste("Total number of deaths: <b>", death_total,"</b>", sep = " ")
  })

  
  output$plot_cause_new <- renderGvis({
    cause_of_death_treemap(input$year,input$sex,input$age)
  })
  
  output$plot_male1 <-renderGvis({
    cause_of_death_treemap(input$yearMF,"Males",input$ageMF)
  })
  
  output$plot_female1 <-renderGvis({
    cause_of_death_treemap(input$yearMF,"Females",input$ageMF)
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
  
  output$plot_map <- renderLeaflet({
    leaflet() %>% 
      # Disable movement, keep map static
      leaflet(options = leafletOptions(zoomControl = FALSE,
                                       minZoom = 3, maxZoom = 3,
                                       dragging = FALSE)) %>%
      addTiles() %>% 
      setView(-110.09, 62.7,  zoom = 3) %>% 
      addPolygons(data = subset(provinces, name %in% c("British Columbia", "Alberta", "Saskatchewan", "Manitoba", "Ontario", "Quebec", "New Brunswick", "Prince Edward Island", "Nova Scotia", "Newfoundland and Labrador", "Yukon", "Northwest Territories", "Nunavut")),
                  # Province shading
                  fillColor = rainbow(14, alpha = NULL), stroke = FALSE,
                  weight = 1,
                  # Popup annotations
                  popup = "idk") %>%
      # Checklist
      addLayersControl(overlayGroups = c('idk',
                                         'what',
                                         'the',
                                         'options',
                                         'are'),
                       options = layersControlOptions(collapsed = FALSE),
                       position = 'topright')
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
