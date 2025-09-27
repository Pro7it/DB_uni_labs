-- Union
SELECT 
	l.name,
	l.surname
FROM consil AS c
INNER JOIN lector AS l ON l.id = c.lector_id
UNION
SELECT 
	l.name,
	l.surname
FROM uni_group AS ug
INNER JOIN lector AS l ON l.id = ug.curator_id;

-- Union All
SELECT 
	l.id,
	l.name,
	l.surname
FROM consil AS c
INNER JOIN lector AS l ON l.id = c.lector_id
UNION ALL
SELECT 
	l.id,
	l.name,
	l.surname
FROM uni_group AS ug
INNER JOIN lector AS l ON l.id = ug.curator_id;

-- Intersect
SELECT 
	l.name,
	l.surname
FROM consil AS c
INNER JOIN lector AS l ON l.id = c.lector_id
INTERSECT
SELECT name, surname FROM lector;

-- Except
SELECT name, surname FROM lector
EXCEPT 
SELECT 
	l.name,
	l.surname
FROM uni_group AS ug
INNER JOIN lector AS l ON l.id = ug.curator_id;

-- Order by and Where
SELECT * FROM lector
WHERE salary >= 33000
ORDER BY salary DESC;

-- Left/ right join
SELECT 
	s.name,
	l.name,	
	l.surname,
	sc.lesson_date
FROM schedule AS sc
RIGHT JOIN lector AS l ON sc.lector_id = l.id
LEFT JOIN subject AS s ON sc.subject_id = s.id;

-- Mega Inner join + projection
SELECT 
	s.name,
	l.name,	
	l.surname,
	ug.course,
	ug.num,
	sc.lesson_date,
	d.name,
	c.building_number
FROM schedule AS sc
INNER JOIN lector AS l ON sc.lector_id = l.id
INNER JOIN subject AS s ON sc.subject_id = s.id
INNER JOIN uni_group AS ug ON sc.unigroup_id = ug.id
INNER JOIN department AS d ON ug.department_id = d.id
INNER JOIN classroom AS c ON sc.classroom_id = c.id;

-- Group by and having
SELECT 
	d.name,
	COUNT(s.id)
FROM uni_group AS ug
INNER JOIN department AS d ON ug.department_id = d.id
INNER JOIN student AS s ON ug.id = s.unigroup_id
GROUP BY d.name
HAVING COUNT(s.id) > 40;

-- Subquery 
SELECT * FROM uni_group 
WHERE curator_id IN (SELECT id FROM lector WHERE salary < 25000);

-- Super puper Cross join ands ubquery
SELECT 
	d.name,
	ug.course,
	ug.num,
	l.name,
	l.surname
FROM uni_group AS ug
INNER JOIN department AS d ON d.id = ug.department_id
CROSS JOIN lector AS l
WHERE ug.curator_id is NULL
	AND l.id NOT IN (SELECT curator_id FROM uni_group WHERE curator_id IS NOT NULL);