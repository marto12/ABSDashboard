rm(list=ls())

library(tidyverse)
library(readxl)

url <- 'http://www.abs.gov.au/ausstats/meisubs.NSF/log?openagent&5206001_key_aggregates.xls&5206.0&Time%20Series%20Spreadsheet&CE1F279684368599CA2581ED001C1FF1&0&Sep%202017&06.12.2017&Latest'

download.file(url = url,destfile = "Data_Raw/5206001.xls",mode = 'wb')

# Read in excel file ------------------------------------------------------

ABS_5206_001_raw <- read_excel("Data_Raw/5206001.xls",sheet="Data1",col_names = FALSE)

# Create series info dataframe --------------------------------------------

ABS_5206_001_seriesInfo <- 
  ABS_5206_001_raw[1:10,]

# Clean up and transpose --------------------------------------------------

ABS_5206_001_seriesInfo <-
  ABS_5206_001_seriesInfo %>% 
  t() 

colnames(ABS_5206_001_seriesInfo) <- 
  ABS_5206_001_seriesInfo[1,]

ABS_5206_001_seriesInfo <- 
  ABS_5206_001_seriesInfo %>% 
  as.data.frame()

colnames(ABS_5206_001_seriesInfo)[1] <- 'Description'

ABS_5206_001_seriesInfo <- 
  ABS_5206_001_seriesInfo[-1,]

ABS_5206_001_seriesInfo <-
  ABS_5206_001_seriesInfo %>%
  select(`Series ID`,everything()) 

rownames(ABS_5206_001_seriesInfo) <- NULL

View(ABS_5206_001_seriesInfo)


# Split columns -----------------------------------------------------------

ABS_5206_001_seriesInfo <-
  ABS_5206_001_seriesInfo %>% 
  separate(col = 'Description',
           into = c('Description 1','Description 2'),
           sep = ":",
           extra = 'merge',
           fill= 'right',
           remove = FALSE)

ABS_5206_001_seriesInfo <-
  ABS_5206_001_seriesInfo %>% 
  separate(col = 'Description 2',
           into = c('Description 2','Description 3'),
           sep = " - ")

ABS_5206_001_seriesInfo$`Description 2` <- 
  gsub("[;]","",ABS_5206_001_seriesInfo$`Description 2`)
  
ABS_5206_001_seriesInfo$`Description 3` <- 
  gsub("[;]","",ABS_5206_001_seriesInfo$`Description 3`)

ABS_5206_001_seriesInfo <- 
  ABS_5206_001_seriesInfo %>%
  select(-Description)

# Clean data file ---------------------------------------------------------

ABS_5206_001_data <- 
  ABS_5206_001_raw %>%
  slice(-(1:9))

colnames(ABS_5206_001_data) <- 
  ABS_5206_001_data[1,]

ABS_5206_001_data <- 
  ABS_5206_001_data %>%
  slice(-1)

colnames(ABS_5206_001_data)[1] <- "Date"


# Convert to numeric ------------------------------------------------------

ABS_5206_001_data <-
  ABS_5206_001_data %>% 
  mutate(Date = as.numeric(Date))

# Convert to numeric ------------------------------------------------------

excelDateOrigin <- "1899-12-30"
ABS_5206_001_data <-
  ABS_5206_001_data %>% 
  mutate(Date = as.Date(Date, origin=excelDateOrigin))

class(ABS_5206_001_data$Date)


# Remove redundant dataframe ----------------------------------------------

remove(ABS_5206_001_raw)


# Export to file ----------------------------------------------------------

write.csv(ABS_5206_001_seriesInfo,'Data/ABS_5206_001_seriesInfo.csv',row.names = FALSE)
write.csv(ABS_5206_001_data,'Data/ABS_5206_001_data.csv',row.names = FALSE)
