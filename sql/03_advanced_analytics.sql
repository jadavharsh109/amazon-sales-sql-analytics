-- =============================================================================
-- Amazon E-Commerce & Retail Sales Analytics
-- Script 03: Comprehensive Business Queries & Advanced Analytics
-- Author: Harsh Jadav (https://github.com/jadavharsh109)
-- Database Engine: MySQL 8.0+
-- =============================================================================

USE amazon_sales_db;

-- =============================================================================
-- SECTION 1: Exploratory Data Analysis & Dimensional Counts
-- =============================================================================

-- Q1. Total number of records in dataset
SELECT COUNT(*) AS total_transactions FROM sales;

-- Q2. Total columns in sales table schema
SELECT COUNT(*) AS total_columns 
FROM information_schema.columns
WHERE table_name = 'sales' AND table_schema = 'amazon_sales_db';

-- Q3. Count of distinct cities represented
SELECT COUNT(DISTINCT City) AS distinct_cities FROM sales;

-- Q4. Distinct branches and their mapped cities
SELECT DISTINCT Branch, City FROM sales ORDER BY Branch;

-- Q5. Distinct customer types
SELECT DISTINCT Customer_Type FROM sales;

-- Q6. Distinct product lines
SELECT DISTINCT Product_Line FROM sales;

-- Q7. Distinct payment methods
SELECT DISTINCT Payment_Method FROM sales;

-- Q8. Overall financial metrics (Total Revenue, Min Sale, Max Sale, Avg Sale)
SELECT 
    ROUND(SUM(Total), 2) AS total_revenue,
    ROUND(AVG(Total), 2) AS avg_transaction_value,
    ROUND(MIN(Total), 2) AS min_sale_amount,
    ROUND(MAX(Total), 2) AS max_sale_amount,
    ROUND(AVG(Unit_Price), 2) AS avg_unit_price,
    SUM(Quantity) AS total_units_sold
FROM sales;

-- =============================================================================
-- SECTION 2: Product Line Performance & Classification
-- =============================================================================

-- Q9. Count of distinct product lines
SELECT COUNT(DISTINCT Product_Line) AS product_line_count FROM sales;

-- Q10. Total revenue generated per product line (Ranked Highest to Lowest)
SELECT 
    Product_Line, 
    ROUND(SUM(Total), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity_sold
FROM sales
GROUP BY Product_Line
ORDER BY total_revenue DESC;

-- Q11. Average rating per product line
SELECT 
    Product_Line, 
    ROUND(AVG(Rating), 2) AS avg_customer_rating,
    COUNT(*) AS review_count
FROM sales
GROUP BY Product_Line
ORDER BY avg_customer_rating DESC;

-- Q12. Average unit price per product line
SELECT 
    Product_Line, 
    ROUND(AVG(Unit_Price), 2) AS avg_unit_price
FROM sales
GROUP BY Product_Line
ORDER BY avg_unit_price DESC;

-- Q13. Value-Added Tax (VAT) contribution by product line
SELECT 
    Product_Line, 
    ROUND(SUM(VAT), 2) AS total_vat_collected
FROM sales
GROUP BY Product_Line
ORDER BY total_vat_collected DESC;

-- Q14. Dynamic Performance Tagging: Classify product lines as 'Good' (above average revenue) or 'Bad' (below average)
SELECT 
    Product_Line,
    ROUND(SUM(Total), 2) AS total_revenue,
    CASE 
        WHEN SUM(Total) > (
            SELECT SUM(Total) / COUNT(DISTINCT Product_Line) 
            FROM sales
        ) THEN 'Good'
        ELSE 'Bad' 
    END AS performance_category
FROM sales 
GROUP BY Product_Line
ORDER BY total_revenue DESC;

-- Q15. High-performing product lines with total sales > 1000 and average rating
SELECT 
    Product_Line, 
    ROUND(SUM(Total), 2) AS total_sales, 
    ROUND(AVG(Rating), 2) AS avg_rating 
FROM sales 
GROUP BY Product_Line 
HAVING total_sales > 1000
ORDER BY total_sales DESC;

-- =============================================================================
-- SECTION 3: Customer Segmentation & Demographics
-- =============================================================================

-- Q16. Transaction breakdown by customer type (Member vs. Normal)
SELECT 
    Customer_Type, 
    COUNT(*) AS total_transactions,
    ROUND(SUM(Total), 2) AS total_revenue,
    ROUND(AVG(Total), 2) AS avg_spend_per_visit
FROM sales 
GROUP BY Customer_Type
ORDER BY total_revenue DESC;

-- Q17. Revenue and transaction distribution by gender
SELECT 
    Gender, 
    COUNT(*) AS transaction_count,
    ROUND(SUM(Total), 2) AS total_revenue,
    ROUND(AVG(Total), 2) AS avg_ticket_size
FROM sales 
GROUP BY Gender
ORDER BY total_revenue DESC;

-- Q18. Customer demographic split by city and gender
SELECT 
    City, 
    Gender, 
    COUNT(*) AS customer_count,
    ROUND(SUM(Total), 2) AS city_gender_revenue
FROM sales 
GROUP BY City, Gender
ORDER BY City, Gender;

-- Q19. Total gross income generated per customer type
SELECT 
    Customer_Type, 
    ROUND(SUM(Gross_Income), 2) AS total_gross_income,
    ROUND(AVG(Gross_Income), 2) AS avg_gross_income
FROM sales 
GROUP BY Customer_Type
ORDER BY total_gross_income DESC;

-- Q20. Product line preference across genders
SELECT 
    Gender, 
    Product_Line, 
    COUNT(*) AS purchase_frequency,
    ROUND(SUM(Total), 2) AS total_spend
FROM sales
GROUP BY Gender, Product_Line
ORDER BY Gender, purchase_frequency DESC;

-- Q21. [ADVANCED CTE & WINDOW FUNCTION] Most frequently purchased product line per gender
WITH RankedCategoryByGender AS (
    SELECT 
        Gender, 
        Product_Line, 
        COUNT(*) AS purchase_frequency,
        ROUND(SUM(Total), 2) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY Gender 
            ORDER BY COUNT(*) DESC
        ) AS rank_order
    FROM sales
    GROUP BY Gender, Product_Line
)
SELECT 
    Gender, 
    Product_Line AS top_preferred_product_line, 
    purchase_frequency,
    total_sales
FROM RankedCategoryByGender
WHERE rank_order = 1;

-- =============================================================================
-- SECTION 4: Branch & Geographic Store Performance
-- =============================================================================

-- Q22. Total sales revenue and transaction count per branch
SELECT 
    Branch, 
    COUNT(*) AS total_orders,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(Total), 2) AS total_sales
