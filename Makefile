
# #  Makefile for data preparation and analysis in R

# # Define the Rscript command
# Rscript = Rscript

# # Define the input and output files
# FILTERED_DATA = src/prep/filtered_data.csv
# CLEANED_DATA = src/prep/cleaned_data.csv
# PLOTS = src/analysis/Rplots.pdf

# # Default target
# all: $(FILTERED_DATA) $(CLEANED_DATA) $(PLOTS)

# # Target to run Exploration_Data.R
# $(FILTERED_DATA): src/prep/Exploration_Data.R
# 	$(Rscript) src/prep/Exploration_Data.R

# # Target to run Preparation_Data.R
# $(CLEANED_DATA): $(FILTERED_DATA) src/prep/Preparation_Data.R
# 	$(Rscript) src/prep/Preparation_Data.R

# # Target to run Analysis_Data.R
# $(PLOTS): $(CLEANED_DATA) src/analysis/Analysis_Data.R
# 	$(Rscript) src/analysis/Analysis_Data.R

# # Clean target
# clean:
# 	rm -f $(FILTERED_DATA) $(CLEANED_DATA) $(PLOTS)

# #############################

# Define the Rscript command
Rscript = Rscript

# Define the input and output files
MERGED_DATA = src/prep/merged_data.csv
FILTERED_DATA = src/prep/filtered_data.csv
CLEANED_DATA = src/prep/cleaned_data.csv
PLOTS = src/analysis/Rplots.pdf

# Default target
all: $(FILTERED_DATA) $(CLEANED_DATA) $(PLOTS)

# Target to run data.R
$(MERGED_DATA): data\data.R
	$(Rscript) data\data.R

# Target to run Exploration_Data.R
$(FILTERED_DATA): $(MERGED_DATA) src/prep/Exploration_Data.R
	$(Rscript) src/prep/Exploration_Data.R

# Target to run Preparation_Data.R
$(CLEANED_DATA): $(FILTERED_DATA) src/prep/Preparation_Data.R
	$(Rscript) src/prep/Preparation_Data.R

# Target to run Analysis_Data.R
$(PLOTS): $(CLEANED_DATA) src/analysis/Analysis_Data.R
	$(Rscript) src/analysis/Analysis_Data.R

# Clean target
clean:
	rm -f $(MERGED_DATA) $(FILTERED_DATA) $(CLEANED_DATA) $(PLOTS)
