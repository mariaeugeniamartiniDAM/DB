DROP PROCEDURE IF EXISTS customers_sales_report;

DELIMITER // 

CREATE PROCEDURE customers_sales_report(
	IN p_officeName VARCHAR (50),
    IN p_yearParameter INT,
    OUT p_report LONGTEXT
)

BEGIN 
	SELECT GROUP_CONCAT(
		CONCAT (
			'** Employee: ', v.reportEmployee,
            '** Customer: ', v.reportCustomer, 
            '** Total Sales: ', FORMAT(v.totalSales, 2)
        )
        ORDER BY v.reportEmployee, v.reportCustomer
        SEPARATOR '\n'
    ) INTO p_report
    FROM (
		SELECT 
			CONCAT(e.firstName, ' ', e.lastName) AS reportEmployee,
            c.customerName AS reportCustomer,
            SUM(od.quantityOrdered * od.priceEach) AS totalSales
		FROM offices o
		JOIN employees e ON o.officeCode = e.officeCode
		JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
		JOIN orders ord ON c.customerNumber = ord.customerNumber
		JOIN orderdetails od ON ord.orderNumber = od.orderNumber
		WHERE o.city = p_officeName
			AND YEAR(ord.orderDate) = p_yearParameter
		GROUP BY e.employeeNumber, c.customerNumber
	) AS v;
    
    IF p_report IS NULL THEN
		SET p_report = CONCAT('No sales data available for office "', p_officeName, '" in year ', p_yearParameter, '.');
	END IF;

END //

DELIMITER ;

-- Caso 1. Oficina existente con ventas ese año
SET @report = ' ';
CALL customers_sales_report('London', 2005, @report);
SELECT @report AS informeFinal;

-- Caso 2. Oficina o año sin datos.
SET @report = ' ';
CALL customers_sales_report('London', 2025, @report);
SELECT @report AS informeFinal;
