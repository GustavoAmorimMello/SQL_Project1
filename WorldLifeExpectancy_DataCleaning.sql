-- World Life Expectancy Data Cleaning

SELECT * 
FROM world_life_expectancy
;

-- Searching for duplicates in the table

-- Found a duplicated line related to country and year
SELECT country, 
Year,
CONCAT(country,year),
COUNT(CONCAT(country,year))
FROM world_life_expectancy
GROUP BY Country, YEar, CONCAT(country,year)
HAVING COUNT(CONCAT(country,year)) > 1
;

-- Searching which line is duplicated from Row_id
SELECT *
FROM
(
SELECT ROW_ID,
CONCAT(country,year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(country,year) ORDER BY CONCAT(country,year)) as Row_num
FROM world_life_expectancy) as Row_table
WHERE row_num > 1
;

-- Deleting the rows that are duplicated
DELETE FROM world_life_expectancy
WHERE 
	ROw_id IN (
    SELECT row_id
FROM
(
SELECT ROW_ID,
CONCAT(country,year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(country,year) ORDER BY CONCAT(country,year)) as Row_num
FROM world_life_expectancy) as Row_table
WHERE row_num > 1)
;

SELECT * 
FROM world_life_expectancy
;

-- Identifying blank values in the "status" column
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

-- Identifying distinct values from "status" column to populated the blank values
SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE Status <> ''
;

SELECT country, status 
FROM world_life_expectancy
WHERE country = 'Afghanistan'
;

-- Replacing Blank values in "Status" to the correct value between "developing" and "developed"
SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE status = 'Developed'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed'
;

SELECT * 
FROM world_life_expectancy
;

-- Replacing blank spaces in 'Life Expectancy" column to the AVG between the previous year and next year

SELECT * 
FROM world_life_expectancy
Where `Life expectancy` = ''
;
-- Using Self Join to include the AVG value of the year before and the next year to the years with blank space
SELECT t1.Country, t1.Year,  t1.`Life expectancy`, 
t2.Country, t2.Year,  t2.`Life expectancy`, 
t3.Country, t3.Year,  t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1 
Where t1.`Life expectancy` = ''
;

-- Updating the table to the new value for the blank spaces
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1 
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;

