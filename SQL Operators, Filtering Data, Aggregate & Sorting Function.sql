-- Write a query to display all the records in the table tutorial.oscar_nominees
SELECT * FROM tutorial.oscar_nominees;

-- Write a query to find the distinct values in the ‘year’ column
SELECT DISTINCT year FROM tutorial.oscar_nominees;

-- Write a query to filter the records from year 1999 to year 2006
SELECT * FROM tutorial.oscar_nominees WHERE year BETWEEN 1999 AND 2006;

-- Write a query to filter the records for either year 1991 or 1998.
SELECT * FROM tutorial.oscar_nominees WHERE year= 1991 or year =1998;

-- Write a query to return the winner movie name for the year of 1997.
SELECT movie FROM tutorial.oscar_nominees WHERE year= 1997 AND winner = True;

-- Write a query to return the winner in the ‘actor in a leading role’ and ‘actress in a leading role’ 
-- category for the year of 1994,1980, and 2008. 

SELECT nominee,year,category,winner
FROM tutorial.oscar_nominees 
WHERE category IN ('actor in a leading role','actress in a leading role') AND year IN (1980,1994,2008) AND winner = True;

-- Write a query to return the name of the movie starting from letter ‘a’?

SELECT movie
FROM tutorial.oscar_nominees 
WHERE lower(movie) LIKE ('a%');

 -- Write a query to return the name of movies containing the word ‘the’.
 
SELECT movie
FROM tutorial.oscar_nominees 
WHERE lower(movie) LIKE ('%the%');

-- Write a query to return all the records where the nominee name starts with “c” and ends with “r”.

SELECT *
FROM tutorial.oscar_nominees 
WHERE lower(nominee) LIKE ('c%') AND lower(nominee) LIKE ('%r');

-- Write a query to return all the records where the movie was released in 2005 and movie name does 
-- not start with ‘a’ and ‘c’ and nominee was a winner

SELECT *
FROM tutorial.oscar_nominees 
WHERE (lower(movie) NOT LIKE ('a%') AND lower(movie) NOT LIKE ('c%')) AND year = 2005 AND winner = True;

-- Write a query to count the total number of records in the tutorial.kag_conversion_data dataset.
SELECT COUNT(*) AS total_records
FROM tutorial.kag_conversion_data;

-- Write a query to find the maximum spent, average interest, minimum impressions for ad_id.
SELECT 
 MAX(spent) AS max_spent,
 AVG(interest) AS avg_interest,
 MIN(impressions) AS min_impression
FROM Tutorial.kag_conversion_data
GROUP by ad_id;

 -- Write a query to create an additional column spent per impressions(spent/impressions)
SELECT *,spent/impressions AS spent_per_impression
FROM Tutorial.kag_conversion_data;

-- Write a query to count the ad_campaign for each age group.

SELECT age,COUNT(ad_id) AS num_campaign
FROM tutorial.kag_conversion_data
GROUP BY Age;

-- Write a query to calculate the average spent on ads for each gender category.
SELECT gender,AVG(spent) AS avg_spent
FROM tutorial.kag_conversion_data
GROUP BY Gender;

-- Write a query to find the total approved conversion per xyz campaign id. Arrange the total conversion in descending order.

SELECT xyz_campaign_id,SUM(approved_conversion) AS total_approved_conversion 
FROM tutorial.kag_conversion_data
GROUP BY xyz_campaign_id
ORDER BY total_approved_conversion DESC;
 
-- Write a query to show the fb_campaign_id and total interest per fb_campaign_id.Only show the campaign which has more than 300 interests.

SELECT fb_campaign_id,SUM(interest) AS total_interest
FROM tutorial.kag_conversion_data
GROUP BY fb_campaign_id
HAVING SUM(interest) > 300
ORDER BY total_interest DESC;

-- Write a query to find the age and gender segment with maximum impression to interest ratio. 
-- Return three columns - age, gender, impression_to_interest.

SELECT age,gender,SUM(impressions)/SUM(interest) AS impresssion_to_interest
FROM tutorial.kag_conversion_data
GROUP BY age, gender
ORDER BY impresssion_to_interest DESC
LIMIT 1;

-- Write a query to find the top 2 xyz_campaign_id and gender segment with the maximum 
-- total_unapproved_conversion (total_conversion - approved_conversion).

SELECT xyz_campaign_id,gender,SUM(total_conversion - approved_conversion) AS total_unapproved_conversion
FROM tutorial.kag_conversion_data
GROUP BY xyz_campaign_id,gender
ORDER BY total_unapproved_conversion DESC
LIMIT 2;
