/*
=============================================================
Create Analytics Database and Gold Tables
=============================================================
Purpose:
    Creates the analytics database, gold schema, and analytical tables.
    Loads CSV data into the Gold layer for reporting and analysis.

Note:
    File paths used in BULK INSERT are environment-specific and
    should be updated before execution.
=============================================================
*/

USE master;
GO

-- recreate database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics 
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- create database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- create schema
CREATE SCHEMA gold;
GO


-- =============================================================================
-- Create Tables
-- =============================================================================

CREATE TABLE gold.dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  NVARCHAR(50),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    country          NVARCHAR(50),
    marital_status   NVARCHAR(50),
    gender           NVARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);
GO

CREATE TABLE gold.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  NVARCHAR(50),
    product_name    NVARCHAR(50),
    category_id     NVARCHAR(50),
    category        NVARCHAR(50),
    subcategory     NVARCHAR(50),
    maintenance     NVARCHAR(50),
    cost             INT,
    product_line    NVARCHAR(50),
    start_date      DATE
);
GO

CREATE TABLE gold.fact_sales (
    order_number    NVARCHAR(50),
    product_key     INT,
    customer_key    INT,
    order_date      DATE,
    shipping_date   DATE,
    due_date        DATE,
    sales_amount    INT,
    quantity        TINYINT,
    price           INT
);
GO


-- =============================================================================
-- Load Customer Dimension
-- =============================================================================

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO


-- =============================================================================
-- Load Product Dimension
-- =============================================================================

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO


-- =============================================================================
-- Load Sales Fact Table
-- =============================================================================

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\sql\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
