--Creating a table structure to import data in it
CREATE TABLE zepto (
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	product_name VARCHAR(120) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	packageQuantity INTEGER
);

--DATA EXPLORATION

--sample data
SELECT * FROM zepto 
ORDER BY sku_id
LIMIT 50;

--total rows
SELECT COUNT(*) AS records 
FROM zepto;

--check nulls
SELECT * FROM zepto
WHERE category IS NULL
OR product_name IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR availableQuantity IS NULL
OR discountedPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR packageQuantity IS NULL;

--check duplicate rows
SELECT product_name,
		category,
		weightInGms,
		mrp,
		discountPercent,
		availableQuantity,
		discountedPrice,
		outOfStock, 
		packageQuantity FROM zepto
GROUP BY product_name,
		category,
		weightInGms,
		mrp,
		discountPercent,
		availableQuantity,
		discountedPrice,
		outOfStock, 
		packageQuantity
HAVING COUNT(*) >1;

--different product categories 
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products inStock Vs outOfStock
SELECT COUNT(CASE WHEN outOfStock = FALSE THEN 1 END) AS in_stock,
	COUNT(CASE WHEN outOfStock = TRUE THEN 1 END) AS out_of_stock
	FROM zepto;

--another method
SELECT outOfStock , COUNT(sku_id) AS stock_count
FROM zepto
GROUP BY outOfStock;

--unique products
SELECT COUNT(DISTINCT product_name) AS unique_products
FROM zepto;

--product names appearing multiple times
SELECT product_name, COUNT(sku_id) AS "Number_of_SKUs" 
FROM zepto
GROUP BY product_name
HAVING COUNT(sku_id) >1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING AND PREPROCESSING

--remove duplicate records
DELETE FROM zepto
WHERE sku_id NOT IN (
    SELECT MIN(sku_id)
    FROM zepto
    GROUP BY 
        product_name,
        category,
        weightInGms,
        mrp,
        discountPercent,
        availableQuantity,
        discountedPrice,
        outOfStock, 
        packageQuantity
);

--finding invalid products
SELECT * FROM zepto
WHERE mrp =0.0
OR discountedPrice = 0.0;

--deleting rows where price is zero
DELETE FROM zepto
WHERE mrp =0.0
OR discountedPrice = 0.0;

--converting price from paise to rupees
--1 rupees= 100.0 paise
UPDATE zepto
SET mrp=mrp/100.0,
discountedPrice=discountedPrice/100.0;

--DATA ANALYSIS

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT product_name,mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT product_name, mrp, discountedPrice
FROM zepto
WHERE outOfStock=TRUE
AND mrp>200
ORDER BY mrp DESC;


-- Q3.Calculate total inventory value for each category
SELECT category,
SUM(discountedPrice * availableQuantity) AS inventory_value
FROM zepto
GROUP BY category
ORDER BY inventory_value DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT product_name, mrp , discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, ROUND(AVG(discountPercent),2) AS avg_discount_percent
FROM zepto
GROUP BY category
ORDER BY avg_discount_percent DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT product_name, discountedPrice, weightInGms,
ROUND((discountedPrice/weightInGms),2) AS price_per_gram
FROM zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;

-- Q7.What is the Total Inventory Weight Per Category 
SELECT category, 
ROUND((SUM(weightInGms * availableQuantity)/1000.0),3) AS total_weight_in_KG
FROM zepto
GROUP BY category
ORDER BY total_weight_in_KG DESC;

-- Q8.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT product_name, weightInGms, 
CASE WHEN weightInGms < 500 THEN 'Low'
	WHEN weightInGms < 2000 THEN 'Medium'
	ELSE 'Bulk' END AS wt_category
FROM zepto;

-- Q9.Inventory value by weight category
SELECT wt_category, 
SUM(discountedPrice * availableQuantity) AS inventory_value
FROM
(SELECT DISTINCT product_name, weightInGms,
discountedPrice, availableQuantity,
CASE WHEN weightInGms < 500 THEN 'Low'
	WHEN weightInGms < 2000 THEN 'Medium'
	ELSE 'Bulk' END AS wt_category
FROM zepto) AS t
GROUP BY wt_category;

-- Q10.Out of stock percentage by category
SELECT category, 
COUNT(sku_id) AS total_skus,
COUNT(CASE WHEN outOfStock=TRUE THEN 1 END) AS out_of_stock_skus,
ROUND(COUNT(CASE WHEN outOfStock=TRUE THEN 1 END)*100.0/COUNT(sku_id),2) AS out_of_stock_percent
FROM zepto
GROUP BY category
ORDER BY out_of_stock_percent DESC;

