SELECT COUNT(*) FROM train;

SELECT * FROM train;


-- What does the gender distribution of the customer base look like?
SELECT gender, COUNT(*) AS customers
FROM train
GROUP BY gender
ORDER BY customers;


-- How are customers distributed across urban, suburban, and rural areas?
SELECT City_Type, COUNT(*) AS customers
FROM train
GROUP BY City_Type
ORDER BY customers;


-- What is the income profile of the customers?
SELECT
    MIN(Annual_Income_USD) AS min_income,
    AVG(Annual_Income_USD) AS avg_income,
    MAX(Annual_Income_USD) AS max_income
FROM train;


-- What proportion of customers are willing to buy an EV?
SELECT
    Will_Buy_EV,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM train
GROUP BY Will_Buy_EV;


-- Is EV purchase intent different between urban, suburban, and rural customers?
SELECT
    City_Type,
    COUNT(*) AS customers,
    SUM(
        CASE
            WHEN Will_Buy_EV = 'Yes' THEN 1
            ELSE 0
        END
    ) AS potential_buyers,
    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct
FROM train
GROUP BY City_Type
ORDER BY purchase_intent_pct DESC;


-- Are customers with access to home charging more likely to consider buying an EV?
SELECT
    Home_Charging_Possible,
    COUNT(*) AS customers,
    SUM(
        CASE
            WHEN Will_Buy_EV = 'Yes' THEN 1
            ELSE 0
        END
    ) AS potential_buyers,
    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct
FROM train
GROUP BY Home_Charging_Possible
ORDER BY purchase_intent_pct DESC;


-- Is EV purchase intent associated with different levels of range anxiety?
SELECT
    Range_Anxiety_Level,
    COUNT(*) AS customers,
    SUM(
        CASE
            WHEN Will_Buy_EV = 'Yes' THEN 1
            ELSE 0
        END
    ) AS potential_buyers,
    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct
FROM train
GROUP BY Range_Anxiety_Level
ORDER BY purchase_intent_pct DESC;


-- Is EV purchase intent higher among customers who have access to subsidies?
SELECT
    Subsidy_Available,
    COUNT(*) AS customers,
    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct
FROM train
GROUP BY Subsidy_Available
ORDER BY purchase_intent_pct DESC;


-- How does EV purchase intent vary across different daily commuting distances?
SELECT
    CASE
        WHEN Daily_Commute_km <= 20 THEN '0-20 kms'
        WHEN Daily_Commute_km <= 40 THEN '20-40 kms'
        WHEN Daily_Commute_km <= 60 THEN '40-60 kms'
        WHEN Daily_Commute_km <= 80 THEN '60-80 kms'
        WHEN Daily_Commute_km <= 100 THEN '80-100 kms'
        ELSE '100+ kms'
    END AS commute_groups,

    COUNT(*) AS customers,

    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct

FROM train

GROUP BY
    CASE
        WHEN Daily_Commute_km <= 20 THEN '0-20 kms'
        WHEN Daily_Commute_km <= 40 THEN '20-40 kms'
        WHEN Daily_Commute_km <= 60 THEN '40-60 kms'
        WHEN Daily_Commute_km <= 80 THEN '60-80 kms'
        WHEN Daily_Commute_km <= 100 THEN '80-100 kms'
        ELSE '100+ kms'
    END

ORDER BY purchase_intent_pct DESC;


-- Which types of current car owners show the highest EV purchase intent?
SELECT
    Current_Car_Type,
    COUNT(*) AS customers,
    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct
FROM train
GROUP BY Current_Car_Type
ORDER BY purchase_intent_pct DESC;


-- Is higher environmental concern associated with stronger EV purchase intent?
SELECT
    Environmental_Concern_Level,
    COUNT(*) AS customers,
    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct
FROM train
GROUP BY Environmental_Concern_Level
ORDER BY purchase_intent_pct DESC;


-- Does EV purchase intent vary across income groups?
SELECT
    CASE
        WHEN Annual_Income_USD < 50000 THEN '< $50K'
        WHEN Annual_Income_USD < 100000 THEN '$50K–$100K'
        WHEN Annual_Income_USD < 150000 THEN '$100K–$150K'
        ELSE '$150K+'
    END AS income_group,

    COUNT(*) AS customers,

    ROUND(
        SUM(
            CASE
                WHEN Will_Buy_EV = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS purchase_intent_pct

FROM train

GROUP BY
    CASE
        WHEN Annual_Income_USD < 50000 THEN '< $50K'
        WHEN Annual_Income_USD < 100000 THEN '$50K–$100K'
        WHEN Annual_Income_USD < 150000 THEN '$100K–$150K'
        ELSE '$150K+'
    END

ORDER BY purchase_intent_pct DESC;