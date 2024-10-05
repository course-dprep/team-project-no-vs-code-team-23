#Data Preparation
# --- Input and Column Selection----
# Load the dataset and select only the necessary columns
filtered_data <- read.csv("filtered_data.csv")

clean_data <- filtered_data %>%
  select(tconst, parentTconst, seasonNumber, episodeNumber, titleType, primaryTitle, originalTitle, startYear, endYear, runtimeMinutes, genres, averageRating, numVotes)

# ---- Identify and handle missing values ----
miss_val <- colSums(is.na(clean_data))
print(miss_val)

# ---- Data Type Conversion and Missing Value Handling ----
# Check the data types
str(clean_data)
# Handle missing value and format the necessary columns
clean_data <- filtered_data %>%
  # Convert startyear, seasonnumber, averageRating, numVotes and runtimeminutes to numeric and replace \\N with NA
  mutate(
    startYear = as.numeric(replace(startYear, startYear == "\\N", NA )),
    seasonNumber = as.numeric(replace(seasonNumber, seasonNumber == "\\N", NA)),
    averageRating = as.numeric(replace(averageRating, averageRating == "\\N", NA)),
    numVotes = as.numeric(replace(numVotes, numVotes == "\\N", NA)),
    runtimeMinutes = as.numeric(replace(runtimeMinutes, runtimeMinutes == '\\N', NA))
  ) %>%
  # Remove rows with missing values from the above columns
  filter(!is.na(startYear), !is.na(seasonNumber), !is.na(averageRating), !is.na(numVotes), !is.na(runtimeMinutes)) %>%
  # Filter observations to have a start year >= 1980
  filter(startYear >=1980)

# ---- Data Formatting: Factors and Handling Year ----
# Format column 'titleType' as a factor from character
clean_data$titleType <- as.factor(clean_data$titleType)
is.factor(basics_data$titleType)
sum(is.na(basics_data$titleType))

#Handle missing values for endYear as using current year
current_year <- as.numeric(format(Sys.Date(), "%Y"))

clean_data <- clean_data %>% 
  mutate(endYear = as.numeric(replace(endYear, endYear == '\\N', NA))) %>%
  mutate(endYear = ifelse(is.na(endYear), current_year, endYear))

# ---- Handle Duplicates ----
# Check for and Handle duplicates
clean_data <- clean_data %>%
  distinct(tconst, .keep_all = TRUE)

# ---- Feature Engineering: Creating new variables ----
# Create neccesary variables
clean_data <- clean_data %>%
  # 1. Seasonal trends: avg_rating_per_season
  group_by(seasonNumber, parentTconst) %>%
  mutate(avg_rating_per_season = mean(averageRating, na.rm =TRUE)) %>%
  ungroup() %>%
  #3. TV show lifetime
  mutate(tv_show_lifetime = endYear - startYear) %>%
  #4. Total number of ratings per TV Series
  group_by(parentTconst) %>%
  mutate(total_ratings_TV_Series = sum(numVotes, na.rm = TRUE)) %>%
  ungroup()

# ---- Output ----
#Save the data as a CSV file
write.csv(clean_data, 'clean_data.csv', row.names = FALSE)
