CREATE DATABASE study_db;

USE study_db;

#	MySQL 5.7 Spatial Data Types

CREATE TABLE t_spatial(
geo		geometry,
pnt		point,
ls		linestring,
pg		polygon,
m_pnt	multipoint,
m_ls	multilinestring,
m_pg	multipolygon,
geo_c	geometrycollection
);

DESC t_spatial;

#	spatial data insert statements via ST_GeonFromText()
INSERT INTO t_spatial(pnt) 	values(ST_GeomFromText('POINT(1 1)'));

INSERT INTO t_spatial(ls) 	values(ST_GeomFromText('LINESTRING(0 0, 1 1, 2 2)'));		

INSERT INTO t_spatial(pg)	values(ST_GeomFromText('POLYGON(
	(0 0, 	10 0, 	10 10, 	0 10,	 0 0),
	(5 5,	7 5,	7 7,	5 7,	5 5)
)'));	# polygon with one outer and one inner ring

INSERT INTO t_spatial(geo_c) values(
	ST_GeomFromText(
		'GEOMETRYCOLLECTION(
			POINT(1 1),
			LINESTRING(0 0,		1 1,	2 2,	3 3,	4 4)
		)'
	)
);

#	spatial data insert statements via specific functions
INSERT INTO t_spatial(pnt) 	values(ST_PointFromText('POINT(1 1)'));
INSERT INTO t_spatial(ls)  	values(ST_LineStringFromText('LINESTRING(0 0,	1 1,	2 2)'));

INSERT INTO t_spatial(pg)	values(ST_PolygonFromText('POLYGON(
	(0 0, 	10 0, 	10 10, 	0 10,	 0 0),
	(5 5,	7 5,	7 7,	5 7,	5 5)
)'));

INSERT INTO t_spatial(geo_c)	values(ST_GeomCollFromText('
	GEOMETRYCOLLECTION(
		POINT(1 1),
		LINESTRING(0 0,		1 1,	2 2,	3 3,	4 4)
	)
'));

SELECT * FROM t_spatial;

#	inserting BINARY DATA
INSERT INTO t_spatial(pnt) values(ST_GeomFromWKB(X'0101000000000000000000F03F000000000000F03F'));	# Note the SOURCE OF this information IS required TO verify that IS IS syntactically correct.  Note the X' RE: this IS a hex value.

#	Retrieving SPATIAL VALUES
SELECT ST_AsText(pnt), ST_AsText(ls), ST_AsText(pg), ST_AsText(geo_c) 
FROM t_spatial;

ALTER TABLE t_spatial ADD SPATIAL index(pnt);
ALTER TABLE t_spatial ADD SPATIAL index(ls);
ALTER TABLE t_spatial ADD SPATIAL index(pg);

DESC t_spatial;

SELECT * FROM tsanders.v_describe WHERE table_name = 't_spatial';

ALTER TABLE t_spatial
ADD SPATIAL INDEX(geo);