# 🛒 Amazon E-Commerce & Retail Sales Analytics

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![SQL Engine](https://img.shields.io/badge/SQL-Advanced%20CTEs%20%26%20Window%20Functions-00758F?style=for-the-badge&logo=sqlite&logoColor=white)](https://en.wikipedia.org/wiki/SQL)
[![Domain](https://img.shields.io/badge/Domain-Retail%20%26%20E--Commerce%20Analytics-E67E22?style=for-the-badge)](https://github.com/jadavharsh109/amazon-sales-sql-analytics)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Harsh%20Jadav-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/harshjadav0901/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

An enterprise-grade **SQL exploratory and financial sales analysis system** evaluating 1,000 retail transactions across three major metropolitan branches (Yangon, Naypyitaw, Mandalay) during Q1 2019. Features schema modeling, transactional feature engineering, and 35+ structured analytical queries covering revenue performance, customer segmentation, peak shopping traffic, and profit margins.

---

## 📑 Table of Contents
- [📌 Business Context & Objectives](#-business-context--objectives)
- [📁 Project Structure](#-project-structure)
- [🗄️ Database Architecture & Schema](#️-database-architecture--schema)
- [⚙️ Data Pipeline & Feature Engineering](#️-data-pipeline--feature-engineering)
- [📊 Key Business Insights & Analytical Queries](#-key-business-insights--analytical-queries)
  - [1. Top Revenue-Generating Product Lines](#1-top-revenue-generating-product-lines)
  - [2. Customer Segmentation: Member vs. Normal](#2-customer-segmentation-member-vs-normal)
  - [3. Gender Preference by Product Line (CTE + Window Function)](#3-gender-preference-by-product-line-cte--window-function)
  - [4. Peak Shopping Hours & Temporal Traffic](#4-peak-shopping-hours--temporal-traffic)
  - [5. Branch & City Revenue Optimization](#5-branch--city-revenue-optimization)
  - [6. Value-Added Tax (VAT) & Margin Analysis](#6-value-added-tax-vat--margin-analysis)
- [🛠️ Advanced SQL Techniques Demonstrated](#️-advanced-sql-techniques-demonstrated)
- [🚀 Quickstart & Reproduction Guide](#-quickstart--reproduction-guide)
- [📄 Project Documentation](#-project-documentation)
- [👨‍💻 Author](#-author)

---

## 📌 Business Context & Objectives

In competitive multi-branch retail, understanding revenue drivers, peak operational windows, and customer buying preferences is vital for inventory forecasting, dynamic promotions, and staffing optimization. 

### Key Business Questions Addressed:
1. **Product Line Viability:** Which product lines generate the bulk of top-line revenue, and which underperform relative to the storewide baseline?
2. **Customer Demographics:** Do loyalty program members drive significantly higher basket sizes than non-member walk-ins?
3. **Temporal Dynamics:** At what times of the day and days of the week are store operations most active, and when do customer ratings peak?
4. **Geographic Distribution:** Which branch (Branch A - Yangon, Branch B - Mandalay, Branch C - Naypyitaw) delivers highest operational profitability and customer satisfaction?

---

## 📁 Project Structure

```
amazon-sales-sql-analytics/
├── data/
│   └── amazon_supermarket_sales.csv     # Cleaned, standardized 1,000-row transaction dataset
├── sql/
│   ├── 01_schema_setup.sql              # DDL schema creation, constraints, ingestion scripts
│   ├── 02_feature_engineering.sql       # Safe transformations (Time_of_day, Day_name, Month_name)
│   └── 03_advanced_analytics.sql        # 37 structured business intelligence queries
├── docs/
│   └── Amazon_Sales_Data_Report.pdf     # Comprehensive case study report with execution proofs
├── .gitignore                           # Git hygiene configuration
├── LICENSE                              # MIT License
└── README.md                            # Comprehensive project documentation
```

---

## 🗄️ Database Architecture & Schema

The relational schema centers on the `sales` entity:

| Attribute | Data Type | Constraint | Business Description |
| :--- | :--- | :--- | :--- |
| `Invoice_ID` | `VARCHAR(30)` | `PRIMARY KEY` | Unique transaction invoice identifier |
| `Branch` | `VARCHAR(5)` | `NOT NULL` | Branch code (`A`, `B`, `C`) |
| `City` | `VARCHAR(30)` | `NOT NULL` | Location (`Yangon`, `Naypyitaw`, `Mandalay`) |
| `Customer_Type`| `VARCHAR(30)` | `NOT NULL` | Customer status (`Member` vs. `Normal`) |
| `Gender` | `VARCHAR(10)` | `NOT NULL` | Customer gender (`Female`, `Male`) |
| `Product_Line` | `VARCHAR(100)`| `NOT NULL` | Retail category (e.g., Food & Beverages, Fashion) |
| `Unit_Price` | `DECIMAL(10,2)`| `NOT NULL` | Price per unit in USD |
| `Quantity` | `INT` | `NOT NULL` | Number of units purchased |
| `VAT` | `FLOAT` | `NOT NULL` | 5% Value-Added Tax levied |
| `Total` | `DECIMAL(10,2)`| `NOT NULL` | Total invoice cost including VAT |
| `Purchase_Date`| `DATE` | `NOT NULL` | Date of sale (Q1 2019) |
| `Purchase_Time`| `TIME` | `NOT NULL` | Time of sale (24-hour format) |
| `Payment_Method`| `VARCHAR(25)` | `NOT NULL` | Tender type (`Cash`, `Ewallet`, `Credit card`) |
| `COGS` | `DECIMAL(10,2)`| `NOT NULL` | Cost of Goods Sold |
| `Gross_Margin_%`| `FLOAT` | `NOT NULL` | Fixed margin percentage (~4.76%) |
| `Gross_Income` | `DECIMAL(10,2)`| `NOT NULL` | Gross profit realized |
| `Rating` | `DECIMAL(3,1)` | `NOT NULL` | Customer satisfaction rating (1.0 - 10.0 scale) |

---

## ⚙️ Data Pipeline & Feature Engineering

To facilitate deeper time-series and behavioral analysis, transactional records were enriched with three derived attributes in [`02_feature_engineering.sql`](sql/02_feature_engineering.sql):

1. **`Time_of_day`**: Categorizes purchasing timestamps into distinct operational shifts:
   * **Morning:** `06:00 - 11:59`
   * **Afternoon:** `12:00 - 17:59`
   * **Evening:** `18:00 - 23:59`
2. **`day_name`**: Extracted weekday name (`Monday` through `Sunday`) to capture weekly cyclicality.
3. **`month_name`**: Extracted calendar month (`January`, `February`, `March`) to evaluate quarterly pacing.

```sql
-- Feature Engineering: Time of Day classification
ALTER TABLE sales ADD COLUMN Time_of_day VARCHAR(15) NULL;

UPDATE sales
SET Time_of_day = CASE  
    WHEN HOUR(Purchase_Time) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(Purchase_Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END;
```

---

## 📊 Key Business Insights & Analytical Queries

### 1. Top Revenue-Generating Product Lines
* **Query Objective:** Identify top product categories by gross revenue and quantify units sold.
* **SQL Implementation:**
```sql
SELECT 
    Product_Line, 
    ROUND(SUM(Total), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity_sold
FROM sales
GROUP BY Product_Line
ORDER BY total_revenue DESC;
```
* **Key Finding:** `Food and beverages` and `Sports and travel` lead storewide revenue generation, contributing over 35% of total top-line sales.

---

### 2. Customer Segmentation: Member vs. Normal
* **Query Objective:** Contrast spending volume and average ticket size between loyalty program members and regular shoppers.
* **SQL Implementation:**
```sql
SELECT 
    Customer_Type, 
    COUNT(*) AS total_transactions,
    ROUND(SUM(Total), 2) AS total_revenue,
    ROUND(AVG(Total), 2) AS avg_spend_per_visit
FROM sales 
GROUP BY Customer_Type
ORDER BY total_revenue DESC;
```
* **Key Finding:** While transaction counts between Members and Normal customers are almost evenly split (~501 vs. 499), loyalty members generate a higher average ticket size ($324.97 vs. $318.99).

---

### 3. Gender Preference by Product Line (CTE + Window Function)
* **Query Objective:** Determine the top-selling product category by purchase frequency for each gender using window functions.
* **SQL Implementation:**
```sql
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
```
* **Key Finding:** Female shoppers purchase most frequently in `Fashion accessories`, while male shoppers show highest purchase frequency in `Health and beauty`.

---

### 4. Peak Shopping Hours & Temporal Traffic
* **Query Objective:** Identify peak customer traffic times across operational windows to optimize staffing.
* **SQL Implementation:**
```sql
SELECT 
    Time_of_day, 
    COUNT(*) AS sales_count,
    ROUND(SUM(Total), 2) AS time_period_revenue,
    ROUND(AVG(Total), 2) AS avg_ticket_size
FROM sales 
GROUP BY Time_of_day
ORDER BY sales_count DESC;
```
* **Key Finding:** **Afternoon (12:00 PM – 6:00 PM)** accounts for over 52% of total transaction volume and revenue, representing the core shift for floor staff and checkout register allocation.

---

### 5. Branch & City Revenue Optimization
* **Query Objective:** Assess revenue, volume, and customer ratings across store branches.
* **SQL Implementation:**
```sql
SELECT 
    Branch, 
    City,
    COUNT(*) AS total_orders,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(Total), 2) AS total_sales,
    ROUND(AVG(Rating), 2) AS avg_satisfaction_rating
FROM sales 
GROUP BY Branch, City
ORDER BY total_sales DESC;
```
* **Key Finding:** **Branch C (Naypyitaw)** generated the highest total revenue ($110,568.71) with the top average customer satisfaction rating (7.07 / 10).

---

### 6. Value-Added Tax (VAT) & Margin Analysis
* **Query Objective:** Track VAT contributions per payment tender to support financial accounting.
* **SQL Implementation:**
```sql
SELECT 
    Payment_Method, 
    ROUND(SUM(VAT), 2) AS total_vat_collected,
    ROUND(SUM(Total), 2) AS total_revenue_processed
FROM sales
GROUP BY Payment_Method
ORDER BY total_vat_collected DESC;
```
* **Key Finding:** `Ewallet` and `Cash` transactions each account for approximately 34% of tax collections, highlighting high digital wallet penetration.

---

## 🛠️ Advanced SQL Techniques Demonstrated

* **Common Table Expressions (CTEs):** Modularized nested aggregation logic using `WITH RankedCategoryByGender AS (...)`.
* **Analytical Window Functions:** Applied `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` for segmented ranking without data collapse.
* **Conditional Logic & Case Statements:** Dynamically derived operational shifts and automated product performance tiers (`Good` vs. `Bad`) based on scalar subquery averages.
* **Temporal Functions:** Leveraged `HOUR()`, `DAYNAME()`, `MONTHNAME()`, and `FIELD()` for custom ordinal sorting of weekdays and shifts.
* **Data Cleansing & Idempotency:** Integrated `SET SQL_SAFE_UPDATES = 0` toggles and `DROP TABLE IF EXISTS` guards for safe, repeatable script execution.

---

## 🚀 Quickstart & Reproduction Guide

### Prerequisites
* **MySQL Server 8.0+** or **MySQL Workbench** installed locally.
* Git installed on your workstation.

### Step 1: Clone the Repository
```bash
git clone https://github.com/jadavharsh109/amazon-sales-sql-analytics.git
cd amazon-sales-sql-analytics
```

### Step 2: Database Initialization & Ingestion
Open your MySQL terminal or Workbench and execute:
```sql
SOURCE sql/01_schema_setup.sql;
```
*(Import `data/amazon_supermarket_sales.csv` using the Table Data Import Wizard or `LOAD DATA LOCAL INFILE` as documented in `01_schema_setup.sql`).*

### Step 3: Run Feature Engineering
```sql
SOURCE sql/02_feature_engineering.sql;
```

### Step 4: Execute Analytical Business Queries
```sql
SOURCE sql/03_advanced_analytics.sql;
```

---

## 📄 Project Documentation

For complete query outputs, visual chart analysis, and project presentation slides, refer to:
* 📑 **[`Amazon_Sales_Data_Report.pdf`](docs/Amazon_Sales_Data_Report.pdf)** located in the `docs/` folder.

---

## 👨‍💻 Author

**Harsh Jadav**
* 💼 **LinkedIn:** [linkedin.com/in/harshjadav0901](https://www.linkedin.com/in/harshjadav0901/)
* 🐙 **GitHub:** [github.com/jadavharsh109](https://github.com/jadavharsh109)
* 📧 **Email:** [jadavharsh109@gmail.com](mailto:jadavharsh109@gmail.com)

*If you found this project helpful or insightful, consider giving it a ⭐ on GitHub!*
