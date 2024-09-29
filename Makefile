# Makefile for R project automation

# Define the R scripts
PREPARE = src/Data_preparation.R
EXPLORE = src/Data_exploration.R
ANALYZE = src/Data_analysis.R
DEPLOY = src/Data_deployment.R

# Define the data files
DATA_FILES = title.basics.tsv.gz title.episode.tsv.gz title.ratings.tsv.gz

# Define the targets
all: prepare explore analyze deploy

# Target to prepare data
prepare: $(DATA_FILES)
	Rscript $(PREPARE)

# Target to explore data
explore: prepare
	Rscript $(EXPLORE)

# Target to analyze data
analyze: explore
	Rscript $(ANALYZE)

# Target to deploy results
deploy: analyze
	Rscript $(DEPLOY)

# Clean target to remove any temporary files if needed (optional)
clean:
	rm -f output/*

# Phony targets
.PHONY: all prepare explore analyze deploy clean
