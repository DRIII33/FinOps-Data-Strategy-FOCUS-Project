-- FILE: 03_Dashboard_Queries_SQL.sql
-- PROJECT ID: driiiportfolio
-- DESCRIPTION: Core SQL queries for the FinOps Executive Dashboard (Looker Studio)
--              using the FINOPS_FOCUS_ANALYTICS view.

-- 1. EXECUTIVE DASHBOARD - TOTAL SPEND & MONTH-OVER-MONTH TREND
-- Metric: Total Amortized Cost, MoM Change (%)
SELECT
    t1.billing_period,
    SUM(t1.focus_amortized_cost_usd) AS monthly_spend_usd,
    -- MoM Change calculation for trend visualization
    (SUM(t1.focus_amortized_cost_usd) - LAG(SUM(t1.focus_amortized_cost_usd), 1) OVER (ORDER BY t1.billing_period)) / LAG(SUM(t1.focus_amortized_cost_usd), 1) OVER (ORDER BY t1.billing_period) * 100 AS mom_change_percent
FROM
    driiiportfolio.finops_data.FINOPS_FOCUS_ANALYTICS t1
GROUP BY
    1
ORDER BY
    t1.billing_period;


-- 2. EXECUTIVE DASHBOARD - COST ALLOCATION & DATA QUALITY REPORT
-- Metric: Allocation Rate (The Data Strategist's KPI to achieve 95%)
SELECT
    t1.billing_period,
    SUM(t1.focus_amortized_cost_usd) AS total_spend_usd,
    SUM(CASE WHEN t1.is_unallocated IS FALSE THEN t1.focus_amortized_cost_usd ELSE 0 END) AS allocated_spend_usd,
    SUM(CASE WHEN t1.is_unallocated IS TRUE THEN t1.focus_amortized_cost_usd ELSE 0 END) AS unallocated_spend_usd,
    -- Allocation Rate using the is_unallocated flag
    SAFE_DIVIDE(SUM(CASE WHEN t1.is_unallocated IS FALSE THEN t1.focus_amortized_cost_usd ELSE 0 END), SUM(t1.focus_amortized_cost_usd)) * 100 AS allocation_rate_percent
FROM
    driiiportfolio.finops_data.FINOPS_FOCUS_ANALYTICS t1
GROUP BY
    1
ORDER BY
    t1.billing_period;


-- 3. EXECUTIVE DASHBOARD - TOP-LEVEL SPEND BY ALLOCATION DIMENSION (Product & Cloud)
-- Metric: Spend by Product Name & Cloud Provider
SELECT
    t1.allocated_product,
    t1.cloud_provider,
    SUM(t1.focus_amortized_cost_usd) AS total_spend_usd
FROM
    driiiportfolio.finops_data.FINOPS_FOCUS_ANALYTICS t1
-- Filter out the UNKNOWN/UNALLOCATED product cost to focus on accountable spend
WHERE
    t1.is_unallocated IS FALSE
GROUP BY
    1, 2
ORDER BY
    3 DESC;


-- 4. EXECUTIVE DASHBOARD - UNIT ECONOMICS (COST PER DAU)
-- Metric: The strategic business value metric (Cost per Daily Active User)
SELECT
    DATE_TRUNC(t1.billing_date, MONTH) AS billing_month,
    SUM(t1.focus_amortized_cost_usd) AS monthly_product_cost,
    SUM(t1.daily_active_users) AS total_monthly_dau,
    -- Unit Cost Calculation (Core business insight for C-suite)
    SAFE_DIVIDE(SUM(t1.focus_amortized_cost_usd), SUM(t1.daily_active_users)) AS cost_per_dau_usd
FROM
    driiiportfolio.finops_data.FINOPS_FOCUS_ANALYTICS t1
WHERE
    t1.allocated_product = 'Aether' -- Focus on the flagship product as requested
    AND t1.daily_active_users IS NOT NULL
GROUP BY
    1
ORDER BY
    1;
