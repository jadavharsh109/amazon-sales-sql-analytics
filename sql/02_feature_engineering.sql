-- =============================================================================
-- Amazon E-Commerce & Retail Sales Analytics
-- Script 02: Feature Engineering & Data Enrichment
-- Author: Harsh Jadav (https://github.com/jadavharsh109)
-- Database Engine: MySQL 8.0+
-- =============================================================================

USE amazon_sales_db;

-- Disable safe update mode for transformation queries
SET SQL_SAFE_UPDATES = 0;

-- -----------------------------------------------------------------------------
-- Step 1: Feature Engineering - Time of Day Classification
-- Categorizes purchases into Morning (06:00-11:59), Afternoon (12:00-17:59),
-- and Evening (18:00-23:59).
-- -----------------------------------------------------------------------------

ALTER TABLE sales
ADD COLUMN Time_of_day VARCHAR(15) NULL;

UPDATE sales
SET Time_of_day = CASE  
    WHEN HOUR(Purchase_Time) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(Purchase_Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END;

-- Verification of Time_of_day distribution
SELECT Time_of_day, COUNT(*) AS transaction_count 
FROM sales
GROUP BY Time_of_day
ORDER BY transaction_count DESC;

-- -----------------------------------------------------------------------------
-- Step 2: Feature Engineering - Day Name
-- Extracts the day of the week (Monday, Tuesday, etc.) to analyze shopping cycles.
-- -----------------------------------------------------------------------------

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(15) NULL;

UPDATE sales 
SET day_name = DAYNAME(Purchase_Date);

-- Verification of weekday distribution
SELECT day_name, COUNT(*) AS transaction_count
FROM sales
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- -----------------------------------------------------------------------------
-- Step 3: Feature Engineering - Month Name
-- Extracts the calendar month name (January, February, March) for quarterly trends.
-- -----------------------------------------------------------------------------

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(15) NULL;

UPDATE sales
SET month_name = MONTHNAME(Purchase_Date);

-- Verification of monthly transaction volume
SELECT month_name, COUNT(*) AS transaction_count, ROUND(SUM(Total), 2) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;

-- -----------------------------------------------------------------------------
-- Schema Structure Post-Transformation
-- -----------------------------------------------------------------------------
DESCRIBE sales;
