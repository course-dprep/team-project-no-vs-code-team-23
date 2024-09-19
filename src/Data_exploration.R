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

options(repos = c(CRAN = "https://cloud.r-project.org/"))
# URLs for the datasets needed in this research
url_episodes <- "https://datasets.imdbws.com/title.episode.tsv.gz"
url_ratings <- "https://datasets.imdbws.com/title.ratings.tsv.gz"
url_basics <- "https://datasets.imdbws.com/title.basics.tsv.gz"

# Download the files
download.file(url_episodes, destfile = "title.episode.tsv.gz")
download.file(url_ratings, destfile = "title.ratings.tsv.gz")
download.file(url_basics, destfile = "title.basics.tsv.gz")
list.files()

# Load the datasets
episode_data <- read_tsv("title.episode.tsv.gz")
ratings_data <- read_tsv("title.ratings.tsv.gz")
basics_data <- read_tsv("title.basics.tsv.gz")

summary(episode_data)
summary(ratings_data)
summary(basics_data)

