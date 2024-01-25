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
