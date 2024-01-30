select * from public.sales_dataset_rfm_prj

--task 1
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE timestamp USING TO_TIMESTAMP(orderdate, 'MM/DD/YYYY HH24:MI');

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING TRIM(ordernumber)::numeric,
ALTER COLUMN quantityordered TYPE numeric USING TRIM(ordernumber)::numeric,
ALTER COLUMN orderlinenumber TYPE numeric USING TRIM(ordernumber)::numeric,
ALTER COLUMN sales TYPE numeric USING TRIM(ordernumber)::numeric,
ALTER COLUMN msrp TYPE numeric USING TRIM(ordernumber)::numeric,
ALTER COLUMN phone TYPE numeric USING TRIM(ordernumber)::numeric,
ALTER COLUMN postalcode TYPE numeric USING TRIM(ordernumber)::numeric

--task 2
SELECT *
FROM public.sales_dataset_rfm_prj
WHERE 
  ORDERNUMBER IS NULL OR TRIM(ORDERNUMBER) = '' OR
  QUANTITYORDERED IS NULL OR QUANTITYORDERED = '' OR
  PRICEEACH IS NULL OR PRICEEACH = '' OR
  ORDERLINENUMBER IS NULL OR ORDERLINENUMBER = '' OR
  SALES IS NULL OR SALES = '' OR
  ORDERDATE IS NULL OR ORDERDATE = '';

--task 3
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN CONTACTFIRSTNAME varchar(50),
ADD COLUMN CONTACTLASTNAME varchar(50)

UPDATE public.sales_dataset_rfm_prj AS a
SET 
    contactlastname = b.contactlastname,
    contactfirstname = b.contactfirstname
FROM 
(SELECT contactfullname,
LEFT(contactfullname, POSITION('-' IN contactfullname) - 1) AS contactfirstname,
RIGHT(contactfullname, LENGTH(contactfullname) - POSITION('-' IN contactfullname)) AS contactlastname
FROM public.sales_dataset_rfm_prj) AS b
WHERE a.contactfullname = b.contactfullname;

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID varchar(50),
ADD COLUMN MONTH_ID varchar(50),
ADD COLUMN YEAR_ID varchar(50)

--task 4
UPDATE public.sales_dataset_rfm_prj AS a
SET 
    QTR_ID = b.QTR_ID,
    MONTH_ID = b.MONTH_ID,
	YEAR_ID = b.YEAR_ID
FROM 
(SELECT orderdate,
EXTRACT(QUARTER FROM orderdate) AS QTR_ID,
EXTRACT(MONTH FROM orderdate) AS MONTH_ID,
EXTRACT(YEAR FROM orderdate) AS YEAR_ID
FROM public.sales_dataset_rfm_prj) AS b
WHERE a.orderdate = b.orderdate;

--task 5
--c1: box plot
WITH twt_minmax AS (
SELECT q1-1.5*iqr as min_value, q3+1.5*iqr as max_value
FROM (
SELECT 
percentile_cont(0.25) WITHIN GROUP(ORDER BY quantityordered) AS q1,
percentile_cont(0.75) WITHIN GROUP(ORDER BY quantityordered) AS q3,
percentile_cont(0.75) WITHIN GROUP(ORDER BY quantityordered)-percentile_cont(0.25) WITHIN GROUP(ORDER BY QUANTITYORDERED) as IQR
FROM public.sales_dataset_rfm_prj) AS a)

SELECT quantityordered FROM public.sales_dataset_rfm_prj
WHERE quantityordered <(select min_value from twt_minmax)
OR quantityordered >(select max_value from twt_minmax)

--c2: z-score
WITH cte AS (
SELECT quantityordered,
(SELECT AVG(quantityordered) AS avg FROM public.sales_dataset_rfm_prj),
(SELECT stddev(quantityordered) as stddev FROM public.sales_dataset_rfm_prj)
FROM public.sales_dataset_rfm_prj)

SELECT quantityordered, ((quantityordered-avg)/stddev) as z_score
FROM cte
WHERE ABS((quantityordered-avg)/stddev) > 2
--Xử lý outlier
UPDATE public.sales_dataset_rfm_prj
SET quantityordered= (SELECT AVG(quantityordered) FROM public.sales_dataset_rfm_prj)
WHERE quantityordered IN (SELECT quantityordered FROM twt_outlier);

DELETE FROM public.sales_dataset_rfm_prj
WHERE quantityordered IN (SELECT quantityordered FROM twt_outlier); 
