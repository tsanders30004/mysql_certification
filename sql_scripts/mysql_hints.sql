# turn general logs on and off
# logs are stored in the DATADIR

show variables like 'general_log%'; 
SET GLOBAL general_log = 'OFF'; 
SET GLOBAL general_log = 'ON';
set global log_output = 'FILE';
set global log_output = 'TABLE';

show variables like 'general_log';
show variables like 'log_output';

CREATE TABLE tbl1(
id int UNSIGNED NOT NULL auto_increment,
f1 varchar(16),
f2 decimal (13, 2),
PRIMARY KEY (id),
FOREIGN KEY (id) REFERENCES tbl2(id),
INDEX(f1)
);

# create table with generated column
CREATE TABLE date_d(
id int UNSIGNED NOT NULL auto_increment,
d date NOT NULL,
y MEDIUMINT UNSIGNED AS (year(d)),	# note that the expression after AS must be enclosed in parentheses
PRIMARY key(id));

# rename a table 
RENAME TABLE old_name TO new_name; 

# add auto_increment primary key field
ALTER TABLE ktr ADD COLUMN id int unsigned NOT NULL AUTO_INCREMENT PRIMARY key first;

# add column
ALTER TABLE revenue_f
CHANGE COLUMN departure_date_id departure_date date;
ALTER TABLE table ADD new_name_field1 type1 FIRST;
ALTER TABLE table ADD new_name_field1 type1 AFTER another_field;

# add generated column
ALTER TABLE date_d
ADD COLUMN y MEDIUMINT UNSIGNED AS (year(d));

# change field order
ALTER TABLE table MODIFY field1 type1 FIRST;
ALTER TABLE table MODIFY field1 type1 AFTER another_field;
ALTER TABLE table CHANGE old_name_field1 new_name_field1 type1 FIRST;
ALTER TABLE table CHANGE old_name_field1 new_name_field1 type1 AFTER another_field;

# add foreign key
ALTER TABLE revenue_f
ADD FOREIGN KEY(flight_id) REFERENCES flights_d(id);

# add index
alter table airlines_d add constraint unique(airline);

# add primary key
ALTER TABLE revenue_f
ADD PRIMARY key(flight_id, pax_id, departure_date);

# add unique constraint
ALTER TABLE my_table ADD CONSTRAINT unique(some_column);

# drop foreign key
ALTER TABLE tbl1
DROP FOREIGN KEY foreign_key_name;

# disable / enable foreign key constraints [untested]
SET FOREIGN_KEY_CHECKS=0;	# to disable
SET FOREIGN_KEY_CHECKS=1;

# explain  type (fastest to slowest)
SYSTEM / COST / EQ_REF / REF / RANGE / INDEX / ALL 

# describe a table with primary and foreign key information
# DROP VIEW tsanders.v_describe;
# CREATE VIEW tsanders.v_describe AS 

CREATE VIEW tsanders.v_describe AS;
SELECT
    c.TABLE_SCHEMA AS db,
    c.TABLE_NAME AS table_name,
    c.COLUMN_NAME AS column_name,
    c.IS_NULLABLE AS is_nullable,
    c.COLUMN_TYPE AS column_type,
        index_name,
    seq_in_index, 
    s.cardinality, 
    sub_part,
    t.CONSTRAINT_TYPE AS constraint_type,
    k.CONSTRAINT_NAME AS constraint_name,
    k.REFERENCED_TABLE_NAME AS referenced_table_name,
    k.REFERENCED_COLUMN_NAME AS referenced_column_name,
    c.EXTRA AS extra
FROM
    (
        (
            information_schema.columns c
        LEFT JOIN information_schema.key_column_usage k ON
            (
                (
                    (
                        c.TABLE_SCHEMA = k.CONSTRAINT_SCHEMA
                    )
                    AND(
                        c.TABLE_NAME = k.TABLE_NAME
                    )
                    AND(
                        c.COLUMN_NAME = k.COLUMN_NAME
                    )
                )
            )
        )
    LEFT JOIN information_schema.table_constraints t ON
        (
            (
                (
                    c.TABLE_SCHEMA = t.TABLE_SCHEMA
                )
                AND(
                    c.TABLE_NAME = t.TABLE_NAME
                )
                AND(
                    k.CONSTRAINT_NAME = t.CONSTRAINT_NAME
                )
            )
        )
    )
    LEFT JOIN information_schema.statistics s ON c.table_schema = s.TABLE_SCHEMA AND c.TABLE_NAME = s.TABLE_NAME AND c.COLUMN_NAME = s.COLUMN_NAME
