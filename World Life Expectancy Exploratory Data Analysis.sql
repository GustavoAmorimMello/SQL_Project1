-- World Life Expectancy Exploratory Data Analysis

-- Studying the life expectancy

SELECT country,
MIN(`Life expectancy`),
MAX(`Life expectancy`), 
round(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_INCREASE_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_INCREASE_15_years desc
;

SELECT Year,
ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY YEAR
ORDER BY YEAR
;	

-- Finding correlation between Life_expectancy and GDP grouping by country
-- Looking the life_expectancy data and AVG_GDP we can conclude there is a correlation between them
SELECT country,
ROUND(AVG(`Life expectancy`),1) as Life_expectancy,
round(AVG(GDP),1) AS AVG_GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_expectancy <> 0
AND AVG_GDP <> 0
ORDER BY AVG_GDP DESC
;

-- We can classify life_expectancy from lower to higher based on GDP grouping by country
-- The countries with Higher GDP have a average of Life_expectaancy around 74.2, and the countries with lower GDP value under 1500 have average LE of 64.7
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),1) High_GDP_LIfe_expectancy,
SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) Low_GDP_count,
ROUND(AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` ELSE NULL END),1) Low_GDP_LIfe_expectancy
FROM world_life_expectancy
;

-- Studying correlation for Status "developing" and "Developed"
SELECT status,
ROUND(AVG(`Life expectancy`),1),
COUNT(DISTINCT country),
MIN(`Life expectancy`),
MAX(`Life expectancy`)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY status
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
;

SELECT country, status, MAX(`Life expectancy`), GDP
FROM world_life_expectancy
GROUP BY country, status, GDP
HAVING MAX(`Life expectancy`) = 89
;

SELECT country, status, GDP, year
FROM world_life_expectancy
WHERE country = 'france'
GROUP BY country, status, GDP, year
ORDER BY GDP
;

-- Looking correlation between BMI(body mass index) and Life_expectancy
SELECT country,
ROUND(AVG(`Life expectancy`),1) as Life_expectancy,
round(AVG(BMI),1) AS AVG_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_expectancy <> 0
AND AVG_BMI <> 0
ORDER BY AVG_BMI DESC
;

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY country ORDER BY Year) AS Roling_total
FROM world_life_expectancy
;