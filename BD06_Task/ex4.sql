DROP PROCEDURE IF EXISTS delete_employee;

DELIMITER //

CREATE PROCEDURE delete_employee(IN p_employeeNumber INT)
BEGIN
	DECLARE v_supervisorId INT;
    DECLARE v_employeeName VARCHAR (100);
    DECLARE v_supervisorName VARCHAR (100);
    DECLARE v_exists INT;
    DECLARE v_finalMessage TEXT;
    
    SELECT COUNT(*)
    INTO v_exists
    FROM employees 
    WHERE employeeNumber = p_employeeNumber;

    IF v_exists = 0 THEN 
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error. The employee number does not exist';
	END IF;
    
    SELECT 
        CONCAT(e1.firstName, ' ', e1.lastName), 
        e1.reportsTo, 
        CONCAT(e2.firstName, ' ', e2.lastName)
    INTO v_employeeName, v_supervisorId, v_supervisorName
    FROM employees e1
    LEFT JOIN employees e2 ON e1.reportsTo = e2.employeeNumber
    WHERE e1.employeeNumber = p_employeeNumber;
    
    IF v_supervisorId IS NULL THEN -- Check if it's the president
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error. The employee is the President and cannot be deleted';
    ELSE
		-- Reassignments
		UPDATE customers
        SET salesRepEmployeeNumber = v_supervisorId
        WHERE salesRepEmployeeNumber = p_employeeNumber;
        
        UPDATE employees
        SET reportsTo = v_supervisorId
        WHERE reportsTo = p_employeeNumber;
        
        DELETE FROM employees WHERE employeeNumber = p_employeeNumber;
        
        -- Construction of the final message, when succesfully deletion is complete
        SET v_finalMessage = CONCAT(
			'Customers managed by ', v_employeeName, ' (', p_employeeNumber, '), ',
            'are now managed by ', v_supervisorName, ' (', v_supervisorId, '). ',
            'Employees managed by ', v_employeeName, ' (', p_employeeNumber, '), ',
            'are now managed by ', v_supervisorName, ' (', v_supervisorId, ') --> ',
            v_employeeName, ' (', p_employeeNumber, ') deleted successfully!'
        );
        
        SELECT v_finalMessage AS 'Result';
	END IF;
END // 

DELIMITER ;

CALL delete_employee(1002);

CALL delete_employee(1143);