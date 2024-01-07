--EX1
select NAME from CITY
where COUNTRYCODE='USA'
AND POPULATION>120000
--EX2
SELECT * FROM CITY
WHERE COUNTRYCODE='JPN'
--EX3
SELECT CITY, STATE FROM STATION
--EX4
SELECT CITY FROM STATION
/* WHERE CITY LIKE 'a%' 
or CITY LIKE 'e%' 
or CITY LIKE 'i%' 
or CITY LIKE 'O%'
or CITY LIKE 'u%'
*/
WHERE CITY REGEXP '^[aeiou]'
--EX5
SELECT DISTINCT CITY FROM STATION
/* WHERE CITY LIKE '%a' 
or CITY LIKE '%e' 
or CITY LIKE '%i' 
or CITY LIKE '%o'
or CITY LIKE '%u'
*/
WHERE CITY REGEXP '[aeuio]$'
--EX6
SELECT DISTINCT CITY FROM STATION
/*WHERE CITY NOT LIKE 'a%' 
and CITY NOT LIKE 'e%' 
and CITY NOT LIKE 'i%' 
and CITY NOT LIKE 'O%'
and CITY NOT LIKE 'u%'
*/
WHERE CITY NOT REGEXP '^[aeuio]'
--EX7
SELECT name FROM Employee
ORDER BY name
--EX8
SELECT name FROM Employee
WHERE salary >2000 AND months<10
ORDER BY employee_id
--EX9
SELECT product_id FROM Products
WHERE low_fats='Y' AND recyclable='Y'
--EX10
SELECT name from Customer
WHERE referee_id IS NULL OR referee_id!=2
--EX11
SELECT name, population, area FROM World
WHERE area>=3000000 OR population>=25000000
--EX12
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id=viewer_id
--EX13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
--EX14
select * from lyft_drivers
where yearly_salary<=30000 or yearly_salary>=70000
--EX15
select * from uber_advertising
where money_spent>100000 and year=2019

