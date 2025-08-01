![Amazon](data/amazon_cover.jpg)

## Project Overview

This project involves advanced querying including customer behavior, product performance, and sales trends, revenue analysis, customer segmentation, and inventory management, addressing real-world business challenges.

**Resource**: [`01_database_init.sql`](01_database_init.sql), [`02_business_queries.sql`](02_business_queries.sql)





## Database Setup

Created tables for `products`, `categories`, `customers`, `sellers`, `orders`, `orders_items`, `payments`, `shipping` and `inventory`.

![AmazonERD](00_database_erd.jpg)


```sql

CREATE TABLE products
	(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(50),
	price FLOAT,
	cogs FLOAT,
	category_id INT,
	CONSTRAINT product_fk_category 
	FOREIGN KEY (category_id)
	REFERENCES categories(category_id)
	);

CREATE TABLE orders
	(
	order_id INT PRIMARY KEY,
	order_date DATE,
	customer_id INT,
	seller_id INT,
	order_status VARCHAR(15),
	CONSTRAINT order_fk_customer_id
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	CONSTRAINT order_fk_seller_id
	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
	);

[...]

```

## Business Problems

**1. Top Selling Products**

Query the top 10 products by total sales value.
Challenge: Include product id, product name, total quantity sold, and total sales value.

```sql
SELECT 
	products.product_id,
	products.product_name,
	SUM(orders_items.quantity) AS total_quantity,
	COUNT(orders.order_id) AS total_orders,
	SUM(orders_items.total_price) AS total_price
FROM
	orders
JOIN orders_items
	ON orders_items.order_id = orders.order_id
JOIN products
	ON products.product_id = orders_items.product_id
GROUP BY 1,2
ORDER BY 5 DESC
;

```
---
**2. Revenue by Category**

Calculate total revenue generated by each product category.
Challenge: Include the percentage contribution of each category to total revenue.

```sql
SELECT 
	categories.category_name,
	ROUND(SUM(orders_items.total_price)::numeric,0) as total_sales,
	ROUND((SUM(orders_items.total_price) /
	(SELECT SUM(total_price) FROM orders_items))::numeric,2) as  percentage
FROM orders
JOIN orders_items
	ON orders.order_id = orders_items.order_id
JOIN products
	ON orders_items.product_id = products.product_id
JOIN categories
	ON products.category_id = categories.category_id
GROUP BY 1
ORDER BY 2 DESC;
```
---

**3. Average Order Value (AOV)**

Compute the average order value for each customer.
Challenge: Include only customers with more than 5 orders.

```sql
SELECT 
	customers.customer_id,
	CONCAT(customers.first_name, ' ',customers.last_name) as full_name,
	COUNT(orders.order_id) as cnt_orders,
	ROUND(SUM(total_price)::numeric,0) as total_sales,
	SUM(total_price)/ COUNT(orders.order_id) as avg_orders
FROM orders
JOIN orders_items
	ON orders.order_id = orders_items.order_id
JOIN customers
	ON orders.customer_id = customers.customer_id
GROUP BY 1,2
HAVING COUNT(orders.order_id) > 5
ORDER BY 5
;
```
---
**4. Monthly Sales Trend:**

Query monthly total sales over the past year.
Challenge: Display the sales trend, grouping by month, return current_month sale, last month sale!

```sql
SELECT
	year,
	month,
	total_sales,
	LAG(total_sales,1) OVER(ORDER BY year,month) 
FROM
(
SELECT 
	EXTRACT(YEAR FROM order_date) as year,
	EXTRACT(MONTH FROM order_date) as month,
	ROUND(SUM(total_price::numeric),0) AS total_sales
FROM orders
JOIN orders_items
	ON orders.order_id = orders_items.order_id
GROUP BY 1,2
ORDER BY 1,2
)as c1;
```
---

**5. Customers with No Purchases**

Find customers who have registered but never placed an order.
Challenge: List customer details and the time since their registration.

```sql
SELECT *
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT(customer_id) FROM orders);
```
---

**6. Least-Selling Categories by State**

Identify the least-selling product category for each state.
Challenge: Include the total sales for that category within each state.

```sql
WITH ranking_table
AS
(SELECT
	customers.state,
	categories.category_name,
	SUM(orders_items.total_price) AS total_sales,
	RANK() OVER(PARTITION BY customers.state ORDER BY SUM(orders_items.total_price) ASC) AS rank
FROM orders
JOIN orders_items
	ON orders.order_id = orders_items.order_id
JOIN products
	ON orders_items.product_id = products.product_id
JOIN categories
	ON products.category_id = categories.category_id
JOIN customers
	ON orders.customer_id = customers.customer_id
GROUP BY 1,2
ORDER BY 1) 

SELECT * FROM ranking_table 
WHERE rank = 1 ;
```
---

