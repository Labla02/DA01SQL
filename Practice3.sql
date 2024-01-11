--EX1
SELECT Name FROM STUDENTS
WHERE Marks>75
ORDER BY RIGHT(Name,3), ID

--EX2
SELECT user_id, UPPER(LEFT(name,1))||LOWER(SUBSTRING(name from 2 for (length(name)-1))) AS name
FROM Users
/*SELECT user_id, UPPER(LEFT(name,1))||LOWER(RIGHT(name,(length(name)-1))) AS name
FROM Users*/

--EX3
SELECT manufacturer,
CONCAT('$',ROUND((SUM(total_sales)/1000000)), ' million') AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY (SUM(total_sales)/1000000) DESC, manufacturer

--EX4
SELECT EXTRACT('month' from submit_date) AS mth, 
product_id, 
ROUND(AVG(stars),2) as avg_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id

--EX5
SELECT sender_id, COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT('month' from sent_date)=8 AND EXTRACT('YEAR' from sent_date)=2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

--EX6
SELECT tweet_id 
FROM Tweets
WHERE LENGTH(content)>15

--EX7 Bài này em không hiểu yêu cầu đề bài, cũng không thấy video chữa bài ạ
  
--EX8
select count(id) 
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date)=2022
group by extract(month from joining_date),
extract(year from joining_date)

--EX9
select position('a' in first_name) 
from worker
where first_name='Amitah'

--EX10
select substring(title, length(winery)+2, 4) 
from winemag_p2
where country= 'Macedonia'
