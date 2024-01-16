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
SELECT e.employee_id, e.name, COUNT(r.employee_id) AS reports_count,
ROUND(AVG(r.age)) as average_age 
FROM Employees AS e
JOIN Employees as r
ON e.employee_id = r.reports_to
WHERE r.reports_to IS NOT NULL
GROUP BY e.employee_id, e.name

