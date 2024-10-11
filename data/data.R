# Load required libraries
library(readr)
library(dplyr)

# ---- Input ----
# URLs for the datasets needed in this research
urls <- c("https://datasets.imdbws.com/title.episode.tsv.gz",
          "https://datasets.imdbws.com/title.ratings.tsv.gz",
          "https://datasets.imdbws.com/title.basics.tsv.gz")

filenames <- c("title.episode.tsv.gz", "title.ratings.tsv.gz", "title.basics.tsv.gz")

# ---- Data Download: Download IMDb Datasets ----
# Download the files
for (i in seq_along(urls)) {
  download.file(urls[i], destfile = filenames[i])
}

# ---- Data Loading: Load the downloaded datasets ----
# Load the datasets
episode_data <- read_tsv("title.episode.tsv.gz")
ratings_data <- read_tsv("title.ratings.tsv.gz")
basics_data <- read_tsv("title.basics.tsv.gz")

# ---- Data Merging: Combine datasets based on 'tconst' ----
# Merging the datasets
merged_data <- episode_data %>%
  inner_join(basics_data, by = "tconst") %>%
  inner_join(ratings_data, by = "tconst")

# ---- Save Merged Data ----
write.csv(merged_data, "merged_data.csv", row.names = FALSE)
