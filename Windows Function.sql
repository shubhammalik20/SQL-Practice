-- Write a query to add column - avg_sat_writing. Each row in this column should include average 
-- marks in the writing section of the student per school.

SELECT *, AVG(sat_writing)OVER(PARTITION BY school) AS avg_sat_writing
FROM Tutorial.sat_scores;

-- In the above question, add an additional column - count_per_school,max_per_teacher and min_per_teacher
--  Each row of this column should include number of students per school

SELECT *,
 AVG(sat_writing)OVER(PARTITION BY school) AS avg_sat_writing,
 COUNT(student_id)OVER(PARTITION BY school) AS count_per_school,
 MAX(sat_math)OVER(PARTITION BY teacher) AS max_per_teacher,
 MIN(sat_math)OVER(PARTITION BY teacher) AS min_per_teacher
FROM Tutorial.sat_scores;

-- For the dataset, write a query to add the two columns cum_hrs_studied and total_hrs_studied. Each row in cum_hrs_studied should display 
-- the cumulative sum of hours studied per school. Each row in the total_hrs_studied will display total hours studied per school. 
-- Order the data in the ascending order of student id.

SELECT *,
SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id) AS cum_hrs_studied,
SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_hrs_studied
FROM Tutorial.sat_scores;

-- For the dataset, write a query to add column sub_hrs_studied.Each row in sub_hrs_studied should display the sum of hrs_studied
-- for a row above, a row below, and current row per school. Order the data in the ascending order of student id

SELECT *,
 SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS sub_hrs_studied
FROM Tutorial.sat_scores;

-- Write a query to rank the students per school on the basis of scores in verbal. Use both rank and 
-- dense_rank function. Students with the highest marks should get rank 1.

SELECT *,
 RANK() OVER(PARTITION BY school ORDER BY sat_verbal DESC) AS score_verbal_rank,
 DENSE_RANK() OVER(PARTITION BY school ORDER BY sat_verbal DESC) AS score_verbal_dense_rank
FROM tutorial.sat_scores;

-- Write a query to find the top 5 students per teacher who spent maximum hours studying.

SELECT a.teacher, a.student_id
FROM (SELECT *,ROW_NUMBER()OVER(PARTITION BY teacher ORDER BY hrs_studied DESC ) AS ranknum
FROM tutorial.sat_scores) a
WHERE a.ranknum <6;

-- Write a query to find the worst 5 students per school who got minimum marks in sat_math

SELECT a.school, a.student_id
FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY school ORDER BY sat_math ) AS ranknum
FROM tutorial.sat_scores) a
WHERE a.ranknum <6;

-- Write a query to divide the dataset into quartile on the basis of marks in sat_verbal.

SELECT *, NTILE(4)OVER( ORDER BY sat_verbal ) AS quartile
FROM tutorial.sat_scores;

-- For ‘Petersville HS’ school, write a query to arrange the students in the ascending order of hours studied. 
-- Also, add a column to find the difference in hours studied from the student above(in the row).Exclude the cases where hrs_studied is null.

SELECT *, hrs_studied - LAG(hrs_studied)OVER(ORDER BY hrs_studied) AS diff_hrs
FROM tutorial.sat_scores
WHERE school ='Petersville HS' AND hrs_studied IS NOT NULL;

-- For ‘Washington HS’ school, write a query to arrange the students in the descending order of sat_math.
-- Also, add a column to find the difference in sat_math from the student below(in the row).

SELECT *, sat_math - LEAD(sat_math)OVER(ORDER BY sat_math DESC) AS diff_marks
FROM tutorial.sat_scores
WHERE school ='Washington HS';

Write a query to return 4 columns - student_id, school, sat_writing, difference in sat_writing & average marks scored in sat_writing.

SELECT student_id,school,sat_writing, sat_writing - AVG(sat_writing)OVER(PARTITION BY school) AS diff_avg
FROM tutorial.sat_scores;

-- Write a query to return the student_id and school who are in bottom 20 in each of sat_verbal, sat_writing, and sat_math for their school.

WITH data AS 
 (SELECT student_id,school,
 ROW_NUMBER()OVER(PARTITION BY school ORDER BY sat_verbal) AS rank_verbal,
 ROW_NUMBER()OVER(PARTITION BY school ORDER BY sat_math) AS rank_math,
 ROW_NUMBER()OVER(PARTITION BY school ORDER BY sat_writing) AS rank_writing
 FROM tutorial.sat_scores)
SELECT student_id, school
FROM data 
WHERE rank_verbal < 21 AND rank_writing < 21 AND rank_math < 21;

-- Write a query to find the student_id for the highest mark and lowest mark per teacher for sat_writing.

SELECT DISTINCT teacher,
FIRST_VALUE(student_id)OVER(PARTITION BY teacher ORDER BY sat_writing DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_marks_student,
LAST_VALUE(student_id)OVER(PARTITION BY teacher ORDER BY sat_writing DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS min_marks_student
FROM tutorial.sat_scores;
