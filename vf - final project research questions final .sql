/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS 
** File:  final project research questions 
** Author: Zoey
************************************************/

USE FP

-- overall data 200139
SELECT 
    COUNT(a.crime_case)
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id;


-- break it into month
SELECT 
    EXTRACT(MONTH FROM a.crime_datetime) AS month,
    COUNT(a.crime_case)
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
GROUP BY EXTRACT(MONTH FROM a.crime_datetime)
ORDER BY COUNT(a.crime_case) DESC;
    

--  overall crimes in community
SELECT 
    COUNT(a.crime_case),
    b.community_name,
    (COUNT(a.crime_case) / 200139) AS numbers_of_crime_percentage
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY b.community_name
ORDER BY COUNT(a.crime_case) DESC;

-- classify the community and percentile
WITH s AS (
	SELECT 
		b.community_name,
		COUNT(*) as num_crimes
	FROM
		crime a
			JOIN
		Community_area b ON a.community_area_id = b.community_area_id
	GROUP BY b.community_area_id
),
p AS (
	SELECT
		community_name,
		PERCENT_RANK() OVER (ORDER BY num_crimes) as percentile -- calculate percentile of community by number of crimes
	FROM s
)
SELECT s.community_name, s.num_crimes, p.percentile, 
(CASE WHEN p.percentile < 0.25 THEN "LOW CRIME" WHEN p.percentile < 0.5 THEN "MID-LOW CRIME" WHEN p.percentile < 0.75 THEN "MID-HIGH CRIME"
	ELSE "HIGH CRIME" END) AS crime_classification
FROM 
	s JOIN p ON s.community_name = p.community_name
ORDER BY p.percentile DESC;

-- overall crimes in district
SELECT 
    COUNT(a.crime_case),
    c.distrct_name,
    (COUNT(a.crime_case) / 200139) AS numbers_of_crime_percentage
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY c.distrct_name
ORDER BY COUNT(a.crime_case) DESC;


-- overall crimes in district & add percentile
WITH s AS (
	SELECT 
		c.distrct_name as district_name,
		COUNT(*) as num_crimes
	FROM
		crime a
			JOIN
		Community_area b ON a.community_area_id = b.community_area_id
			JOIN
		district c ON a.district_id = c.district_num
	GROUP BY district_name
),
p AS (
	SELECT
		district_name,
		PERCENT_RANK() OVER (ORDER BY num_crimes) as percentile -- calculate percentile of community by number of crimes
	FROM s
)
SELECT s.district_name, s.num_crimes, p.percentile, 
(CASE WHEN p.percentile < 0.25 THEN "LOW CRIME" WHEN p.percentile < 0.5 THEN "MID-LOW CRIME" WHEN p.percentile < 0.75 THEN "MID-HIGH CRIME"
	ELSE "HIGH CRIME" END) AS crime_classification
FROM 
	s JOIN p ON s.district_name = p.district_name
ORDER BY p.percentile DESC;

-- more frequent crimes
SELECT 
    COUNT(a.crime_case),
    e.IUCR_id,
    e.primary_description,
    (COUNT(a.crime_case) / 200139) AS crime_type_percentage
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY e.primary_description
ORDER BY COUNT(a.crime_case) DESC;

-- q3 popilation affect crime?

Select
	count(a.crime_case), b.community_name, b.community_population, count(a.crime_case)/ b.community_population
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
		JOIN
	FBI_code d on a.FBI_code = d.FBI_code
		JOIN
	IUCR e on a.IUCR_id = e.IUCR_id
		JOIN
	Ward f on a.ward_id = f.ward_id
    
where a.crime_datetime >= '2021-01-01 00:00:00' AND a.crime_datetime <= '2021-12-31 23:59:59'
group by  b.community_name
order by  b.community_population 

-- q4 what types of crimes happened most in location?
SELECT 
    a.location_description, count(*) AS numbers_of_crime, count(a.crime_case)/200139 as crime_rate
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY a.location_description
ORDER BY COUNT(a.crime_case) DESC;

