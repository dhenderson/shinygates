# First import our dependencies
library(shiny)

# Define the UI for the application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Gates Foundation data explorer"),
  
  # Let's use the sidebar layout to layout our application. As the name
  # implies, the sidebar layout has a sidebar (default to the left side)
  # and then a main panel on the right.
  sidebarLayout(
    # Create a sidebar that gives the user the option to 
    # specify grant date ranges, grant duration in years, 
    # and the grant amount range.
    sidebarPanel(
      # Add any number of UI inputs in the sidebar panel
      
      # First, let's add a date range input
      dateRangeInput("start_date_range", label = "Grant start date",
                     start  = "2015-01-01"),
      
      # Add a slide input that let's the user specify
      # the grant duration in number of years
      sliderInput("number_of_years_range",
                  "Grant length (year)",
                  min = 0,
                  max = 7,
                  value = c(0, 7)
      ),
      
      # Add a slider input that lets the user specify 
      # the grant amount range
      sliderInput("amount_range", 
                  "Grant amount range",
                  min = 100,
                  max = 50e6,
                  value = c(100, 50e6)
                  )
    ),
    
    # Now that the user inputs have been specified, let's add
    # output to the main panel of the UI.
    mainPanel(
      
      # The first thing we want to add is the text output
      # we created that tells the user the total amount of grants
      # the user is exploring. We'll wrap this in an h2(...)
      # function which stands for the header 2 style.
      h2(textOutput("total_amount")),
      
      # Because we have a few charts and tables, let's first organize
      # everything into tabs by using the tabsetPanel(...) function.
      tabsetPanel(
        
        # The first tab we'll create will let the user explore 
        # the duration and amount of grants
        tabPanel("Duration and amount",
                 # Add the ggplot2 chart showing duration and amount
                 plotOutput("duration_amount_chart"),
                 
                 # Add a UI control to let the user toggle hiding or
                 # showing the LOESS regression line
                 radioButtons("regression", "LOESS regression line",
                              c("Hide", "Show"), selected = "Hide")
                 ),
        
        # The second tab will show our table of top 50 organizations
        # by total grant amounts awarded
        tabPanel("Top 50 grantees",
                 # Add the data table output of top grantees.
                 dataTableOutput("top_grantees")
                 ),
        
        # Finally, add a tab that allows users to explore
        # grant amounts by regional focus
        tabPanel("Grants by geographic focus",
                 
                 # First, add the bar chart showing total 
                 # grant amouts by region
                 plotOutput("total_amount_region_bar"),
                 
                 # Second, let's add the box plots showing
                 # grants by region
                 plotOutput("amount_region_boxplot")
        )
      )
    )
  )
))