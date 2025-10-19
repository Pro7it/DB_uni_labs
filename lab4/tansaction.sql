--Transaction to move student from one group to another
CREATE OR REPLACE PROCEDURE change_student_group(p_student_id INT, p_unigroup_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    group_count INT;
BEGIN
    group_count := 0

    BEGIN;
        UPDATE student
        SET unigroup_id = p_unigroup_id
        WHERE id = p_student_id;

        SELECT COUNT(*) INTO group_count
        FROM student
        WHERE unigroup_id = p_unigroup_id;

        IF group_count >= 10 THEN
            RAISE NOTICE 'Too many students in group: %', group_count - 1;
            ROLLBACK;
        END IF;
        COMMIT;
END;
$$;


--Arternative
DO $$
DECLARE
    group_count INT;
BEGIN
	group_count := 0

	BEGIN;
	    UPDATE student
	    SET unigroup_id = 13
	    WHERE id = 3;
	
	    SELECT COUNT(*) INTO group_count
	    FROM student
	    WHERE unigroup_id = 13;
	
	    IF group_count > 10 THEN
	        RAISE NOTICE 'Too many students in group: %', group_count;
	        ROLLBACK;
    	END IF;
		COMMIT;
END;
$$;