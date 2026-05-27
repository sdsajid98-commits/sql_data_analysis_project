/*
===============================================================================
Product Report
===============================================================================
Purpose:
    Creates a product-level analytics view with sales performance,
    customer activity, and revenue metrics.
===============================================================================
*/


-- =============================================================================
-- Create View: gold.report_products
-- =============================================================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (

    -- sales and product details
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_summary AS (

    -- aggregated product metrics
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        MIN(order_date) AS first_sale_date,
        MAX(order_date) AS last_sale_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(
            AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),
            1
        ) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,

    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,

    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- average revenue per order
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- average monthly revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_summary;
GO
