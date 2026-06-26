# Financial Risk Simulation Database — Clean Schema Rebuild

## Project Goal

-- Build a realistic financial-risk simulation database capable of supporting:

* borrower risk analysis
* loan performance analysis
-- * default prediction studies
* loan pool construction
* tranche simulation
* Power BI dashboards
-- * systemic risk analysis similar to the 2008 financial crisis

---

# DESIGN PRINCIPLES

## 1. Relationships Over Randomness

-- The database should model:

borrower quality
→ loan risk
→ payment behavior
→ pool quality
→ tranche exposure

-- NOT disconnected random fields.

---

## 2. Borrowers Are The Source Of Truth

-- The borrowers table stores:

* income
* credit score
-- * employment status
-- 
-- Other tables reference borrowers instead of duplicating those fields.

---

## 3. Controlled Realism

The system should:

* contain patterns
* still include randomness/noise
* avoid perfectly predictable behavior

Example:

-- * low credit scores default more often
-- * but some high-credit borrowers can still default

---

# DATABASE SCHEMA

---

# 1. BORROWERS TABLE

## Purpose

-- Represents people/customers applying for loans.

## Create Table

```sql
CREATE TABLE borrowers (
    borrower_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
credit_score INT,
    income DECIMAL(12,2),
    employment_status VARCHAR(50),

);
```

---

# 2. LOANS TABLE

## Purpose

Represents loans issued to borrowers.

## Key Idea

One borrower can have multiple loans.

## Create Table

```sql
CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,

    borrower_id INT,

    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    loan_date DATE,

    loan_type VARCHAR(20),
    status VARCHAR(20),

    FOREIGN KEY (borrower_id)
    REFERENCES borrowers(borrower_id)
);
```

---

# 3. PAYMENTS TABLE

## Purpose

Tracks repayments made on loans.

## Key Idea

One loan can have many payments.

## Create Table

```sql
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,

    loan_id INT,

    payment_date DATE,
    payment_amount DECIMAL(12,2),
    payment_status VARCHAR(20),

    FOREIGN KEY (loan_id)
    REFERENCES loans(loan_id)
);
```

---

# 4. LOAN_POOLS TABLE

## Purpose

Groups loans together into investment pools.

## Create Table

```sql
CREATE TABLE loan_pools (
    pool_id INT PRIMARY KEY AUTO_INCREMENT,

    pool_name VARCHAR(100),
    creation_date DATE
);
```

---

# 5. POOL_LOANS TABLE

## Purpose
-- Many-to-many bridge table.

-- A pool contains many loans.
-- A loan belongs to a pool.

## Create Table

```sql
CREATE TABLE pool_loans (
    pool_loan_id INT PRIMARY KEY AUTO_INCREMENT,

    pool_id INT,
    loan_id INT,

    FOREIGN KEY (pool_id)
    REFERENCES loan_pools(pool_id),

    FOREIGN KEY (loan_id)
    REFERENCES loans(loan_id)
);
```

---

# 6. TRANCHES TABLE

## Purpose

Represents investment slices of loan pools.

## Create Table

```sql
CREATE TABLE tranches (
    tranche_id INT PRIMARY KEY AUTO_INCREMENT,

    pool_id INT,

    tranche_name VARCHAR(50),
    rating VARCHAR(10),
    expected_return DECIMAL(5,2),
    risk_level VARCHAR(20),

    FOREIGN KEY (pool_id)
    REFERENCES loan_pools(pool_id)
);
```

---

# TABLE RELATIONSHIPS

## Relationship Flow

borrowers
→ loans
→ payments

loans
→ loan_pools
→ tranches

---

# WHY THIS STRUCTURE IS GOOD

## Supports:

### SQL Analysis

* joins
* aggregation
* subqueries
* window functions

### Power BI Dashboards

* borrower risk dashboards
-- * default trends
* pool performance
* tranche analysis

### Financial Simulation

* subprime concentration
-- * default clustering
* risk propagation
* toxic asset modeling

---

# POPULATION ORDER

## IMPORTANT

-- Populate tables in this order:

1. borrowers
2. loans
3. payments
4. loan_pools
5. pool_loans
6. tranches

Reason:
-- Foreign keys depend on parent tables existing first.

---

# BORROWERS POPULATION

