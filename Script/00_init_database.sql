
USE master
GO

-- =============================================
-- Step 1: Database Setup & Cleanup
-- =============================================

IF EXISTS (SELECT 1 FROM SYS.databases WHERE NAME = 'HR_Analytics_DW')
BEGIN
	ALTER DATABASE HR_Analytics_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE HR_Analytics_DW
END

-- Create the new database
CREATE DATABASE HR_Analytics_DW
GO

USE HR_Analytics_DW
GO
DROP TABLE HR_Data

-- =============================================
-- Step 2: Create Staging Table (Raw Data)
-- =============================================
CREATE TABLE HR_Data
(
	enrollee_id			   INT ,
	city				   VARCHAR(50) ,
	city_development_index FLOAT,
	gender				   VARCHAR(10),
	relevent_experience    VARCHAR(50),
	enrolled_university    VARCHAR(50),
	education_level        VARCHAR(50),
	major_discipline	   VARCHAR(50),
	experience			   VARCHAR(50),
	company_size		   VARCHAR(50),
	company_type		   VARCHAR(50),
	last_new_job		   VARCHAR(50),
	training_hour		   INT,
	[target]               FLOAT
)

-- Clear any existing data in the table
TRUNCATE TABLE HR_Data
GO

-- =============================================
-- Step 3: Data Ingestion (ETL Load)
-- =============================================

-- Efficiently load data from the CSV file into the staging table
BULK INSERT HR_Data
    FROM 'C:\Queries\My_Project\HR Analytics\Dataset\aug_train.csv'
WITH
(
    FIRSTROW = 2 ,
    FIELDTERMINATOR = ',' ,
    ROWTERMINATOR = '0x0a' ,  
    TABLOCK
)
GO
