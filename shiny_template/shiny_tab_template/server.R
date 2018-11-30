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
  
  output$plot_cause_new <- renderGvis({
    year_input <- input$year
    sex_input <- input$sex
    age_input <- input$age
    
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
        minColor='#EE6C81',
        midColor='#777CA8',
        maxColor= '#AFBACD',
        highlightOnMouseOver=TRUE,
        generateTooltip = "function(row, size, value) { 
                              return '<div style=\"background:#fd9; padding:10px; border-style:solid\">' + data.getValue(row, 3) + '</div>'; 
    }"
      )
    )
  })
  
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
  
  output$plot_map <- renderLeaflet({
    year_input = input$year_province
    
    df <- df %>%
      filter(YEAR==year_input)
    
    df_male <- df %>%
      filter(Sex=='M')
    
    df_female <- df %>%
      filter(Sex=='F')

    df_both <- df %>%
      filter(Sex=='Both')
    
    provinces2_both  <- sp::merge(
      provinces,
      df_both,
      by.x = "name",
      by.y = "GEO",
      sort = FALSE
    )
    
    provinces2_male  <- sp::merge(
      provinces,
      df_male,
      by.x = "name",
      by.y = "GEO",
      sort = FALSE
    )
    
    provinces2_female  <- sp::merge(
      provinces,
      df_female,
      by.x = "name",
      by.y = "GEO",
      sort = FALSE
    )
    
    
    clear <- "#F2EFE9"
    lineColor <- "#000000"
    hoverColor <- "red"
    lineWeight <- 0.5
    pal <- colorNumeric(palette = 'Spectral', c(max(df$AVG_VALUE), min(df$AVG_VALUE)), reverse = TRUE)
    
    
    leaflet() %>% 
      leaflet(options = leafletOptions(zoomControl = FALSE,
                                       minZoom = 3, maxZoom = 3,
                                       dragging = FALSE)) %>%
      addTiles() %>% 
      setView(-110.09, 62.7,  zoom = 3) %>% 
      addPolygons(data = subset(provinces2_both, name %in% c("British Columbia", "Alberta", "Saskatchewan", "Manitoba", "Ontario", "Québec", "New Brunswick", "Prince Edward Island", "Nova Scotia", "Newfoundland and Labrador", "Yukon", "Northwest Territories", "Nunavut")),
                  fillColor = ~ pal(AVG_VALUE),
                  fillOpacity = 0.75,
                  stroke = TRUE,
                  weight = lineWeight,
                  color = lineColor,
                  highlightOptions = highlightOptions(fillOpacity = 1, bringToFront = TRUE, sendToBack = TRUE),
                  label=~stringr::str_c(
                    name,' ',
                    formatC(AVG_VALUE)),
                  labelOptions= labelOptions(direction = 'auto'),
                  group = "Both") %>%
      addPolygons(data = subset(provinces2_male, name %in% c("British Columbia", "Alberta", "Saskatchewan", "Manitoba", "Ontario", "Québec", "New Brunswick", "Prince Edward Island", "Nova Scotia", "Newfoundland and Labrador", "Yukon", "Northwest Territories", "Nunavut")),
                  fillColor = ~ pal(AVG_VALUE),
                  fillOpacity = 0.75,
                  stroke = TRUE,
                  weight = lineWeight,
                  color = lineColor,
                  highlightOptions = highlightOptions(fillOpacity = 1, bringToFront = TRUE, sendToBack = TRUE),
                  label=~stringr::str_c(
                    name,' ',
                    formatC(AVG_VALUE)),
                  labelOptions= labelOptions(direction = 'auto'),
                  group = "Male") %>%
      addPolygons(data = subset(provinces2_female, name %in% c("British Columbia", "Alberta", "Saskatchewan", "Manitoba", "Ontario", "Québec", "New Brunswick", "Prince Edward Island", "Nova Scotia", "Newfoundland and Labrador", "Yukon", "Northwest Territories", "Nunavut")),
                  fillColor = ~ pal(AVG_VALUE),
                  fillOpacity = 0.75,
                  stroke = TRUE,
                  weight = lineWeight,
                  color = lineColor,
                  highlightOptions = highlightOptions(fillOpacity = 1, bringToFront = TRUE, sendToBack = TRUE),
                  label=~stringr::str_c(
                    name,' ',
                    formatC(AVG_VALUE)),
                  labelOptions= labelOptions(direction = 'auto'),
                  group = "Female") %>%
      # Add the checklist
      addLayersControl(overlayGroups = c('Male',
                                         'Female'),
                       options = layersControlOptions(collapsed = FALSE),
                       position = 'topright') %>%
      addLegend(pal = pal, 
                values = df$AVG_VALUE,
                position = "bottomleft", 
                title = "Life Expectancy",
                labFormat = labelFormat(suffix = " Years", transform = function(x) sort(x, decreasing = FALSE))
      ) %>%
      addLayersControl(
        position = "topleft",
        baseGroups = c("Male", "Female", "Both"),
        #overlayGroups = c("sfbdjsd", "sdbjskfdk"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  
  output$plot_map_canada <- renderLeaflet({
    year_input = input$year_canada
    
    df <- df %>%
      filter(YEAR==year_input, Sex=="Both")
    
    provinces2  <- sp::merge(
      provinces,
      df,
      by.x = "name",
      by.y = "GEO",
      sort = FALSE
    )
    
    clear <- "#F2EFE9"
    lineColor <- "#000000"
    hoverColor <- "red"
    lineWeight <- 0.5
    pal <- colorNumeric(palette = 'Reds', c(max(df$AVG_VALUE), min(df$AVG_VALUE)), reverse = TRUE)
    provinces2 %>% 
      leaflet() %>% 
      leaflet(options = leafletOptions(zoomControl = FALSE,
                                       minZoom = 3, maxZoom = 3,
                                       dragging = FALSE)) %>%
      addTiles() %>% 
      setView(-110.09, 62.7,  zoom = 3) %>% 
      addPolygons(data = subset(provinces2, name %in% c("British Columbia", "Alberta", "Saskatchewan", "Manitoba", "Ontario", "Québec", "New Brunswick", "Prince Edward Island", "Nova Scotia", "Newfoundland and Labrador", "Yukon", "Northwest Territories", "Nunavut")),
                  fillColor = ~ pal(AVG_VALUE),
                  fillOpacity = 0.5,
                  stroke = TRUE,
                  weight = lineWeight,
                  color = lineColor,
                  highlightOptions = highlightOptions(fillOpacity = 1, bringToFront = TRUE, sendToBack = TRUE),
                  label=~stringr::str_c(
                    name,' ',
                    formatC(AVG_VALUE)),
                  labelOptions= labelOptions(direction = 'auto')) %>%
      # Add the checklist
      addLegend(pal = pal, 
                values = df$AVG_VALUE,
                position = "bottomleft", 
                title = "Life Expectancy",
                labFormat = labelFormat(suffix = " Years"))
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