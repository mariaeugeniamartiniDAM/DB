DROP FUNCTION IF EXISTS customer_summary;

DELIMITER //

CREATE FUNCTION customer_summary(p_customerNumber INT)
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_orderCount INT;
    DECLARE v_productCount INT;
    DECLARE v_result VARCHAR(255);
    
    SELECT COUNT(*) INTO v_orderCount
    FROM orders
    WHERE customerNumber = p_customerNumber;
    
    SELECT COUNT(DISTINCT od.productCode) INTO v_productCount
    FROM orderdetails od
    JOIN orders o ON od.orderNumber = o.orderNumber
    WHERE o.customerNumber = p_customerNumber;
    
    IF v_orderCount = 0 THEN
		SET v_result = 'No orders or products'; 
	ELSE 
		SET v_result = CONCAT(v_orderCount, ' order/s and ', v_productCount,  ' product/s');
	END IF;
    
    RETURN v_result;
    
END //

DELIMITER ;

SELECT customer_summary(103);

SELECT customer_summary(999);

SELECT customerNumber, customerName, customer_summary(customerNumber) AS summary
FROM customers
ORDER BY customerNumber;