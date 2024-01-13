--EX1
SELECT
SUM(CASE
    WHEN device_type='laptop' THEN 1 ELSE 0 
END) AS laptop_views,
SUM(CASE
    WHEN device_type IN('phone','tablet') THEN 1 ELSE 0 
END) AS mobile_views
FROM viewership

--EX2
SELECT x, y, z,
CASE
    WHEN (x+y>z) AND (x+z>y) AND (y+z>x) THEN 'Yes' ELSE 'No'
END AS Triangle
FROM Triangle

--EX3
SELECT
ROUND(100.0 * COUNT(case_id)/SUM(CASE
    WHEN call_category IS NULL OR call_category='n/a' THEN 1 ELSE 0
END)) AS call_percentage
FROM callers

--EX4
SELECT name FROM Customer
WHERE referee_id IS NULL OR referee_id!=2

--EX5
select survived,
SUM(CASE
    when pclass=1 then 1 else 0
END) AS first_class,
SUM(CASE
    when pclass=2 then 1 else 0
END) AS second_classs,
SUM(CASE
    when pclass=3 then 1 else 0
END) AS third_class
from titanic
GROUP BY survived
