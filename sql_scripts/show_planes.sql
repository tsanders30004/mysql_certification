drop procedure if exists show_planes;
delimiter //
create procedure show_planes()
begin
	declare ac_model smallint;
	declare ac_name varchar(16);
	declare eof tinyint default 0;
		
	declare aircraft_cursor CURSOR FOR SELECT model, `name` FROM aircraft ORDER BY model;
	/* handlers must be declared after handlers */
	declare continue handler for 1329 
	BEGIN
		set eof = 1;
		/* SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 1329, MESSAGE_TEXT = 'FETCHED PAST END OF TABLE';  */
	END;
	
	OPEN aircraft_cursor;
    
	aircraft_loop:
	LOOP
		FETCH FROM aircraft_cursor INTO ac_model, ac_name;
		
		IF eof THEN 
			SELECT 'fetched past end of cursor.';
			LEAVE aircraft_loop;
		END IF;
		
		SELECT ac_model, ac_name;
				
	END LOOP aircraft_loop;
		
end//
delimiter ;
