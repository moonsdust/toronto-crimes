#### Preamble ####
# Purpose: Cleans the unedited ward profile data, unedited police location
# data, and unedited data on neighbourhood crime rates.
# Author: Emily Su
# Date: 21 September 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-install_packages.R and 01-download_data.R
# have been ran to install necessary packages and download datasets.
# Any other information needed? -
# NOTE: This script was checked through lintr for styling

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)
library(geojsonsf)
library(sf)

#### Clean data ####
raw_ward_profiles_data <-
  read_csv("data/raw_data/raw_ward_profiles.csv", show_col_types = FALSE)
raw_crime_rates_data <-
  geojson_sf("data/raw_data/raw_crime_rates.geojson")
raw_police_location_data <-
  geojson_sf("data/raw_data/raw_police_location.geojson")

# Dataset 1 (Ward Profiles Dataset)
# Expected columns: ward_num | ward_name | avg_income
# Clean column names
cleaned_ward_data <- raw_ward_profiles_data |> clean_names()

# Get row that contains the average household income
cleaned_ward_data <-
  cleaned_ward_data |>
  filter(x2021_one_variable_city_of_toronto_profiles ==
           "Average total income of households in 2020 ($)")
# Convert row to a column
cleaned_ward_data <-
  cleaned_ward_data |>
  # Code snippet to convert to a 1-column matrix and then to a vector
  # was adapted from the following:
  # https://www.geeksforgeeks.org/convert-matrix-to-vector-in-r/
  t() |> # Convert 1-row matrix into a 1-column matrix
  c() |> # Convert to a vector
  tibble() |> # Change into a tibble
  slice(-1) |> # Remove the first row
  slice(-1) |>
  rename( # Left side is the new name and the right side is the old name
    avg_income = "c(t(cleaned_ward_data))"
  ) |>
  mutate(
    ward_num = c(1:25),
    ward_name = c("Etobicoke North",
                  "Etobicoke Centre",
                  "Etobicoke-Lakeshore",
                  "Parkdale-High Park",
                  "York South-Weston",
                  "York Centre",
                  "Humber River-Black Creek",
                  "Eglinton-Lawrence",
                  "Davenport",
                  "Spadina-Fort York",
                  "University-Rosedale",
                  "Toronto-St. Paul’s",
                  "Toronto Centre",
                  "Toronto-Danforth",
                  "Don Valley West",
                  "Don Valley East",
                  "Don Valley North",
                  "Willowdale",
                  "Beaches-East York",
                  "Scarborough Southwest",
                  "Scarborough Centre",
                  "Scarborough-Agincourt",
                  "Scarborough North",
                  "Scarborough-Guildwood",
                  "Scarborough-Rouge Park")
  )

# Convert columns from character to numeric
cleaned_ward_data$avg_income <- as.numeric(cleaned_ward_data$avg_income)

# Switch order of columns
cleaned_ward_data <-
  cleaned_ward_data |>
  select(ward_num, ward_name, avg_income)

# Dataset 2 (Crime rates dataset)
# Expected columns: year | neighbourhood | hood_id | population_2023
# more columns | homicide_or_shooting | num_of_cases | geometry

# Clean column names
cleaned_crime_data <- raw_crime_rates_data |> clean_names()

# Select columns
cleaned_crime_data <-
  cleaned_crime_data |>
  select(area_name, hood_id, population_2023, homicide_2018, homicide_2019,
         homicide_2020, homicide_2021, homicide_2022, homicide_2023,
         shooting_2018, shooting_2019, shooting_2020, shooting_2021,
         shooting_2022, shooting_2023, geometry)

# Convert all cases columns to numeric
cleaned_crime_data$homicide_2018 <- as.numeric(cleaned_crime_data$homicide_2018)
cleaned_crime_data$homicide_2019 <- as.numeric(cleaned_crime_data$homicide_2019)
cleaned_crime_data$homicide_2020 <- as.numeric(cleaned_crime_data$homicide_2020)
cleaned_crime_data$homicide_2021 <- as.numeric(cleaned_crime_data$homicide_2021)
cleaned_crime_data$homicide_2022 <- as.numeric(cleaned_crime_data$homicide_2022)
cleaned_crime_data$homicide_2023 <- as.numeric(cleaned_crime_data$homicide_2023)

