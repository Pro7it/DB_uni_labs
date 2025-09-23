CREATE INDEX idx_lector_department_id ON lector(department_id);

CREATE INDEX idx_unigroup_department_id ON uni_group(department_id);

CREATE INDEX idx_student_unigroup_id ON student(unigroup_id);
CREATE INDEX idx_student_scholarship_id ON student(scholarship_id);

CREATE INDEX idx_classroom_building_room ON classroom(building_number, room_number);

CREATE INDEX idx_schedule_unigroup_id ON schedule(unigroup_id);
CREATE INDEX idx_schedule_subject_id ON schedule(subject_id);
CREATE INDEX idx_schedule_lector_id ON schedule(lector_id);
CREATE INDEX idx_schedule_lesson_date ON schedule(lesson_date);
CREATE INDEX idx_schedule_classroom_id ON schedule(classroom_id);
