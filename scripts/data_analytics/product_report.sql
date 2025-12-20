/*
=========================================================================
Product Report
=========================================================================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
=========================================================================
*/

CREATE VIEW gold.report_products AS
WITH base_query AS (
/*------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
------------------------------------------------------------------------*/
	SELECT
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_number,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
)
, product_aggregations AS (
/*------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
------------------------------------------------------------------------*/
	SELECT
		product_key,
		product_number,
		product_name,
		cost,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity_sold,
		COUNT(DISTINCT customer_key) AS total_customers,
		MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY product_key, product_number, product_name, cost
)
/*------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
------------------------------------------------------------------------*/
SELECT
	product_key,
	product_number,
	product_name,
	cost,
	CASE
		WHEN total_sales < 10000 THEN 'Low-Performers'
		WHEN total_sales <= 50000 THEN 'Mid-Range'
		ELSE 'High-Performers'
	END performance_segment,
	total_orders,
	total_sales,
	total_quantity_sold,
	total_customers,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE ROUND(CAST(total_sales AS FLOAT) / total_orders, 0)
	END AS avg_order_revenue,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE ROUND(CAST(total_sales AS FLOAT) / lifespan, 0)
	END AS avg_monthly_spend
FROM product_aggregations;
GO