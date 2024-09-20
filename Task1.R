

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
