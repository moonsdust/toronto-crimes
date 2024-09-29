# High Number of Shootings and Homicides but Fewer Police Stations Around in Toronto Neighbourhoods

## Overview
Despite optimism in 2023 about gun violence continuing to decrease annually in Toronto, there was a sudden increase in gun violence at the beginning of 2024. This paper looks at patterns of where shootings and homicides occurred across all Toronto neighbourhoods alongside the location of police stations from 2018 to 2023. The results showed that the six neighbourhoods with the highest cases of shootings and homicides had below-average household income and smaller populations and there are fewer police stations around neighbourhoods with high numbers of shootings and homicides. These findings can inform where future police facilities can be built to ensure the safety of Toronto neighbourhoods, but further investigation is needed on how adding police facilities can impact crime cases in surrounding neighbourhoods over time.

## Important Notes
- Due to the formatting of the `geometry` columns for the "Police Facility Location" and "Neighbourhood Crime Rates" datasets, they were downloaded as geojson files instead of CSV files.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from the City of Toronto's Open Data Portal (Open Data Toronto).
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `other` contains sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

No LLMs were used for any aspect of this work.