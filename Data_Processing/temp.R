rm(list = ls())

library(tidyverse)

# Get series info series --------------------------------------------------

ABS_5206_001_seriesInfo <- read.csv('Data/ABS_5206_001_seriesInfo.csv')
ABS_5232_001_seriesInfo <- read.csv('Data/ABS_5232_001_seriesInfo.csv')

# Join series info series -------------------------------------------------

seriesInfo_raw <- 
  rbind(ABS_5206_001_seriesInfo,ABS_5232_001_seriesInfo) %>%
  as.tibble()

# Initiate clean series ---------------------------------------------------

seriesInfo <- 
  seriesInfo_raw

# Generic cleaning function -----------------------------------------------
# Funny syntax because its a replacement function
# http://adv-r.had.co.nz/Functions.html

cleanUp <- function(x,value) {
  
  # Convert factors to characters
  x <- x %>%
    as.character()
  
  # Remove whitespaces at the beginning
  x <- x %>% 
    str_replace("^\\s*","")
  
  # Remove whitespaces at the end
  x <- x %>% 
    str_replace("\\s+$","")
  
  # Remove colons at theDa end
  x <- x %>% 
    str_replace("\\:+$","")
  
  # Remove fix capitalisation
  x <- x %>% 
    str_replace("Changes","changes")
  
  x
}

seriesInfo$Description.2 <-
  cleanUp(seriesInfo$Description.1) 

seriesInfo$Description.2 <- 
  cleanUp(seriesInfo$Description.2) 

seriesInfo$Description.3 <-
  cleanUp(seriesInfo$Description.3)


# Check Description 1 -----------------------------------------------------

seriesInfo$Description.1 %>%
  sort() %>%
  unique() %>%
  View()

# Check Description 2 -----------------------------------------------------

seriesInfo$Description.2 %>%
  sort() %>%
  unique() %>%
  View()

# Check Description 3 -----------------------------------------------------

seriesInfo$Description.3 %>%
  sort() %>%
  unique() %>%
  View()

