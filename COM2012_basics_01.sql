-- 1. Creating database
-- comment: Ctrl + K, C
/*
CREATE DATABASE abc;
CREATE DATABASE xyz;
*/
CREATE DATABASE com2012;
USE com2012;

-- 2. Creating tables
-- create
CREATE TABLE students(
	id INT PRIMARY KEY,
	fullName VARCHAR(50) NOT NULL
);
-- drop table
DROP TABLE IF EXISTS students;


-- alter table add column
ALTER TABLE students
ADD email VARCHAR(50) NOT NULL;

ALTER TABLE students
ADD phone VARCHAR(10) NOT NULL;

-- rename
EXEC sp_rename students, sinhViens;
EXEC sp_rename sinhViens, students;

-- drop column
ALTER TABLE students
DROP COLUMN phone;

-- 3. Insert into
-- single row
INSERT INTO students(id, fullName, email, phone)
VALUES(1, 'student 1', 'email 1', 'phone 1');

-- multiple rows
INSERT INTO students(id, fullName, email, phone)
VALUES
	(2, 'student 2', 'email 2', 'phone2'),
	(3, 'student 3', 'email 3', 'phone 3'),
	(4, 'student 4', 'email 4', 'phone 4');

-- Delete
DELETE FROM students WHERE id = 1;

---------------------------------------------------------------------
---------------------------------------------------------------------
----------- DATA MANIPULATION ---------------------------------------
-- 1. SELECT
SELECT TOP 10
	first_name,
	last_name
FROM sales.customers;

SELECT TOP 10
	first_name,
	last_name,
	email
FROM sales.customers;

SELECT TOP 10
	*
FROM sales.customers;

-- 1.1 WHERE
--
SELECT
    *
FROM
    sales.customers
WHERE
    state = 'CA';

--
SELECT
    *
FROM
    sales.customers
WHERE
    state = 'CA' AND phone IS NOT NULL;

--
SELECT
    *
FROM
    sales.customers
WHERE
    state = 'CA' AND phone IS NOT NULL AND city = 'San Diego';

-- 1.2 ORDER BY
SELECT
    *
FROM
    sales.customers
WHERE
    state = 'CA' AND phone IS NOT NULL AND city = 'San Diego'
ORDER BY first_name DESC; -- default = ASC

-- 1.3 Advanced: GROUP BY
SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
ORDER BY
    city;

-- 1.4 Advanced: HAVING
SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
HAVING
    COUNT (*) > 10
ORDER BY
    city;

-- 2. ORDER BY [ASC, DESC]
-- 2.1 By one column ASC (default) or DESC
SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    first_name DESC;

-- 2.2 By multiple columns
SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city,
    first_name;

-- Sort a result set by multiple columns in different orders
SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city DESC,
    first_name ASC;

-- Sort a result set by a column that is not in the select list
SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    state;

-- Advanced: Sort a result set by an expression
SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    LEN(first_name) DESC;

-- Sort by ordinal positions of columns (Not recomended!)
SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    1,
    2;

-- 3. SELECT TOP
SELECT TOP (expression) [PERCENT]
    [WITH TIES]
FROM 
    table_name
ORDER BY 
    column_name;

-- 3.1 Using SQL Server SELECT TOP with a constant value
SELECT TOP 10
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;

-- 3.2 Using SELECT TOP to return a percentage of rows
SELECT TOP 1 PERCENT
    product_name, 
    list_price	
FROM
    production.products
ORDER BY 
    list_price DESC;

-- 3.3 Using SELECT TOP WITH TIES to include rows that match values in the last row
SELECT TOP 3 WITH TIES
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;

-- 4. OFFSET FETCH
-- 4.1 Using the SQL Server OFFSET FETCH example
-- normal
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name;

-- offset 10 rows
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name 
OFFSET 10 ROWS;
-- 4.2 skip the first 10 products and select the next 10 products, use both OFFSET and FETCH
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name 
OFFSET 10 ROWS 
FETCH NEXT 10 ROWS ONLY;
-- Using the OFFSET FETCH clause to get the top N rows
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price DESC,
    product_name 
OFFSET 0 ROWS 
FETCH FIRST 10 ROWS ONLY;

-- 5. SELECT DISTINCT
-- 5.1 with one column
SELECT 
  DISTINCT city 
FROM 
  sales.customers 
ORDER BY 
  city;

-- 5.2 with multiple columns
SELECT 
  DISTINCT city, state 
FROM 
  sales.customers
ORDER BY 
  city, 
  state;

-- 5.3 Using SELECT DISTINCT with NULL
SELECT 
  DISTINCT phone 
FROM 
  sales.customers 
ORDER BY 
  phone;

-- 6. WHERE
-- 6.1 Using the WHERE clause with a simple equality operator
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    category_id = 1
ORDER BY
    list_price DESC;

-- 6.2 Using the WHERE clause with the AND operator
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    category_id = 1 AND model_year = 2018
ORDER BY
    list_price DESC;

-- 6.3 Using WHERE to filter rows using a comparison operator
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price > 300 AND model_year = 2018
ORDER BY
    list_price DESC;

-- 6.4 Using the WHERE clause to filter rows that meet any of two conditions
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price > 3000 OR model_year = 2018
ORDER BY
    list_price DESC;

-- 6.5 Using the WHERE clause to filter rows with the value between two values
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price BETWEEN 1899.00 AND 1999.99
ORDER BY
    list_price DESC;

-- 6.6 Using the WHERE clause to filter rows that have a value in a list of values
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    list_price IN (299.99, 369.99, 489.99)
ORDER BY
    list_price DESC;

-- 6.7 Finding rows whose values contain a string
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    product_name LIKE '%Cruiser%'
ORDER BY
    list_price;




