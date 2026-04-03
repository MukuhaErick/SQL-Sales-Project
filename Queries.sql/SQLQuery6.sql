-- CHANGE OVERTIME TRENDS
SELECT 
order_date,
SUM (sales_amount) as total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;

SELECT 
YEAR (order_date) as order_year,
MONTH (order_date) as order_month,
SUM (sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM (quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH (order_date)
ORDER BY YEAR(order_date),MONTH (order_date);

SELECT 
DATETRUNC (MONTH, order_date) as order_date,

SUM (sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM (quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (MONTH ,order_date)
ORDER BY DATETRUNC (MONTH ,order_date);

SELECT 
FORMAT(order_date,'yyyy-MMM') as order_date,

SUM (sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM (quantity) as total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY FORMAT (order_date, 'yyyy-MMM')
ORDER BY FORMAT (order_date, 'yyyy-MMM')

-- CUMULATIVE ANALYSIS
-- 1.Calculate the total sales per month
-- 2.The running total of sales over time

SELECT
DATETRUNC (month,order_date) as order_date,
SUM (sales_amount) AS total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (month,order_date)
ORDER BY DATETRUNC (month,order_date) ;


SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM 
(
SELECT
DATETRUNC (month,order_date) as order_date,
SUM (sales_amount) AS total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (month,order_date)
)t

-- IN PARTITIONING THE CF STARTS AGAIN IN NEW MONTH
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY order_date) AS running_total_sales
FROM 
(
SELECT
DATETRUNC (month,order_date) as order_date,
SUM (sales_amount) AS total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (month,order_date)
)t;

SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price
FROM 
(
SELECT
DATETRUNC (year,order_date) as order_date,
SUM (sales_amount) AS total_sales,
AVG(price) as avg_price
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC (year,order_date)
)t
 





