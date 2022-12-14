library(shiny)
library(plotly)

source("tabs/tab_panel_intro.R")
source("tabs/tab_panel_chart1.R")
source("tabs/tab_panel_chart2.R")
source("tabs/tab_panel_chart3.R")
source("tabs/tab_panel_summary.R")
source("tabs/tab_panel_report.R")


ui <- navbarPage(
  
  includeCSS("www/styles.css"),
  
  title = "Education & Social Status in the United States",
  position = "fixed-top",

  br(),
  
  # A simple footer
  footer = list(
    tags$style(type = "text/css", "body {padding-top: 70px; padding-left: 10px}"),
    hr(),
    HTML("INFO 201: Foundational Skills for Data Science | Autumn 2022 | Jacob Hilse, Megan Chiang, Vincent Kao, Xuan Yi"),
    hr()
  ),

  # The project introduction
  tab_panel_intro,

  # The three charts
  tab_panel_chart1,
  tab_panel_chart2,
  tab_panel_chart3,

  # The project summary
  tab_panel_summary,

  # The project report
  tab_panel_report
)
