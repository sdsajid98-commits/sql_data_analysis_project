/*
===============================================================================
Dimension Exploration
===============================================================================
Purpose:
    Simple exploration queries for reviewing dimension data
    used in reporting and analytics.
===============================================================================
*/


-- =============================================================================
-- Customer Countries
-- =============================================================================

SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country;


-- =============================================================================
-- Product Categories
-- =============================================================================

SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
