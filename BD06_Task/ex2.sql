DROP TRIGGER IF EXISTS before_order_insert;

DELIMITER //

CREATE TRIGGER before_order_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN

	DECLARE active_orders_count INT;
    
    SELECT COUNT(*) INTO active_orders_count
    FROM orders
    WHERE customerNumber = NEW.customerNumber
		AND status IN ('In Process', 'On Hold', 'Shipped');
	
    IF active_orders_count >= 3 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error. El cliente ya tiene 3 pedidos activos. No puede crearse uno nuevo.';    
    END IF;

END //

DELIMITER ;

SELECT COUNT(*) FROM orders 
WHERE customerNumber = 103 AND status IN ('In Process', 'On Hold', 'Shipped');

INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES ('1222', '2005-05-29', '2005-06-07', NULL, 'In Process', NULL, '103');

