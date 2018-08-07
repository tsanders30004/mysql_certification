drop procedure if exists rollback_demo;
delimiter //
create procedure rollback_demo()
begin
	declare exit handler for 1062 
	begin
		select 'rollback!';
		rollback;
	end;
	
	/* 
	mysql [localhost] [stored_procs] select * from aircraft order by model;
	+----+-------+--------------+
	| id | model | name         |
	+----+-------+--------------+
	| 10 |   300 | Airbus A-300 |
	|  2 |   340 | Airbus A-340 |
	|  3 |   727 | Boeing 727   |
	|  9 |   737 | Boeing 737   |
	|  1 |   757 | Boeing 757   |
	+----+-------+--------------+
	
	The 747 is not in the table but the 757 is.  
	Neither of the inserts below will work; the 747 insert will succeed at first.  
	But the 757 will fail since it is already in the table.
	That will fire the exit handler and the transaction will be rolled back.
	*/
	start transaction;
		insert into aircraft(model, name) values (747, 'Boeing 747');
		select 'after insert 1';
		insert into aircraft(model, name) values (757, 'Boeing 757-200');
		select 'after insert 2';
	commit;
end//
delimiter ;