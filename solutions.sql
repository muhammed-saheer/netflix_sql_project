CREATE TABLE NETFLIX (
	SHOW_ID VARCHAR(5),
	TYPE VARCHAR(10),
	TITLE VARCHAR(250),
	DIRECTOR VARCHAR(550),
	CASTS VARCHAR(1050),
	COUNTRY VARCHAR(550),
	DATE_ADDED VARCHAR(55),
	RELEASE_YEAR INT,
	RATING VARCHAR(15),
	DURATION VARCHAR(15),
	LISTED_IN VARCHAR(250),
	DESCRIPTION VARCHAR(550)
);

SELECT
	*
FROM
	NETFLIX;

SELECT
	COUNT(*) AS TOTEL_CONTENT
FROM
	NETFLIX;

SELECT DISTINCT
	TYPE
FROM
	NETFLIX;

-- Problems and Solutions


-- 1. Count the Number of Movies vs TV Shows

SELECT TYPE,
 count (*) as total_content
from netflix
group by type;


-- 2. List All Movies Released in a Specific Year (e.g., 2020)

select *
from netflix
where  type = 'Movie'
and release_year = 2020;


-- 3. Find the Top 5 Countries with the Most Content on Netflix

 SELECT 
 country, count(show_id) as totel_content
 from netflix
 group by 1

 select
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
	group by 1

	order by 2 desc
	limit 5


-- 4. Identify the Longest Movie

select * from netflix 
	where type = 'Movie'
		and 
  duration= (select max (duration)from netflix)



-- 5. Find Content Added in the Last 5 Years


select * from netflix
	where TO_DATE(date_added,  'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'




-- 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
	where director ilike '%Rajiv Chilaka%'


-- 7. List All TV Shows with More Than 5 Seasons

select * from NETFLIX 
WHERE TYPE = 'TV Show'
	and split_part(duration, ' ', 1)::numeric > 5


-- 8. Count the Number of Content Items in Each Genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(*)as totel_content

from netflix
group by 1;



-- 9. Find each year and the average numbers of content release in India on netflix.(return top 5 year with highest avg content release!)

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


-- 10. List All Movies that are Documentaries

select * from netflix
where listed_in Ilike '%Documentaries%'



-- 11. Find All Content Without a Director

SELECT * from netflix
where director is null;


-- 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * FROM netflix 	
	WHERE casts ILIKE '%Salman Khan%'
		AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;




-- 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


SELECT 
	UNNEST(STRING_TO_ARRAY(casts,','))AS ACTORS,
	COUNT(*) AS TOTAL_CONTENT
	FROM netflix

	where country ilike '%india%'
	group by 1
	order by 2 desc
	limit 10




-- 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords




  SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END  category
    FROM netflix
