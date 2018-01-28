rm(list = ls())

library(tidyverse)

# Get series data series --------------------------------------------------

ABS_5206_001_data <- read.csv('Data/ABS_5206_001_data.csv',colClasses = c(Date="Date"))
ABS_5232_001_data <- read.csv('Data/ABS_5232_001_data.csv',colClasses = c(Date="Date"))

# Join series data series -------------------------------------------------

data <- full_join(ABS_5206_001_data,ABS_5232_001_data,by="Date")

# Export all ABS data -----------------------------------------------------

write.csv(data,'Data/ABSdata.csv',row.names = FALSE)
