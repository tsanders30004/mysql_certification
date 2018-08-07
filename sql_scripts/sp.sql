delimiter //

DROP PROCEDURE IF EXISTS add_customer;
CREATE PROCEDURE add_customer(IN new_customer varchar(16)) MODIFIES SQL DATA
BEGIN
	DECLARE dupe_key TINYINT DEFAULT 0;
	
	DECLARE CONTINUE HANDLER FOR 1062 
		SET dupe_key = 1;
	
	INSERT INTO customers(customer) values(new_customer);
	IF dupe_key = 0 THEN
		SELECT 'new customer added to customers table';
		SELECT id, customer FROM customers WHERE id = LAST_INSERT_ID();
	ELSEIF dupe_key = 1 THEN
		SELECT 'unique key violation.  customer already exists'; 
		SELECT id, customer FROM customers WHERE customer=new_customer;
	ELSE
		SELECT 'some other bad error occured.';
	END IF;
END//
delimiter ;