ORDER BY
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    c.ORDINAL_POSITION;
 
# informatation_schema 
SELECT * FROM information_schema.COLUMNS;
SELECT * FROM information_schema.EVENTS;
SELECT * FROM information_schema.KEY_COLUMN_USAGE;
SELECT * FROM information_schema.PARAMETERS;
SELECT * FROM information_schema.PARTITIONS;
SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS;
SELECT * FROM information_schema.ROUTINES
SELECT * FROM information_schema.PROCESSLIST;
SELECT * FROM information_schema.STATISTICS;	# shows indices
SELECT * FROM information_schema.TABLES;
SELECT * FROM information_schema.TABLE_CONSTRAINTS;
SELECT * FROM information_schema.TRIGGERS;
SELECT * FROM information_schema.USER_PRIVILEGES;
SELECT * FROM information_schema.VIEWS;

# select random integer between two values
SET @min_val = 201;
SET @max_val = 799;
SELECT FLOOR(RAND()*(@max_val-@min_val+1))+@min_val;

# show host i.p. address / host name
SHOW VARIABLES WHERE Variable_name = 'hostname';

# show indices
show index from flights.revenue_f;

# show / kill process(s)
SHOW processlist;
KILL processnumber;

# show users
SELECT * FROM mysql.user;

# create a new user
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

# grant  / revoke
GRANT ALL ON database.* TO 'user'@'localhost';
GRANT ALL PRIVILEGES ON base.* TO 'user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, DELETE ON base.* TO 'user'@'localhost' IDENTIFIED BY 'password';
REVOKE ALL PRIVILEGES ON base.* FROM 'user'@'host'; -- one permission only
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'user'@'host'; -- all permissions
SET PASSWORD = PASSWORD('new_pass');
SET PASSWORD FOR 'user'@'host' = PASSWORD('new_pass');
SET PASSWORD = OLD_PASSWORD('new_pass');
DROP USER 'user'@'host';

# add tsanders user to wheel group on macos [type this exactly; replace tsanders with a different user name if necessary]
sudo dscl . -append /Groups/wheel GroupMembership tsanders 

# predominant data types
TINYINT	(-128, 128)	
SMALLINT	(-32768, 32767)	
MEDIUMINT	(-8388608 , 8388607)	
INT	(-2147483648 , 2147483647 )	
BIGINT	(-9223372036854775808 , 92233720368)	
FLOAT		
DOUBLE		
DATE		
TIME		
DATETIME		
TIMESTAMP		
ENUM		
CHAR		
VARCHAR		

# select random dates between two dates
SET @MIN = '2018-01-01 00:00:00';
SET @MAX = '2018-12-31 00:00:00';
SELECT cast(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN) AS date) AS random_date;

# select random time between two times
SET @min_time='05:00:00';
SET @max_time='06:00:00';
SELECT SEC_TO_TIME(FLOOR(TIME_TO_SEC(@min_time) + RAND() * (TIME_TO_SEC(TIMEDIFF(@max_time, @min_time)))));
        

# generate a random phone number 
SET @min_val = 201;
SET @max_val = 799;
SELECT concat(FLOOR(RAND()*(@max_val-@min_val+1))+@min_val, '-', FLOOR(RAND()*(@max_val-@min_val+1))+@min_val, '-', left(1000*FLOOR(RAND()*(@max_val-@min_val+1))+@min_val, 4));

# dump a database
mysqldump -u [username] -p [database] > db_backup.SQL

# import data
load data local infile 'C:/Users/tsanders/Desktop/temp/ktr.csv'
into table ktr
fields terminated by ','
lines terminated by '\n'
ignore 1 lines;

