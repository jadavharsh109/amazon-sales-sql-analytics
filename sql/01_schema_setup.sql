-- =============================================================================
-- Amazon E-Commerce & Retail Sales Analytics
-- Script 01: Schema Definition & Database Setup
-- Author: Harsh Jadav (https://github.com/jadavharsh109)
-- Database Engine: MySQL 8.0+
-- =============================================================================

CREATE DATABASE IF NOT EXISTS amazon_sales_db;
USE amazon_sales_db;

-- Drop table if it already exists to allow idempotent execution
DROP TABLE IF EXISTS sales;

-- -----------------------------------------------------------------------------
-- Table Structure: sales
-- Represents retail transactions across branches and cities
-- -----------------------------------------------------------------------------
CREATE TABLE sales (
    Invoice_ID              VARCHAR(30)     PRIMARY KEY,
    Branch                  VARCHAR(5)      NOT NULL,
    City                    VARCHAR(30)     NOT NULL,
    Customer_Type           VARCHAR(30)     NOT NULL,
    Gender                  VARCHAR(10)     NOT NULL,
    Product_Line            VARCHAR(100)    NOT NULL,
    Unit_Price              DECIMAL(10,2)   NOT NULL,
    Quantity                INT             NOT NULL,
    VAT                     FLOAT           NOT NULL,
    Total                   DECIMAL(10,2)   NOT NULL,
    Purchase_Date           DATE            NOT NULL,
    Purchase_Time           TIME            NOT NULL,
    Payment_Method          VARCHAR(25)     NOT NULL,
    COGS                    DECIMAL(10,2)   NOT NULL,
    Gross_Margin_Percentage FLOAT           NOT NULL,
    Gross_Income            DECIMAL(10,2)   NOT NULL,
    Rating                  DECIMAL(3,1)    NOT NULL
);

-- -----------------------------------------------------------------------------
-- Data Ingestion Instructions
-- Method 1: Using LOAD DATA LOCAL INFILE (Fast Ingestion)
-- Method 2: MySQL Workbench Table Data Import Wizard
-- -----------------------------------------------------------------------------

/*
-- Enable local infile on server & client
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'data/amazon_supermarket_sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    Invoice_ID, Branch, City, Customer_Type, Gender, Product_Line,
    Unit_Price, Quantity, VAT, Total, Purchase_Date, Purchase_Time,
    Payment_Method, COGS, Gross_Margin_Percentage, Gross_Income, Rating
);
*/

-- -----------------------------------------------------------------------------
-- Data Ingestion Sanity Checks
-- -----------------------------------------------------------------------------

-- 1. Verify total row count (Expected: 1,000 rows)
SELECT COUNT(*) AS total_records FROM sales;

-- 2. Check for missing or NULL values across key attributes
SELECT 
    SUM(CASE WHEN Invoice_ID IS NULL THEN 1 ELSE 0 END) AS null_invoices,
    SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS null_totals,
    SUM(CASE WHEN Purchase_Date IS NULL THEN 1 ELSE 0 END) AS null_dates
FROM sales;

-- 3. Preview first 5 rows
SELECT * FROM sales LIMIT 5;
