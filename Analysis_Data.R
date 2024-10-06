# ---- Analysis of Horror TV Series IMDb Ratings ----
#Getting Ready
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(purrr)
library(stringr)
library(broom)

# ---- Input ----
clean_data <- read_csv('clean_data.csv')

# ---- Descriptive Statistics ----
# Summary statistics of ratings across all seasons
summary_stats <- clean_data %>%
  group_by(seasonNumber) %>%
  summarize(
    avg_rating = mean(averageRating, na.rm = TRUE),
    median_rating = median(averageRating, na.rm = TRUE),
    min_rating = min(averageRating, na.rm = TRUE),
    max_rating = max(averageRating, na.rm = TRUE),
    num_episodes = n()
  )

print(summary_stats)

# ---- Regression Analysis: Effect of Season Number on IMDb Rating ----
# Model the relationship between season number and average rating
rating_model <- lm(averageRating ~ seasonNumber, data = clean_data)

# Get a summary of the regression model
model_summary <- summary(rating_model)
print(model_summary)

# Visualizing the Regression Line
ggplot(clean_data, aes(x = seasonNumber, y = averageRating)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "blue") +
  labs(
    title = "Regression Analysis of IMDb Ratings over Seasons",
    x = "Season Number",
    y = "Average IMDb Rating"
  ) +
  theme_minimal()

# ---- Key metrics from Regression Analysis ----
#Coefficient for Season Number: 0.007999 
#Standard Error: 0.004079 
#t value: 1.961 
#p-value for Season Number Coefficient: 0.0499 
#R-squared: 0.0005603 
#Adjusted R-squared: 0.0004146 

# ---- Summary of our findings ----
#The effect of seasonNumber on averageRating is statistically significant, but the effect size is extremely small (an increase of 0.008 per season).
#The model's predictive power is very low (R-squared is close to zero), meaning that seasonNumber does not explain much of the variance in IMDb ratings.
#Although there's a small positive trend, it may not be practically meaningful.
# Description: This visualization provides an overview of how IMDb ratings vary over seasons for each horror series.



# ---- Regression by Series ----
# Creating Models for Each Series Separately
models_by_series <- filtered_data %>%
  group_by(parentTconst) %>%
  nest() %>%
  mutate(
    model = map(data, ~ lm(averageRating ~ seasonNumber, data = .x)),
    tidied = map(model, tidy)
  ) %>%
  unnest(tidied)
# Description: This step applies regression analysis to each horror series separately, allowing you to compare trends among different series.
# Print summary of models
models_by_series_filtered <- models_by_series %>%
  filter(!is.na(estimate))

print(models_by_series_filtered)

#Identify significant models
significant_models <- models_by_series_filtered %>%
  filter(term == "seasonNumber", p.value < 0.05) %>%
  arrange(p.value)

print(significant_models)
# This will give you a list of series where the season number significantly affects the ratings.

# ---- Summary of the lisat with models ----
#Series with negative coefficients (e.g., tt1844624, tt3743822, tt2761354) show a decline in ratings as seasons progress.
#Series with positive coefficients (e.g., tt1105711, tt0094578) show an increase in ratings over their seasons.



# ---- Time Series Analysis ----
# Aggregating the data by season
time_series_data <- clean_data %>%
  group_by(parentTconst, seasonNumber) %>%
  summarize(
    avg_season_rating = mean(averageRating, na.rm = TRUE),
    num_episodes = n()
  )
# Aggregate across all series to see general trends
aggregated_ratings <- time_series_data %>%
  group_by(seasonNumber) %>%
  summarize(avg_season_rating = mean(avg_season_rating, na.rm = TRUE))

# Plot the general trend over seasons
ggplot(aggregated_ratings, aes(x = seasonNumber, y = avg_season_rating)) +
  geom_line(color = "blue") +
  geom_point(color = "blue") +
  labs(
    title = "Average IMDb Ratings Over Seasons (All Series)",
    x = "Season Number",
    y = "Average IMDb Rating"
  ) +
  theme_minimal()

#---- Summary of Results ----
#There doesn’t appear to be a smooth increasing or decreasing trend over seasons. Instead, the ratings fluctuate, which could indicate that ratings are affected by multiple factors other than just the progression of seasons.
#Since this plot aggregates ratings across all series, it might obscure series-specific patterns. Certain series might have consistently increasing or decreasing trends that are averaged out in this plot.
#The sharp spikes and drops could result from certain series having fewer seasons or episodes, thus disproportionately influencing the average for some seasons.


# ---- Smoothing the plot to focus on the general trend without sharp fluctuations ----
ggplot(aggregated_ratings, aes(x = seasonNumber, y = avg_season_rating)) +
  geom_line(color = "blue") +
  geom_point(color = "blue") +
  geom_smooth(method = "loess", color = "red", se = FALSE) +  # Add a smoothing line
  labs(
    title = "Smoothed Average IMDb Ratings Over Seasons",
    x = "Season Number",
    y = "Average IMDb Rating"
  ) +
  theme_minimal()

#---- Results of Smoothing the plot ----
#Non-Linear Trend: The smoothed line indicates a non-linear relationship between season number and average rating. There is no simple upward or downward trend but rather a fluctuating pattern.
#Outlier Seasons: Some seasons show sharp changes in ratings, suggesting that particular series might be significantly better or worse in those seasons.


# ---- Further Data Enrichment ----
# Description: This step explores whether the number of words in the title of episodes or series has any correlation with IMDb ratings.
# Text Analysis: Extract Word Count of Titles to See Correlation with Ratings
clean_data <- clean_data %>%
  mutate(title_word_count = str_count(primaryTitle, "\\w+"))

# Correlation Between Title Word Count and Ratings
correlation_analysis <- lm(averageRating ~ title_word_count, data = clean_data)
summary(correlation_analysis)

# Visualization of Correlation
ggplot(clean_data, aes(x = title_word_count, y = averageRating)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Correlation Between Title Word Count and IMDb Ratings",
    x = "Word Count in Title",
    y = "Average IMDb Rating"
  ) +
  theme_minimal()
# ---- Summary of Results ----
#There is a statistically significant positive relationship between the number of words in a title and IMDb ratings, but the effect size is minimal. In practical terms, for each additional word in a title, the average rating increases slightly by 0.017.
#However, the low R-squared value indicates that title_word_count alone is not a strong predictor of averageRating. Most of the variation in ratings is explained by other factors not included in this simple model.


# ---- Save Processed Analysis Data ----
write.csv(summary_stats, "summary_statistics.csv")

