# Targets for different data processing steps
all: data_exploration data_preparation data_analysis 

# Target to run the data exploration R script
data_exploration:

	Rscript src/prep/Exploration_Data.R

# Target to run the data preparation R script
data_preparation:
	Rscript src/prep/Preparation_Data.R


# Target to run the data analysis R script
data_analysis:
	Rscript src/analysis/Analysis_Data.R

# Clean target to remove any temporary files if needed (optional)
clean:
	rm -f output/*
