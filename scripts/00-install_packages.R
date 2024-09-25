#### Preamble ####
# Purpose: Installs packages needed to run scripts and Quarto document
# Author: Emily Su
# Date: 21 September 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: -
# NOTE: This script was checked through lintr for styling

#### Workspace setup ####
## Installing packages (only needs to be done once per computer)
install.packages("tidyverse") # Contains data-related packages
install.packages("opendatatoronto") # Open Data Toronto API
install.packages("knitr") # To make tables
install.packages("janitor") # To clean datasets
install.packages("dplyr")
install.packages("ggplot2") # To make graphs
install.packages("lintr") # To check styling of code
install.packages("styler") # To style code
install.packages("geojsonsf") 
install.packages("sf")