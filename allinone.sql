-- Many to many
SELECT sc.*
FROM Schedule as sc
INNER JOIN uni_group as ug ON ug.id = sc.uni_group_id
INNER JOIN Subject as s ON s.id = sc.subject_id
WHERE ug.group_year = 1;

-- Cool find lector-department
SELECT 
	l.id,
	l.lector_name,
	l.lector_surname,
	d.id,
	d.department_name
FROM Lector l
JOIN Department d
	ON l.department_id = d.id;

-- Find group-department
SELECT 
	u.id,
	u.group_number,
	u.group_year,
	d.department_name
FROM uni_group u
JOIN Department d
	ON u.department_id = d.id;

-- Which lector make whick subject in whuch gruop and department
SELECT 
	l.lector_name,
	l.lector_surname,
	s.subject_name,
	sc.uni_group_id,
	sc.lesson_date,
	d.department_name
FROM Schedule AS sc
INNER JOIN uni_group AS ug ON ug.id = sc.uni_group_id
INNER JOIN Department AS d ON d.id = ug.department_id
INNER JOIN Lector AS l ON l.id = sc.lector_id
INNER JOIN Subject AS s ON s.id = sc.subject_id;

-- Reindex the Table 
CREATE TEMPORARY TABLE uni_group_map AS
SELECT id AS old_id,
       ROW_NUMBER() OVER (ORDER BY id) AS new_id
FROM uni_group;

UPDATE uni_group u
SET id = m.new_id
FROM uni_group_map m
WHERE u.id = m.old_id;

SELECT pg_get_serial_sequence('uni_group', 'id');

SELECT setval('public.uni_group_id_seq', (SELECT MAX(id) FROM uni_group));

-- Custom CONSTRAINT
ALTER TABLE uni_group
ADD CONSTRAINT check_group_year CHECK (group_year BETWEEN 1 AND 6);