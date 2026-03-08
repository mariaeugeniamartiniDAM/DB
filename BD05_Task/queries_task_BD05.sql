/* Excercise 2
Insert the following payments into the payments table using SQL statements:
customerNumber checkNumber paymentDate amount
	124	 		H123 		2024-02-06 845.00
	151 		H124 		2024-02-07 70.00
	112 		H125 		2024-02-05 1024.00
Copy the SQL statements you used in your submission. Only include the data shown.
*/
select * FROM payments;

INSERT INTO payments VALUES 
	(124, 'H123', '2024-02-06', 845),
	(151, 'H124', '2024-02-07', 70),
	(112, 'H125', '2024-02-05', 1024);
    
SELECT * FROM payments
WHERE YEAR(paymentDate) = 2024;

/*
* Exercise 3
Modify the addresses of some customers using the graphical tool, and provide
screenshots showing the changes made. Update the records in the customers table as
follows:
customerNumber 		city 		addressLine1 		postalCode
	141 			Girona 		43 State St 		17001
	124 			Lleida 		2 Walls St 			25002
	119 			Tarragona 	46 Marlborough Rd. 	43003 
*/

SELECT customerNumber, city, addressLine1, postalCode FROM customers;

/*
* Exercise 4
Cancel the order made on 2003-09-28, using SQL instructions. Change the status to
'Cancelled', the shippedDate to the current date, and comments to 'Order cancelled due
to delay'. Do this using a single SQL statement.
Copy the statement in your submission. 
*/
SET SQL_SAFE_UPDATES = 0;

UPDATE orders
SET status = 'Cancelled',
	shippedDate = CURDATE(), -- The function CURDATE returns current date.
    comments = 'Order cancelled due to delay'
WHERE orderDate = '2003-09-28';

SELECT * FROM orders
WHERE orderDate = '2003-09-28';


/*
Exercise 5
Update all product names of type Trains to include the product code in parentheses. For example, 
a product with productCode = S10_1949 and productName = "Vintage Train" will become:
"Vintage Train (code S10_1949)"
Do this with a single SQL statement using the proper MySQL functions. 
*/

UPDATE products
SET productName = CONCAT(productName, ' (code ', productCode, ')')
WHERE productLine = 'Trains';

SELECT * FROM products
WHERE productLine = 'Trains';

/*
Exercise 6
Increase buyPrice and MSRP of all products with quantityInStock > 500 by 0.02%.
Do this with one SQL statement. 
*/
SELECT * FROM products
WHERE quantityInStock > 500;

UPDATE products
SET buyPrice = buyPrice * 1.0002, -- to make an increase of 0.02%, we have to multiply it by 1 + (0.02/100) = 1.0002
	MSRP = MSRP * 1.0002
WHERE quantityInStock > 500;

SELECT * FROM products
WHERE quantityInStock > 500;

/*
Exercise 7
Remove all payments made by customers who are represented by employees with the
last name 'Patterson'.
Use a single SQL statement and copy it for the task delivery. 
*/

SELECT * FROM payments p
JOIN customers c ON p.customerNumber = c.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE e.lastName = 'Patterson';

DELETE FROM payments
WHERE customerNumber IN (
	SELECT c.customerNumber
    FROM customers c
    JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
    WHERE e.lastName = 'Patterson'
);


/*Exercise 8
Delete all customers from Lisbon who have not made any payment.
Use one SQL statement only. 
*/

SELECT * FROM customers
WHERE city = 'Lisboa' -- it turns out that the city is written in spanish, as 'Lisboa', not 'Lisbon'
AND customerNumber NOT IN (
	SELECT customerNumber
    FROM payments
);

DELETE FROM customers
WHERE city = 'Lisboa' 
AND customerNumber NOT IN (
	SELECT customerNumber
    FROM payments
);


/*
Exercise 9
Add all customers as new employees, using their contact names as first and last name.
Use customerNumber + 2000 as the new employeeNumber, leave all other fields as
 'x0000' extension, 'new@company.com' email,'1' officeCode, 'Sales Rep' jobTitle
Use contactFirstName as firstName, contactLastName as lastName.
Do this with a single SQL statement. 
*/
SELECT customerNumber, contactFirstName, contactLastName FROM customers;

SELECT customerNumber + 2000 AS employeeNumber,
       contactFirstName AS firstName,
       contactLastName AS lastName,
       'x0000' AS extension,
       'new@company.com' AS email,
       '1' AS officeCode,
       'Sales Rep' AS jobTitle
FROM customers;

INSERT INTO employees 
(employeeNumber, firstName, lastName, extension, email, officeCode, jobTitle)
SELECT customerNumber + 2000 AS employeeNumber,
       contactFirstName AS firstName,
       contactLastName AS lastName,
       'x0000' AS extension,
       'new@company.com' AS email,
       '1' AS officeCode,
       'Sales Rep' AS jobTitle
FROM customers;

SELECT * FROM employees
ORDER BY extension;


/*
*Cancel all orders made by customers handled by the customer Elizabeth Lincoln.
*Change the status to 'Cancelled', shippedDate to the current date, and comments to
*'Order cancelled by management'.
*Use a single SQL statement
*/
SELECT * FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
WHERE c.contactFirstName = 'Elizabeth' AND c.contactLastName = 'Lincoln';

UPDATE orders
SET status = 'Cancelled',
    shippedDate = CURDATE(),
    comments = 'Order cancelled by management'
WHERE customerNumber IN (
    SELECT customerNumber
    FROM customers
    WHERE contactFirstName = 'Elizabeth'
    AND contactLastName = 'Lincoln'
);


-- Trying the same query with Elizabeth Devon
SELECT * FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
WHERE c.contactFirstName = 'Elizabeth' AND c.contactLastName = 'Devon';

UPDATE orders
SET status = 'Cancelled',
    shippedDate = CURDATE(),
    comments = 'Order cancelled by management'
WHERE customerNumber IN (
    SELECT customerNumber
    FROM customers
    WHERE contactFirstName = 'Elizabeth'
    AND contactLastName = 'Devon'
);