**7. Customer Lifetime Value (CLTV)**

Calculate the total value of orders placed by each customer over their lifetime.
Challenge: Rank customers based on their CLTV.

```sql
SELECT 
	customers.customer_id,
	CONCAT(customers.first_name, ' ',customers.last_name),
	ROUND(SUM(total_price)::numeric,0) AS  total_sales,
	DENSE_RANK()OVER(ORDER BY SUM(total_price) DESC ) AS ranking
FROM orders
JOIN orders_items
	ON orders.order_id = orders_items.order_id
JOIN customers
	ON orders.customer_id = customers.customer_id
GROUP BY 1,2
ORDER BY 3 DESC;
```
---

**8. Inventory Stock Alerts**
   
Query products with stock levels below a certain threshold (e.g., less than 5 units).
Challenge: Include last restock date and warehouse information.

```sql
SELECT
	p.product_id AS product_id,
	p.product_name AS product_name,
	i.inventory_id AS inventory_id,
	i.stock AS stock,
	i.warehouse_id AS warehouse_id,
	i.last_stock_date AS last_stock_date
FROM products AS p
JOIN inventory AS i
ON i.product_id = p.product_id
WHERE i.stock < 10;
```
---

**9. Shipping Delays**

Identify orders where the shipping date is later than 3 days after the order date.
Challenge: Include customer, order details, and delivery provider.

```sql
SELECT
	orders.order_id,
	orders.order_date,
	shippings.shipping_id,
	shippings.shipping_date,
	shippings.shipping_date - orders.order_date AS diff,
	CONCAT(customers.first_name,' ',customers.last_name) AS full_name,
	sellers.seller_name AS provider
FROM shippings
JOIN orders
	ON shippings.order_id  = orders.order_id
JOIN customers
	ON orders.customer_id = customers.customer_id
JOIN sellers
	ON orders.seller_id = sellers.seller_id
WHERE shippings.shipping_date - orders.order_date > 4;

```
---

**10. Payment Success Rate**

Calculate the percentage of successful payments across all orders.
Challenge: Include breakdowns by payment status (e.g., failed, pending).

```sql
SELECT 
	payment_status,
	COUNT(payment_id) AS cnt,
	ROUND((COUNT(payment_id)::numeric / (SELECT COUNT(payment_id) FROM payments)::numeric)*100,0) AS percent
FROM payments
GROUP BY 1;

```
---

**11. Top Performing Sellers**

Find the top 5 sellers based on total sales value.
Challenge: Include both successful and failed orders, and display their percentage of successful orders.

```sql
WITH 
c1 AS (
		SELECT
			sellers.seller_id,
			sellers.seller_name,
			ROUND(SUM(orders_items.total_price)::numeric,0) AS total_sales
		FROM orders
		JOIN orders_items
			ON orders.order_id = orders_items.order_id
		JOIN sellers 
			ON orders.seller_id = sellers.seller_id
		GROUP BY 1,2
		ORDER BY 3 DESC
),
total_payments AS (

		SELECT
			sellers.seller_id,
			sellers.seller_name,
			COUNT(payments.payment_id) AS payments_cnt
		FROM orders
		JOIN payments
			ON orders.order_id = payments.order_id
		JOIN sellers
			ON orders.seller_id = sellers.seller_id
		GROUP BY 1,2
		ORDER BY 1
	),
	
success_payments AS (

		SELECT
			sellers.seller_id,
			sellers.seller_name,
			COUNT(payments.payment_id) AS successed_cnt
		FROM orders
		JOIN payments
			ON orders.order_id = payments.order_id
		JOIN sellers
			ON orders.seller_id = sellers.seller_id
		WHERE payment_status = 'Payment Successed'
		GROUP BY 1,2
		ORDER BY 1
		
	) 
	
SELECT 
	c1.seller_id,
	c1.seller_name,
	c1.total_sales,
	success_payments.successed_cnt,
	total_payments.payments_cnt,
	ROUND((success_payments.successed_cnt::numeric / total_payments.payments_cnt::numeric )*100,0) AS percentage
FROM c1
JOIN total_payments
	ON c1.seller_id = total_payments.seller_id
JOIN success_payments
	ON c1.seller_id = success_payments.seller_id
ORDER BY 3 DESC;


```

---

**12. Product Profit Margin**

Calculate the profit margin for each product (difference between price and cost of goods sold).
Challenge: Rank products by their profit margin, showing highest to lowest.

