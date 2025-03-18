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
```

## How to Run the Application
1. Clone the Repo
   ```bash
   git clone https://github.com/DANNY130/Renewable-Energy-Growth-Analysis.git
   cd Renewable-Energy-Growth-Analysis
2. Open RStudio and navigate to the cloned repository directory.

3. Load the CSV Files: Ensure the CSV files (annual-percentage-change-renewables.csv and modern-renewable-prod.csv) are placed in the same directory as the Shiny.R file.

4. Run the Shiny Application: Open the Shiny.R file in RStudio and click the "Run App" button in the top right corner of the script editor.

## Application Features
- Renewable Plot: Visualizes the annual percentage change in renewable energy generation for different regions and years.
- Energy Generation Plot: Shows the production of modern renewable energy sources (Wind, Hydro, Solar, Other) over time for selected regions.

## Usage
Renewable Plot
- Select Region: Choose from "World", "North America", "Latin America & Caribbean", "Europe", "Asia", "Africa", "Oceania".
- Select Year: Use the slider to select the year for which you want to visualize the data.
Energy Generation Plot
- Select Region: Choose a specific region from the list of available regions in the dataset.
- Select Year: Use the slider to select the year range for which you want to visualize the data.
Data Sources
- Ember - Yearly Electricity Data (2023)
- Ember - European Electricity Review (2022)
- Energy Institute - Statistical Review of World Energy (2023)
- Our World in Data


Author
DANNY130
