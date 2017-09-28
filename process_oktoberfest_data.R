library(dplyr)

# save url string
rawDataUrl <- "https://www.opengov-muenchen.de/dataset/8d6c8251-7956-4f92-8c96-f79106aab828/resource/e0f664cf-6dd9-4743-bd2b-81a8b18bd1d2/download/oktoberfestgesamt19852016.csv"

# read data
data <- read.csv(rawDataUrl)

# rename variables DEU-ENG
data <- rename(data, year = jahr, 
               duration_days = dauer,
               visitor_year = besucher_gesamt, 
               visitor_day = besucher_tag, 
               beer_price = bier_preis,
               beer_sold = bier_konsum,
               chicken_price = hendl_preis,
               chicken_sold = hendl_konsum)

# unify measures
data$visitor_year <- data$visitor_year * 1000000
data$visitor_day <- data$visitor_day * 1000
data$beer_sold <- data$beer_sold * 100

write.csv(data, "OktobeRfest/dataOktoberfest.csv")