```sql
WITH
profits 
AS (
	SELECT
		product_id,
		product_name,
		price,
		((price - cogs)/price) AS margin,
		ROUND((price - cogs)::numeric,0) AS profit
	FROM products
	ORDER BY profit DESC
	)
SELECT
	profits.product_id,
	profits.product_name,
	SUM(orders_items.quantity * profits.profit) AS total_profit,
	SUM(orders_items.total_price) AS total_sale,
	profits.margin,
	RANK() OVER(ORDER BY SUM(orders_items.quantity * profits.profit)DESC)
FROM orders
JOIN orders_items
	ON orders.order_id = orders_items.order_id
JOIN profits
	ON orders_items.product_id = profits.product_id
GROUP BY 1,2,5
ORDER BY 3 DESC;

```

---


**13. Most Returned Products**

Query the top 10 products by the number of returns.
Challenge: Display the return rate as a percentage of total units sold for each product.

```sql
SELECT
	products.product_id,
	products.product_name,
	SUM(CASE WHEN orders.order_status = 'Returned' THEN orders_items.quantity ELSE 0 END) AS return_quantity,
	SUM(CASE WHEN orders.order_status = 'Completed' THEN orders_items.quantity ELSE 0 END) AS completed_quantity,
	SUM(orders_items.quantity) as total_quantity,
	ROUND(SUM(CASE WHEN orders.order_status = 'Returned' THEN orders_items.quantity ELSE 0 END)::numeric
	/NULLIF(SUM(orders_items.quantity),0)::numeric * 100,0) AS percent_returned
FROM orders_items
JOIN products
	ON orders_items.product_id = products.product_id
JOIN orders
	ON orders_items.order_id = orders.order_id
GROUP BY 1,2
ORDER BY 3 DESC 
LIMIT 10;

```
---

**14. Orders Pending Delivery**

Find orders that have been paid but are still pending Delivery .
Challenge: Include order details, payment date, and customer information.

```sql
SELECT
	orders.order_id,
	orders.order_date,
	payments.payment_date,
	CONCAT(customers.first_name,' ',customers.last_name) AS full_name,
	payments.payment_status,
	shippings.delivery_status
FROM orders
JOIN shippings
	ON orders.order_id = shippings.order_id
JOIN payments
	ON orders.order_id = payments.order_id
JOIN customers
	ON orders.customer_id = customers.customer_id
WHERE 
	payments.payment_status = 'Payment Successed' AND
	shippings.delivery_status <> 'Delivered' ;

```
---

**15. Inactive Sellers**

Identify sellers who haven’t made any sales in the last 6 months.
Challenge: Show the last sale date and total sales from those sellers.

```sql
WITH sellers_sales
AS (
	SELECT
		seller_id,
		MAX(order_date) AS max_date,
		COUNT(order_id) AS cnt_orders
	FROM orders
	GROUP BY 1
)

SELECT 
	sellers_sales.seller_id,
	sellers.seller_name,
	sellers_sales.max_date,
	sellers_sales.cnt_orders
	
FROM sellerS
LEFT JOIN sellers_sales
	ON sellers.seller_id = sellers_sales.seller_id
WHERE max_date < CURRENT_DATE - INTERVAL '1 YEARS'

```

---

**16. Categorized customers**
If the customer has done more than 5 return categorize them as returning otherwise new
Challenge: List customers id, name, total orders, total returns and total_sales

```sql

WITH sales AS (
	SELECT
		orders.customer_id,
		SUM(orders_items.quantity * orders_items.price_per_unit) AS total_sales
	FROM orders
	JOIN orders_items
		ON orders.order_id = orders_items.order_id
	GROUP BY 1
), details as (

SELECT
	*,
	CASE WHEN total_returned > 10 THEN 'Returned' ELSE 'New' END AS cat
FROM (
		SELECT 
			customers.customer_id,
			CONCAT(customers.first_name,' ', customers.last_name) AS full_name,
			COUNT(DISTINCT orders.order_id) AS total_orders,
			SUM(CASE WHEN orders.order_status = 'Returned' THEN 1 ELSE 0 END) AS total_returned
		FROM orders
		JOIN customers
			ON orders.customer_id = customers.customer_id
		GROUP BY 1,2
	)
)

SELECT
	*
FROM details
JOIN sales
	ON details.customer_id = sales.customer_id;


```
---

**17. Top 5 Customers by Orders in Each State**

Identify the top 5 customers with the highest number of orders for each state.
Challenge: Include the number of orders and total sales for each customer.

```sql
WITH rankings
AS(
SELECT
	customers.state,
	orders.customer_id,
	CONCAT(customers.first_name,' ',customers.last_name) AS full_name,
	COUNT(orders.order_id) AS cnt_orders,
	DENSE_RANK() OVER(PARTITION BY customers.state ORDER BY COUNT(orders.order_id) DESC ) AS ranking
FROM orders
JOIN customers
	ON orders.customer_id = customers.customer_id
GROUP BY 1,2,3
ORDER BY 1,4 DESC
)
SELECT * 
FROM rankings
WHERE ranking <6;

```
---

