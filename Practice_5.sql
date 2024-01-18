--EX1
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population)) FROM CITY
INNER JOIN COUNTRY
ON CITY.CountryCode=COUNTRY.Code
GROUP BY COUNTRY.Continent

--EX2
SELECT
ROUND(SUM(CASE
    WHEN texts.signup_action='Confirmed' THEN 1 ELSE 0
END)/COUNT(DISTINCT emails.email_id)::DECIMAL,2) AS confirm_rate
FROM emails
LEFT JOIN texts
ON emails.email_id=texts.email_id

--EX3
SELECT age_bucket,
ROUND(100.0*SUM(CASE
    WHEN a.activity_type='send' THEN  time_spent ELSE 0
END)/SUM(CASE
    WHEN a.activity_type IN ('open', 'send') THEN  time_spent ELSE 0
END),2) AS send_perc,
ROUND(100.0*SUM(CASE
    WHEN a.activity_type='open' THEN  time_spent ELSE 0
END)/SUM(CASE
    WHEN a.activity_type IN ('open', 'send') THEN  time_spent ELSE 0
END),2) AS open_perc
FROM activities AS a
INNER JOIN age_breakdown AS b
ON a.user_id=b.user_id
GROUP BY b.age_bucket

--EX4
SELECT a.customer_id
FROM customer_contracts a
JOIN products AS b 
ON a.product_id = b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)

--EX5
SELECT e.employee_id, e.name, COUNT(r.employee_id) AS reports_count,
ROUND(AVG(r.age)) as average_age 
FROM Employees AS e
JOIN Employees as r
ON e.employee_id = r.reports_to
WHERE r.reports_to IS NOT NULL
GROUP BY e.employee_id, e.name

--EX6
SELECT a.product_name, SUM(b.unit) AS unit
FROM Products AS a
LEFT JOIN Orders AS b
ON a.product_id=b.product_id
WHERE EXTRACT(month FROM b.order_date)=02
GROUP BY a.product_name
HAVING SUM(b.unit)>=100

--EX7
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE liked_date IS NULL
ORDER BY a.page_id ASC

--Mid course test
--Q1
SELECT DISTINCT MIN(replacement_cost) FROM public.film

--Q2
SELECT 
SUM(CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0
END) AS low,
SUM(CASE
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 ELSE 0
END) AS medium,
SUM(CASE
	WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 ELSE 0
END) AS high
FROM public.film

--Q3
SELECT a.title, a.length, c.name
FROM public.film AS a
LEFT JOIN public.film_category AS b
ON a.film_id=b.film_id
LEFT JOIN public.category AS c
ON b.category_id=c.category_id
WHERE c.name='Drama' OR c.name='Sports'
ORDER BY a.length DESC
LIMIT 1

--Q4
SELECT c.name, COUNT(a.title) AS so_luong
FROM public.film AS a
LEFT JOIN public.film_category AS b
ON a.film_id=b.film_id
LEFT JOIN public.category AS c
ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY so_luong DESC
LIMIT 1

--Q5
SELECT COUNT(a.film_id), b.first_name, b.last_name
FROM public.film_actor AS a
LEFT JOIN public.actor as b
ON a.actor_id=b.actor_id
GROUP BY b.first_name, b.last_name
ORDER BY COUNT(a.film_id) DESC
LIMIT 1

--Q6
SELECT 
SUM(CASE
	WHEN b.address_id IS NULL THEN 1 ELSE 0
END)
FROM public.address as a
LEFT JOIN public.customer as b
ON a.address_id=b.address_id

--Q7
SELECT b.city, SUM(d.amount) AS doanh_thu
FROM public.address AS a
LEFT JOIN city as b
ON a.city_id=b.city_id
LEFT JOIN public.customer as c
ON a.address_id=c.address_id
LEFT JOIN public.payment AS d
ON c.customer_id=d.customer_id
GROUP BY b.city
HAVING SUM(d.amount) IS NOT NULL
ORDER BY doanh_thu DESC
LIMIT 1

--Q8
SELECT (b.city || ', ' || e.country) AS city, SUM(d.amount) AS doanh_thu
FROM public.address AS a
LEFT JOIN city as b
ON a.city_id=b.city_id
LEFT JOIN public.customer as c
ON a.address_id=c.address_id
LEFT JOIN public.payment AS d
ON c.customer_id=d.customer_id
LEFT JOIN public.country AS e
ON b.country_id=e.country_id
GROUP BY b.city, e.country
HAVING SUM(d.amount) IS NOT NULL
ORDER BY doanh_thu
LIMIT 1
