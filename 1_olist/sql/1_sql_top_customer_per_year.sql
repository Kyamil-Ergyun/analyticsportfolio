SELECT *
FROM customers c 
	JOIN orders o 
		USING ("customer_id")
	JOIN order_items oi 
		USING ("order_id")
WHERE o.order_status = 'delivered'
LIMIT 10;


ALTER TABLE orders ADD delivery_year VARCHAR(50);

ALTER TABLE orders DROP COLUMN delivery_year;

ALTER TABLE olist.public.orders ALTER COLUMN delivery_year VARCHAR(50);


UPDATE orders SET delivery_year = LEFT(order_delivered_carrier_date, 4);

ALTER TABLE olist.public.orders ALTER COLUMN delivery_year AS INTEGER;

ALTER TABLE orders ALTER COLUMN delivery_year YEAR;
ALTER TABLE orders 
ALTER COLUMN delivery_year TYPE integer USING delivery_year::integer;


SELECT 
	c.customer_id
	,c.customer_city
	,c.customer_state
	,o.delivery_year 
	,SUM(oi.price) AS total_spending
FROM customers c 
	JOIN orders o 
		USING ("customer_id")
	JOIN order_items oi 
		USING ("order_id")
	
WHERE 
	o.order_status = 'delivered'
--	AND o.delivery_year = '2017'
GROUP BY
	c.customer_id
	,o.delivery_year 
ORDER BY 
	total_spending DESC;
--LIMIT 10;


SELECT 
	c.customer_state	
	,c.customer_city
	,o.delivery_year 
	,SUM(oi.price) AS total_spending
FROM customers c 
	JOIN orders o 
		USING ("customer_id")
	JOIN order_items oi 
		USING ("order_id")
WHERE 
	o.order_status = 'delivered'
--	AND o.delivery_year = '2017'
GROUP BY
	c.customer_state
	,c.customer_city 
	,o.delivery_year 
ORDER BY 
	total_spending DESC;