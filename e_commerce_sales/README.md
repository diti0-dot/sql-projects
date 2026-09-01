# E-Commerce Sales Analytics Mini Case Study

## Exploratory Data Analysis

This section explores the cleaned e-commerce transaction data to understand customer behavior, product performance, revenue, discounts, and order outcomes.

---

### 1. How many unique orders and customers are there?

We start by identifying the total number of unique orders and customers in the dataset.

```sql
SELECT
    COUNT(DISTINCT Order_ID) AS unique_orders,
    COUNT(DISTINCT Customer_ID) AS unique_customers
FROM ecommerce_retail_transactions_raw;
```

**Answer:**
<img width="173" height="39" alt="image" src="https://github.com/user-attachments/assets/683ae992-4c5e-4931-a132-32b912118461" />

> **11810** unique orders and **3368** unique customers.

---

### 2. What is the distribution of order statuses?

Understanding the distribution of order statuses helps us see how many orders were delivered, cancelled, returned, or are still pending.

```sql
SELECT
    Order_Status,
    COUNT(Order_Status) AS orders_distribution
FROM ecommerce_retail_transactions_raw
GROUP BY Order_Status;
```

**Answer:**
<img width="166" height="94" alt="image" src="https://github.com/user-attachments/assets/df45e368-7e5f-4742-b09b-d944ecfa3d84" />

---

### 3. What percentage of orders are delivered?

The delivery rate shows what percentage of all orders were successfully completed.

```sql
SELECT
    ROUND(
        COUNT(DISTINCT CASE
            WHEN Order_Status = 'Delivered' THEN Order_ID
        END)
        * 100.0 / COUNT(DISTINCT Order_ID),
        2
    ) AS delivered_order_percentage
FROM ecommerce_retail_transactions_raw;
```

**Answer:**
<img width="149" height="36" alt="image" src="https://github.com/user-attachments/assets/c93ca84f-b83e-4227-bd92-6059356f46dd" />

> **54.80%** of orders were successfully delivered.

---

### 4. How many customers are repeat customers?

Repeat customers are identified as customers with more than one delivered order.

```sql
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT Customer_ID
    FROM ecommerce_retail_transactions_raw
    WHERE Order_Status = 'Delivered'
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT Order_ID) > 1
) AS repeat_customers;
```

**Answer:**
<img width="104" height="36" alt="image" src="https://github.com/user-attachments/assets/9c7c89d6-b415-4f80-8c43-a71c5949136e" />

> **1945** customers made more than one delivered order.

---

### 5. What is the average order value?

To calculate Average Order Value (AOV), we first calculate the value of each delivered order and then take the average across all orders.

Discounts are included in the calculation to represent the actual value after the applied discount.

```sql
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
```

**Answer:**
<img width="118" height="37" alt="image" src="https://github.com/user-attachments/assets/a6348741-a01b-44c0-9bd0-11c5bee69ba6" />

> The average delivered order value is **$119.03**.

---

### 6. Which customers generate the most revenue?

This identifies the customers contributing the highest amount of delivered revenue after discounts.

```sql
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
```

**Answer:**
<img width="158" height="165" alt="image" src="https://github.com/user-attachments/assets/c0c0fedd-7cfa-4ea0-85eb-43c8e903a051" />

> **CUST00996** generated the highest revenue at **$1992.47**.

---

### 7. Which products sell the most units?

Here we look at the total number of units sold for each product, considering only delivered orders.

```sql
SELECT
    Product_Name,
    SUM(Quantity) AS total_units_sold
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Product_Name
ORDER BY total_units_sold DESC;
```

**Answer:**
<img width="173" height="173" alt="image" src="https://github.com/user-attachments/assets/3409759c-2c0f-4540-9b47-c6fd45b19845" />

> **Kids Storybook** was the best-selling product with **484 units sold**.

---

### 8. Which products generate the most revenue?

Revenue is calculated using quantity, unit price, and the applied discount.

```sql
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
```

**Answer:**
<img width="168" height="170" alt="image" src="https://github.com/user-attachments/assets/57095428-93e0-4285-8da8-d4dd88aa3320" />

