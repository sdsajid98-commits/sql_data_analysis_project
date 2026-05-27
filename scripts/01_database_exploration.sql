/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    Basic exploration queries for reviewing database tables
    and column-level metadata.
===============================================================================
*/


-- =============================================================================
-- List All Tables
-- =============================================================================

SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;


-- =============================================================================
-- View Columns for dim_customers
-- =============================================================================

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
