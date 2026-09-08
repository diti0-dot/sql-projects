# What Drives EV Purchase Intent?

<img width="764" height="438" alt="Screenshot 2026-09-08 130505" src="https://github.com/user-attachments/assets/2764b75c-f7eb-4fa5-b27d-1e5b88860490" />


## Overview

Electric vehicle adoption is growing, but not every customer is equally willing to make the switch.

For this project, I used the **Predicting Electric Vehicle Purchases** dataset from Kaggle to figure out what actually separates customers who intend to buy an EV from the ones who don't. I built an interactive **Power BI dashboard** to explore it.

> The question I set out to answer: what does the potential EV customer look like, and what's stopping the rest of the market from buying?

Quick note before the findings: the dashboard reflects the full dataset of 668,665 customers. A few of the deeper segment cuts below were run in SQL against the first 179K rows while the rest of the import was still loading. I'll flag it where sample size actually changes how much I'd trust a number.

---

## The Dashboard

<img width="487" height="101" alt="image" src="https://github.com/user-attachments/assets/3da18048-fbc7-4a3f-8c79-2694adc321ad" />


I opened the dashboard with four headline numbers. Out of **668,665 customers**, only **17.46%** said they'd buy an EV. The rest, **82.54%**, said no. Average income across the group is **$84.77K**, and average daily commute is **32.16 km**.

From there I broke purchase intent down five ways: city type, commute distance, range anxiety, subsidy availability, and home charging access. I wanted someone looking at this to go from "how big is the opportunity" to "which lever actually moves it" without leaving the page.

---

## Key Findings

## By City Type

<img width="303" height="235" alt="image" src="https://github.com/user-attachments/assets/43012124-21ad-4f70-beca-5a1651a17a7e" />

Urban customers show the highest EV interest (~50K "Yes" out of ~290K), followed by suburban (~40K "Yes" out of ~250K), and rural customers trail with the lowest volume and intent (~25K "Yes" out of ~130K).

Purchase intent scales with urbanization, likely reflecting better charging infrastructure and higher disposable income in cities.

## By Daily Commute Distance

<img width="538" height="252" alt="image" src="https://github.com/user-attachments/assets/dc118077-6022-40fe-b384-5529adad925a" />

Customers with the shortest commutes (0–10 km) form the largest segment (~148K total) and contribute the highest volume of "Yes" responses (~28K).

Both total customers and purchase intent decline sharply as commute distance increases, with almost no interest beyond 70 km/day.

This suggests EV adoption today is concentrated among low-mileage, likely urban commuters. Range limitations are still a real barrier for longer-distance drivers.

## By Range Anxiety

<img width="306" height="260" alt="image" src="https://github.com/user-attachments/assets/c6425640-a402-4f4d-aad8-3ed634a106e9" />

This is one of the strongest predictors of intent. Customers with **low** range anxiety show ~15–17% "Yes" responses, but this collapses to near **0%** for **medium** and **high** anxiety segments.

Range anxiety alone appears to suppress purchase intent almost entirely once it rises above "low."

## By Subsidy Availability

<img width="302" height="246" alt="image" src="https://github.com/user-attachments/assets/ab8c7f8c-7af3-4d49-9551-bfc7e020ce67" />

Customers with subsidy access show roughly **22% purchase intent**, compared to just **~2%** for those without subsidies.

That represents an approximately **10x difference** in purchase intent. This indicates subsidies are a strong, though not sole, lever for driving EV adoption.

## By Home Charging Availability

This is the single biggest differentiator.

<img width="304" height="240" alt="image" src="https://github.com/user-attachments/assets/bf4ddb3b-ec54-410e-8901-bcb826d7e6e4" />

~470K customers have home charging access compared with ~200K who do not, and purchase intent is concentrated almost entirely among the home-charging group.

This makes home charging access the strongest infrastructure-related driver of EV adoption in the dataset.

# Business Implications

* **Prioritize home charging infrastructure investment and partnerships.** It is the single largest lever for conversion. Customers without home charging represent a largely untapped and hard-to-convert segment without infrastructure support.

* **Target subsidy campaigns at fence-sitters.** The ~10x lift in intent with subsidies suggests marketing spend on subsidy awareness, not just subsidy availability, could meaningfully increase EV purchase intent.

* **Address range anxiety directly.** Since medium and high anxiety nearly eliminate purchase intent, investment in range-anxiety-reducing messaging such as charging network maps, range guarantees, and fast-charging partnerships could unlock a currently dormant segment.

* **Focus go-to-market on urban and suburban, short-commute customers first.** This is the highest-intent, lowest-friction segment. Rural and long-commute customers may need a longer-term infrastructure strategy before conversion is realistic.

* **Reallocate rural strategy toward infrastructure-first rather than marketing-first.** Low intent among rural customers may indicate an infrastructure barrier rather than simply a lack of demand.


---

## Tools

| Tool | Purpose |
|---|---|
| **Power BI** | Dashboard build and primary analysis |
| **MySQL** | Exploratory segmentation and business question drafting |
| **Kaggle** | Dataset |

---

## Workflow

```text
Kaggle Dataset
      ↓
SQL Exploration & Business Questions
      ↓
Power BI Dashboard (full dataset)
      ↓
Segment Analysis
      ↓
Business Recommendations
```