# export data
SELECT column_name FROM table_name 
INTO OUTFILE '/tmp/outfile.csv' 
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n';


# describe a table with key information
# DROP VIEW tsanders.v_describe;
# CREATE VIEW tsanders.v_describe AS 
SELECT c.table_schema AS db, c.table_name, c.column_name, is_nullable, column_type, constraint_type, k.constraint_name, k.referenced_table_name, k.referenced_column_name, extra
FROM information_schema.columns c
LEFT JOIN information_schema.key_column_usage k
ON c.table_schema = k.constraint_schema
AND c.table_name = k.table_name
AND c.column_name = k.column_name
LEFT JOIN information_schema.TABLE_CONSTRAINTS t
ON c.TABLE_SCHEMA = t.TABLE_SCHEMA
AND c.TABLE_NAME = t.TABLE_NAME
AND k.CONSTRAINT_NAME = t.CONSTRAINT_NAME
ORDER BY c.table_schema, c.table_name, if(constraint_type='PRIMARY KEY', 1, if(constraint_type='FOREIGN KEY', 2, 3)), c.ordinal_position;

# sample stored procedure with cursor
delimiter //
CREATE PROCEDURE mysql_programming.update_usage()
BEGIN
	DECLARE d1	date;
	DECLARE d2	date;
	DECLARE r1	bigint;
	DECLARE r2	bigint;
	DECLARE c1	CURSOR FOR SELECT read_date, reading FROM reading_f;
		
	FETCH c1 INTO d1, r1;

	loop1:
		LOOP
			FETCH c1 INTO d2, r2;
			IF cast(d2 AS date)-cast(d1 AS date) = 1 THEN
				INSERT IGNORE INTO usage_f(usage_date, usage_amount) values(d1, r2-r1);
			END IF;
			SET d1 = d2;
			SET r1 = r2;
		END LOOP loop1;
	CLOSE c1;
	SELECT * FROM usage_f;
END;//
delimiter ;

# another cursor example
delimiter //
CREATE PROCEDURE sp_example4()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE vr_name VARCHAR(100);
    DECLARE cur1 CURSOR FOR SELECT username FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    -- now we open the cursor
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO vr_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- now do something with the return, vr_name.
    END LOOP;
    CLOSE cur1;
END;//
delimiter ;

# sample procedure with while loop
delimiter //
CREATE PROCEDURE create_flight_data()
BEGIN
	DECLARE i	int;
	SET i = 1;
	WHILE i <= 1000 DO
		INSERT IGNORE flights_d(airline_id, aircraft_id, departure_id, arrival_id, flight_no) values(
			rand_between(1, 32), 
			rand_between(1, 18), 
			rand_between(1, 4431), 
			rand_between(1, 16), 
			rand_between(1, 1000));
			SET i = i + 1;
	END WHILE;
END;//
delimiter ;

# sample function
CREATE FUNCTION get_column_value(str text, d varchar(1), n int) 
RETURNS text 
DETERMINISTIC
BEGIN
	DECLARE start_pos 		int;
	DECLARE end_pos			int;

	SET start_pos = LENGTH(SUBSTRING_INDEX( str, d, n ))+ 2;
	SET end_pos = LENGTH(SUBSTRING_INDEX( str, d, n + 1 ))+ 1;

	IF n = 0 THEN
		RETURN left(str, end_pos-1);
	ELSE 
		RETURN SUBSTRING( str, start_pos, end_pos - start_pos );
	END IF;
END;

# select into a variable in a stored procedure
CREATE PROCEDURE sp_example2()
BEGIN
  DECLARE my_var VARCHAR(511); 

  SELECT username FROM users WHERE id=4 INTO my_var;
END;

# combine date and time into timestamp
SELECT timestamp(departure_date,departure_time)

# repair databases after unclean shutdown
mysqlcheck --all-databases
mysqlcheck --all-databases --fast

# reset root password
$ /etc/init.d/mysql stop
$ mysqld_safe --skip-grant-tables
$ mysql # on another terminal
mysql> UPDATE mysql.user SET password=PASSWORD('new_pass') WHERE user='root';
## Switch back to the mysqld_safe terminal and kill the process using Control + \
$ /etc/init.d/mysql START

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

