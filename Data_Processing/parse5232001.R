rm(list=ls())

library(tidyverse)
library(readxl)

url <- 'http://www.abs.gov.au/ausstats/abs@archive.nsf/log?openagent&5232001.xls&5232.0&Time%20Series%20Spreadsheet&EF0C2D251CB1A531CA2581FB0012339E&0&Sep%202017&20.12.2017&Latest'

download.file(url = url,destfile = "Data_Raw/5232001.xls",mode = 'wb')

# Read in excel file ------------------------------------------------------

ABS_5232_001_raw <- read_excel("Data_Raw/5232001.xls",sheet="Data1",col_names = FALSE)

# Create series info dataframe --------------------------------------------

ABS_5232_001_seriesInfo <- 
  ABS_5232_001_raw[1:10,]

# Clean up and transpose --------------------------------------------------

ABS_5232_001_seriesInfo <-
  ABS_5232_001_seriesInfo %>% 
  t() 

colnames(ABS_5232_001_seriesInfo) <- 
  ABS_5232_001_seriesInfo[1,]

ABS_5232_001_seriesInfo <- 
  ABS_5232_001_seriesInfo %>% 
  as.data.frame()

colnames(ABS_5232_001_seriesInfo)[1] <- 'Description'

ABS_5232_001_seriesInfo <- 
  ABS_5232_001_seriesInfo[-1,]

ABS_5232_001_seriesInfo <-
  ABS_5232_001_seriesInfo %>%
  select(`Series ID`,everything()) 

rownames(ABS_5232_001_seriesInfo) <- NULL

ABS_5232_001_seriesInfo <- 
  ABS_5232_001_seriesInfo %>%
  as.data.frame()

View(ABS_5232_001_seriesInfo)


# Split columns -----------------------------------------------------------

ABS_5232_001_seriesInfo$Description <- 
  ABS_5232_001_seriesInfo$Description %>%
  as.character()

ABS_5232_001_seriesInfo$Description %>%
  class()

ABS_5232_001_seriesInfo$Description[2] -> original

ABS_5232_001_seriesInfo <-
  ABS_5232_001_seriesInfo %>% 
  separate(col = 'Description',
           into = c('Description 1','Description 2','Description 3'),
           sep = ";",
           extra = 'merge',
           fill= 'right',
           remove = FALSE
           )

ABS_5232_001_seriesInfo$`Description 2` <- 
  gsub("[;]","",ABS_5232_001_seriesInfo$`Description 2`)
  
ABS_5232_001_seriesInfo$`Description 3` <- 
  gsub("[;]","",ABS_5232_001_seriesInfo$`Description 3`)

ABS_5232_001_seriesInfo <- 
  ABS_5232_001_seriesInfo %>% 
  select(-Description)

# Clean data file ---------------------------------------------------------

ABS_5232_001_data <- 
  ABS_5232_001_raw %>%
  slice(-(1:9))

colnames(ABS_5232_001_data) <- 
  ABS_5232_001_data[1,]

ABS_5232_001_data <- 
  ABS_5232_001_data %>%
  slice(-1)

colnames(ABS_5232_001_data)[1] <- "Date"

# Convert to numeric ------------------------------------------------------

ABS_5232_001_data <-
  ABS_5232_001_data %>% 
  mutate(Date = as.numeric(Date))

# Convert to numeric ------------------------------------------------------

excelDateOrigin <- "1899-12-30"

ABS_5232_001_data <-
  ABS_5232_001_data %>% 
  mutate(Date = as.Date(Date, origin=excelDateOrigin))

class(ABS_5232_001_data$Date)

# Remove redundant dataframe ----------------------------------------------

remove(ABS_5232_001_raw)

# Export to file ----------------------------------------------------------

write.csv(ABS_5232_001_seriesInfo,'Data/ABS_5232_001_seriesInfo.csv',row.names = FALSE)
write.csv(ABS_5232_001_data,'Data/ABS_5232_001_data.csv',row.names = FALSE)
