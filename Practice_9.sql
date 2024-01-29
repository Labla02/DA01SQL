select * from public.sales_dataset_rfm_prj

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
