--Creamos la base de datos

CREATE DATABASE library_db;

--Creamos cada una de las tablas

DROP TABLE IF EXISTS branch;

CREATE TABLE branch (
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(25),
	contact_no VARCHAR(15)
	
);

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(40),
	emp_position VARCHAR(25),
	emp_salary DECIMAL(10,2),
	branch_id VARCHAR(10),
	FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

DROP TABLE IF EXISTS books;
CREATE TABLE books(
	isbn VARCHAR(30) PRIMARY KEY,
	book_title VARCHAR(70),
	category VARCHAR(20),
	rental_price DECIMAL(10,2),
	status VARCHAR(5),
	author VARCHAR(60),
	publisher VARCHAR(50)
);

DROP TABLE IF EXISTS member;

CREATE TABLE member(
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(30),
	member_address VARCHAR(50),
	reg_date DATE
);

DROP TABLE IF EXISTS return_status;

CREATE TABLE return_status(
	return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(10),
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20)
);


DROP TABLE IF EXISTS issue_status;

CREATE TABLE issue_status (
	issue_id VARCHAR(10) PRIMARY KEY,
	issued_member_id VARCHAR(10),
	issued_book_name VARCHAR(100),
	issued_date DATE,
	issued_book_isbn VARCHAR(60),
	issued_emp_id VARCHAR(10)
);

--Agregamos las Foreign Keys faltantes

ALTER TABLE issue_status
ADD CONSTRAINT fk_member
FOREIGN KEY (issued_member_id)
REFERENCES member(member_id);

ALTER TABLE issue_status
ADD CONSTRAINT fk_book_isbn
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issue_status
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES issue_status(issue_id);

ALTER TABLE books
ALTER COLUMN book_id TYPE VARCHAR(200);

--Introducimos todos los registros a la base de datos a las respectivas tablas

