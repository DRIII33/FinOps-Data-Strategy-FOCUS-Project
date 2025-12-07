-- FILE: 02_BigQuery_Schema_SQL.sql
-- PROJECT ID: driiiportfolio
-- DESCRIPTION: Creates the FinOps dataset, raw tables, and the core FOCUS-aligned
--              FINOPS_FOCUS_ANALYTICS view, which normalizes multi-cloud tags
--              and handles unallocated cost (Data Quality solution).

-- 1. Create the FinOps Dataset
CREATE SCHEMA IF NOT EXISTS driiiportfolio.finops_data
OPTIONS(
  location='us'
);

-- 2. Create the Raw Billing Table (Target for raw_multi_cloud_billing_data.csv upload)
-- NOTE: The user must load the CSV into this table.
CREATE TABLE IF NOT EXISTS driiiportfolio.finops_data.raw_cloud_billing (
    line_item_id STRING,
    billing_period STRING,
    billing_date DATE,
    cloud_provider STRING,
    service_name STRING,
    tag_product STRING, -- Will contain NULLs for unallocated cost
    tag_environment STRING,
    tag_team STRING,    -- Will contain NULLs for unallocated cost
    usage_amount NUMERIC,
    usage_unit STRING,
    cost_in_usd NUMERIC,
    amortized_cost_in_usd NUMERIC,
    is_commitment BOOL,
    is_unallocated BOOL,
    region STRING
);

-- 3. Create the Business DAU Metrics Table (Target for business_dau_metrics.csv upload)
-- NOTE: The user must load the CSV into this table.
CREATE TABLE IF NOT EXISTS driiiportfolio.finops_data.business_dau_metrics (
    business_date DATE,
    product_name STRING,
    daily_active_users INT64
);


-- 4. Create the Core FOCUS-Aligned FINOPS_FOCUS_ANALYTICS VIEW
-- This VIEW is the critical technical deliverable: Data Normalization and Quality Fix.
CREATE OR REPLACE VIEW driiiportfolio.finops_data.FINOPS_FOCUS_ANALYTICS AS
SELECT
    t1.line_item_id,
    t1.billing_date,
    t1.billing_period,
    -- Normalization: Standardizing provider and service fields
    t1.cloud_provider,
    t1.service_name,

    -- Data Quality Fix & Allocation Logic (Mapping raw tags to FOCUS-like dimensions)
    -- COALESCE replaces NULL (the unallocated tag) with 'UNKNOWN' for consistent reporting.
    COALESCE(t1.tag_product, 'UNKNOWN') AS allocated_product,
    COALESCE(t1.tag_environment, 'UNKNOWN') AS allocated_environment,
    COALESCE(t1.tag_team, 'UNKNOWN') AS allocated_team_owner,
    t1.region,

    -- Cost Metric
    t1.amortized_cost_in_usd AS focus_amortized_cost_usd,
    t1.is_commitment,

    -- Data Quality Metric
    t1.is_unallocated,

    -- Join with Business Metrics for Unit Economics
    t2.daily_active_users
FROM
    driiiportfolio.finops_data.raw_cloud_billing t1
LEFT JOIN
    driiiportfolio.finops_data.business_dau_metrics t2
    ON t1.billing_date = t2.business_date
    AND t1.tag_product = t2.product_name -- Join cost data only for the relevant product
WHERE
    t1.amortized_cost_in_usd > 0
;
