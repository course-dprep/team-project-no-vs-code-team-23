# Input = filtered_data


cleaned_data <- filtered_data %>%
  # Removing unneccesary columns: primaryTitle/originalTitle, isAdult
  select(-primaryTitle, -isAdult) %>%
  # Identify missing values:
  # Step 1: Replace "\N" with NA
  mutate(across(everything(), ~ na_if(., "\\N")))
# Step 2: Count NA values in each column
na_counts <- filtered_data %>%
  summarize_all(~ sum(is.na(.)))
# View the NA counts for each column
na_counts

# Handle missing value

# Identify incorrectly formatted values

# Handle incorrectly formatted values

# Check for duplicates

# Handle duplicates

# Create neccesary variables

# Output = cleaned_data
