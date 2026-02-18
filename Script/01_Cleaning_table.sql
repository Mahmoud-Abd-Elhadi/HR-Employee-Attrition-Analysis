-- =============================================
-- Step 1: Handling NULLs in Categorical Columns
-- =============================================

-- 1.1 Fill missing Gender with 'Unknown'
UPDATE HR_Data
SET gender = ISNULL(gender , 'Unknown')

-- 1.2 Handle missing University Enrollment
UPDATE HR_Data
SET enrolled_university = 'no_enrollment'
WHERE enrolled_university IS NULL

-- 1.3 Handle missing Education Level
UPDATE HR_Data
SET education_level = 'Student'
WHERE education_level IS NULL

-- 1.4 Handle missing Major
UPDATE HR_Data
SET major_discipline = 'No Major'
WHERE major_discipline IS NULL

-- =============================================
-- Step 2: Cleaning 'Experience' Column (Complex Logic)
-- =============================================

-- (Data Inspection) - Review special cases
SELECT
	*
FROM HR_Data
WHERE experience LIKE '<%' OR 
	  experience LIKE '>%'

-- 2.1 Convert '<1' to 0 (Logic: Extract number '1' then subtract 1)
UPDATE HR_Data
SET experience = CAST(TRIM(SUBSTRING(experience , 2 , 2)) AS INT ) - 1
WHERE experience LIKE '<%' 

-- 2.2 Convert '>20' to 21 (Logic: Extract number '20' then add 1)
UPDATE HR_Data
SET experience = CAST(TRIM(SUBSTRING(experience , 2 , 2)) AS INT ) + 1
WHERE experience LIKE '>%'

-- 2.3 Handle NULL experience by setting it to 0
UPDATE HR_Data
SET experience = 0
WHERE experience IS NULL

-- =============================================
-- Step 3: Cleaning Company Data
-- =============================================

SELECT * FROM HR_Data
SELECT DISTINCT company_size FROM HR_Data

-- 3.1 Standardize format: Replace '/' with '-'
UPDATE HR_Data
SET company_size = REPLACE(company_size , '/' , '-')

-- 3.2 Handle missing Company Size
UPDATE HR_Data
SET company_size = 'Unknown'
WHERE company_size IS NULL

-- 3.3 Handle missing Company Type
UPDATE HR_Data
SET company_type = 'Other' 
WHERE company_type IS NULL

-- =============================================
-- Step 4: Cleaning 'Last New Job' Column
-- =============================================
SELECT DISTINCT last_new_job FROM HR_Data

-- 4.1 Normalize values: Convert 'never' to '0' and handle NULLs
UPDATE HR_Data
SET last_new_job = 
				   CASE
					   WHEN last_new_job = 'never' THEN '0'
					   WHEN last_new_job IS NULL THEN 'Unknown'
					   ELSE last_new_job
				   END

-- =============================================
-- Step 5: Final Data Type Conversion
-- =============================================

-- 5.1 Convert 'experience' from String (VARCHAR) to Integer
ALTER TABLE HR_Data
ALTER COLUMN experience INT

-- 5.2 Convert 'target' from Float to Integer (0 or 1)
ALTER TABLE HR_Data
ALTER COLUMN [target] INT 