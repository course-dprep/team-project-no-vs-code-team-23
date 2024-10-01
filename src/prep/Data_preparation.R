#Input
episode_data <- read_tsv('cleaned_episode_data')
ratings_data <- read_tsv('cleaned_ratings_data')
basics_data <- read_tsv('cleaned_basics_data')
head(basics_data)

#Task 2

#merging the datasets
merged_data <- episode_data %>%
  inner_join(basics_data, by = "tconst") %>%
  inner_join(ratings_data, by = "tconst")


#filtering neccesary columns
# I don't know which columns are deemed necessary. Here is the code to select columns that are needed.
# merged_data <- merged_data %>%
#   select(tconst, primaryTitle, startYear, endYear, genres, averageRating, numVotes, parentTconst, seasonNumber, episodeNumber) # just fill in the columns that we need

# Task 3
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

# Task 5: Perform calculations before converting to Date objects
cleaned_data <- cleaned_data %>%
  # Ensure endYear is numeric and handle NA values
  mutate(endYear = as.numeric(replace(endYear, endYear == "\\N", NA))) %>%
  
  # 1. Seasonal trends: avg_rating_per_season
  group_by(seasonNumber, parentTconst) %>%
  mutate(avg_rating_per_season = mean(averageRating, na.rm = TRUE)) %>%
  ungroup() %>%
  
  # 2. Episode popularity: ratings_per_episode
  mutate(ratings_per_episode = numVotes) %>%
  
  # 3. Year-based analysis: startYear already exists
  
  # 4. TV show lifetime: Handle NA in endYear
  mutate(tv_show_lifetime = ifelse(
    is.na(endYear),
    as.numeric(format(Sys.Date(), "%Y")) - startYear,
    endYear - startYear
  )) %>%
  
  # 5. Total number of ratings per TV Series
  group_by(parentTconst) %>%
  mutate(total_ratings_per_series = sum(numVotes, na.rm = TRUE)) %>%
  ungroup()

# Task 7: Convert startYear and endYear to Date objects without overwriting
cleaned_data <- cleaned_data %>%
  # Create new Date variables
  mutate(
    startDate = as.Date(paste(startYear, "01", "01", sep = "-")),
    endDate = as.Date(paste(endYear, "01", "01", sep = "-"))
  )

# Optional: Check for invalid years and filter them out
cleaned_data <- cleaned_data %>%
  filter(startYear >= 1900, startYear <= as.numeric(format(Sys.Date(), "%Y")))

# Now, if you need to calculate durations using Date objects, use the new variables
cleaned_data <- cleaned_data %>%
  mutate(
    tv_show_lifetime_years = as.numeric(difftime(
      ifelse(is.na(endDate), Sys.Date(), endDate),
      startDate,
      units = "days"
    )) / 365.25
  )