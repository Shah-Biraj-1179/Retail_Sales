-- SQL RETAIL SALES ANALYSIS - project1

-- Create TABLE
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales
			(
			   transactions_id INT PRIMARY KEY,
			   sale_date DATE,
			   sale_time TIME,
			   customer_id INT,
			   gender VARCHAR(10),
			   age INT,
			   category VARCHAR(25), 
			   quantity INT, 
			   price_per_unit FLOAT,
			   cogs FLOAT,
			   total_sale FLOAT
			);

SELECT * FROM Retail_Sales
LIMIT 20

SELECT 
    COUNT(*) 
FROM Retail_Sales

-- Data Cleaning
SELECT * FROM Retail_Sales
WHERE
    transactions_id IS NULL
    OR
	sale_date IS NULL
	OR
    sale_time IS NULL
	OR
    customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL


DELETE FROM Retail_Sales
WHERE
    transactions_id IS NULL
    OR
	sale_date IS NULL
	OR
    sale_time IS NULL
	OR
    customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM Retail_Sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM Retail_Sales

-- How many unique categories we have?
SELECT DISTINCT category FROM Retail_Sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis and Findings
-- Q1) Write a SQL query to retrieve all columns for sales made on '2022-01-08'
-- Q2) Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 4 in the month of Nov-2022
-- Q3) Write a SQL query to calculate the total sales (total_sale) for each category
-- Q4) Write a SQL query to find the average age of customers who purchased items from the 'Clothing' category
-- Q5) Write a SQL query to find all transactions where the total_sale is greater than 1350.
-- Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q8) Write a SQL query to find the top 5 customers based on the highest total sales
-- Q9) Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


-- Q1) Write a SQL query to retrieve all columns for sales made on '2022-01-08'

SELECT * FROM Retail_Sales WHERE sale_date = '2022-10-08';

-- Q2) Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 3 in the month of Sept-2023

SELECT 
   *
FROM Retail_Sales
WHERE category = 'Beauty'
     AND
	 TO_CHAR(sale_date, 'YYYY-MM') = '2023-09'
	 AND
	 quantity >= 3

-- Q3) Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
    category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM Retail_Sales
GROUP BY 1;


-- Q4) Write a SQL query to find the average age of customers who purchased items from the 'Clothing' category

SELECT 
    ROUND(AVG(age), 2) as avg_age
FROM Retail_Sales
WHERE category = 'Clothing'


-- Q5) Write a SQL query to find all transactions where the total_sale is greater than 1350.

SELECT * FROM Retail_Sales
WHERE total_sale > 1350


-- Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
    category,
	gender,
	COUNT(*) as total_trans
FROM Retail_Sales
GROUP 
    BY 
	category,
	gender
ORDER BY 1


-- Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
     year,
	 month,	
	avg_sale
FROM(
SELECT
    EXTRACT(YEAR FROM sale_date) as year,
	-- YEAR(sale_date) & MONTH(sale_date) in MySQL
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as  rank
FROM Retail_Sales
GROUP BY 1, 2
-- ORDER BY 1, 3 DESC
) as T1
WHERE rank = 1


-- Q8) Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
    customer_id,
	SUM(total_sale) as toatal_sales
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q9) Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM Retail_Sales
GROUP BY category


-- Q10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

-- SELECT *,
--     CASE
-- 	    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
-- 		WHEN EXTRACT(HOUR FROM sale_time) Between 12 AND 17 THEN 'Afternoon'
-- 		ELSE 'Evening'
-- 	END as shift
-- FROM Retail_Sales

WITH hourly_sale
AS
(
SELECT *,
    CASE
	    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) Between 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM Retail_Sales
)
SELECT 
    shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)