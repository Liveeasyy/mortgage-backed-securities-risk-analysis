# mortgage-backed-securities-risk-analysis
End-to-end Mortgage-Backed Securities (MBS) risk analysis using MySQL and Power BI, featuring synthetic data generation, securitization, tranche modeling, and interactive dashboards.
# Mortgage-Backed Securities (MBS) Risk Analysis Using MySQL & Power BI

## Project Overview

What happens after a bank issues thousands of loans?

This project simulates the lifecycle of mortgage-backed securities (MBS), from borrower origination to loan securitization. Using MySQL to generate and manage synthetic financial data and Power BI for visualization, the project explores how individual borrower risk is transformed into investment products through loan pooling and tranche creation.

Rather than analyzing a static dataset, this project builds the complete data pipeline, demonstrating database design, SQL data generation, financial modeling, and business intelligence reporting.

---

# Business Problem

Financial institutions issue thousands of loans every year. Instead of holding every loan on their balance sheet, they often bundle these loans into pools and create Mortgage-Backed Securities (MBS) that can be sold to investors.

This raises several important business questions:

* Which borrowers are most likely to default?
* How does payment behavior indicate future risk?
* Which loan pools contain the highest concentration of risky loans?
* Does securitization eliminate risk or simply redistribute it?
* Are higher-rated tranches always safer investments?

This project answers these questions through data modeling, SQL analysis, and interactive Power BI dashboards.

---

# Dataset

A synthetic dataset was designed and generated entirely in MySQL to simulate a realistic lending environment.

### Tables

* **borrowers** – Borrower demographics, employment status, income, and credit scores
* **loans** – Loan amount, interest rate, loan type, status, and origination date
* **payments** – Simulated payment history including paid, late, and missed payments
* **loan_pools** – Mortgage loan pools used for securitization
* **pool_loans** – Bridge table linking loans to pools
* **tranches** – Investment tranches with varying credit ratings and expected returns

### Scale

* 3,000 Borrowers
* 3,000 Loans
* Thousands of Payment Records
* Multiple Loan Pools
* Multiple Investment Tranches

---

# SQL Techniques Used

This project demonstrates practical SQL skills including:

## Database Design

* Relational schema design
* Primary and foreign keys
* One-to-many and many-to-many relationships

## Data Generation

* Synthetic borrower generation
* Randomized loan creation
* Payment simulation
* Loan pool allocation
* Tranche generation

## SQL Features

* JOINs
* Aggregate Functions
* CASE Statements
* Common Table Expressions (CTEs)
* Views
* Window Functions
* Conditional Logic
* Business Rule Simulation

## Analytical Views

* vw_loan_performance
* vw_payment_behavior
* vw_pool_risk_summary
* vw_tranche_analysis

---

# Power BI Dashboard

The report is organized into five storytelling pages.

## Page 1 — The Mortgage Machine

Introduces the lending portfolio through key performance indicators and loan distribution.

Key Metrics

* Total Borrowers
* Total Loans
* Portfolio Value
* Average Credit Score

---

## Page 2 — Who Fails?

Explores borrower characteristics associated with loan default.

Questions Answered

* Do lower credit scores default more?
* Does employment status affect loan performance?
* Are higher interest rates associated with increased defaults?

---

## Page 3 — Payment Cracks

Analyzes borrower payment behavior before default.

Questions Answered

* How many payments are made on time?
* Which loan types experience the highest late-payment rates?
* Can payment behavior provide early warning signals?

---

## Page 4 — The Toxic Pools

Examines how risky loans are distributed into mortgage pools.

Questions Answered

* Which pools contain the highest concentration of risky loans?
* Which pools experience the highest default rates?
* Does pool composition match its perceived level of risk?

---

## Page 5 — The Big Short

Investigates securitization and tranche construction.

Questions Answered

* How is risk redistributed across investment tranches?
* Are higher expected returns associated with greater risk?
* How do credit ratings relate to underlying loan quality?

---

# Key Insights

The analysis produced several important findings:

* Borrowers with lower credit scores exhibited significantly higher default rates.
* Loans carrying higher interest rates were more likely to default.
* Late payments frequently preceded loan default, making payment behavior an effective early warning indicator.
* Certain loan pools accumulated substantially higher default concentrations than others.
* Securitization redistributed risk across investment tranches rather than eliminating it.
* Higher expected returns generally corresponded with higher-risk tranches.

---

# Skills Demonstrated

## SQL

* Relational Database Design
* Data Modeling
* Data Generation
* Complex Query Writing
* Views
* Business Logic Implementation

## Power BI

* Data Modeling
* Relationships
* DAX Measures
* KPI Cards
* Interactive Dashboards
* Drill-through Analysis
* Data Storytelling

## Business Analysis

* Credit Risk Analysis
* Loan Performance Analysis
* Payment Behavior Analysis
* Portfolio Risk Assessment
* Mortgage-Backed Securities (MBS)
* Financial Data Visualization

---

# Tools Used

* MySQL 8.0
* MySQL Workbench
* Power BI Desktop
* DAX
* GitHub

---

# Future Improvements

Potential enhancements include:

* Loan amortization schedules
* Adjustable-rate mortgages
* Geographic borrower segmentation
* Economic stress testing scenarios
* Probability of Default (PD) models
* Loss Given Default (LGD)
* Expected Credit Loss (ECL) calculations
* Machine learning models for default prediction
* Interactive investor portfolio simulations

---

# Conclusion

This project demonstrates how SQL and Power BI can be combined to model, analyze, and communicate complex financial systems.

Rather than focusing solely on dashboard creation, the project emphasizes the complete analytical workflow—from database design and synthetic data generation to business analysis and executive storytelling.

It highlights a key principle of financial engineering:

**Risk can be transformed, redistributed, and repackaged—but it cannot be eliminated.**
