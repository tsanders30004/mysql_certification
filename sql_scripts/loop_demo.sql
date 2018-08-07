drop procedure if exists loop_demo;
delimiter //
create procedure loop_demo()
begin
	declare i int default 0;
	declare j int default 0;
	declare k int default 0;
	
	/* repeat demo */
	repeat
		select i;
		set i = i + 1;
	until i = 3 end repeat;
	
	/* while demo */
	while j < 4 do
		select j;
		set j = j + 1;
	end while;
	
end//
delimiter ;
