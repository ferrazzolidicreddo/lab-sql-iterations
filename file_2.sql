USE sakila;

# Lab | SQL Iterations
# In this lab, we will continue working on the Sakila database of movie rentals.

# Instructions
# Write queries to answer the following questions:

# Write a query to find what is the total business done by each store.
SELECT * FROM sakila.rental;
SELECT * FROM sakila.store;
SELECT * FROM sakila.payment;
SELECT * FROM sakila.staff;

SELECT round(sum(amount),0) FROM sakila.payment;

# Testing the code 1
SELECT s.store_id AS Store, p.staff_id AS Staff, round(sum(p.amount),0) AS Total_Revenue
FROM sakila.payment AS p
JOIN sakila.store AS s
ON s.manager_staff_id = p.staff_id
GROUP BY s.store_id;


# Testing the code 2
SELECT store_id AS Store, r.staff_id AS Staff, round(sum(p.amount)) AS Total_Revenue
FROM sakila.rental AS r
JOIN sakila.payment AS p
ON r.staff_id = p.staff_id
JOIN sakila.staff AS s
ON r.staff_id = s.staff_id
GROUP BY s.store_id;

# Convert the previous query into a stored procedure.

#Testing the code
SELECT s.store_id AS Store, p.staff_id AS Staff, round(sum(p.amount),0) AS Total_Revenue
FROM sakila.payment AS p
JOIN sakila.store AS s
ON s.manager_staff_id = p.staff_id
GROUP BY s.store_id
HAVING s.store_id = 1;

# Solution
DROP PROCEDURE store_revenue;

DELIMITER //
CREATE PROCEDURE store_revenue(in param1 int)
BEGIN
	SELECT s.store_id AS Store, p.staff_id AS Staff, round(sum(p.amount),0) AS Total_Revenue
	FROM sakila.payment AS p
	JOIN sakila.store AS s
	ON s.manager_staff_id = p.staff_id
	GROUP BY s.store_id
	HAVING s.store_id = param1;
END;
//
DELIMITER ;


# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //
CREATE PROCEDURE store_revenue(in param1 int)
BEGIN
	SELECT s.store_id AS Store, p.staff_id AS Staff, round(sum(p.amount),0) AS Total_Revenue
	FROM sakila.payment AS p
	JOIN sakila.store AS s
	ON s.manager_staff_id = p.staff_id
	GROUP BY s.store_id
	HAVING s.store_id = param1;
END;
//
DELIMITER ;

# Update the previous query. Declare a variable total_sales_value of float type,
# that will store the returned result (of the total sales amount for the store).
# Call the stored procedure and print the results.

DROP PROCEDURE store_total_sales1;

DELIMITER //
CREATE PROCEDURE store_total_sales1(in param1 int)
BEGIN
	DECLARE Total_sales_value float default 0.0;
	SELECT s.store_id AS Store, p.staff_id AS Staff, round(sum(p.amount),0) AS Total_Revenue
	FROM sakila.payment AS p
	JOIN sakila.store AS s
	ON s.manager_staff_id = p.staff_id
	GROUP BY s.store_id
	HAVING s.store_id = param1;
END
//
DELIMITER ;

CALL store_total_sales1(2);


# In the previous query, add another variable flag. If the total sales value for the store is over 30.000,
# then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes
# an input as the store_id and returns total sales value for that store and flag value.

DROP PROCEDURE store_total_sales2;

DELIMITER //
CREATE PROCEDURE store_total_sales2(in param1 int, out param2 varchar(20))
BEGIN
	DECLARE Total_sales_value float default 0.0;
    DECLARE Flag varchar(50) default ' ';
	SELECT round(sum(p.amount),0) INTO Total_sales_value
	FROM sakila.payment AS p
	JOIN sakila.store AS s
	ON s.manager_staff_id = p.staff_id
	GROUP BY s.store_id
	HAVING s.store_id = param1;

	IF Total_sales_value > 30000 THEN 
		SET Flag = 'GREEN';
    ELSE
		SET Flag = 'RED';
    END IF;

	SELECT Flag INTO param2;
	SELECT param1, Total_sales_value, Flag;
END
//
DELIMITER ;

CALL store_total_sales2(2,@x);