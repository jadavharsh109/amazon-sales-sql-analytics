# 🛒 Amazon E-Commerce & Retail Sales Analytics

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-00758F?style=for-the-badge&logo=sqlite&logoColor=white)](https://en.wikipedia.org/wiki/SQL)
[![Domain](https://img.shields.io/badge/Domain-Retail%20%26%20Sales-E67E22?style=for-the-badge)](https://github.com/jadavharsh109/amazon-sales-sql-analytics)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Harsh%20Jadav-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/harshjadav0901/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

A complete **SQL data analysis project** examining 1,000 retail sales transactions across three supermarket branches (Yangon, Naypyitaw, and Mandalay) during the first three months of 2019. 

The goal of this project is to understand sales patterns, customer buying habits, peak shopping hours, and branch performance to help store managers make better business decisions.

---

## 📑 Table of Contents
- [📌 Project Overview](#-project-overview)
- [📁 Project Files](#-project-files)
- [🗄️ Dataset Details](#️-dataset-details)
- [⚙️ New Features Created](#️-new-features-created)
- [📊 Key Business Insights](#-key-business-insights)
- [🛠️ SQL Skills Used](#️-sql-skills-used)
- [🚀 How to Run This Project](#-how-to-run-this-project)
- [📄 Project Report](#-project-report)
- [👨‍💻 Author](#-author)

---

## 📌 Project Overview

Running a multi-branch retail store comes with common business challenges:
* Which product categories bring in the most money?
* Do loyalty club members actually spend more than normal customers?
* What time of day do most people shop, and when should more staff be scheduled?
* Which city branch is performing best in sales and customer happiness?

This project uses SQL to clean the sales data, build new time-based columns, and answer these questions directly.

---

## 📁 Project Files

```
amazon-sales-sql-analytics/
├── data/
│   └── amazon_supermarket_sales.csv     # 1,000 real retail sales records
├── sql/
│   ├── 01_schema_setup.sql              # Creates the database and sales table
│   ├── 02_feature_engineering.sql       # Adds time of day, day name, and month name
│   └── 03_advanced_analytics.sql        # 37 business queries answering key questions
├── docs/
│   └── Amazon_Sales_Data_Report.pdf     # Full project report with charts and results
├── .gitignore                           # Git settings
├── LICENSE                              # MIT License
└── README.md                            # Project documentation
```

---

## 🗄️ Dataset Details

The dataset contains 1,000 rows and 17 columns tracking every purchase:

| Column | What It Means |
| :--- | :--- |
| `Invoice_ID` | Unique receipt number for each sale |
| `Branch` | Store branch code (`A`, `B`, or `C`) |
| `City` | Store location (`Yangon`, `Naypyitaw`, `Mandalay`) |
| `Customer_Type` | Customer membership status (`Member` or `Normal`) |
| `Gender` | Customer gender (`Male` or `Female`) |
| `Product_Line` | Product category (e.g. Food & Beverages, Fashion) |
| `Unit_Price` | Price of a single item in USD |
| `Quantity` | Number of items bought |
| `VAT` | 5% tax added to the purchase |
| `Total` | Total bill amount including tax |
| `Purchase_Date` | Date of purchase (January to March 2019) |
| `Purchase_Time` | Exact time the receipt was printed |
| `Payment_Method`| Payment type (`Cash`, `Credit card`, or `Ewallet`) |
| `COGS` | Cost of Goods Sold (store cost) |
| `Gross_Income` | Profit earned on the sale |
| `Rating` | Customer review score (from 1 to 10) |

---

## ⚙️ New Features Created

To help analyze shopping habits by time and day, three new columns were added to the table using SQL:

1. **`Time_of_day`**: Divides purchases into three shifts:
   * **Morning:** 6:00 AM – 11:59 AM
   * **Afternoon:** 12:00 PM – 5:59 PM
   * **Evening:** 6:00 PM – 11:59 PM
2. **`day_name`**: The weekday of the purchase (`Monday`, `Tuesday`, etc.) to see which days are busiest.
3. **`month_name`**: The month name (`January`, `February`, `March`) to track month-over-month growth.

---

## 📊 Key Business Insights

Here are the main findings discovered from the data:

### 1. Best Selling Products
* **`Food and beverages`** and **`Sports and travel`** made the most money, generating over **$56,000 each** (making up more than 35% of all store revenue).
* **`Health and beauty`** had the lowest sales volume, suggesting the store should either promote these products better or adjust inventory.

### 2. Members vs. Regular Walk-in Shoppers
* Total visits were almost an even 50/50 split between loyalty members (501 visits) and regular walk-ins (499 visits).
* However, **members spent more per basket** (averaging **$324.97** per visit compared to **$318.99** for regular customers), proving the loyalty program brings higher cart values.

### 3. Shopping Preferences by Gender
* **Female customers** purchased most often in **`Fashion accessories`**, followed closely by `Food and beverages`.
* **Male customers** shopped most often in **`Health and beauty`**, followed by `Electronic accessories`.

### 4. Peak Shopping Hours
* **Afternoon (12:00 PM to 6:00 PM) is the busiest time of day**, bringing in over **52% of all daily sales and customer visits**.
* Evenings are the second busiest, while mornings have the lowest footfall. 
* *Business Recommendation:* Schedule more checkout cashiers and floor staff between 12:00 PM and 6:00 PM to keep wait times low.

### 5. Top Performing Store Branch
* **Branch C in Naypyitaw** was the clear winner:
  * Highest Total Sales: **$110,568.71**
  * Highest Customer Rating: **7.07 out of 10**
* Branch A (Yangon) came second in sales ($106,200), while Branch B (Mandalay) had the lowest sales ($106,197) but remained very close.

### 6. Preferred Payment Methods
* **E-wallets (digital payments) and Cash were tied for first place**, each taking about **34% of all transactions**.
* Credit cards accounted for the remaining 32%, showing customers like having multiple payment options.

### 7. Customer Satisfaction Timing
* Customers gave their **highest ratings during afternoon transactions**, matching the peak traffic hours. This shows the store maintains good customer service even during busy hours.

---

## 🛠️ SQL Skills Used

* **Database & Table Setup:** `CREATE TABLE`, data types, and primary keys.
* **Feature Engineering:** `ALTER TABLE` and `UPDATE` using `CASE WHEN` logic and date functions (`HOUR`, `DAYNAME`, `MONTHNAME`).
* **Summary Numbers:** `SUM`, `AVG`, `MIN`, `MAX`, and `COUNT`.
* **Grouping & Filtering:** `GROUP BY`, `ORDER BY`, and `HAVING` filters.
* **Advanced Ranking:** Common Table Expressions (`WITH ... AS`) and Window Functions (`ROW_NUMBER() OVER (PARTITION BY ...)`).
* **Subqueries:** Comparing individual category sales against storewide averages.

---

## 🚀 How to Run This Project

### What You Need
* MySQL Server or MySQL Workbench installed on your computer.

### Quick Setup Steps
1. **Clone this repository:**
   ```bash
   git clone https://github.com/jadavharsh109/amazon-sales-sql-analytics.git
   cd amazon-sales-sql-analytics
   ```
2. **Set up the database and import data:**
   * Run [`sql/01_schema_setup.sql`](sql/01_schema_setup.sql).
   * Import [`data/amazon_supermarket_sales.csv`](data/amazon_supermarket_sales.csv) using the MySQL Workbench Table Data Import Wizard.
3. **Run feature engineering:**
   * Run [`sql/02_feature_engineering.sql`](sql/02_feature_engineering.sql) to add the time and day columns.
4. **Run the analysis queries:**
   * Run [`sql/03_advanced_analytics.sql`](sql/03_advanced_analytics.sql) to see all the business insights.

---

## 📄 Project Report

For full charts, query screenshots, and presentation slides, check out:
* 📑 **[`Amazon_Sales_Data_Report.pdf`](docs/Amazon_Sales_Data_Report.pdf)** in the `docs/` folder.

---

## 👨‍💻 Author

**Harsh Jadav**
* 💼 **LinkedIn:** [linkedin.com/in/harshjadav0901](https://www.linkedin.com/in/harshjadav0901/)
* 🐙 **GitHub:** [github.com/jadavharsh109](https://github.com/jadavharsh109)
* 📧 **Email:** [jadavharsh109@gmail.com](mailto:jadavharsh109@gmail.com)

*If this project was helpful to you, feel free to give it a ⭐!*
