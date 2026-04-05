DROP TRIGGER IF EXISTS before_employee_insert;

DELIMITER //

CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
	IF NEW.jobTitle LIKE 'Sale_ Manager%' THEN
		IF EXISTS (
			SELECT 1
            FROM employees
            WHERE officeCode = NEW.officeCode
				AND jobTitle LIKE 'Sale_ Manager%'
        ) THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error. Ya existe un Sales Manager en esta oficina';
		END IF;
	END IF;
END //

DELIMITER ;

INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES (8001, 'Lopez', 'Maria', 'x123', 'mlopez@classic.com', '1', 1002, 'Sales Rep');

INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES (9001, 'Lopez', 'Maria', 'x123', 'mlopez@classic.com', '1', 1002, 'Sales Manager');