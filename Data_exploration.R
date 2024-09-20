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

# Load data sets
library(readr)
episode_data <- read_tsv("title.episode.tsv.gz")
ratings_data <- read_tsv("title.ratings.tsv.gz")
basics_data <- read_tsv("title.basics.tsv.gz")
summary(episode_data)
summary(ratings_data)
summary(basics_data)

# Task 1- Review, clean data and remove missing values from the 3 data sets and all irrelevant columns for this study
# Cleaning the episode_data data frame
class(episode_data$tconst)
class(episode_data$parentTconst)
class(episode_data$seasonNumber)
class(episode_data$episodeNumber)
is.numeric(episode_data$seasonNumber)
as.numeric(episode_data$seasonNumber)
non_numeric_values <-episode_data$seasonNumber[!grepl("^\\d+$", episode_data$seasonNumber)]
print(non_numeric_values) 

# Replace non-numeric values with NA in the episode_data 
episode_data$seasonNumber[!grepl("^\\d+$", episode_data$seasonNumber)] <- NA

# Convert to numeric or integer
episode_data$seasonNumber <- as.integer(episode_data$seasonNumber)  
is.numeric(episode_data$seasonNumber)

#Non numeric values for variable episodeNumber
non_numeric_values_episodeNumber <-episode_data$episodeNumber[!grepl("^\\d+$", episode_data$episodeNumber)]
print(non_numeric_values_episodeNumber)
# Check the number of NAs introduced
sum(is.na(episode_data$episodeNumber))
episode_data$episodeNumber[!grepl("^\\d+$", episode_data$episodeNumber)] <- NA
# Convert episodeNumber to integer
episode_data$episodeNumber <- as.integer(episode_data$episodeNumber)  
is.numeric(episode_data$episodeNumber)

# Cleaning data in the 2nd data set (ratings_data)
class(ratings_data$tconst)
class(ratings_data$averageRating)
class(ratings_data$numVotes)
# Check for NAs 
non_numeric_values_averageRating <-ratings_data$averageRating[!grepl("^\\d+$", ratings_data$averageRating)]
print(non_numeric_values_averageRating)
sum(is.na(ratings_data$tconst)) 
sum(is.na(ratings_data$averageRating))
sum(is.na(ratings_data$numVotes))

# Cleaning the data from the 3rd data set basics_data
class(basics_data$tconst)
class(basics_data$titleType)
class(basics_data$primaryTitle)
class(basics_data$originalTitle)
class(basics_data$startYear)
class(basics_data$endYear)
class(basics_data$runtimeMinutes)
class(basics_data$genres)

#Converting titleType from character to a factor
basics_data$titleType <- as.factor(basics_data$titleType)
is.factor(basics_data$titleType)
sum(is.na(basics_data$titleType))
# Check the unique values in the startYear column
unique(basics_data$startYear)
# Replace non-numeric values (like \N) with NA for startYear
basics_data$startYear[basics_data$startYear == "\\N"] <- NA
basics_data$startYear[basics_data$startYear == ""] <- NA  
# Convert startYear to integer, now without errors
basics_data$startYear <- as.integer(basics_data$startYear)
is.integer(basics_data$startYear)

# endYear 
class(basics_data$endYear)
unique(basics_data$endYear)
# Replace \N values with NA in the endYear column
basics_data$endYear[basics_data$endYear == "\\N"] <- NA
basics_data$endYear[basics_data$endYear == ""] <- NA
sum(is.na(basics_data$endYear))
basics_data$endYear <- as.integer(basics_data$endYear)
is.integer(basics_data$endYear)
# Check for problematic values in endYear (less than 1800)
invalid_years <- basics_data[basics_data$endYear < 1800 & !is.na(basics_data$endYear), ]
print(invalid_years)
# Replace invalid years (less than 1800) with NA
basics_data$endYear[basics_data$endYear < 1800] <- NA

# Remove the isAdult column using select() from dplyr
library(dplyr)
basics_data <- basics_data %>% select(-isAdult)

# Handling runtimeMinutes
class(basics_data$runtimeMinutes)
# Step 1: Replace \N with NA
basics_data$runtimeMinutes[basics_data$runtimeMinutes == "\\N"] <- NA
# Replace non-numeric values (e.g., empty strings) with NA
basics_data$runtimeMinutes[basics_data$runtimeMinutes == ""] <- NA
# Step 2: Convert runtimeMinutes to numeric
basics_data$runtimeMinutes <- as.integer(basics_data$runtimeMinutes)
# Step 3: Check the result
summary(basics_data$runtimeMinutes)

# Handling /N in the variable genres
basics_data$genres[basics_data$genres == "\\N"] <- NA
basics_data$genres[basics_data$genres == ""] <- NA



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
