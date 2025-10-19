-- Simple insert
CREATE PROCEDURE insert_student(
    s_name VARCHAR(50),
    s_surname VARCHAR(50),
    s_unigroup_id INT,
    s_scholarship_id INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO student(name, surname, unigroup_id, scholarship_id)
    VALUES (s_name, s_surname, s_unigroup_id, s_scholarship_id);
END;
$$;

-- M:M insert
CREATE PROCEDURE quick_lesson(
	sub_id INT,
	lec_id INT,
	unig_id INT,
	clasr_id INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
	INSERT INTO schedule(subject_id, lector_id, unigroup_id, lesson_date, classroom_id)
	VALUES (sub_id, lec_id, unig_id, CURRENT_DATE, clasr_id);

END;
$$;

-- Cursor
CREATE PROCEDURE add_to_salary(amount INT)
LANGUAGE plpgsql
AS
$$
DECLARE 
    lec_record RECORD;
    lec_cursor CURSOR FOR SELECT * FROM lector FOR UPDATE;
BEGIN


    OPEN lec_cursor;

    LOOP
        FETCH lec_cursor INTO lec_record;
        EXIT WHEN NOT FOUND;

        UPDATE lector
        SET salary = lec_record.salary + amount
        WHERE id = lec_record.id; 
    
    END LOOP;

    CLOSE lec_cursor;

    RAISE NOTICE 'Now uni have less(or more)money:(';
END;
$$;