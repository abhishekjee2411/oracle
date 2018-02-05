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

ANALYZE TABLE emp VALIDATE STRUCTURE CASCADE;

ANALYZE TABLE emp VALIDATE STRUCTURE CASCADE FAST;

ANALYZE TABLE emp VALIDATE STRUCTURE CASCADE ONLINE;

--LISTING CHAINED ROWS OF TABLES AND CLUSTERS

/*
https://www.akadia.com/services/ora_chained_rows.html
https://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_4005.htm
http://www.dba-oracle.com/t_oracle_analyze_table.htm
http://www.dba-oracle.com/art_sql_tune.htm
https://oracle-base.com/dba/script?category=miscellaneous&file=analyze_all.sql

Once set, the DB_BLOCK_SIZEm, which is a multiple of the OS Block Size, cannot be changed during the life of the database.
To decide on a suitable block size for the database, we need to consider:
	1.	Size of the DB.
	2.	Concurrent number of transactions expected.
	
Database -> Tablespace -> Segment -> Extent -> Block (DB_BLOCK_SIZE)

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