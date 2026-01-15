### **Project: FOCUS-Aligned Multi-Cloud Data Strategy for Cloudability: Driving Unit Economics & Forecast Accuracy**

*This portfolio project is designed to showcase the full range of skills required for a **Senior Data Strategist at IBM Cloudability**, specifically focusing on data architecture, normalization (via a **FOCUS-like schema**), and the creation of high-impact financial metrics like **Unit Economics** for the FinOps Executive Dashboard.*

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

_________________________________________________________________________
## FinOps Data Strategy FOCUS Project: Multi-Cloud Cost Allocation

**Repository Name:** `FinOps-Data-Strategy-FOCUS-Project`

**Author:** Daniel Rodriguez III - Senior Data Strategist

---

## Project Overview

This repository houses the end-to-end data strategy and architecture implemented to address critical cost visibility and accountability challenges for IBM Cloudability clients leveraging multi-cloud environments (AWS and GCP).

The project's primary goal, designed by the Senior Data Strategist, was to establish a **FOCUS-Aligned** (FinOps Open Cost and Usage Specification) analytic layer to enable **Unit Economics** reporting and measure **Cost Allocation Accuracy**.

### Key Strategic Goals

1.  **Normalization:** Fix the messy raw tagging data (which was approx 38% incomplete) at the analytic layer using `COALESCE` logic, mapping missing tags to `'UNKNOWN'`. This ensures all costs are reported, preventing zero-dollar line items in the reporting.
2.  **Allocation Measurement:** Implement a metric to measure the current **Cost Allocation Rate** (initially approx 62%) to track progress toward the target of 95% accuracy.
3.  **Unit Economics:** Integrate cloud cost data with business metrics (Daily Active Users - DAU) to calculate the strategic C-suite metric: **Cost per DAU**.

---

## Repository Structure

The project deliverables are organized into the following clear directories:

| Folder | Description | Key Files |
| :--- | :--- | :--- |
| **`/docs`** | All non-code instructional guides and final executive analyses. | `Cloud_Setup_Guide.md`, `Executive_Summary_Analysis.md` |
| **`/data`** | Synthetic data generated to simulate the real-world multi-cloud complexity. | `raw_multi_cloud_billing_data.csv`, `business_dau_metrics.csv` |
| **`/notebooks`** | Python scripts used for initial data generation and simulation. | `01_Synthetic_Data_Generator.py` |
| **`/sql`** | BigQuery SQL scripts for data modeling and final reporting. | `02_BigQuery_Schema_SQL.sql`, `03_Dashboard_Queries_SQL.sql` |
| **`/looker_studio`** | Conceptual dashboard artifact. | `04_FinOps_Executive_Dashboard.pdf` |
| **Root** | Core documentation for the data structure. | `data_dictionary.csv` |

---


---

**Portfolio Project Disclaimer**

**Disclaimer FinOps Data Strategy Portfolio Project** 

This portfolio project, titled **FOCUS-Aligned Multi-Cloud Data Strategy**, is a conceptual exercise designed to demonstrate proficiency in the core competencies required of a **Senior Data Strategist** at a firm like IBM Consulting, particularly within the FinOps domain.

All data used in this project, including the raw billing records *(raw_multi_cloud_billing_data.csv)* and business metrics *(business_dau_metrics.csv)*, is **entirely synthetic, anonymized, and fictional**. The **challenges**—specifically the 62% allocation rate and the $506K unallocated cost liability—were derived from common, publicly discussed pain points and industry reports related to multi-cloud cost management and tagging governance (Frameworks like **FOCUS** are publicly available)

The use of company names such as **IBM Cloudability, AWS**, and **GCP** is purely for **contextual realism and architectural simulation** and does not imply any actual or historical relationship, data, or endorsement. This project does not intend to misrepresent the financial or operational status of any company mentioned. Its sole purpose is to showcase the application of data strategy, BigQuery, and FinOps principles to solve real-world business problems.
