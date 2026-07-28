CREATE TABLE staging_spy_data (
    trade_date TIMESTAMPTZ,
    open_price NUMERIC,
    high_price NUMERIC,
    low_price NUMERIC,
    close_price NUMERIC,
    volume BIGINT,
    dividends NUMERIC
);


COPY staging_spy_data(trade_date, open_price, high_price, low_price, close_price, volume, dividends)
FROM 'C:\Users\Public\SQL stuff\SPY.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE historical_prices AS
SELECT 
    DATE(trade_date) AS trade_date,
    ROUND(close_price, 2) AS close_price,
    volume
FROM staging_spy_data
ORDER BY trade_date ASC;

DROP TABLE staging_spy_data;

CREATE VIEW market_metrics_vw AS
WITH DailyReturns AS (
    SELECT 
        trade_date,
        close_price,
        LAG(close_price) OVER (ORDER BY trade_date) AS prev_close,
        ROUND(((close_price - LAG(close_price) OVER (ORDER BY trade_date)) / LAG(close_price) OVER (ORDER BY trade_date)) * 100, 4) AS daily_return_pct
    FROM historical_prices
)
SELECT 
    trade_date,
    close_price,
    daily_return_pct,
    ROUND(AVG(close_price) OVER (
        ORDER BY trade_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_50d,
    ROUND(AVG(close_price) OVER (
        ORDER BY trade_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_200d
FROM DailyReturns
WHERE trade_date >= '2020-01-01';