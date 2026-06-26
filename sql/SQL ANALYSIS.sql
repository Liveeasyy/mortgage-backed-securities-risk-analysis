 -- QUESTIONS  
-- 1. Borrower Risk Analysis
-- 2. Loan Performance Analysis
-- 3. Payment Behavior Analysis
-- 4. Pool Risk Analysis
-- 5. Tranche & Big-Short Style Analysis
-- BORROWER RISK ANALYSIS
-- Q1. Which employment group defaults more?
-- Business question:
-- Are unemployed borrowers riskier?
SELECT
    b.employment_status,
    l.status,
    COUNT(*) AS total_loans
FROM borrowers b
JOIN loans l
    ON b.borrower_id = l.borrower_id
GROUP BY b.employment_status, l.status
ORDER BY b.employment_status;

-- Q2. Average credit score by loan status
-- Business question:
-- Are defaulted borrowers lower quality?

SELECT
    l.status,
    ROUND(AVG(b.credit_score),2) AS avg_credit_score
FROM borrowers b
JOIN loans l
    ON b.borrower_id = l.borrower_id
GROUP BY l.status;

-- Q3. Income vs loan amount
-- Business question:
-- Do richer borrowers receive larger loans?

SELECT
    b.borrower_id,
    b.income,
    ROUND(AVG(l.loan_amount),2) AS avg_loan_amount
FROM borrowers b
JOIN loans l
    ON b.borrower_id = l.borrower_id
GROUP BY b.borrower_id, b.income
ORDER BY b.income DESC;

-- LOAN PERFORMANCE ANALYSIS
-- Q4. Prime vs subprime performance
-- Business question:
-- Which loan class defaults most?
SELECT
    loan_type,
    status,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type, status
ORDER BY loan_type;

-- Q5. Interest rate vs default
-- Business question:
-- Are higher-rate loans riskier?
SELECT
    status,
    ROUND(AVG(interest_rate),2) AS avg_interest_rate
FROM loans
GROUP BY status;

-- Q6. Loan type profitability
-- Business question:
-- Which loans produce higher expected returns?
SELECT
    loan_type,
    ROUND(AVG(interest_rate),2) AS avg_interest_rate,
    ROUND(AVG(loan_amount),2) AS avg_loan_amount
FROM loans
GROUP BY loan_type;

-- 3. PAYMENT BEHAVIOR ANALYSIS
-- Q7. Payment status distribution
-- Business question:
-- Are borrowers mostly paying?
SELECT
    payment_status,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_status;

-- Q8. Payment behavior by loan type
-- Business question:
-- Do subprime borrowers miss more payments?
SELECT
    l.loan_type,
    p.payment_status,
    COUNT(*) AS total
FROM payments p
JOIN loans l
    ON p.loan_id = l.loan_id
GROUP BY l.loan_type, p.payment_status
ORDER BY l.loan_type;

-- Q9. Average payments before default
-- Business question:
-- How long do defaulted loans survive?
SELECT
    l.loan_type,
    COUNT(p.payment_id) AS payments_before_stop
FROM loans l
LEFT JOIN payments p
    ON l.loan_id = p.loan_id
WHERE l.status = 'defaulted'
GROUP BY l.loan_id, l.loan_type
ORDER BY payments_before_stop;

-- 4. POOL RISK ANALYSIS
-- Q10. Pool composition

-- Business question:

-- What is inside each pool?
SELECT
    lp.pool_name,
    l.loan_type,
    COUNT(*) AS total_loans
FROM pool_loans pl
JOIN loan_pools lp
    ON pl.pool_id = lp.pool_id
JOIN loans l
    ON pl.loan_id = l.loan_id
GROUP BY lp.pool_name, l.loan_type
ORDER BY lp.pool_name;

-- Q11. Toxic pool detection

-- Business question:

-- Which pool contains the most defaults?
SELECT
    lp.pool_name,
    l.status,
    COUNT(*) AS total_loans
FROM pool_loans pl
JOIN loan_pools lp
    ON pl.pool_id = lp.pool_id
JOIN loans l
    ON pl.loan_id = l.loan_id
GROUP BY lp.pool_name, l.status
ORDER BY lp.pool_name;


-- 5. TRANCHE / BIG SHORT ANALYSIS
-- Q12. Tranche risk profile
-- Business question:
-- Are higher returns hiding more risk?
SELECT
    lp.pool_name,
    t.tranche_name,
    t.rating,
    t.expected_return,
    t.risk_level
FROM tranches t
JOIN loan_pools lp
    ON t.pool_id = lp.pool_id
