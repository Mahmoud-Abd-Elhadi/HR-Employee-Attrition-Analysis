/*
===============================================================================
File Name:      5_Create_Analytical_Views.sql
Description:    Create Views for Reporting & Analytics.
                These views act as a semantic layer for BI tools (Power BI/Excel),
                simplifying complex logic and aggregations.
===============================================================================
*/

USE HR_Analytics_DW
GO

-- =============================================
-- View 1: Overview KPIs (Key Performance Indicators)
-- =============================================

SELECT * FROM [GOLD].[Fact_HR]

IF OBJECT_ID ('GOLD.vw_Key_Metrics') IS NOT NULL
    DROP VIEW GOLD.vw_Key_Metrics
GO

CREATE VIEW GOLD.vw_Key_Metrics 
AS
    SELECT
        COUNT(Candidate_ID) AS Total_Candidates ,
        SUM([target]) AS Candidates_Looking_For_Job ,
        ROUND(CAST(SUM([target]) AS FLOAT) * 100 /
              COUNT(Candidate_ID) , 2) AS Attrition_Rate_Pct
    FROM [GOLD].[Fact_HR]

SELECT * FROM GOLD.vw_Key_Metrics

-- =============================================
-- View 2: Analysis by Company (Company Performance)
-- =============================================
SELECT * FROM [GOLD].[Dim_Company]

IF OBJECT_ID('GOLD.vw_Company_Analysis') IS NOT NULL
    DROP VIEW GOLD.vw_Company_Analysis;
GO

CREATE VIEW GOLD.vw_Company_Analysis
AS
    SELECT
        company_size ,
        company_type ,
        COUNT(FHR.Candidate_ID) AS Total_Candidates ,
        SUM(FHR.[target])       AS Candidates_Looking_For_Job ,
        ROUND(CAST(SUM([target]) AS FLOAT) * 100 /
              COUNT(Candidate_ID) , 2) AS Attrition_Rate_Pct
    FROM [GOLD].[Dim_Company] AS GDC
    JOIN [GOLD].[Fact_HR]     AS FHR
        ON GDC.Company_ID = FHR.Company_ID
    GROUP BY company_size ,
             company_type

SELECT * FROM GOLD.vw_Company_Analysis
ORDER BY Attrition_Rate_Pct DESC
-- =============================================
-- View 3: Analysis by Education (Talent Quality)
-- =============================================

IF OBJECT_ID('GOLD.vw_Education_Analysis') IS NOT NULL 
    DROP VIEW GOLD.vw_Education_Analysis;
GO

CREATE VIEW GOLD.vw_Education_Analysis 
AS
    SELECT 
        E.education_level,
        E.major_discipline,
        COUNT(F.Candidate_ID) AS Total_Candidates,
        SUM(F.Target) AS Attrition_Count,
        CAST(SUM(F.Target) * 100.0 / 
             COUNT(F.Candidate_ID) AS DECIMAL(5,2)) AS Attrition_Rate
    FROM GOLD.Fact_HR F
    JOIN GOLD.Dim_Education E ON F.Education_ID = E.Education_ID
    GROUP BY E.education_level, E.major_discipline;
GO

SELECT * FROM GOLD.vw_Education_Analysis
ORDER BY Attrition_Rate DESC

-- =============================================
-- View 4: Training Impact Analysis
-- =============================================

SELECT * FROM [GOLD].[Fact_HR]

IF OBJECT_ID('GOLD.vw_Training_Analysis') IS NOT NULL
    DROP VIEW GOLD.vw_Training_Analysis;
GO

CREATE VIEW GOLD.vw_Training_Analysis
AS
    SELECT
        CASE
            WHEN training_hour < 10 THEN '0-10 Hours'
            WHEN training_hour BETWEEN 10 AND 50 THEN '10-50'
            WHEN training_hour BETWEEN 51 AND 100 THEN '51-100'
            ELSE 'More Than 100 Hours'
        END AS Training_Range,
        COUNT(Candidate_ID) AS Total_Candidates ,
        SUM([target]) AS Candidates_Looking_For_Job ,
        ROUND(CAST(SUM([target]) AS FLOAT) * 100 /
              COUNT(Candidate_ID) , 2) AS Attrition_Rate
    FROM [GOLD].[Fact_HR]
    GROUP BY 
            CASE
                WHEN training_hour < 10 THEN '0-10 Hours'
                WHEN training_hour BETWEEN 10 AND 50 THEN '10-50'
                WHEN training_hour BETWEEN 51 AND 100 THEN '51-100'
                ELSE 'More Than 100 Hours'
            END

