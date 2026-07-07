--IMPORT DATASET INTO SQL AND CREATE DATABASE

CREATE DATABASE HRAnalytics;

USE HRAnalytics;

--UNDERSTAND THE DATA

--HOW MANY ROWS ARE THERE
SELECT COUNT(*) AS TotalRows
FROM HR_EmployeeData;

--HOW MANY COLUMNS DOES THE TABLE HAVE
SELECT COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HR_EmployeeData';

--CHECK FOR MISSING VALUES
SELECT 
    SUM(CASE WHEN Educationlevel IS NULL
THEN 1 ELSE 0 END) AS MissingEducation,
    SUM(CASE WHEN BusinessTravel IS NULL 
THEN 1 ELSE 0 END) AS MissingBusinessTravel,
    SUM(CASE WHEN JobSatisfaction IS NULL
THEN 1 ELSE 0 END) AS MissingJobSatisfaction
FROM HR_EmployeeData;

--CHECK FOR DUPLICATES
SELECT EmployeeID,
       COUNT(*) AS Duplicatecount
FROM HR_EmployeeData
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

--EXPLORE THE DATA

--GENDER DISTRIBUTION
SELECT Gender,
       COUNT(*) AS EmployeeCount
FROM HR_EmployeeData
GROUP BY Gender;

--DEPARTMENT DISTRIBUTION
SELECT Department,
       COUNT(*) AS EmployeeCount
FROM HR_EmployeeData
GROUP BY Department
ORDER BY EmployeeCount DESC;

--ATTRITION DISTRIBUTION
SELECT Attrition,
       COUNT(*) AS EmployeeCount
FROM HR_EmployeeData
GROUP BY Attrition; 


--DATA CLEANING QUERIES
--Replacing Missing Educationlevel

UPDATE HR_EmployeeData
SET EducationLevel = 'UNKNOWN'
WHERE EducationLevel IS NULL;

--Replacing Missing BusinessTravel
UPDATE HR_EmployeeData
SET BusinessTravel = 'UNKNOWN'
WHERE BusinessTravel IS NULL;

--Replacing Missing JobSatisfaction
SELECT AVG(CAST( JobSatisfaction AS FLOAT)) AS AvgJobSatisfaction
FROM HR_EmployeeData
WHERE JobSatisfaction IS NOT NULL;

UPDATE HR_EmployeeData
SET JobSatisfaction = 3
WHERE JobSatisfaction IS NULL

--Removing the 20 Duplicates
WITH DuplicateCTE AS
(  
   SELECT*,
         ROW_NUMBER() OVER (
		 PARTITION BY EmployeeID
		 ORDER BY EmployeeID
		 ) AS RowNum
  FROM HR_EmployeeData
		 )
  DELETE FROM DuplicateCTE
  WHERE RowNum >1;

  --TO VERIFY THE CLEANING
--Check total rows
SELECT COUNT(*) AS TotalRows
from HR_EmployeeData;

--Check missing values again
SELECT 
    SUM(CASE WHEN Educationlevel IS NULL
THEN 1 ELSE 0 END) AS MissingEducation,
    SUM(CASE WHEN BusinessTravel IS NULL 
THEN 1 ELSE 0 END) AS MissingBusinessTravel,
    SUM(CASE WHEN JobSatisfaction IS NULL
THEN 1 ELSE 0 END) AS MissingJobSatisfaction
FROM HR_EmployeeData;

--Check duplicates again
SELECT EmployeeID,
       COUNT(*) AS Duplicatecount
FROM HR_EmployeeData
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

--CREATE FINAL TABLE

SELECT *
INTO HR_EmployeeData_Final
FROM HR_EmployeeData;


--HR BUSINESS ANALYSIS
--OVER ALL ATTRITION
SELECT
    COUNT(*) AS TotalEmployees,
	SUM(CAST (Attrition AS INT)) AS
	EmployeesLeft,
	ROUND(
	  100.0 * SUM(CAST(Attrition AS INT)) / COUNT(*),
	  2
	  ) AS AttritionRate
FROM HR_EmployeeData_Final;

--ATTRITION BY DEPARTMENT
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
	SUM(CAST (Attrition AS INT)) AS
	EmployeesLeft,
	ROUND(
	  100.0 * SUM(CAST(Attrition AS INT)) / COUNT(*),
	  2
	  ) AS AttritionRate
FROM HR_EmployeeData_Final
GROUP BY Department
ORDER BY AttritionRate DESC;

--DOES 'OVERTIME' AFFECT ATTRITON?
SELECT
    Overtime,
    COUNT(*) AS TotalEmployees,
	SUM(CAST (Attrition AS INT)) AS
	EmployeesLeft,
	ROUND(
	  100.0 * SUM(CAST(Attrition AS INT)) / COUNT(*),
	  2
	  ) AS AttritionRate
FROM HR_EmployeeData_Final
GROUP BY Overtime
ORDER BY AttritionRate DESC;

--WHICH 'JOBROLES' HAVE THE HIGHEST ATTRITION?
SELECT
    JobRole,
    COUNT(*) AS TotalEmployees,
	SUM(CAST (Attrition AS INT)) AS
	EmployeesLeft,
	ROUND(
	  100.0 * SUM(CAST(Attrition AS INT)) / COUNT(*),
	  2
	  ) AS AttritionRate
FROM HR_EmployeeData_Final
GROUP BY JobRole
ORDER BY AttritionRate DESC;

--DOES 'WORKLIFEBALANCE MATTER?
SELECT
    WorkLifeBalance,
    COUNT(*) AS TotalEmployees,
	SUM(CAST (Attrition AS INT)) AS
	EmployeesLeft,
	ROUND(
	  100.0 * SUM(CAST(Attrition AS INT)) / COUNT(*),
	  2
	  ) AS AttritionRate
FROM HR_EmployeeData_Final
GROUP BY  WorkLifeBalance
ORDER BY  WorkLifeBalance;


