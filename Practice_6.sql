--EX1
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM 
(SELECT company_id, title, description, 
COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description) AS a
WHERE job_count > 1;
--EX2
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
--EX6
