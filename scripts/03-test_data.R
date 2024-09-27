#### Preamble ####
# Purpose: Tests cleaned datasets about crimes, police locations,
# and ward data. 
# Author: Emily Su
# Date: 26 September 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R, 01-download_data.R,
# and 02-data_cleaning.R to obtain cleaned datasets. 
# Any other information needed? -
# NOTE: This script was checked through lintr for styling

#### Workspace setup ####
library(tidyverse)
library(geojsonsf)

#### Read in data ####
cleaned_ward_data <-
  read_csv("data/analysis_data/cleaned_ward_data.csv", show_col_types = FALSE)
cleaned_crime_data <-
  geojson_sf("data/analysis_data/cleaned_crime_data.geojson")
cleaned_police_location <-
  geojson_sf("data/analysis_data/cleaned_police_location.geojson")

#### Test data ####

# Crime dataset: Data Validation / Tests
# 1. "year" contains years between 2018 to 2023
cleaned_crime_data$year |> min() == 2018
cleaned_crime_data$year |> max() == 2023

# 2. Made sure "hood_id" has neighbourhood id that is from 1 to 174
cleaned_crime_data$hood_id |> unique() %in% c(1:174)
cleaned_crime_data$hood_id |> min() == 1
cleaned_crime_data$hood_id |> max() == 174

# 3. "num_of_cases" has min greater than or equal to 0
cleaned_crime_data$num_of_cases |> min() >= 0

# 4. "population_2023" has min greater than or equal to 0
cleaned_crime_data$population |> min() >= 0

# 5. Check the classes
class(cleaned_crime_data$year) == "numeric"
class(cleaned_crime_data$num_of_cases) == "numeric"
class(cleaned_crime_data$hood_id) == "numeric"
class(cleaned_crime_data$homicide_or_shooting) == "character"
class(cleaned_crime_data$neighbourhood) == "character"
class(cleaned_crime_data$population_2023) == "numeric"

# Police location dataset: Data Validation / Tests
# Check the classes
class(cleaned_police_location$facility) == "character"

# cleaned_ward_data: Data Validation / Tests
# 1. Check if that are ward numbers from 1 to 25
cleaned_ward_data$ward_num |> unique() %in% c(1:25)
# 2. Check that average income is equal to or greater than 0 
cleaned_ward_data$avg_income |> min() >= 0
# 3. Check classes 
class(cleaned_ward_data$ward_num) == "numeric"
class(cleaned_ward_data$ward_name) == "character"
class(cleaned_ward_data$avg_income) == "numeric"