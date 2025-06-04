![Retail Sales](retail_sales.jpg)

## Project Overview

**Project Title:** Retail Sales Analysis

**Resource**: [`retail-sales.sql`](Retail-Sales-Project/retail-sales.sql)

**Video Tutorial:** [![YouTube](https://img.shields.io/badge/YouTube-Video%20Tutorial-red?logo=youtube&logoColor=white)](https://youtu.be/sSTcl4nag2Q)

![Youtube](YouTube.jpg)


**Database:** `ventas_db`

The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `ventas_db`.
- **Table Creation**: A table named `ventas` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE ventas_db;

CREATE TABLE ventas
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM ventas;
SELECT COUNT(DISTINCT customer_id) FROM ventas;
SELECT DISTINCT category FROM ventas;

SELECT * FROM ventas
WHERE 
    sale_date IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL;

DELETE FROM ventas
WHERE 
    sale_date IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **All transactions for sales made on '2022-11-05**:
```sql
SELECT *
FROM ventas
WHERE sale_date = '2022-11-05';
```

2. **All transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM ventas
WHERE 
    category = 'Clothing' AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'  AND
    quantity >= 4
```

3. **Total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM ventas
GROUP BY 1
```

4. **Average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM ventas
WHERE category = 'Beauty'
```

5. **All transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM ventas
WHERE total_sale > 1000
```

6. **Total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM ventas
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Top 5 customers based on the highest total sales**:
```sql
SELECT 
	customer_id,
	SUM(total_sale) AS venta_total
FROM ventas
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

8.**Create a time transaction column (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Mañana'
		WHEN EXTRACT(HOUR FROM sale_time) between 12 AND 17 THEN 'Tarde'
		ELSE 'Noche'
	END tiempo,
	COUNT(*)
FROM ventas
GROUP BY tiempo;
```

9. **Average sales by year and month**:
```sql
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as mes,
	AVG(total_sale) as promedio
FROM ventas
GROUP BY year, mes
ORDER BY year, mes;
```

10. **Top monthly average by year**:
```sql
SELECT*
FROM
	(SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as mes,
		AVG(total_sale) as promedio,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
	FROM ventas
	GROUP BY year, mes
	ORDER BY year, mes) AS subconsulta
WHERE ranking = 1;
```
