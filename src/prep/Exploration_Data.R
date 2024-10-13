# Data Exploration
# ---- Getting Started ----
install.packages("dplyr")
install.packages("tidyr")
install.packages("readr")
install.packages("ggplot2")
install.packages("lubridate")
install.packages("rmarkdown")
install.packages("knitr")
install.packages("stringr")
install.packages("purrr")
install.packages("broom")
install.packages("vroom")

#Load packages
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(lubridate)
library(rmarkdown)
library(knitr)
library(stringr)
library(purrr)
library(broom)
library(vroom)

#load in data
merged_data <- read_csv("gen/merged_data.csv")

# ---- Data Filtering & Transformation ----
filtered_data <- merged_data %>%
  # Group by parentTconst (series identifier) to calculate statistics for each series individually
  group_by(parentTconst) %>%
  
  # Create a new column 'numSeasons' which holds the maximum season number for each series
  # This helps identify how many seasons a particular series has
  mutate(numSeasons = max(seasonNumber, na.rm = TRUE)) %>%
  
  # Remove the grouping to ensure subsequent operations are applied to the entire dataset, not grouped data
  ungroup() %>%
  
  # Filter the dataset based on three conditions:
  # 1. The series is categorized as "Horror" in the 'genres' column.
  # 2. The series has more than one season (as calculated in 'numSeasons').
  # 3. The season number is not missing (i.e., not NA).
  filter(grepl("Horror", genres) & numSeasons > 1 & !is.na(seasonNumber))

# ---- Summary of the Dataset ----
#Summary for the final dataset
summary(filtered_data)

# ---- Analysis ----
#To further explore our data let's take a look at which horror movie has the most ratings for 2024 and has more than 1 season
result <- filtered_data %>%
  filter(numSeasons > 1) %>%
  arrange(desc(numVotes)) %>%
  slice(1)

# Trial Trend Analysis: Ratings of "Most Watched TV Series" over its seasons
most_watched <- filtered_data %>%
  filter(parentTconst == "tt1520211")

ggplot(most_watched, aes(x = seasonNumber, y = averageRating)) +
  geom_line(aes(color = seasonNumber), show.legend = FALSE) +
  geom_point(aes(color = seasonNumber), show.legend = FALSE) +
  facet_wrap(~ seasonNumber, scales = "free_x") +
  labs(
    title = "IMDb Ratings for Most Watched TV Series by Season",
    x = "Season Number",
    y = "Average Rating"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# ---- Output ----
#Save the data into a CSV file
write.csv(filtered_data, "gen/filtered_data.csv", row.names = FALSE)


