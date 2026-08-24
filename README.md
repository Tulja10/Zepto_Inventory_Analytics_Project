# 🛒 Zepto Inventory Analytics: SQL + Power BI Dashboard

A SQL and Power BI project that looks at product-level inventory data from Zepto (a quick-commerce grocery delivery app), with a focus on stock-outs, discounting, and category performance.

## Purpose

This project uses a Zepto inventory dataset to answer real business questions about stock-outs, discounts, and category performance. Data was explored, cleaned, and analyzed in PostgreSQL, then loaded into Power BI to build a two-page interactive dashboard. The goal is to show a simple, complete analyst workflow: raw data → SQL cleaning and analysis → dashboard → business insight.

## Tech Stack

- 🐘 **PostgreSQL (pgAdmin)** – Used to explore, clean, and analyze the data with SQL
- 📊 **Power BI Desktop** – Used to build the dashboard and reports
- 🧠 **DAX (Data Analysis Expressions)** – Used for calculated columns and measures for KPI cards and category-level calculations.
- 📁 **File Formats** – `.sql` (queries), `.pbix` (dashboard), `.pdf` (dashboard previews)

## Data Source

Dataset: Zepto inventory data, downloaded from Kaggle. It's a single table (`zepto`) with one row per product, including category, product name, MRP, discount %, discounted price, available quantity, weight (grams), stock status, and package quantity.

## Features / Highlights

### Business Problem
Quick-commerce companies like Zepto run on thin margins and fast delivery, so knowing what's in stock and how it's priced matters a lot. Questions like "which categories run out of stock most," "how much are we discounting," and "where is our inventory value sitting" are hard to answer from raw data without proper analysis.

### Goal of the Project
- Clean and check the raw inventory data using SQL
- Answer 10 business questions directly in PostgreSQL
- Build a Power BI dashboard to show stock health, pricing, and category performance
- Let the viewer filter and drill down by category, stock status, and discount range

### Workflow

1. **Data Exploration (PostgreSQL)** — checked sample rows, total row count, null values, duplicate rows, distinct categories, and in-stock vs. out-of-stock counts.
2. **Data Cleaning (PostgreSQL)** — removed duplicate rows, deleted invalid rows (zero MRP or zero discounted price), and fixed currency values (converted from paise to rupees).
3. **Data Analysis (PostgreSQL)** — wrote 10 SQL queries to answer specific business questions (listed below).
4. **Visualization (Power BI)** — connected Power BI directly to the cleaned PostgreSQL table and built a 2-page dashboard.

### SQL Business Questions Answered
| # | Question |
|---|----------|
| 1 | Top 10 best-value products by discount percentage |
| 2 | Products with high MRP that are out of stock |
| 3 | Total inventory value per category |
| 4 | Products with MRP > ₹500 and discount < 10% |
| 5 | Top 5 categories by average discount percentage |
| 6 | Price-per-gram for products above 100g (best value) |
| 7 | Total inventory weight per category (in KG) |
| 8 | Weight-based product segmentation (Low / Medium / Bulk) |
| 9 | Inventory value by weight category |
| 10 | Out-of-stock percentage by category |

Full queries: [`analysis_queries.sql`](analysis_queries.sql)

### Dashboard Walkthrough

**Page 1 — Inventory Overview**
- **KPI cards:** Total SKUs (3,729), Unique Products (1,669), Inventory Units (14,947), Inventory Value (2.24M), Out-of-Stock Rate (12.15%)
- **Inventory Value & Avg Discount % by Category** (combo chart) — shows how much stock value each category holds, next to its average discount
- **Out-of-Stock Rate by Category** (bar chart) — shows which categories run out of stock the most
- **Total SKUs by Category** (bar chart) — shows how many products each category has

**Page 2 — Product & Pricing Analysis**
- **Filters:** Category, Out-of-stock status, Discount % range
- **Top 10 Products by Discounted Amount** (bar chart) — products where the business is giving away the most money in discounts (not just the highest discount %)
- **MRP vs. Discount %** (scatter plot) — shows the pricing pattern across all products, with a marked "High MRP, Low Discount" zone for premium products that aren't discounted much
- **Detail table** — product-level table with a running total of inventory value

### Key Insights
- **Biscuits has the highest out-of-stock rate at 29%**, more than double the overall average (~12%) — the top category to restock first.
- **Beverages and Dairy, Bread & Batter are next at 22% out-of-stock each**, showing repeated supply gaps in daily-use categories.
- **Cooking Essentials and Munchies have the most stock value and the most variety in products (514 SKUs each)**, but a lower-than-average discount (~7%) — these categories sell on volume, not discounts.
- **Fruits & Vegetables, Paan Corner, and Personal Care have the lowest out-of-stock rate (6%)**, meaning supply is more reliable in these categories.
- A small group of **high-MRP products (₹1,000+) get very little discount**, while a couple of outliers still get 40%+ off — worth a closer look to see which ones are premium items and which one needs to remove.

### Business Impact
- **Inventory/Ops teams** can focus restocking on the categories running out most, like Biscuits and Beverages.
- **Pricing teams** can check discount levels against stock value to spot categories that may be over- or under-discounted.
- **Anyone reviewing the business** gets one dashboard to check stock health and pricing trends, without writing SQL themselves.

## How to View
- Open `zepto_dashboard.pbix` in Power BI Desktop for the full interactive report, or
- View `zepto_dashboard_preview.pdf` for a static preview.
