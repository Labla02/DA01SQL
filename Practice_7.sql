--EX1
SELECT EXTRACT(year FROM transaction_date) AS year, product_id,
spend AS curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id, 
EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend,
ROUND(100 * 
    (spend - LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id, 
EXTRACT(YEAR FROM transaction_date)))/ LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id, 
EXTRACT(YEAR FROM transaction_date)), 2) AS yoy_rate 
FROM user_transactions
/*
WITH yearly_spend_cte AS (
SELECT EXTRACT(year FROM transaction_date) AS year, product_id,
spend AS curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id, 
EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend
FROM user_transactions)

SELECT year, product_id, curr_year_spend, prev_year_spend, 
  ROUND(100 * (curr_year_spend - prev_year_spend)/ prev_year_spend, 2) AS yoy_rate 
FROM yearly_spend_cte
*/
--EX2
SELECT DISTINCT card_name,
FIRST_VALUE(issued_amount) 
OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC
--EX3
WITH rank_3 as
(SELECT *, 
RANK() OVER(PARTITION BY user_id	ORDER BY transaction_date)
FROM transactions)

SELECT user_id, spend, transaction_date FROM rank_3
WHERE rank=3
--EX4
WITH A AS
(SELECT transaction_date, user_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC)
FROM user_transactions)

SELECT transaction_date, user_id, count(*) as purchase_count
FROM A
WHERE rank=1
GROUP BY transaction_date, user_id
ORDER BY transaction_date
--EX5
WITH A AS
(SELECT *,
LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) AS lag_1,
LAG(tweet_count, 2) OVER(PARTITION BY user_id ORDER BY tweet_date) AS lag_2
FROM tweets)

SELECT user_id, tweet_date,
CASE 
  WHEN lag_1 IS NULL AND lag_2 IS NULL THEN ROUND(tweet_count, 2)
  WHEN lag_1 IS NOT NULL AND lag_2 IS NULL THEN ROUND((tweet_count + lag_1) / 2.0, 2)
  ELSE ROUND((tweet_count + lag_1 + lag_2) / 3.0, 2)
  END AS rolling_avg_3d
FROM A
--EX6
WITH A AS
(SELECT merchant_id, credit_card_id, amount, transaction_timestamp,
LAG(transaction_timestamp) 
OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) 
AS prev_transaction
FROM transactions)

SELECT COUNT(merchant_id) as payment_count 
FROM A
WHERE EXTRACT(MINUTE FROM transaction_timestamp)-EXTRACT(MINUTE FROM prev_transaction)
<= 10
AND EXTRACT(HOUR FROM transaction_timestamp)-EXTRACT(HOUR FROM prev_transaction)
= 0
--EX7
WITH A AS
(SELECT category, product,
SUM(spend)  AS total_spend,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

SELECT category, product, total_spend
FROM A
WHERE ranking <= 2 
ORDER BY category, ranking

--EX8
WITH top_10_cte AS (
SELECT a.artist_name,
DENSE_RANK() OVER (ORDER BY COUNT(b.song_id) DESC) AS artist_rank
FROM artists a
INNER JOIN songs b ON a.artist_id = b.artist_id
INNER JOIN global_song_rank c ON b.song_id = c.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name
)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5
