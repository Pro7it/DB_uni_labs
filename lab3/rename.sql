ALTER TABLE department
RENAME COLUMN department_name TO name;

ALTER TABLE lector
RENAME COLUMN lector_name TO name;
RENAME COLUMN lector_surname TO surname;
RENAME COLUMN lector_salary TO salary;

ALTER TABLE subject
RENAME COLUMN subject_name TO name;

ALTER TABLE uni_group
RENAME COLUMN group_year TO course;1
RENAME COLUMN group_number TO num;

ALTER TABLE scholarship
RENAME COLUMN scholarship_amount TO amount;
RENAME COLUMN scholarship_type TO type;

ALTER TABLE student
RENAME COLUM student_name TO name;
RENAME COLUMN student_surname TO surname;

ALTER TABLE uni_group
RENAME COLUMN group_curator_id TO curator_id;