USE flights;

SELECT * 
FROM tsanders.v_describe
WHERE db = 'flights'
AND table_name = 'flights_d';

SHOW INDEX FROM flights_d;

SELECT * FROM v_flight_schedule;
EXPLAIN SELECT * FROM v_flight_schedule;

ALTER TABLE flights_d 
DROP INDEX airline_id;

ALTER TABLE flights_d
DROP FOREIGN KEY flights_d_ibfk_1,
DROP FOREIGN KEY flights_d_ibfk_4,
DROP FOREIGN KEY flights_d_ibfk_2,
DROP FOREIGN KEY flights_d_ibfk_3;

ALTER TABLE flights_d
ADD FOREIGN KEY (airline_id) REFERENCES airlines_d(id),
ADD FOREIGN KEY(departure_id) REFERENCES cities_d(id),
ADD FOREIGN KEY(arrival_id) REFERENCES cities_d(id),
ADD FOREIGN KEY(aircraft_id) REFERENCES aircraft_d(id);

SHOW tables;

DROP TABLE fname;

DESCRIBE FIRST;

ALTER TABLE last  ADD COLUMN id bigint UNSIGNED;

SELECT CAST (rand()*10000 AS int);

DESCRIBE LAST;
UPDATE first SET id = FLOOR(RAND()*(1000-1+1))+1;

ALTER TABLE first ADD index(id);

SELECT firstname, lastname
FROM FIRST JOIN LAST using(id)
LIMIT 10;

DELETE FROM last WHERE lastname = 'lastname';

SELECT * FROM FIRST
ORDER BY id
LIMIT 10;




SELECT * FROM LAST;

CREATE TEMPORARY TABLE fuck AS SELECT firstname, lastname
FROM FIRST 
JOIN LAST USING (id) ORDER BY rand();

SELECT * FROM fuck LIMIT 10;

INSERT INTO pax_d(fname, lname) SELECT firstname, lastname FROM fuck LIMIT 1000;

SELECT * FROM pax_d LIMIT 10;

DROP TABLE LAST;
DROP TABLE FIRST;

SHOW tables;

SELECT * FROM pax_d;


SHOW tables;

DROP TABLE fname;
DROP TABLE lname;

SELECT FLOOR(RAND()*(799-200+1))+1;

SET @min_val = 201;
SET @max_val = 799;
SELECT FLOOR(RAND()*(@max_val-@min_val+1))+@min_val;

SELECT 


SELECT concat(FLOOR(RAND()*(@max_val-@min_val+1))+@min_val, '-', FLOOR(RAND()*(@max_val-@min_val+1))+@min_val, '-', left(1000*FLOOR(RAND()*(@max_val-@min_val+1))+@min_val, 4));

SELECT * FROM pax_d;

SELECT * FROM flights_d;

SELECT * FROM cities_d;


SELECT * FROM airports where code = 'ATL' LIMIT 10;

DESCRIBE cities_d;

INSERT IGNORE  INTO cities_d(city_code) SELECT DISTINCT code FROM airports;

SELECT * FROM cities_d;

SHOW variables LIKE 'datadir%';

DESCRIBE airlines_d;

USE flights;


DESCRIBE airlines_d;

ALTER TABLE airlines_d
CHANGE COLUMN id id int UNSIGNED NOT NULL auto_increment;

DESC flights_d;

SELECT * 
FROM tsanders.v_describe
WHERE db='flights';

ALTER TABLE flights_d
ADD FOREIGN KEY(airline_id) REFERENCES airlines_d(id);

