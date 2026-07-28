# Quantitative Market & Volatility Tracker

## Overview
Financial analysts and quantitative researchers need to track asset performance and market volatility over long historical periods. When dealing with decades of daily trading data, running complex time-series mathematics in a standard local script can become incredibly slow. 

This project builds a highly optimised data pipeline to track long-term market trends using over 30 years of daily S&P 500 (SPY) trading data, totalling over 8,000 individual trading days up to the end of 2024.

## Data Architecture & Engineering
The time-series dataset was ingested into a PostgreSQL database. The date-time objects were carefully formatted and the records were sorted chronologically to ensure absolute accuracy for the sequential analysis.

## Analytical Approach
To optimise the pipeline's performance, the heavy mathematical processing was shifted directly into the SQL database rather than relying on R to do the calculations. 

A quantitative database view was engineered using advanced window functions. By utilising the `LAG()` function and specific preceding row parameters, the database automatically calculates:
* Daily percentage returns
* 50-day moving averages
* 200-day moving averages

Executing these calculations at the database level drastically reduces the processing load for downstream applications.

## Data Pipeline & Visualisation
R was connected to the pre-calculated SQL view to generate the final visual output. The raw daily closing prices were plotted against the moving average trendlines to visually track classic financial indicators and macro-economic events, clearly identifying anomalies like the 2020 market crash and 2022 bear market.

## Technical Skills Highlighted
* **SQL:** Time-series analysis, Window Functions, Database Views, Pipeline Optimisation.
* **R:** API Database Connections, `ggplot2` time-series plotting, Data scaling.
* **Finance:** Moving averages, daily yield calculations, equity tracking.

## How to Run Locally
1. Clone this repository.
2. Execute the `.sql` script in a PostgreSQL environment to build the database view.
3. Open `volatility_tracker.R` in RStudio.
4. Update the database password and execute the script to render the market trend visualisations.
