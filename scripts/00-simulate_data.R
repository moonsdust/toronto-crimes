#### Preamble ####
# Purpose: Simulates data sets pertaining to crimes and police locations
# Author: Emily Su
# Date: 26 September 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R prior to install
# necessary packages.
# Any other information needed? -
# NOTE: This script was checked through lintr for styling

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(646)

# Global variables
population_of_toronto <- 2930000
num_of_neighbourhood_ids <- 174
num_of_neighbourhoods <- 158

# Dataset 1: Crime dataset
# Expected Columns: year | neighbourhood | hood_id | num_shootings
# (more columns) | num_homicides | population

simulated_dataset_1 <- tibble(
  # Create a vector for the years We will create a vector for the years 2018
  # to 2023 and repeat this 158 times (to represent each neighbourhood)
  year = rep(c(1:6 + 2017), num_of_neighbourhoods),
  # Generate 158 unique neighbourhood names
  neighbourhood =
    rep(paste(rep("neighbourhood", size = num_of_neighbourhoods),
              sample(x = 1:num_of_neighbourhoods, size = num_of_neighbourhoods,
                     replace = FALSE), sep = " "), 6),
  # Generate hood_id
  hood_id =
    as.numeric(rep(sample(x = 1:num_of_neighbourhood_ids,
                          size = num_of_neighbourhoods,
                          replace = FALSE), 6)),
  # Create 6 * num_of_neighbourhoods random values from uniform distribution
  # to get number of shootings each year per neighbourhood
  num_shootings = round(runif(n = 6 * num_of_neighbourhoods, min = 0,
                              max = 100)),
  # Randomize number of homicides
  num_homicides = round(runif(n = 6 * num_of_neighbourhoods,
                              min = 0, max = 100)),
  # Randomize population size
  population =
    rep(round(sample(x = 0:population_of_toronto / num_of_neighbourhoods,
                     size = num_of_neighbourhoods, replace = FALSE)), 6),
  # Generate geometry
  geometry = paste("MULTIPOINT", "{",
                   sample(x = 0:1000, size = 6 * num_of_neighbourhoods,
                          replace = TRUE), "}")
)

# Dataset 1: Data Validation / Tests
# 1. "year" contains years between 2018 to 2023
simulated_dataset_1$year |> min() == 2018
simulated_dataset_1$year |> max() == 2023

# 2. Made sure "hood_id" has neighbourhood id that is from 1 to 174
simulated_dataset_1$hood_id |> unique() %in% c(1:174)
simulated_dataset_1$hood_id |> min() == 1
simulated_dataset_1$hood_id |> max() == 174

# 2. Check that there are 158 neighbourhoods
simulated_dataset_1$neighbourhood |> n_distinct() == 158

# 3. "num_shootings" has min greater than or equal to 0
simulated_dataset_1$num_shootings |> min() >= 0

# 4. "num_homicides" has min greater than or equal to 0
simulated_dataset_1$num_homicides |> min() >= 0

# 5. "population" has min greater than or equal to 0
simulated_dataset_1$population |> min() >= 0

# 6. Check the classes
class(simulated_dataset_1$year) == "numeric"
class(simulated_dataset_1$neighbourhood) == "character"
class(simulated_dataset_1$hood_id) == "numeric"
class(simulated_dataset_1$num_shootings) == "numeric"
class(simulated_dataset_1$num_homicides) == "numeric"
class(simulated_dataset_1$population) == "numeric"
class(simulated_dataset_1$geometry) == "character"


# Dataset 2: Police Facility dataset
# Expected Columns: facility | geometry
simulated_dataset_2 <- tibble(
  # Generate Facility Name
  facility = paste(c(1:25), "division"),
  # Generate geometry
  geometry = paste("MULTIPOINT", "{", sample(x = 0:1000, size = 25,
                                             replace = TRUE), "}")
)

# Dataset 2: Data Validation / Tests
# Check the classes
class(simulated_dataset_2$facility) == "character"
class(simulated_dataset_1$geometry) == "character"
