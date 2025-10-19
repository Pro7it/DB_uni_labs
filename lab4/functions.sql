-- Statistic
CREATE FUNCTION average_department_salary (dptm_id INT)
RETURNS INT AS
$$
SELECT AVG(salary) FROM lector WHERE department_id=dptm_id;
$$
LANGUAGE SQL;

-- Return by key
CREATE FUNCTION get_students_by_group(gid INT) 
RETURNS TABLE(id INT, name TEXT, surname TEXT) AS 
$$ 
SELECT id, name, surname FROM student WHERE unigroup_id = gid; 
$$ 
LANGUAGE SQL;