> **Smartwatch** generated the highest revenue at **$30246.02**.

---

### 9. Which products have the highest return rates?

Rather than looking only at the number of returned orders, we calculate the percentage of a product's orders that were returned.

```sql
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
        * 100.0 / COUNT(DISTINCT Order_ID),
        2
    ) AS return_rate_percent

FROM ecommerce_retail_transactions_raw
GROUP BY Product_Name
ORDER BY return_rate_percent DESC;
```

**Answer:**

<img width="321" height="174" alt="image" src="https://github.com/user-attachments/assets/538d4e83-392a-446f-a635-93125cb0c14b" />

> **Webcam** had the highest return rate at **11.38%**.

---

### 10. What is the total revenue?

Total revenue represents the value generated from delivered orders after discounts.

```sql
SELECT
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS total_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered';
```

**Answer:**
<img width="104" height="35" alt="image" src="https://github.com/user-attachments/assets/c7c7c5cd-fca9-44fa-8718-2f5ca57832df" />

> Total delivered revenue was **$770333.42**.

---

### 11. Which countries generate the most revenue?

This helps identify which markets contribute the most to overall delivered revenue.

```sql
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
```

**Answer:**
<img width="200" height="110" alt="image" src="https://github.com/user-attachments/assets/32d639e1-c829-4deb-ba95-95d180590ed7" />

> **UAE** generated the highest revenue at **$118320.68**.

---

### 12. Which categories generate the most revenue?

This shows which product categories contribute the most to total delivered revenue.

```sql
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
```

**Answer:**
<img width="176" height="121" alt="image" src="https://github.com/user-attachments/assets/a73a216a-0b94-4474-a9df-7e8adeb9c719" />

> **Electronics** was the highest-revenue category, generating **$205476.02**.

---

### 13. How does revenue change over time?

We aggregate delivered revenue by year to identify changes in sales performance over time.

```sql
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
```

**Answer:**

> <img width="154" height="60" alt="image" src="https://github.com/user-attachments/assets/e78462fc-506c-4203-9ff6-ea45ddc28526" />


**Insight:**

> Revenue **decreased** over the period analyzed, with **2024** generating the highest revenue. Revenue remained relatively stable from 2024 to 2025, before declining significantly in 2026.


---

### 14. Are higher discounts associated with higher sales volume?

We compare discount levels with the number of units sold and orders placed. This helps identify whether higher discounts are associated with greater sales volume.

```sql
SELECT
    Discount_Percent,
    SUM(Quantity) AS total_units_sold,
    COUNT(DISTINCT Order_ID) AS number_of_orders
FROM ecommerce_retail_transactions_raw
WHERE Order_Status = 'Delivered'
GROUP BY Discount_Percent
ORDER BY Discount_Percent;
```

**Answer:**

> <img width="245" height="100" alt="image" src="https://github.com/user-attachments/assets/abbce914-e407-42c1-a911-fda020cfbf15" />

**Insight:**

> The data shows an overall decline in sales volume as discount levels increase, with the highest sales volume occurring at 0% discount and the lowest at 25%. There are small fluctuations between 5% and 10%, but the overall pattern suggests a negative association between discount level and sales volume. This indicates an association, but does not by itself prove that discounts caused the change in sales.

---

### 15. How much potential revenue is associated with cancelled and returned orders?

Cancelled and returned orders did not generate actual revenue. However, calculating their transaction value allows us to estimate the revenue that could potentially have been generated if these orders had been successfully completed and retained.

```sql
SELECT
    SUM(
        Quantity * Unit_Price_USD
        * (1 - Discount_Percent / 100)
    ) AS potential_revenue
FROM ecommerce_retail_transactions_raw
WHERE Order_Status IN ('Cancelled', 'Returned');
```

**Answer:**
<img width="101" height="35" alt="image" src="https://github.com/user-attachments/assets/dae719b7-0fe9-462c-951a-2132a6925be7" />

> Cancelled and returned orders represented approximately **$252733.45** in potential revenue.

**Insight:**

> This provides an estimate of the transaction value associated with unsuccessful orders and can help identify the potential financial impact of cancellations and returns.

```