-- q4 which crime types happened most in "restaurant"
SELECT count(e.primary_description), e.primary_description
FROM
  crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
		JOIN
	FBI_code d on a.FBI_code = d.FBI_code
		JOIN
	IUCR e on a.IUCR_id = e.IUCR_id
    
WHERE a.location_description = 'RESTAURANT' AND a.crime_datetime >= '2021-01-01 00:00:00' AND a.crime_datetime <= '2021-12-31 23:59:59'

group by e.primary_description 
order by count(e.primary_description) desc;

-- q5 which days in week have most crimes
SELECT 
    COUNT(a.crime_id) AS crimes_per_day,
    DAYNAME(a.crime_datetime) AS Day_Name1
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
GROUP BY Day_Name1
ORDER BY Day_Name1;


-- q6 which day in a year have most crimes committed
SELECT 
    COUNT(a.crime_id) AS crimes_per_day,
    DATE(a.crime_datetime) AS day
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
GROUP BY DATE(a.crime_datetime)
ORDER BY crimes_per_day DESC;
    
-- q7 which time in a day have most crimes
SELECT 
    COUNT(a.crime_id) AS crimes_per_time,
    TIME(a.crime_datetime) AS time
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
GROUP BY TIME(a.crime_datetime)
ORDER BY crimes_per_time DESC;



-- q9 arrest rate overall in 2021

SELECT 
    COUNT(a.arrest = 'TRUE' OR NULL) AS arrest_num,
    COUNT(a.arrest = 'TRUE' OR NULL) / COUNT(*) AS arrest_rate,
    COUNT(*) - COUNT(a.arrest = 'TRUE' OR NULL) AS non_arrest_num,
    (COUNT(*) - COUNT(a.arrest = 'TRUE' OR NULL)) / COUNT(*) AS non_arrest_rate
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
ORDER BY COUNT(a.arrest) DESC;


-- q10 arrest rate in each community

SELECT 
    b.community_name,
    COUNT(a.arrest = 'TRUE' OR NULL) / COUNT(*) as arrest_rate_in_community
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY b.community_name
ORDER BY COUNT(a.arrest) DESC;

-- arrest_rate in each community
SELECT 
    b.community_name,
    COUNT(a.arrest = 'TRUE' OR NULL) / COUNT(*) as arrest_rate_in_community
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY b.community_name
ORDER BY COUNT(a.arrest) DESC;

-- higher population equal to higher crime? -- no 
SELECT 
    b.community_name,
    b.community_population,
    COUNT(*),
    b.community_population / COUNT(*) AS per_count_of_population
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY b.community_name
ORDER BY b.community_population DESC;

-- higher density equal to higher crimes? --- no 
SELECT 
    b.community_name,
    b.community_density_sqmi,
    COUNT(*),
    b.community_density_sqmi / COUNT(*) AS per_count_of_population
FROM
    crime a
        JOIN
    Community_area b ON a.community_area_id = b.community_area_id
        JOIN
    district c ON a.district_id = c.district_num
        JOIN
    FBI_code d ON a.FBI_code = d.FBI_code
        JOIN
    IUCR e ON a.IUCR_id = e.IUCR_id
        JOIN
    Ward f ON a.ward_id = f.ward_id
WHERE
    a.crime_datetime >= '2021-01-01 00:00:00'
        AND a.crime_datetime <= '2021-12-31 23:59:59'
GROUP BY b.community_density_sqmi
ORDER BY b.community_density_sqmi DESC;


-- check out all columns in crime
SHOW COLUMNS FROM crime
SHOW COLUMNS FROM district
SHOW COLUMNS FROM FBI_code
SHOW COLUMNS FROM IUCR
SHOW COLUMNS FROM Ward
SHOW COLUMNS FROM Community_area

-- count
SELECT 
    COUNT(*)
FROM
    crime
LIMIT 10;

-- select all
SELECT 
    *
FROM
    crime
LIMIT 10;

