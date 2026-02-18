-- =============================================
-- Step 1: Clean up existing Fact Table
-- =============================================
IF OBJECT_ID('GOLD.Fact_HR') IS NOT NULL 
	DROP TABLE GOLD.Fact_HR

-- =============================================
-- Step 2: Create and Populate Fact Table
-- =============================================
SELECT
	T1.enrollee_id ,
	T1.city ,
	EDU.Education_ID ,
	COMP.Company_ID ,
	T1.training_hour ,
	T1.[target]
INTO GOLD.Fact_HR
FROM HR_Data AS T1
JOIN GOLD.Dim_Education AS EDU
	ON  T1.education_level = EDU.education_level
	AND T1.major_discipline = EDU.major_discipline
	AND T1.enrolled_university = EDU.enrolled_university
JOIN GOLD.Dim_Company AS COMP
	ON  T1.company_size = COMP.company_size
	AND T1.company_type = COMP.company_type


-- =============================================
-- Step 3: Add Surrogate Key (Fact_ID)
-- =============================================
ALTER TABLE GOLD.Fact_HR
	ADD Fact_ID INT IDENTITY(1,1)

-- =============================================
-- Step 4: Standardize Column Names
-- =============================================
EXEC sp_rename 'GOLD.Fact_HR.enrollee_id' , 'Candidate_ID' , 'COLUMN' 
EXEC sp_rename 'GOLD.Fact_HR.city' , 'City_ID' , 'COLUMN' 
