library(shinydashboard)
library(leaflet)
library(DT)

header <- dashboardHeader(title = "Mortgage Stress")

body <- dashboardBody(fluidRow(column(
  width = 12,
  box(
    width = NULL,
    div(style = "display:inline-block;width: 350px; position:relative; z-index:99999 !important;", uiOutput("indicatorSelect"))
  ),
  box(width = NULL,
      dataTableOutput("absTable")),
  box(
    width = NULL,
    plotOutput("plot1", hover = hoverOpts(id ="plot_hover")),
    uiOutput("hover_info")
  )
)))

dashboardPage(header,
              dashboardSidebar(disable = TRUE),
              body)