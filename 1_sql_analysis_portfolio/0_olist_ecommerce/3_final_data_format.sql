SELECT
	o.order_id
	,o.customer_id
	,c.customer_unique_id
	,c.customer_state
	,c.customer_city
	,c.customer_zip_code_prefix
	,o.order_purchase_timestamp
	,t.product_category_name_english
	,oi.price
	,r.review_score
FROM orders o 
	JOIN customers c 
	USING ("customer_id")
	JOIN order_items oi 
	USING("order_id")
	JOIN products p 
	ON p.product_id = oi.product_id 
	JOIN translations t 
	ON t.product_category_name = p.product_category_name 
	JOIN reviews r 
	USING("order_id")
WHERE
	o.order_status = 'delivered';


-- RETRIVING UNIQUE ZIP CODES AND GEOLOCATION 
SELECT
	geolocation_zip_code_prefix
	,AVG(geolocation_lat) AS avg_latit
	,AVG(geolocation_lng) AS avg_longit
FROM geolocation
GROUP BY 
	geolocation_zip_code_prefix
ORDER BY
	geolocation_zip_code_prefix DESC
	,geolocation_zip_code_prefix DESC;
	