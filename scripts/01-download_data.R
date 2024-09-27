#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto on the location
# of police facilities, neighbourhood crime rates, and the profiles of
# Toronto's 25 wards.
# Author: Emily Su
# Date: 21 September 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: 00-install_packages.R has been ran to install necessary
# packages.
# Any other information needed? -
# NOTE: This script was checked through lintr for styling

# Datasets to be downloaded and saved
# Ward Profiles (25-Ward Model):
# - https://open.toronto.ca/dataset/ward-profiles-25-ward-model/
# Police Facility Location
# - https://open.toronto.ca/dataset/police-facility-locations/
# Neighbourhood Crime Rates
# - https://open.toronto.ca/dataset/neighbourhood-crime-rates/

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(dplyr)
library(sf)

#### Download data ####
# Code to download data was adapted from:
# https://open.toronto.ca/dataset/neighbourhood-crime-rates/

# Function to download data
# Downloading geojson file due to the formatting of "geometry" column
download_geojson <- function(package_num) {
  files <- filter(list_package_resources(package_num),
                  tolower(format) %in% c("geojson"))
  return(filter(files, row_number() == 1) %>% get_resource())
}

# Download "Neighbourhood Crime Rates" Dataset
# crime_rates <- download_csv("neighbourhood-crime-rates")
crime_rates <- download_geojson("neighbourhood-crime-rates")

# Download "Police Facility Locations" Dataset
police_location <- download_geojson("9aeefa17-27e8-4dd9-b74d-80f7f9eb85ac")

# Download "Ward Profiles (25-Ward Model)"
ward_profiles <-
  filter(list_package_resources("6678e1a6-d25f-4dff-b2b7-aa8f042bc2eb"),
         row_number() == 1) |> get_resource()

#### Save data ####
# write_csv(crime_rates, "data/raw_data/raw_crime_rates.csv")
write_sf(crime_rates, "data/raw_data/raw_crime_rates.geojson")
write_sf(police_location, "data/raw_data/raw_police_location.geojson")
write_csv(as.data.frame(ward_profiles[1]),
          "data/raw_data/raw_ward_profiles.csv")
