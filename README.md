# 📊 HR Analytics Data Warehouse (SQL Server)

## 📌 Project Overview
This project involves building a complete **Data Warehouse (DWH)** for an HR department to analyze employee attrition behavior. The goal is to transform raw data into a structured **Star Schema** to answer key business questions regarding employee retention, training impact, and company demographics.

## 🛠️ Tools & Technologies
- **Database:** Microsoft SQL Server (SSMS)
- **ETL:** T-SQL (Stored Procedures, Bulk Insert)
- **Data Modeling:** Star Schema (Fact & Dimensions)
- **Reporting:** SQL Views (Prepared for Power BI)

## 📂 Project Structure
The project follows a standard Data Warehousing lifecycle:

1.  **`1_Setup_and_Load.sql`**: Database creation, raw data ingestion, and data cleaning.
2.  **`2_Create_Dimensions.sql`**: Building dimension tables (`Candidate`, `Company`, `Location`, `Education`).
3.  **`3_Create_Fact_Table.sql`**: Constructing the Fact table and linking surrogate keys.
4.  **`4_Apply_Constraints.sql`**: Establishing Primary Keys (PK) and Foreign Keys (FK).
5.  **`5_Create_Analytical_Views.sql`**: Creating business views for analysis (KPIs, Churn Analysis).

## 🔑 Key Insights (Analysis)
The SQL Views answer the following questions:
- What is the overall attrition rate?
- Which company type has the highest employee turnover?
- Does more training hours lead to higher retention?
- Are senior employees more likely to leave than juniors?

## 📸 Data Model (Star Schema)
*(https://github.com/Mahmoud-Abd-Elhadi/HR-Employee-Attrition-Analysis/blob/main/Image/Database%20Diagram.png)*

---
*Created by [Mahmoud Abd Elhadi]*
