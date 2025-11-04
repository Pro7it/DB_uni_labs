-- All indexes
SELECT * FROM pg_indexes WHERE schemaname = 'public';

-- Simple analyze without index
EXPLAIN ANALYZE SELECT * FROM student WHERE name='Zakharii';

--Simple analyze witth index
EXPLAIN ANALYZE SELECT * FROM student WHERE id=164;

--!0000 index scan
EXPLAIN ANALYZE SELECT * FROM tmp WHERE id=445;

-- Complex analyze
EXPLAIN ANALYZE SELECT 
	l.name,
	l.surname,
	s.name,
	sc.unigroup_id,
	sc.lesson_date,
	d.name
FROM Schedule AS sc
INNER JOIN uni_group AS ug ON ug.id = sc.unigroup_id
INNER JOIN Department AS d ON d.id = ug.department_id
INNER JOIN Lector AS l ON l.id = sc.lector_id
INNER JOIN Subject AS s ON s.id = sc.subject_id;

-- Problem
EXPLAIN SELECT l.name, l.surname
FROM consil AS c
INNER JOIN lector AS l ON l.id = c.lector_id
INTERSECT
SELECT name, surname FROM lector;

-- Optimization 
EXPLAIN SELECT l.name, l.surname
FROM consil AS c
INNER JOIN lector AS l ON l.id = c.lector_id
INNER JOIN lector AS l2 ON l.name = l2.name AND l.surname = l2.surname;


-- Parameters
SHOW all;

-- Optimizations
SET shared_buffers = "4GB"; --кеш
SET work_mem = "64MB"; --пам'ять для сортувань, хешів і тд
SET maintenance_work_mem = "512MB"; --пам'ять для вакуума, індексів та алтерів
SET effective_cache_size = "12GB"; --кеш для планувальника
SET temp_buffers = "16MB"; --тимчасовий буфер
SET max_parallel_workers = 12; --паралельність
SET max_parallel_workers_per_gather = 6; --тоже щось від неї

-- Backup
pg_dump -U postgres -d mydb -f backup.sql

-- Restore
psql -U postgres -d mydb_back -f backup.sql