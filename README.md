# FloodRisk-AI: Flood Risk Detection Dashboard

## Project Overview
FloodRisk-AI is a flood risk detection dashboard developed using R and Shiny for the Data Science Using R course. It displays flood-risk information for selected areas of Mumbai using rainfall, water-level, and risk-category data.

## Features
- Interactive flood risk map of Mumbai
- Rainfall and water-level visualizations
- Flood risk category analysis
- Rule-based flood risk prediction
- Data table and CSV report download

## Technologies Used
- R
- Shiny
- shinydashboard
- Plotly
- Leaflet
- DT

## Project Files
- `app/app.R` — Shiny dashboard application
- `app/mumbai_flood_data.csv` — sample dataset

## How to Run
1. Install R and RStudio.
2. Install the required packages:
   `install.packages(c("shiny", "shinydashboard", "plotly", "leaflet", "DT"))`
3. Open RStudio and set the project directory.
4. Run the app using:
   `shiny::runApp("app")`

## Data Note
The dataset contains illustrative sample data and should not be treated as real-time flood measurements or official flood predictions.


