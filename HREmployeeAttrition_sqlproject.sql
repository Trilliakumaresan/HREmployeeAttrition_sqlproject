-- List all tables in the current database
SELECT 
	table_schema, 
    table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';

SELECT * 
FROM HREmployeeAttrition;

---Understanding the Structure of the Dataset
EXEC sp_help 'HREmployeeAttrition';

--Check for Missing Values:
SELECT COUNT(*) 
FROM HREmployeeAttrition 
WHERE age IS NULL;

--Remove Duplicates:
SELECT 
    COUNT(*) AS TotalRecords,
    COUNT(Age) AS Age_NotNull,
    COUNT(Attrition) AS Attrition_NotNull,
    COUNT(BusinessTravel) AS BusinessTravel_NotNull,
    COUNT(DailyRate) AS DailyRate_NotNull,
    COUNT(Department) AS Department_NotNull,
    COUNT(DistanceFromHome) AS DistanceFromHome_NotNull,
    COUNT(Education) AS Education_NotNull,
    COUNT(EducationField) AS EducationField_NotNull,
    COUNT(EmployeeCount) AS EmployeeCount_NotNull,
    COUNT(EmployeeNumber) AS EmployeeNumber_NotNull,
    COUNT(EnvironmentSatisfaction) AS EnvironmentSatisfaction_NotNull,
    COUNT(Gender) AS Gender_NotNull,
    COUNT(HourlyRate) AS HourlyRate_NotNull,
    COUNT(JobInvolvement) AS JobInvolvement_NotNull,
    COUNT(JobLevel) AS JobLevel_NotNull,
    COUNT(JobRole) AS JobRole_NotNull,
    COUNT(JobSatisfaction) AS JobSatisfaction_NotNull,
    COUNT(MaritalStatus) AS MaritalStatus_NotNull,
    COUNT(MonthlyIncome) AS MonthlyIncome_NotNull,
    COUNT(MonthlyRate) AS MonthlyRate_NotNull,
    COUNT(NumCompaniesWorked) AS NumCompaniesWorked_NotNull,
    COUNT(Over18) AS Over18_NotNull,
    COUNT(OverTime) AS OverTime_NotNull,
    COUNT(PercentSalaryHike) AS PercentSalaryHike_NotNull,
    COUNT(PerformanceRating) AS PerformanceRating_NotNull,
    COUNT(RelationshipSatisfaction) AS RelationshipSatisfaction_NotNull,
    COUNT(StandardHours) AS StandardHours_NotNull,
    COUNT(StockOptionLevel) AS StockOptionLevel_NotNull,
    COUNT(TotalWorkingYears) AS TotalWorkingYears_NotNull,
    COUNT(TrainingTimesLastYear) AS TrainingTimesLastYear_NotNull,
    COUNT(YearsAtCompany) AS YearsAtCompany_NotNull,
    COUNT(YearsInCurrentRole) AS YearsInCurrentRole_NotNull,
    COUNT(YearsSinceLastPromotion) AS YearsSinceLastPromotion_NotNull,
    COUNT(YearsWithCurrManager) AS YearsWithCurrManager_NotNull
FROM HREmployeeAttrition;

--This will return the empoyee number that appear more than once in the HREmployeeAttrition table.
SELECT 
	EmployeeNumber, 
    COUNT(*)
FROM HREmployeeAttrition
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;                                                   

--Anomalies and Outliers
SELECT * 
FROM HREmployeeAttrition
WHERE MonthlyIncome > (SELECT AVG(MonthlyIncome) + 3 * STDEV(MonthlyIncome) FROM HREmployeeAttrition);

--------------------------------------------------------------------------------------------------------------------------------

--Questions
--1. What is the average age of employees in the company?
select 
	avg(age) as [Average Age of the Employees] 
from HREmployeeAttrition;


--2. How many employees are in each department?
select 
	department,
    count(*) as [Number of Employees] 
from HREmployeeAttrition 
GROUP by department;

--3. What is the average monthly income by job role?
select 
	jobrole, 
    avg(monthlyincome) as [Average Monthly Income] 
from HREmployeeAttrition 
GROUP by jobrole;

--4. How many employees have left the company (Attrition)?
select 
	count(*) as 'Number of Employees Left the Company' 
from HREmployeeAttrition 
where attrition='Yes';

--5. What is the distribution of EducationField among employees?
select 
	EducationField, 
    count(*) as [Number of Employees] 
from HREmployeeAttrition 
group by educationfield;

--6. What is the average number of years employees have been with the company?
select 
	avg(yearsatcompany) as 'Average Number of Years at Company' 
from HREmployeeAttrition;

--7. How many employees travel frequently for business?
select 
	count(*) as [Number of Employeees Travel Frequently] 
from HREmployeeAttrition 
where BusinessTravel = 'Travel_Frequently';

--8. Which employees are eligible for stock options and at what levels?
select jobrole, stockoptionlevel, count(*) As [Number of Employees] 
from HREmployeeAttrition 
group by jobrole,stockoptionlevel having stockoptionlevel > '0'
order by stockoptionlevel;

--9. What is the correlation between JobRole and JobLevel?
select jobrole, joblevel, count(*) As [Number of Employees] 
from HREmployeeAttrition 
group by jobrole,joblevel
order by joblevel;
----------------------------------------------------------------------------------------------------------------------------
--Reasons for Attrition

--1. What is the overall attrition rate in the company?
select 
	count(*) As [Total No.of Rows],
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS [Total Number of Attrition],
    ((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) / count(*) * 100) AS AttritionRate
from AttritionTable

--2. Is there a correlation between the percentage of salary hike and attrition?
SELECT 
    PercentSalaryHike,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS TotalAttrition
FROM HREmployeeAttrition
GROUP BY PercentSalaryHike
ORDER BY TotalAttrition desc; 

--3. What is the relationship between JobSatisfaction and Attrition?
SELECT JobSatisfaction, 
	   COUNT(*) AS Number_of_Employees, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Number_of_Employees_Left
FROM HREmployeeAttrition 
GROUP BY JobSatisfaction order by JobSatisfaction;


--4. Which departments have the highest attrition rates?
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS TotalAttrition
FROM HREmployeeAttrition
GROUP BY Department
ORDER BY TotalAttrition DESC;
    
--5. Employees from which designation falls attrition more
select 
	Jobrole,
    count(Case when attrition = 'Yes' then 1 else 0 end) as [Number of Employees Attrited]
from HREmployeeAttrition 
group by jobrole 
order by [Number of Employees Attrited] desc;

--6. distance from home by job role and attrition
SELECT 
    JobRole,
    Attrition,
    AVG(DistanceFromHome) AS Average_Distance,
    MIN(DistanceFromHome) AS Min_Distance,
    MAX(DistanceFromHome) AS Max_Distance,
    COUNT(*) AS Number_of_Employees
FROM HREmployeeAttrition
GROUP BY JobRole, Attrition HAVING attrition='Yes'
ORDER BY JobRole, Attrition;

--7. How does attrition vary across different age groups?
SELECT 
    Age,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS TotalAttrition
FROM HREmployeeAttrition
GROUP BY Age
ORDER BY TotalAttrition desc;

--8. compare average monthly income by education and attrition
select 
	Education,
    Educationfield,
    AVG(monthlyincome) As [Monthly Income],
    count(*) as [Number of Employees Attrited]
 from HREmployeeAttrition
 GROUP by education, educationfield, attrition
 HAVING attrition = 'Yes'
 ORDER BY education;
 
 --16. 
