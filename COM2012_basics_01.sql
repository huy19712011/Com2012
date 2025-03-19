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
    first_name DESC;

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

-- 7. NULL
-- 7.1 IS NULL, IS NOT NULL
SELECT
    customer_id,
    first_name,
    last_name,
    phone
FROM
    sales.customers
WHERE
    phone IS NULL
ORDER BY
    first_name,
    last_name;

-- 8. IN
-- 8.1 Basic SQL Server IN operator
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;

-- NOT IN
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price NOT IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;

-- Advanced: in subquery
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price NOT IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;

-- 9. BETWEEN
-- 9.1 Using SQL Server BETWEEN with numbers example
-- BETWEEN
SELECT
    product_id,
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price BETWEEN 149.99 AND 199.99
ORDER BY
    list_price;
-- NOT BETWEEN
SELECT
    product_id,
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price NOT BETWEEN 149.99 AND 199.99
ORDER BY
    list_price;

-- 9.2 Using SQL Server BETWEEN with dates example
SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM
    sales.orders
WHERE
    order_date BETWEEN '20170115' AND '20170117'
ORDER BY
    order_date;

-- 10. LIKE

-- 11. GROUP BY
-- Syntax: GROUP BY clause produces a group for each combination of the values in the columns listed in the GROUP BY clause.
/*
SELECT
    select_list
FROM
    table_name
GROUP BY
    column_name1,
    column_name2 ,...;
*/
-- 11.1
-- normal
SELECT
    order_id,
	order_date,
	customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
ORDER BY
    customer_id;

-- using GROUP BY
SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

-- same as DISTINCT
SELECT DISTINCT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
ORDER BY
    customer_id;

-- 11.2 GROUP BY clause and aggregate functions
-- COUNT(); SUM(); AVG(); MIN(); MAX()
--
SELECT
    customer_id,
    YEAR (order_date) AS order_year,
    COUNT (order_id) AS order_placed,
	--
	COUNT (customer_id) AS number,
	COUNT (order_date) AS number,
	COUNT (*) AS number
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

-- Error
SELECT
    customer_id,
    YEAR (order_date) AS order_year,
    -- Error at this row
	order_status
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

-- 11.3 More examples
-- GROUP BY clause with the COUNT() function
-- COUNT() function returns the number of customers in each city
SELECT
    city,
    COUNT (customer_id) AS customer_count
FROM
    sales.customers
GROUP BY
    city
ORDER BY
    city;

-- number of customers by state and city
SELECT
    city,
    state,
    COUNT (customer_id) AS customer_count
FROM
    sales.customers
GROUP BY
    state,
    city
ORDER BY
    city,
    state;

-- GROUP BY clause with the MIN and MAX functions
-- minimum and maximum list prices of all products with the model 2018 by brand
SELECT
    brand_name,
    MIN (list_price) AS min_price,
    MAX (list_price) AS max_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;

-- GROUP BY clause with the AVG() function
-- average list price by brand for all products with the model year 2018
SELECT
    brand_name,
    AVG (list_price) AS avg_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;

-- GROUP BY clause with the SUM function
SELECT
    order_id,
    SUM (
        quantity * list_price * (1 - discount)
    ) AS net_value
FROM
    sales.order_items
GROUP BY
    order_id;

-- 12. HAVING
-- SYNTAX: HAVING clause is often used with the GROUP BY clause to filter groups based on a specified list of conditions
/*
SELECT
    select_list
FROM
    table_name
GROUP BY
    group_list
HAVING
    conditions;
*/

-- 12.1 HAVING with the COUNT function
SELECT
    customer_id,
    YEAR (order_date) AS order_year,
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;

-- 12.2 HAVING clause with the SUM() function
-- The following statement finds the sales orders whose net values are greater than 20,000
SELECT
    order_id,
    SUM (
        quantity * list_price * (1 - discount)
    ) net_value
FROM
    sales.order_items
GROUP BY
    order_id
HAVING
    SUM (
        quantity * list_price * (1 - discount)
    ) > 20000
ORDER BY
    net_value;

--
SELECT
    *
FROM
    sales.order_items;

SELECT
    *
FROM
    sales.orders;

-- HAVING clause with MAX and MIN functions
-- The following statement first finds the maximum and minimum list prices in each product category. Then, it filters out the category which has a maximum list price greater than 4,000 or a minimum list price less than 500
SELECT
    category_id,
    MAX (list_price) max_list_price,
    MIN (list_price) min_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    MAX (list_price) > 4000 OR MIN (list_price) < 500;

-- HAVING clause with AVG() function
-- The following statement finds product categories whose average list prices are between 500 and 1,000
SELECT
    category_id,
    AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    AVG (list_price) BETWEEN 500 AND 1000;

-- 13. INNER JOIN
--
SELECT
    product_name,
    category_name,
    list_price
FROM
    production.products AS p
INNER JOIN production.categories AS c 
    ON c.category_id = p.category_id -- AND c.category_id = 1
-- WHERE c.category_id = 1
ORDER BY
    product_name DESC;

--
SELECT
    product_name,
    category_name,
    brand_name,
    list_price
FROM
    production.products p
INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
ORDER BY
    product_name DESC;

-- 14. LEFT JOIN, RIGHT JOIN
-- returns all rows from the left table and the matching rows from the right table. If no matching rows are found in the right table, NULL are used
--
SELECT
    product_name,
    order_id,
	--
	p.product_id AS 'In Products',
	o.product_id AS 'In Orders'
FROM
    production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
ORDER BY
    order_id;

-- with WHERE: returns the products that do not appear in any sales order
SELECT
    product_name,
    order_id
FROM
    production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
WHERE order_id IS NULL

--  join three tables: production.products, sales.orders, and sales.order_items using the LEFT JOIN clauses
SELECT
    p.product_name,
    o.order_id,
    i.item_id,
    o.order_date,
	--
	i.product_id,
	p.product_id
FROM
    production.products p
	LEFT JOIN sales.order_items i
		ON i.product_id = p.product_id
	LEFT JOIN sales.orders o
		ON o.order_id = i.order_id
ORDER BY
    order_id;

-- conditions in ON vs. WHERE clause: not same; Note that for the INNER JOIN , the condition in the ON is functionally equivalent in the WHERE.
-- WHERE
SELECT
    product_name,
    order_id
FROM
    production.products p
LEFT JOIN sales.order_items o 
   ON o.product_id = p.product_id
WHERE order_id = 100
ORDER BY
    order_id;

-- ON
SELECT
    p.product_id,
    product_name,
    order_id
FROM
    production.products p
    LEFT JOIN sales.order_items o 
         ON o.product_id = p.product_id AND 
            o.order_id = 100
ORDER BY
    order_id DESC;

-- 15. FULL OUTER JOIN

