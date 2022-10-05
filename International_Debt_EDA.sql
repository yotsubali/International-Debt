USE Project;
GO

-- view IDS_AllCountries_Data, IDS_CountryMetaData
SELECT *
FROM IDS_AllCountries_Data;
SELECT*
FROM IDS_CountryMetaData;

-- we notice that the column names of IDS_AllCountries_Data table is column plus number, which is quite inconvenient to analyze
-- so we change its column names to attributes in the first record, then delete the first record
DELETE FROM IDS_AllCountries_Data
WHERE Country_Name LIKE '%Country Name%';

-- 5 last records in IDS_AllCountries_Data table are null and info about data source and date, we will delete those 5 records
DELETE FROM IDS_AllCountries_Data
WHERE Country_Code IS NULL;


-- explore IDS_AllCountries_Data
SELECT
COUNT (DISTINCT Country_Name) num_of_countries,
COUNT (DISTINCT Series_Code) num_of_indicators,
COUNT (Country_Name) num_of_rows
FROM IDS_AllCountries_Data;


-- take a look at the countries with the highest debt by indicator in 2022
SELECT 
Country_Name,
Country_Code,
Series_Name,
Series_Code,
[2022] Debt_in_2022
FROM IDS_AllCountries_Data
WHERE [2022] IN (SELECT MAX ([2022])
				FROM IDS_AllCountries_Data
				GROUP BY Series_Code);


-- now look closer to DT.DOD.PVLX.CD indicator (present value of external debt)
SELECT *
FROM IDS_AllCountries_Data
WHERE Series_Code LIKE '%DT.DOD.PVLX.CD%';
-- we can quickly see that the latest data being updated in 2020

-- let's see top 10 countries having the largest debt in 2020 based on DT.DOD.PVLX.CD (present value of external debt)
SELECT TOP 10
Country_Name,
[2020] Debt_in_2020
FROM IDS_AllCountries_Data
WHERE
Series_Code LIKE '%DT.DOD.PVLX.CD%'
ORDER BY [2020] DESC;
-- China ranks no.1 on the list with the amount of debt being $3.9E+12


-- let's look at top 20 countries having the highest total amount of debt (of all indicators) in 2022
SELECT TOP 20
Country_Name,
Country_Code,
SUM([2022]) Total_Debt_2022
FROM IDS_AllCountries_Data
GROUP BY Country_Name, Country_Code
ORDER BY Total_Debt_2022 DESC;
-- the income groups, regions, countries and several classifications appear in the list, which is quite confusing

-- so we will see the total amount of debt in 2022 by income group and by region this time

-- take a look at Income_Group attribute
SELECT DISTINCT Income_Group
FROM IDS_CountryMetaData;
-- there's null, let's see what it is

SELECT *
FROM IDS_CountryMetaData
WHERE Income_Group IS NULL;
-- we can see these NULL income groups are regions, income groups, several classifications and Venezuela

-- now we exclude NULL value and look at which income group owes the largest debt in 2022?
SELECT
Income_Group,
SUM ([2022]) Total_Debt_2022
FROM IDS_AllCountries_Data tb1
JOIN IDS_CountryMetaData tb2
ON tb1.Country_Code = tb2.Code
WHERE Income_Group IS NOT NULL
GROUP BY Income_Group
ORDER BY Total_Debt_2022 DESC;
-- so countries from Upper middle income group owes the largest debt in 2022 with the amount of debt being $6,76721339704062E+16


-- now take a look at Region attribute
SELECT DISTINCT Region
FROM IDS_CountryMetaData;
-- there's null, let's see what it is

SELECT *
FROM IDS_CountryMetaData
WHERE Region IS NULL;
-- we can see these NULL income groups are regions, income groups and several classifications

-- now we exclude NULL value and look at which region owes the largest debt in 2022?
SELECT
Region,
SUM ([2022]) Total_Debt_2022
FROM IDS_AllCountries_Data tb1
JOIN IDS_CountryMetaData tb2
ON tb1.Country_Code = tb2.Code
WHERE Region IS NOT NULL
GROUP BY Region
ORDER BY Total_Debt_2022 DESC;
-- so countries from East Asia & Pacific owes the largest debt in 2022 with the amount of debt being $6,76657504283366E+16


-- now explore IDS_CountryMetaData more
-- let's check out Lending_category attribute 
SELECT DISTINCT Lending_category
FROM IDS_CountryMetaData;
-- there's null, let's take a closer look

SELECT *
FROM IDS_CountryMetaData
WHERE Lending_category IS NULL;
-- we can see these NULL lending categories are regions, income groups and several classifications

-- let's see which lending type is the most popular among the countries
SELECT 
Lending_category,
COUNT (Code) num_of_countries
FROM IDS_CountryMetaData
WHERE Lending_category IS NOT NULL
GROUP BY Lending_category
ORDER BY num_of_countries DESC;
-- so IBRD and IDA are the two most popular lending type


-- which system of trade most countries use?
SELECT 
System_of_trade,
COUNT (Code) num_of_countries
FROM IDS_CountryMetaData
GROUP BY System_of_trade
ORDER BY num_of_countries DESC;
-- so General trade system is the most used system of trade

-- let's see more about Special trade system
SELECT
Region,
COUNT (Code) num_of_countries
FROM IDS_CountryMetaData
WHERE System_of_trade LIKE '%Special trade system%'
GROUP BY Region
ORDER BY num_of_countries DESC;
-- so most of countries from Latin America & Caribbean use Special trade system


-- now let's find out which Government Accounting concept is the most popular concept?
SELECT 
Government_Accounting_concept,
COUNT (Code) num_of_countries
FROM IDS_CountryMetaData
GROUP BY Government_Accounting_concept
ORDER BY num_of_countries DESC;
-- so Budgetary central government concept is the most popular government accounting concept


-- now let's see which IMF data dissemination standard is used by most countries?
SELECT 
IMF_data_dissemination_standard,
COUNT (Code) num_of_countries
FROM IDS_CountryMetaData
GROUP BY IMF_data_dissemination_standard
ORDER BY num_of_countries DESC;
-- so Enhanced General Data Dissemination System (e-GDDS) is used by most countries


-- data for visualization in Tableau

-- countries with the highest debt by indicator in 2022
SELECT 
Country_Name,
Country_Code,
Series_Name,
Series_Code,
[2022] Highest_Debt
FROM IDS_AllCountries_Data
WHERE [2022] IN (SELECT MAX ([2022])
				FROM IDS_AllCountries_Data
				GROUP BY Series_Code);

--  debt in 2022 by income group
SELECT
Income_Group,
SUM ([2022]) Total_Debt_2022
FROM IDS_AllCountries_Data tb1
JOIN IDS_CountryMetaData tb2
ON tb1.Country_Code = tb2.Code
WHERE Income_Group IS NOT NULL
GROUP BY Income_Group;


-- debt in 2022 by region 
SELECT
Region,
SUM ([2022]) Total_Debt_2022
FROM IDS_AllCountries_Data tb1
JOIN IDS_CountryMetaData tb2
ON tb1.Country_Code = tb2.Code
WHERE Region IS NOT NULL
GROUP BY Region;
