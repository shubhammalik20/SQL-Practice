-- Write a query to return player_name, school_name, position, conference from the above dataset.

SELECT players.player_name,players.school_name,players.position,teams.conference
FROM benn.college_football_players players 
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name;

-- Write a query to find the total number of players playing in each conference.Order the output in the descending order of number of players.

SELECT teams.conference,COUNT(players.player_name) AS num_players
FROM benn.college_football_players players 
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name
GROUP BY teams.conference
ORDER BY num_players DESC;

-- Write a query to find the average height of players per division

SELECT teams.division,AVG(players.height) AS avg_height
FROM benn.college_football_players players 
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name
GROUP BY Teams.division;

-- Write a query to return to the conference where average weight is more than 210. Order the output in descending order of average weight.

SELECT teams.conference,AVG(players.weight) AS avg_weight
FROM benn.college_football_players players 
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name
GROUP BY teams.conference
HAVING AVG(players.weight) > 210
ORDER BY avg_weight DESC;

-- Find the product which does not sell a single unit.
 
SELECT a.*,b.time
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
WHERE b.time IS NULL;

-- Write a query to find how many units are sold per product. Sort the data in terms of unit sold(descending order)

SELECT a.product_id,a.product_name,COUNT(b.time) AS units_sold
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
GROUP BY a.product_id,a.product_name
ORDER BY units_sold DESC;

-- Write a query to return product_type and units_sold where product_type is sold more than 50 times.

SELECT a.product_type,COUNT(b.time) AS units_sold
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
GROUP BY a.product_type
HAVING COUNT(b.time) > 50;

-- Write a query to return the total revenue generated.

SELECT SUM(price_unit) AS total_revenue
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
WHERE b.time IS NOT NULL;

-- Write a query to return the most selling product under product_type = ‘dry goods’
 
SELECT product_name,COUNT(b.time) AS unit_sold
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
WHERE product_type = 'dry_goods'
GROUP BY product_name
ORDER BY unit_sold DESC
LIMIT 1;

-- Write a query to find the difference between inventory and total sales per product_type?

SELECT product_type,SUM(current_inventory) - COUNT(b.time) AS delta
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
GROUP BY product_type
ORDER BY delta DESC;

 -- Find the product-wise sales for product_type =’dairy’

SELECT a.product_name,SUM(a.price_unit)*COUNT(b.time) AS sales
FROM tutorial.excel_sql_inventory_data a
LEFT JOIN tutorial.excel_sql_transaction_data b
ON a.product_id = b.product_id
WHERE product_type = 'dairy'
GROUP BY product_name
ORDER BY sales DESC;