
--Amazon Project - Advanced SQL
--Set Up Schema
CREATE TABLE categories
	(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(30)
	);

CREATE TABLE customers
	(
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	state VARCHAR(20),
	zip_code VARCHAR(5) DEFAULT('XXXXXX')
	);

CREATE TABLE sellers
	(
	seller_id INT PRIMARY KEY,
	seller_name VARCHAR(25),
	origin VARCHAR(15)
	);

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

CREATE TABLE orders_items
	(
	order_item_id INT PRIMARY KEY,
	order_id INT,
	product_id INT,
	quantity INT,
	price_per_unit FLOAT,
	CONSTRAINT orders_items_fk_order_id
	FOREIGN KEY(order_id) REFERENCES orders(order_id),
	CONSTRAINT orders_fk_product_id
	FOREIGN KEY(product_id) REFERENCES products(product_id)
	);

CREATE TABLE payments
	(
	payment_id INT PRIMARY KEY,
	order_id INT,
	payment_date DATE,
	payment_status VARCHAR(20),
	CONSTRAINT payments_fk_order_id
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
	);

CREATE TABLE shippings
	(
	shipping_id INT PRIMARY KEY,
	order_id INT,
	shipping_date DATE,
	return_date DATE,
	shipping_providers VARCHAR(25),
	delivery_status VARCHAR(30),
	CONSTRAINT shippings_fk_order_id
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
	);

CREATE TABLE inventory
	(
	inventory_id INT,
	product_id INT,
	stock INT,
	warehouse_id INT,
	last_stock_date DATE,
	CONSTRAINT inventory_fk_product_id
	FOREIGN KEY (product_id) REFERENCES products(product_id)
	);