insert ignore into airlines_d(airline, iata_code) values('Aloha Airlines','AQ');
insert ignore into airlines_d(airline, iata_code) values('American Airlines','AA');
insert ignore into airlines_d(airline, iata_code) values('America West Airlines','HP');
insert ignore into airlines_d(airline, iata_code) values('Air Midwest','ZV');
insert ignore into airlines_d(airline, iata_code) values('Atlas Air','5Y');
insert ignore into airlines_d(airline, iata_code) values('AirTran Airways','FL');
insert ignore into airlines_d(airline, iata_code) values('Braniff International Airways','BN');
insert ignore into airlines_d(airline, iata_code) values('Continental Airlines','CO');
insert ignore into airlines_d(airline, iata_code) values('Delta Air Lines','DL');
insert ignore into airlines_d(airline, iata_code) values('Eastern Airlines','EA');
insert ignore into airlines_d(airline, iata_code) values('Federal Express','FX');
insert ignore into airlines_d(airline, iata_code) values('Hawaiian Airlines','HA');
insert ignore into airlines_d(airline, iata_code) values('JetBlue Airways','B6');
insert ignore into airlines_d(airline, iata_code) values('Kiwi International Air Lines','KP');
insert ignore into airlines_d(airline, iata_code) values('Northwest Airlines','NW');
insert ignore into airlines_d(airline, iata_code) values('Pan American World Airways','PA');
insert ignore into airlines_d(airline, iata_code) values('Trans World Airlines','TW');
insert ignore into airlines_d(airline, iata_code) values('United Airlines','UA');
insert ignore into airlines_d(airline, iata_code) values('US Airways','US');
insert ignore into airlines_d(airline, iata_code) values('Virgin America','VX');
insert ignore into airlines_d(airline, iata_code) values('Western Airlines','WA');
insert ignore into airlines_d(airline, iata_code) values('World Airways','WO');

SELECT * FROM airlines_d;

SELECT * FROM cities_d;

SELECT * FROM aircraft_d;

SELECT * FROM flights_d;

SELECT min(id), max(id) from flights_d;


drop FUNCTION rand_between;

delimiter //
CREATE FUNCTION rand_between(min_val int, max_val int) 
RETURNS int 
DETERMINISTIC
BEGIN
	RETURN FLOOR(RAND()*(max_val-min_val+1))+min_val;
END;//
delimiter ;



CREATE FUNCTION get_column_value(str text, d varchar(1), n int) 
RETURNS text 
DETERMINISTIC
BEGIN
	DECLARE start_pos 		int;
	DECLARE end_pos			int;

	SET start_pos = LENGTH(SUBSTRING_INDEX( str, d, n ))+ 2;
	SET end_pos = LENGTH(SUBSTRING_INDEX( str, d, n + 1 ))+ 1;

	IF n = 0 THEN
		RETURN left(str, end_pos-1);
	ELSE 
		RETURN SUBSTRING( str, start_pos, end_pos - start_pos );
	END IF;
END;


SELECT * FROM flights_d;

INSERT IGNORE flights_d(airline_id, aircraft_id, departure_id, arrival_id, flight_no) values(
rand_between(1, 32), 
rand_between(1, 18), 
rand_between(1, 4431), 
rand_between(1, 16), 
rand_between(1, 1000)
);

SELECT * FROM flights_d;

SELECT * FROM v_flight_schedule;




delimiter //
CREATE PROCEDURE create_flight_data()
BEGIN
	DECLARE i	int;
	SET i = 1;
	WHILE i <= 1000 DO
		INSERT IGNORE flights_d(airline_id, aircraft_id, departure_id, arrival_id, flight_no) values(
			rand_between(1, 32), 
			rand_between(1, 18), 
			rand_between(1, 4431), 
			rand_between(1, 16), 
			rand_between(1, 1000));
			SET i = i + 1;
	END WHILE;
END;//
delimiter ;

CALL create_flight_data();

SHOW processlist;

SELECT count(*) FROM flights_d;

SELECT * FROM v_flight_schedule LIMIT 100;



SET @min_time='05:00:00';
SET @max_time='06:00:00';
SELECT SEC_TO_TIME(FLOOR(TIME_TO_SEC(@min_time) + RAND() * (TIME_TO_SEC(TIMEDIFF(@max_time, @min_time)))));




# sample procedure with while loop
delimiter //
CREATE PROCEDURE create_date_d()
BEGIN
	DECLARE i	int;
	SET i = 1;
	WHILE i <= 1000 DO
	INSERT INTO date_d(d) values(@some_date);
	END WHILE;
