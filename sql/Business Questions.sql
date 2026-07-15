-- 1. total_sales
SELECT SUM(price) AS total_sales
FROM fact_sales;

-- 2. sales evolution over time
SELECT order_id, price, date
	FROM fact_sales
		JOIN dim_date ON fact_sales.date_id = dim_date.date_id; 

-- 3. categories with the highest revenue
SELECT category_name, SUM(price) AS ingresos
	FROM fact_sales
		JOIN dim_product 
			ON fact_sales.product_id = dim_product.product_id
		GROUP BY category_name
		ORDER BY ingresos DESC;

-- 4. States that buy the most
SELECT state, SUM(price) AS sales
	FROM fact_sales 
		JOIN dim_customer
		ON fact_sales.customer_id = dim_customer.customer_id
	GROUP BY state
	ORDER BY sales DESC;

-- 5. Top Sellers
SELECT seller_id, SUM(price) AS sales
	FROM fact_sales
	GROUP BY seller_id
	ORDER BY sales DESC;

-- 6. Most frequent customers
SELECT customer_id, COUNT(customer_id) AS ocurrencia
	FROM fact_sales
	GROUP BY customer_id
	ORDER BY ocurrencia DESC
	LIMIT 5;

-- 7. Most requested product categories
SELECT category_name, COUNT(fs.product_id) AS num_pedidos
	FROM fact_sales AS fs
	JOIN dim_product
		ON fs.product_id = dim_product.product_id
	GROUP BY category_name
	ORDER BY num_pedidos DESC;

-- 8.1 Categories with the most cancellations
SELECT COUNT(order_status) AS cont, category_name
	FROM fact_sales
		JOIN dim_product
		ON fact_sales.product_id = dim_product.product_id
	WHERE order_status = 'canceled'
	GROUP BY category_name
	ORDER BY cont DESC;

-- 8.2 Cancellation rate (%)
SELECT 
	COUNT(DISTINCT CASE
		WHEN order_status = 'canceled' THEN order_id
	END) AS canceled_orders,
	COUNT(DISTINCT order_id) AS total_orders,
	ROUND(
		100.0 * COUNT(DISTINCT CASE
			WHEN order_status = 'canceled' THEN order_id
			END)/COUNT(DISTINCT order_id), 2)
			AS canceled_orders_perc
	
	FROM fact_sales;
