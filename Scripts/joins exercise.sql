-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name ‘Joins’ (not the apostrophes). Click Save.

-- 3. Left click the server ‘Joins’. Left click Schemas. 


-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

select s.film_title as name, s.release_year, r.worldwide_gross 
from specs s
left join revenue r on s.movie_id=r.movie_id
order by r.worldwide_gross limit 1

--Answer: Semi-Tough, release year 1977, $37,187,139

 

-- 2. What year has the highest average imdb rating?

select s.release_year, sum(r.imdb_rating) as HighestAVGImdbRating
from specs s
inner join rating r on s.movie_id=r.movie_id
group by s.release_year
order by 2 desc limit 1

--Answer: 1977 imdb ratig 74.5


-- 3. What is the highest grossing G-rated movie? Which company distributed it?

select s.film_title as name, d.company_name, r.worldwide_gross
from specs s
inner join revenue r on s.movie_id=r.movie_id
inner join distributors d on s.domestic_distributor_id=d.distributor_id
where s.mpaa_rating='G'
order by 3 desc Limit 1

--Answer:  Toy Story 4 & Walt Disney



-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

select d.company_name, count(s.movie_id) as Movies_associated
from distributors d
left join specs s on s.domestic_distributor_id=d.distributor_id
group by company_name


"company_name"	"movies_associated"
"Universal Pictures"	58
"Columbia Pictures"	15
"American International Pictures"	1
"Miramax"	1
"TriStar Pictures"	9
"DreamWorks"	17
"Orion Pictures"	6
"Paramount Pictures"	51
"Icon Productions"	1
"Sony Pictures"	31
"IFC Films"	1
"Summit Entertainment"	3
"The H Collective"	1
"Fox Searchlight Pictures"	1
"New Line Cinema"	8
"Metro-Goldwyn-Mayer"	13
"Twentieth Century Fox"	49
"Walt Disney "	76
"Warner Bros."	71
"Lionsgate"	5
"Legendary Entertainment"	0
"Vestron Pictures"	1
"Relativity Media"	0

-- 5. Write a query that returns the five distributors with the highest average movie budget.

select d.company_name, AVG(r.film_budget) as AVG_Movie_Budget
from distributors d
inner join specs s on s.domestic_distributor_id=d.distributor_id
inner join revenue r on s.movie_id=r.movie_id
group by company_name 
order by 2 desc Limit 5

"company_name"	"avg_movie_budget"
"Walt Disney "	148735526.32
"Sony Pictures"	139129032.26
"Lionsgate"	122600000.00
"DreamWorks"	121352941.18
"Warner Bros."	103430985.92

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?


SELECT COUNT(film_title) total,film_title,imdb_rating,company_name
FROM specs AS s
LEFT JOIN distributors as d
ON s.domestic_distributor_id=d.distributor_id
LEFT JOIN rating as r
ON s.movie_id= r.movie_id
WHERE headquarters NOT LIKE '%CA'
GROUP BY imdb_rating, company_name, film_title
ORDER BY total DESC;

--Answer: 2
--Answer: Dirty Dancing

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT length_in_min,
AVG(imdb_rating) AS avg_rating
FROM specs AS s
LEFT JOIN rating AS r
ON s.movie_id=r.movie_id
WHERE length_in_min >=120 OR length_in_min<120
GROUP BY length_in_min
ORDER BY length_in_min DESC, avg_rating DESC;

--Answer:  movies over 2 hours long