ORDER BY lp.pool_name;
-- Q13. “Safe-looking but risky?”
-- Business question:
-- Do supposedly safe tranches contain bad loans?
SELECT
    lp.pool_name,
    t.tranche_name,
    t.rating,
    l.loan_type,
    l.status,
    COUNT(*) AS total_loans
FROM tranches t
JOIN loan_pools lp
    ON t.pool_id = lp.pool_id
JOIN pool_loans pl
    ON lp.pool_id = pl.pool_id
JOIN loans l
    ON pl.loan_id = l.loan_id
GROUP BY
    lp.pool_name,
    t.tranche_name,
    t.rating,
    l.loan_type,
    l.status
ORDER BY lp.pool_name;
-- hh


SELECT
    l.loan_type,
    p.payment_status,
    COUNT(*) AS total_payments,

    ROUND(
        COUNT(*) * 100.0 /
        totals.total_count,
        2
    ) AS percentage

FROM payments p

JOIN loans l
    ON p.loan_id = l.loan_id

JOIN (
    SELECT
        l.loan_type,
        COUNT(*) AS total_count
    FROM payments p
    JOIN loans l
        ON p.loan_id = l.loan_id
    GROUP BY l.loan_type
) totals
    ON l.loan_type = totals.loan_type

GROUP BY
    l.loan_type,
    p.payment_status,
    totals.total_count

ORDER BY
    l.loan_type,
    percentage DESC;
    
 -- What this gives Power BI:
 -- loan risk
 -- borrower quality
 -- interest rate analysis
 -- default analysis
 -- employment vs default   
    CREATE VIEW vw_loan_performance AS -- Business purpose: loan-level performance & borrower risk

SELECT
    l.loan_id,
    l.loan_type,
    l.loan_amount,
    l.interest_rate,
    l.loan_date,
    l.status AS loan_status,

    b.borrower_id,
    b.name,
    b.credit_score,
    b.income,
    b.employment_status

FROM loans l
JOIN borrowers b
    ON l.borrower_id = b.borrower_id;
    
    SELECT *
FROM vw_loan_performance
LIMIT 10;

-- Power BI use cases:
-- payment trends over time
-- paid vs late vs missed
-- payment behavior by loan type
-- delinquency analysis

CREATE VIEW vw_pool_risk_summary AS -- Business purpose: securitized pool toxicity

SELECT
    lp.pool_id,
    lp.pool_name,

    l.loan_id,
    l.loan_type,
    l.status AS loan_status,
    l.loan_amount,
    l.interest_rate

FROM pool_loans pl

JOIN loan_pools lp
    ON pl.pool_id = lp.pool_id

JOIN loans l
    ON pl.loan_id = l.loan_id;
    
    -- Business purpose:
-- payment trends and delinquency analysis
CREATE VIEW vw_payment_behavior AS -- Business purpose: payment trends and delinquency analysis

SELECT
    p.payment_id,
    p.loan_id,
    p.payment_date,
    p.payment_amount,
    p.payment_status,

    l.loan_type,
    l.status AS loan_status,
    l.loan_amount,
    l.interest_rate

FROM payments p
JOIN loans l
    ON p.loan_id = l.loan_id;

SELECT *
FROM vw_payment_behavior
LIMIT 10;

-- Power BI visuals:
-- pool composition
-- pool toxicity
-- defaults by pool
-- prime vs subprime concentration
-- Business purpose:
-- securitized pool toxicity
CREATE VIEW vw_pool_risk_summary AS

SELECT
    lp.pool_id,
    lp.pool_name,

    l.loan_id,
    l.loan_type,
    l.status AS loan_status,
    l.loan_amount,
    l.interest_rate

FROM pool_loans pl

JOIN loan_pools lp
    ON pl.pool_id = lp.pool_id

JOIN loans l
    ON pl.loan_id = l.loan_id;
    
    SELECT *
FROM vw_pool_risk_summary
LIMIT 10;
-- Business purpose:
-- risk-return storytelling
CREATE VIEW vw_tranche_analysis AS

SELECT
    t.tranche_id,
    t.pool_id,
    lp.pool_name,

    t.tranche_name,
    t.rating,
    t.expected_return,
    t.risk_level,

    l.loan_type,
    l.status AS loan_status,
    l.loan_amount

FROM tranches t

JOIN loan_pools lp
    ON t.pool_id = lp.pool_id

JOIN pool_loans pl
    ON lp.pool_id = pl.pool_id

JOIN loans l
    ON pl.loan_id = l.loan_id;
    
    SELECT *
FROM vw_tranche_analysis
LIMIT 10;
-- Power BI visuals:
-- risk vs return
-- ratings vs default exposure
-- AAA with toxic loans
-- Big Short narrative