END;//
delimiter ;

SET @MIN = '2018-01-01 00:00:00';
SET @MAX = '2018-12-31 00:00:00';
INSERT INTO date_d(d) values(random_date(@min, @max));

SELECT * FROM mysql.proc
WHERE name LIKE '%rand%';



INSERT INTO date_d(d) values(cast(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN) AS date) AS random_date;);

SET @MIN = '2018-01-01 00:00:00';
SET @MAX = '2018-12-31 00:00:00';
SET @MAX = '2018-12-31 00:00:00';
SELECT cast(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN) AS date);


INSERT INTO date_d(d) values(cast(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN) AS date));

SELECT count(*) FROM date_d;




DROP PROCEDURE create_date_d;
delimiter //
CREATE PROCEDURE create_date_d()
BEGIN
	DECLARE i	int;
	DECLARE my_date date;
	SET i = 1;
	SET my_date = '2018-1-1';
	WHILE i <= 31 DO
		INSERT IGNORE INTO date_d(d) values(my_date);
		SET my_date = adddate(my_date, INTERVAL 1 day);
		SET i = i + 1;
	END WHILE;
END;//
delimiter ;

CALL create_date_d();

SELECT * FROM date_d;

SELECT d1.d, d2.d 
FROM date_d d1
JOIN date_d d2 ON d1.d = d2.d
WHERE d1.id != d2.id;

DESCRIBE date_d;

DELETE FROM date_d;

ALTER TABLE date_d
ADD unique(d);

SELECT cast(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN) AS date);

SET @my_date = '2018-2-1';

SELECT quarter(@my_date);

SELECT adddate(@my_date, INTERVAL 1 day);

CALL create_date_d();

UPDATE date_d SET d = '2010-2-1' WHERE id = 2733;

DELETE FROM date_d WHERE id = 2733;

SELECT * FROM date_d ORDER BY id DESC;
DELETE FROM date_d WHERE y != 2018;

SELECT count(*) FROM date_d;

SELECT * FROM date_d ORDER BY d;

DESCRIBE date_d;

EXPLAIN SELECT count(*) FROM date_d WHERE m=3;

ALTER TABLE date_d 
ADD index(q);

alter TABLE date_d
CHANGE COLUMN y y MEDIUMINT UNSIGNED NOT NULL AS year(d);

EXPLAIN SELECT * FROM date_d WHERE m=3;

RENAME TABLE date_d TO dates_d;

DESCRIBE dates_d;

SHOW tables;

SELECT * FROM airports_d LIMIT 10;

SELECT min(length(code)) FROM airports_d;

DESCRIBE airports_d;
ALTER TABLE airports_d
DROP COLUMN citycode;

RENAME TABLE airports_d TO airports_x;

EXPLAIN SELECT * FROM pax_d
WHERE lname like 'sander%';

SELECT * FROM tsanders.v_describe
WHERE table_name='pax_d';

DESCRIBE pax_d;

ALTER TABLE pax_d
DROP INDEX lname,
DROP INDEX lname_2, 
DROP INDEX lname_3;

SHOW indexes FROM pax_d;

SHOW tables FROM information_schema;

SELECT * FROM information_schema.STATISTICS
WHERE table_name = 'pax_d';


USE tsanders;

SELECT database();
drop VIEW tsanders.v_describe;

CREATE VIEW tsanders.v_describe AS
SELECT
    c.TABLE_SCHEMA AS db,
    c.TABLE_NAME AS table_name,
    c.COLUMN_NAME AS column_name,
    c.IS_NULLABLE AS is_nullable,
    c.COLUMN_TYPE AS column_type,
        index_name,
    seq_in_index, 
    s.cardinality, 
    sub_part,
    t.CONSTRAINT_TYPE AS constraint_type,
    k.CONSTRAINT_NAME AS constraint_name,
    k.REFERENCED_TABLE_NAME AS referenced_table_name,
    k.REFERENCED_COLUMN_NAME AS referenced_column_name,
    c.EXTRA AS extra
