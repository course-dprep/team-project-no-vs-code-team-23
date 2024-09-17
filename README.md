# Unveiling the Evolution of Horror TV Series Ratings: A Dive into IMDb Trends

In this project, we explore how IMDb ratings for horror TV Series change as
shows progress through their seasons. Our analyses delve into the trends of
ratings over time, comparing different TV Series in the Horror Genre.

We explore the volume of Ratings fluctuating with each season, providing
insights on these series' popularity and viewer engagement. This analysis
is valuable for fans, critics, and industry professionals looking to understand
how the reception of horror TV series develops over time. By highlighting these
trends, we offer actionable information to help producers decide
about TV series production and viewer engagement strategies.

## Research question
“*Do Horror TV series episodes tend to receive higher or lower IMDb ratings as
a show progresses through its seasons?*" 

## Research Method
The research method includes several steps. First, a descriptive
statistics analysis is performed. This is crucial as it gives simple
insights into the data for any patterns and/or trends. It is helpful for
the research as it allows us to have a quick overview of how the ratings
change over the seasons of TV series. We will calculate the average
ratings per season.

Second, our approach combines regression analysis to model the relationship
between ratings and seasons with time series analysis to observe trends and
patterns over time. This integrated methodology provides a comprehensive view
of how the reception of horror TV series develops, offering valuable insights
for fans, critics, and industry professionals. Understanding these trends can
guide decisions related to TV series production and viewer engagement
strategies.

### Analysis Overview

1. **Regression Analysis**: We use regression techniques to model and predict
how ratings vary with each new season of horror TV series.
2. **Time Series Analysis**: We apply time series methods to examine temporal
trends and patterns in the ratings over time, highlighting how viewer
engagement changes with the progression of seasons.

Listed below are the variables needed specifically for this research and their
description:

## Combined Variable Descriptions

The table below summarizes all the variables used in our analysis, detailing their source datasets and descriptions.

| Dataset             | Variable Name   | Description                                      |
|---------------------|-----------------|--------------------------------------------------|
| **title.episode.tsv.gz** | `tconst`   | Unique identifier for the episode               |
|                     | `parentTconst`  | Identifier for the parent TV series             |
|                     | `seasonNumber`  | Season number of the episode                    |
|                     | `episodeNumber` | Episode number within the season                |
| **title.ratings.tsv.gz** | `tconst`   | Unique identifier for the title                 |
|                     | `averageRating` | Weighted average of all the individual user ratings |
|                     | `numVotes`      | Number of votes the title has received          |
| **title.basics.tsv.gz** | `tconst`    | Unique identifier for the title                 |
|                     | `titleType`     | Type of title (e.g., movie, short, tvseries)    |
|                     | `primaryTitle`  | Primary title used for promotional materials    |
|                     | `originalTitle` | Original title in the original language         |
|                     | `startYear`     | Release year of the title or TV series start year |
|                     | `endYear`       | End year of TV series or '\N' for non-series titles |
|                     | `runtimeMinutes`| Primary runtime of the title, in minutes         |
|                     | `genres`        | Array of genres associated with the title        |

To get the datasets, you can follow the following links:
- url_episodes <- "https://datasets.imdbws.com/title.episode.tsv.gz"
- url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"
- url_basics <- "https://datasets.imdbws.com/title.basics.tsv.gz"

## Repository Overview - TO BE DONE

