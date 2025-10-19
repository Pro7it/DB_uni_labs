--Data integrity
CREATE OR REPLACE FUNCTION check_lector_salary()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.salary < 0 OR NEW.salary > 40000 THEN
        RAISE EXCEPTION 'Do not underestimate my triggers';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_salary
BEFORE INSERT OR UPDATE ON lector
FOR EACH ROW
EXECUTE FUNCTION check_lector_salary();

--Cardinality
CREATE OR REPLACE FUNCTION student_single_group()
RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
BEGIN 
    IF (SELECT COUNT(*) FROM student WHERE NEW.name = name AND NEW.surname = surname) >= 1 THEN
        RAISE EXCEPTION 'Student is already assigned to another group';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_single_group
BEFORE INSERT OR UPDATE ON student
FOR EACH ROW
EXECUTE FUNCTION student_single_group();

--Autocorect
CREATE OR REPLACE FUNCTION capitalize_name()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN 
    NEW.name := INITCAP(NEW.name);
    NEW.surname := INITCAP(NEW.surname);

    RETURN NEW;

END;
$$;

CREATE TRIGGER trg_student_name
BEFORE INSERT OR UPDATE ON student
FOR EACH ROW
EXECUTE FUNCTION capitalize_name();

CREATE TRIGGER trg_lector_name
BEFORE INSERT OR UPDATE ON lector
FOR EACH ROW
EXECUTE FUNCTION capitalize_name();