-- Use your Mockaroo dataset.

-- Recommended size:

-- * 1000 borrowers

---

# LOANS POPULATION STRATEGY

Recommended size:

-- * 3000 loans

Important modeling logic:

| Borrower Quality | Loan Behavior              |
| ---------------- | -------------------------- |
| High income      | larger loans               |
| Low credit score | subprime loans             |
| Riskier borrower | higher interest rates      |
-- | Low scores       | higher default probability |

---

# LOAN TYPES

-- | Credit Score | Loan Type  |
| ------------ | ---------- |
| 700+         | prime      |
| 600–699      | near-prime |
| Below 600    | subprime   |

---

# DEFAULT LOGIC

-- Should NOT be purely random.

-- Defaults should be influenced by:

* credit score
-- * loan type
* interest rate

But randomness/noise should still exist.

---

# PAYMENT LOGIC

Example payment statuses:

* paid
* missed
* late

Riskier loans should have:

* more missed payments
* more late payments

---

# FUTURE ANALYSIS GOALS

## Example Questions

### Borrower Risk

-- * Which employment groups default most?
* Which credit-score ranges fail most often?

### Loan Analysis

* Are subprime loans producing more defaults?
* Are high-interest loans failing more often?

### Pool Analysis

* Which pools contain toxic loans?
* Which pools are safest?

### Tranche Analysis

* Are AAA-rated tranches secretly risky?
-- * Which tranches collapse first during stress?

---

# IMPORTANT LESSONS FROM THE FIRST ATTEMPT

## Mistakes To Avoid

### 1. Random Everything

Wrong:

-- * unrelated random fields

Correct:

* connected financial behavior

---

### 2. Duplicating Borrower Data

Wrong:

-- * storing credit score repeatedly in loans

Correct:

* loans reference borrowers

---

### 3. Ignoring Foreign Keys

Wrong:

-- * disconnected tables

Correct:

* enforce relationships intentionally

---

### 4. Overengineering Early

Wrong:

* chasing perfect realism too early

Correct:

* build iterative realism

---

# RECOMMENDED NEXT STEP

-- 1. Drop old experimental tables
-- 2. Recreate schema cleanly
-- 3. Import borrowers from Mockaroo
-- 4. Generate loans using SQL
-- 5. Generate payments
-- 6. Build pools
-- 7. Create tranches
-- 8. Analyze using SQL + Power BI






CREATE DATABASE BigShort;
USE BigShort;

CREATE TABLE borrowers (
    borrower_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
credit_score INT,
    income DECIMAL(12,2),
    employment_status VARCHAR(50)

);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,

    borrower_id INT,

    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    loan_date DATE,

    loan_type VARCHAR(20),	
    status VARCHAR(20),

    FOREIGN KEY (borrower_id)
    REFERENCES borrowers(borrower_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,

    loan_id INT,

    payment_date DATE,
    payment_amount DECIMAL(12,2),
    payment_status VARCHAR(20),

    FOREIGN KEY (loan_id)
    REFERENCES loans(loan_id)
);

CREATE TABLE loan_pools (
    pool_id INT PRIMARY KEY AUTO_INCREMENT,

    pool_name VARCHAR(100),
    creation_date DATE
);

CREATE TABLE pool_loans (
    pool_loan_id INT PRIMARY KEY AUTO_INCREMENT,

    pool_id INT,
    loan_id INT,

    FOREIGN KEY (pool_id)
    REFERENCES loan_pools(pool_id),

    FOREIGN KEY (loan_id)
    REFERENCES loans(loan_id)
);


CREATE TABLE tranches (
    tranche_id INT PRIMARY KEY AUTO_INCREMENT,

    pool_id INT,

    tranche_name VARCHAR(50),
    rating VARCHAR(10),
    expected_return DECIMAL(5,2),
    risk_level VARCHAR(20),

    FOREIGN KEY (pool_id)
    REFERENCES loan_pools(pool_id)
);


INSERT INTO loans (
    borrower_id,
    loan_amount,
    interest_rate,
    loan_date,
    loan_type,
    status
)

