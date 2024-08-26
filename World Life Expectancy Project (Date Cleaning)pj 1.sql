# World Life Expectancy Project (Date Cleaning)

Select *     # analyzed data table
From worldlifeexpectancy_table
 ;
 
Select country, year, concat(country, year), count(concat(country, year))     # stringed together the country and yr to find duplicates and counted them
From worldlifeexpectancy_table
GROUP BY country, year, concat(country, year)
Having count(concat(country, year)) > 1   # searched for the duplicates that were greater than 1
 ;
 
 SELECT *
 FROM( SELECT Row_ID,
       concat(country, year),
       ROW_NUMBER() OVER(PARTITION BY concat(country, year) ORDER BY Row_ID) AS Row_num   # assigned each row a number to also look for duplicates
FROM worldlifeexpectancy_table) As ROW_TABLE
where ROW_NUM > 1;
 
 
 Delete from worldlifeexpectancy_table   # decided to delete all duplicates greater than 1
 FROM ( SELECT Row_ID,
       concat(country, year),
       ROW_NUMBER() OVER(PARTITION BY concat(country, year) ORDER BY Row_ID) AS Row_num
FROM worldlifeexpectancy_table) As Subquery
where Row_num > 1);
 
 SET SQL_SAFE_UPDATES = 0; # I made sure to set this to '0' to not run int issues and also created a backup in case there are any irreversible errors 
 
 
Select *    				# Checked to see what status is blank
From worldlifeexpectancy_table
where status= '';    

Select *    
From worldlifeexpectancy_table
where status= is null    # I found no rows that were empty with nulls
 ;
 
Select DISTINCT Status
From worldlifeexpectancy_table
where status <> '' # I found status to be either developed or developing
 ;
 
Select DISTINCT(Country)  
From worldlifeexpectancy_table
where status= 'developing'   # looked at DISTINCT Countries
 ;
 update worldlifeexpectancy_table     #didn't work
 Set t1.Status = 'Developing' 
 where Country in (Select DISTINCT(Country)  
					From worldlifeexpectancy_table
					where status= 'developing');
                    
 
 UPDATE worldlifeexpectancy_table t1      # I updated the missing status to developing 
JOIN worldlifeexpectancy_table t2 ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' AND t2.Status = 'Developing';
 
Select *    
From worldlifeexpectancy_table
where country = 'United States of America'   # the status next to the united atates year 2021 didn't populate to 'developed'
 ;
 
UPDATE worldlifeexpectancy_table t1         # I updated and populated the empty status to developed
JOIN worldlifeexpectancy_table t2 ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' AND t2.Status = 'Developed';
 
 
Select *    
From worldlifeexpectancy_table
where `Life expectancy`= '';    # I decided to populate the data by averaging the data out


Select t1.Country, t1.Year, t1.`Life expectancy`,  # I decided to averaging the data out to fill in missing blanks
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
From worldlifeexpectancy_table t1
 Join worldlifeexpectancy_table t2
 on t1.Country = t2.Country
 AND t1.Year = t2.Year - 1
 Join worldlifeexpectancy_table t3
 on t1.Country = t3.Country
 AND t1.Year = t3.Year + 1
 where t1.`Life expectancy` = '' ;
 
update worldlifeexpectancy_table t1   # Updated the table to fill in those blanks of averaged data
 Join worldlifeexpectancy_table t2
 on t1.Country = t2.Country
 AND t1.Year = t2.Year - 1
 Join worldlifeexpectancy_table t3
 on t1.Country = t3.Country
 AND t1.Year = t3.Year + 1
 set t1.`Life expectancy`= ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
 WHERE t1.`Life expectancy` = ''