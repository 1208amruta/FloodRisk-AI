
library(shiny)
library(shinydashboard)
library(plotly)
library(leaflet)
library(DT)

# Illustrative demo data
# Load Mumbai flood dataset
locations <- read.csv("mumbai_flood_data.csv")

# Make column names compatible with the dashboard
locations$Rainfall <- locations$Rainfall_mm
locations$WaterLevel <- locations$WaterLevel_m
locations$Risk <- locations$FloodRisk

# Mumbai area coordinates for the illustrative map
coordinates <- data.frame(
  Area = c("Andheri", "Dadar", "Kurla", "Hindmata", "Chembur"),
  Latitude = c(19.1197, 19.0178, 19.0726, 19.0040, 19.0522),
  Longitude = c(72.8468, 72.8478, 72.8826, 72.8420, 72.8998)
)

locations <- merge(locations, coordinates, by = "Area")

risk_colors <- c(
  "LOW" = "#22c55e",
  "MODERATE" = "#facc15",
  "HIGH" = "#f97316",
  "CRITICAL" = "#ef4444"
)

ui <- dashboardPage(
  skin = "blue",
  
  dashboardHeader(
    title = "FloodRisk AI",
    titleWidth = 230
  ),
  
  dashboardSidebar(
    width = 230,
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard",
               icon = icon("dashboard")),
      menuItem("Flood Map", tabName = "map",
               icon = icon("map")),
      menuItem("Data Analysis", tabName = "analysis",
               icon = icon("chart-line")),
      menuItem("Model Prediction", tabName = "prediction",
               icon = icon("brain")),
      menuItem("Reports", tabName = "reports",
               icon = icon("file-alt"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        body, .content-wrapper, .right-side {
          background-color: #0b1220 !important;
          color: #e5e7eb !important;
        }
        .main-header .logo {
          background-color: #111c30 !important;
          color: #38bdf8 !important;
          font-weight: bold;
        }
        .main-header .navbar {
          background-color: #111c30 !important;
        }
        .main-sidebar {
          background-color: #111827 !important;
        }
        .sidebar-menu > li > a {
          color: #cbd5e1 !important;
        }
        .sidebar-menu > li.active > a {
          background-color: #1e293b !important;
          border-left-color: #38bdf8 !important;
        }
        .box {
          background-color: #111c30 !important;
          border-top: 2px solid #334155 !important;
          color: #e5e7eb !important;
        }
        .box-header {
          color: #e5e7eb !important;
        }
        .small-box {
          border-radius: 10px;
          overflow: hidden;
        }
        .content-header > h1 {
          color: #e5e7eb !important;
        }
        .form-control {
          background-color: #1e293b !important;
          color: #e5e7eb !important;
          border-color: #475569 !important;
        }
        .btn-primary {
          background-color: #0284c7 !important;
          border-color: #0284c7 !important;
        }
        .disclaimer {
          color: #94a3b8;
          font-size: 12px;
          padding: 10px 0;
        }
      "))
    ),
    
    tabItems(
      # DASHBOARD
      tabItem(
        tabName = "dashboard",
        
        h2("Flood Risk Overview"),
        
        fluidRow(
          valueBoxOutput("locations_box", width = 3),
          valueBoxOutput("rain_box", width = 3),
          valueBoxOutput("water_box", width = 3),
          valueBoxOutput("highrisk_box", width = 3)
        ),
        
        fluidRow(
          box(
            title = "Rainfall vs Water Level",
            width = 8,
            status = "primary",
            solidHeader = FALSE,
            plotlyOutput("overview_chart", height = 300)
          ),
          box(
            title = "Risk Distribution",
            width = 4,
            status = "primary",
            plotlyOutput("risk_chart", height = 300)
          )
        ),
        
        fluidRow(
          fluidRow(
            box(
              title = "Area Risk Summary",
              width = 12,
              DTOutput("summary_table")
            )
          ),
          
          fluidRow(
            box(
              title = "Mumbai Flood Risk Distribution",
              width = 12,
              plotlyOutput("mumbai_risk_chart", height = 300)
            )
          )
        ),
        
        div(
          class = "disclaimer",
          "Prototype dashboard using illustrative demo data. Not for emergency decisions."
        )
      ),
      
      # FLOOD MAP
      tabItem(
        tabName = "map",
        h2("Mumbai Flood Risk Map"),
        box(
          title = "Mumbai Flood-Risk Areas",
          width = 12,
          leafletOutput("flood_map", height = 500)
        ),
        div(
          class = "disclaimer",
          "Map markers and risk levels are examples, not live observations."
        )
      ),
      
      # DATA ANALYSIS
      tabItem(
        tabName = "analysis",
        h2("Data Analysis"),
        
        fluidRow(
          box(
            title = "Rainfall by Area",
            width = 6,
            plotlyOutput("rain_area_chart", height = 320)
          ),
          box(
            title = "Water Level by Area",
            width = 6,
            plotlyOutput("water_area_chart", height = 320)
          )
        ),
        
        # ADDED: Scatter plot display
        fluidRow(
          box(
            title = "Rainfall vs Water Level",
            width = 12,
            plotlyOutput("rainfall_water_scatter", height = 350)
          )
        ),
        
        box(
          title = "Explore Demo Data",
          width = 12,
          DTOutput("analysis_table")
        )
      ),
      
      # MODEL PREDICTION
      tabItem(
        tabName = "prediction",
        h2("Flood Risk Assessment"),
        
        fluidRow(
          box(
            title = "Enter Environmental Conditions",
            width = 5,
            numericInput(
              "rainfall", "Rainfall (mm)",
              value = 20, min = 0, max = 500
            ),
            numericInput(
              "water", "Water Level (m)",
              value = 0.5, min = 0, max = 20
            ),
            numericInput(
              "elevation", "Elevation (m)",
              value = 10, min = 0, max = 500
            ),
            numericInput(
              "slope", "Slope (degrees)",
              value = 2, min = 0, max = 90
            ),
            selectInput(
              "landuse", "Land Use",
              choices = c(
                "Residential", "Commercial",
                "Agricultural", "Forest"
              )
            ),
            actionButton(
              "predict", "Check Flood Risk",
              class = "btn-primary"
            )
          ),
          
          box(
            title = "Assessment Result",
            width = 7,
            h3(textOutput("risk_title")),
            textOutput("risk_description"),
            br(),
            p(
              class = "disclaimer",
              "This is a rule-based demonstration, not a trained or validated machine-learning model."
            )
          )
        )
      ),
      
      # REPORTS
      tabItem(
        tabName = "reports",
        h2("Reports"),
        box(
          title = "Download Area Summary",
          width = 12,
          p("Download the illustrative area summary as a CSV file."),
          downloadButton("download_data", "Download CSV")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$locations_box <- renderValueBox({
    valueBox(
      nrow(locations), "Sample Records",
      icon = icon("map-marker-alt"),
      color = "aqua"
    )
  })
  
  output$rain_box <- renderValueBox({
    valueBox(
      paste0(max(locations$Rainfall), " mm"),
      "Maximum Demo Rainfall",
      icon = icon("cloud-rain"),
      color = "yellow"
    )
  })
  
  output$water_box <- renderValueBox({
    valueBox(
      paste0(max(locations$WaterLevel), " m"),
      "Maximum Demo Water Level",
      icon = icon("tint"),
      color = "blue"
    )
  })
  
  output$highrisk_box <- renderValueBox({
    valueBox(
      sum(locations$Risk == "HIGH"),
      "High-Risk Demo Areas",
      icon = icon("exclamation-triangle"),
      color = "red"
    )
  })
  
  output$overview_chart <- renderPlotly({
    plot_ly(
      locations,
      x = ~Area,
      y = ~Rainfall,
      type = "bar",
      name = "Rainfall (mm)"
    ) |>
      add_trace(
        y = ~WaterLevel,
        name = "Water Level (m)",
        type = "scatter",
        mode = "lines+markers",
        yaxis = "y2"
      ) |>
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Rainfall (mm)"),
        yaxis2 = list(
          title = "Water Level (m)",
          overlaying = "y",
          side = "right"
        ),
        paper_bgcolor = "#111c30",
        plot_bgcolor = "#111c30",
        font = list(color = "#e5e7eb"),
        legend = list(orientation = "h")
      )
  })
  
  output$risk_chart <- renderPlotly({
    counts <- as.data.frame(table(locations$Risk))
    names(counts) <- c("Risk", "Count")
    
    plot_ly(
      counts,
      labels = ~Risk,
      values = ~Count,
      type = "pie",
      hole = 0.55
    ) |>
      layout(
        paper_bgcolor = "#111c30",
        font = list(color = "#e5e7eb")
      )
  })
  
  
  
  output$summary_table <- renderDT({
    datatable(
      locations[, c("Area", "Rainfall", "WaterLevel", "Risk")],
      rownames = FALSE,
      options = list(
        paging = FALSE,
        searching = FALSE,
        info = FALSE,
        ordering = TRUE,
        dom = "t"
      )
    ) |>
      formatStyle(
        "Area",
        color = "#e5e7eb",
        backgroundColor = "#111c30"
      ) |>
      formatStyle(
        c("Rainfall", "WaterLevel"),
        color = "#e5e7eb",
        backgroundColor = "#111c30"
      ) |>
      formatStyle(
        "Risk",
        fontWeight = "bold",
        color = styleEqual(
          c("LOW", "MODERATE", "HIGH", "CRITICAL"),
          c("#22c55e", "#facc15", "#f97316", "#ef4444")
        ),
        backgroundColor = "#111c30"
      )
  })
  
  
  output$mumbai_risk_chart <- renderPlotly({
    risk_counts <- as.data.frame(table(locations$Risk))
    names(risk_counts) <- c("Risk", "Count")
    
    risk_counts <- risk_counts[risk_counts$Count > 0, ]
    
    plot_ly(
      risk_counts,
      x = ~Risk,
      y = ~Count,
      type = "bar",
      text = ~Count,
      textposition = "auto",
      marker = list(
        color = c(
          "LOW" = "#22c55e",
          "MODERATE" = "#facc15",
          "HIGH" = "#f97316",
          "CRITICAL" = "#ef4444"
        )[risk_counts$Risk]
      )
    ) |>
      layout(
        title = "Mumbai Flood Risk Distribution",
        xaxis = list(title = "Flood Risk Category"),
        yaxis = list(title = "Number of Records", rangemode = "tozero"),
        paper_bgcolor = "#111c30",
        plot_bgcolor = "#111c30",
        font = list(color = "#e5e7eb")
      )
  })
  
  
  output$flood_map <- renderLeaflet({
    leaflet(locations) |>
      addTiles() |>
      setView(lng = 72.87, lat = 19.07, zoom = 11) |>
      addCircleMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        radius = 9,
        
        color = ~unname(risk_colors[Risk]),
        fillOpacity = 0.85,
        
        popup = ~paste0(
          "<b>", Area, "</b><br>",
          "Rainfall: ", Rainfall, " mm<br>",
          "Water level: ", WaterLevel, " m<br>",
          "Flood risk: ", Risk
        ),
        
        label = ~paste0(
          Area,
          " | Rainfall: ", Rainfall, " mm",
          " | Water level: ", WaterLevel, " m",
          " | Risk: ", Risk
        )
        
      )
  })
  
  output$rain_area_chart <- renderPlotly({
    plot_ly(
      locations,
      x = ~Area,
      y = ~Rainfall,
      type = "bar"
    ) |>
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Rainfall (mm)")
      )
  })
  
  output$water_area_chart <- renderPlotly({
    plot_ly(
      locations,
      x = ~Area,
      y = ~WaterLevel,
      type = "bar"
    ) |>
      layout(
        xaxis = list(title = ""),
        yaxis = list(title = "Water Level (m)")
      )
  })
  
  # ADDED: Scatter plot showing rainfall versus water level
  output$rainfall_water_scatter <- renderPlotly({
    plot_ly(
      locations,
      x = ~Rainfall,
      y = ~WaterLevel,
      color = ~Risk,
      type = "scatter",
      mode = "markers",
      text = ~Area,
      hovertemplate = paste(
        "<b>%{text}</b><br>",
        "Rainfall: %{x} mm<br>",
        "Water level: %{y} m",
        "<extra></extra>"
      )
    ) |>
      layout(
        title = "Rainfall vs Water Level",
        xaxis = list(title = "Rainfall (mm)"),
        yaxis = list(title = "Water Level (m)"),
        paper_bgcolor = "#111c30",
        plot_bgcolor = "#111c30",
        font = list(color = "#e5e7eb")
      )
  })
  
  
  output$analysis_table <- renderDT({
    datatable(
      locations,
      rownames = FALSE,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      )
    ) |>
      formatStyle(
        columns = names(locations),
        color = "#F8FAFC",
        backgroundColor = "#17263F",
        borderColor = "#475569"
      ) |>
      formatStyle(
        "FloodRisk",
        fontWeight = "bold",
        color = styleEqual(
          c("LOW", "MODERATE", "HIGH", "CRITICAL"),
          c("#4ADE80", "#FACC15", "#FB923C", "#F87171")
        )
      ) |>
      formatStyle(
        "Risk",
        fontWeight = "bold",
        color = styleEqual(
          c("LOW", "MODERATE", "HIGH", "CRITICAL"),
          c("#4ADE80", "#FACC15", "#FB923C", "#F87171")
        )
      )
  })
  
  
  risk_result <- eventReactive(input$predict, {
    if (input$rainfall >= 100 || input$water >= 2.5) {
      "HIGH RISK"
    } else if (input$rainfall >= 50 || input$water >= 1.5) {
      "MODERATE RISK"
    } else {
      "LOW RISK"
    }
  })
  
  output$risk_title <- renderText({
    req(risk_result())
    risk_result()
  })
  
  output$risk_description <- renderText({
    req(risk_result())
    paste(
      "Assessment based on the rainfall and water-level rules.",
      "Elevation, slope, and land use are collected but are not yet used."
    )
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      "flood_risk_demo_summary.csv"
    },
    content = function(file) {
      write.csv(locations, file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)

