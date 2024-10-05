# Input = filtered_data
filtered_data <- read.csv("filtered_data.csv")

# Select only the necessary columns
clean_data <- filtered_data %>%
  select(tconst, parentTconst, seasonNumber, episodeNumber, titleType, primaryTitle, originalTitle, startYear, endYear, runtimeMinutes, genres, ave