SELECT

    b.borrower_id,

    -- Loan amount depends on income
    CASE
        WHEN b.income >= 700000
            THEN ROUND(RAND() * 400000 + 200000, 2)

        WHEN b.income >= 400000
            THEN ROUND(RAND() * 250000 + 100000, 2)

        ELSE
            ROUND(RAND() * 100000 + 50000, 2)
    END AS loan_amount,

    -- Interest rate depends on credit score
    CASE
        WHEN b.credit_score >= 700
            THEN ROUND(RAND() * 3 + 3, 2)

        WHEN b.credit_score >= 600
            THEN ROUND(RAND() * 3 + 6, 2)

        ELSE
            ROUND(RAND() * 5 + 9, 2)
    END AS interest_rate,

    -- Random loan dates
    DATE_ADD(
        '2019-01-01',
        INTERVAL FLOOR(RAND() * 1825) DAY
    ) AS loan_date,

    -- Loan type
    CASE
        WHEN b.credit_score >= 700
            THEN 'prime'

        WHEN b.credit_score >= 600
            THEN 'near-prime'

        ELSE
            'subprime'
    END AS loan_type,

    -- Default behavior
    CASE

        -- Random life-event noise
        WHEN RAND() < 0.03
            THEN 'defaulted'

        -- Very risky borrowers
        WHEN b.credit_score < 550
             AND RAND() < 0.70
            THEN 'defaulted'

        -- Medium-risk borrowers
        WHEN b.credit_score < 700
             AND RAND() < 0.30
            THEN 'defaulted'

        -- Low-risk edge cases
        WHEN RAND() < 0.05
            THEN 'defaulted'

        ELSE 'active'

    END AS status

FROM borrowers b
CROSS JOIN borrowers b2

LIMIT 3000;



-- loan type in sensible proportion
SELECT 
    loan_type,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type;

-- status distribution
SELECT 
    status,
    COUNT(*) AS total_loans
FROM loans
GROUP BY status;

-- default rate by loan type
SELECT
    loan_type,
    status,
    COUNT(*) AS total
FROM loans
GROUP BY loan_type, status
ORDER BY loan_type;

-- loan amount sanity check
SELECT
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan,
    AVG(loan_amount) AS avg_loan
FROM loans;

-- populate payments with sql


CREATE TABLE numbers (
    n INT PRIMARY KEY
);

INSERT INTO numbers (n)
VALUES
(1),(2),(3),(4),(5),
(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),
(16),(17),(18),(19),(20),
(21),(22),(23),(24);

INSERT INTO payments (
    loan_id,
    payment_date,
    payment_amount,
    payment_status
)

SELECT

    l.loan_id,

    -- Monthly payment dates
    DATE_ADD(
        l.loan_date,
        INTERVAL n.n MONTH
    ) AS payment_date,

    -- Equal payment split
    ROUND(
        l.loan_amount / pp.total_payments,
        2
    ) AS payment_amount,

    -- Payment behavior
    CASE
        WHEN RAND() < 0.86 THEN 'paid'
        WHEN RAND() < 0.95 THEN 'late'
        ELSE 'missed'
    END AS payment_status

FROM loans l

-- Create payment plan FIRST
JOIN (
    SELECT
        loan_id,
        FLOOR(RAND() * 19) + 6 AS total_payments
    FROM loans
) pp
ON l.loan_id = pp.loan_id

-- Then use numbers table
JOIN numbers n
ON n.n <=
    CASE
        WHEN l.status = 'active'
            THEN pp.total_payments

        ELSE FLOOR(
            pp.total_payments *
            (RAND() * 0.4 + 0.2)
        )
    END;
    SELECT COUNT(*)
FROM payments;

INSERT INTO loan_pools (
    pool_name,
    creation_date
)
VALUES
('Prime Secure Pool', '2022-01-01'),
('Growth Pool', '2022-02-01'),
('Balanced Pool', '2022-03-01'),
('Risk Expansion Pool', '2022-04-01'),
('Subprime Opportunity Pool', '2022-05-01');

INSERT INTO pool_loans (
    pool_id,
    loan_id
)

SELECT

    CASE

        -- Prime loans
        WHEN l.loan_type = 'prime'
             AND RAND() < 0.60
            THEN 1

        -- Growth (prime + near-prime)
        WHEN l.loan_type IN ('prime','near-prime')
             AND RAND() < 0.70
            THEN 2

        -- Balanced mix
        WHEN RAND() < 0.50
            THEN 3

        -- Risk expansion
        WHEN l.loan_type IN ('near-prime','subprime')
             AND RAND() < 0.70
            THEN 4

        -- High-risk pool
        ELSE 5

    END AS pool_id,

    l.loan_id

