/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    Explore the time range of sales data and customer demographics.
===============================================================================
*/


-- =============================================================================
-- Sales Date Range
-- =============================================================================

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;


-- =============================================================================
-- Customer Age Range
-- =============================================================================

SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
