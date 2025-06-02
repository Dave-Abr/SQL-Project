--1.Configuración base de datos--
CREATE DATABASE ventas_db;

CREATE TABLE ventas(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)


--2.Exploración y limpieza de datos--
--Cantidad de registros--

SELECT 
	COUNT(*)
FROM
	ventas;

--Cantidad de clientes únicos--

SELECT 
	COUNT(DISTINCT(customer_id)) 
FROM
	ventas;

--Cantidad de Categorias--

SELECT CATEGORY 
FROM VENTAS
GROUP BY 1;

--Identificar y eliminar valores nulos--

SELECT *
FROM
	ventas
WHERE
	quantiy IS NULL OR
	total_sale IS NULL;

DELETE FROM ventas 
WHERE
	quantiy IS NULL OR
	total_sale IS NULL;

--3.Análisis de datos--
--3.1 Todas las  ventas realizadas el '2022-11-05'--

SELECT *
FROM ventas
WHERE sale_date = '2022-11-05';

--3.2 Todas las transacciones de la categoria «Clothing», la cantidad >=4 en el mes de Nov-2022

SELECT *
FROM ventas
WHERE 
	category = 'Clothing' AND
	quantiy >= 4 AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

--3.3 Cantidad todal vendida por categoria

SELECT 
	category,
	COUNT(*)
FROM ventas
GROUP BY 1;

--3.4 Promedio edad de clientes que compran 'Beauty'

SELECT
	ROUND(AVG(age)) as promedio_edad
FROM ventas
WHERE category = 'Beauty';

--3.5 Ventas Total superiores a 1000

SELECT *
FROM ventas
WHERE total_sale > 1000;

--3.6 Numero total de transacciones hechas por genero en cada categoria

SELECT 
	category,
	gender,
	COUNT(*)
FROM ventas
GROUP BY 1,2
ORDER BY 1,2;

--3.7 Top 5 clientes con mayor valor de compras

SELECT 
	customer_id,
	SUM(total_sale) AS venta_total
FROM ventas
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--3.8 Clasifica las transacciones según la hora
--    (Mañana <12, Tarde  12-17, Noche >17)

SELECT
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Mañana'
		WHEN EXTRACT(HOUR FROM sale_time) between 12 AND 17 THEN 'Tarde'
		ELSE 'Noche'
	END tiempo,
	COUNT(*)
FROM ventas
GROUP BY tiempo;

--3.9 Promedio ventas por mes.

SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as mes,
	AVG(total_sale) as promedio
FROM ventas
GROUP BY year, mes
ORDER BY year, mes;

--3.10 Mejor promedio de ventas del mes de cada año

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