FROM
    (
        (
            information_schema.columns c
        LEFT JOIN information_schema.key_column_usage k ON
            (
                (
                    (
                        c.TABLE_SCHEMA = k.CONSTRAINT_SCHEMA
                    )
                    AND(
                        c.TABLE_NAME = k.TABLE_NAME
                    )
                    AND(
                        c.COLUMN_NAME = k.COLUMN_NAME
                    )
                )
            )
        )
    LEFT JOIN information_schema.table_constraints t ON
        (
            (
                (
                    c.TABLE_SCHEMA = t.TABLE_SCHEMA
                )
                AND(
                    c.TABLE_NAME = t.TABLE_NAME
                )
                AND(
                    k.CONSTRAINT_NAME = t.CONSTRAINT_NAME
                )
            )
        )
    )
    LEFT JOIN information_schema.statistics s ON c.table_schema = s.TABLE_SCHEMA AND c.TABLE_NAME = s.TABLE_NAME AND c.COLUMN_NAME = s.COLUMN_NAME
ORDER BY
    c.TABLE_SCHEMA,
    c.TABLE_NAME,
    c.ORDINAL_POSITION;
    
    USE DATABASE flights;
    
    USE flights;


SELECT * FROM tsanders.v_describe WHERE table_name = 'pax_d';
SELECT * FROM tsanders.v_describe WHERE table_name = 'flights_d';

EXPLAIN SELECT * FROM pax_d WHERE lname LIKE 'B%';

SELECT left(lname, 1), count(*) 
FROM pax_d
GROUP BY left(lname, 1);

DROP TABLE f_d;
CREATE TABLE f_d(
id				int UNSIGNED		NOT NULL	auto_increment,
airline			char(2)				NOT NULL,
flight_no		SMALLINT UNSIGNED	NOT NULL, 
departure		char(3)				NOT NULL,
arrival			char(3)				NOT NULL,
flight_duration	TIME				NOT NULL,
departure_time	TIME				NOT NULL,
arrival_time	TIME AS (addtime(departure_time, flight_duration)),
PRIMARY key(id));

DESCRIBE f_d;

ALTER TABLE f_d 
ADD FOREIGN key(departure) REFERENCES airports_x(airport_code);

FOREIGN KEY(departure) REFERENCES airports_x(airport_code),
FOREIGN KEY(arrival) REFERENCES airports_x(airport_code));

# create table with generated column
CREATE TABLE date_d(
id int UNSIGNED NOT NULL auto_increment,
d date NOT NULL,
y MEDIUMINT UNSIGNED AS (year(d)),
PRIMARY key(id));

DESCRIBE airports_x;





CREATE temparary TABLE x(
x double, 
y double,
z double AS x);

SET @my_dep = '23:10:11';
SET @my_dur = '10:10:00';
SELECT @my_dep, @my_dur, addtime(@my_dur, @my_dep), addtime(@my_dep, @my_dur);



SELECT * FROM dates_d;

SELECT * FROM pax_d;

SELECT * FROM f_d;

INSERT INTO f_d(airline, flight_no, departure, arrival, departure_ti)





# select random integer between two values
SET @min_val = 201;
SET @max_val = 799;
SELECT FLOOR(RAND()*(@max_val-@min_val+1))+@min_val;

# select random dates between two dates
SET @MIN = '2018-01-01 00:00:00';
SET @MAX = '2018-12-31 00:00:00';
SELECT cast(TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN) AS date) AS random_date;

# select random time between two times
SET @min_time='05:00:00';
SET @max_time='06:00:00';
SELECT SEC_TO_TIME(FLOOR(TIME_TO_SEC(@min_time) + RAND() * (TIME_TO_SEC(TIMEDIFF(@max_time, @min_time)))));
        

DROP FUNCTION random_time;

delimiter //
CREATE FUNCTION random_time(t1 time, t2 time) 
RETURNS time
DETERMINISTIC
BEGIN
	RETURN SEC_TO_TIME(FLOOR(TIME_TO_SEC(t1) + RAND() * (TIME_TO_SEC(TIMEDIFF(t2, t1)))));
END; //
delimiter ;

