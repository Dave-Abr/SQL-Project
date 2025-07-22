![Amazon](data/amazon_cover.jpg)

## Project Overview

**Project Title:** Amazon Advanced

**Resource**: [`02_business_queries.sql`](01_database_init.sql), [`01_database_init.sql`](02_business_queries.sql)



**Database:** `amazon_db`

The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.


## Database Setup

![AmazonERD](00_database_erd.jpg)

- **Table Creation**: Created tables for products, categories, customers, sellers, orders, orders_items, payments, shipping and inventory.

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
**Task 2.** Update an Existing Member's Address

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```
**Task 3.** Delete a Record from the Issued Status

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```


### 3. CTAS (Create Table As Select) & Data Analysis

The following SQL queries were developed to answer specific business questions:

1. **Find Total Rental Income by Category**
```sql
SELECT 
	b.isbn,
	COUNT(i.issued_book_isbn) as times_sold,
	b.rental_price,
	COUNT(i.issued_book_isbn)*b.rental_price AS total_income
FROM books as b
JOIN issue_status as i
ON b.isbn = i.issued_book_isbn
GROUP BY b.isbn, b.rental_price;
```

2. **List Employees with Their Branch Manager's Name and their branch details:**:
```sql
SELECT 
	b.branch_id ,
	e.branch_id,
	b.manager_id,
	e2.emp_name as manager,
	e.emp_id,
	e.emp_name
FROM employees as e
JOIN branch as b
	ON e.branch_id = b.branch_id
JOIN employees as e2
	ON b.manager_id = e2.emp_id;
```

3. **Retrieve the List of Books Not Yet Returned**:
```sql
SELECT *
FROM return_status as r
RIGHT JOIN issue_status as i
	ON r.issued_id = i.issue_id
WHERE r.return_date IS NULL;
```

# Advanced Operations

4. **Identify Members with Overdue Books >30 days**:
```sql
SELECT 
	m.member_name,
	i.issued_book_name as book,
	i.issued_date,
	CURRENT_DATE - i.issued_date  as  days_overdue
FROM return_status as r
RIGHT JOIN issue_status as i
	ON r.issued_id = i.issue_id
JOIN member as m
	ON i.issued_member_id = m.member_id
WHERE r.return_date IS NULL 
	AND (CURRENT_DATE - i.issued_date) >= 50
ORDER BY days_overdue DESC;
```

5. **Update Book Status on Return**
   
The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.:
```sql
CREATE OR REPLACE PROCEDURE 
	update_status
		(p_issued_id VARCHAR(10),
		p_issued_member_id VARCHAR(10),
		p_issued_book_id VARCHAR(60),
		p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
as $$
	DECLARE
		var1 VARCHAR(10);
	BEGIN
		SELECT status INTO var1
		FROM books
		WHERE isbn = p_issued_book_id;

		IF  var1 = 'yes' 
		THEN
			INSERT INTO issue_status(issue_id,issued_member_id,issued_date,issued_book_isbn,issued_emp_id)
			VALUES (p_issued_id,p_issued_member_id,CURRENT_DATE,p_issued_book_id,p_issued_emp_id);

			UPDATE books
			SET status = 'no'
			WHERE isbn = p_issued_book_id;

			RAISE NOTICE 'Book success: %', p_issued_book_id;
			
		ELSE
			RAISE NOTICE 'Book failure: %', p_issued_book_id;
			
		end if;

	END;

$$
```

```sql
CALL update_status('RS138', 'IS135', 'Good');
```

6. **Branch Performance Report**
   
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.:

```sql
SELECT 
	br.branch_id,
	COUNT(i.issue_id),
	COUNT(r.return_id),
	SUM(b.rental_price)
FROM issue_status as i
JOIN employees as e
	ON i.issued_emp_id = e.emp_id
JOIN branch as br
	ON br.branch_id = e.branch_id
LEFT JOIN return_status as r
	ON r.issued_id = i.issue_id
JOIN books as b
	ON b.isbn = i.issued_book_isbn
GROUP BY br.branch_id;
```