INSERT INTO member(member_id, member_name, member_address, reg_date) 
VALUES
('C101', 'Alice Johnson', '123 Main St', '2021-05-15'),
('C102', 'Bob Smith', '456 Elm St', '2021-06-20'),
('C103', 'Carol Davis', '789 Oak St', '2021-07-10'),
('C104', 'Dave Wilson', '567 Pine St', '2021-08-05'),
('C105', 'Eve Brown', '890 Maple St', '2021-09-25'),
('C106', 'Frank Thomas', '234 Cedar St', '2021-10-15'),
('C107', 'Grace Taylor', '345 Walnut St', '2021-11-20'),
('C108', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C109', 'Ivy Martinez', '567 Oak St', '2022-01-05'),
('C110', 'Jack Wilson', '678 Pine St', '2022-02-25'),
('C118', 'Sam', '133 Pine St', '2024-06-01'),    
('C119', 'John', '143 Main St', '2024-05-01');
SELECT * FROM member;

INSERT INTO branch(branch_id, manager_id, branch_address, contact_no) 
VALUES
('B001', 'E109', '123 Main St', '+919099988676'),
('B002', 'E109', '456 Elm St', '+919099988677'),
('B003', 'E109', '789 Oak St', '+919099988678'),
('B004', 'E110', '567 Pine St', '+919099988679'),
('B005', 'E110', '890 Maple St', '+919099988680');
SELECT * FROM branch;

INSERT INTO employees(emp_id, emp_name, emp_position, emp_salary, branch_id) 
VALUES
('E101', 'John Doe', 'Clerk', 60000.00, 'B001'),
('E102', 'Jane Smith', 'Clerk', 45000.00, 'B002'),
('E103', 'Mike Johnson', 'Librarian', 55000.00, 'B001'),
('E104', 'Emily Davis', 'Assistant', 40000.00, 'B001'),
('E105', 'Sarah Brown', 'Assistant', 42000.00, 'B001'),
('E106', 'Michelle Ramirez', 'Assistant', 43000.00, 'B001'),
('E107', 'Michael Thompson', 'Clerk', 62000.00, 'B005'),
('E108', 'Jessica Taylor', 'Clerk', 46000.00, 'B004'),
('E109', 'Daniel Anderson', 'Manager', 57000.00, 'B003'),
('E110', 'Laura Martinez', 'Manager', 41000.00, 'B005'),
('E111', 'Christopher Lee', 'Assistant', 65000.00, 'B005');
SELECT * FROM employees;


-- insertamos todos los registros de los libros en la tabla libros
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES
('978-0-553-29698-2', 'The Catcher in the Rye', 'Classic', 7.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company'),
('978-0-330-25864-8', 'Animal Farm', 'Classic', 5.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-118776-1', 'One Hundred Years of Solitude', 'Literary Fiction', 6.50, 'yes', 'Gabriel Garcia Marquez', 'Penguin Books'),
('978-0-525-47535-5', 'The Great Gatsby', 'Classic', 8.00, 'yes', 'F. Scott Fitzgerald', 'Scribner'),
('978-0-141-44171-6', 'Jane Eyre', 'Classic', 4.00, 'yes', 'Charlotte Bronte', 'Penguin Classics'),
('978-0-307-37840-1', 'The Alchemist', 'Fiction', 2.50, 'yes', 'Paulo Coelho', 'HarperOne'),
('978-0-679-76489-8', 'Harry Potter and the Sorcerers Stone', 'Fantasy', 7.00, 'yes', 'J.K. Rowling', 'Scholastic'),
('978-0-7432-4722-4', 'The Da Vinci Code', 'Mystery', 8.00, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-09-957807-9', 'A Game of Thrones', 'Fantasy', 7.50, 'yes', 'George R.R. Martin', 'Bantam'),
('978-0-393-05081-8', 'A Peoples History of the United States', 'History', 9.00, 'yes', 'Howard Zinn', 'Harper Perennial'),
('978-0-19-280551-1', 'The Guns of August', 'History', 7.00, 'yes', 'Barbara W. Tuchman', 'Oxford University Press'),
('978-0-307-58837-1', 'Sapiens: A Brief History of Humankind', 'History', 8.00, 'no', 'Yuval Noah Harari', 'Harper Perennial'),
('978-0-375-41398-8', 'The Diary of a Young Girl', 'History', 6.50, 'no', 'Anne Frank', 'Bantam'),
('978-0-14-044930-3', 'The Histories', 'History', 5.50, 'yes', 'Herodotus', 'Penguin Classics'),
('978-0-393-91257-8', 'Guns, Germs, and Steel: The Fates of Human Societies', 'History', 7.00, 'yes', 'Jared Diamond', 'W. W. Norton & Company'),
('978-0-7432-7357-1', '1491: New Revelations of the Americas Before Columbus', 'History', 6.50, 'no', 'Charles C. Mann', 'Vintage Books'),
('978-0-679-64115-3', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-14-143951-8', 'Pride and Prejudice', 'Classic', 5.00, 'yes', 'Jane Austen', 'Penguin Classics'),
('978-0-452-28240-7', 'Brave New World', 'Dystopian', 6.50, 'yes', 'Aldous Huxley', 'Harper Perennial'),
('978-0-670-81302-4', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Knopf'),
('978-0-385-33312-0', 'The Shining', 'Horror', 6.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52993-5', 'Fahrenheit 451', 'Dystopian', 5.50, 'yes', 'Ray Bradbury', 'Ballantine Books'),
('978-0-345-39180-3', 'Dune', 'Science Fiction', 8.50, 'yes', 'Frank Herbert', 'Ace'),
('978-0-375-50167-0', 'The Road', 'Dystopian', 7.00, 'yes', 'Cormac McCarthy', 'Vintage'),
('978-0-06-025492-6', 'Where the Wild Things Are', 'Children', 3.50, 'yes', 'Maurice Sendak', 'HarperCollins'),
('978-0-06-112241-5', 'The Kite Runner', 'Fiction', 5.50, 'yes', 'Khaled Hosseini', 'Riverhead Books'),
('978-0-06-440055-8', 'Charlotte''s Web', 'Children', 4.00, 'yes', 'E.B. White', 'Harper & Row'),
('978-0-679-77644-3', 'Beloved', 'Fiction', 6.50, 'yes', 'Toni Morrison', 'Knopf'),
('978-0-14-027526-3', 'A Tale of Two Cities', 'Classic', 4.50, 'yes', 'Charles Dickens', 'Penguin Books'),
('978-0-7434-7679-3', 'The Stand', 'Horror', 7.00, 'yes', 'Stephen King', 'Doubleday'),
('978-0-451-52994-2', 'Moby Dick', 'Classic', 6.50, 'yes', 'Herman Melville', 'Penguin Books'),
('978-0-06-112008-4', 'To Kill a Mockingbird', 'Classic', 5.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'),
('978-0-553-57340-1', '1984', 'Dystopian', 6.50, 'yes', 'George Orwell', 'Penguin Books'),
('978-0-7432-4722-5', 'Angels & Demons', 'Mystery', 7.50, 'yes', 'Dan Brown', 'Doubleday'),
('978-0-7432-7356-4', 'The Hobbit', 'Fantasy', 7.00, 'yes', 'J.R.R. Tolkien', 'Houghton Mifflin Harcourt');

SELECT * FROM books;

INSERT INTO issue_status(issue_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id) 
VALUES
('IS106', 'C106', 'Animal Farm', '2024-03-10', '978-0-330-25864-8', 'E104'),
('IS107', 'C107', 'One Hundred Years of Solitude', '2024-03-11', '978-0-14-118776-1', 'E104'),
('IS108', 'C108', 'The Great Gatsby', '2024-03-12', '978-0-525-47535-5', 'E104'),
('IS109', 'C109', 'Jane Eyre', '2024-03-13', '978-0-141-44171-6', 'E105'),
('IS110', 'C110', 'The Alchemist', '2024-03-14', '978-0-307-37840-1', 'E105'),
('IS111', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-03-15', '978-0-679-76489-8', 'E105'),
('IS112', 'C109', 'A Game of Thrones', '2024-03-16', '978-0-09-957807-9', 'E106'),
('IS113', 'C109', 'A Peoples History of the United States', '2024-03-17', '978-0-393-05081-8', 'E106'),
('IS114', 'C109', 'The Guns of August', '2024-03-18', '978-0-19-280551-1', 'E106'),
('IS115', 'C109', 'The Histories', '2024-03-19', '978-0-14-044930-3', 'E107'),
('IS116', 'C110', 'Guns, Germs, and Steel: The Fates of Human Societies', '2024-03-20', '978-0-393-91257-8', 'E107'),
('IS117', 'C110', '1984', '2024-03-21', '978-0-679-64115-3', 'E107'),
('IS118', 'C101', 'Pride and Prejudice', '2024-03-22', '978-0-14-143951-8', 'E108'),
('IS119', 'C110', 'Brave New World', '2024-03-23', '978-0-452-28240-7', 'E108'),
('IS120', 'C110', 'The Road', '2024-03-24', '978-0-670-81302-4', 'E108'),
('IS121', 'C102', 'The Shining', '2024-03-25', '978-0-385-33312-0', 'E109'),
('IS122', 'C102', 'Fahrenheit 451', '2024-03-26', '978-0-451-52993-5', 'E109'),
('IS123', 'C103', 'Dune', '2024-03-27', '978-0-345-39180-3', 'E109'),
('IS124', 'C104', 'Where the Wild Things Are', '2024-03-28', '978-0-06-025492-6', 'E110'),
('IS125', 'C105', 'The Kite Runner', '2024-03-29', '978-0-06-112241-5', 'E110'),
('IS126', 'C105', 'Charlotte''s Web', '2024-03-30', '978-0-06-440055-8', 'E110'),
('IS127', 'C105', 'Beloved', '2024-03-31', '978-0-679-77644-3', 'E110'),
('IS128', 'C105', 'A Tale of Two Cities', '2024-04-01', '978-0-14-027526-3', 'E110'),
('IS129', 'C105', 'The Stand', '2024-04-02', '978-0-7434-7679-3', 'E110'),
('IS130', 'C106', 'Moby Dick', '2024-04-03', '978-0-451-52994-2', 'E101'),
('IS131', 'C106', 'To Kill a Mockingbird', '2024-04-04', '978-0-06-112008-4', 'E101'),
('IS132', 'C106', 'The Hobbit', '2024-04-05', '978-0-7432-7356-4', 'E106'),
('IS133', 'C107', 'Angels & Demons', '2024-04-06', '978-0-7432-4722-5', 'E106'),
('IS134', 'C107', 'The Diary of a Young Girl', '2024-04-07', '978-0-375-41398-8', 'E106'),
('IS135', 'C107', 'Sapiens: A Brief History of Humankind', '2024-04-08', '978-0-307-58837-1', 'E108'),
('IS136', 'C107', '1491: New Revelations of the Americas Before Columbus', '2024-04-09', '978-0-7432-7357-1', 'E102'),
('IS137', 'C107', 'The Catcher in the Rye', '2024-04-10', '978-0-553-29698-2', 'E103'),
('IS138', 'C108', 'The Great Gatsby', '2024-04-11', '978-0-525-47535-5', 'E104'),
('IS139', 'C109', 'Harry Potter and the Sorcerers Stone', '2024-04-12', '978-0-679-76489-8', 'E105'),
('IS140', 'C110', 'Animal Farm', '2024-04-13', '978-0-330-25864-8', 'E102');

SELECT * FROM issue_status;

-- insertamos todos los registros de devoluciones 
INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES

('RS104', 'IS106', '2024-05-01'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');
SELECT * FROM return_status;


-- Tarea 1. Creamos un nuevo registro

INSERT INTO books 
	(isbn,	book_title, category, rental_price, status, author, publisher)
VALUES
	('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Tarea 2: Actualizamos un registro

UPDATE member
SET member_address ='555 Main St'
WHERE member_id='C101';

SELECT * FROM member;

-- Tarea 3: eliminamos un registro de la tabla prestamos

DELETE FROM issue_status
WHERE issue_id = 'IS107';
SELECT * FROM issue_status;

-- Tarea 4: Conteo total de la cantidad de libros prestados por empleado

SELECT 
	issued_emp_id as empleado,
	COUNT(*) AS cnt_issued
FROM  issue_status
GROUP BY 1
ORDER BY 2 DESC;
WHERE	emp_id = 'E101';

-- Tarea 5: Miembros que an alquilado más de 1 libro

SELECT 
	issued_member_id as members,
	COUNT(issue_id) AS cnt_issued
FROM issue_status
GROUP BY 1
HAVING COUNT(issue_id) > 1
ORDER BY 2 DESC;

-- ### 3. CTAS (Create Table As Select)

-- Tarea  6: Create Summary Tables**: Creamos 1 tabla - cantidad de préstamos por cada libro
CREATE TABLE book_issued_cnt AS
SELECT 
	iss.issued_book_name,b.book_title,
	COUNT(iss.issue_id) as book_issued_cnt
FROM issue_status as iss
JOIN books as b
ON iss.issued_book_isbn = b.isbn
GROUP BY iss.issued_book_name, b.book_title;

SELECT * FROM books;

-- Tarea 7: Ingreso total por categoria de libro

SELECT 
	b.isbn,
	COUNT(i.issued_book_isbn) as times_sold,
	b.rental_price,
	COUNT(i.issued_book_isbn)*b.rental_price AS total_income
FROM books as b
JOIN issue_status as i
ON b.isbn = i.issued_book_isbn
GROUP BY b.isbn, b.rental_price;

SELECT * FROM books;

-- Tarea 8. **miembros registrados en los ultimos 180 Days**:

SELECT * FROM member
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 DAYS';

-- Tarea 10: List Employees with Their Branch Manager's Name and their branch details**:

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

select * from employees;


-- Tarea 11: Lista de libros aun NO devueltos

SELECT *
FROM return_status as r
right JOIN issue_status as i
ON r.issued_id = i.issue_id
WHERE r.return_date IS NULL;
    

### Operaciones Avanzadas 

--Task 12: Miembros con mas de 50 dias de mora


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


-- Agregamos una nueva columna para el status de los libros devueltos

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');

--Tarea 15: Desempeño por cada rama
--Cantidad de libros prestados, libros devueltos e ingreso total.

SELECT br.branch_id,
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

--Task 16: CTAS: Crear una tabla para miembros activos (libro prestados en los ultimos 12 meses)

SELECT * FROM member
WHERE member_id IN
(SELECT DISTINCT issued_member_id
FROM issue_status as i
WHERE issued_date > (CURRENT_DATE  - INTERVAL'12 month')) ;


--Tarea 17: Empleado con la mayor cantidad de libros prestados

SELECT 
	e.emp_name,
	e.branch_id,
	COUNT(i.issue_id)
FROM issue_status as i
JOIN employees as e 
	ON i.issued_emp_id = e.emp_id
GROUP BY 1,2
ORDER BY COUNT(i.issue_id) DESC;



--Tarea 18: Procedimiento para verifica y actulizar el estatus de cada libro prestado
  --  Si el libro se presta el status debe cambiar a 'no'
  --  Si el libro es devuelto el status debe cambiar a 'yes'

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

CALL update_status('IS155', 'C105','978-0-307-58837-1','E102');
CALL update_status('IS156', 'C105','978-0-393-05081-8','E102');