**18. Revenue by Shipping Provider**

Calculate the total revenue handled by each shipping provider.
Challenge: Include the total number of orders handled and the average delivery time for each provider.

```sql
WITH details AS (
	SELECT
		shippings.shipping_providers,
		AVG(shippings.shipping_date - orders.order_date) AS days_spent,
		COUNT(DISTINCT orders.order_id) AS total_orders
	FROM shippings
	JOIN orders
		ON orders.order_id = shippings.order_id
	GROUP BY 1

), revenue AS(

	SELECT
		shippings.shipping_providers,
		ROUND(SUM(orders_items.total_price::numeric),0) AS total_sales
	FROM shippings
	JOIN orders
		ON orders.order_id = shippings.order_id
	JOIN orders_items
		ON orders.order_id = orders_items.order_id
	GROUP BY 1

)
SELECT 
	*
FROM details
JOIN revenue
	ON details.shipping_providers  = revenue.shipping_providers

```
---

**19. Top 10 product with highest decreasing revenue ratio compare to last year(2022) and current_year(2023)**

Challenge: Return product_id, product_name, category_name, 2022 revenue and 2023 revenue decrease ratio at end Round the result

```sql
SELECT
	products.product_id,
	products.product_name,
	ROUND(SUM(oi.quantity * oi.price_per_unit)::numeric,0) AS total_revenue,
	ROUND((SUM(CASE WHEN EXTRACT(YEAR FROM orders.order_date) = 2022 THEN oi.quantity * oi.price_per_unit ELSE '0' END))::numeric,0) AS y_2022,
	ROUND((SUM(CASE WHEN EXTRACT(YEAR FROM orders.order_date) = 2023 THEN oi.quantity * oi.price_per_unit ELSE '0' END))::numeric,0) AS y_2023,
	ROUND(SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2023 THEN oi.quantity * oi.price_per_unit ELSE 0 END)
			-
			SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2022 THEN oi.quantity * oi.price_per_unit ELSE 0 END)
		)
		/
		NULLIF(SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2022 THEN oi.quantity * oi.price_per_unit ELSE 0 END), 0)
		* 100,0) AS ratio_24
FROM orders_items AS oi
JOIN products
	ON oi.product_id = products.product_id
JOIN orders
	ON oi.product_id = orders.order_id
GROUP BY 1,2
ORDER BY 6 DESC
ORDER BY 6 DESC;

```


## Procedure Creation 🛒

Function that automatically reduces the quantity from the inventory table as soon as a product is sold. When a sale is recorded , it should update the stock in the inventory table based on the product ID and the quantity purchased.

```sql
CREATE OR REPLACE PROCEDURE
update_inventory(
	p_order_id INT,
	p_customer_id INT,
	p_seller_id INT,
	p_order_item_id INT,
	p_product_id INT,
	p_quantity INT,
	p_price_per_unit
)
LANGUAGE plpgsql as 
$$
	DECLARE
		v_count INT;
		v_price FLOAT;
		v_name VARCHAR(45);
	
	BEGIN
	--CHECK STOCK
		SELECT COUNT(*) 
		INTO v_count
		FROM inventory
		WHERE
			product_id = p_product_id AND
			quantity >= p_quantity

		SELECT price,product_name INTO v_price, v_name FROM productS
		WHERE product_id = p_product_id
		
		IF v_count > 0 THEN
		
			--add sale
			INSERT INTO orders (order_id, order_date, customer_id,seller_id)
			VALUES (p_order_id, CURRENT_DATE,p_customer_id,p_seller_id);
			
			INSERT INTO orders_items(order_item_id,order_id, product_id, quantity,price_per_unit)
			VALUES (p_order_item_id,p_order_id,p_product_id,p_quantity,v_price);
		
			--update inventory
			UPDATE inventory
			SET stock = stock - p_quantity
			WHERE product_id = p_product_id;

			RAISE NOTICE'% WAS SUCCESSFULL',v_name;

		ELSE
			RAISE NOTICE'THANK YOU FOR YOU INFO, THE % IS NOT AVAILABLE',v_name;

	END
$$

```

## Conclusions

- When working with an inventory database, it's more efficient to update existing records—using a one-record-per-product model—rather than creating new records for each update and filtering by the most recent date. This approach keeps the database cleaner, reduces redundancy, and improves query performance.

- The product price is retrieved from the products table but is also stored in the order_items table at the time of purchase. This ensures that even if the product price later changes in the products table, each order retains the original price used during the transaction, preserving historical accuracy.

