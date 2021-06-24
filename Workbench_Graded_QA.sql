-- Questions:

-- Q-6: Insert the following two rows in the 'customers' table.
-- (495,'Diecast Collectables','Franco','Valarie','Boston','MA','51003','USA','1188',85100),
-- (496,'Kelly\'s Gift Shop','Snowden','Tony','Auckland  ','NULL','NULL','New Zealand','1612',110000)

INSERT INTO `customers` VALUES (495,'Diecast Collectables','Franco','Valarie','Boston','MA','51003','USA','1188',85100)
, (496,'Kelly\'s Gift Shop','Snowden','Tony','Auckland  ','NULL','NULL','New Zealand','1612',110000);

-- Q-7: In the "employees" table there are some entries where 'SR' is written instead of 'Sales Rep' where office code is equal to 4.
-- Update the 'employees' table by inserting a job title as 'Sales Rep' where office code is equal to 4.

UPDATE employees
SET jobTitle = 'Sales Rep'
WHERE officeCode = 4;

-- Insert the following entry into the employee table.
insert into employees 
values
(1102, 'Bondur', 'Gerard', 'x5408', 'gbondur@classicmodelcars.com', 4, '1056', 'Sale Manager(EMEA)');
-- use company;
-- SELECT * FROM employees;
-- WHERE employeeNumber =1102;

-- Q-8: There is no product under category of boat. Hence, delete the Boat entry from productlines table.

-- SELECT * FROM productlines;

DELETE FROM productlines
WHERE productLine = 'Boats';

-- Q-9: Convert the 'quantityOrdered' column's data type into int from varchar.
ALTER TABLE orderdetails
CHANGE quantityOrdered quantityOrdered INT;

-- SELECT * FROM orderdetails;

-- Q-10: Print the employees with the job title “Sales Rep”. 
-- What is the first name of the employee that appears on the top after applying this query?

SELECT * FROM employees
WHERE jobTitle = "Sales Rep";


-- Q-10: Find the total number of employees from the 'employees’ table and alias it as "Total_Employees".

SELECT count(employeeNumber) Total_Employees
FROM employees;

-- Q-10: How many customers belongs to Australia? also alias it as "Australia_Customers".

SELECT count(CustomerNumber) Australia_Customers
FROM customers
WHERE country = 'Australia';

-- Q-11: Print the quantity in stock for "Red Start Diecast" product vendors with product line is "Vintage Cars" from the table "products".

SELECT sum(quantityInStock) FROM products
WHERE productVendor = 'Red Start Diecast' AND ProductLine = 'Vintage Cars';

-- Q-11: Count the total number of orders that has not been shipped yet in the "orders" table. 

SELECT * FROM orders;

SELECT count(orderNumber) FROM orders
WHERE status !='Shipped';

-- Q-12: Count the entries in "orderdetails" table with "productCode" starts with S18 and "priceEach" greater than 150.

SELECT count(orderNumber)
FROM orderdetails
WHERE productCode REGEXP '^S18' AND priceEach >150;


-- Q- 13: What are the top three countries which have the maximum number of customers?

SELECT Country, count(customerNumber) No_of_Cust
FROM customers
GROUP BY Country
ORDER BY No_of_Cust DESC
LIMIT 3;

SELECT Country
FROM customers
GROUP BY Country
ORDER BY count(customerNumber) DESC
LIMIT 3;


-- Q-14: What is the average credit limit for Singapore from "customers" table?

SELECT ROUND(AVG(creditLimit)) Avg_Credit_Limit_Singapore
FROM customers
WHERE country = 'Singapore';

-- Q-15: What is the total amount to be paid by the customer named as “Euro+ Shopping Channel”?
-- You need to use the “customers” and “payments” tables to answer this question.

SELECT customerName, sum(amount) Total_amount
FROM customers INNER JOIN payments USING (customerNumber)
WHERE customerName LIKE 'Euro+ Shopping Channel'
GROUP BY customerName;


-- Q-16: Which month has recieved the maximum aggragated payments from the customers? 
-- Q-16: What is the aggregated value of the payment recieved from that month?

SELECT month(paymentDate) Month, sum(amount) Agg_payment
FROM payments
GROUP BY Month
ORDER BY Agg_payment DESC;


-- Q-17: What is the shipped date of the maximum quantity ordered for "1968 Ford Mustang" product name?
-- use company;

WITH prod_order_details AS
(SELECT o.shippedDate, od.quantityOrdered, productCode, p.productName
FROM orders o 
INNER JOIN orderdetails od
USING (orderNumber)
INNER JOIN products p
USING (productCode)
)
SELECT shippedDate, quantityOrdered
FROM prod_order_details
WHERE productName = '1968 Ford Mustang'
ORDER BY quantityOrdered DESC
LIMIT 1;

SELECT shippedDate
FROM orders
WHERE orderNumber = (SELECT orderNumber FROM orderdetails
					WHERE productCode = (SELECT productCode FROM products
										WHERE productName = '1968 Ford Mustang'
                                        )
					ORDER BY quantityOrdered DESC
					LIMIT 1
					);

-- Q-18: Inner join:  What is the average value of credit limit corresponds to the customers which have been contacted by the employees with their office located in “Tokyo” city? 

SELECT avg(creditLimit) Avg_creditLimit
FROM customers c INNER JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE officeCode = (SELECT officeCode FROM offices WHERE office_city = 'Tokyo');

    
-- Q-19: Outer Join: What is the name of the customer which has paid the lowest amount to the company. 

SELECT customerName, sum(amount) Amt_paid
FROM customers RIGHT JOIN payments
USING (CustomerNumber)
GROUP BY customerName
ORDER BY Amt_paid;

-- Q-20: Outer Join: What is the city of the employee whose job title is "VP Marketing" ? 

SELECT jobTitle, office_city
FROM employees LEFT JOIN offices
USING (officeCode)
WHERE jobTitle = 'VP Marketing';

-- Q-21: What is the name of the customer who belongs to ‘France’ and has the maximum creditLimit among the customers in France?

SELECT customerName, creditLimit
FROM customers
WHERE country = 'France'
ORDER BY creditLimit DESC
LIMIT 1;

-- Q-22: What will be the remaining stock of the product code that equals ‘S18_1589’ if it is sent to all the customers who have demanded it?

SELECT quantityInStock - sum(quantityOrdered) 
FROM products INNER JOIN orderdetails
USING (productCode)
WHERE productCode = 'S18_1589';

-- Q-23: What is the average amount paid by the customer 'Mini Gifts Distributors Ltd.'?

SELECT ROUND(avg(amount)) Avg_amt_paid, customerName
FROM customers INNER JOIN payments
USING (customerNumber)
WHERE customerName = 'Mini Gifts Distributors Ltd.';
