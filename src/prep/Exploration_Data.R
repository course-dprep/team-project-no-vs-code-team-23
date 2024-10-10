#Data Exploration
# ---- Getting Started ----
install.packages(dplyr)
install.packages(tidyr)
install.packages(readr)
install.packages(ggplot2)
install.packages(lubridate)
install.packages(rmarkdown)
install.packages(knitr)
install.packages(stringr)
install.packages(purrr)
install.packages(broom)

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

# ---- Input ----
# URLs for the datasets needed in this research
urls <- c("https://datasets.imdbws.com/title.episode.tsv.gz",
          "https://datasets.imdbws.com/title.ratings.tsv.gz",
          "https://datasets.imdbws.com/title.basics.tsv.gz")

filenames <- c("title.episode.tsv.gz", "title.ratings.tsv.gz", "title.basics.tsv.gz")

# ---- Data Download: Download IMDb Datasets ----
#Download the files
for (i in seq_along(urls)) {
  download.file(urls[i], destfile = filenames[i])
}

# ---- Data Loading: Load the downloaded datasets ----
#Load the datasets
episode_data <- read_tsv("title.episode.tsv.gz")
ratings_data <- read_tsv("title.ratings.tsv.gz")
basics_data <- read_tsv("title.basics.tsv.gz")

# ---- Data Merging: Combine datasets based on 'tconst' ----
#Merging the datasets
merged_data <- episode_data %>%
  inner_join(basics_data, by = "tconst") %>%
  inner_join(ratings_data, by = "tconst")

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
write.csv(filtered_data, "filtered_data.csv", row.names = FALSE)
