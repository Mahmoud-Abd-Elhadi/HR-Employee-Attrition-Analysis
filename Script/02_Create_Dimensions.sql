
-- =============================================
-- Step 1: Create Schema (Container)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'GOLD')
BEGIN
    EXEC('CREATE SCHEMA GOLD')
END
GO


-- =============================================
-- Step 2: Create Candidate Dimension
-- =============================================
IF OBJECT_ID ('GOLD.Dim_Candidate') IS NOT NULL
	DROP TABLE GOLD.Dim_Candidate
GO

SELECT
	enrollee_id ,
	gender ,
	relevent_experience ,
	experience ,
	last_new_job
INTO GOLD.Dim_Candidate
FROM HR_Data

-- Standardize Column Name (enrollee_id -> Candidate_ID)
EXEC sp_rename 'GOLD.Dim_Candidate.enrollee_id' , 'Candidate_ID' , 'COLUMN'


-- =============================================
-- Step 3: Create Location Dimension
-- =============================================
IF OBJECT_ID ('GOLD.Dim_Location') IS NOT NULL
	DROP TABLE GOLD.Dim_Location

SELECT DISTINCT
	city ,
	city_development_index 
INTO GOLD.Dim_Location
FROM HR_Data

-- Standardize Column Name (city -> City_ID)
EXEC sp_rename 'GOLD.Dim_Location.city' , 'City_ID' , 'COLUMN' 


-- =============================================
-- Step 4: Create Company Dimension
-- =============================================
IF OBJECT_ID ('GOLD.Dim_Company') IS NOT NULL
	DROP TABLE GOLD.Dim_Company

-- Generate Surrogate Key (Company_ID) for unique Company attributes
SELECT DISTINCT
	IDENTITY(INT, 1, 1) AS Company_ID ,
	company_size ,
	company_type
INTO GOLD.Dim_Company
FROM 
	( SELECT DISTINCT 
		 company_size ,
		 company_type
	  FROM HR_Data ) AS SOURCE_TABLE

-- =============================================
-- Step 5: Create Education Dimension
-- =============================================
IF OBJECT_ID('GOLD.Dim_Education') IS NOT NULL
	DROP TABLE GOLD.Dim_Education

-- Generate Surrogate Key (Education_ID) for unique Education attributes
SELECT
	IDENTITY(INT, 1, 1) AS Education_ID ,
	education_level ,
	major_discipline ,
	enrolled_university
INTO GOLD.Dim_Education
FROM 
	(SELECT DISTINCT 
		education_level ,
		major_discipline ,
		enrolled_university
	 FROM HR_Data) AS T
