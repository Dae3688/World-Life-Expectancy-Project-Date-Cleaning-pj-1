-- US Household Income Exploratory Data Analysis-- 

SELECT *
From us_project.ushouseholdincome;  # analyzed the data #

SELECT *
From us_project.ushouseholdincome_statistics; # analyzed the data #

select State_name, sum(aland), sum(awater)  # I looked at the largest area of the land and the water based on state
from us_project.ushouseholdincome
GROUP BY state_name
ORDER BY 3 desc
limit 10; # looked up the top 10


SELECT u.State_Name, city, 
       round(AVG(us.mean), 1), round(AVG(us.median), 1) # Wanted to know the highest mean and median averages of household incomes (based on state and city)
FROM us_project.ushouseholdincome AS u					
 JOIN us_project.ushouseholdincome_statistics AS us
ON u.id = us.id
GROUP BY  State_Name, city
ORDER BY round(AVG(us.mean), 1) DESC
;

SELECT type, COUNT(type), 
       round(AVG(us.mean), 1), round(AVG(us.median), 1) # looked at dfferent "types" such as track, city or borough to see the average mean and median of household incomes
FROM us_project.ushouseholdincome AS u					
INNER JOIN us_project.ushouseholdincome_statistics AS us
ON u.id = us.id
where mean <> 0 # filtered out the dirty data
GROUP BY 1 
ORDER BY 4 DESC
limit 20;


SET SQL_SAFE_UPDATES = 0; -- Had to disable safe UPDATE mode to stop getting errors to allow me to filter the data as needed




