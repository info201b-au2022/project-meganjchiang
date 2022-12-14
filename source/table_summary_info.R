library(dplyr)
library(tidyr)
library(tibble)
span <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-meganjchiang/main/data/1995_2015.csv")
ed <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-meganjchiang/main/data/education.csv")
countyData <- read.csv("https://raw.githubusercontent.com/info201b-au2022/project-meganjchiang/main/data/2017_county_data.csv")

#HE attainment changes across 2 decades
HEattainmentAcrossTwoDecades <- span %>%
  select(1:4, 8:10) %>%
  group_by(Year) %>%
  filter(Age_Range == "18_64") %>%
  mutate(CollegeGrad = (Bachelor + Advanced + Associate)) %>%
  mutate(CGprop = round(CollegeGrad / Total, 3)) %>%
  select(1:3, 8:9)

HEtable <- knitr::kable(HEattainmentAcrossTwoDecades, caption = "Proportions of College Graduates")

#HEA1970region <- ed %>%
#  select(2,9:48) %>%
#  group_by(State) %>%
#  summarise("1970CountyAverageHEA%" = mean((100-(Percent.of.adults.with.a.high.school.diploma.only..1970+Percent.of.adults.with.less.than.a.high.school.diploma..1970)), na.rm=TRUE))
  
#HEA2015to2019region <- ed %>%
#  select(2,9:48) %>%
#  group_by(State) %>%
#  summarise("2015-2019CountyAverageHEA%" = mean((100-(Percent.of.adults.with.less.than.a.high.school.diploma..2015.19+Percent.of.adults.with.a.high.school.diploma.only..2015.19)), na.rm=TRUE))

#Regional HE attainment
#regionalHEA1970to2019 <- left_join(HEA1970region,HEA2015to2019region, by = "State")

#Socioeconomic data by state
#socioEconomic <- countyData %>%
#  select(2,7:12,14:18, 37) %>%
#  group_by(State) %>%
#  summarise_each(list(mean))