create schema hr_analytics;
use hr_analytics;
select count(Attrition) from hr_1;
DESCRIBE HR_1;
select * from HR_1;
SELECT COUNT(*) FROM HR_1 WHERE EmployeeNumber IS NULL;

ALTER TABLE hr_1 
CHANGE COLUMN `ï»¿Age` `Age` INT NULL DEFAULT NULL;

select * from HR_2;


ALTER TABLE hr_2 
CHANGE COLUMN `ï»¿Employee ID` `Employee_ID` INT NULL DEFAULT NULL;

USE hr_analytics;

CREATE OR REPLACE VIEW v_hr_complete AS
SELECT 
    h1.*,
    h2.`MonthlyIncome`,
    h2.`YearsAtCompany`,
    h2.`YearsSinceLastPromotion`,
    h2.`TotalWorkingYears`
FROM hr_1 h1
INNER JOIN hr_2 h2 
    ON h1.EmployeeNumber = h2.Employee_ID;
    
select * from v_hr_complete;
   
  
# KPI 1: Average Attrition rate for the dataset 
select round(avg(Attrition_type)*100,2) as Overall_Attrition from v_hr_complete;

# KPI 2:Average Hourly rate,(Male)Research Scientist

SELECT 
    ROUND(AVG(HourlyRate), 2) AS Avg_Hourly_Rate
FROM v_hr_complete
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';


# KPI 3: total_Employees of the company

select count(*) as total_Employees from v_hr_complete;

# KPI 4: Total_Department in the company
select count(distinct department) as Total_Department from v_hr_complete;

# KPI 5: Total count of Male and female in the company

select gender,count(gender) from v_hr_complete group by gender;


# KPI 6: Attrition rate Vs Monthly income stats
SELECT 
    CASE 
        WHEN MonthlyIncome BETWEEN 0 AND 9999 THEN '0-9999'
        WHEN MonthlyIncome BETWEEN 10000 AND 19999 THEN '10000-19999'
        WHEN MonthlyIncome BETWEEN 20000 AND 29999 THEN '20000-29999'
        WHEN MonthlyIncome BETWEEN 30000 AND 39999 THEN '30000-39999'
        WHEN MonthlyIncome BETWEEN 40000 AND 49999 THEN '40000-49999'
        ELSE '50000-59999'
    END AS Income_Range,
    ROUND(AVG(`Attrition_type`) * 100, 2) AS Attrition_Rate_Pct
FROM v_hr_complete
GROUP BY 1
ORDER BY Income_Range ASC;

# KPI 7: Average working years By Department

SELECT 
    Department,
    ROUND(AVG(TotalWorkingYears), 1) AS Avg_Working_Years
FROM v_hr_complete
GROUP BY Department
ORDER BY Department ASC;

# KPI 8: Job Role Vs Work life balance

SELECT 
    JobRole,
    ROUND(AVG(TotalWorkingYears), 2) AS Avg_Work_Life_Balance
FROM v_hr_complete
GROUP BY JobRole;

# KPI 9: Attrition rate Vs last promotion

SELECT 
    YearsSinceLastPromotion,
    ROUND(AVG(`Attrition_type`) * 100, 2) AS Attrition_Rate_Pct
FROM v_hr_complete
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion ASC;










