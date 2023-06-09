-- Write a query to return the name of nominees who got more nominations than ‘Akim Tamiroff’. Solve this using CTE.

WITH nominees AS 
(SELECT nominee,COUNT(*) AS nomination_count
 FROM tutorial.oscar_nominees
 GROUP BY nominee)
SELECT nominee
FROM nominees
WHERE nomination_count > (SELECT COUNT(*) FROM tutorial.oscar_nominees 
						  WHERE nominee IN ('Akim Tamiroff'));

-- Write a query to find the nominee name with the second highest number of oscar wins. Solve using subquery

WITH wins AS
 (SELECT nominee,COUNT(*) AS num_wins
 FROM tutorial.oscar_nominees
 WHERE winner = true
 GROUP BY nominee
 ORDER BY num_wins DESC)
SELECT nominee,num_wins
FROM wins
WHERE num_wins = (SELECT MAX(num_wins) FROM wins WHERE num_wins < (SELECT MAX(num_wins) FROM wins));

-- Write a query to create three columns per nominee
-- 1. Number of wins
-- 2. Number of loss
-- 3. Total nomination

SELECT nominee,
       SUM(CASE WHEN winner = true THEN 1 ELSE 0 END) AS num_wins,
       SUM(CASE WHEN winner = false THEN 1 ELSE 0 END) AS num_loss,
	   COUNT(*) AS total_nomination
FROM tutorial.oscar_nominees
GROUP BY nominee
ORDER BY total_nomination DESC;

-- Write a query to create two columns
-- ● Win_rate: Number of wins/total 
-- ● Loss_rate: Number of loss/total 

SELECT movie,
 100.0 * SUM(CASE WHEN winner = true THEN 1 ELSE 0 END)/COUNT(*) AS win_rate,
 100.0 * SUM(CASE WHEN winner = false THEN 1 ELSE 0 END)/COUNT(*) AS loss_rate
FROM tutorial.oscar_nominees
GROUP BY Movie;

-- Write a query to return all the records of the nominees who have lost but won at least once.

SELECT * 
FROM tutorial.oscar_nominees
WHERE nominee IN (SELECT DISTINCT nominee FROM tutorial.oscar_nominees WHERE winner = true) AND winner = false;

-- Write a query to find the nominees who are nominated for both 'actor in a leading role' and 'actor in supporting role'

SELECT DISTINCT nominee 
FROM tutorial.oscar_nominees
WHERE nominee IN (SELECT DISTINCT nominee FROM tutorial.oscar_nominees WHERE category IN ('actor in a supporting role'))
 AND category IN ('actor in a leading role');
 
-- Write a query to find the movie which won more than average number of wins per winning movie.

WITH movie_wins AS
(SELECT movie,COUNT(*) AS num_wins
FROM  tutorial.oscar_nominees
WHERE winner = true
GROUP BY movie)
SELECT movie
FROM movie_wins
WHERE num_wins > (SELECT AVG(num_wins) FROM movie_wins);

-- Write a query to return the year which have more winners than year 1970

WITH year_wins AS
(SELECT year,COUNT(*) AS num_wins
FROM  tutorial.oscar_nominees
WHERE winner = true
GROUP BY year)
SELECT year
FROM year_wins
WHERE num_wins > (SELECT num_wins FROM year_wins WHERE year = 1970);

-- Write a query to return all the movies which have won oscars both in the actor and actress category.

SELECT DISTINCT movie 
FROM tutorial.oscar_nominees
WHERE winner = true AND lower(category) LIKE ('%actor%')
 AND movie IN (SELECT DISTINCT movie FROM tutorial.oscar_nominees WHERE winner = true AND lower(category) LIKE ('%actress%'));

-- Write a query to return the movie name which did not win a single oscar.

SELECT DISTINCT movie 
FROM tutorial.oscar_nominees
WHERE winner = false AND movie NOT IN (SELECT DISTINCT movie FROM tutorial.oscar_nominees WHERE winner = true);

     