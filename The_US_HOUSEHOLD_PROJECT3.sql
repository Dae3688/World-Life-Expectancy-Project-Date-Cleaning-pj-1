-- US household income data clearing --

Select *
from ushouseholdincome_statistics;

ALTER TABLE ushouseholdincome_statistics 
RENAME COLUMN `ï»¿id` TO `id`;

Select *
from ushouseholdincome_statistics; # Column fixed #

Select *
From ushouseholdincome;  # I looked at both income & statistics to ANALYZE for errors

select *
From ushouseholdincome_statistics;

select count(id)
from ushouseholdincome_statistics;

select id, COUNT(id)				# I found all the duplicates
from us_project.ushouseholdincome_statistics
group by id
having COUNT(id) > 1;

DELETE FROM us_project.ushouseholdincome_statistics #(I ran into a problem here. error:Error Code: 1093. You can't specify target table 'ushouseholdincome_statistics' for update in FROM clause
#)
WHERE id IN (
    SELECT id
    FROM us_project.ushouseholdincome_statistics
    GROUP BY id
    HAVING COUNT(*) > 1);
    
CREATE TEMPORARY TABLE duplicate_ids AS
SELECT id
FROM us_project.ushouseholdincome_statistics
GROUP BY id
HAVING COUNT(*) > 1;

DELETE FROM us_project.ushouseholdincome_statistics #I recieved this error and corrected it.Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
WHERE id IN (SELECT id FROM duplicate_ids)
;
SET SQL_SAFE_UPDATES = 0;

DELETE FROM us_project.ushouseholdincome_statistics
WHERE id IN (SELECT id FROM duplicate_ids)
;
select id, COUNT(id)				# Checking for the duplicates
from us_project.ushouseholdincome_statistics
group by id
having COUNT(id) > 1; # duplicates eliminated 

SELECT id, COUNT(*) AS duplicate_count
FROM ushouseholdincome
GROUP BY id
HAVING COUNT(*) > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM ushouseholdincome    #I recieved this error and corrected it.Error Code: 1175. You are using safe update mode.... Then I had to turn off the sfe mode again
WHERE id IN (
  SELECT id
  FROM (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM ushouseholdincome
  ) AS subquery
  WHERE row_num > 1
);

SELECT id, ROW_NUMBER () over (PARTITION BY id) 'the_count' 
    FROM ushouseholdincome
    where 'the_count' > 1;  # duplicates eliminated 

SELECT DISTINCT state_name # Checked for any incorrect spellings of states
from ushouseholdincome
ORDER BY 1;

UPDATE ushouseholdincome #updated the column were there was some mis spelling of 'Georgia'
SET State_Name ='Georgia'
where State_Name = 'georia';

Select State_Name				#wanted to make sure all the 'Georgia' looks to same, no lower case
From ushouseholdincome
where State_Name like 'georgia';

Select Type, count(Type)   # This allowed me to see each individual type, to see any errors
From ushouseholdincome
GROUP BY type;

update ushouseholdincome # I updated the errror of 'Boroughs' to Borough
set type = 'Borough'
where type = 'Boroughs';



