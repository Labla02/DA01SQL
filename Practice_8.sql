--EX1
WITH FirstOrders AS (
SELECT 
    customer_id,
    MIN(order_date) AS first_order_date,
    customer_pref_delivery_date
FROM Delivery
GROUP BY customer_id, customer_pref_delivery_date
),
ImmediateOrders AS (
SELECT COUNT(*) AS immediate_order_count
FROM FirstOrders
WHERE first_order_date = customer_pref_delivery_date
),
TotalFirstOrders AS (
SELECT COUNT(*) AS total_first_order_count
FROM FirstOrders
)

SELECT 
ROUND((immediate_order_count * 100.0) / total_first_order_count, 2) AS immediate_percentage
FROM ImmediateOrders, TotalFirstOrders

--EX3
SELECT id,
CASE 
    WHEN id % 2 = 0 THEN COALESCE(LAG(student) OVER (ORDER BY id), student)
    ELSE COALESCE(LEAD(student) OVER (ORDER BY id), student)
    END AS student
FROM Seat
--EX4
WITH A AS(
SELECT visited_on, SUM(amount) amount
FROM Customer
GROUP BY visited_on)

SELECT visited_on,
SUM(amount) OVER (ORDER BY visited_on ROWS 6 PRECEDING) amount,
ROUND(AVG(amount) OVER (ORDER BY visited_on ROWS 6 PRECEDING),2) average_amount
FROM A
ORDER BY visited_on
Limit 100 OFFSET 6
--EX5
WITH A as
(SELECT pid, TIV_2015, TIV_2016, 
COUNT(CONCAT(lat, lon)) OVER (PARTITION BY CONCAT(lat, lon)) as c1, 
COUNT(TIV_2015) OVER (PARTITION BY tiv_2015) as c2
FROM insurance)

select sum(TIV_2016) as TIV_2016 
FROM A 
WHERE c1=1 AND c2!=1
--EX6
WITH A AS
(
SELECT D.name as Department, E.name as Employee, E.salary as Salary, 
DENSE_RANK() OVER(PARTITION BY E.departmentId order by E.salary desc) as rank
FROM Employee E
LEFT JOIN Department D
ON E.departmentId=D.id
)
SELECT Department, Employee, Salary FROM A
WHERE rank<4