SELECT * FROM GOLD.vw_Training_Analysis
ORDER BY Attrition_Rate DESC

-- =============================================
-- 5. Experience Level Analysis (New!) 
-- =============================================
IF OBJECT_ID('GOLD.vw_Experience_Analysis') IS NOT NULL 
    DROP VIEW GOLD.vw_Experience_Analysis;
GO

CREATE VIEW GOLD.vw_Experience_Analysis 
AS
    SELECT
        CASE 
            WHEN GDC.experience BETWEEN 0 AND 2 THEN 'Junior (0-2 Years)'
            WHEN GDC.experience BETWEEN 3 AND 10 THEN 'Mid-Level (3-10 Years)'
            WHEN GDC.experience > 10 THEN 'Senior (+10 Years)'
            ELSE 'Unknown'
        END AS Experience_Category,
        COUNT(GDC.Candidate_ID) AS Total_Candidates ,
        SUM(FHR.[target]) AS Candidates_Looking_For_Job ,
        ROUND(CAST(SUM(FHR.[target]) AS FLOAT) * 100 /
              COUNT(GDC.Candidate_ID) , 2) AS Attrition_Rate
    FROM [GOLD].[Fact_HR] AS FHR
    JOIN [GOLD].[Dim_Candidate] AS GDC
        ON FHR.Candidate_ID = GDC.Candidate_ID
    GROUP BY 
            CASE 
                WHEN GDC.experience BETWEEN 0 AND 2 THEN 'Junior (0-2 Years)'
                WHEN GDC.experience BETWEEN 3 AND 10 THEN 'Mid-Level (3-10 Years)'
                WHEN GDC.experience > 10 THEN 'Senior (+10 Years)'
                ELSE 'Unknown'
            END

SELECT * FROM GOLD.vw_Experience_Analysis
ORDER BY Attrition_Rate DESC

-- =============================================
-- 6. City Development Analysis (New!) 
-- =============================================

IF OBJECT_ID('GOLD.vw_City_Analysis') IS NOT NULL 
    DROP VIEW GOLD.vw_City_Analysis;
GO

CREATE VIEW GOLD.vw_City_Analysis 
AS
    SELECT 
        CASE 
            WHEN GDL.city_development_index < 0.60 THEN 'Low Development'
            WHEN GDL.city_development_index BETWEEN 0.60 AND 0.85 THEN 'Medium Development'
            WHEN GDL.city_development_index > 0.85 THEN 'High Development'
        END AS Development_Category,
        COUNT(FHR.Candidate_ID) AS Total_Candidates ,
        SUM(FHR.[target]) AS Candidates_Looking_For_Job ,
        ROUND(CAST(SUM(FHR.[target]) AS FLOAT) * 100 /
              COUNT(FHR.Candidate_ID) , 2) AS Attrition_Rate
    FROM [GOLD].[Fact_HR]      AS FHR
    JOIN [GOLD].[Dim_Location] AS GDL
        ON FHR.City_ID = GDL.City_ID
    GROUP BY 
            CASE 
                WHEN GDL.city_development_index < 0.60 THEN 'Low Development'
                WHEN GDL.city_development_index BETWEEN 0.60 AND 0.85 THEN 'Medium Development'
                WHEN GDL.city_development_index > 0.85 THEN 'High Development'
            END

SELECT * FROM GOLD.vw_City_Analysis
ORDER BY Attrition_Rate DESC
    
-- =============================================
-- 7. Job Switching History Analysis (New!) 
-- =============================================

IF OBJECT_ID('GOLD.vw_Job_Switching_Analysis') IS NOT NULL 
    DROP VIEW GOLD.vw_Job_Switching_Analysis;
GO

CREATE VIEW GOLD.vw_Job_Switching_Analysis 
AS
    SELECT
        GDC.last_new_job AS Years_Since_Last_Job,
        COUNT(FHR.Candidate_ID) AS Total_Candidates ,
        SUM(FHR.[target]) AS Candidates_Looking_For_Job ,
        ROUND(CAST(SUM(FHR.[target]) AS FLOAT) * 100 /
              COUNT(FHR.Candidate_ID) , 2) AS Attrition_Rate
    FROM [GOLD].[Fact_HR]       AS FHR
    JOIN [GOLD].[Dim_Candidate] AS GDC
        ON FHR.Candidate_ID = GDC.Candidate_ID
    GROUP BY GDC.last_new_job

SELECT * FROM GOLD.vw_Job_Switching_Analysis
ORDER BY Attrition_Rate DESC

 