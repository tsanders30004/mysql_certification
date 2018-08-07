DELIMITER //

DROP PROCEDURE IF EXISTS demo_sp//

CREATE PROCEDURE demo_sp()
BEGIN
	DECLARE eof					INT DEFAULT 0;
	DECLARE j					INT DEFAULT 0;
	DECLARE my_cursor			CURSOR FOR SELECT i FROM random_ints;
	DECLARE CONTINUE HANDLER 	FOR NOT FOUND SET eof = 0;
	
	OPEN my_cursor;

	WHILE NOT eof DO
		FETCH my_cursor INTO j;
		SELECT j;
	END WHILE;
	
	CLOSE my_cursor;
		
END//

delimiter ;