FROM sales 
GROUP BY Branch
ORDER BY total_sales DESC;

-- Q23. Average customer satisfaction rating per branch
SELECT 
    Branch, 
    ROUND(AVG(Rating), 2) AS avg_rating
FROM sales 
GROUP BY Branch
ORDER BY avg_rating DESC;

-- Q24. Total revenue and average ratings per city
SELECT 
    City, 
    COUNT(*) AS total_orders,
    ROUND(SUM(Total), 2) AS total_revenue,
    ROUND(AVG(Rating), 2) AS avg_rating
FROM sales 
GROUP BY City 
ORDER BY total_revenue DESC;

-- Q25. Identify branches that exceeded the average number of products sold across all branches
SELECT 
    Branch, 
    SUM(Quantity) AS total_products_sold 
FROM sales
GROUP BY Branch
HAVING SUM(Quantity) > (
    SELECT SUM(Quantity) / COUNT(DISTINCT Branch) 
    FROM sales
)
ORDER BY total_products_sold DESC;

-- Q26. Total revenue cross-tabulated by Branch and Product Line
SELECT 
    Branch, 
    Product_Line, 
    ROUND(SUM(Total), 2) AS branch_line_revenue
FROM sales 
GROUP BY Branch, Product_Line
ORDER BY Branch, branch_line_revenue DESC;

-- =============================================================================
-- SECTION 5: Temporal, Peak-Hour & Day-of-Week Analytics
-- =============================================================================

-- Q27. Monthly revenue trajectory (Q1 2019)
SELECT 
    month_name, 
    COUNT(*) AS total_transactions,
    ROUND(SUM(Total), 2) AS monthly_revenue
FROM sales 
GROUP BY month_name 
ORDER BY monthly_revenue DESC;

-- Q28. Revenue and order count per day of the week
SELECT 
    day_name, 
    COUNT(*) AS total_transactions,
    ROUND(SUM(Total), 2) AS weekday_revenue
FROM sales 
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Q29. Peak shopping time-of-day analysis
SELECT 
    Time_of_day, 
    COUNT(*) AS sales_count,
    ROUND(SUM(Total), 2) AS time_period_revenue,
    ROUND(AVG(Total), 2) AS avg_ticket_size
FROM sales 
GROUP BY Time_of_day
ORDER BY sales_count DESC;

-- Q30. Number of sales occurrences by time of day for each weekday
SELECT 
    day_name, 
    Time_of_day, 
    COUNT(*) AS sales_count,
    ROUND(SUM(Total), 2) AS total_sales
FROM sales
GROUP BY day_name, Time_of_day
ORDER BY 
    FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), 
    FIELD(Time_of_day, 'Morning', 'Afternoon', 'Evening');

-- Q31. Time of day when customers provide the highest volume of ratings
SELECT 
    Time_of_day, 
    COUNT(Rating) AS ratings_submitted,
    ROUND(AVG(Rating), 2) AS avg_rating_score
FROM sales
GROUP BY Time_of_day
ORDER BY ratings_submitted DESC;

-- =============================================================================
-- SECTION 6: Payment Methods, COGS & Taxation (VAT) Insights
-- =============================================================================

-- Q32. Most frequently utilized payment methods
SELECT 
    Payment_Method, 
    COUNT(*) AS usage_frequency,
    ROUND(SUM(Total), 2) AS total_processed_revenue,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales), 2) AS payment_share_percentage
FROM sales
GROUP BY Payment_Method
ORDER BY usage_frequency DESC;

-- Q33. Total VAT collected per payment method
SELECT 
    Payment_Method, 
    ROUND(SUM(VAT), 2) AS total_vat_collected
FROM sales
GROUP BY Payment_Method
ORDER BY total_vat_collected DESC;

-- Q34. Month in which Cost of Goods Sold (COGS) reached its peak
SELECT 
    month_name, 
    ROUND(SUM(COGS), 2) AS total_cogs
FROM sales
GROUP BY month_name 
ORDER BY total_cogs DESC;

-- Q35. Highest transaction value recorded by city
SELECT 
    City, 
    ROUND(MAX(Total), 2) AS max_single_transaction
FROM sales
GROUP BY City
ORDER BY max_single_transaction DESC;

-- Q36. Top 5 highest-value transactions in the dataset
SELECT 
    Invoice_ID, 
    Branch, 
    City, 
    Customer_Type, 
    Product_Line, 
    Quantity, 
    Total, 
    Purchase_Date, 
    Payment_Method
FROM sales 
ORDER BY Total DESC 
LIMIT 5;

-- Q37. Transaction value categorization (High-Ticket >  vs Standard)
SELECT 
    Invoice_ID, 
    Total, 
    CASE 
        WHEN Total > 500 THEN 'High Value' 
        ELSE 'Standard Value' 
    END AS transaction_tier
FROM sales
LIMIT 20;