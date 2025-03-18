library(tidyverse)
if (!require(plotly)) install.packages('plotly')
if (!require(shiny)) install.packages('tidyverse')

# Load the necessary libraries
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(plotly)
# Get the world map data
world_map <- ne_countries(scale = "medium", returnclass = "sf") |>
  filter(name != "Antarctica")
renewable_grow <- read.csv("annual-percentage-change-renewables.csv") |>
  filter(Code != "NA") 

renewable_grow$Renewables....growth. <- round(renewable_grow$Renewables....growth.,2)

renewable_plot <- function(region, year) {
  # Ensure region is not NULL or empty
  if (is.null(region) || region == "") {
    stop("Region input is missing or invalid.")
  }
  renewable_grow22 <- renewable_grow |>
    filter(Year == year)
  
  renewable_grow_map22 <- left_join(world_map,renewable_grow22,
                                    
                                    c( "iso_a3_eh"= "Code")) |>
    rename( "growth" = "Renewables....growth.")
  
  if (region == "World") {
    
  } else if (region == "North America" | region == "Latin America & Caribbean") {
    renewable_grow_map22 <- filter(renewable_grow_map22, region_wb == region)
  }
  else {renewable_grow_map22 <- filter(renewable_grow_map22, region_un == region )}
  
  
  p <- ggplot(data = renewable_grow_map22) +
    geom_sf( aes( fill = growth + runif(nrow(renewable_grow_map22),min = 0, max = 0.001), text = paste("</b>",admin,"</b>\n growth rate:",signif(growth,3),"%")), color = "black")+
    #scale_fill_manual("", values = my_colors)+
    labs(
      title = paste("Annual percentage change in renewable energy generation in", year),
      fill = "Growth %") +
    scale_fill_continuous(low = "red", high = "green", limits = c(-50, 50), guide = guide_colorbar(direction = "horizontal", ticks = TRUE, nbin = 50, barwidth = 10, barheight = 1, label.position = "bottom", title.position = "top", title.hjust = 0.5)) +
    theme_map() 
  #scale_fill_continuous(low = "red", mid = "white", high = "blue", labels = scales::percent)
  
  ggplotly(p, tooltip = "text") |>
    style(hoveron = "fills")
  
}

energy_gen <- read.csv("modern-renewable-prod.csv") 

egen_plot <- function(region, year_dat) {
  # Ensure region is not NULL or empty
  if (is.null(region) || region == "") {
    stop("Region input is missing or invalid.")
  }
  energy_gen_spec_line <- energy_gen |>
    filter(Entity == region & Year <= year_dat) |>
    rename( "Wind"="Electricity.from.wind...TWh" ,"Hydro" = "Electricity.from.hydro...TWh", "Solar" = "Electricity.from.solar...TWh","Other"  = "Other.renewables.including.bioenergy...TWh")
  energy_gen_spec_point <- energy_gen_spec_line |>
    pivot_longer(cols = c(Hydro, Wind, Solar, Other), names_to = "sources",
                 values_to = "Energy" )
  
  p <- ggplot()  +
    geom_line(data = energy_gen_spec_line,aes(x = Year, y = Wind), color = "purple") + 
    geom_line(data = energy_gen_spec_line,aes(x = Year, y = Hydro), color = "pink") +
    geom_line(data = energy_gen_spec_line,aes(x = Year, y = Solar), color = "green") +
    geom_line(data = energy_gen_spec_line,aes(x = Year, y = Other), color = "chartreuse4") +
    geom_point(data = energy_gen_spec_point, aes(x = Year, y = Energy, color = sources, text = paste("</b>Generated Energy",signif(Energy,2)," TWh","</b>\n Year:", Year)), size = 2) +
    theme_minimal() +
    scale_y_continuous(breaks = seq(0, 1000, by = 200), labels = paste(seq(0, 1000, by = 200), "TWh"))
  
  
  ggplotly(p, tooltip = "text") |>
    style(hoveron = "fill")
  
  
  
}

# Define the region variable with valid choices
region <- c("World", "North America", "Latin America & Caribbean", "Europe", "Asia", "Africa", "Oceania")

ui <- fluidPage(
  titlePanel("Renewable Energy Dashboard"),
  
  # Create separate tabs and inputs for plotting
  tabsetPanel(
    id = "tab",
    tabPanel(title = "Renewable Plot", value = "growth",
             fluidRow(
               column(8, sidebarPanel(
                 selectInput("region", "Select Region:", choices = region, selected = "World"),
                 sliderInput("year", "Select Year:", min = 1956, max = 2022, value = 2022)
               )),
               column(12, plotlyOutput("renewable_plot"))
             )
    ),
    tabPanel(
      title = "Energy Generation Plot", value = "electricity",
      fluidRow(
        column(8, sidebarPanel(
          selectInput("area", "Select Region:", choices = unique(energy_gen$Entity), selected = unique(energy_gen$Entity)[1]),
          sliderInput("Year", "Select Year:", min = min(energy_gen$Year, na.rm = TRUE), max = max(energy_gen$Year, na.rm = TRUE), value = max(energy_gen$Year, na.rm = TRUE))
        )),
        column(12, plotlyOutput("egen_plot"))
      )
    )
  ),
  mainPanel(
    h3(textOutput("TitleText")),
    h5(textOutput("SubtitleText"))
  )
)

server <- function(input, output) {
  # Render renewable_plot
  output$renewable_plot <- renderPlotly({
    validate(
      need(!is.null(input$region) && input$region != "", "Please select a valid region."),
      need(!is.null(input$year), "Please select a valid year.")
    )
    renewable_plot(input$region, input$year)
  })
  
  # Render egen_plot
  output$egen_plot <- renderPlotly({
    validate(
      need(!is.null(input$area) && input$area != "", "Please select a valid region."),
      need(!is.null(input$Year), "Please select a valid year.")
    )
    egen_plot(input$area, input$Year)
  })
  
  # RenderText
  output$TitleText <- renderText({
    if (!is.null(input$tab) && input$tab == "growth") {
      "Annual change in renewable energy generation"
    } else {
      "Modern renewable energy generation by source"
    }
  })
  output$SubtitleText <- renderText({
    if (!is.null(input$tab) && input$tab == "growth") {
      "Change in renewable energy generation relative to the previous year, measured in terawatt-hours and using the substitution method. It includes energy from hydropower, solar, wind, geothermal, wave and tidal, and bioenergy.\nLinks: https://ourworldindata.org/grapher/annual-change-renewables?tab=chart&yScale=log \n Data source: Energy Institute - Statistical Review of World Energy(2023) "
    } else {
      "Data source: Ember - Yearly Electricity Data (2023); Ember - European Electricity Review (2022); Energy Institute- Statistical Review of World Energy(2023).\nLinks: https://ourworldindata.org/grapher/modern-renewable-prod?country=~North+America+%28Ember%29"
    }
  })
}

# Run the app
shinyApp(ui, server)
