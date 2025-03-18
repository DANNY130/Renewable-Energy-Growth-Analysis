# Renewable Energy Growth Analysis

This repository contains a Shiny application for analyzing and visualizing the growth of renewable energy generation across different regions and over time. The application uses various datasets in CSV format and provides interactive plots using the `plotly` and `shiny` libraries in R.

## Folder Structure

- `Shiny.R`: The main R script that contains the Shiny application.
- `annual-percentage-change-renewables.csv`: Data file containing the annual percentage change in renewable energy generation.
- `modern-renewable-prod.csv`: Data file containing the production of modern renewable energy sources.

## Prerequisites

Make sure you have the following installed:
- R (version 4.0 or later)
- RStudio
- The necessary R packages: `tidyverse`, `plotly`, `shiny`, `rnaturalearth`, `rnaturalearthdata`, `ggplot2`, `dplyr`, and `ggthemes`.

You can install the required packages by running the following commands in your R console:
```r
install.packages(c('tidyverse', 'plotly', 'shiny', 'rnaturalearth', 'rnaturalearthdata', 'ggplot2', 'dplyr', 'ggthemes'))
