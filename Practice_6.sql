--EX1
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM 
(SELECT company_id, title, description, 
COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description) AS a
WHERE job_count > 1;
--EX2
WITH ApplianceSpend AS
(SELECT product, SUM(spend) AS total_appliance FROM product_spend
WHERE category='appliance' and EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product
ORDER BY total_appliance DESC
LIMIT 2),
ElectronicsSpend AS
(SELECT product, SUM(spend) AS total_electronics FROM product_spend
WHERE category='electronics' and EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product
ORDER BY total_electronics DESC
LIMIT 2)

SELECT 'appliance' AS category, product, total_appliance AS total_spend
FROM ApplianceSpend
UNION ALL
SELECT 'electronics' AS category, product, total_electronics AS total_spend
FROM ElectronicsSpend
--EX3
WITH call_records AS (
SELECT policy_holder_id, COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3 )

SELECT COUNT(policy_holder_id) AS member_count
FROM call_records;

--EX4
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE liked_date IS NULL
ORDER BY a.page_id ASC
--EX5
SELECT EXTRACT(MONTH FROM event_date) AS month,
COUNT(DISTINCT user_id) AS monthly_active_users
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 7
AND user_id IN 
(SELECT user_id
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 6
)
GROUP BY month
--EX6
SELECT
    EXTRACT(YEAR FROM trans_date) || '-' || EXTRACT(MONTH FROM trans_date) AS month,
    country,
    COUNT(id) AS trans_count,
    COUNT(CASE WHEN state = 'approved' THEN id END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount END) AS approved_total_amount
FROM Transactions
GROUP BY month, country
ORDER BY month, country DESC  
--EX7
SELECT product_id, year as first_year, quantity, price
FROM Sales
WHERE (product_id, year) in 
(
SELECT product_id, MIN(year)
FROM Sales
GROUP BY product_id
)
--EX8
SELECT customer_id FROM Customer 
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product)
--EX9
SELECT employee_id FROM Employees 
WHERE salary <30000 AND manager_id NOT IN (SELECT employee_id FROM Employees)
--EX10
SELECT employee_id, department_id FROM Employee
WHERE primary_flag = 'Y' OR employee_id in (
SELECT employee_id FROM Employee 
GROUP BY employee_id 
HAVING COUNT(department_id) = 1)
--EX11
(SELECT u.name  AS results FROM Users u
JOIN MovieRating mr 
ON u.user_id = mr.user_id
GROUP BY u.name
ORDER BY COUNT(mr.movie_id) DESC, u.name
LIMIT 1)
UNION
(SELECT m.title AS results FROM Movies m
JOIN MovieRating mr 
ON m.movie_id = mr.movie_id
WHERE EXTRACT(MONTH FROM mr.created_at) = 2 AND EXTRACT(YEAR FROM mr.created_at) = 2020
GROUP BY m.title
ORDER BY AVG(mr.rating) DESC, m.title
LIMIT 1)
--EX12
WITH A AS(
SELECT requester_id , accepter_id
FROM RequestAccepted
UNION ALL
SELECT accepter_id , requester_id
FROM RequestAccepted
)
SELECT requester_id AS id, count(accepter_id) AS num
FROM A
group by id
ORDER BY num DESC
LIMIT 1