SELECT random_date('2018-01-01', '2018-12-31');
SELECT random_time('05:00:00', '06:00:00');

SELECT * FROM mysql.proc WHERE db='flights';

SELECT 'DL',
rand_between(12,2999), 
'ATL', 
'CDG', 
random_time('01:00:00', '14:00:00'), # flight duration
random_time('05:00:00', '23:59:00'); # departure_time



INSERT INTO f_d(airline, flight_no, departure, arrival, flight_duration, departure_time) 
SELECT 'DL', rand_between(12,2999), 'ATL', 'CDG', random_time('01:00:00', '14:00:00'), random_time('05:00:00', '23:59:00');

SELECT * FROM f_d;
DELETE FROM f_d WHERE arrival_time IS NULL;




DROP PROCEDURE create_f_d;

delimiter //
CREATE PROCEDURE create_f_d()
BEGIN
	DECLARE i	int;
	SET i = 1;
	WHILE i <= 100 DO
		INSERT INTO f_d(airline, flight_no, departure, arrival, flight_duration, departure_time) SELECT 'DL', rand_between(12,2999), 'ATL', 'CDG', random_time('01:00:00', '14:00:00'), random_time('05:00:00', '23:59:00');
		SET i = i + 1;
	END WHILE;
END;//
delimiter ;

CALL create_f_d();

SELECT count(*) FROM f_d;
DELETE FROM f_d WHERE arrival_time IS NULL;
SELECT * FROM f_d ORDER BY arrival_time;
UPDATE f_d
SET airline = NULL;

UPDATE f_d 
SET arrival='MSP' WHERE arrival = 'MIZ';
rand() <= 0.2;

SELECT arrival, count(*) 
FROM f_d 
GROUP BY arrival;

SELECT * FROM f_d;

ALTER TABLE f_d
ADD index(aircraft);

UPDATE f_d
SET aircraft='767'

UPDATE f_d
SET aircraft='380'
WHERE rand() < 0.2;

SELECT *
FROM tsanders.v_describe
WHERE table_name = 'revenue_f'
AND index_name != 'PRIMARY';

DROP TABLE flights_d;
SHOW tables;
DELETE FROM flights_d;
SELECT * FROM flights_d;
DELETE FROM flights_d WHERE id >= 1;

DROP TABLE airlines_d;


ALTER TABLE flights_d
DROP constraint 'flights_d_ibfk_5';
'flights_d_ibfk_4'
'flights_d_ibfk_2'
'flights_d_ibfk_3'


ALTER TABLE revenue_f
DROP FOREIGN KEY revenue_f_ibfk_1;

RENAME TABLE f_d TO flights_d;

ALTER TABLE revenue_f
ADD FOREIGN key(flight_id) REFERENCES flights_d(id);



DELETE FROM revenue_f;
DESCRIBE revenue_f;

SELECT * FROM revenue_f;

SELECT min(id), max(id)
FROM pax_d;


INSERT IGNORE INTO revenue_f(flight_id, pax_id, departure_date, return_date, fare) values(
rand_between(111, 310),
rand_between(1, 1008),
random_date('2018-01-01', '2018-03-31'),
random_date('2018-03-31', '2018-06-30'),
rand()*1000
);

SELECT * FROM revenue_f;

SELECT * FROM v_flight_schedule;

SELECT * FROM flights_d;

DROP VIEW v_flight_schedule;

SELECT * FROM pax_d;

SELECT * FROM revenue_f;

EXPLAIN SELECT lname, fname, airline, flight_no, departure, arrival, departure_date, d1.y, d1.m, d1.q, departure_time, return_date, d2.y, d2.m, d2.q, arrival_time, fare
FROM revenue_f	r
JOIN flights_d	f ON r.flight_id = f.id
JOIN pax_d		p ON r.pax_id = p.id
JOIN dates_d	d1 ON r.departure_date = d1.d
JOIN dates_d	d2 ON r.return_date = d2.d;

ALTER TABLE revenue_f
ADD index(departure_date);

SELECT * FROM v_describe WHERE table_name = 'revenue_f';


SELECT * FROM tsanders.v_describe WHERE table_name='revenue_f';