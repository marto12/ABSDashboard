library(shiny)
library(DT)
library(shinyjs)


# Import data -------------------------------------------------------------

seriesInfo <- read.csv('Data/seriesInfo.csv')

# User interface ----------------------------------------------------------

ui <- fluidPage(
  h2("ABS Series Finder"),
  h3("Instructions"),
  p("Start with the search box in the top right, then filter by column"),
  p("   "),
  DT::dataTableOutput("mytable"),
  useShinyjs(),
  inlineCSS(list("body" = "font-size: 12px"))
)

# Server ------------------------------------------------------------------

server <- function(input, output) {
  output$mytable = DT::renderDataTable(
    seriesInfo,
    filter = 'top',
    options = list(scrollX = TRUE)
  )
}

shinyApp(ui, server)
  



