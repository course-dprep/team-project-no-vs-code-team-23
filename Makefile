all: data_exploration data_preparation data_analysis 

data_exploration:
	make -C src/prep/Exploration_Data.R

data_preparation:
	make -C src/prep/Preparation_Data.R

data_analysis:
	make -C src/analysis/Analysis_Data.R

# Clean target to remove any temporary files if needed (optional)
clean:
	rm -f output/*
