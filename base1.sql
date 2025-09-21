CREATE TABLE Department (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE Subject (
    id SERIAL PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL
);

CREATE TABLE Scholarship (
    id SERIAL PRIMARY KEY,
    scholarship_type VARCHAR(50) NOT NULL,
    scholarship_amount SMALLINT NOT NULL
);

CREATE TABLE Classroom (
    id SERIAL PRIMARY KEY,
    room_number SMALLINT NOT NULL,
    building_number SMALLINT NOT NULL
);

CREATE TABLE Lector (
    id SERIAL PRIMARY KEY,
    lector_name VARCHAR(50) NOT NULL,
    lector_surname VARCHAR(50) NOT NULL,
    lector_salary INTEGER NOT NULL,
    department_id INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE UniGroup (
    id SERIAL PRIMARY KEY,
    group_year SMALLINT NOT NULL,
    group_number SMALLINT NOT NULL,
    group_curator_id INTEGER NOT NULL UNIQUE REFERENCES Lector(id),
    department_id INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE Student (
    id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    student_surname VARCHAR(50) NOT NULL,
    unigroup_id INTEGER NOT NULL REFERENCES UniGroup(id),
    scholarship_id INTEGER NOT NULL REFERENCES Scholarship(id)
);

CREATE TABLE Schedule (
    id SERIAL PRIMARY KEY,
    subject_id INTEGER NOT NULL REFERENCES Subject(id),
    lector_id INTEGER NOT NULL REFERENCES Lector(id),
    unigroup_id INTEGER NOT NULL REFERENCES UniGroup(id),
    lesson_date DATE NOT NULL,
    classroom_id INTEGER NOT NULL REFERENCES Classroom(id)
);

ALTER TABLE UniGroup
ADD CONSTRAINT check_group_year CHECK (group_year BETWEEN 1 AND 6);

CREATE TEMPORARY TABLE UnigroupMap AS
SELECT id AS old_id,
       ROW_NUMBER() OVER (ORDER BY id) AS new_id
FROM UniGroup;

UPDATE Unigroup u
SET id = m.new_id
FROM UnigroupMap m
WHERE u.id = m.old_id;

SELECT pg_get_serial_sequence('UniGroup', 'id');

SELECT setval('public.unigroup_id_seq', (SELECT MAX(id) FROM UniGroup));