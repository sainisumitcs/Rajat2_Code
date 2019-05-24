-------------------------------------------------------------------------------
--           P O L Y H E D R A    D E M O
--           Copyright (C) 2005-2014 Enea Software AB
-------------------------------------------------------------------------------
-- 	Filename      : tables.sql
-- 	Description   : sample schema for testing Navvy
-- 	Author        : Nigel Day
--
--      CVSID         : $Id: tables.sql,v 1.5 2014/07/23 17:10:14 nigel Exp $
-------------------------------------------------------------------------------
-- NOTE: this is ILLUSTRATIVE CODE, provided on an 'as is' basis to help
-- demonstrate one or more features of the Polyhedra product. 
-- It may well need adaption for use in a live installation, and
-- Enea Software AB and its agents and distributors do not warrant this code.
-------------------------------------------------------------------------------

-- ensure our tables, views, etc are not there, so we can easily reload
-- this schema

DROP INDEX i1;
DROP INDEX i2;
DROP INDEX i3_o;
DROP INDEX i4_u;
DROP INDEX i5_uo;
DROP INDEX i6;

DROP VIEW view_one;
DROP VIEW view_two;

DROP TABLE ten;
DROP TABLE nine;
DROP TABLE eight;
DROP TABLE seven;
DROP TABLE six;
DROP TABLE five;
DROP TABLE four;
DROP TABLE three;
DROP TABLE two;

ALTER SCHEMA

DROP TABLE one
DROP domain d2
DROP domain d1

;

-- create some tables, domains, views and indexes to test the application.

CREATE SCHEMA

-- a simple domain

CREATE DOMAIN d1
( v1 INTEGER NOT NULL
, v2 INTEGER default 3
)

-- a derived domain with a refence to a table that is defined further below
-- (hence the use of CREATE SCHEMA)

CREATE DOMAIN d2
( derived from d1
, v3 INTEGER references one
)

-- a simple table to test basic operation; it has a mixture of attribute qualifiers

CREATE TABLE one
( PERSISTENT
, id INTEGER PRIMARY KEY
, arg2 INTEGER NOT NULL 
, arg3 INTEGER TRANSIENT
, arg4 INTEGER TRANSIENT LOCAL
, arg5 INTEGER HIDDEN
, arg6_shared INTEGER SHARED
, arg7_virtual INTEGER VIRTUAL
)

-- now a table to test handling of different types, and defaults

CREATE TABLE two
( PERSISTENT
, id INTEGER PRIMARY KEY
, arg2 LARGE VARCHAR DEFAULT 'arg2'
, arg3 CHAR(1) DEFAULT 'arg3'
, arg4 VARCHAR(20) DEFAULT 'arg4'
, arg5 FLOAT DEFAULT 5.12
, arg6 float32 DEFAULT 6.0
, arg7 integer16 DEFAULT 16
, arg8 integer8 DEFAULT 8
, arg9 DATETIME DEFAULT '01-Jan-1973 11:12:13'
, arg10 BOOL DEFAULT TRUE
, arg11 BINARY(50) DEFAULT x'0102030405'
, arg12 binary large object
, arg13 ARRAY OF one TRANSIENT
, arg14 large VARCHAR(20)
, arg15 large VARCHAR
, arg16 INTEGER64
)

-- a table with multi-column primary keys

CREATE TABLE three
( persistent
, id1 INTEGER, id2 INTEGER, PRIMARY KEY (id1, id2)
, arg3 INTEGER
)

-- a table with references, including multi-key references and cascade conditions

CREATE TABLE four
( TRANSIENT
, id   INTEGER PRIMARY KEY REFERENCES one on delete restrict on update cascade
, arg2 INTEGER NOT NULL    REFERENCES one on update cascade  on delete cascade
, arg3 INTEGER
, arg4 INTEGER
, FOREIGN KEY (arg3, arg4) REFERENCES three (id1, id2) on delete set null
, arg5 INTEGER
, arg6 INTEGER
, FOREIGN KEY (arg5, arg6) REFERENCES three (id2, id1) on delete cascade on update restrict

)

-- a derived table

CREATE TABLE five
( TRANSIENT, DERIVED FROM two
, extra1 INTEGER TRANSIENT
, extra2 INTEGER PERSISTENT
, extra3 INTEGER references five
)

-- another derived table

CREATE TABLE six
( TRANSIENT, DERIVED FROM five
, extra4 INTEGER TRANSIENT
, extra5 INTEGER PERSISTENT
, extra6 INTEGER references five
)

-- yet another derived table; note that the added attributes have
-- the same names as in another table derived from the same base
-- table - this is perfectly legitimate!
-- Also, one of the attributes has a name that is a reserved word.

CREATE TABLE seven
( TRANSIENT,   DERIVED FROM five
, extra4       INTEGER TRANSIENT
, extra5       INTEGER PERSISTENT
, "References" INTEGER references four
)

-- add some more derived tables, so we can see how the application
-- handles trees.

CREATE TABLE eight
( TRANSIENT, DERIVED FROM two
, extra1   INTEGER TRANSIENT
, extra2   INTEGER PERSISTENT
, "Extra3" INTEGER references eight
)

CREATE TABLE nine
( TRANSIENT, DERIVED FROM six
, extra7 INTEGER TRANSIENT
, extra8 INTEGER PERSISTENT
, extra9 INTEGER references two
)

-- recent versions of Polyhedra support 64-bit signed integers

CREATE TABLE ten
( id integer primary key
, data integer64
)

-- add a table with some domain attributes

CREATE TABLE eleven
( id integer PRIMARY KEY
, x d1
, y d2
)
;

-- finally, some indexes and views

CREATE INDEX i1 ON one (arg3);
CREATE INDEX i2 ON two (id, arg2);
CREATE ordered INDEX i3_o ON three (arg3);
CREATE UNIQUE INDEX i4_u ON three (id1);
CREATE UNIQUE ordered INDEX i5_uo ON four (id);
CREATE INDEX i6 ON one (arg4);

CREATE VIEW view_one AS SELECT name, depth, derived_from FROM TABLES WHERE TYPE = 0;
CREATE VIEW view_two AS SELECT count (*) tablecount FROM TABLES;

/*---------------------------------------------------------------------------*/
/*                          e n d   o f   f i l e                            */
/*---------------------------------------------------------------------------*/


