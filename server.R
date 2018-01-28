rm(list = ls())

library(shiny)
library(DT)
library(shinyjs)


# Import data -------------------------------------------------------------

abs <- read.csv('Data/ABSdata.csv')

# Convert to long format --------------------------------------------------

abs_long <- 
  abs %>%
  gather(key = "Indicator",value="Value",-Date)

abs_long$Date <- 
  abs_long$Date %>% 
  as.Date()

abs_long$Date %>% class()

function(input, output, session){
  
  getDataSet<-reactive({
    
    withProgress(message = 'Fetching data', {
      
      # Get a subset of the data which is contingent on the input variables -----
      dataSet<-abs_long[abs_long$Indicator==input$dataIndicator,]
      
      dataSet
    })
  })
  
  suppressWarnings(
  output$plot1 <- renderPlot({
    dataSet<-getDataSet()
    plot(dataSet$Date,dataSet$Value)
    
    dataSet %>% 
      ggplot(mapping = aes(x=Date,y=Value)) +
      geom_jitter(size=0.5,color="turquoise4",alpha=0.5) +
      geom_area(alpha=0.2,fill="turquoise2") + 
      geom_line(alpha=0.5,colour="turquoise2") + 
      theme_pander() +
      scale_colour_pander()
  
    })
  )

  # Table of results, rendered using data table
  
  withProgress(message = 'Creating table', {
    
    output$absTable <- renderDataTable(datatable({
      dataSet<-getDataSet()
      dataSet <- 
        dataSet %>%
        arrange(desc(Date))
    },
    options = list(lengthMenu = c(5, 10, 50), pageLength = 10),
    rownames= FALSE)
    )
  })
  
  # Data indicator selecter. Gets values from dataset -------------------------
  
  output$indicatorSelect <- renderUI({
    indicatorRange <- abs_long$Indicator %>% unique()
    selectInput("dataIndicator",
                "Indicator",
                choices = indicatorRange,
                selected = indicatorRange[1])
  })
  
  # https://gitlab.com/snippets/16220
  
  output$hover_info <- renderUI({
    hover <- input$plot_hover
    point <- nearPoints(dataSet, hover, threshold = 5, maxpoints = 1, addDist = TRUE)
    if (nrow(point) == 0) return(NULL)
    
    # calculate point position INSIDE the image as percent of total dimensions
    # from left (horizontal) and from top (vertical)
    left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
    top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)
    
    # calculate distance from left and bottom side of the picture in pixels
    left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
    top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)
    
    # create style property fot tooltip
    # background color is set so tooltip is a bit transparent
    # z-index is set so we are sure are tooltip will be on top
    style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
                    "left:", left_px + 2, "px; top:", top_px + 2, "px;")
    
    # actual tooltip created as wellPanel
    wellPanel(
      style = style,
      p(HTML(paste0("<b> Date: </b>", format(point$Date,"%B %Y"), "<br/>",
                    "<b> Value: </b>", point$Value, "<br/>"
                    )))
    )
  })
  
}
# format(point$Date,"%a %b %d")
# input$dataIndicator
# 
# theData$Value
# 



