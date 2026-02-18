
-- =============================================
-- Step 1: Define Primary Keys for Dimensions
-- =============================================

-- 1.1 Candidate Dimension
-- Ensure the column is NOT NULL before creating PK
ALTER TABLE GOLD.Dim_Candidate
	ALTER COLUMN Candidate_ID INT NOT NULL

ALTER TABLE GOLD.Dim_Candidate
	ADD CONSTRAINT PK_Candidate PRIMARY KEY (Candidate_ID)

-- 1.2 Location Dimension
-- Ensure the column is NOT NULL before creating PK
ALTER TABLE GOLD.Dim_Location
	ALTER COLUMN City_ID VARCHAR(50) NOT NULL

ALTER TABLE GOLD.Dim_Location
	ADD CONSTRAINT PK_Location PRIMARY KEY (City_ID)

-- 1.3 Company Dimension
ALTER TABLE GOLD.Dim_Company
	ADD CONSTRAINT PK_Company PRIMARY KEY (Company_ID)

-- 1.4 Education Dimension
ALTER TABLE GOLD.Dim_Education
	ADD CONSTRAINT PK_Education PRIMARY KEY (Education_ID)


-- =============================================
-- Step 2: Define Primary Key for Fact Table
-- =============================================
ALTER TABLE GOLD.Fact_HR
	ADD CONSTRAINT PK_Fact PRIMARY KEY (Fact_ID)

-- =============================================
-- Step 3: Define Foreign Keys (Relationships)
-- =============================================

-- 3.1 Link Fact to Candidate
ALTER TABLE GOLD.Fact_HR
	ADD CONSTRAINT FK_Fact_Candidate 
	FOREIGN KEY (Candidate_ID) REFERENCES GOLD.Dim_Candidate (Candidate_ID)

-- 3.2 Link Fact to Location
ALTER TABLE GOLD.Fact_HR
	ADD CONSTRAINT FK_Fact_Location
	FOREIGN KEY (City_ID) REFERENCES GOLD.Dim_Location (City_ID)

-- 3.3 Link Fact to Company
ALTER TABLE GOLD.Fact_HR
	ADD CONSTRAINT FK_Fact_Company
	FOREIGN KEY (Company_ID) REFERENCES GOLD.Dim_Company (Company_ID)

-- 3.4 Link Fact to Education
ALTER TABLE GOLD.Fact_HR
	ADD CONSTRAINT FK_Fact_Education
	FOREIGN KEY (Education_ID) REFERENCES GOLD.Dim_Education (Education_ID)
