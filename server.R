# Import our dependencies
library(shiny)
library(dplyr)
library(ggplot2)

# Anything that happens here, before the shinyServer(...) function
# is loaded once when the application is started. This is a 
# good place to load our data

# load the data before starting up the application
gates <- read.csv("data/gates.csv", sep=",")
gates$start_date <- as.Date(gates$start_date)
gates$amount <- as.numeric(gates$amount)

# Define server logic
shinyServer(function(input, output) {
  # Everything in here is after the application is started
  # and is specific to each user session. That means
  # if one user subsets the data in a specific way, the 
  # change is only reflected in that one user's session,
  # not across all sessions.
  
  gatesData <- reactive({
    #' Reactive function that subsets our data based on 
    #' user input and returns a data frame.
    dplyr::filter(gates,
                  # make sure the data is in the date range
                  start_date >= input$start_date_range[1],
                  start_date <= input$start_date_range[2],
                  # make sure the data has the specified duration
                  # in years
                  duration_years >= input$number_of_years_range[1],
                  duration_years <= input$number_of_years_range[2],
                  # make sure the grant amount value is 
                  # in the specified amount range
                  amount >= input$amount_range[1],
                  amount <= input$amount_range[2]
                  )
  })
  
  grantsByRegion <- reactive({
    #' Massage our core Gates Foundation dataset
    #' in cases where we want to look at grants by
    #' geographic region.
    gatesData() %>%
      tidyr::gather(Region, is_region, c(
        Africa, Asia, World, SouthAmerica, NorthAmerica, Europe, Oceania
      )) %>%
      filter(is_region == TRUE)
  })
  
  output$total_amount <- renderText({
    #' Sum all grants that meet this user's requirements
    #' and render text that tells the user
    #' how much the total grant amount being explored is.
    
    # sum the total amount
    total.amount <- sum(gatesData()$amount)
    # format the total amount as a string with an explanation
    total.amount <- paste("Exploring ", "$", format(total.amount, big.mark=","), " in grants", sep="")
    # return
    total.amount
  })
  
  output$duration_amount_chart <- renderPlot({
    #' Create a ggplot2 scatterplot that shows grant
    #' duration and grant amount. Optionally allow the user
    #' to add a LOESS regression line to the visualization.
    
    # First, create the chart
    chart <- gatesData() %>%
      ggplot(aes(x=duration_years, y=amount)) + 
      geom_point() + 
      labs(
        title = "Grant duration and amount",
        x = "Grant duration in years",
        y = "Grant amount in dollars"
      )
    
    # optionally add a LOESS regression line
    if(input$regression == "Show"){
      chart <- chart + geom_smooth(method="loess")
    }
    
    # return the chart
    chart
  })
  
  output$top_grantees <- renderDataTable({
    #' Create a table that lists the top 50 grantees
    #' by total dollar value of grants given.
    gatesData() %>%
      # group by the grantee unique identifier
      group_by(grant_id) %>%
      # summarize at the grantee level
      summarise(
        # get the grantee's name and country
        Grantee = recipient_name[1],
        Country = recipient_country[1],
        # summarize the amount of all grants
        Amount = sum(amount, na.rm=T)
      ) %>%
      # we only want to show the grantee's name, country,
      # and the grant amount, so select only those fields
      select(Grantee, Country, Amount) %>%
      # top 50 organizations by amount
      top_n(50, Amount)
  })
  
  output$total_amount_region_bar <- renderPlot({
    #' Create a ggplot2 bar chart that shows the total
    #' amount of grants given by region
    grantsByRegion() %>%
      group_by(Region) %>%
      summarise(
        total_amount = sum(amount, na.rm=T)
      ) %>%
      ggplot(aes(x=Region, y=total_amount)) + 
        geom_bar(stat="identity") + 
      labs(
        title = "Total grant amounts by region",
        x = "Region",
        y = "Total grants in dollars"
      )
  })
  
  output$amount_region_boxplot <- renderPlot({
    #' Create a ggplot2 boxplot which shows the median
    #' grant amount and range by region 
    grantsByRegion() %>%
      ggplot(aes(x=Region, y=amount)) + 
      geom_boxplot() +
      labs(
        title = "Grant amounts by region",
        x = "Region",
        y = "Grant amount in dollars"
      )
  })
  
  
})