## Dependencies
- R. [Installation guide](https://tilburgsciencehub.com/building-blocks/configure-your-computer/statistics-and-computation/r/).
- Make. [Installation guide](https://tilburgsciencehub.com/building-blocks/configure-your-computer/automation-and-workflows/make/).
- To knit RMarkdown documents, make sure you have installed Pandoc using the [installation guide](https://pandoc.org/installing.html) on their website.

# Make sure that you have installed all necessary R packages for this research:
```
install.packages(dplyr)
install.packages(tidyr)
install.packages(readr)
install.packages(ggplot2)
install.packages(lubridate)
install.packages(rmarkdown)
install.packages(knitr)
```
## Authors
Team 6:
- [Maria Yolovska](https://github.com/myolovska),    email: m.d.yolovska@tilburguniversity.edu
- [Nicole Nikolova](https://github.com/nikolnikolovan),    email: n.nikolova@tilburguniversity.edu
- [Noah Bouwhuis](https://github.com/Balboa57),    email: n.bouwhuis@tilburguniversity.edu

# Deliverable 2 - 2.1. Data Exploration

``` {r, echo= FALSE}
options(repos = c(CRAN = "https://cloud.r-project.org/"))
```
```r
install.packages("readr")
```

    ## 
    ##   There is a binary version available but the source version is later:
    ##       binary source needs_compilation
    ## readr  2.1.4  2.1.5              TRUE

    ## installing the source package 'readr'

``` {r, echo = TRUE}
library(readr)
```

``` {r, echo = TRUE}
# URLs for the datasets needed in this research
url_episodes <- "https://datasets.imdbws.com/title.episode.tsv.gz"
url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"
url_basics <- "https://datasets.imdbws.com/title.basics.tsv.gz"
```
```{r, echo = TRUE}
# Download the files
download.file(url_episodes, destfile = "title.episode.tsv.gz")
download.file(url_ratings, destfile = "title.ratings.tsv.gz")
download.file(url_basics, destfile = "title.basics.tsv.gz")
list.files()
```
```{r, echo = TRUE}
# Load the datasets
episode_data <- read_tsv("title.episode.tsv.gz")
ratings_data <- read_tsv("title.ratings.tsv.gz")
basics_data <- read_tsv("title.basics.tsv.gz")
```
``` {r, echo = TRUE}
summary(episode_data)
```
``` {r,echo = TRUE}
summary(ratings_data)
```
```{r, echo = TRUE}
summary(basics_data)
```
## Variable descriptions for “title.episode.tsv.gz”

| Variable Name   | Description                         |
|-----------------|-------------------------------------|
| `tconst`        | Unique identifier for the episode   |
| `parentTconst`  | Identifier for the parent TV series |
| `seasonNumber`  | Season number                       |
| `episodeNumber` | Episode number within the season    |

## Variabel description for “title.ratings.tsv.gz”

| Variable Name   | Description                                         |
|-----------------|-----------------------------------------------------|
| `tconst`        | Unique identifier for the title                     |
| `averageRating` | Weighted average of all the individual user ratings |
| `numVotes`      | Number of votes the title has received              |


## Variable Descriptions for "title.basics.tsv.gz"

| Variable Name   | Description                                             |
|-----------------|---------------------------------------------------------|
| `tconst`        | Alphanumeric unique identifier of the title             |
| `titleType`     | Type of the title (e.g., movie, short, tvseries, etc.)   |
| `primaryTitle`  | More popular title / promotional title                  |
| `originalTitle` | Original title in the original language                 |
| `isAdult`       | Whether the title is for adults (0: non-adult, 1: adult)|
| `startYear`     | Release year of the title (or series start year)        |
| `endYear`       | End year for TV series (or NA for non-series)         |
| `runtimeMinutes`| Primary runtime of the title, in minutes                |
| `genres`        | Up to three genres associated with the title            |

## To further explore our data let's take a look at which horror movie has the most ratings for 2024 and has more than 1 season:
```{r, echo=TRUE}
install.packages("ggplot2")
install.packages("dplyr")
library(dplyr)
library(readr)
horror_tv_series <- basics_data %>%
  filter(grepl("\\bHorror\\b", genres)) %>%
  filter(titleType == "tvSeries")
season_counts <- episode_data %>%
  group_by(parentTconst) %>%
  summarize(numSeasons = max(seasonNumber, na.rm = TRUE))
horror_tv_series_with_seasons <- horror_tv_series %>%
  left_join(season_counts, by = c("tconst" = "parentTconst"))
horror_tv_series_multiple_seasons <- horror_tv_series_with_seasons %>%
  filter(numSeasons > 1)
horror_tv_series_with_ratings <- horror_tv_series_multiple_seasons %>%
  inner_join(ratings_data, by = "tconst")
most_rated_horror_tv_series <- horror_tv_series_with_ratings %>%
  arrange(desc(numVotes)) %>%
  slice(1)
most_rated_horror_tv_series

```
## Trend Analysis: Ratings of "Stranger Things" over its seasons
``` {r, echo = TRUE}
library(ggplot2)
stranger_things <- basics_data %>%
  filter(primaryTitle == "Stranger Things")

## Get the episodes of Stranger Things
stranger_things_episodes <- episode_data %>%
  filter(parentTconst == stranger_things$tconst)

## Join with ratings data
stranger_things_ratings <- ratings_data %>%
  inner_join(stranger_things_episodes, by = "tconst")

## Add episode information to the dataset
stranger_things_ratings <- stranger_things_ratings %>%
  left_join(stranger_things_episodes %>%
              select(tconst, seasonNumber, episodeNumber),
            by = "tconst")
stranger_things_ratings <- stranger_things_ratings %>%
  mutate(
    releaseDate = as.Date(paste0("2024-", seasonNumber.x, "-", episodeNumber.x), format="%Y-%m-%d"),
    year = as.numeric(format(releaseDate, "%Y")),
    month = as.numeric(format(releaseDate, "%m"))
  )

stranger_things_ratings <- stranger_things_ratings %>%
  filter(!is.na(releaseDate))
ratings_by_season <- stranger_things_ratings %>%
  group_by(seasonNumber.x) %>%
  summarize(mean_rating = mean(averageRating, na.rm = TRUE))
stranger_things_ratings <- stranger_things_ratings %>%
  mutate(seasonNumber.x = as.factor(seasonNumber.x))

stranger_things_ratings <- stranger_things_ratings %>%
  filter(!is.na(seasonNumber.x)) %>%
  mutate(seasonNumber.x = as.factor(seasonNumber.x))

stranger_things_ratings %>%
  summary()
ggplot(stranger_things_ratings, aes(x = releaseDate, y = averageRating)) +
  geom_line(aes(color = seasonNumber.x), show.legend = FALSE) +
  geom_point(aes(color = seasonNumber.x), show.legend = FALSE) +
  facet_wrap(~ seasonNumber.x, scales = "free_x") +
  labs(
    title = "IMDb Ratings for Stranger Things by Season",
    x = "Release Date",
    y = "Average Rating"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

```
