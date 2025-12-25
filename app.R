# app.R
library(shiny)
library(ggplot2)

# ---- data (CSV innebygd) ----
csv_txt <- "
year,min_extent_million_km2,min_date
1979,6.895,1979-09-21
1980,7.533,1980-09-05
1981,6.902,1981-09-10
1982,7.160,1982-09-13
1983,7.204,1983-09-08
1984,6.396,1984-09-16
1985,6.486,1985-09-09
1986,7.122,1986-09-13
1987,7.414,1987-09-14
1988,7.433,1988-09-14
1989,7.051,1989-09-08
1990,6.251,1990-09-17
1991,6.579,1991-09-15
1992,7.251,1992-09-21
1993,6.156,1993-09-17
1994,6.065,1994-09-20
1995,6.080,1995-09-22
1996,7.877,1996-09-09
1997,6.641,1997-09-17
1998,6.560,1998-09-17
1999,6.325,1999-09-14
2000,6.287,2000-09-18
2001,6.798,2001-09-12
2002,5.784,2002-09-18
2003,6.130,2003-09-17
2004,5.946,2004-09-18
2005,5.271,2005-09-21
2006,5.891,2006-09-13
2007,4.281,2007-09-16
2008,4.724,2008-09-14
2009,5.361,2009-09-18
2010,4.623,2010-09-21
2011,4.343,2011-09-09
2012,3.387,2012-09-16
2013,5.077,2013-09-13
2014,4.624,2014-09-17
2015,4.433,2015-09-11
2016,4.145,2016-09-10
2017,4.664,2017-09-13
2018,4.592,2018-09-22
2019,4.186,2019-09-18
2020,3.793,2020-09-13
2021,4.757,2021-09-14
2022,4.692,2022-09-15
2023,4.244,2023-09-17
2024,4.245,2024-09-10
"

df <- read.csv(text = csv_txt, stringsAsFactors = FALSE)
df$min_date <- as.Date(df$min_date)
df <- df[order(df$year), ]

roll_mean <- function(x, k = 5) {
  # sentrert rullerende snitt, enkel og robust
  if (k <= 1) return(x)
  stats::filter(x, rep(1 / k, k), sides = 2)
}

# ---- UI ----
ui <- fluidPage(
  titlePanel("Arktisk havis – minimum (extent) per år (1979–2024)"),

  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "year_range", "År (filter):",
        min = min(df$year), max = max(df$year),
        value = c(min(df$year), max(df$year)), sep = ""
      ),

      selectInput(
        "smooth", "Glatting:",
        choices = c("Ingen" = "none", "LOESS" = "loess", "Rullerende snitt" = "roll"),
        selected = "none"
      ),

      conditionalPanel(
        condition = "input.smooth == 'roll'",
        sliderInput("k", "Vindusstørrelse (år):", min = 3, max = 15, value = 5, step = 2)
      ),

      selectInput(
        "pick_year", "Vis detalj for år:",
        choices = df$year, selected = max(df$year)
      ),

      helpText("Enhet: millioner km². Merk: extent ≠ area.")
    ),

    mainPanel(
      fluidRow(
        column(
          4,
          wellPanel(
            h4("Valgt år"),
            verbatimTextOutput("year_card")
          )
        ),
        column(
          8,
          plotOutput("p", height = 360)
        )
      ),

      h4("År-for-år-tabell (filtrert)"),
      tableOutput("tbl")
    )
  )
)

# ---- Server ----
server <- function(input, output, session) {

  # Oppdater år-velgeren så den følger filteret (men behold valgt hvis mulig)
  observeEvent(input$year_range, {
    yrs <- df$year[df$year >= input$year_range[1] & df$year <= input$year_range[2]]
    current <- isolate(input$pick_year)
    if (!(current %in% yrs)) current <- tail(yrs, 1)
    updateSelectInput(session, "pick_year", choices = yrs, selected = current)
  }, ignoreInit = TRUE)

  dff <- reactive({
    df[df$year >= input$year_range[1] & df$year <= input$year_range[2], ]
  })

  output$year_card <- renderText({
    y <- as.integer(input$pick_year)
    row <- df[df$year == y, ]
    if (nrow(row) == 0) return("Ingen data for valgt år.")
    sprintf(
      "År: %d\nMinimum extent: %.3f mill. km²\nDato for minimum: %s",
      row$year, row$min_extent_million_km2, format(row$min_date, "%Y-%m-%d")
    )
  })

  output$p <- renderPlot({
    d <- dff()

    base <- ggplot(d, aes(x = year, y = min_extent_million_km2)) +
      geom_line() +
      geom_point() +
      labs(x = NULL, y = "Minimum extent (mill. km²)")

    if (input$smooth == "loess") {
      base <- base + geom_smooth(se = TRUE, method = "loess", span = 0.5)
    } else if (input$smooth == "roll") {
      k <- input$k
      d2 <- d
      d2$roll <- as.numeric(roll_mean(d2$min_extent_million_km2, k = k))

      base <- base +
        geom_line(data = d2, aes(x = year, y = roll), linewidth = 1)
    }
    # marker valgt år
    y <- as.integer(input$pick_year)
    row <- d[d$year == y, ]
    if (nrow(row) == 1) {
      base <- base + geom_vline(xintercept = y, linetype = "dashed")
    }

    base
  })

  output$tbl <- renderTable({
    d <- dff()
    d[, c("year", "min_extent_million_km2", "min_date")]
  }, striped = TRUE, digits = 3)
}

shinyApp(ui, server)
