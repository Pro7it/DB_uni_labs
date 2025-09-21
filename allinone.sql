-- Many to many
SELECT sc.*
FROM Schedule as sc
INNER JOIN UniGroup as ug ON ug.id = sc.unigroup_id
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
FROM UniGroup u
JOIN Department d
	ON u.department_id = d.id;

-- Which lector make whick subject in whuch gruop and department
SELECT 
	l.lector_name,
	l.lector_surname,
	s.subject_name,
	sc.unigroup_id,
	sc.lesson_date,
	d.department_name
FROM Schedule AS sc
INNER JOIN UniGroup AS ug ON ug.id = sc.unigroup_id
INNER JOIN Department AS d ON d.id = ug.department_id
INNER JOIN Lector AS l ON l.id = sc.lector_id
INNER JOIN Subject AS s ON s.id = sc.subject_id;