cleaned_crime_data$shooting_2018 <- as.numeric(cleaned_crime_data$shooting_2018)
cleaned_crime_data$shooting_2019 <- as.numeric(cleaned_crime_data$shooting_2019)
cleaned_crime_data$shooting_2020 <- as.numeric(cleaned_crime_data$shooting_2020)
cleaned_crime_data$shooting_2021 <- as.numeric(cleaned_crime_data$shooting_2021)
cleaned_crime_data$shooting_2022 <- as.numeric(cleaned_crime_data$shooting_2022)
cleaned_crime_data$shooting_2023 <- as.numeric(cleaned_crime_data$shooting_2023)

# Replace N\A with 0
# Reference:
# https://stackoverflow.com/questions/8161836/
# how-do-i-replace-na-values-with-zeros-in-an-r-dataframe
cleaned_crime_data[is.na(cleaned_crime_data)] <- 0

# Transform columns about crime numbers to get num_shootings and
# num_homicide columns
cleaned_crime_data <-
  cleaned_crime_data |>
  # Reference: https://gistlib.com/r/convert-columns-into-rows-in-r
  pivot_longer(cols = c(homicide_2018, homicide_2019,
                        homicide_2020, homicide_2021, homicide_2022,
                        homicide_2023, shooting_2018, shooting_2019,
                        shooting_2020, shooting_2021, shooting_2022,
                        shooting_2023), names_to = "homicide_or_shooting",
               values_to = "num_of_cases")

# Add year column
cleaned_crime_data <-
  cleaned_crime_data |>
  mutate(
    year = case_when(
      (homicide_or_shooting == "homicide_2018") ~ 2018,
      (homicide_or_shooting == "homicide_2019") ~ 2019,
      (homicide_or_shooting == "homicide_2020") ~ 2020,
      (homicide_or_shooting == "homicide_2021") ~ 2021,
      (homicide_or_shooting == "homicide_2022") ~ 2022,
      (homicide_or_shooting == "homicide_2023") ~ 2023,
      (homicide_or_shooting == "shooting_2018") ~ 2018,
      (homicide_or_shooting == "shooting_2019") ~ 2019,
      (homicide_or_shooting == "shooting_2020") ~ 2020,
      (homicide_or_shooting == "shooting_2021") ~ 2021,
      (homicide_or_shooting == "shooting_2022") ~ 2022,
      (homicide_or_shooting == "shooting_2023") ~ 2023,
      TRUE ~ 0
    )
  )

# Update values in homicide_or_shooting column
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "homicide_2018",
              "homicide")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "homicide_2019",
              "homicide")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "homicide_2020",
              "homicide")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "homicide_2021",
              "homicide")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "homicide_2022",
              "homicide")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "homicide_2023",
              "homicide")

cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "shooting_2018",
              "shooting")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "shooting_2019",
              "shooting")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "shooting_2020",
              "shooting")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "shooting_2021",
              "shooting")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "shooting_2022",
              "shooting")
cleaned_crime_data$homicide_or_shooting <-
  str_replace(cleaned_crime_data$homicide_or_shooting, "shooting_2023",
              "shooting")

# Select the expected columns for this dataset
cleaned_crime_data <-
  cleaned_crime_data |>
  select(year, area_name, hood_id, population_2023,
         homicide_or_shooting, num_of_cases, geometry) |>
  # rename
  rename(
    "neighbourhood" = area_name
  )

# Dataset 3
# Expected Columns: facility | geometry
# Clean column names
cleaned_police_location <- raw_police_location_data |> clean_names()

# Select expected columns
cleaned_police_location <-
  cleaned_police_location |> select(facility, geometry)

#### Save data ####
# Save crime data as a geojson
write_sf(cleaned_crime_data, "data/analysis_data/cleaned_crime_data.geojson")
# Save ward profile data as a csv
write_csv(cleaned_ward_data, "data/analysis_data/cleaned_ward_data.csv")
# Save police location data as a geojson
write_sf(cleaned_police_location,
         "data/analysis_data/cleaned_police_location.geojson")
