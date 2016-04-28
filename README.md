# Shiny Gates

Shiny Gates is a sample [Shiny Server][shiny] web application written for a session at the 2016 [Do Good Data][do-good] conference. The app enables users to browse [Gates Foundation][gates] grant amounts by duration and region.

This application is meant for learning purposes, do with it what you wish.

## Running the app

To start the application, open either the `server.R` or `ui.R` file in RStudio and press the "Run App" button.

## Dependencies

The app depends on the following packages. You can download packages in R with `install.packages("name_of_package")`.

- shiny
- dplyr
- ggplot2
- tidyr

## Where the data comes from

The data was pulled from the [Glasspockets][glass] API using an  [R Glasspockets API wrapper][wrapper]. The data pulled from Glasspockets was lightly massaged to better conform to the app's needs.

## Shiny resources

- RStudio has a nice [tutorial on its website](http://shiny.rstudio.com/tutorial/)
- This [gallery of Shiny apps](http://shiny.rstudio.com/gallery/) can help you get inspired about what to build
- If you want push-button Shiny webapp hosting, check out [shinyapps.io](http://www.shinyapps.io/)

[shiny]: http://shiny.rstudio.com/
[glass]: http://glasspockets.org/
[gates]: http://www.gatesfoundation.org/
[do-good]: http://www.dogooddata.com/
[wrapper]: https://github.com/dhenderson/glasspockets
