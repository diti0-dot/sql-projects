# 📊 Diti's Portfolio

Welcome to my data portfolio! This repository contains projects where I use **SQL, Python, and Power BI** to clean, analyze, and communicate insights from real-world datasets.

## Table of Contents

* [SQL](#sql)
* [Python](#python)
* [Power BI](#power-bi)

---

# SQL

Projects focused on **data cleaning, exploratory analysis, and answering business questions using SQL**.

| **Project**                                                                                                                                                      | **Area of Analysis**              | **Tools** | **Project Description**                                                                                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [E-Commerce Sales Analytics Mini Case Study](https://github.com/diti0-dot/sql-projects/tree/main/e_commerce_sales#e-commerce-sales-analytics-mini-case-study) | Data Cleaning & Business Analysis | MySQL     | Cleaned and explored messy e-commerce transaction data to understand customer behavior, product performance, revenue, discounts, and order outcomes. Used SQL to transform the raw dataset and answer business questions through exploratory analysis. |

---

# Python

Projects focused on **data wrangling, statistical analysis, machine learning, and extracting patterns from data**.

| **Project** | **Area** | **Project Description** | **Libraries** |
| --- | --- | --- | --- |
| [UAV Flight Anomaly Detection Using PCA](https://github.com/diti0-dot/Flight-Anomaly-Detection/tree/main#uav-flight-anomaly-detection-using-pca) | Anomaly Detection & Data Analysis | Analyzed real fixed-wing UAV flight sensor data to detect in-flight failures without labeled failure data. Cleaned and time-aligned independently logged telemetry streams, modeled normal flight behavior using PCA, and used reconstruction error as an anomaly score. The detected failure point was validated against the dataset's official ground-truth timestamp: detection came 12.5 s after the engine failure, and the model correctly ignored an earlier, visually dramatic altitude drop. | pandas, NumPy, scikit-learn, Matplotlib |
| [Predicting Electric Vehicle Purchase Intent with LogisticRegression](https://github.com/diti0-dot/python_projects/tree/main/ev_purchase#predicting-electric-vehicle-purchase-intent) | Predictive Analytics & Business Intelligence | Investigated the factors behind EV purchase intent (income, commute distance, range anxiety, environmental concern, charging access, subsidies) for a Kaggle Playground Series competition. Started with exploratory analysis in SQL and an interactive Power BI dashboard, then built a Python ML pipeline (one-hot encoding, standard scaling, feature engineering) feeding a logistic regression classifier (ROC AUC ≈ 0.938) on a class-imbalanced dataset (17.5% buyers). | pandas, scikit-learn, Matplotlib, SQL, Power BI |

---

# Power BI

Projects focused on **business analysis, data visualization, and turning analytical findings into interactive dashboards**.

| **Project**                                                                                                                           | **Area of Analysis**       | **Tools**       | **Project Description**                                                                                                                                                                                                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [What Drives EV Purchase Intent?](https://github.com/diti0-dot/sql-projects/tree/main/ev_purchases#what-drives-ev-purchase-intent) | Customer & Market Analysis | MySQL, Power BI | Analyzed 668,665 customers to understand what separates potential EV buyers from customers who do not intend to purchase an EV. Explored purchase intent across city type, commute distance, range anxiety, subsidy availability, and home charging access, then built an interactive Power BI dashboard to communicate the findings. |

---
