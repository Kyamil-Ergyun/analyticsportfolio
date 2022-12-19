-- MAKING SOME TABLE ADJSUTMENTS

ALTER TABLE orders
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP
USING order_purchase_timestamp::TIMESTAMP;

ALTER TABLE order_items 
ALTER COLUMN shipping_limit_date TYPE TIMESTAMP
USING shipping_limit_date::TIMESTAMP;

ALTER TABLE reviews  
ALTER COLUMN review_answer_timestamp TYPE TIMESTAMP
USING review_answer_timestamp::TIMESTAMP;


-- RFM ANALYSIS CACULATIONS
-- RECENCY

SELECT 
	c.customer_unique_id
	,CAST(EXTRACT(YEAR FROM o.order_purchase_timestamp) AS INTEGER) AS purch_year
	,CONCAT (CAST(EXTRACT(YEAR FROM o.order_purchase_timestamp) AS INTEGER), ' Q',DATE_PART('quarter',o.order_purchase_timestamp)) AS quarter
	,MAX(o.order_purchase_timestamp) AS last_purch_date
	,(date('2018-10-18') - date(MAX(o.order_purchase_timestamp))) AS recency
FROM customers c 
	JOIN orders o 
	USING("customer_id")
GROUP BY 
	c.customer_unique_id
	,EXTRACT(YEAR FROM o.order_purchase_timestamp)
	,DATE_PART('quarter',o.order_purchase_timestamp)
ORDER BY recency ASC;

-- RFM ANALYSIS CACULATIONS
-- FREQUENCY

SELECT 
	c.customer_unique_id
	,c.customer_state 
	,DATE_PART('year', o.order_purchase_timestamp) AS year
	,COUNT(o.order_purchase_timestamp) AS frequency
FROM customers c 
	JOIN orders o 
	USING("customer_id")
GROUP BY 
	c.customer_unique_id
	,c.customer_state 
	,DATE_PART('year', o.order_purchase_timestamp)
ORDER BY 
	year ASC
	,frequency DESC;


SELECT DISTINCT *
FROM order_items
ORDER BY order_item_id DESC;

SELECT 
	c.customer_unique_id
	,COUNT(DISTINCT c.customer_unique_id) AS num_interact
FROM orders o 
	JOIN customers c 
	USING("customer_id")
GROUP BY c.customer_unique_id
ORDER BY num_interact DESC;
