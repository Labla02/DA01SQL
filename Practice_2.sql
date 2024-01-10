--EX1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2 =0

--EX2
SELECT COUNT(*)-COUNT(DISTINCT CITY) FROM STATION

--EX3
SELECT CEILING(AVG(Salary)-AVG(REPLACE(Salary,'0','')))
FROM EMPLOYEES 
--EX4
SELECT ROUND((SUM(item_count*order_occurrences)::DECIMAL / SUM(order_occurrences)),1) AS mean 
FROM items_per_order;
--SELECT ROUND(CAST(SUM(item_count*order_occurrences)/ SUM(order_occurrences) AS DECIMAL),1) AS mean 
FROM items_per_order;

--EX5
SELECT candidate_id	FROM candidates
WHERE skill IN('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) =3

--EX6
SELECT user_id, MAX(post_date)::DATE-MIN(post_date)::DATE AS days_between 
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(user_id)>1

--EX7
SELECT card_name, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount) - MIN(issued_amount) DESC
--EX8
SELECT manufacturer, COUNT(drug) AS drug_count, ABS(SUM(total_sales-cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales-cogs<0
GROUP BY manufacturer
ORDER BY total_loss DESC

--EX9
SELECT * FROM Cinema
WHERE id%2=1 AND NOT description='boring'
ORDER BY rating DESC

--EX10
SELECT teacher_id, count (distinct subject_id) as cnt FROM Teacher
group by teacher_id

--EX11
SELECT user_id, COUNT(follower_id) AS followers_count FROM Followers
GROUP BY user_id 
ORDER BY user_id ASC

--EX12
SELECT class FROM Courses
GROUP BY class
HAVING COUNT(student) >=5
