#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)



###############################################################################

# Chart 2: Visualization for Research Question #2
# How has the level of education for the American public changed over the last
# couple of decades?

# import 1995-2015 data
data_1995_2015 <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-meganjchiang/main/data/1995_2015.csv")

# filter the rows with all ages and sexes and select columns with education info 
education_data <- data_1995_2015 %>%
  filter(Age_Range == "18_64", Sex == "Both") %>% 
  select(Year, No_HS_Diploma:Advanced)

# transpose rows and columns
education_data <- as.data.frame(t(education_data))  

# delete row with years
education_data <- education_data[-1, ]

# add column with levels of education
education_levels <- rownames(education_data)
education_levels <- str_replace_all(education_levels, "_", " ")
education_data <- education_data %>% 
  mutate(
    "Highest Level of Education" = education_levels
  )

# make education levels the first column
education_data <- education_data %>%
  select("Highest Level of Education", everything())

# make column names the years 1995, 2005, 2015 
colnames(education_data) <- c("Highest Level of Education", "1995", "2005", 
                              "2015")

# delete row names
rownames(education_data) <- NULL

# reorder levels of education (so not alphabetical in legend)
education_data$`Highest Level of Education` <- factor(
  education_data$`Highest Level of Education`, levels = rev(education_levels)
)


# "lengthen" the data so it's easier to graph & add proportion of population
education_data <- education_data %>% 
  pivot_longer("1995":"2015", names_to = "Year", 
               values_to = "Number of Adults") %>%
  group_by(Year) %>%
  mutate("Proportion of Adults" = round(
    `Number of Adults` / sum(`Number of Adults`), 3))

build_chart2 <- function(year1, year2) {
  
  education_data_for_plot <- education_data %>%
    filter(Year == year1 | Year == year2)

  education_stack_bar <- ggplot(data = education_data_for_plot) +
    geom_bar(
      mapping = aes(
        fill = `Highest Level of Education`,
        x = c(education_data_for_plot$Year),
        y = `Proportion of Adults`
      ),
      position = "stack",
      stat = "identity",
      width = 0.3
    )
  return(ggplotly(education_stack_bar))
}

###############################################################################

# Chart 3: Visualization for Research Question #3
# How does one’s level of education received relate to their employment status?


# import data
data_unemploy <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-meganjchiang/main/data/unemployment.csv")
data_edu <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-meganjchiang/main/data/education.csv")


# combine 2 data sets
data_total <- data_unemploy %>%
  left_join(data_edu %>%
              mutate("Area_name" = paste0(Area.name, ", ", State)),
            by = "Area_name")

# select important variables for chart
data_2000_2015 <- data_total %>%
  select(State.x,
         City.Suburb.Town.Rural,
         Unemployment_rate_2000,
         Percent.of.adults.with.a.bachelor.s.degree.or.higher..2000,
         Unemployment_rate_2015, 
         Percent.of.adults.with.a.bachelor.s.degree.or.higher..2015.19)

# group and summarize
data_sum <- data_2000_2015 %>%
  group_by(City.Suburb.Town.Rural) %>%
  summarize(
    Unemployment_Rate_2000 = mean(Unemployment_rate_2000, na.rm = TRUE),
    At_Least_Bachelors_2000 = mean(
      Percent.of.adults.with.a.bachelor.s.degree.or.higher..2000, 
      na.rm = TRUE),
    Unemployment_Rate_2015 = mean(Unemployment_rate_2015, na.rm = TRUE),
    At_Least_Bachelors_2015 = mean(
      Percent.of.adults.with.a.bachelor.s.degree.or.higher..2015.19, 
      na.rm = TRUE)
  ) %>%
  rename(Area = City.Suburb.Town.Rural)
data_sum <- data_sum[-1, ]


build_chart3 <- function(year, type) {
  data_sum_for_plot <- data_sum
  if (year == 2000){
    data_sum_for_plot <- data_sum %>%
      select("Area", "Unemployment_Rate_2000", "At_Least_Bachelors_2000") %>%
      rename(`Unemployment Rate` = Unemployment_Rate_2000) %>%
      rename(`Percent of Adults with At Least Bachelor's Degree` = At_Least_Bachelors_2000)
  }
  if (year == 2015){
    data_sum_for_plot <- data_sum %>%
      select("Area", "Unemployment_Rate_2015", "At_Least_Bachelors_2015") %>%
      rename(`Unemployment Rate` = Unemployment_Rate_2015) %>%
      rename(`Percent of Adults with At Least Bachelor's Degree` = At_Least_Bachelors_2015)
  }
  
  chart3_group_bar <- ggplot(data = data_sum_for_plot) +
    geom_bar(
      mapping = aes(
        x = `Area`,
        if (type == "Unemployment Rate") {
          y = `Unemployment Rate`
        } else {
          y = `Percent of Adults with At Least Bachelor's Degree`
        }
      ),
      position = "dodge",
      stat = "identity",
      color = "black",
      fill = "white",
      width = 0.3
    ) +
    labs(
      title = paste0(type, " in America in ", year, " for Different Areas"),
      x = "Area",
      y = type
    )
  return(ggplotly(chart3_group_bar))
}

###############################################################################

server <- function(input, output) {
    # TBD
  
  output$chart2 <- renderPlotly({
    return(build_chart2(input$c2y1, input$c2y2))
  })
  
  output$chart3 <- renderPlotly({
    return(build_chart3(input$c3year, input$c3type))
  })
  
}

