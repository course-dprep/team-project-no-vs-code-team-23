#Data Exploration
# ---- Getting Started ----
#Install Packages
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
url_episodes <- "https://datasets.imdbws.com/title.episode.tsv.gz"
url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"
url_basics <- "https://datasets.imdbws.com/title.basics.tsv.gz"

# ---- Data Download: Download IMDb Datasets ----
#Download the files
download.file(url_episodes, destfile = "title.episode.tsv.gz")
download.file(url_ratings, destfile = "title.ratings.tsv.gz")
download.file(url_basics, destfile = "title.basics.tsv.gz")

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
#Filtering horror & episodes from series with >1season
filtered_data <- merged_data %>%
  #filter for horror only
  filter(grepl("Horror", genres)) %>%
  # Remove rows where seasonNumber is NA (\\N)
  filter(!is.na(seasonNumber)) %>%
  # Group by parentTconst (series)
  group_by(parentTconst) %>%
  # Filter out series that have only season 1
  filter(max(seasonNumber) > 1) %>%
  ungroup()

# ---- Summary of the Dataset ----
#Summary for the final dataset
summary(filtered_data)

# ---- Analysis ----
#To further explore our data let's take a look at which horror movie has the most ratings for 2024 and has more than 1 season
result <- filtered_data %>%
  group_by(parentTconst) %>%
  mutate(numSeasons = max(seasonNumber, na.rm = TRUE)) %>%
  ungroup() %>%
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
