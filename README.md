# Netflix Movies and TV Shows Data Analysis using SQL


![Netflix Logo](https://github.com/muhammed-saheer/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.


## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)


## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Problems and Solutions


### 1. Count the Number of Movies vs TV Shows

```sql
SELECT TYPE,
 count (*) as total_content
from netflix
group by type;
```

`
-- 2. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select *
from netflix
where  type = 'Movie'
and release_year = 2020;
```


-- 3. Find the Top 5 Countries with the Most Content on Netflix

```sql
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
```


-- 4. Identify the Longest Movie

```sql
select * from netflix 
	where type = 'Movie'
		and 
  duration= (select max (duration)from netflix)
```


-- 5. Find Content Added in the Last 5 Years

```sql
select * from netflix
	where TO_DATE(date_added,  'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

```


-- 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix
	where director ilike '%Rajiv Chilaka%'
```


-- 7. List All TV Shows with More Than 5 Seasons

```sql
select * from NETFLIX 
WHERE TYPE = 'TV Show'
	and split_part(duration, ' ', 1)::numeric > 5
```

-- 8. Count the Number of Content Items in Each Genre


```sql
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(*)as totel_content

from netflix
group by 1;
```


-- 9. Find each year and the average numbers of content release in India on netflix.(return top 5 year with highest avg content release!)

```sql
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
```


-- 10. List All Movies that are Documentaries

```sql
select * from netflix
where listed_in Ilike '%Documentaries%'
```



-- 11. Find All Content Without a Director

```sql
SELECT * from netflix
where director is null;
```


-- 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years


```sql
SELECT * FROM netflix 	
	WHERE casts ILIKE '%Salman Khan%'
		AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```



-- 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India



```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,','))AS ACTORS,
	COUNT(*) AS TOTAL_CONTENT
	FROM netflix

	where country ilike '%india%'
	group by 1
	order by 2 desc
	limit 10
```



-- 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords



```sql
  SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END  category
    FROM netflix
```


