DELIMITER //

DROP PROCEDURE IF EXISTS demo_sp//

CREATE PROCEDURE demo_sp()
BEGIN
	DECLARE eof					INT DEFAULT 0;	/* assume eof false */
	DECLARE j					INT DEFAULT 0;
	DECLARE my_cursor			CURSOR FOR SELECT i FROM random_ints limit 3;
	DECLARE CONTINUE HANDLER 	FOR NOT FOUND SET eof = 1;
	
	OPEN my_cursor;
	
	/* efficient example of a cursor using a while loop */
	while1:
	WHILE NOT eof DO
		
		FETCH my_cursor INTO j;
		
		/* this IF statement is required; it omitted, the last row in the table will be shown twice. */
		IF eof THEN
			LEAVE while1;
		END IF;
		
		SELECT j;
		
	END WHILE while1;
	
	CLOSE my_cursor;
END//

delimiter ;
