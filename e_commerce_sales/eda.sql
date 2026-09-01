
-- EXPLORATORY DATA ANALYSIS

-- 1. Dataset overview

DESCRIBE ecommerce_retail_transactions_raw;

SELECT COUNT(*) AS total_rows
FROM ecommerce_retail_transactions_raw;

-- Check dataset size and remaining data quality issues
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Order_ID) AS unique_orders,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    SUM(Quantity < 1) AS invalid_quantities,
    SUM(Unit_Price_USD < 0) AS invalid_prices,
    SUM(Shipping_City = '') AS missing_cities,
    SUM(Customer_Rating IS NULL) AS missing_ratings
FROM ecommerce_retail_transactions_raw;

-- Countries in the dataset
SELECT DISTINCT Country
FROM ecommerce_retail_transactions_raw;

-- Product categories
SELECT DISTINCT Product_Category
FROM ecommerce_retail_transactions_raw;


-- 2. Order status analysis

SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS order_count
FROM ecommerce_retail_transactions_raw
GROUP BY Order_Status
ORDER BY order_count DESC;


-- 3. Customer analysis

-- Number of unique customers
SELECT COUNT(DISTINCT Customer_ID) AS total_customers
FROM ecommerce_retail_transactions_raw;

-- Number of repeat customers
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT Customer_ID
    FROM ecommerce_retail_transactions_raw
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Order_ID) > 1
) AS repeat_customers;

-- Top customers by delivered revenue
SELECT
    Customer_ID,
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS customer_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
ORDER BY customer_revenue DESC;

-- Average order value
WITH order_totals AS (
    SELECT
        Order_ID,
        SUM(
            Quantity * Unit_Price_USD
            * (1 - Discount_Percent / 100)
        ) AS order_value
    FROM ecommerce_retail_transactions_raw
    WHERE Order_Status = 'Delivered'
    GROUP BY Order_ID
)
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM order_totals;


-- 4. Product analysis

-- Best-selling products by units sold
SELECT
    Product_Name,
    SUM(Quantity) AS total_units_sold
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Product_Name
ORDER BY total_units_sold DESC;

-- Revenue by product
SELECT
    Product_Name,
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS product_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Product_Name
ORDER BY product_revenue DESC;

-- Most frequently returned products
SELECT
    Product_Name,
    COUNT(DISTINCT Order_ID) AS returned_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Returned'
GROUP BY Product_Name
ORDER BY returned_orders DESC;

-- Most frequently cancelled products
SELECT
    Product_Name,
    COUNT(DISTINCT Order_ID) AS cancelled_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Cancelled'
GROUP BY Product_Name
ORDER BY cancelled_orders DESC;


-- 5. Revenue analysis

-- Total delivered revenue
SELECT
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS total_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered';

-- Revenue by country
SELECT
    Country,
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS country_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Country
ORDER BY country_revenue DESC;

-- Revenue by product category
SELECT
    Product_Category,
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS category_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Product_Category
ORDER BY category_revenue DESC;

-- Revenue by year
SELECT
    YEAR(Order_Date) AS order_year,
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS yearly_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY YEAR(Order_Date)
ORDER BY order_year;


-- 6. Discount analysis

-- Sales volume by discount level
SELECT
    Discount_Percent,
    SUM(Quantity) AS total_units_sold,
    COUNT(DISTINCT Order_ID) AS number_of_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Discount_Percent
ORDER BY Discount_Percent;

-- Average discount by product category
SELECT
    Product_Category,
    ROUND(AVG(Discount_Percent), 2) AS average_discount
FROM ecommerce_retail_transactions_raw
GROUP BY Product_Category
ORDER BY average_discount DESC;

-- Maximum discount by product category
SELECT
    Product_Category,
    MAX(Discount_Percent) AS maximum_discount
FROM ecommerce_retail_transactions_raw
GROUP BY Product_Category
ORDER BY maximum_discount DESC;


-- 7. Geographic analysis

-- Orders by country
SELECT
    Country,
    COUNT(DISTINCT Order_ID) AS order_count
FROM ecommerce_retail_transactions_raw
GROUP BY Country
ORDER BY order_count DESC;

-- Orders by shipping city
SELECT
    Shipping_City,
    COUNT(DISTINCT Order_ID) AS order_count
FROM ecommerce_retail_transactions_raw
WHERE Shipping_City <> ''
GROUP BY Shipping_City
ORDER BY order_count DESC;


-- 8. Time-based analysis

-- Delivered orders by year
SELECT
    YEAR(Order_Date) AS order_year,
    COUNT(DISTINCT Order_ID) AS delivered_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY YEAR(Order_Date)
ORDER BY order_year;


-- 9. Data patterns

-- Cancelled orders by country
SELECT
    Country,
    COUNT(DISTINCT Order_ID) AS cancelled_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Cancelled'
GROUP BY Country
ORDER BY cancelled_orders DESC;

-- Relationship between discounts and sales volume
SELECT
    Discount_Percent,
    SUM(Quantity) AS total_units_sold,
    COUNT(DISTINCT Order_ID) AS number_of_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Discount_Percent
ORDER BY Discount_Percent;

-- Product return rates
SELECT
    Product_Name,
    COUNT(DISTINCT CASE
        WHEN Order_Status = 'Returned' THEN Order_ID
    END) AS returned_orders,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN Order_Status = 'Returned' THEN Order_ID
        END)
        / COUNT(DISTINCT Order_ID) * 100,
        2
    ) AS return_rate_percent
FROM ecommerce_retail_transactions_raw
GROUP BY Product_Name
ORDER BY return_rate_percent DESC;

