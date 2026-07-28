library(DBI)
library(RPostgres)
library(ggplot2)
library(dplyr)
library(scales)


con <- dbConnect(RPostgres::Postgres(),
                 dbname = "market_data_db",
                 host = "localhost",
                 port = 5432,
                 user = "postgres",
                 password = "Dummy_Password")

market_data <- dbGetQuery(con, "SELECT * FROM market_metrics_vw;")

market_data$trade_date <- as.Date(market_data$trade_date)

ggplot(market_data, aes(x = trade_date)) +
  geom_line(aes(y = close_price), colour = "grey70", alpha = 0.6, size = 0.5) +
  geom_line(aes(y = moving_avg_50d, colour = "50-Day MA"), size = 0.8) +
  geom_line(aes(y = moving_avg_200d, colour = "200-Day MA"), size = 0.8) +
  
  scale_y_continuous(labels = scales::dollar) +
  scale_colour_manual(name = "Trend Indicators", values = c("50-Day MA" = "steelblue", "200-Day MA" = "firebrick")) +
  
  labs(
    title = "S&P 500 (SPY) Trend Analysis & Market Volatility",
    subtitle = "Tracking 50-day and 200-day moving averages (2020 - 2024)",
    x = "Trade Date",
    y = "Price (USD)",
    caption = "Data Source: SPY Historical Market Data"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

dbDisconnect(con)