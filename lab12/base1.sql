CREATE TABLE department (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE subject (
    id SERIAL PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL
);

CREATE TABLE scholarship (
    id SERIAL PRIMARY KEY,
    scholarship_type VARCHAR(50) NOT NULL,
    scholarship_amount SMALLINT NOT NULL
);

CREATE TABLE classroom (
    id SERIAL PRIMARY KEY,
    room_number SMALLINT NOT NULL,
    building_number SMALLINT NOT NULL
);

CREATE TABLE lector (
    id SERIAL PRIMARY KEY,
    lector_name VARCHAR(50) NOT NULL,
    lector_surname VARCHAR(50) NOT NULL,
    lector_salary INTEGER NOT NULL,
    department_id INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE uni_group (
    id SERIAL PRIMARY KEY,
    group_year SMALLINT NOT NULL,
    group_number SMALLINT NOT NULL,
    group_curator_id INTEGER NOT NULL UNIQUE REFERENCES Lector(id),
    department_id INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    student_surname VARCHAR(50) NOT NULL,
    unigroup_id INTEGER NOT NULL REFERENCES UniGroup(id),
    scholarship_id INTEGER NOT NULL REFERENCES Scholarship(id)
);

CREATE TABLE schedule (
    id SERIAL PRIMARY KEY,
    subject_id INTEGER NOT NULL REFERENCES Subject(id),
    lector_id INTEGER NOT NULL REFERENCES Lector(id),
    unigroup_id INTEGER NOT NULL REFERENCES uni_group(id),
    lesson_date DATE NOT NULL,
    classroom_id INTEGER NOT NULL REFERENCES Classroom(id)
);