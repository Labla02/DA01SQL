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