FROM loans l;


SELECT
    lp.pool_name,
    COUNT(*) AS total_loans
FROM pool_loans pl
JOIN loan_pools lp
    ON pl.pool_id = lp.pool_id
GROUP BY lp.pool_name;

SELECT COUNT(*)
FROM pool_loans;


INSERT INTO tranches (
    pool_id,
    tranche_name,
    rating,
    expected_return,
    risk_level
)

-- Pool 1: Prime Secure Pool
SELECT
    1,
    'Senior',
    'AAA',
    ROUND(RAND() * 2 + 4, 2),
    'low'
UNION ALL
SELECT
    1,
    'Mezzanine',
    'BBB',
    ROUND(RAND() * 3 + 7, 2),
    'medium'
UNION ALL
SELECT
    1,
    'Equity',
    'BB',
    ROUND(RAND() * 6 + 12, 2),
    'high'

-- Pool 2: Growth Pool
UNION ALL
SELECT
    2,
    'Senior',
    'AAA',
    ROUND(RAND() * 2 + 5, 2),
    'low'
UNION ALL
SELECT
    2,
    'Mezzanine',
    'BBB',
    ROUND(RAND() * 3 + 7, 2),
    'medium'
UNION ALL
SELECT
    2,
    'Equity',
    'BB',
    ROUND(RAND() * 6 + 12, 2),
    'high'

-- Pool 3: Balanced Pool
UNION ALL
SELECT
    3,
    'Senior',
    'A',
    ROUND(RAND() * 3 + 6, 2),
    'medium'
UNION ALL
SELECT
    3,
    'Mezzanine',
    'BBB',
    ROUND(RAND() * 4 + 8, 2),
    'medium'
UNION ALL
SELECT
    3,
    'Equity',
    'BB',
    ROUND(RAND() * 6 + 13, 2),
    'high'

-- Pool 4: Risk Expansion Pool
UNION ALL
SELECT
    4,
    'Senior',
    'BBB',
    ROUND(RAND() * 5 + 8, 2),
    'medium'
UNION ALL
SELECT
    4,
    'Mezzanine',
    'BB',
    ROUND(RAND() * 5 + 10, 2),
    'high'
UNION ALL
SELECT
    4,
    'Equity',
    'B',
    ROUND(RAND() * 6 + 15, 2),
    'high'

-- Pool 5: Subprime Opportunity Pool
UNION ALL
SELECT
    5,
    'Senior',
    'BBB',
    ROUND(RAND() * 5 + 10, 2),
    'high'
UNION ALL
SELECT
    5,
    'Mezzanine',
    'B',
    ROUND(RAND() * 6 + 14, 2),
    'high'
UNION ALL
SELECT
    5,
    'Equity',
    'CCC',
    ROUND(RAND() * 8 + 18, 2),
    'very_high';
    
    
    SELECT *
FROM tranches
ORDER BY pool_id, tranche_name;
-- REALITY CHECK
-- We should expect:prime → mostly active subprime → higher defaults

SELECT
    loan_type,
    status,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type, status
ORDER BY loan_type, status;

-- Expected: paid ≈ dominant, late ≈ smaller, missed ≈ smallest
SELECT
    payment_status,
    COUNT(*) AS total
FROM payments
GROUP BY payment_status;

-- We should see: Prime Secure Pool → mostly prime Subprime Opportunity Pool → 
-- heavy subprime
-- Otherwise the assignment logic failed.
SELECT
    lp.pool_name,
    l.loan_type,
    COUNT(*) AS total
FROM pool_loans pl
JOIN loan_pools lp
    ON pl.pool_id = lp.pool_id
JOIN loans l
    ON pl.loan_id = l.loan_id
GROUP BY lp.pool_name, l.loan_type
ORDER BY lp.pool_name;

-- We want to see the story:safe pools → safer ratings
-- risky pools → downgraded tranches
SELECT
    lp.pool_name,
    t.tranche_name,
    t.rating,
    t.expected_return
FROM tranches t
JOIN loan_pools lp
    ON t.pool_id = lp.pool_id
ORDER BY t.pool_id;