library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(lubridate)
library(rmarkdown)
library(knitr)

# install.packages(dplyr)
# install.packages(tidyr)
# install.packages(readr)
# install.packages(ggplot2)
# install.packages(lubridate)
# install.packages(rmarkdown)
# install.packages(knitr)

# options(repos = c(CRAN = "https://cloud.r-project.org/"))
# # URLs for the datasets needed in this research
# url_episodes <- "https://datasets.imdbws.com/title.episode.tsv.gz"
# url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"
# url_basics <- "https://datasets.imdbws.com/title.basics.tsv.gz"
#
# # Download the files
# download.file(url_episodes, destfile = "title.episode.tsv.gz")
# download.file(url_ratings, destfile = "title.ratings.tsv.gz")
# download.file(url_basics, destfile = "title.basics.tsv.gz")
# list.files()
#
# # Load the datasets
# episode_data <- read_tsv("title.episode.tsv.gz")
# ratings_data <- read_tsv("title.ratings.tsv.gz")
# basics_data <- read_tsv("title.basics.tsv.gz")
#
# summary(episode_data)
# summary(ratings_data)
# summary(basics_data)

# #small in between prep for task 3
# episode_data <- episode_data %>%
#   mutate(seasonNumber = as.numeric(seasonNumber))
#
# episode_data
# ratings_data
View(basics_data)


#Task 2

#merging the datasets
merged_data <- merge(episode_data, basics_data, by = "tconst")
merged_data <- merge(merged_data, ratings_data, by = "tconst")

#filtering neccesary columns
# I don't know which columns are deemed necessary. Here is the code to select columns that are needed.
# merged_data <- merged_data %>%
#   select(tconst, primaryTitle, startYear, endYear, genres, averageRating, numVotes, parentTconst, seasonNumber, episodeNumber) # just fill in the columns that we need

# Task 3
#Filtering horror & episodes from series with >1season

filtered_data <- merged_data %>%
  #filter for horror only
  filter(grepl("Horror", genres))
# Remove rows where seasonNumber is NA (\\N)
filter(!is.na(seasonNumber)) %>%
  # Group by parentTconst (series)
  group_by(parentTconst) %>%
  # Filter out series that have only season 1
  filter(max(seasonNumber) > 1) %>%
  ungroup()

#Task 4

# Step 1: Check for missing values
missing_values <- colSums(is.na(filtered_data))
print(missing_values)

# Step 2: Check data types
str(filtered_data)

# Step 3: Clean and format relevant columns
cleaned_data <- filtered_data %>%
  # Convert startYear and seasonNumber to numeric, replacing "\\N" with NA
  mutate(
    startYear = as.numeric(replace(startYear, startYear == "\\N", NA)),
    seasonNumber = as.numeric(replace(seasonNumber, seasonNumber == "\\N", NA)),
    averageRating = as.numeric(replace(averageRating, averageRating == "\\N", NA)),
    numVotes = as.numeric(replace(numVotes, numVotes == "\\N", NA))
  ) %>%
  
  # Remove rows with critical missing data
  filter(!is.na(startYear), !is.na(seasonNumber), !is.na(averageRating), !is.na(numVotes)) %>%
  
  # Step 4: Remove duplicates based on unique identifier 'tconst'
  distinct(tconst, .keep_all = TRUE)

# Step 5: Check for remaining missing values
remaining_missing_values <- colSums(is.na(cleaned_data))
print(remaining_missing_values)

# Summary of cleaned data
summary(cleaned_data)

#Task 5
# Make sure 'endYear' is treated as numeric and handle '\N' for non-series titles
cleaned_data <- cleaned_data %>%
  mutate(endYear = ifelse(endYear == "\\N", NA, as.numeric(endYear))) %>%
  
  # 1. Seasonal trends: avg_rating_per_season
  group_by(seasonNumber, parentTconst) %>%
  mutate(avg_rating_per_season = mean(averageRating, na.rm = TRUE)) %>%
  ungroup() %>%
  
  # 2. Episode popularity: ratings_per_episode
  mutate(ratings_per_episode = numVotes) %>%
  
  # 3. Year-based analysis: startYear
  # This variable already exists, so no need to create it again
  
  # 4. TV show lifetime: endYear - startYear
  mutate(tv_show_lifetime = endYear - startYear) %>%
  
  # 5. Total number of ratings per TV Series
  group_by(parentTconst) %>%
  mutate(total_ratings_per_series = sum(numVotes, na.rm = TRUE)) %>%
  ungroup()


#Task 6


# Task 7


cleaned_data <- cleaned_data %>%
  # Convert startYear to a Date object
  mutate(startYear = as.Date(paste(startYear, "01", "01", sep = "-"))) %>%
  
  # Convert endYear to a Date object, handle '\N' for non-series titles
  mutate(endYear = ifelse(endYear == "\\N", NA, as.Date(paste(endYear, "01", "01", sep = "-")))) %>%
  
  # Optionally, check for consistency
  mutate(startYear = ifelse(is.na(startYear), NA, floor_date(startYear, "year")),
         endYear = ifelse(is.na(endYear), NA, floor_date(endYear, "year")))
