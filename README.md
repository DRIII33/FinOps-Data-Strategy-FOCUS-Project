This portfolio project is designed to showcase the full range of skills required for a **Senior Data Strategist at IBM Cloudability**, specifically focusing on data architecture, normalization (via a **FOCUS-like schema**), and the creation of high-impact financial metrics like **Unit Economics** for the FinOps Executive Dashboard.

**Project: FOCUS-Aligned Multi-Cloud Data Strategy for Cloudability: Driving Unit Economics & Forecast Accuracy**

**1. Research-Driven Business Scenario & Problem**
The project is grounded in current (as of December 2025) challenges in the FinOps industry, as highlighted by FinOps Foundation reports and industry trends.

**Synthesized Challenges & Role Alignment:**
| **Industry Challenge (Dec 2025)**                       | **Senior Data Strategist Mandate**                                                                                   | **Dashboard Element Affected**        |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| Multi-Cloud Complexity & FOCUS Adoption                  | Define the architecture to ingest, normalize, and model billing data from AWS, Azure, GCP into a unified (FOCUS-like) schema. | Allocation, Spend Trend                |
| Low Data Quality (Inconsistent Tags)                     | Implement data quality checks (DQ) and define logic to handle "unallocated" resources, increasing allocation accuracy.        | Cost Allocation Rate                   |
| Quantifying Business Value (Unit Economics)              | Partner with Product/Data Science to integrate business data (DAU) with cost data to calculate Cost per X.                    | Unit Economics                         |
| Forecast/Budgetary Uncertainty                           | Provide high-quality, normalized data to reduce forecast variance and eliminate "invoice shock."                             | Forecast vs. Actual Spend              |

**Business Scenario: Stratosphere Tech**

IBM Cloudability has a major client, **'Stratosphere Tech'**, a rapidly growing multi-cloud (AWS and GCP) SaaS provider whose executive leadership is demanding greater **financial accountability and predictability**.
* **Current State Challenge:** The current cost allocation rate is dangerously low (≈62%) due to inconsistent tagging, leading to high forecast variance (over 15% MoM) and a lack of trust in the numbers.
* **Business Problem Statement:** Stratosphere Tech lacks **trustworthy, unified, and business-aligned multi-cloud cost data**, preventing the calculation of the **Cost per Daily Active User (DAU)** for their flagship product, 'Aether', which is critical for strategic pricing and capacity decisions.
* **Strategic Goal:** The Data Strategist will define the data foundation to achieve 95% **cost allocation accuracy** and produce the reliable **Unit Economics** metric required for executive decision-making.
* 
_________________________________________________________________________
## FinOps Data Strategy FOCUS Project: Multi-Cloud Cost Allocation

**Repository Name:** `FinOps-Data-Strategy-FOCUS-Project`

---

## Project Overview

This repository houses the end-to-end data strategy and architecture implemented to address critical cost visibility and accountability challenges for IBM Cloudability clients leveraging multi-cloud environments (AWS and GCP).

The project's primary goal, designed by the Senior Data Strategist, was to establish a **FOCUS-Aligned** (FinOps Open Cost and Usage Specification) analytic layer to enable **Unit Economics** reporting and measure **Cost Allocation Accuracy**.

### Key Strategic Goals

1.  **Normalization:** Fix the messy raw tagging data (which was $\approx 38\%$ incomplete) at the analytic layer using `COALESCE` logic, mapping missing tags to `'UNKNOWN'`. This ensures all costs are reported, preventing zero-dollar line items in the reporting.
2.  **Allocation Measurement:** Implement a metric to measure the current **Cost Allocation Rate** (initially $\approx 62\%$) to track progress toward the target of $95\%$ accuracy.
3.  **Unit Economics:** Integrate cloud cost data with business metrics (Daily Active Users - DAU) to calculate the strategic C-suite metric: **Cost per DAU**.

---

## Repository Structure

The project deliverables are organized into the following clear directories:

| Folder | Description | Key Files |
| :--- | :--- | :--- |
| **`/docs`** | All non-code instructional guides and final executive analyses. | `Cloud_Setup_Guide.docx`, `Executive_Summary_Analysis.docx` |
| **`/data`** | Synthetic data generated to simulate the real-world multi-cloud complexity. | `raw_multi_cloud_billing_data.csv`, `business_dau_metrics.csv` |
| **`/notebooks`** | Python scripts used for initial data generation and simulation. | `01_Synthetic_Data_Generator.ipynb` |
| **`/sql`** | BigQuery SQL scripts for data modeling and final reporting. | `02_BigQuery_Schema_SQL.sql`, `03_Dashboard_Queries_SQL.sql` |
| **`/looker_studio`** | Conceptual dashboard artifact. | `04_FinOps_Executive_Dashboard.looker` |
| **Root** | Core documentation for the data structure. | `data_dictionary.csv` |

---

## Execution Guide: Phase-by-Phase

This project follows a strict three-phase rollout process.

### Phase 1: Data Generation & Ingestion

1.  **Generate Data:** Execute the Python script located in **`/notebooks/01_Synthetic_Data_Generator.ipynb`** to create the two raw CSV files in the `/data` directory.
    * *Result:* Confirms the initial low allocation rate and the existence of the core data quality problem (missing tags).
2.  **Upload Data:** Follow the detailed steps in **`/docs/Cloud_Setup_Guide.docx`** to upload these CSVs to the designated BigQuery tables (`raw_cloud_billing`, `business_dau_metrics`).

### Phase 2: Data Modeling and Transformation

1.  **Execute Schema:** Run the full script located in **`/sql/02_BigQuery_Schema_SQL.sql`** in BigQuery.
    * *Result:* This creates the single, normalized, and consolidated analytic view: **`FINOPS_FOCUS_ANALYTICS`**. This view is the permanent, cleaned source of truth for all subsequent reporting.

### Phase 3: Reporting and Insight

1.  **Run Reporting Queries:** Execute the four queries within **`/sql/03_Dashboard_Queries_SQL.sql`**. These queries run against the **`FINOPS_FOCUS_ANALYTICS`** view to produce the final aggregated metrics (e.g., Cost per DAU, Allocation Rate KPI).
2.  **Connect Dashboard:** Use the queries from Step 1 as **Custom Queries** within Looker Studio to create the visualizations for the FinOps Executive Dashboard.
3.  **Analyze & Communicate:** Reference the **`/docs/Executive_Summary_Analysis.docx`** for the narrative and interpretation of the key findings (Cost/DAU stability, persistent allocation problem).

---

## Key Data Strategy Component: The Analytic View

The core intellectual property of this project is the **`FINOPS_FOCUS_ANALYTICS`** view. It addresses the $38\%$ unallocated cost problem by implementing the following BigQuery logic (simplified):

SELECT 
  COALESCE(tag_product, 'UNKNOWN') AS allocated_product,
  ...
FROM raw_cloud_billing
LEFT JOIN business_dau_metrics


This SQL transformation ensures that while the **raw data is messy**, the **reporting layer is clean and complete**, guaranteeing $100\%$ of costs can be attributed to a dimension (`Aether`, `Nexus`, or the designated problem category: `UNKNOWN`).

---

Would you like me to generate the detailed **`03_Dashboard_Queries_SQL.sql`** script content itself, or perhaps the **`data_dictionary.csv`** content for completeness?
