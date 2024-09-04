# World Life Expectancy Project (Exploratory Data Analysis)#
# I explored the data by looking at the life expectancy, insights and trends. 
#  This is based on countries, seeing if they were developed/developing and looking at the motality rates. 
# I also compared that data to the BMI and to see if that had any correlation of them being developed/developing.

SELECT *
FROM worldlifeexpectancy_table
;

SELECT country, MIN(`life expectancy`), MAX(`life expectancy`),
ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) as LIFE_EXPECTANCY_RANGE
FROM worldlifeexpectancy_table
group by country
HAVING  MIN(`life expectancy`) <> 0
AND MAX(`life expectancy`) <> 0
Order by LIFE_EXPECTANCY_RANGE asc
;

SET SQL_SAFE_UPDATES = 0;

SELECT Year, Round(avg(`life expectancy`),2)
FROM worldlifeexpectancy_table
where `life expectancy` <> 0
AND  `life expectancy` <> 0
GROUP BY year
Order BY Year
;

SELECT *
FROM worldlifeexpectancy_table
;

SELECT Country, Round(AVG(`life expectancy`),1) as Life_EXP, round(avg(GDP),1) AS GDP
FROM worldlifeexpectancy_table
GROUP BY Country
HAVING Life_EXP > 0
AND GDP > 0
Order BY GDP asc
;

SELECT *
FROM worldlifeexpectancy_table
order by GDP;
;

SELECT 
SUM(Case when GDP  >= 1500 THEN 1 ELSE 0 End) High_GDP_Count,
AVG(Case when GDP  >= 1500 THEN `life expectancy` ELSE NULL End) High_GDP_life_expectancy,
SUM(Case when GDP  <= 1500 THEN 1 ELSE 0 End) Low_GDP_Count,
AVG(Case when GDP  <= 1500 THEN `life expectancy` ELSE NULL End) Low_GDP_life_expectancy
FROM worldlifeexpectancy_table
;

SELECT *
FROM worldlifeexpectancy_table
;

SELECT status, Round(avg(`life expectancy`),1)
FROM worldlifeexpectancy_table
group by status
;

SELECT status,COUNT(DISTINCT Country), Round(avg(`life expectancy`),1)
FROM worldlifeexpectancy_table
group by status
;

SELECT Country, Round(AVG(`life expectancy`),1) as Life_EXP, round(avg(BMI),1) AS BMI
FROM worldlifeexpectancy_table
GROUP BY Country
HAVING Life_EXP > 0
AND BMI > 0
Order BY BMI DESC
;


SELECT Country, Year, `life expectancy`, 
`Adult Mortality`, sum(`Adult Mortality`) 
over(partition by country order by year) as rolling_total
FROM worldlifeexpectancy_table
where country like '%united%'
;
