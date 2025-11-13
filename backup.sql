--
-- PostgreSQL database dump
--

\restrict 46k2MOjbnm4X6lTbTfM82hHeK7WMBlEoTkJxIYbm6LgTYUtjoBHtiCPh1Fyknkb

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_to_salary(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_to_salary(IN amount integer)
    LANGUAGE plpgsql
    AS $$
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


ALTER PROCEDURE public.add_to_salary(IN amount integer) OWNER TO postgres;

--
-- Name: average_department_salary(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.average_department_salary(dptm_id integer) RETURNS integer
    LANGUAGE sql
    AS $$
SELECT AVG(salary) FROM lector WHERE department_id=dptm_id;
$$;


ALTER FUNCTION public.average_department_salary(dptm_id integer) OWNER TO postgres;

--
-- Name: capitalize_name(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.capitalize_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
    NEW.name := INITCAP(NEW.name);
    NEW.surname := INITCAP(NEW.surname);

    RETURN NEW;

END;
$$;


ALTER FUNCTION public.capitalize_name() OWNER TO postgres;

--
-- Name: change_student_group(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.change_student_group(IN p_student_id integer, IN p_unigroup_id integer)
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


ALTER PROCEDURE public.change_student_group(IN p_student_id integer, IN p_unigroup_id integer) OWNER TO postgres;

--
-- Name: check_lector_salary(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_lector_salary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.salary < 0 OR NEW.salary > 40000 THEN
        RAISE EXCEPTION 'Do not underestimate my triggers';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_lector_salary() OWNER TO postgres;

--
-- Name: get_students_by_group(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_students_by_group(gid integer) RETURNS TABLE(id integer, name text, surname text)
    LANGUAGE sql
    AS $$ 
SELECT id, name, surname FROM student WHERE unigroup_id = gid; 
$$;


ALTER FUNCTION public.get_students_by_group(gid integer) OWNER TO postgres;

--
-- Name: insert_student(character varying, character varying, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_student(IN s_name character varying, IN s_surname character varying, IN s_unigroup_id integer, IN s_scholarship_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO student(name, surname, unigroup_id, scholarship_id)
    VALUES (s_name, s_surname, s_unigroup_id, s_scholarship_id);
END;
$$;


ALTER PROCEDURE public.insert_student(IN s_name character varying, IN s_surname character varying, IN s_unigroup_id integer, IN s_scholarship_id integer) OWNER TO postgres;

--
-- Name: quick_lesson(integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.quick_lesson(IN sub_id integer, IN lec_id integer, IN unig_id integer, IN clasr_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO schedule(subject_id, lector_id, unigroup_id, lesson_date, classroom_id)
	VALUES (sub_id, lec_id, unig_id, CURRENT_DATE, clasr_id);

END;
$$;


ALTER PROCEDURE public.quick_lesson(IN sub_id integer, IN lec_id integer, IN unig_id integer, IN clasr_id integer) OWNER TO postgres;

--
-- Name: student_single_group(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.student_single_group() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
    IF (SELECT COUNT(*) FROM student WHERE NEW.name = name AND NEW.surname = surname) >= 1 THEN
        RAISE EXCEPTION 'Student is already assigned to another group';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.student_single_group() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: classroom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classroom (
    id integer NOT NULL,
    room_number smallint NOT NULL,
    building_number smallint NOT NULL
);


ALTER TABLE public.classroom OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classroom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classroom_id_seq OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classroom_id_seq OWNED BY public.classroom.id;


--
-- Name: consil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consil (
    lector_id integer NOT NULL
);


ALTER TABLE public.consil OWNER TO postgres;

--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying(50) CONSTRAINT department_department_name_not_null NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_id_seq OWNER TO postgres;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


--
-- Name: lector; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lector (
    id integer NOT NULL,
    name character varying(50) CONSTRAINT lector_lector_name_not_null NOT NULL,
    surname character varying(50) CONSTRAINT lector_lector_surname_not_null NOT NULL,
    salary integer CONSTRAINT lector_lector_salary_not_null NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE public.lector OWNER TO postgres;

--
-- Name: lector_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lector_id_seq OWNER TO postgres;

--
-- Name: lector_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lector_id_seq OWNED BY public.lector.id;


--
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    id integer NOT NULL,
    subject_id integer NOT NULL,
    lector_id integer NOT NULL,
    unigroup_id integer NOT NULL,
    lesson_date date NOT NULL,
    classroom_id integer NOT NULL
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_id_seq OWNER TO postgres;

--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- Name: scholarship; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scholarship (
    id integer NOT NULL,
    type character varying(50) CONSTRAINT scholarship_scholarship_type_not_null NOT NULL,
    amount smallint CONSTRAINT scholarship_scholarship_amount_not_null NOT NULL
);


ALTER TABLE public.scholarship OWNER TO postgres;

--
-- Name: scholarship_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scholarship_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scholarship_id_seq OWNER TO postgres;

--
-- Name: scholarship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scholarship_id_seq OWNED BY public.scholarship.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id integer NOT NULL,
    name character varying(50) CONSTRAINT student_student_name_not_null NOT NULL,
    surname character varying(50) CONSTRAINT student_student_surname_not_null NOT NULL,
    unigroup_id integer NOT NULL,
    scholarship_id integer NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_id_seq OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject (
    id integer NOT NULL,
    name character varying(50) CONSTRAINT subject_subject_name_not_null NOT NULL
);


ALTER TABLE public.subject OWNER TO postgres;

--
-- Name: subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_id_seq OWNER TO postgres;

--
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_id_seq OWNED BY public.subject.id;


--
-- Name: uni_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uni_group (
    id integer NOT NULL,
    course smallint CONSTRAINT uni_group_group_year_not_null NOT NULL,
    num smallint CONSTRAINT uni_group_group_number_not_null NOT NULL,
    curator_id integer CONSTRAINT uni_group_group_curator_id_not_null NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE public.uni_group OWNER TO postgres;

--
-- Name: uni_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uni_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.uni_group_id_seq OWNER TO postgres;

--
-- Name: uni_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uni_group_id_seq OWNED BY public.uni_group.id;


--
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_id_seq'::regclass);


--
-- Name: department id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- Name: lector id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lector ALTER COLUMN id SET DEFAULT nextval('public.lector_id_seq'::regclass);


--
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- Name: scholarship id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarship ALTER COLUMN id SET DEFAULT nextval('public.scholarship_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject ALTER COLUMN id SET DEFAULT nextval('public.subject_id_seq'::regclass);


--
-- Name: uni_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uni_group ALTER COLUMN id SET DEFAULT nextval('public.uni_group_id_seq'::regclass);


--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (id, room_number, building_number) FROM stdin;
1	1	1
2	2	1
3	3	1
4	4	1
5	5	1
6	6	1
7	7	1
8	8	1
9	9	1
10	10	1
11	11	1
12	12	1
13	13	1
14	14	1
15	15	1
16	16	1
17	17	1
18	18	1
19	19	1
20	20	1
21	1	2
22	2	2
23	3	2
24	4	2
25	5	2
26	6	2
27	7	2
28	8	2
29	9	2
30	10	2
31	11	2
32	12	2
33	13	2
34	14	2
35	15	2
36	16	2
37	17	2
38	18	2
39	19	2
40	20	2
41	1	3
42	2	3
43	3	3
44	4	3
45	5	3
46	6	3
47	7	3
48	8	3
49	9	3
50	10	3
51	11	3
52	12	3
53	13	3
54	14	3
55	15	3
56	16	3
57	17	3
58	18	3
59	19	3
60	20	3
61	1	4
62	2	4
63	3	4
64	4	4
65	5	4
66	6	4
67	7	4
68	8	4
69	9	4
70	10	4
71	11	4
72	12	4
73	13	4
74	14	4
75	15	4
76	16	4
77	17	4
78	18	4
79	19	4
80	20	4
81	1	5
82	2	5
83	3	5
84	4	5
85	5	5
86	6	5
87	7	5
88	8	5
89	9	5
90	10	5
91	11	5
92	12	5
93	13	5
94	14	5
95	15	5
96	16	5
97	17	5
98	18	5
99	19	5
100	20	5
\.


--
-- Data for Name: consil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consil (lector_id) FROM stdin;
1
2
3
5
8
13
21
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id, name) FROM stdin;
1	AI
2	VR
3	Mathematics
4	Literature
\.


--
-- Data for Name: lector; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lector (id, name, surname, salary, department_id) FROM stdin;
1	Oleksandr	Chumak	25250	1
2	Oleksandr	Hrytsenko	28200	1
3	Nataliia	Dovzhenko	26490	1
4	Volodymyr	Mazur	36960	1
5	Svitlana	Bondarenko	36000	1
6	Olena	Soroka	37000	2
7	Viktoriia	Kovalchuk	20800	2
8	Svitlana	Oliinyk	34000	2
9	Hanna	Soroka	32290	2
10	Artem	Kushnir	23675	2
11	Alla	Khomenko	37900	3
12	Roksolana	Havryliuk	23150	3
13	Kristina	Khomenko	36175	3
14	Tetiana	Havryliuk	20640	3
15	Kristina	Baran	22860	3
16	Vitalii	Stetsiuk	23900	4
17	Anatolii	Rudenko	36500	4
18	Kyrylo	Chumak	38200	4
19	Kyrylo	Karpenko	24200	4
20	Oleh	Polishchuk	24300	4
21	Mykola	Hrytsenko	27500	1
22	Olena	Shevchuk	29000	1
23	Vasyl	Dmytrenko	31000	2
24	Iryna	Tymoshenko	33500	2
25	Taras	Bilenkyi	36000	3
26	Halyna	Yurchenko	24500	3
27	Petro	Horbach	32000	4
28	Kateryna	Pavlenko	29800	4
29	Olha	Kovalenko	28000	1
30	Dmytro	Bondarenko	26500	1
31	Svitlana	Moroz	30000	1
32	Andriy	Lysenko	31000	2
33	Natalia	Khmara	32500	2
34	Roman	Shevchuk	33000	2
35	Liudmyla	Kravchenko	29000	3
36	Viktor	Kotsiubynskyi	27000	3
37	Yulia	Bondar	28500	3
38	Oleh	Savchenko	34000	4
39	Inna	Melnyk	30000	4
40	Bohdan	Tkach	31500	4
41	Anastasiya	Fedorenko	29500	1
42	Stepan	Petryk	32000	2
43	Kateryna	Osadcha	30500	3
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schedule (id, subject_id, lector_id, unigroup_id, lesson_date, classroom_id) FROM stdin;
1	1	5	5	2025-10-11	76
2	3	5	6	2025-10-12	37
3	5	3	7	2025-10-13	76
4	5	5	6	2025-10-14	63
5	7	2	4	2025-10-15	93
6	1	2	6	2025-10-16	49
7	1	5	2	2025-10-17	69
8	10	10	11	2025-10-18	80
9	12	7	10	2025-10-19	52
10	9	9	12	2025-10-20	3
11	12	7	10	2025-10-21	9
12	9	6	8	2025-10-22	20
13	8	6	8	2025-10-23	48
14	13	10	9	2025-10-24	73
15	18	12	16	2025-10-25	84
16	21	11	15	2025-10-26	14
17	15	14	17	2025-10-27	76
18	17	12	17	2025-10-28	97
19	15	14	16	2025-10-29	73
20	18	12	16	2025-10-30	56
21	19	14	17	2025-10-31	79
22	27	20	26	2025-11-01	77
23	24	16	25	2025-11-02	33
24	27	19	28	2025-11-03	40
25	22	18	26	2025-11-04	91
26	27	17	27	2025-11-05	84
27	23	19	26	2025-11-06	5
28	28	17	27	2025-11-07	58
\.


--
-- Data for Name: scholarship; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scholarship (id, type, amount) FROM stdin;
1	None	0
2	Common	2000
3	Higher	3000
4	President	5000
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (id, name, surname, unigroup_id, scholarship_id) FROM stdin;
1	Stepan	Baran	1	1
2	Sofiia	Boyko	1	3
3	Mykola	Soroka	1	1
4	Oleksandr	Kravchenko	1	1
5	Tetiana	Ivashchenko	1	1
6	Volodymyr	Kovalchuk	1	4
7	Artem	Bondarenko	1	2
8	Iryna	Kushnir	2	3
9	Bohdan	Karpenko	2	1
10	Yurii	Maksymenko	2	3
11	Tetiana	Karpenko	2	2
12	Zoriana	Shevchenko	2	3
13	Roman	Klymenko	3	1
14	Roman	Voitenko	3	3
15	Kyrylo	Mazur	3	4
16	Roman	Mazur	3	1
17	Sofiia	Yakovenko	3	1
18	Artem	Polishchuk	4	4
19	Alla	Kovalenko	4	1
20	Anatolii	Baran	4	2
21	Roman	Khomenko	4	1
22	Liudmyla	Oliinyk	4	1
23	Kateryna	Bondarenko	5	1
24	Lesia	Havryliuk	5	1
25	Oleksandr	Chumak	5	2
26	Petro	Voitenko	5	4
27	Zoriana	Pavlenko	5	2
28	Mykola	Levchenko	5	4
29	Mykola	Kovalenko	6	1
30	Oleh	Voitenko	6	2
31	Iryna	Tkachenko	6	2
32	Zoriana	Stetsiuk	6	1
33	Roksolana	Savchenko	6	4
34	Zoriana	Kovalenko	7	3
35	Hanna	Pavlenko	7	4
36	Ihor	Shevchenko	7	4
37	Iryna	Rudenko	7	3
38	Kyrylo	Hrytsenko	7	1
39	Oleksandr	Klymenko	7	4
40	Vasyl	Khomenko	8	4
41	Anatolii	Dovzhenko	8	4
42	Ihor	Panchenko	8	2
43	Kristina	Tkachenko	8	1
44	Iryna	Panchenko	8	3
45	Serhii	Hnatyuk	8	1
46	Viktoriia	Voitenko	9	4
47	Kristina	Chumak	9	2
48	Stepan	Soroka	9	1
49	Anatolii	Yaremchuk	9	1
50	Kateryna	Kravchenko	9	4
51	Andrii	Dovzhenko	10	2
52	Sofiia	Yakymenko	10	4
53	Stepan	Ivashchenko	10	1
54	Halyna	Pavlenko	10	3
55	Mykola	Klymenko	10	3
56	Stepan	Shulha	10	4
57	Yurii	Yaremchuk	10	2
58	Nadiia	Karpenko	11	4
59	Vitalii	Pavlenko	11	1
60	Artem	Dovzhenko	11	2
61	Kristina	Kravchenko	11	1
62	Zoriana	Vasylenko	11	3
63	Hanna	Chumak	11	4
64	Kyrylo	Klymenko	12	2
65	Yurii	Kushnir	12	4
66	Vitalii	Kovalenko	12	3
67	Stepan	Shulha	12	1
68	Andrii	Moroz	12	4
69	Anatolii	Mazur	12	4
70	Sofiia	Levchenko	12	1
71	Lesia	Boyko	13	3
72	Tetiana	Yakymenko	13	2
73	Serhii	Soroka	13	2
74	Mariia	Dovzhenko	13	3
75	Vasyl	Mazur	13	2
76	Sofiia	Stetsiuk	13	3
77	Halyna	Kushnir	13	2
78	Liudmyla	Polishchuk	14	2
79	Vitalii	Pavlenko	14	3
80	Nataliia	Kushnir	14	4
81	Taras	Lysenko	14	3
82	Serhii	Hrytsenko	14	2
83	Andrii	Shevchenko	14	1
84	Oleksandr	Yaremchuk	15	3
85	Ihor	Shevchenko	15	1
86	Hanna	Dovzhenko	15	1
87	Hanna	Panchenko	15	2
88	Halyna	Kushnir	15	3
89	Anatolii	Maksymenko	16	1
90	Serhii	Boyko	16	4
91	Kristina	Dovzhenko	16	3
92	Roman	Ivashchenko	16	4
93	Zoriana	Vasylenko	16	3
94	Iryna	Nechyporenko	17	1
95	Olena	Vasylenko	17	1
96	Kyrylo	Oliinyk	17	4
97	Oksana	Soroka	17	3
98	Svitlana	Voitenko	17	2
99	Taras	Boyko	18	1
100	Serhii	Lysenko	18	4
101	Petro	Shulha	18	4
102	Stepan	Shulha	18	3
103	Svitlana	Shulha	18	1
104	Petro	Yaremchuk	18	3
105	Oleksandr	Klymenko	19	1
106	Serhii	Dovzhenko	19	1
107	Liudmyla	Mazur	19	1
108	Halyna	Kovalchuk	19	1
109	Vasyl	Savchenko	19	2
110	Alla	Rudenko	19	2
111	Roman	Horobets	20	1
112	Kateryna	Yaremchuk	20	4
113	Halyna	Melnyk	20	2
114	Oksana	Lysenko	20	2
115	Anatolii	Rudenko	20	4
116	Petro	Shulha	21	2
117	Petro	Stetsiuk	21	1
118	Tetiana	Havryliuk	21	3
119	Serhii	Yakovenko	21	3
120	Anatolii	Baran	21	1
121	Zoriana	Horobets	21	3
122	Kateryna	Boyko	22	1
123	Oksana	Savchenko	22	4
124	Roksolana	Boyko	22	2
125	Kristina	Mazur	22	4
126	Sofiia	Kravchenko	22	2
127	Petro	Hrytsenko	22	2
128	Lesia	Rudenko	23	4
129	Nataliia	Bondarenko	23	4
130	Vasyl	Kovalchuk	23	2
131	Roksolana	Shulha	23	1
132	Halyna	Horobets	23	2
133	Anatolii	Kushnir	23	1
134	Volodymyr	Shevchenko	24	1
135	Lesia	Yaremchuk	24	1
136	Roksolana	Kravchenko	24	1
137	Alla	Havryliuk	24	3
138	Dmytro	Shulha	24	3
139	Halyna	Yaremchuk	25	1
140	Ihor	Klymenko	25	2
141	Yurii	Klymenko	25	3
142	Olena	Pavlenko	25	1
143	Petro	Kovalchuk	25	3
144	Alla	Khomenko	25	4
145	Halyna	Panchenko	26	3
146	Nadiia	Tkachenko	26	3
147	Oleksandr	Yaremchuk	26	3
148	Roksolana	Soroka	26	1
149	Hanna	Yaremchuk	26	1
150	Viktoriia	Pavlenko	26	2
151	Valentyn	Yaremchuk	26	3
152	Artem	Shulha	27	2
153	Volodymyr	Bondarenko	27	2
154	Bohdan	Shulha	27	4
155	Kristina	Vasylenko	27	4
156	Andrii	Savchenko	27	3
157	Svitlana	Vasylenko	27	3
158	Yurii	Lysenko	27	1
159	Dmytro	Khomenko	28	4
160	Serhii	Savchenko	28	4
161	Halyna	Nechyporenko	28	1
162	Vasyl	Boyko	28	2
163	Iryna	Karpenko	28	2
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject (id, name) FROM stdin;
1	Machine Learning
2	Neural Networks
3	NLP
4	Computer Vision
5	Reinforcement Learning
6	AI Ethics
7	AI Systems
8	3D Graphics
9	HCI
10	VR Hardware
11	Immersive Environments
12	AR/VR Game Design
13	VR Interaction
14	XR Tech
15	Algebra
16	Calculus
17	Probability
18	Geometry
19	Discrete Math
20	Number Theory
21	Linear Algebra
22	World Literature
23	Poetry Analysis
24	Modern Novels
25	Drama & Theatre
26	Literary Theory
27	Classical Myths
28	Cultural Studies
\.


--
-- Data for Name: uni_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uni_group (id, course, num, curator_id, department_id) FROM stdin;
1	6	1	1	1
2	1	2	2	1
3	4	3	3	1
4	3	4	4	1
5	4	5	5	1
6	2	6	6	1
7	2	7	7	1
8	4	1	8	2
9	4	2	9	2
10	6	3	10	2
11	3	4	11	2
12	5	5	12	2
13	4	6	13	2
14	1	7	14	2
15	6	1	15	3
16	4	2	16	3
17	2	3	17	3
18	4	4	18	3
19	2	5	19	3
20	6	6	20	3
21	4	7	21	3
22	3	1	22	4
23	2	2	23	4
24	2	3	24	4
25	4	4	25	4
26	3	5	26	4
27	2	6	27	4
28	5	7	28	4
\.


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_id_seq', 100, true);


--
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 4, true);


--
-- Name: lector_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lector_id_seq', 43, true);


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schedule_id_seq', 28, true);


--
-- Name: scholarship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scholarship_id_seq', 4, true);


--
-- Name: student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_id_seq', 163, true);


--
-- Name: subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subject_id_seq', 28, true);


--
-- Name: uni_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uni_group_id_seq', 28, true);


--
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- Name: consil consil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consil
    ADD CONSTRAINT consil_pkey PRIMARY KEY (lector_id);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: lector lector_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lector
    ADD CONSTRAINT lector_pkey PRIMARY KEY (id);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- Name: schedule schedule_subject_id_lector_id_unigroup_id_lesson_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_subject_id_lector_id_unigroup_id_lesson_date_key UNIQUE (subject_id, lector_id, unigroup_id, lesson_date);


--
-- Name: scholarship scholarship_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarship
    ADD CONSTRAINT scholarship_pkey PRIMARY KEY (id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- Name: uni_group uni_group_group_curator_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uni_group
    ADD CONSTRAINT uni_group_group_curator_id_key UNIQUE (curator_id);


--
-- Name: uni_group uni_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uni_group
    ADD CONSTRAINT uni_group_pkey PRIMARY KEY (id);


--
-- Name: idx_classroom_building_room; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_classroom_building_room ON public.classroom USING btree (building_number, room_number);


--
-- Name: idx_lector_department_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lector_department_id ON public.lector USING btree (department_id);


--
-- Name: idx_schedule_classroom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_classroom_id ON public.schedule USING btree (classroom_id);


--
-- Name: idx_schedule_lector_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_lector_id ON public.schedule USING btree (lector_id);


--
-- Name: idx_schedule_lesson_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_lesson_date ON public.schedule USING btree (lesson_date);


--
-- Name: idx_schedule_subject_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_subject_id ON public.schedule USING btree (subject_id);


--
-- Name: idx_schedule_unigroup_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_schedule_unigroup_id ON public.schedule USING btree (unigroup_id);


--
-- Name: idx_student_scholarship_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_scholarship_id ON public.student USING btree (scholarship_id);


--
-- Name: idx_student_unigroup_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_unigroup_id ON public.student USING btree (unigroup_id);


--
-- Name: idx_unigroup_department_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unigroup_department_id ON public.uni_group USING btree (department_id);


--
-- Name: lector trg_check_salary; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_salary BEFORE INSERT OR UPDATE ON public.lector FOR EACH ROW EXECUTE FUNCTION public.check_lector_salary();


--
-- Name: lector trg_lector_name; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_lector_name BEFORE INSERT OR UPDATE ON public.lector FOR EACH ROW EXECUTE FUNCTION public.capitalize_name();


--
-- Name: student trg_single_group; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_single_group BEFORE INSERT OR UPDATE ON public.student FOR EACH ROW EXECUTE FUNCTION public.student_single_group();


--
-- Name: student trg_student_name; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_student_name BEFORE INSERT OR UPDATE ON public.student FOR EACH ROW EXECUTE FUNCTION public.capitalize_name();


--
-- Name: consil consil_lector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consil
    ADD CONSTRAINT consil_lector_id_fkey FOREIGN KEY (lector_id) REFERENCES public.lector(id);


--
-- Name: lector lector_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lector
    ADD CONSTRAINT lector_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: schedule schedule_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id);


--
-- Name: schedule schedule_lector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_lector_id_fkey FOREIGN KEY (lector_id) REFERENCES public.lector(id);


--
-- Name: schedule schedule_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subject(id);


--
-- Name: schedule schedule_unigroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_unigroup_id_fkey FOREIGN KEY (unigroup_id) REFERENCES public.uni_group(id);


--
-- Name: student student_scholarship_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_scholarship_id_fkey FOREIGN KEY (scholarship_id) REFERENCES public.scholarship(id);


--
-- Name: student student_unigroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_unigroup_id_fkey FOREIGN KEY (unigroup_id) REFERENCES public.uni_group(id);


--
-- Name: uni_group uni_group_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uni_group
    ADD CONSTRAINT uni_group_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: uni_group uni_group_group_curator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uni_group
    ADD CONSTRAINT uni_group_group_curator_id_fkey FOREIGN KEY (curator_id) REFERENCES public.lector(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 46k2MOjbnm4X6lTbTfM82hHeK7WMBlEoTkJxIYbm6LgTYUtjoBHtiCPh1Fyknkb

