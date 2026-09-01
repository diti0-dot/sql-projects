
-- E-COMMERCE DATA CLEANING

-- 1. BACKUP

SELECT *
FROM ecommerce_retail_transactions_raw;

CREATE TABLE ecommerce_retail_transactions_raw_copy (
    Order_ID TEXT,
    Customer_ID TEXT,
    Order_Date TEXT,
    Product_Category TEXT,
    Product_Name TEXT,
    Quantity INT DEFAULT NULL,
    Unit_Price_USD DOUBLE DEFAULT NULL,
    Discount_Percent TEXT,
    Payment_Method TEXT,
    Shipping_City TEXT,
    Country TEXT,
    Order_Status TEXT,
    Customer_Rating TEXT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO ecommerce_retail_transactions_raw_copy
SELECT *
FROM ecommerce_retail_transactions_raw;


-- 2. DATE CLEANING

-- Check existing date formats
SELECT DISTINCT Order_Date
FROM ecommerce_retail_transactions_raw;

-- Convert dates such as '17 Jun 2024'
SELECT
    Order_Date,
    DATE_FORMAT(
        STR_TO_DATE(Order_Date, '%d %b %Y'),
        '%m/%d/%Y'
    ) AS cleaned_date
FROM ecommerce_retail_transactions_raw
WHERE SUBSTRING(Order_Date, 4, 3) REGEXP '[a-zA-Z]';

UPDATE ecommerce_retail_transactions_raw
SET Order_Date = DATE_FORMAT(
    STR_TO_DATE(Order_Date, '%d %b %Y'),
    '%m/%d/%Y'
)
WHERE SUBSTRING(Order_Date, 4, 3) REGEXP '[a-zA-Z]';


-- Convert YYYY/MM/DD and YYYY-MM-DD
SELECT
    Order_Date,
    CASE
        WHEN Order_Date LIKE '%/%/%'
            THEN DATE_FORMAT(
                STR_TO_DATE(Order_Date, '%Y/%m/%d'),
                '%m/%d/%Y'
            )
        WHEN Order_Date LIKE '%-%-%'
            THEN DATE_FORMAT(
                STR_TO_DATE(Order_Date, '%Y-%m-%d'),
                '%m/%d/%Y'
            )
    END AS cleaned_date
FROM ecommerce_retail_transactions_raw
WHERE SUBSTRING(Order_Date, 1, 4) REGEXP '^[0-9]{4}$';

UPDATE ecommerce_retail_transactions_raw
SET Order_Date =
    CASE
        WHEN Order_Date LIKE '%/%/%'
            THEN DATE_FORMAT(
                STR_TO_DATE(Order_Date, '%Y/%m/%d'),
                '%m/%d/%Y'
            )
        WHEN Order_Date LIKE '%-%-%'
            THEN DATE_FORMAT(
                STR_TO_DATE(Order_Date, '%Y-%m-%d'),
                '%m/%d/%Y'
            )
        ELSE NULL
    END
WHERE SUBSTRING(Order_Date, 1, 4) REGEXP '^[0-9]{4}$';


-- Convert MM-DD-YYYY
SELECT
    Order_Date,
    DATE_FORMAT(
        STR_TO_DATE(Order_Date, '%m-%d-%Y'),
        '%m/%d/%Y'
    ) AS cleaned_date
FROM ecommerce_retail_transactions_raw
WHERE Order_Date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';

UPDATE ecommerce_retail_transactions_raw
SET Order_Date = DATE_FORMAT(
    STR_TO_DATE(Order_Date, '%m-%d-%Y'),
    '%m/%d/%Y'
)
WHERE Order_Date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';

-- Validate date format
SELECT Order_Date
FROM ecommerce_retail_transactions_raw
WHERE Order_Date NOT REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$';


-- 3. QUANTITY

-- Find invalid quantities
SELECT DISTINCT Quantity
FROM ecommerce_retail_transactions_raw;

SELECT *
FROM ecommerce_retail_transactions_raw
WHERE Quantity < 1;

-- Remove invalid transactions
DELETE FROM ecommerce_retail_transactions_raw
WHERE Quantity < 1;


-- 4. PAYMENT METHOD

SELECT DISTINCT Payment_Method
FROM ecommerce_retail_transactions_raw;

-- Standardize payment method values
UPDATE ecommerce_retail_transactions_raw
SET Payment_Method = 'Net Banking'
WHERE Payment_Method LIKE 'Net%';

UPDATE ecommerce_retail_transactions_raw
SET Payment_Method = 'PayPal'
WHERE Payment_Method LIKE 'Pay%';

UPDATE ecommerce_retail_transactions_raw
SET Payment_Method = 'UPI'
WHERE Payment_Method LIKE 'U.%';

UPDATE ecommerce_retail_transactions_raw
SET Payment_Method = 'CREDIT CARD'
WHERE Payment_Method LIKE 'credit%';

UPDATE ecommerce_retail_transactions_raw
SET Payment_Method = 'DEBIT CARD'
WHERE Payment_Method LIKE 'debit%';

UPDATE ecommerce_retail_transactions_raw
SET Payment_Method = 'Cash on Delivery'
WHERE Payment_Method LIKE 'cod%';

-- Validate payment methods
SELECT DISTINCT Payment_Method
FROM ecommerce_retail_transactions_raw;


-- 5. COUNTRY

SELECT DISTINCT Country
FROM ecommerce_retail_transactions_raw;

-- Standardize country names
DELIMITER //

CREATE PROCEDURE Update_country(
    IN match_word TEXT,
    IN updated_to TEXT
)
BEGIN
    UPDATE ecommerce_retail_transactions_raw
    SET Country = updated_to
    WHERE Country LIKE match_word;
END //

DELIMITER ;

CALL Update_country('au%', 'Australia');
CALL Update_country('ca%', 'Canada');
CALL Update_country('de%', 'Germany');
CALL Update_country('ger%', 'Germany');
CALL Update_country('IN%', 'India');
CALL Update_country('UAE', 'UAE');
CALL Update_country('U.A.E', 'UAE');
CALL Update_country('U.k.', 'United Kingdom');
CALL Update_country('Uk', 'United Kingdom');
CALL Update_country('U.S.A', 'United States');
CALL Update_country('US', 'United States');
CALL Update_country('USA', 'United States');

-- Validate countries
SELECT DISTINCT Country
FROM ecommerce_retail_transactions_raw;


-- 6. DISCOUNT

-- Check missing discounts
SELECT *
FROM ecommerce_retail_transactions_raw
WHERE Discount_Percent = '';

-- Treat missing discounts as 0%
UPDATE ecommerce_retail_transactions_raw
SET Discount_Percent = 0.0
WHERE Discount_Percent = '';


-- 7. SHIPPING CITY

-- Remove duplicate pending records with missing shipping city
-- when the same customer, order, and product has another record.
DELETE e
FROM ecommerce_retail_transactions_raw e
JOIN (
    SELECT
        Customer_ID,
        Order_ID,
        Product_Name
    FROM ecommerce_retail_transactions_raw
    GROUP BY Customer_ID, Order_ID, Product_Name
    HAVING COUNT(*) > 1
) d
    ON e.Customer_ID = d.Customer_ID
    AND e.Order_ID = d.Order_ID
    AND e.Product_Name = d.Product_Name
WHERE e.Order_Status = 'Pending'
  AND e.Shipping_City = '';


-- Find missing cities with one known city
WITH known_cities AS (
    SELECT
        Customer_ID,
        Country,
        Shipping_City
    FROM ecommerce_retail_transactions_raw
    WHERE Shipping_City <> ''
),

unique_cities AS (
    SELECT
        Customer_ID,
        Country,
        MIN(Shipping_City) AS Shipping_City
    FROM known_cities
    GROUP BY Customer_ID, Country
    HAVING COUNT(DISTINCT Shipping_City) = 1
),

missing_cities AS (
    SELECT
        Customer_ID,
        Order_ID,
        Shipping_City,
        Country
    FROM ecommerce_retail_transactions_raw
    WHERE Shipping_City = ''
)

SELECT
    m.Customer_ID,
    m.Order_ID,
    m.Country,
    m.Shipping_City AS missing_city,
    u.Shipping_City AS city_to_use
FROM missing_cities m
JOIN unique_cities u
    ON m.Customer_ID = u.Customer_ID
    AND m.Country = u.Country;


-- Populate only unambiguous cities
WITH known_cities AS (
    SELECT
        Customer_ID,
        Country,
        Shipping_City
    FROM ecommerce_retail_transactions_raw
    WHERE Shipping_City <> ''
),

unique_cities AS (
    SELECT
        Customer_ID,
        Country,
        MIN(Shipping_City) AS Shipping_City
    FROM known_cities
    GROUP BY Customer_ID, Country
    HAVING COUNT(DISTINCT Shipping_City) = 1
)

UPDATE ecommerce_retail_transactions_raw AS m
JOIN unique_cities AS u
    ON m.Customer_ID = u.Customer_ID
    AND m.Country = u.Country
SET m.Shipping_City = u.Shipping_City
WHERE m.Shipping_City = '';

-- Check remaining missing cities
SELECT COUNT(*)
FROM ecommerce_retail_transactions_raw
WHERE Shipping_City = '';


-- 8. DATA VALIDATION

-- Check duplicate Order IDs
SELECT
    Order_ID,
    COUNT(*) AS occurrence_count
FROM ecommerce_retail_transactions_raw
GROUP BY Order_ID
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

-- Check invalid prices
SELECT *
FROM ecommerce_retail_transactions_raw
WHERE Unit_Price_USD < 0;

-- Check order statuses
SELECT DISTINCT Order_Status
FROM ecommerce_retail_transactions_raw
ORDER BY Order_Status;

SELECT *
FROM ecommerce_retail_transactions_raw
WHERE Order_ID IS NULL
   OR Order_ID = '';
   
SELECT *
FROM ecommerce_retail_transactions_raw
WHERE Customer_ID IS NULL
   OR Customer_ID = '';
   
SELECT
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    MIN(Unit_Price_USD) AS min_price,
    MAX(Unit_Price_USD) AS max_price
FROM ecommerce_retail_transactions_raw;


-- 9. REMOVE DUPLICATE ROWS

CREATE TEMPORARY TABLE clean_duplicates AS
SELECT DISTINCT *
FROM ecommerce_retail_transactions_raw;

TRUNCATE TABLE ecommerce_retail_transactions_raw;

INSERT INTO ecommerce_retail_transactions_raw
SELECT *
FROM clean_duplicates;

-- 10. Update date type 

UPDATE ecommerce_retail_transactions_raw
SET Order_Date = DATE_FORMAT(
    STR_TO_DATE(Order_Date, '%d/%m/%Y'),
    '%m/%d/%Y'
)
WHERE CAST(SUBSTRING_INDEX(Order_Date, '/', 1) AS UNSIGNED) > 12;
SELECT Order_Date
FROM ecommerce_retail_transactions_raw
WHERE STR_TO_DATE(Order_Date, '%m/%d/%Y') IS NULL;

ALTER TABLE ecommerce_retail_transactions_raw
ADD COLUMN Order_Date_new DATE;

UPDATE ecommerce_retail_transactions_raw
SET Order_Date_new = STR_TO_DATE(Order_Date, '%m/%d/%Y');

SELECT
    Order_Date,
    Order_Date_new
FROM ecommerce_retail_transactions_raw
LIMIT 20;

ALTER TABLE ecommerce_retail_transactions_raw
DROP COLUMN Order_Date;

ALTER TABLE ecommerce_retail_transactions_raw
RENAME COLUMN Order_Date_new TO Order_Date;

DESCRIBE ecommerce_retail_transactions_raw;

SELECT
    MIN(Order_Date) AS earliest_date,
    MAX(Order_Date) AS latest_date
FROM ecommerce_retail_transactions_raw;

SELECT DISTINCT Discount_Percent
FROM ecommerce_retail_transactions_raw
ORDER BY Discount_Percent;

ALTER TABLE ecommerce_retail_transactions_raw
MODIFY COLUMN Discount_Percent DECIMAL(5,2);

SELECT DISTINCT Customer_Rating
FROM ecommerce_retail_transactions_raw
ORDER BY Customer_Rating;

UPDATE ecommerce_retail_transactions_raw
SET Customer_Rating = NULL
WHERE Customer_Rating = '';

ALTER TABLE ecommerce_retail_transactions_raw
MODIFY COLUMN Customer_Rating INT;

SELECT DISTINCT Customer_Rating
FROM ecommerce_retail_transactions_raw
ORDER BY Customer_Rating;

ALTER TABLE ecommerce_retail_transactions_raw
MODIFY COLUMN Unit_Price_USD DECIMAL(10,2);

-- 11. FINAL CHECK

SELECT COUNT(*) AS final_row_count
FROM ecommerce_retail_transactions_raw;

SELECT *
FROM ecommerce_retail_transactions_raw;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Order_ID) AS unique_orders,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    SUM(Quantity < 1) AS invalid_quantities,
    SUM(Unit_Price_USD < 0) AS invalid_prices,
    SUM(Shipping_City = '') AS missing_cities,
    SUM(Customer_Rating IS NULL OR Customer_Rating = '') AS missing_ratings
FROM ecommerce_retail_transactions_raw;

