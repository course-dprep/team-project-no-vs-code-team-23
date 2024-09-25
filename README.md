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
*Do Horror TV series episodes tend to receive higher or lower IMDb ratings as
a show progresses through its seasons?*

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
