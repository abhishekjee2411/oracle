https://docs.oracle.com/cd/B28359_01/server.111/b28310/general002.htm#ADMIN11527

"======================================"
"ANALYZING TABLES, INDEXES AND CLUSTERS"
"======================================"

--ANALYZE + VALIDATE STRUCTURE

/*
If a table/index/cluster is corrupted, you should drop it and re-create it.
If a materialized view is corrupted, you should:
	1.	Perform a complete refresh.
	2.	(if the refresh didn't work) Drop and re-create the materialized view.
*/
ANALYZE TABLE emp VALIDATE STRUCTURE;
--performs a complete validation, by default.

ANALYZE TABLE emp VALIDATE STRUCTURE CASCADE;
--validates the table "emp" and all the dependent objects (indexes, constraints, etc.) as well.

ANALYZE TABLE emp VALIDATE STRUCTURE CASCADE FAST;
--locates the corruptions in the "emp" table, and then performs a fast validation on the table.

ANALYZE TABLE emp VALIDATE STRUCTURE CASCADE ONLINE;
--performs structure validation while DML is occurring against the table "emp" that is being validated.

"==========================================="
"LISTING CHAINED ROWS OF TABLES AND CLUSTERS"
"==========================================="

/*
https://www.akadia.com/services/ora_chained_rows.html
https://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_4005.htm
http://www.dba-oracle.com/t_oracle_analyze_table.htm
http://www.dba-oracle.com/art_sql_tune.htm
https://oracle-base.com/dba/script?category=miscellaneous&file=analyze_all.sql

Once set, the DB_BLOCK_SIZE, which is a multiple of the OS Block Size, cannot be changed during the life of the database.
To decide on a suitable block size for the database, we need to consider:
	1.	Size of the DB.
	2.	Concurrent number of transactions expected.
	
Database -> Tablespace -> Segment -> Extent -> Block (DB_BLOCK_SIZE)

Segments	:	Tables, Indexes, Rollback, etc.

Contents of an Oracle Block:
	1.	Header
	2.	Table-Directory
	3.	Row-Directory
	4.	PCTFREE
	5.	PCTUSED
	6.	FREELIST
	7.	Oracle Row Data
		a.	Row-Overhead
		b.	Number of Columns
		c.	Cluster Key
		d.	Rowid
		e.	Column Length
		f.	Column Data
		g.	Column Length
		h.	Column Data
	
*/

/*

=============
ROW-MIGRATION
=============

Row migration occurs when a row, once updated, is no longer able to fit inside of the space it had occupied earlier.
In this case, the row is moved to a new block, while the old one simply contains a forwarding address (the ROWID of the row being migrated) to the row's new location.
Full Table scans are not affected by row migrations.
Index scans/reads are affected by row migrations, as an I/O would be incurred for every migrated row that is encountered in the index read.

============
ROW-CHAINING
============

If table rowsize exceeds the database blocksize, then row-chaining occurs.
Tables with LONG and LONG RAW columns are prone to having chained rows.
Tables with more than 255 columns will have chained rows, as Oracle breaks wide tables up into pieces.

<<table fetch continued row>>
	This event occurs when a SELECT query is fired such that it selects more than one columns among which one or more are in other blocks due to row-chaining.
	If the SELECT query contains only one column that remains in the original block, then the above event does not occur.

*/

--How to check for row-chaining and migration:

SELECT a.name, b.value
FROM V$STATNAME a, V$MYSTAT b
WHERE a.STATISTIC# = b.STATISTIC#
AND LOWER(a.name) = 'table fetch continued row';

"==========================================="
"LISTING CHAINED ROWS OF TABLES AND CLUSTERS"
"==========================================="

--Execute the script:
utlchain.sql
utlchn1.sql

--The above script(s), when executed, would create a CHAINED_ROWS table in the schema of the invoking user.
--The following query would then analyze the table, highlighting the information about the chained rows.

ANALYZE TABLE emp LIST CHAINED ROWS INTO CHAINED_ROWS;




