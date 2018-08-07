drop procedure if exists lock_test;
delimiter //
create procedure lock_test()
begin
	declare i bigint unsigned default 1;
	start transaction;
		select now();
		repeat
			set i = i + 1;
			select i;
			update aircraft set model = 727 where id=1;
		until i = 10000 end repeat;
		select now();
	commit;
end//
delimiter ;

