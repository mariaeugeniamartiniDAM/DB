DROP TRIGGER IF EXISTS before_orderdetails_insert;

DELIMITER //

CREATE TRIGGER before_orderdetails_insert
BEFORE INSERT ON orderdetails
FOR EACH ROW
BEGIN

	DECLARE stock_disponible INT;
    
    SELECT quantityInStock INTO stock_disponible
    FROM products
    WHERE productCode = NEW.productCode;
    
    IF stock_disponible = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error. El producto solicitado está fuera de stock.';
	
    ELSEIF NEW.quantityOrdered > stock_disponible THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error. La cantidad solicitada excede el stock disponible.';
    END IF;
    
END //

DELIMITER ;

-- 1. Exceder el stock de un articulo disponible. 
UPDATE products SET quantityInStock = 10 WHERE productCode = 's24_2000';

INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (10100, 'S24_2000', 15, 95.34, 1);

-- 2. Intentar comprar un articulo fuera de stock
UPDATE products SET quantityInStock = 0 WHERE productCode = 's24_2000'; -- Forzamos stock a 0 para probarlo

INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (10100, 'S24_2000', 1, 95.34, 1)