DROP MATERIALIZED VIEW order_counts; 


-- CREATING MATERIALIZED VIEW FOR ORDER COUNTS AND CUSTOMER BINS
CREATE MATERIALIZED VIEW order_counts AS

SELECT
	c.customer_state 
	,c.customer_unique_id
	,DATE_PART('year',o.order_purchase_timestamp) AS purch_year
	,CONCAT(DATE_PART('year',o.order_purchase_timestamp),' Q',DATE_PART('quarter',o.order_purchase_timestamp)) AS purch_quarter
	,TO_CHAR(o.order_purchase_timestamp, 'Month') AS purch_month
	,CASE  
		WHEN oi.price BETWEEN 0 AND 50 THEN 'Bin 0-50'
		WHEN oi.price BETWEEN 51 AND 100 THEN 'Bin 51-100'
		WHEN oi.price BETWEEN 101 AND 150 THEN 'Bin 101-150'
		WHEN oi.price BETWEEN 151 AND 200 THEN 'Bin 151-200'
		WHEN oi.price BETWEEN 201 AND 250 THEN 'Bin 201-250'
		WHEN oi.price BETWEEN 251 AND 300 THEN 'Bin 251-300'
		WHEN oi.price > 300 THEN 'Bin More Than 301'
		END AS Customer_Bin
	,COUNT(DISTINCT o.order_id) AS orders_count
FROM customers c
	JOIN orders o 
	USING ("customer_id")
	JOIN order_items oi 
	ON o.order_id = oi.order_id  
WHERE o.order_status = 'delivered'
GROUP BY
	c.customer_state
	,c.customer_unique_id
	,purch_year
	,purch_quarter
	,purch_month
	,customer_bin
ORDER BY orders_count DESC ;


-- ORDER COUNTS SELECTION FROM MATERIALIZED VIEW
SELECT 
	oc.purch_year
	,oc.purch_quarter
	,oc.purch_month 
	,oc.customer_state
	,oc.customer_bin
	,oc.orders_count AS frequency
	,COUNT(DISTINCT oc.customer_unique_id) AS customer_count
FROM order_counts oc
GROUP BY 
	oc.customer_state
	,oc.customer_bin
	,frequency
	,oc.purch_year 
	,oc.purch_quarter
	,oc.purch_month 
ORDER BY oc.purch_quarter;

-- AD HOC CHECKS:
-- YEARLY COUNT
SELECT
	purch_year
	,COUNT(DISTINCT customer_unique_id) AS yearly_cust_count
FROM order_counts 
GROUP BY purch_year; 

-- MONTHLY COUNT
-- MONTHLY COUNT
SELECT
	purch_year
	,purch_month 
	,COUNT(DISTINCT customer_unique_id) AS monthly_cust_count
FROM order_counts 
GROUP BY 
	purch_year
	,purch_month; 


SELECT
	COUNT(DISTINCT customer_unique_id) AS cust_count
FROM customers;
