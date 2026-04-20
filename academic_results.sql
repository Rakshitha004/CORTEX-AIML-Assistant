--
-- PostgreSQL database dump
--

\restrict bNSe1BzZSPshVpwUOpDJoatxy2nsONFEFhm4oVlPAfGIiWh6RUlenMfTNb04Bir

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: semester_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semester_results (
    id integer NOT NULL,
    usn text NOT NULL,
    semester integer NOT NULL,
    sgpa real
);


ALTER TABLE public.semester_results OWNER TO postgres;

--
-- Name: semester_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semester_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semester_results_id_seq OWNER TO postgres;

--
-- Name: semester_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semester_results_id_seq OWNED BY public.semester_results.id;


--
-- Name: student_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_results (
    sl_no integer NOT NULL,
    usn text,
    name text,
    cgpa real
);


ALTER TABLE public.student_results OWNER TO postgres;

--
-- Name: student_results_sl_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_results_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_results_sl_no_seq OWNER TO postgres;

--
-- Name: student_results_sl_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_results_sl_no_seq OWNED BY public.student_results.sl_no;


--
-- Name: subject_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_grades (
    id integer NOT NULL,
    usn text NOT NULL,
    semester integer NOT NULL,
    subject_code text NOT NULL,
    subject_name text,
    grade text
);


ALTER TABLE public.subject_grades OWNER TO postgres;

--
-- Name: subject_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_grades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_grades_id_seq OWNER TO postgres;

--
-- Name: subject_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_grades_id_seq OWNED BY public.subject_grades.id;


--
-- Name: semester_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester_results ALTER COLUMN id SET DEFAULT nextval('public.semester_results_id_seq'::regclass);


--
-- Name: student_results sl_no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_results ALTER COLUMN sl_no SET DEFAULT nextval('public.student_results_sl_no_seq'::regclass);


--
-- Name: subject_grades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_grades ALTER COLUMN id SET DEFAULT nextval('public.subject_grades_id_seq'::regclass);


--
-- Data for Name: semester_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester_results (id, usn, semester, sgpa) FROM stdin;
1	1DS21AI001	3	8.58
2	1DS21AI002	3	9.67
3	1DS21AI003	3	7.67
4	1DS21AI004	3	7.94
5	1DS21AI005	3	9.5
6	1DS21AI006	3	8
7	1DS21AI007	3	2.56
8	1DS21AI008	3	9.06
9	1DS21AI009	3	8.87
10	1DS21AI010	3	9.5
11	1DS21AI011	3	7.33
12	1DS21AI012	3	9.44
13	1DS21AI013	3	4.39
14	1DS21AI014	3	3.72
15	1DS21AI015	3	6.89
16	1DS21AI016	3	9.5
17	1DS21AI017	3	9.33
18	1DS21AI018	3	9.11
19	1DS21AI019	3	3.78
20	1DS21AI020	3	6.44
21	1DS21AI021	3	9.06
22	1DS21AI022	3	7.44
23	1DS21AI023	3	10
24	1DS21AI024	3	4.89
25	1DS21AI025	3	8.72
26	1DS21AI026	3	5.33
27	1DS21AI027	3	7.89
28	1DS21AI028	3	9.72
29	1DS21AI029	3	7.56
30	1DS21AI030	3	8.67
31	1DS21AI031	3	8.17
32	1DS21AI032	3	8.33
33	1DS21AI033	3	3.56
34	1DS21AI034	3	9.23
35	1DS21AI035	3	7.44
36	1DS21AI036	3	9.17
37	1DS21AI037	3	9.11
38	1DS21AI038	3	8.33
39	1DS21AI039	3	7.61
40	1DS21AI040	3	8.83
41	1DS21AI041	3	7.83
42	1DS21AI042	3	9.17
43	1DS21AI043	3	9.06
44	1DS21AI044	3	6.61
45	1DS21AI045	3	8.94
46	1DS21AI046	3	8.33
47	1DS21AI047	3	8.87
48	1DS21AI048	3	8.5
49	1DS21AI049	3	8.89
50	1DS21AI050	3	7.28
51	1DS21AI051	3	7.11
52	1DS21AI052	3	9.33
53	1DS21AI053	3	8.39
54	1DS21AI054	3	9.17
55	1DS21AI055	3	10
56	1DS21AI056	3	4.61
57	1DS21AI057	3	8.89
58	1DS21AI058	3	8.5
59	1DS21AI059	3	7.44
60	1DS21AI001	4	9.5
61	1DS21AI002	4	9.86
62	1DS21AI003	4	8.59
63	1DS21AI004	4	8.05
64	1DS21AI005	4	9.86
65	1DS21AI006	4	8.86
66	1DS21AI007	4	4.86
67	1DS21AI008	4	9.32
68	1DS21AI009	4	9.14
69	1DS21AI010	4	9.45
70	1DS21AI011	4	8.41
71	1DS21AI012	4	9.86
72	1DS21AI013	4	6.36
73	1DS21AI014	4	5.32
74	1DS21AI015	4	7.32
75	1DS21AI016	4	9.86
76	1DS21AI017	4	9.73
77	1DS21AI018	4	9.36
78	1DS21AI019	4	7.64
79	1DS21AI020	4	7.45
80	1DS21AI021	4	9.64
81	1DS21AI022	4	6.91
82	1DS21AI023	4	10
83	1DS21AI024	4	7.18
84	1DS21AI025	4	9.27
85	1DS21AI026	4	6.91
86	1DS21AI027	4	9.59
87	1DS21AI028	4	9.86
88	1DS21AI029	4	7.59
89	1DS21AI030	4	9.14
90	1DS21AI031	4	8.86
91	1DS21AI032	4	8.55
92	1DS21AI033	4	7.32
93	1DS21AI034	4	9.64
94	1DS21AI035	4	8.45
95	1DS21AI036	4	9.64
96	1DS21AI037	4	9.27
97	1DS21AI038	4	8.82
98	1DS21AI039	4	7.77
99	1DS21AI040	4	8.73
100	1DS21AI041	4	9.05
101	1DS21AI042	4	9.5
102	1DS21AI043	4	9.36
103	1DS21AI044	4	8.36
104	1DS21AI045	4	8.86
105	1DS21AI046	4	9
106	1DS21AI047	4	9.53
107	1DS21AI048	4	9.18
108	1DS21AI049	4	9.09
109	1DS21AI050	4	8.82
110	1DS21AI051	4	7.55
111	1DS21AI052	4	9.55
112	1DS21AI053	4	8.86
113	1DS21AI054	4	9.86
114	1DS21AI055	4	10
115	1DS21AI056	4	7.45
116	1DS21AI057	4	9.45
117	1DS21AI058	4	9.45
118	1DS21AI059	4	8.68
119	1DS21AI001	5	9.28
120	1DS21AI002	5	9.44
121	1DS21AI003	5	7.83
122	1DS21AI004	5	4.83
123	1DS21AI005	5	9.39
124	1DS21AI006	5	8.67
125	1DS21AI007	5	5.78
126	1DS21AI008	5	9.17
127	1DS21AI009	5	9.44
128	1DS21AI010	5	9.61
129	1DS21AI011	5	8.5
130	1DS21AI012	5	9.67
131	1DS21AI013	5	7.33
132	1DS21AI014	5	6.94
133	1DS21AI015	5	7.83
134	1DS21AI016	5	9.67
135	1DS21AI017	5	9.33
136	1DS21AI018	5	9.39
137	1DS21AI019	5	8.33
138	1DS21AI020	5	8.33
139	1DS21AI021	5	9.06
140	1DS21AI022	5	8.61
141	1DS21AI023	5	10
142	1DS21AI024	5	8.44
143	1DS21AI025	5	9.33
144	1DS21AI026	5	7.5
145	1DS21AI027	5	8.72
146	1DS21AI028	5	9.89
147	1DS21AI029	5	4.72
148	1DS21AI030	5	8.72
149	1DS21AI031	5	8.5
150	1DS21AI032	5	8.17
151	1DS21AI033	5	7.44
152	1DS21AI034	5	9.28
153	1DS21AI035	5	8.39
154	1DS21AI036	5	9.67
155	1DS21AI037	5	9.22
156	1DS21AI038	5	8.06
157	1DS21AI039	5	8.78
158	1DS21AI040	5	8.94
159	1DS21AI041	5	8.83
160	1DS21AI042	5	9.44
161	1DS21AI043	5	9.44
162	1DS21AI044	5	8.72
163	1DS21AI045	5	8.67
164	1DS21AI046	5	9
165	1DS21AI047	5	9.22
166	1DS21AI048	5	8.28
167	1DS21AI049	5	8.61
168	1DS21AI050	5	9.39
169	1DS21AI051	5	7.72
170	1DS21AI052	5	9.67
171	1DS21AI053	5	8.33
172	1DS21AI054	5	9.5
173	1DS21AI055	5	9.89
174	1DS21AI056	5	7.39
175	1DS21AI057	5	8.89
176	1DS21AI058	5	9.72
177	1DS21AI059	5	8.17
178	1DS21AI001	6	9.18
179	1DS21AI002	6	9.64
180	1DS21AI003	6	8.14
181	1DS21AI004	6	1.77
182	1DS21AI005	6	9.73
183	1DS21AI006	6	8.09
184	1DS21AI007	6	6.36
185	1DS21AI008	6	9.14
186	1DS21AI009	6	9.73
187	1DS21AI010	6	9.59
188	1DS21AI011	6	9.14
189	1DS21AI012	6	9.86
190	1DS21AI013	6	8
191	1DS21AI014	6	8
192	1DS21AI015	6	8.5
193	1DS21AI016	6	9.32
194	1DS21AI017	6	9.86
195	1DS21AI018	6	9.86
196	1DS21AI019	6	8.27
197	1DS21AI020	6	8.5
198	1DS21AI021	6	9.59
199	1DS21AI022	6	9.32
200	1DS21AI023	6	10
201	1DS21AI024	6	8.68
202	1DS21AI025	6	9.73
203	1DS21AI026	6	7.82
204	1DS21AI027	6	8.82
205	1DS21AI028	6	9.59
206	1DS21AI029	6	1.64
207	1DS21AI030	6	8.59
208	1DS21AI031	6	9.73
209	1DS21AI032	6	8.27
210	1DS21AI033	6	7.09
211	1DS21AI034	6	10
212	1DS21AI035	6	9.05
213	1DS21AI036	6	9.73
214	1DS21AI037	6	9.45
215	1DS21AI038	6	8.82
216	1DS21AI039	6	8.55
217	1DS21AI040	6	9.45
218	1DS21AI041	6	9.59
219	1DS21AI042	6	9.86
220	1DS21AI043	6	9.64
221	1DS21AI044	6	9.59
222	1DS21AI045	6	9.14
223	1DS21AI046	6	9.27
224	1DS21AI047	6	9.64
225	1DS21AI048	6	8.86
226	1DS21AI049	6	9.45
227	1DS21AI050	6	9.45
228	1DS21AI051	6	8.59
229	1DS21AI052	6	9.59
230	1DS21AI053	6	8.95
231	1DS21AI054	6	9.86
232	1DS21AI055	6	10
233	1DS21AI056	6	8.27
234	1DS21AI057	6	9.73
235	1DS21AI058	6	9.86
236	1DS21AI059	6	8.09
237	1DS21AI001	7	9.29
238	1DS21AI002	7	9.5
239	1DS21AI003	7	8.92
240	1DS21AI004	7	5.54
241	1DS21AI005	7	9.75
242	1DS21AI006	7	8.46
243	1DS21AI007	7	6.67
244	1DS21AI008	7	9.33
245	1DS21AI009	7	9.75
246	1DS21AI010	7	9.88
247	1DS21AI011	7	9.29
248	1DS21AI012	7	9.5
249	1DS21AI013	7	6.29
250	1DS21AI014	7	8.58
251	1DS21AI015	7	8.75
252	1DS21AI016	7	9.42
253	1DS21AI017	7	9.88
254	1DS21AI018	7	9.54
255	1DS21AI019	7	8.33
256	1DS21AI020	7	8.79
257	1DS21AI021	7	9.21
258	1DS21AI022	7	9.5
259	1DS21AI023	7	9.63
260	1DS21AI024	7	9.17
261	1DS21AI025	7	9.54
262	1DS21AI026	7	8.29
263	1DS21AI027	7	9.17
264	1DS21AI028	7	9.75
265	1DS21AI029	7	4.96
266	1DS21AI030	7	9.42
267	1DS21AI031	7	9.54
268	1DS21AI032	7	8.83
269	1DS21AI033	7	8.17
270	1DS21AI034	7	9.75
271	1DS21AI035	7	8.79
272	1DS21AI036	7	9.88
273	1DS21AI037	7	9.45
274	1DS21AI038	7	8.63
275	1DS21AI039	7	8.79
276	1DS21AI040	7	9.29
277	1DS21AI041	7	9.54
278	1DS21AI042	7	9.88
279	1DS21AI043	7	9.29
280	1DS21AI044	7	9.29
281	1DS21AI045	7	9.33
282	1DS21AI046	7	9.04
283	1DS21AI047	7	9.75
284	1DS21AI048	7	9.46
285	1DS21AI049	7	9.04
286	1DS21AI050	7	9.54
287	1DS21AI051	7	8
288	1DS21AI052	7	9.38
289	1DS21AI053	7	8.71
290	1DS21AI054	7	9.75
291	1DS21AI055	7	10
292	1DS21AI056	7	8.21
293	1DS21AI057	7	9.54
294	1DS21AI058	7	9.88
295	1DS21AI059	7	7.92
296	1DS21AI001	8	10
297	1DS21AI002	8	9.94
298	1DS21AI003	8	9.88
299	1DS21AI004	8	5.94
300	1DS21AI005	8	10
301	1DS21AI006	8	6.13
302	1DS21AI007	8	9.88
303	1DS21AI008	8	9.94
304	1DS21AI009	8	9.94
305	1DS21AI010	8	9
306	1DS21AI011	8	9.94
307	1DS21AI012	8	10
308	1DS21AI013	8	5
309	1DS21AI014	8	7.94
310	1DS21AI015	8	7
311	1DS21AI016	8	9
312	1DS21AI017	8	9.06
313	1DS21AI018	8	10
314	1DS21AI019	8	6.94
315	1DS21AI020	8	8.94
316	1DS21AI021	8	9
317	1DS21AI022	8	9.88
318	1DS21AI023	8	10
319	1DS21AI024	8	8.94
320	1DS21AI025	8	9.94
321	1DS21AI026	8	10
322	1DS21AI027	8	8
323	1DS21AI028	8	9.06
324	1DS21AI029	8	6
325	1DS21AI030	8	9.88
326	1DS21AI031	8	9.94
327	1DS21AI032	8	9
328	1DS21AI033	8	8
329	1DS21AI034	8	9.06
330	1DS21AI035	8	8.88
331	1DS21AI036	8	10
332	1DS21AI037	8	10
333	1DS21AI038	8	8.81
334	1DS21AI039	8	10
335	1DS21AI040	8	10
336	1DS21AI041	8	0.63
337	1DS21AI042	8	9.06
338	1DS21AI043	8	10
339	1DS21AI044	8	9
340	1DS21AI045	8	9.94
341	1DS21AI046	8	10
342	1DS21AI047	8	9.94
343	1DS21AI048	8	9.94
344	1DS21AI049	8	9.94
345	1DS21AI050	8	9.06
346	1DS21AI051	8	9
347	1DS21AI052	8	10
348	1DS21AI053	8	9.88
349	1DS21AI054	8	9
350	1DS21AI055	8	10
351	1DS21AI056	8	8.94
352	1DS21AI057	8	10
353	1DS21AI058	8	8.94
354	1DS21AI059	8	8.94
\.


--
-- Data for Name: student_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_results (sl_no, usn, name, cgpa) FROM stdin;
1	1DS21AI001	ADITHYA N AWATI	9.3
2	1DS21AI002	AMIT A	9.67
3	1DS21AI003	ANIRUDH VISHWAS HEGDE	8.51
4	1DS21AI004	ANKAN BHATT	5.68
5	1DS21AI005	ANKUSH G	9.71
6	1DS21AI006	ARYAMAN SAXENA	8.04
7	1DS21AI007	ASHWIN SAI G	6.02
8	1DS21AI008	B J PHANINDRA BABU	9.33
9	1DS21AI009	BHARGAVI K	9.48
10	1DS21AI010	BHUVAN KUMAR M	9.51
11	1DS21AI011	CHANDRU	8.77
12	1DS21AI012	CHARAN GOWDA B M	9.72
13	1DS21AI013	DANIYAL EKRAM	6.23
14	1DS21AI014	DARSHAN R	6.75
15	1DS21AI015	DHARSHAN R KUMAR	7.71
16	1DS21AI016	EBUDI HARSHITH	9.46
17	1DS21AI017	FATIMA ANEES MULLA	9.53
18	1DS21AI018	GURUDARSHAN L	9.54
19	1DS21AI019	HARIKRISHNA M	7.21
20	1DS21AI020	HARSHITHA B	8.08
21	1DS21AI021	HARSHITHA S	9.26
22	1DS21AI022	HEMANTH GOWDA V	8.61
23	1DS21AI023	HITHA N	9.94
24	1DS21AI024	JEEVAN T R	7.88
25	1DS21AI025	JYOTI SHMATI	9.42
26	1DS21AI026	KAASHIF MERAJ	7.64
27	1DS21AI027	KOTIREDDY CHARAN SIMHA REDDY	8.7
28	1DS21AI028	KRUTIKA R SINNUR	9.65
29	1DS21AI029	KUSH CHAUHAN	5.41
30	1DS21AI030	MANAS KALRA	9.07
31	1DS21AI031	MANASVINI T	9.12
32	1DS21AI032	MESHANK BANSAL	8.53
33	1DS21AI033	MITHUN KESHAVALU REDDY K	6.93
34	1DS21AI034	MONICA K C	9.49
35	1DS21AI035	NANDITHA K G	8.5
36	1DS21AI036	NIHARIKA RAJENDRA ANKALKOTI	9.68
37	1DS21AI037	NISARGA B	9.42
38	1DS21AI038	PRAJWAL K	8.58
39	1DS21AI039	PRAKRITI SINGH	8.58
40	1DS21AI040	PRERANA S B	9.21
41	1DS21AI041	RADHIKA MITTAL	7.58
42	1DS21AI042	RIJUTHA A	9.48
43	1DS21AI043	ROHAN D	9.46
44	1DS21AI044	S UDAY KUMAR	8.6
45	1DS21AI045	SHA AARIZE SIDDIQUE	9.15
46	1DS21AI046	SHIVABASAVAMATUR	9.11
47	1DS21AI047	SHREESHA S	9.49
48	1DS21AI048	SHREYAS M J KALKUR	9.04
49	1DS21AI049	SHUBHAM MISHRA	9.17
50	1DS21AI050	SK SAI TARUN	8.92
51	1DS21AI051	SUHAS KASHAYAP M S	8
52	1DS21AI052	SUPRITH A S	9.59
53	1DS21AI053	UDAYASURYA S	8.85
54	1DS21AI054	VELPULA JASWANTH REDDY	9.52
55	1DS21AI055	VIDYA V	9.98
56	1DS21AI056	YARASINGU SHANMUKHA PRIYA	7.48
57	1DS21AI057	YASH GOVIL	9.42
58	1DS21AI058	YASHAS A M	9.39
59	1DS21AI059	YASHVARDHAN MALIK	8.21
\.


--
-- Data for Name: subject_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject_grades (id, usn, semester, subject_code, subject_name, grade) FROM stdin;
1	1DS21AI001	3	21MAT31A	Foundation in Mathematics	B
2	1DS21AI001	3	21AI32	Data Structures with Applications	B
3	1DS21AI001	3	21AI33	Database Management System	B
4	1DS21AI001	3	21AI34	Software Engineering	A
5	1DS21AI001	3	21AIL35	Application Development Using Python Lab	B
6	1DS21AI001	3	21SCR36	Social Connect and Responsibility	B
7	1DS21AI001	3	21CIP37	Constitution of India and Professional Ethics	S
8	1DS21AI001	3	21AIL381	Robotic Process Automation	S
9	1DS21AI002	3	21MAT31A	Foundation in Mathematics	O
10	1DS21AI002	3	21AI32	Data Structures with Applications	O
11	1DS21AI002	3	21AI33	Database Management System	A+
12	1DS21AI002	3	21AI34	Software Engineering	O
13	1DS21AI002	3	21AIL35	Application Development Using Python Lab	O
14	1DS21AI002	3	21SCR36	Social Connect and Responsibility	O
15	1DS21AI002	3	21CIP37	Constitution of India and Professional Ethics	O
16	1DS21AI002	3	21AIL381	Robotic Process Automation	O
17	1DS21AI003	3	21MAT31A	Foundation in Mathematics	A
18	1DS21AI003	3	21AI32	Data Structures with Applications	B+
19	1DS21AI003	3	21AI33	Database Management System	B+
20	1DS21AI003	3	21AI34	Software Engineering	B+
21	1DS21AI003	3	21AIL35	Application Development Using Python Lab	O
22	1DS21AI003	3	21SCR36	Social Connect and Responsibility	O
23	1DS21AI003	3	21CIP37	Constitution of India and Professional Ethics	B+
24	1DS21AI003	3	21AIL381	Robotic Process Automation	O
25	1DS21AI004	3	21MAT31A	Foundation in Mathematics	A
26	1DS21AI004	3	21AI32	Data Structures with Applications	B+
27	1DS21AI004	3	21AI33	Database Management System	A
28	1DS21AI004	3	21AI34	Software Engineering	A
29	1DS21AI004	3	21AIL35	Application Development Using Python Lab	O
30	1DS21AI004	3	21SCR36	Social Connect and Responsibility	A+
31	1DS21AI004	3	21CIP37	Constitution of India and Professional Ethics	B+
32	1DS21AI004	3	21AIL381	Robotic Process Automation	A+
33	1DS21AI005	3	21MAT31A	Foundation in Mathematics	O
34	1DS21AI005	3	21AI32	Data Structures with Applications	O
35	1DS21AI005	3	21AI33	Database Management System	A+
36	1DS21AI005	3	21AI34	Software Engineering	A+
37	1DS21AI005	3	21AIL35	Application Development Using Python Lab	O
38	1DS21AI005	3	21SCR36	Social Connect and Responsibility	O
39	1DS21AI005	3	21CIP37	Constitution of India and Professional Ethics	A
40	1DS21AI005	3	21AIL381	Robotic Process Automation	O
41	1DS21AI006	3	21MAT31A	Foundation in Mathematics	A+
42	1DS21AI006	3	21AI32	Data Structures with Applications	B+
43	1DS21AI006	3	21AI33	Database Management System	B+
44	1DS21AI006	3	21AI34	Software Engineering	A
45	1DS21AI006	3	21AIL35	Application Development Using Python Lab	O
46	1DS21AI006	3	21SCR36	Social Connect and Responsibility	A+
47	1DS21AI006	3	21CIP37	Constitution of India and Professional Ethics	A+
48	1DS21AI006	3	21AIL381	Robotic Process Automation	A+
49	1DS21AI007	3	21MAT31A	Foundation in Mathematics	F
50	1DS21AI007	3	21AI32	Data Structures with Applications	F
51	1DS21AI007	3	21AI33	Database Management System	F
52	1DS21AI007	3	21AI34	Software Engineering	C
53	1DS21AI007	3	21AIL35	Application Development Using Python Lab	A+
54	1DS21AI007	3	21SCR36	Social Connect and Responsibility	A
55	1DS21AI007	3	21CIP37	Constitution of India and Professional Ethics	C
56	1DS21AI007	3	21AIL381	Robotic Process Automation	A+
57	1DS21AI008	3	21MAT31A	Foundation in Mathematics	O
58	1DS21AI008	3	21AI32	Data Structures with Applications	A+
59	1DS21AI008	3	21AI33	Database Management System	A
60	1DS21AI008	3	21AI34	Software Engineering	A+
61	1DS21AI008	3	21AIL35	Application Development Using Python Lab	O
62	1DS21AI008	3	21SCR36	Social Connect and Responsibility	O
63	1DS21AI008	3	21CIP37	Constitution of India and Professional Ethics	A
64	1DS21AI008	3	21AIL381	Robotic Process Automation	O
65	1DS21AI009	3	21MAT31A	Foundation in Mathematics	A+
66	1DS21AI009	3	21AI32	Data Structures with Applications	A+
67	1DS21AI009	3	21AI33	Database Management System	A+
68	1DS21AI009	3	21AI34	Software Engineering	A
69	1DS21AI009	3	21AIL35	Application Development Using Python Lab	O
70	1DS21AI009	3	21SCR36	Social Connect and Responsibility	O
71	1DS21AI009	3	21CIP37	Constitution of India and Professional Ethics	A+
72	1DS21AI009	3	21AIL381	Robotic Process Automation	O
73	1DS21AI010	3	21MAT31A	Foundation in Mathematics	A+
74	1DS21AI010	3	21AI32	Data Structures with Applications	O
75	1DS21AI010	3	21AI33	Database Management System	A+
76	1DS21AI010	3	21AI34	Software Engineering	O
77	1DS21AI010	3	21AIL35	Application Development Using Python Lab	O
78	1DS21AI010	3	21SCR36	Social Connect and Responsibility	O
79	1DS21AI010	3	21CIP37	Constitution of India and Professional Ethics	A
80	1DS21AI010	3	21AIL381	Robotic Process Automation	O
81	1DS21AI011	3	21MAT31A	Foundation in Mathematics	A
82	1DS21AI011	3	21AI32	Data Structures with Applications	B+
83	1DS21AI011	3	21AI33	Database Management System	B+
84	1DS21AI011	3	21AI34	Software Engineering	A
85	1DS21AI011	3	21AIL35	Application Development Using Python Lab	A+
86	1DS21AI011	3	21SCR36	Social Connect and Responsibility	A+
174	1DS21AI022	3	21SCR36	Social Connect and Responsibility	0
87	1DS21AI011	3	21CIP37	Constitution of India and Professional Ethics	B+
88	1DS21AI011	3	21AIL381	Robotic Process Automation	A+
89	1DS21AI012	3	21MAT31A	Foundation in Mathematics	A+
90	1DS21AI012	3	21AI32	Data Structures with Applications	A+
91	1DS21AI012	3	21AI33	Database Management System	O
92	1DS21AI012	3	21AI34	Software Engineering	A+
93	1DS21AI012	3	21AIL35	Application Development Using Python Lab	O
94	1DS21AI012	3	21SCR36	Social Connect and Responsibility	O
95	1DS21AI012	3	21CIP37	Constitution of India and Professional Ethics	O
96	1DS21AI012	3	21AIL381	Robotic Process Automation	O
97	1DS21AI013	3	21MAT31A	Foundation in Mathematics	F
98	1DS21AI013	3	21AI32	Data Structures with Applications	P
99	1DS21AI013	3	21AI33	Database Management System	P
100	1DS21AI013	3	21AI34	Software Engineering	C
101	1DS21AI013	3	21AIL35	Application Development Using Python Lab	A
102	1DS21AI013	3	21SCR36	Social Connect and Responsibility	A+
103	1DS21AI013	3	21CIP37	Constitution of India and Professional Ethics	B
104	1DS21AI013	3	21AIL381	Robotic Process Automation	B+
105	1DS21AI014	3	21MAT31A	Foundation in Mathematics	F
106	1DS21AI014	3	21AI32	Data Structures with Applications	F
107	1DS21AI014	3	21AI33	Database Management System	P
108	1DS21AI014	3	21AI34	Software Engineering	C
109	1DS21AI014	3	21AIL35	Application Development Using Python Lab	A+
110	1DS21AI014	3	21SCR36	Social Connect and Responsibility	A+
111	1DS21AI014	3	21CIP37	Constitution of India and Professional Ethics	B+
112	1DS21AI014	3	21AIL381	Robotic Process Automation	O
113	1DS21AI015	3	21MAT31A	Foundation in Mathematics	A
114	1DS21AI015	3	21AI32	Data Structures with Applications	C
115	1DS21AI015	3	21AI33	Database Management System	B+
116	1DS21AI015	3	21AI34	Software Engineering	B
117	1DS21AI015	3	21AIL35	Application Development Using Python Lab	A+
118	1DS21AI015	3	21SCR36	Social Connect and Responsibility	A+
119	1DS21AI015	3	21CIP37	Constitution of India and Professional Ethics	B+
120	1DS21AI015	3	21AIL381	Robotic Process Automation	A+
121	1DS21AI016	3	21MAT31A	Foundation in Mathematics	O
122	1DS21AI016	3	21AI32	Data Structures with Applications	O
123	1DS21AI016	3	21AI33	Database Management System	A
124	1DS21AI016	3	21AI34	Software Engineering	O
125	1DS21AI016	3	21AIL35	Application Development Using Python Lab	O
126	1DS21AI016	3	21SCR36	Social Connect and Responsibility	O
127	1DS21AI016	3	21CIP37	Constitution of India and Professional Ethics	A+
128	1DS21AI016	3	21AIL381	Robotic Process Automation	O
129	1DS21AI017	3	21MAT31A	Foundation in Mathematics	O
130	1DS21AI017	3	21AI32	Data Structures with Applications	A+
131	1DS21AI017	3	21AI33	Database Management System	A+
132	1DS21AI017	3	21AI34	Software Engineering	A+
133	1DS21AI017	3	21AIL35	Application Development Using Python Lab	O
134	1DS21AI017	3	21SCR36	Social Connect and Responsibility	O
135	1DS21AI017	3	21CIP37	Constitution of India and Professional Ethics	A+
136	1DS21AI017	3	21AIL381	Robotic Process Automation	O
137	1DS21AI018	3	21MAT31A	Foundation in Mathematics	O
138	1DS21AI018	3	21AI32	Data Structures with Applications	A+
139	1DS21AI018	3	21AI33	Database Management System	A
140	1DS21AI018	3	21AI34	Software Engineering	A+
141	1DS21AI018	3	21AIL35	Application Development Using Python Lab	O
142	1DS21AI018	3	21SCR36	Social Connect and Responsibility	O
143	1DS21AI018	3	21CIP37	Constitution of India and Professional Ethics	A+
144	1DS21AI018	3	21AIL381	Robotic Process Automation	O
145	1DS21AI019	3	21MAT31A	Foundation in Mathematics	P
146	1DS21AI019	3	21AI32	Data Structures with Applications	C
147	1DS21AI019	3	21AI33	Database Management System	F
148	1DS21AI019	3	21AI34	Software Engineering	F
149	1DS21AI019	3	21AIL35	Application Development Using Python Lab	A+
150	1DS21AI019	3	21SCR36	Social Connect and Responsibility	O
151	1DS21AI019	3	21CIP37	Constitution of India and Professional Ethics	B+
152	1DS21AI019	3	21AIL381	Robotic Process Automation	O
153	1DS21AI020	3	21MAT31A	Foundation in Mathematics	B+
154	1DS21AI020	3	21AI32	Data Structures with Applications	P
155	1DS21AI020	3	21AI33	Database Management System	B
156	1DS21AI020	3	21AI34	Software Engineering	B+
157	1DS21AI020	3	21AIL35	Application Development Using Python Lab	A+
158	1DS21AI020	3	21SCR36	Social Connect and Responsibility	A+
159	1DS21AI020	3	21CIP37	Constitution of India and Professional Ethics	B+
160	1DS21AI020	3	21AIL381	Robotic Process Automation	A+
161	1DS21AI021	3	21MAT31A	Foundation in Mathematics	A+
162	1DS21AI021	3	21AI32	Data Structures with Applications	A+
163	1DS21AI021	3	21AI33	Database Management System	A+
164	1DS21AI021	3	21AI34	Software Engineering	A+
165	1DS21AI021	3	21AIL35	Application Development Using Python Lab	O
166	1DS21AI021	3	21SCR36	Social Connect and Responsibility	O
167	1DS21AI021	3	21CIP37	Constitution of India and Professional Ethics	B+
168	1DS21AI021	3	21AIL381	Robotic Process Automation	O
169	1DS21AI022	3	21MAT31A	Foundation in Mathematics	B+
170	1DS21AI022	3	21AI32	Data Structures with Applications	B
171	1DS21AI022	3	21AI33	Database Management System	B+
172	1DS21AI022	3	21AI34	Software Engineering	A
173	1DS21AI022	3	21AIL35	Application Development Using Python Lab	A+
175	1DS21AI022	3	21CIP37	Constitution of India and Professional Ethics	A
176	1DS21AI022	3	21AIL381	Robotic Process Automation	0
177	1DS21AI023	3	21MAT31A	Foundation in Mathematics	O
178	1DS21AI023	3	21AI32	Data Structures with Applications	O
179	1DS21AI023	3	21AI33	Database Management System	O
180	1DS21AI023	3	21AI34	Software Engineering	O
181	1DS21AI023	3	21AIL35	Application Development Using Python Lab	O
182	1DS21AI023	3	21SCR36	Social Connect and Responsibility	O
183	1DS21AI023	3	21CIP37	Constitution of India and Professional Ethics	O
184	1DS21AI023	3	21AIL381	Robotic Process Automation	O
185	1DS21AI024	3	21MAT31A	Foundation in Mathematics	B
186	1DS21AI024	3	21AI32	Data Structures with Applications	C
187	1DS21AI024	3	21AI33	Database Management System	P
188	1DS21AI024	3	21AI34	Software Engineering	F
189	1DS21AI024	3	21AIL35	Application Development Using Python Lab	A+
190	1DS21AI024	3	21SCR36	Social Connect and Responsibility	A+
191	1DS21AI024	3	21CIP37	Constitution of India and Professional Ethics	B+
192	1DS21AI024	3	21AIL381	Robotic Process Automation	A+
193	1DS21AI025	3	21MAT31A	Foundation in Mathematics	A+
194	1DS21AI025	3	21AI32	Data Structures with Applications	A+
195	1DS21AI025	3	21AI33	Database Management System	A
196	1DS21AI025	3	21AI34	Software Engineering	A
197	1DS21AI025	3	21AIL35	Application Development Using Python Lab	O
198	1DS21AI025	3	21SCR36	Social Connect and Responsibility	A+
199	1DS21AI025	3	21CIP37	Constitution of India and Professional Ethics	A+
200	1DS21AI025	3	21AIL381	Robotic Process Automation	0
201	1DS21AI026	3	21MAT31A	Foundation in Mathematics	B
202	1DS21AI026	3	21AI32	Data Structures with Applications	C
203	1DS21AI026	3	21AI33	Database Management System	F
204	1DS21AI026	3	21AI34	Software Engineering	B+
205	1DS21AI026	3	21AIL35	Application Development Using Python Lab	O
206	1DS21AI026	3	21SCR36	Social Connect and Responsibility	A+
207	1DS21AI026	3	21CIP37	Constitution of India and Professional Ethics	A
208	1DS21AI026	3	21AIL381	Robotic Process Automation	O
209	1DS21AI027	3	21MAT31A	Foundation in Mathematics	O
210	1DS21AI027	3	21AI32	Data Structures with Applications	B+
211	1DS21AI027	3	21AI33	Database Management System	B+
212	1DS21AI027	3	21AI34	Software Engineering	B+
213	1DS21AI027	3	21AIL35	Application Development Using Python Lab	A+
214	1DS21AI027	3	21SCR36	Social Connect and Responsibility	O
215	1DS21AI027	3	21CIP37	Constitution of India and Professional Ethics	B+
216	1DS21AI027	3	21AIL381	Robotic Process Automation	A+
217	1DS21AI028	3	21MAT31A	Foundation in Mathematics	O
218	1DS21AI028	3	21AI32	Data Structures with Applications	O
219	1DS21AI028	3	21AI33	Database Management System	A+
220	1DS21AI028	3	21AI34	Software Engineering	A
221	1DS21AI028	3	21AIL35	Application Development Using Python Lab	O
222	1DS21AI028	3	21SCR36	Social Connect and Responsibility	O
223	1DS21AI028	3	21CIP37	Constitution of India and Professional Ethics	A+
224	1DS21AI028	3	21AIL381	Robotic Process Automation	O
225	1DS21AI029	3	21MAT31A	Foundation in Mathematics	A
226	1DS21AI029	3	21AI32	Data Structures with Applications	B+
227	1DS21AI029	3	21AI33	Database Management System	B+
228	1DS21AI029	3	21AI34	Software Engineering	B+
229	1DS21AI029	3	21AIL35	Application Development Using Python Lab	A+
230	1DS21AI029	3	21SCR36	Social Connect and Responsibility	O
231	1DS21AI029	3	21CIP37	Constitution of India and Professional Ethics	B+
232	1DS21AI029	3	21AIL381	Robotic Process Automation	A+
233	1DS21AI030	3	21MAT31A	Foundation in Mathematics	A+
234	1DS21AI030	3	21AI32	Data Structures with Applications	A
235	1DS21AI030	3	21AI33	Database Management System	A+
236	1DS21AI030	3	21AI34	Software Engineering	A
237	1DS21AI030	3	21AIL35	Application Development Using Python Lab	O
238	1DS21AI030	3	21SCR36	Social Connect and Responsibility	O
239	1DS21AI030	3	21CIP37	Constitution of India and Professional Ethics	B+
240	1DS21AI030	3	21AIL381	Robotic Process Automation	O
241	1DS21AI031	3	21MAT31A	Foundation in Mathematics	A+
242	1DS21AI031	3	21AI32	Data Structures with Applications	B+
243	1DS21AI031	3	21AI33	Database Management System	A
244	1DS21AI031	3	21AI34	Software Engineering	A
245	1DS21AI031	3	21AIL35	Application Development Using Python Lab	A+
246	1DS21AI031	3	21SCR36	Social Connect and Responsibility	O
247	1DS21AI031	3	21CIP37	Constitution of India and Professional Ethics	B+
248	1DS21AI031	3	21AIL381	Robotic Process Automation	O
249	1DS21AI032	3	21MAT31A	Foundation in Mathematics	B+
250	1DS21AI032	3	21AI32	Data Structures with Applications	A+
251	1DS21AI032	3	21AI33	Database Management System	A
252	1DS21AI032	3	21AI34	Software Engineering	A
253	1DS21AI032	3	21AIL35	Application Development Using Python Lab	O
254	1DS21AI032	3	21SCR36	Social Connect and Responsibility	A+
255	1DS21AI032	3	21CIP37	Constitution of India and Professional Ethics	A
256	1DS21AI032	3	21AIL381	Robotic Process Automation	O
257	1DS21AI033	3	21MAT31A	Foundation in Mathematics	F
258	1DS21AI033	3	21AI32	Data Structures with Applications	P
259	1DS21AI033	3	21AI33	Database Management System	P
260	1DS21AI033	3	21AI34	Software Engineering	F
261	1DS21AI033	3	21AIL35	Application Development Using Python Lab	A+
262	1DS21AI033	3	21SCR36	Social Connect and Responsibility	A
263	1DS21AI033	3	21CIP37	Constitution of India and Professional Ethics	B+
264	1DS21AI033	3	21AIL381	Robotic Process Automation	A
265	1DS21AI034	3	21MAT31A	Foundation in Mathematics	0
266	1DS21AI034	3	21AI32	Data Structures with Applications	A+
267	1DS21AI034	3	21AI33	Database Management System	A+
268	1DS21AI034	3	21AI34	Software Engineering	A+
269	1DS21AI034	3	21AIL35	Application Development Using Python Lab	O
270	1DS21AI034	3	21SCR36	Social Connect and Responsibility	O
271	1DS21AI034	3	21CIP37	Constitution of India and Professional Ethics	A
272	1DS21AI034	3	21AIL381	Robotic Process Automation	O
273	1DS21AI035	3	21MAT31A	Foundation in Mathematics	A
274	1DS21AI035	3	21AI32	Data Structures with Applications	B+
275	1DS21AI035	3	21AI33	Database Management System	B
276	1DS21AI035	3	21AI34	Software Engineering	A
277	1DS21AI035	3	21AIL35	Application Development Using Python Lab	A+
278	1DS21AI035	3	21SCR36	Social Connect and Responsibility	A+
279	1DS21AI035	3	21CIP37	Constitution of India and Professional Ethics	B
280	1DS21AI035	3	21AIL381	Robotic Process Automation	O
281	1DS21AI036	3	21MAT31A	Foundation in Mathematics	A+
282	1DS21AI036	3	21AI32	Data Structures with Applications	A+
283	1DS21AI036	3	21AI33	Database Management System	A+
284	1DS21AI036	3	21AI34	Software Engineering	A+
285	1DS21AI036	3	21AIL35	Application Development Using Python Lab	O
286	1DS21AI036	3	21SCR36	Social Connect and Responsibility	O
287	1DS21AI036	3	21CIP37	Constitution of India and Professional Ethics	A+
288	1DS21AI036	3	21AIL381	Robotic Process Automation	O
289	1DS21AI037	3	21MAT31A	Foundation in Mathematics	A+
290	1DS21AI037	3	21AI32	Data Structures with Applications	A+
291	1DS21AI037	3	21AI33	Database Management System	A+
292	1DS21AI037	3	21AI34	Software Engineering	A+
293	1DS21AI037	3	21AIL35	Application Development Using Python Lab	O
294	1DS21AI037	3	21SCR36	Social Connect and Responsibility	O
295	1DS21AI037	3	21CIP37	Constitution of India and Professional Ethics	A
296	1DS21AI037	3	21AIL381	Robotic Process Automation	O
297	1DS21AI038	3	21MAT31A	Foundation in Mathematics	A+
298	1DS21AI038	3	21AI32	Data Structures with Applications	B+
299	1DS21AI038	3	21AI33	Database Management System	A
300	1DS21AI038	3	21AI34	Software Engineering	A+
301	1DS21AI038	3	21AIL35	Application Development Using Python Lab	A
302	1DS21AI038	3	21SCR36	Social Connect and Responsibility	O
303	1DS21AI038	3	21CIP37	Constitution of India and Professional Ethics	A
304	1DS21AI038	3	21AIL381	Robotic Process Automation	O
305	1DS21AI039	3	21MAT31A	Foundation in Mathematics	A+
306	1DS21AI039	3	21AI32	Data Structures with Applications	A
307	1DS21AI039	3	21AI33	Database Management System	B
308	1DS21AI039	3	21AI34	Software Engineering	B+
309	1DS21AI039	3	21AIL35	Application Development Using Python Lab	A+
310	1DS21AI039	3	21SCR36	Social Connect and Responsibility	A+
311	1DS21AI039	3	21CIP37	Constitution of India and Professional Ethics	B+
312	1DS21AI039	3	21AIL381	Robotic Process Automation	A
313	1DS21AI040	3	21MAT31A	Foundation in Mathematics	A+
314	1DS21AI040	3	21AI32	Data Structures with Applications	A+
315	1DS21AI040	3	21AI33	Database Management System	A
316	1DS21AI040	3	21AI34	Software Engineering	A+
317	1DS21AI040	3	21AIL35	Application Development Using Python Lab	A+
318	1DS21AI040	3	21SCR36	Social Connect and Responsibility	O
319	1DS21AI040	3	21CIP37	Constitution of India and Professional Ethics	A
320	1DS21AI040	3	21AIL381	Robotic Process Automation	O
321	1DS21AI041	3	21MAT31A	Foundation in Mathematics	A+
322	1DS21AI041	3	21AI32	Data Structures with Applications	B+
323	1DS21AI041	3	21AI33	Database Management System	B+
324	1DS21AI041	3	21AI34	Software Engineering	B+
325	1DS21AI041	3	21AIL35	Application Development Using Python Lab	O
326	1DS21AI041	3	21SCR36	Social Connect and Responsibility	O
327	1DS21AI041	3	21CIP37	Constitution of India and Professional Ethics	B+
328	1DS21AI041	3	21AIL381	Robotic Process Automation	O
329	1DS21AI042	3	21MAT31A	Foundation in Mathematics	A+
330	1DS21AI042	3	21AI32	Data Structures with Applications	A+
331	1DS21AI042	3	21AI33	Database Management System	A+
332	1DS21AI042	3	21AI34	Software Engineering	A+
333	1DS21AI042	3	21AIL35	Application Development Using Python Lab	O
334	1DS21AI042	3	21SCR36	Social Connect and Responsibility	O
335	1DS21AI042	3	21CIP37	Constitution of India and Professional Ethics	A+
336	1DS21AI042	3	21AIL381	Robotic Process Automation	O
337	1DS21AI043	3	21MAT31A	Foundation in Mathematics	A+
338	1DS21AI043	3	21AI32	Data Structures with Applications	A+
339	1DS21AI043	3	21AI33	Database Management System	A
340	1DS21AI043	3	21AI34	Software Engineering	O
341	1DS21AI043	3	21AIL35	Application Development Using Python Lab	O
342	1DS21AI043	3	21SCR36	Social Connect and Responsibility	O
343	1DS21AI043	3	21CIP37	Constitution of India and Professional Ethics	A
344	1DS21AI043	3	21AIL381	Robotic Process Automation	O
345	1DS21AI044	3	21MAT31A	Foundation in Mathematics	C
346	1DS21AI044	3	21AI32	Data Structures with Applications	C
347	1DS21AI044	3	21AI33	Database Management System	B+
348	1DS21AI044	3	21AI34	Software Engineering	B+
349	1DS21AI044	3	21AIL35	Application Development Using Python Lab	A+
350	1DS21AI044	3	21SCR36	Social Connect and Responsibility	A+
351	1DS21AI044	3	21CIP37	Constitution of India and Professional Ethics	B+
352	1DS21AI044	3	21AIL381	Robotic Process Automation	O
353	1DS21AI045	3	21MAT31A	Foundation in Mathematics	A+
354	1DS21AI045	3	21AI32	Data Structures with Applications	A+
355	1DS21AI045	3	21AI33	Database Management System	A+
356	1DS21AI045	3	21AI34	Software Engineering	A
357	1DS21AI045	3	21AIL35	Application Development Using Python Lab	O
358	1DS21AI045	3	21SCR36	Social Connect and Responsibility	O
359	1DS21AI045	3	21CIP37	Constitution of India and Professional Ethics	A
360	1DS21AI045	3	21AIL381	Robotic Process Automation	O
361	1DS21AI046	3	21MAT31A	Foundation in Mathematics	A
362	1DS21AI046	3	21AI32	Data Structures with Applications	A
363	1DS21AI046	3	21AI33	Database Management System	A
364	1DS21AI046	3	21AI34	Software Engineering	A
365	1DS21AI046	3	21AIL35	Application Development Using Python Lab	O
366	1DS21AI046	3	21SCR36	Social Connect and Responsibility	O
367	1DS21AI046	3	21CIP37	Constitution of India and Professional Ethics	A
368	1DS21AI046	3	21AIL381	Robotic Process Automation	O
369	1DS21AI047	3	21MAT31A	Foundation in Mathematics	A
370	1DS21AI047	3	21AI32	Data Structures with Applications	A+
371	1DS21AI047	3	21AI33	Database Management System	A
372	1DS21AI047	3	21AI34	Software Engineering	A+
373	1DS21AI047	3	21AIL35	Application Development Using Python Lab	O
374	1DS21AI047	3	21SCR36	Social Connect and Responsibility	O
375	1DS21AI047	3	21CIP37	Constitution of India and Professional Ethics	A+
376	1DS21AI047	3	21AIL381	Robotic Process Automation	O
377	1DS21AI048	3	21MAT31A	Foundation in Mathematics	A+
378	1DS21AI048	3	21AI32	Data Structures with Applications	A
379	1DS21AI048	3	21AI33	Database Management System	A
380	1DS21AI048	3	21AI34	Software Engineering	A
381	1DS21AI048	3	21AIL35	Application Development Using Python Lab	O
382	1DS21AI048	3	21SCR36	Social Connect and Responsibility	O
383	1DS21AI048	3	21CIP37	Constitution of India and Professional Ethics	A
384	1DS21AI048	3	21AIL381	Robotic Process Automation	O
385	1DS21AI049	3	21MAT31A	Foundation in Mathematics	O
386	1DS21AI049	3	21AI32	Data Structures with Applications	A+
387	1DS21AI049	3	21AI33	Database Management System	A
388	1DS21AI049	3	21AI34	Software Engineering	A
389	1DS21AI049	3	21AIL35	Application Development Using Python Lab	O
390	1DS21AI049	3	21SCR36	Social Connect and Responsibility	O
391	1DS21AI049	3	21CIP37	Constitution of India and Professional Ethics	A
392	1DS21AI049	3	21AIL381	Robotic Process Automation	O
393	1DS21AI050	3	21MAT31A	Foundation in Mathematics	B+
394	1DS21AI050	3	21AI32	Data Structures with Applications	B+
395	1DS21AI050	3	21AI33	Database Management System	B+
396	1DS21AI050	3	21AI34	Software Engineering	B
397	1DS21AI050	3	21AIL35	Application Development Using Python Lab	A+
398	1DS21AI050	3	21SCR36	Social Connect and Responsibility	O
399	1DS21AI050	3	21CIP37	Constitution of India and Professional Ethics	B+
400	1DS21AI050	3	21AIL381	Robotic Process Automation	O
401	1DS21AI051	3	21MAT31A	Foundation in Mathematics	B+
402	1DS21AI051	3	21AI32	Data Structures with Applications	C
403	1DS21AI051	3	21AI33	Database Management System	B+
404	1DS21AI051	3	21AI34	Software Engineering	A
405	1DS21AI051	3	21AIL35	Application Development Using Python Lab	A+
406	1DS21AI051	3	21SCR36	Social Connect and Responsibility	A+
407	1DS21AI051	3	21CIP37	Constitution of India and Professional Ethics	B+
408	1DS21AI051	3	21AIL381	Robotic Process Automation	O
409	1DS21AI052	3	21MAT31A	Foundation in Mathematics	A+
410	1DS21AI052	3	21AI32	Data Structures with Applications	A+
411	1DS21AI052	3	21AI33	Database Management System	A
412	1DS21AI052	3	21AI34	Software Engineering	A+
413	1DS21AI052	3	21AIL35	Application Development Using Python Lab	O
414	1DS21AI052	3	21SCR36	Social Connect and Responsibility	O
415	1DS21AI052	3	21CIP37	Constitution of India and Professional Ethics	A
416	1DS21AI052	3	21AIL381	Robotic Process Automation	O
417	1DS21AI053	3	21MAT31A	Foundation in Mathematics	A+
418	1DS21AI053	3	21AI32	Data Structures with Applications	A
419	1DS21AI053	3	21AI33	Database Management System	A
420	1DS21AI053	3	21AI34	Software Engineering	A
421	1DS21AI053	3	21AIL35	Application Development Using Python Lab	A+
422	1DS21AI053	3	21SCR36	Social Connect and Responsibility	A+
423	1DS21AI053	3	21CIP37	Constitution of India and Professional Ethics	A
424	1DS21AI053	3	21AIL381	Robotic Process Automation	O
425	1DS21AI054	3	21MAT31A	Foundation in Mathematics	A+
426	1DS21AI054	3	21AI32	Data Structures with Applications	A+
427	1DS21AI054	3	21AI33	Database Management System	A+
428	1DS21AI054	3	21AI34	Software Engineering	A+
429	1DS21AI054	3	21AIL35	Application Development Using Python Lab	O
430	1DS21AI054	3	21SCR36	Social Connect and Responsibility	O
431	1DS21AI054	3	21CIP37	Constitution of India and Professional Ethics	A
432	1DS21AI054	3	21AIL381	Robotic Process Automation	O
433	1DS21AI055	3	21MAT31A	Foundation in Mathematics	O
434	1DS21AI055	3	21AI32	Data Structures with Applications	O
435	1DS21AI055	3	21AI33	Database Management System	O
436	1DS21AI055	3	21AI34	Software Engineering	O
437	1DS21AI055	3	21AIL35	Application Development Using Python Lab	O
438	1DS21AI055	3	21SCR36	Social Connect and Responsibility	O
439	1DS21AI055	3	21CIP37	Constitution of India and Professional Ethics	O
440	1DS21AI055	3	21AIL381	Robotic Process Automation	O
441	1DS21AI056	3	21MAT31A	Foundation in Mathematics	B
442	1DS21AI056	3	21AI32	Data Structures with Applications	F
443	1DS21AI056	3	21AI33	Database Management System	C
444	1DS21AI056	3	21AI34	Software Engineering	C
445	1DS21AI056	3	21AIL35	Application Development Using Python Lab	B
446	1DS21AI056	3	21SCR36	Social Connect and Responsibility	A+
447	1DS21AI056	3	21CIP37	Constitution of India and Professional Ethics	B+
448	1DS21AI056	3	21AIL381	Robotic Process Automation	A
449	1DS21AI057	3	21MAT31A	Foundation in Mathematics	O
450	1DS21AI057	3	21AI32	Data Structures with Applications	A+
451	1DS21AI057	3	21AI33	Database Management System	A
452	1DS21AI057	3	21AI34	Software Engineering	A
453	1DS21AI057	3	21AIL35	Application Development Using Python Lab	O
454	1DS21AI057	3	21SCR36	Social Connect and Responsibility	O
455	1DS21AI057	3	21CIP37	Constitution of India and Professional Ethics	A
456	1DS21AI057	3	21AIL381	Robotic Process Automation	O
457	1DS21AI058	3	21MAT31A	Foundation in Mathematics	A
458	1DS21AI058	3	21AI32	Data Structures with Applications	A
459	1DS21AI058	3	21AI33	Database Management System	A+
460	1DS21AI058	3	21AI34	Software Engineering	A
461	1DS21AI058	3	21AIL35	Application Development Using Python Lab	A+
462	1DS21AI058	3	21SCR36	Social Connect and Responsibility	O
463	1DS21AI058	3	21CIP37	Constitution of India and Professional Ethics	A+
464	1DS21AI058	3	21AIL381	Robotic Process Automation	A+
465	1DS21AI059	3	21MAT31A	Foundation in Mathematics	A
466	1DS21AI059	3	21AI32	Data Structures with Applications	B
467	1DS21AI059	3	21AI33	Database Management System	B+
468	1DS21AI059	3	21AI34	Software Engineering	B+
469	1DS21AI059	3	21AIL35	Application Development Using Python Lab	O
470	1DS21AI059	3	21SCR36	Social Connect and Responsibility	A+
471	1DS21AI059	3	21CIP37	Constitution of India and Professional Ethics	A
472	1DS21AI059	3	21AIL381	Robotic Process Automation	O
473	1DS21AI001	4	21MAT41A	Discrete Mathematical Structures	O
474	1DS21AI001	4	21AI42	Design and Analysis of Algorithms	A+
475	1DS21AI001	4	21AI43	Machine Learning Essentials	O
476	1DS21AI001	4	21AI44	Operating System	A
477	1DS21AI001	4	21BE45	Biology For Engineers	O
478	1DS21AI001	4	21AIL46	OOPs with Java Lab	O
479	1DS21AI001	4	21KBK47	Balake Kannada	O
480	1DS21AI001	4	21AIL481	Data Visualization Lab	O
481	1DS21AI001	4	21UH49	Universal Human Values	A+
482	1DS21AI001	4	21INT410	Inter/Intra Institutional Internship	O
483	1DS21AI002	4	21MAT41A	Discrete Mathematical Structures	O
484	1DS21AI002	4	21AI42	Design and Analysis of Algorithms	O
485	1DS21AI002	4	21AI43	Machine Learning Essentials	O
486	1DS21AI002	4	21AI44	Operating System	A+
487	1DS21AI002	4	21BE45	Biology For Engineers	O
488	1DS21AI002	4	21AIL46	OOPs with Java Lab	O
489	1DS21AI002	4	21KBK47	Balake Kannada	O
490	1DS21AI002	4	21AIL481	Data Visualization Lab	O
491	1DS21AI002	4	21UH49	Universal Human Values	O
492	1DS21AI002	4	21INT410	Inter/Intra Institutional Internship	O
493	1DS21AI003	4	21MAT41A	Discrete Mathematical Structures	A
494	1DS21AI003	4	21AI42	Design and Analysis of Algorithms	A
495	1DS21AI003	4	21AI43	Machine Learning Essentials	A+
496	1DS21AI003	4	21AI44	Operating System	B+
497	1DS21AI003	4	21BE45	Biology For Engineers	A+
498	1DS21AI003	4	21AIL46	OOPs with Java Lab	O
499	1DS21AI003	4	21KSK47	Samskrutika Kannada	A+
500	1DS21AI003	4	21AIL481	Data Visualization Lab	O
501	1DS21AI003	4	21UH49	Universal Human Values	A+
502	1DS21AI003	4	21INT410	Inter/Intra Institutional Internship	O
503	1DS21AI004	4	21MAT41A	Discrete Mathematical Structures	A+
504	1DS21AI004	4	21AI42	Design and Analysis of Algorithms	A
505	1DS21AI004	4	21AI43	Machine Learning Essentials	A+
506	1DS21AI004	4	21AI44	Operating System	B
507	1DS21AI004	4	21BE45	Biology For Engineers	A+
508	1DS21AI004	4	21AIL46	OOPs with Java Lab	A
509	1DS21AI004	4	21KBK47	Balake Kannada	O
510	1DS21AI004	4	21AIL481	Data Visualization Lab	A
511	1DS21AI004	4	21UH49	Universal Human Values	A
512	1DS21AI004	4	21INT410	Inter/Intra Institutional Internship	A+
513	1DS21AI005	4	21MAT41A	Discrete Mathematical Structures	O
514	1DS21AI005	4	21AI42	Design and Analysis of Algorithms	O
515	1DS21AI005	4	21AI43	Machine Learning Essentials	O
516	1DS21AI005	4	21AI44	Operating System	A+
517	1DS21AI005	4	21BE45	Biology For Engineers	O
518	1DS21AI005	4	21AIL46	OOPs with Java Lab	O
519	1DS21AI005	4	21KBK47	Balake Kannada	O
520	1DS21AI005	4	21AIL481	Data Visualization Lab	O
521	1DS21AI005	4	21UH49	Universal Human Values	O
522	1DS21AI005	4	21INT410	Inter/Intra Institutional Internship	O
523	1DS21AI006	4	21MAT41A	Discrete Mathematical Structures	O
524	1DS21AI006	4	21AI42	Design and Analysis of Algorithms	A
525	1DS21AI006	4	21AI43	Machine Learning Essentials	A+
1729	1DS21AI025	6	21AI63	MLOps	O
526	1DS21AI006	4	21AI44	Operating System	B+
527	1DS21AI006	4	21BE45	Biology For Engineers	O
528	1DS21AI006	4	21AIL46	OOPs with Java Lab	O
529	1DS21AI006	4	21KBK47	Balake Kannada	A+
530	1DS21AI006	4	21AIL481	Data Visualization Lab	O
531	1DS21AI006	4	21UH49	Universal Human Values	A+
532	1DS21AI006	4	21INT410	Inter/Intra Institutional Internship	A+
533	1DS21AI007	4	21MAT41A	Discrete Mathematical Structures	C
534	1DS21AI007	4	21AI42	Design and Analysis of Algorithms	F
535	1DS21AI007	4	21AI43	Machine Learning Essentials	C
536	1DS21AI007	4	21AI44	Operating System	PP
537	1DS21AI007	4	21BE45	Biology For Engineers	B+
538	1DS21AI007	4	21AIL46	OOPs with Java Lab	B+
539	1DS21AI007	4	21KBK47	Balake Kannada	A
540	1DS21AI007	4	21AIL481	Data Visualization Lab	A+
541	1DS21AI007	4	21UH49	Universal Human Values	PP
542	1DS21AI007	4	21INT410	Inter/Intra Institutional Internship	A+
543	1DS21AI008	4	21MAT41A	Discrete Mathematical Structures	O
544	1DS21AI008	4	21AI42	Design and Analysis of Algorithms	O
545	1DS21AI008	4	21AI43	Machine Learning Essentials	A+
546	1DS21AI008	4	21AI44	Operating System	A
547	1DS21AI008	4	21BE45	Biology For Engineers	A
548	1DS21AI008	4	21AIL46	OOPs with Java Lab	O
549	1DS21AI008	4	21KBK47	Balake Kannada	O
550	1DS21AI008	4	21AIL481	Data Visualization Lab	O
551	1DS21AI008	4	21UH49	Universal Human Values	A+
552	1DS21AI008	4	21INT410	Inter/Intra Institutional Internship	O
553	1DS21AI009	4	21MAT41A	Discrete Mathematical Structures	A+
554	1DS21AI009	4	21AI42	Design and Analysis of Algorithms	A+
555	1DS21AI009	4	21AI43	Machine Learning Essentials	O
556	1DS21AI009	4	21AI44	Operating System	A
557	1DS21AI009	4	21BE45	Biology For Engineers	A+
558	1DS21AI009	4	21AIL46	OOPs with Java Lab	A
559	1DS21AI009	4	21KBK47	Balake Kannada	O
560	1DS21AI009	4	21AIL481	Data Visualization Lab	O
561	1DS21AI009	4	21UH49	Universal Human Values	O
562	1DS21AI009	4	21INT410	Inter/Intra Institutional Internship	A+
563	1DS21AI010	4	21MAT41A	Discrete Mathematical Structures	O
564	1DS21AI010	4	21AI42	Design and Analysis of Algorithms	O
565	1DS21AI010	4	21AI43	Machine Learning Essentials	A+
566	1DS21AI010	4	21AI44	Operating System	A+
567	1DS21AI010	4	21BE45	Biology For Engineers	O
568	1DS21AI010	4	21AIL46	OOPs with Java Lab	O
569	1DS21AI010	4	21KSK47	Samskrutika Kannada	A+
570	1DS21AI010	4	21AIL481	Data Visualization Lab	O
571	1DS21AI010	4	21UH49	Universal Human Values	A
572	1DS21AI010	4	21INT410	Inter/Intra Institutional Internship	A+
573	1DS21AI011	4	21MAT41A	Discrete Mathematical Structures	A
574	1DS21AI011	4	21AI42	Design and Analysis of Algorithms	A
575	1DS21AI011	4	21AI43	Machine Learning Essentials	A+
576	1DS21AI011	4	21AI44	Operating System	B
577	1DS21AI011	4	21BE45	Biology For Engineers	A+
578	1DS21AI011	4	21AIL46	OOPs with Java Lab	O
579	1DS21AI011	4	21KSK47	Samskrutika Kannada	O
580	1DS21AI011	4	21AIL481	Data Visualization Lab	O
581	1DS21AI011	4	21UH49	Universal Human Values	A+
582	1DS21AI011	4	21INT410	Inter/Intra Institutional Internship	A+
583	1DS21AI012	4	21MAT41A	Discrete Mathematical Structures	O
584	1DS21AI012	4	21AI42	Design and Analysis of Algorithms	O
585	1DS21AI012	4	21AI43	Machine Learning Essentials	A+
586	1DS21AI012	4	21AI44	Operating System	O
587	1DS21AI012	4	21BE45	Biology For Engineers	O
588	1DS21AI012	4	21AIL46	OOPs with Java Lab	O
589	1DS21AI012	4	21KBK47	Balake Kannada	O
590	1DS21AI012	4	21AIL481	Data Visualization Lab	O
591	1DS21AI012	4	21UH49	Universal Human Values	O
592	1DS21AI012	4	21INT410	Inter/Intra Institutional Internship	O
593	1DS21AI013	4	21MAT41A	Discrete Mathematical Structures	B
594	1DS21AI013	4	21AI42	Design and Analysis of Algorithms	B+
595	1DS21AI013	4	21AI43	Machine Learning Essentials	C
596	1DS21AI013	4	21AI44	Operating System	PP
597	1DS21AI013	4	21BE45	Biology For Engineers	B
598	1DS21AI013	4	21AIL46	OOPs with Java Lab	O
599	1DS21AI013	4	21KBK47	Balake Kannada	A
600	1DS21AI013	4	21AIL481	Data Visualization Lab	A+
601	1DS21AI013	4	21UH49	Universal Human Values	C
602	1DS21AI013	4	21INT410	Inter/Intra Institutional Internship	A+
603	1DS21AI014	4	21MAT41A	Discrete Mathematical Structures	C
604	1DS21AI014	4	21AI42	Design and Analysis of Algorithms	F
605	1DS21AI014	4	21AI43	Machine Learning Essentials	B+
606	1DS21AI014	4	21AI44	Operating System	PP
607	1DS21AI014	4	21BE45	Biology For Engineers	A
608	1DS21AI014	4	21AIL46	OOPs with Java Lab	F
609	1DS21AI014	4	21KBK47	Balake Kannada	O
610	1DS21AI014	4	21AIL481	Data Visualization Lab	A+
611	1DS21AI014	4	21UH49	Universal Human Values	A+
612	1DS21AI014	4	21INT410	Inter/Intra Institutional Internship	A+
613	1DS21AI015	4	21MAT41A	Discrete Mathematical Structures	A
614	1DS21AI015	4	21AI42	Design and Analysis of Algorithms	B+
615	1DS21AI015	4	21AI43	Machine Learning Essentials	A+
616	1DS21AI015	4	21AI44	Operating System	PP
617	1DS21AI015	4	21BE45	Biology For Engineers	B+
618	1DS21AI015	4	21AIL46	OOPs with Java Lab	F
619	1DS21AI015	4	21KBK47	Balake Kannada	O
620	1DS21AI015	4	21AIL481	Data Visualization Lab	O
621	1DS21AI015	4	21UH49	Universal Human Values	A+
622	1DS21AI015	4	21INT410	Inter/Intra Institutional Internship	A+
623	1DS21AI016	4	21MAT41A	Discrete Mathematical Structures	O
624	1DS21AI016	4	21AI42	Design and Analysis of Algorithms	O
625	1DS21AI016	4	21AI43	Machine Learning Essentials	O
626	1DS21AI016	4	21AI44	Operating System	A+
627	1DS21AI016	4	21BE45	Biology For Engineers	O
628	1DS21AI016	4	21AIL46	OOPs with Java Lab	O
629	1DS21AI016	4	21KBK47	Balake Kannada	O
630	1DS21AI016	4	21AIL481	Data Visualization Lab	O
631	1DS21AI016	4	21UH49	Universal Human Values	O
632	1DS21AI016	4	21INT410	Inter/Intra Institutional Internship	O
633	1DS21AI017	4	21MAT41A	Discrete Mathematical Structures	O
634	1DS21AI017	4	21AI42	Design and Analysis of Algorithms	O
635	1DS21AI017	4	21AI43	Machine Learning Essentials	O
636	1DS21AI017	4	21AI44	Operating System	A
637	1DS21AI017	4	21BE45	Biology For Engineers	O
638	1DS21AI017	4	21AIL46	OOPs with Java Lab	O
639	1DS21AI017	4	21KBK47	Balake Kannada	O
640	1DS21AI017	4	21AIL481	Data Visualization Lab	O
641	1DS21AI017	4	21UH49	Universal Human Values	O
642	1DS21AI017	4	21INT410	Inter/Intra Institutional Internship	O
643	1DS21AI018	4	21MAT41A	Discrete Mathematical Structures	O
644	1DS21AI018	4	21AI42	Design and Analysis of Algorithms	O
645	1DS21AI018	4	21AI43	Machine Learning Essentials	A+
646	1DS21AI018	4	21AI44	Operating System	B+
647	1DS21AI018	4	21BE45	Biology For Engineers	O
648	1DS21AI018	4	21AIL46	OOPs with Java Lab	O
649	1DS21AI018	4	21KSK47	Samskrutika Kannada	O
650	1DS21AI018	4	21AIL481	Data Visualization Lab	O
651	1DS21AI018	4	21UH49	Universal Human Values	A+
652	1DS21AI018	4	21INT410	Inter/Intra Institutional Internship	O
653	1DS21AI019	4	21MAT41A	Discrete Mathematical Structures	B+
654	1DS21AI019	4	21AI42	Design and Analysis of Algorithms	B+
655	1DS21AI019	4	21AI43	Machine Learning Essentials	A+
656	1DS21AI019	4	21AI44	Operating System	B+
657	1DS21AI019	4	21BE45	Biology For Engineers	A+
658	1DS21AI019	4	21AIL46	OOPs with Java Lab	B+
659	1DS21AI019	4	21KBK47	Balake Kannada	O
660	1DS21AI019	4	21AIL481	Data Visualization Lab	A+
661	1DS21AI019	4	21UH49	Universal Human Values	A
662	1DS21AI019	4	21INT410	Inter/Intra Institutional Internship	A+
663	1DS21AI020	4	21MAT41A	Discrete Mathematical Structures	A
664	1DS21AI020	4	21AI42	Design and Analysis of Algorithms	B+
665	1DS21AI020	4	21AI43	Machine Learning Essentials	B+
666	1DS21AI020	4	21AI44	Operating System	C
667	1DS21AI020	4	21BE45	Biology For Engineers	A+
668	1DS21AI020	4	21AIL46	OOPs with Java Lab	A+
669	1DS21AI020	4	21KBK47	Balake Kannada	O
670	1DS21AI020	4	21AIL481	Data Visualization Lab	A+
671	1DS21AI020	4	21UH49	Universal Human Values	A+
672	1DS21AI020	4	21INT410	Inter/Intra Institutional Internship	A+
673	1DS21AI021	4	21MAT41A	Discrete Mathematical Structures	O
674	1DS21AI021	4	21AI42	Design and Analysis of Algorithms	O
675	1DS21AI021	4	21AI43	Machine Learning Essentials	A+
676	1DS21AI021	4	21AI44	Operating System	A+
677	1DS21AI021	4	21BE45	Biology For Engineers	O
678	1DS21AI021	4	21AIL46	OOPs with Java Lab	O
679	1DS21AI021	4	21KBK47	Balake Kannada	O
680	1DS21AI021	4	21AIL481	Data Visualization Lab	O
681	1DS21AI021	4	21UH49	Universal Human Values	A+
682	1DS21AI021	4	21INT410	Inter/Intra Institutional Internship	O
683	1DS21AI022	4	21MAT41A	Discrete Mathematical Structures	A+
684	1DS21AI022	4	21AI42	Design and Analysis of Algorithms	A
685	1DS21AI022	4	21AI43	Machine Learning Essentials	F
686	1DS21AI022	4	21AI44	Operating System	B+
687	1DS21AI022	4	21BE45	Biology For Engineers	A+
688	1DS21AI022	4	21AIL46	OOPs with Java Lab	O
689	1DS21AI022	4	21KSK47	Samskrutika Kannada	A
690	1DS21AI022	4	21AIL481	Data Visualization Lab	O
691	1DS21AI022	4	21UH49	Universal Human Values	A
692	1DS21AI022	4	21INT410	Inter/Intra Institutional Internship	A+
693	1DS21AI023	4	21MAT41A	Discrete Mathematical Structures	O
694	1DS21AI023	4	21AI42	Design and Analysis of Algorithms	O
695	1DS21AI023	4	21AI43	Machine Learning Essentials	O
696	1DS21AI023	4	21AI44	Operating System	O
697	1DS21AI023	4	21BE45	Biology For Engineers	O
698	1DS21AI023	4	21AIL46	OOPs with Java Lab	O
699	1DS21AI023	4	21KSK47	Samskrutika Kannada	O
700	1DS21AI023	4	21AIL481	Data Visualization Lab	O
701	1DS21AI023	4	21UH49	Universal Human Values	O
702	1DS21AI023	4	21INT410	Inter/Intra Institutional Internship	O
703	1DS21AI024	4	21MAT41A	Discrete Mathematical Structures	B+
704	1DS21AI024	4	21AI42	Design and Analysis of Algorithms	C
705	1DS21AI024	4	21AI43	Machine Learning Essentials	A+
706	1DS21AI024	4	21AI44	Operating System	C
707	1DS21AI024	4	21BE45	Biology For Engineers	A
708	1DS21AI024	4	21AIL46	OOPs with Java Lab	A
709	1DS21AI024	4	21KBK47	Balake Kannada	O
710	1DS21AI024	4	21AIL481	Data Visualization Lab	A
711	1DS21AI024	4	21UH49	Universal Human Values	A
712	1DS21AI024	4	21INT410	Inter/Intra Institutional Internship	O
713	1DS21AI025	4	21MAT41A	Discrete Mathematical Structures	O
714	1DS21AI025	4	21AI42	Design and Analysis of Algorithms	A+
715	1DS21AI025	4	21AI43	Machine Learning Essentials	A+
716	1DS21AI025	4	21AI44	Operating System	A
717	1DS21AI025	4	21BE45	Biology For Engineers	O
718	1DS21AI025	4	21AIL46	OOPs with Java Lab	O
719	1DS21AI025	4	21KBK47	Balake Kannada	O
720	1DS21AI025	4	21AIL481	Data Visualization Lab	A+
721	1DS21AI025	4	21UH49	Universal Human Values	A+
722	1DS21AI025	4	21INT410	Inter/Intra Institutional Internship	O
723	1DS21AI026	4	21MAT41A	Discrete Mathematical Structures	B+
724	1DS21AI026	4	21AI42	Design and Analysis of Algorithms	B
725	1DS21AI026	4	21AI43	Machine Learning Essentials	B
726	1DS21AI026	4	21AI44	Operating System	PP
727	1DS21AI026	4	21BE45	Biology For Engineers	A
728	1DS21AI026	4	21AIL46	OOPs with Java Lab	A
729	1DS21AI026	4	21KBK47	Balake Kannada	O
730	1DS21AI026	4	21AIL481	Data Visualization Lab	O
731	1DS21AI026	4	21UH49	Universal Human Values	A+
732	1DS21AI026	4	21INT410	Inter/Intra Institutional Internship	A+
733	1DS21AI027	4	21MAT41A	Discrete Mathematical Structures	O
734	1DS21AI027	4	21AI42	Design and Analysis of Algorithms	O
735	1DS21AI027	4	21AI43	Machine Learning Essentials	O
736	1DS21AI027	4	21AI44	Operating System	A
737	1DS21AI027	4	21BE45	Biology For Engineers	O
738	1DS21AI027	4	21AIL46	OOPs with Java Lab	O
739	1DS21AI027	4	21KBK47	Balake Kannada	O
740	1DS21AI027	4	21AIL481	Data Visualization Lab	O
741	1DS21AI027	4	21UH49	Universal Human Values	A+
742	1DS21AI027	4	21INT410	Inter/Intra Institutional Internship	A+
743	1DS21AI028	4	21MAT41A	Discrete Mathematical Structures	O
744	1DS21AI028	4	21AI42	Design and Analysis of Algorithms	O
745	1DS21AI028	4	21AI43	Machine Learning Essentials	O
746	1DS21AI028	4	21AI44	Operating System	A+
747	1DS21AI028	4	21BE45	Biology For Engineers	O
748	1DS21AI028	4	21AIL46	OOPs with Java Lab	O
749	1DS21AI028	4	21KSK47	Samskrutika Kannada	O
750	1DS21AI028	4	21AIL481	Data Visualization Lab	O
751	1DS21AI028	4	21UH49	Universal Human Values	O
752	1DS21AI028	4	21INT410	Inter/Intra Institutional Internship	O
753	1DS21AI029	4	21MAT41A	Discrete Mathematical Structures	A
754	1DS21AI029	4	21AI42	Design and Analysis of Algorithms	B+
755	1DS21AI029	4	21AI43	Machine Learning Essentials	A
756	1DS21AI029	4	21AI44	Operating System	C
757	1DS21AI029	4	21BE45	Biology For Engineers	A+
758	1DS21AI029	4	21AIL46	OOPs with Java Lab	A
759	1DS21AI029	4	21KBK47	Balake Kannada	A+
760	1DS21AI029	4	21AIL481	Data Visualization Lab	B+
761	1DS21AI029	4	21UH49	Universal Human Values	A
762	1DS21AI029	4	21INT410	Inter/Intra Institutional Internship	A+
763	1DS21AI030	4	21MAT41A	Discrete Mathematical Structures	A+
764	1DS21AI030	4	21AI42	Design and Analysis of Algorithms	A+
765	1DS21AI030	4	21AI43	Machine Learning Essentials	A+
766	1DS21AI030	4	21AI44	Operating System	A
767	1DS21AI030	4	21BE45	Biology For Engineers	O
768	1DS21AI030	4	21AIL46	OOPs with Java Lab	O
769	1DS21AI030	4	21KBK47	Balake Kannada	A+
770	1DS21AI030	4	21AIL481	Data Visualization Lab	O
771	1DS21AI030	4	21UH49	Universal Human Values	A+
772	1DS21AI030	4	21INT410	Inter/Intra Institutional Internship	O
773	1DS21AI031	4	21MAT41A	Discrete Mathematical Structures	A+
774	1DS21AI031	4	21AI42	Design and Analysis of Algorithms	A+
775	1DS21AI031	4	21AI43	Machine Learning Essentials	A+
776	1DS21AI031	4	21AI44	Operating System	B+
777	1DS21AI031	4	21BE45	Biology For Engineers	A+
778	1DS21AI031	4	21AIL46	OOPs with Java Lab	A
779	1DS21AI031	4	21KSK47	Samskrutika Kannada	O
780	1DS21AI031	4	21AIL481	Data Visualization Lab	O
781	1DS21AI031	4	21UH49	Universal Human Values	A+
782	1DS21AI031	4	21INT410	Inter/Intra Institutional Internship	O
783	1DS21AI032	4	21MAT41A	Discrete Mathematical Structures	A+
784	1DS21AI032	4	21AI42	Design and Analysis of Algorithms	A
785	1DS21AI032	4	21AI43	Machine Learning Essentials	A+
786	1DS21AI032	4	21AI44	Operating System	B+
787	1DS21AI032	4	21BE45	Biology For Engineers	A+
788	1DS21AI032	4	21AIL46	OOPs with Java Lab	O
789	1DS21AI032	4	21KBK47	Balake Kannada	A
790	1DS21AI032	4	21AIL481	Data Visualization Lab	O
791	1DS21AI032	4	21UH49	Universal Human Values	A
792	1DS21AI032	4	21INT410	Inter/Intra Institutional Internship	A+
793	1DS21AI033	4	21MAT41A	Discrete Mathematical Structures	B
794	1DS21AI033	4	21AI42	Design and Analysis of Algorithms	B
795	1DS21AI033	4	21AI43	Machine Learning Essentials	A
796	1DS21AI033	4	21AI44	Operating System	B
797	1DS21AI033	4	21BE45	Biology For Engineers	A
798	1DS21AI033	4	21AIL46	OOPs with Java Lab	A+
799	1DS21AI033	4	21KBK47	Balake Kannada	O
800	1DS21AI033	4	21AIL481	Data Visualization Lab	A
801	1DS21AI033	4	21UH49	Universal Human Values	A
802	1DS21AI033	4	21INT410	Inter/Intra Institutional Internship	A+
803	1DS21AI034	4	21MAT41A	Discrete Mathematical Structures	O
804	1DS21AI034	4	21AI42	Design and Analysis of Algorithms	O
805	1DS21AI034	4	21AI43	Machine Learning Essentials	A+
806	1DS21AI034	4	21AI44	Operating System	A+
807	1DS21AI034	4	21BE45	Biology For Engineers	O
808	1DS21AI034	4	21AIL46	OOPs with Java Lab	O
809	1DS21AI034	4	21KBK47	Balake Kannada	O
810	1DS21AI034	4	21AIL481	Data Visualization Lab	O
811	1DS21AI034	4	21UH49	Universal Human Values	A+
812	1DS21AI034	4	21INT410	Inter/Intra Institutional Internship	O
813	1DS21AI035	4	21MAT41A	Discrete Mathematical Structures	A
814	1DS21AI035	4	21AI42	Design and Analysis of Algorithms	A
815	1DS21AI035	4	21AI43	Machine Learning Essentials	A
816	1DS21AI035	4	21AI44	Operating System	B+
817	1DS21AI035	4	21BE45	Biology For Engineers	A+
818	1DS21AI035	4	21AIL46	OOPs with Java Lab	O
819	1DS21AI035	4	21KBK47	Balake Kannada	O
820	1DS21AI035	4	21AIL481	Data Visualization Lab	O
821	1DS21AI035	4	21UH49	Universal Human Values	A+
822	1DS21AI035	4	21INT410	Inter/Intra Institutional Internship	O
823	1DS21AI036	4	21MAT41A	Discrete Mathematical Structures	O
824	1DS21AI036	4	21AI42	Design and Analysis of Algorithms	O
825	1DS21AI036	4	21AI43	Machine Learning Essentials	A+
826	1DS21AI036	4	21AI44	Operating System	B+
827	1DS21AI036	4	21BE45	Biology For Engineers	O
828	1DS21AI036	4	21AIL46	OOPs with Java Lab	O
829	1DS21AI036	4	21KSK47	Samskrutika Kannada	O
830	1DS21AI036	4	21AIL481	Data Visualization Lab	O
831	1DS21AI036	4	21UH49	Universal Human Values	A+
832	1DS21AI036	4	21INT410	Inter/Intra Institutional Internship	O
833	1DS21AI037	4	21MAT41A	Discrete Mathematical Structures	O
834	1DS21AI037	4	21AI42	Design and Analysis of Algorithms	A+
835	1DS21AI037	4	21AI43	Machine Learning Essentials	A+
836	1DS21AI037	4	21AI44	Operating System	A
837	1DS21AI037	4	21BE45	Biology For Engineers	A+
838	1DS21AI037	4	21AIL46	OOPs with Java Lab	O
839	1DS21AI037	4	21KSK47	Samskrutika Kannada	O
840	1DS21AI037	4	21AIL481	Data Visualization Lab	O
841	1DS21AI037	4	21UH49	Universal Human Values	O
842	1DS21AI037	4	21INT410	Inter/Intra Institutional Internship	O
843	1DS21AI038	4	21MAT41A	Discrete Mathematical Structures	A+
844	1DS21AI038	4	21AI42	Design and Analysis of Algorithms	B+
845	1DS21AI038	4	21AI43	Machine Learning Essentials	A+
846	1DS21AI038	4	21AI44	Operating System	A
847	1DS21AI038	4	21BE45	Biology For Engineers	O
848	1DS21AI038	4	21AIL46	OOPs with Java Lab	O
849	1DS21AI038	4	21KBK47	Balake Kannada	O
850	1DS21AI038	4	21AIL481	Data Visualization Lab	O
851	1DS21AI038	4	21UH49	Universal Human Values	A+
852	1DS21AI038	4	21INT410	Inter/Intra Institutional Internship	O
853	1DS21AI039	4	21MAT41A	Discrete Mathematical Structures	A+
854	1DS21AI039	4	21AI42	Design and Analysis of Algorithms	A
855	1DS21AI039	4	21AI43	Machine Learning Essentials	A+
856	1DS21AI039	4	21AI44	Operating System	F
857	1DS21AI039	4	21BE45	Biology For Engineers	A+
858	1DS21AI039	4	21AIL46	OOPs with Java Lab	O
859	1DS21AI039	4	21KBK47	Balake Kannada	A+
860	1DS21AI039	4	21AIL481	Data Visualization Lab	O
861	1DS21AI039	4	21UH49	Universal Human Values	A+
862	1DS21AI039	4	21INT410	Inter/Intra Institutional Internship	O
863	1DS21AI040	4	21MAT41A	Discrete Mathematical Structures	O
864	1DS21AI040	4	21AI42	Design and Analysis of Algorithms	A+
865	1DS21AI040	4	21AI43	Machine Learning Essentials	A+
866	1DS21AI040	4	21AI44	Operating System	C
867	1DS21AI040	4	21BE45	Biology For Engineers	A+
868	1DS21AI040	4	21AIL46	OOPs with Java Lab	O
869	1DS21AI040	4	21KSK47	Samskrutika Kannada	A
870	1DS21AI040	4	21AIL481	Data Visualization Lab	O
871	1DS21AI040	4	21UH49	Universal Human Values	A+
872	1DS21AI040	4	21INT410	Inter/Intra Institutional Internship	O
873	1DS21AI041	4	21MAT41A	Discrete Mathematical Structures	A+
874	1DS21AI041	4	21AI42	Design and Analysis of Algorithms	O
875	1DS21AI041	4	21AI43	Machine Learning Essentials	A+
876	1DS21AI041	4	21AI44	Operating System	B+
877	1DS21AI041	4	21BE45	Biology For Engineers	A+
878	1DS21AI041	4	21AIL46	OOPs with Java Lab	O
879	1DS21AI041	4	21KBK47	Balake Kannada	O
880	1DS21AI041	4	21AIL481	Data Visualization Lab	A+
881	1DS21AI041	4	21UH49	Universal Human Values	O
882	1DS21AI041	4	21INT410	Inter/Intra Institutional Internship	A+
883	1DS21AI042	4	21MAT41A	Discrete Mathematical Structures	O
884	1DS21AI042	4	21AI42	Design and Analysis of Algorithms	A+
885	1DS21AI042	4	21AI43	Machine Learning Essentials	A+
886	1DS21AI042	4	21AI44	Operating System	A+
887	1DS21AI042	4	21BE45	Biology For Engineers	O
888	1DS21AI042	4	21AIL46	OOPs with Java Lab	O
889	1DS21AI042	4	21KSK47	Samskrutika Kannada	O
890	1DS21AI042	4	21AIL481	Data Visualization Lab	O
891	1DS21AI042	4	21UH49	Universal Human Values	O
892	1DS21AI042	4	21INT410	Inter/Intra Institutional Internship	O
893	1DS21AI043	4	21MAT41A	Discrete Mathematical Structures	A+
894	1DS21AI043	4	21AI42	Design and Analysis of Algorithms	O
895	1DS21AI043	4	21AI43	Machine Learning Essentials	A+
896	1DS21AI043	4	21AI44	Operating System	A+
897	1DS21AI043	4	21BE45	Biology For Engineers	A+
898	1DS21AI043	4	21AIL46	OOPs with Java Lab	O
899	1DS21AI043	4	21KBK47	Balake Kannada	O
900	1DS21AI043	4	21AIL481	Data Visualization Lab	A+
901	1DS21AI043	4	21UH49	Universal Human Values	A+
902	1DS21AI043	4	21INT410	Inter/Intra Institutional Internship	O
903	1DS21AI044	4	21MAT41A	Discrete Mathematical Structures	A
904	1DS21AI044	4	21AI42	Design and Analysis of Algorithms	B+
905	1DS21AI044	4	21AI43	Machine Learning Essentials	A+
906	1DS21AI044	4	21AI44	Operating System	B+
907	1DS21AI044	4	21BE45	Biology For Engineers	A+
908	1DS21AI044	4	21AIL46	OOPs with Java Lab	O
909	1DS21AI044	4	21KBK47	Balake Kannada	O
910	1DS21AI044	4	21AIL481	Data Visualization Lab	O
911	1DS21AI044	4	21UH49	Universal Human Values	A+
912	1DS21AI044	4	21INT410	Inter/Intra Institutional Internship	A+
913	1DS21AI045	4	21MAT41A	Discrete Mathematical Structures	A+
914	1DS21AI045	4	21AI42	Design and Analysis of Algorithms	A
915	1DS21AI045	4	21AI43	Machine Learning Essentials	A+
916	1DS21AI045	4	21AI44	Operating System	A
917	1DS21AI045	4	21BE45	Biology For Engineers	O
918	1DS21AI045	4	21AIL46	OOPs with Java Lab	O
919	1DS21AI045	4	21KBK47	Balake Kannada	A+
920	1DS21AI045	4	21AIL481	Data Visualization Lab	A+
921	1DS21AI045	4	21UH49	Universal Human Values	A
922	1DS21AI045	4	21INT410	Inter/Intra Institutional Internship	O
923	1DS21AI046	4	21MAT41A	Discrete Mathematical Structures	O
924	1DS21AI046	4	21AI42	Design and Analysis of Algorithms	A
925	1DS21AI046	4	21AI43	Machine Learning Essentials	A+
926	1DS21AI046	4	21AI44	Operating System	A
927	1DS21AI046	4	21BE45	Biology For Engineers	A+
928	1DS21AI046	4	21AIL46	OOPs with Java Lab	O
929	1DS21AI046	4	21KSK47	Samskrutika Kannada	O
930	1DS21AI046	4	21AIL481	Data Visualization Lab	O
931	1DS21AI046	4	21UH49	Universal Human Values	O
932	1DS21AI046	4	21INT410	Inter/Intra Institutional Internship	A+
933	1DS21AI047	4	21MAT41A	Discrete Mathematical Structures	O
934	1DS21AI047	4	21AI42	Design and Analysis of Algorithms	A+
935	1DS21AI047	4	21AI43	Machine Learning Essentials	A+
936	1DS21AI047	4	21AI44	Operating System	A
937	1DS21AI047	4	21BE45	Biology For Engineers	O
938	1DS21AI047	4	21AIL46	OOPs with Java Lab	O
939	1DS21AI047	4	21KBK47	Balake Kannada	O
940	1DS21AI047	4	21AIL481	Data Visualization Lab	O
941	1DS21AI047	4	21UH49	Universal Human Values	A+
942	1DS21AI047	4	21INT410	Inter/Intra Institutional Internship	A+
943	1DS21AI048	4	21MAT41A	Discrete Mathematical Structures	A+
944	1DS21AI048	4	21AI42	Design and Analysis of Algorithms	A+
945	1DS21AI048	4	21AI43	Machine Learning Essentials	A+
946	1DS21AI048	4	21AI44	Operating System	A
947	1DS21AI048	4	21BE45	Biology For Engineers	O
948	1DS21AI048	4	21AIL46	OOPs with Java Lab	O
949	1DS21AI048	4	21KBK47	Balake Kannada	O
950	1DS21AI048	4	21AIL481	Data Visualization Lab	O
951	1DS21AI048	4	21UH49	Universal Human Values	A+
952	1DS21AI048	4	21INT410	Inter/Intra Institutional Internship	O
953	1DS21AI049	4	21MAT41A	Discrete Mathematical Structures	O
954	1DS21AI049	4	21AI42	Design and Analysis of Algorithms	A+
955	1DS21AI049	4	21AI43	Machine Learning Essentials	A+
956	1DS21AI049	4	21AI44	Operating System	A
957	1DS21AI049	4	21BE45	Biology For Engineers	A+
958	1DS21AI049	4	21AIL46	OOPs with Java Lab	A+
959	1DS21AI049	4	21KBK47	Balake Kannada	A+
960	1DS21AI049	4	21AIL481	Data Visualization Lab	O
961	1DS21AI049	4	21UH49	Universal Human Values	A+
962	1DS21AI049	4	21INT410	Inter/Intra Institutional Internship	O
963	1DS21AI050	4	21MAT41A	Discrete Mathematical Structures	A+
964	1DS21AI050	4	21AI42	Design and Analysis of Algorithms	A+
965	1DS21AI050	4	21AI43	Machine Learning Essentials	A+
966	1DS21AI050	4	21AI44	Operating System	B+
967	1DS21AI050	4	21BE45	Biology For Engineers	O
968	1DS21AI050	4	21AIL46	OOPs with Java Lab	O
969	1DS21AI050	4	21KSK47	Samskrutika Kannada	A
970	1DS21AI050	4	21AIL481	Data Visualization Lab	A+
971	1DS21AI050	4	21UH49	Universal Human Values	A+
972	1DS21AI050	4	21INT410	Inter/Intra Institutional Internship	A+
973	1DS21AI051	4	21MAT41A	Discrete Mathematical Structures	B+
974	1DS21AI051	4	21AI42	Design and Analysis of Algorithms	B
975	1DS21AI051	4	21AI43	Machine Learning Essentials	A
976	1DS21AI051	4	21AI44	Operating System	B
977	1DS21AI051	4	21BE45	Biology For Engineers	A+
978	1DS21AI051	4	21AIL46	OOPs with Java Lab	A+
979	1DS21AI051	4	21KSK47	Samskrutika Kannada	A
980	1DS21AI051	4	21AIL481	Data Visualization Lab	A+
981	1DS21AI051	4	21UH49	Universal Human Values	A+
982	1DS21AI051	4	21INT410	Inter/Intra Institutional Internship	A+
983	1DS21AI052	4	21MAT41A	Discrete Mathematical Structures	O
984	1DS21AI052	4	21AI42	Design and Analysis of Algorithms	A+
985	1DS21AI052	4	21AI43	Machine Learning Essentials	O
986	1DS21AI052	4	21AI44	Operating System	A
987	1DS21AI052	4	21BE45	Biology For Engineers	O
988	1DS21AI052	4	21AIL46	OOPs with Java Lab	O
989	1DS21AI052	4	21KBK47	Balake Kannada	O
990	1DS21AI052	4	21AIL481	Data Visualization Lab	O
991	1DS21AI052	4	21UH49	Universal Human Values	O
992	1DS21AI052	4	21INT410	Inter/Intra Institutional Internship	O
993	1DS21AI053	4	21MAT41A	Discrete Mathematical Structures	A+
994	1DS21AI053	4	21AI42	Design and Analysis of Algorithms	A
995	1DS21AI053	4	21AI43	Machine Learning Essentials	A+
996	1DS21AI053	4	21AI44	Operating System	B+
997	1DS21AI053	4	21BE45	Biology For Engineers	O
998	1DS21AI053	4	21AIL46	OOPs with Java Lab	O
999	1DS21AI053	4	21KBK47	Balake Kannada	O
1000	1DS21AI053	4	21AIL481	Data Visualization Lab	O
1001	1DS21AI053	4	21UH49	Universal Human Values	A+
1002	1DS21AI053	4	21INT410	Inter/Intra Institutional Internship	O
1003	1DS21AI054	4	21MAT41A	Discrete Mathematical Structures	O
1004	1DS21AI054	4	21AI42	Design and Analysis of Algorithms	O
1005	1DS21AI054	4	21AI43	Machine Learning Essentials	O
1006	1DS21AI054	4	21AI44	Operating System	O
1007	1DS21AI054	4	21BE45	Biology For Engineers	O
1008	1DS21AI054	4	21AIL46	OOPs with Java Lab	O
1009	1DS21AI054	4	21KBK47	Balake Kannada	O
1010	1DS21AI054	4	21AIL481	Data Visualization Lab	O
1011	1DS21AI054	4	21UH49	Universal Human Values	A+
1012	1DS21AI054	4	21INT410	Inter/Intra Institutional Internship	A+
1013	1DS21AI055	4	21MAT41A	Discrete Mathematical Structures	O
1014	1DS21AI055	4	21AI42	Design and Analysis of Algorithms	O
1015	1DS21AI055	4	21AI43	Machine Learning Essentials	O
1016	1DS21AI055	4	21AI44	Operating System	O
1017	1DS21AI055	4	21BE45	Biology For Engineers	O
1018	1DS21AI055	4	21AIL46	OOPs with Java Lab	O
1019	1DS21AI055	4	21KSK47	Samskrutika Kannada	O
1020	1DS21AI055	4	21AIL481	Data Visualization Lab	O
1021	1DS21AI055	4	21UH49	Universal Human Values	O
1022	1DS21AI055	4	21INT410	Inter/Intra Institutional Internship	O
1023	1DS21AI056	4	21MAT41A	Discrete Mathematical Structures	B+
1024	1DS21AI056	4	21AI42	Design and Analysis of Algorithms	B+
1025	1DS21AI056	4	21AI43	Machine Learning Essentials	B+
1026	1DS21AI056	4	21AI44	Operating System	C
1027	1DS21AI056	4	21BE45	Biology For Engineers	A
1028	1DS21AI056	4	21AIL46	OOPs with Java Lab	O
1029	1DS21AI056	4	21KBK47	Balake Kannada	O
1030	1DS21AI056	4	21AIL481	Data Visualization Lab	A+
1031	1DS21AI056	4	21UH49	Universal Human Values	A+
1032	1DS21AI056	4	21INT410	Inter/Intra Institutional Internship	A+
1033	1DS21AI057	4	21MAT41A	Discrete Mathematical Structures	O
1034	1DS21AI057	4	21AI42	Design and Analysis of Algorithms	O
1035	1DS21AI057	4	21AI43	Machine Learning Essentials	A+
1036	1DS21AI057	4	21AI44	Operating System	A
1037	1DS21AI057	4	21BE45	Biology For Engineers	O
1038	1DS21AI057	4	21AIL46	OOPs with Java Lab	O
1039	1DS21AI057	4	21KBK47	Balake Kannada	A+
1040	1DS21AI057	4	21AIL481	Data Visualization Lab	O
1041	1DS21AI057	4	21UH49	Universal Human Values	A+
1042	1DS21AI057	4	21INT410	Inter/Intra Institutional Internship	O
1043	1DS21AI058	4	21MAT41A	Discrete Mathematical Structures	O
1044	1DS21AI058	4	21AI42	Design and Analysis of Algorithms	A+
1045	1DS21AI058	4	21AI43	Machine Learning Essentials	O
1046	1DS21AI058	4	21AI44	Operating System	A
1047	1DS21AI058	4	21BE45	Biology For Engineers	O
1048	1DS21AI058	4	21AIL46	OOPs with Java Lab	O
1049	1DS21AI058	4	21KBK47	Balake Kannada	O
1050	1DS21AI058	4	21AIL481	Data Visualization Lab	O
1051	1DS21AI058	4	21UH49	Universal Human Values	O
1052	1DS21AI058	4	21INT410	Inter/Intra Institutional Internship	A+
1053	1DS21AI059	4	21MAT41A	Discrete Mathematical Structures	A
1054	1DS21AI059	4	21AI42	Design and Analysis of Algorithms	A
1055	1DS21AI059	4	21AI43	Machine Learning Essentials	A+
1056	1DS21AI059	4	21AI44	Operating System	B+
1057	1DS21AI059	4	21BE45	Biology For Engineers	O
1058	1DS21AI059	4	21AIL46	OOPs with Java Lab	O
1059	1DS21AI059	4	21KBK47	Balake Kannada	A+
1060	1DS21AI059	4	21AIL481	Data Visualization Lab	O
1061	1DS21AI059	4	21UH49	Universal Human Values	A+
1062	1DS21AI059	4	21INT410	Inter/Intra Institutional Internship	O
1063	1DS21AI001	5	21AI51	Artificial Intelligence	O
1064	1DS21AI001	5	21AI52	Advanced Machine Learning	A+
1065	1DS21AI001	5	21AI53	Computer Networks and Communication	A+
1066	1DS21AI001	5	21AI54	Introduction to Robotics	O
1067	1DS21AI001	5	21AIL55	Computer Networks Lab	O
1068	1DS21AI001	5	21RM56	Research Methodology and Intellectual Property Rights	A
1069	1DS21AI001	5	21ES57	Environmental Studies	A+
1070	1DS21AI001	5	21AIL584	Full Stack Development Lab	A+
1071	1DS21AI002	5	21AI51	Artificial Intelligence	O
1072	1DS21AI002	5	21AI52	Advanced Machine Learning	O
1073	1DS21AI002	5	21AI53	Computer Networks and Communication	A+
1074	1DS21AI002	5	21AI54	Introduction to Robotics	O
1075	1DS21AI002	5	21AIL55	Computer Networks Lab	O
1076	1DS21AI002	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1077	1DS21AI002	5	21ES57	Environmental Studies	A+
1078	1DS21AI002	5	21AIL584	Full Stack Development Lab	O
1079	1DS21AI003	5	21AI51	Artificial Intelligence	A
1080	1DS21AI003	5	21AI52	Advanced Machine Learning	A
1081	1DS21AI003	5	21AI53	Computer Networks and Communication	B+
1082	1DS21AI003	5	21AI54	Introduction to Robotics	B+
1083	1DS21AI003	5	21AIL55	Computer Networks Lab	A
1084	1DS21AI003	5	21RM56	Research Methodology and Intellectual Property Rights	A
1085	1DS21AI003	5	21ES57	Environmental Studies	A+
1086	1DS21AI003	5	21AIL584	Full Stack Development Lab	O
1087	1DS21AI004	5	21AI51	Artificial Intelligence	A
1088	1DS21AI004	5	21AI52	Advanced Machine Learning	NE
1089	1DS21AI004	5	21AI53	Computer Networks and Communication	B+
1090	1DS21AI004	5	21AI54	Introduction to Robotics	B
1091	1DS21AI004	5	21AIL55	Computer Networks Lab	NE
1092	1DS21AI004	5	21RM56	Research Methodology and Intellectual Property Rights	P
1093	1DS21AI004	5	21ES57	Environmental Studies	A
1094	1DS21AI004	5	21AIL584	Full Stack Development Lab	A
1095	1DS21AI005	5	21AI51	Artificial Intelligence	O
1096	1DS21AI005	5	21AI52	Advanced Machine Learning	O
1097	1DS21AI005	5	21AI53	Computer Networks and Communication	A
1098	1DS21AI005	5	21AI54	Introduction to Robotics	O
1099	1DS21AI005	5	21AIL55	Computer Networks Lab	O
1100	1DS21AI005	5	21RM56	Research Methodology and Intellectual Property Rights	A
1101	1DS21AI005	5	21ES57	Environmental Studies	A+
1102	1DS21AI005	5	21AIL584	Full Stack Development Lab	O
1103	1DS21AI006	5	21AI51	Artificial Intelligence	A+
1104	1DS21AI006	5	21AI52	Advanced Machine Learning	A+
1105	1DS21AI006	5	21AI53	Computer Networks and Communication	B+
1106	1DS21AI006	5	21AI54	Introduction to Robotics	A+
1107	1DS21AI006	5	21AIL55	Computer Networks Lab	A+
1108	1DS21AI006	5	21RM56	Research Methodology and Intellectual Property Rights	A
1109	1DS21AI006	5	21ES57	Environmental Studies	O
1110	1DS21AI006	5	21AIL584	Full Stack Development Lab	O
1111	1DS21AI007	5	21AI51	Artificial Intelligence	B+
1112	1DS21AI007	5	21AI52	Advanced Machine Learning	C
1113	1DS21AI007	5	21AI53	Computer Networks and Communication	B
1114	1DS21AI007	5	21AI54	Introduction to Robotics	B+
1115	1DS21AI007	5	21AIL55	Computer Networks Lab	B+
1116	1DS21AI007	5	21RM56	Research Methodology and Intellectual Property Rights	P
1117	1DS21AI007	5	21ES57	Environmental Studies	C
1118	1DS21AI007	5	21AIL584	Full Stack Development Lab	P
1119	1DS21AI008	5	21AI51	Artificial Intelligence	A+
1120	1DS21AI008	5	21AI52	Advanced Machine Learning	A+
1121	1DS21AI008	5	21AI53	Computer Networks and Communication	A+
1122	1DS21AI008	5	21AI54	Introduction to Robotics	O
1123	1DS21AI008	5	21AIL55	Computer Networks Lab	A+
1124	1DS21AI008	5	21RM56	Research Methodology and Intellectual Property Rights	A
1125	1DS21AI008	5	21ES57	Environmental Studies	O
1126	1DS21AI008	5	21AIL584	Full Stack Development Lab	O
1127	1DS21AI009	5	21AI51	Artificial Intelligence	O
1128	1DS21AI009	5	21AI52	Advanced Machine Learning	O
1129	1DS21AI009	5	21AI53	Computer Networks and Communication	A+
1130	1DS21AI009	5	21AI54	Introduction to Robotics	O
1131	1DS21AI009	5	21AIL55	Computer Networks Lab	O
1132	1DS21AI009	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1133	1DS21AI009	5	21ES57	Environmental Studies	O
1134	1DS21AI009	5	21AIL584	Full Stack Development Lab	A+
1135	1DS21AI010	5	21AI51	Artificial Intelligence	O
1136	1DS21AI010	5	21AI52	Advanced Machine Learning	O
1137	1DS21AI010	5	21AI53	Computer Networks and Communication	A+
1138	1DS21AI010	5	21AI54	Introduction to Robotics	O
1139	1DS21AI010	5	21AIL55	Computer Networks Lab	O
1140	1DS21AI010	5	21RM56	Research Methodology and Intellectual Property Rights	A
1141	1DS21AI010	5	21ES57	Environmental Studies	O
1142	1DS21AI010	5	21AIL584	Full Stack Development Lab	O
1143	1DS21AI011	5	21AI51	Artificial Intelligence	A
1144	1DS21AI011	5	21AI52	Advanced Machine Learning	A+
1145	1DS21AI011	5	21AI53	Computer Networks and Communication	B+
1146	1DS21AI011	5	21AI54	Introduction to Robotics	A+
1147	1DS21AI011	5	21AIL55	Computer Networks Lab	O
1148	1DS21AI011	5	21RM56	Research Methodology and Intellectual Property Rights	A
1149	1DS21AI011	5	21ES57	Environmental Studies	A+
1150	1DS21AI011	5	21AIL584	Full Stack Development Lab	O
1151	1DS21AI012	5	21AI51	Artificial Intelligence	O
1152	1DS21AI012	5	21AI52	Advanced Machine Learning	O
1153	1DS21AI012	5	21AI53	Computer Networks and Communication	A+
1154	1DS21AI012	5	21AI54	Introduction to Robotics	O
1155	1DS21AI012	5	21AIL55	Computer Networks Lab	O
1156	1DS21AI012	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1157	1DS21AI012	5	21ES57	Environmental Studies	A+
1158	1DS21AI012	5	21AIL584	Full Stack Development Lab	O
1159	1DS21AI013	5	21AI51	Artificial Intelligence	B+
1160	1DS21AI013	5	21AI52	Advanced Machine Learning	A
1161	1DS21AI013	5	21AI53	Computer Networks and Communication	C
1162	1DS21AI013	5	21AI54	Introduction to Robotics	A
1163	1DS21AI013	5	21AIL55	Computer Networks Lab	A+
1164	1DS21AI013	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1165	1DS21AI013	5	21ES57	Environmental Studies	B+
1166	1DS21AI013	5	21AIL584	Full Stack Development Lab	O
1167	1DS21AI014	5	21AI51	Artificial Intelligence	B+
1168	1DS21AI014	5	21AI52	Advanced Machine Learning	B+
1169	1DS21AI014	5	21AI53	Computer Networks and Communication	C
1170	1DS21AI014	5	21AI54	Introduction to Robotics	B+
1171	1DS21AI014	5	21AIL55	Computer Networks Lab	A
1172	1DS21AI014	5	21RM56	Research Methodology and Intellectual Property Rights	A
1173	1DS21AI014	5	21ES57	Environmental Studies	A+
1174	1DS21AI014	5	21AIL584	Full Stack Development Lab	B+
1175	1DS21AI015	5	21AI51	Artificial Intelligence	B+
1176	1DS21AI015	5	21AI52	Advanced Machine Learning	A
1177	1DS21AI015	5	21AI53	Computer Networks and Communication	B+
1178	1DS21AI015	5	21AI54	Introduction to Robotics	A
1179	1DS21AI015	5	21AIL55	Computer Networks Lab	O
1180	1DS21AI015	5	21RM56	Research Methodology and Intellectual Property Rights	A
1181	1DS21AI015	5	21ES57	Environmental Studies	A
1182	1DS21AI015	5	21AIL584	Full Stack Development Lab	A+
1183	1DS21AI016	5	21AI51	Artificial Intelligence	O
1184	1DS21AI016	5	21AI52	Advanced Machine Learning	O
1185	1DS21AI016	5	21AI53	Computer Networks and Communication	A+
1186	1DS21AI016	5	21AI54	Introduction to Robotics	O
1187	1DS21AI016	5	21AIL55	Computer Networks Lab	O
1188	1DS21AI016	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1189	1DS21AI016	5	21ES57	Environmental Studies	A+
1190	1DS21AI016	5	21AIL584	Full Stack Development Lab	O
1191	1DS21AI017	5	21AI51	Artificial Intelligence	O
1192	1DS21AI017	5	21AI52	Advanced Machine Learning	O
1193	1DS21AI017	5	21AI53	Computer Networks and Communication	A
1194	1DS21AI017	5	21AI54	Introduction to Robotics	O
1195	1DS21AI017	5	21AIL55	Computer Networks Lab	A+
1196	1DS21AI017	5	21RM56	Research Methodology and Intellectual Property Rights	A
1197	1DS21AI017	5	21ES57	Environmental Studies	A+
1198	1DS21AI017	5	21AIL584	Full Stack Development Lab	O
1199	1DS21AI018	5	21AI51	Artificial Intelligence	O
1200	1DS21AI018	5	21AI52	Advanced Machine Learning	A+
1201	1DS21AI018	5	21AI53	Computer Networks and Communication	A+
1202	1DS21AI018	5	21AI54	Introduction to Robotics	O
1203	1DS21AI018	5	21AIL55	Computer Networks Lab	O
1204	1DS21AI018	5	21RM56	Research Methodology and Intellectual Property Rights	A
1205	1DS21AI018	5	21ES57	Environmental Studies	O
1206	1DS21AI018	5	21AIL584	Full Stack Development Lab	O
1207	1DS21AI019	5	21AI51	Artificial Intelligence	A
1208	1DS21AI019	5	21AI52	Advanced Machine Learning	A+
1209	1DS21AI019	5	21AI53	Computer Networks and Communication	B+
1210	1DS21AI019	5	21AI54	Introduction to Robotics	A+
1211	1DS21AI019	5	21AIL55	Computer Networks Lab	A+
1212	1DS21AI019	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1213	1DS21AI019	5	21ES57	Environmental Studies	A+
1214	1DS21AI019	5	21AIL584	Full Stack Development Lab	O
1215	1DS21AI020	5	21AI51	Artificial Intelligence	A+
1216	1DS21AI020	5	21AI52	Advanced Machine Learning	A
1217	1DS21AI020	5	21AI53	Computer Networks and Communication	B+
1218	1DS21AI020	5	21AI54	Introduction to Robotics	A+
1219	1DS21AI020	5	21AIL55	Computer Networks Lab	A+
1220	1DS21AI020	5	21RM56	Research Methodology and Intellectual Property Rights	A
1221	1DS21AI020	5	21ES57	Environmental Studies	A+
1222	1DS21AI020	5	21AIL584	Full Stack Development Lab	A+
1223	1DS21AI021	5	21AI51	Artificial Intelligence	A+
1224	1DS21AI021	5	21AI52	Advanced Machine Learning	A+
1225	1DS21AI021	5	21AI53	Computer Networks and Communication	A+
1226	1DS21AI021	5	21AI54	Introduction to Robotics	A+
1227	1DS21AI021	5	21AIL55	Computer Networks Lab	O
1228	1DS21AI021	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1229	1DS21AI021	5	21ES57	Environmental Studies	A+
1230	1DS21AI021	5	21AIL584	Full Stack Development Lab	A+
1231	1DS21AI022	5	21AI51	Artificial Intelligence	A
1232	1DS21AI022	5	21AI52	Advanced Machine Learning	A+
1233	1DS21AI022	5	21AI53	Computer Networks and Communication	B+
1234	1DS21AI022	5	21AI54	Introduction to Robotics	A+
1235	1DS21AI022	5	21AIL55	Computer Networks Lab	O
1236	1DS21AI022	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1237	1DS21AI022	5	21ES57	Environmental Studies	A+
1238	1DS21AI022	5	21AIL584	Full Stack Development Lab	O
1239	1DS21AI023	5	21AI51	Artificial Intelligence	O
1240	1DS21AI023	5	21AI52	Advanced Machine Learning	O
1241	1DS21AI023	5	21AI53	Computer Networks and Communication	O
1242	1DS21AI023	5	21AI54	Introduction to Robotics	O
1243	1DS21AI023	5	21AIL55	Computer Networks Lab	O
1244	1DS21AI023	5	21RM56	Research Methodology and Intellectual Property Rights	O
1245	1DS21AI023	5	21ES57	Environmental Studies	O
1246	1DS21AI023	5	21AIL584	Full Stack Development Lab	O
1247	1DS21AI024	5	21AI51	Artificial Intelligence	A
1248	1DS21AI024	5	21AI52	Advanced Machine Learning	A+
1249	1DS21AI024	5	21AI53	Computer Networks and Communication	B+
1250	1DS21AI024	5	21AI54	Introduction to Robotics	A+
1251	1DS21AI024	5	21AIL55	Computer Networks Lab	A+
1252	1DS21AI024	5	21RM56	Research Methodology and Intellectual Property Rights	A
1253	1DS21AI024	5	21ES57	Environmental Studies	A+
1254	1DS21AI024	5	21AIL584	Full Stack Development Lab	O
1255	1DS21AI025	5	21AI51	Artificial Intelligence	O
1256	1DS21AI025	5	21AI52	Advanced Machine Learning	A+
1257	1DS21AI025	5	21AI53	Computer Networks and Communication	A+
1258	1DS21AI025	5	21AI54	Introduction to Robotics	O
1259	1DS21AI025	5	21AIL55	Computer Networks Lab	O
1260	1DS21AI025	5	21RM56	Research Methodology and Intellectual Property Rights	A
1261	1DS21AI025	5	21ES57	Environmental Studies	A+
1262	1DS21AI025	5	21AIL584	Full Stack Development Lab	O
1263	1DS21AI026	5	21AI51	Artificial Intelligence	B+
1264	1DS21AI026	5	21AI52	Advanced Machine Learning	A
1265	1DS21AI026	5	21AI53	Computer Networks and Communication	B+
1266	1DS21AI026	5	21AI54	Introduction to Robotics	A
1267	1DS21AI026	5	21AIL55	Computer Networks Lab	A+
1268	1DS21AI026	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1269	1DS21AI026	5	21ES57	Environmental Studies	A
1270	1DS21AI026	5	21AIL584	Full Stack Development Lab	A+
1271	1DS21AI027	5	21AI51	Artificial Intelligence	A+
1272	1DS21AI027	5	21AI52	Advanced Machine Learning	A+
1273	1DS21AI027	5	21AI53	Computer Networks and Communication	A
1274	1DS21AI027	5	21AI54	Introduction to Robotics	A+
1275	1DS21AI027	5	21AIL55	Computer Networks Lab	A
1276	1DS21AI027	5	21RM56	Research Methodology and Intellectual Property Rights	A
1277	1DS21AI027	5	21ES57	Environmental Studies	O
1278	1DS21AI027	5	21AIL584	Full Stack Development Lab	A+
1279	1DS21AI028	5	21AI51	Artificial Intelligence	O
1280	1DS21AI028	5	21AI52	Advanced Machine Learning	O
1281	1DS21AI028	5	21AI53	Computer Networks and Communication	O
1282	1DS21AI028	5	21AI54	Introduction to Robotics	O
1283	1DS21AI028	5	21AIL55	Computer Networks Lab	O
1284	1DS21AI028	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1285	1DS21AI028	5	21ES57	Environmental Studies	O
1286	1DS21AI028	5	21AIL584	Full Stack Development Lab	O
1287	1DS21AI029	5	21AI51	Artificial Intelligence	B+
1288	1DS21AI029	5	21AI52	Advanced Machine Learning	NE
1289	1DS21AI029	5	21AI53	Computer Networks and Communication	B
1290	1DS21AI029	5	21AI54	Introduction to Robotics	B
1291	1DS21AI029	5	21AIL55	Computer Networks Lab	NE
1292	1DS21AI029	5	21RM56	Research Methodology and Intellectual Property Rights	B
1293	1DS21AI029	5	21ES57	Environmental Studies	A
1294	1DS21AI029	5	21AIL584	Full Stack Development Lab	A
1295	1DS21AI030	5	21AI51	Artificial Intelligence	A+
1296	1DS21AI030	5	21AI52	Advanced Machine Learning	A+
1297	1DS21AI030	5	21AI53	Computer Networks and Communication	B+
1298	1DS21AI030	5	21AI54	Introduction to Robotics	A+
1299	1DS21AI030	5	21AIL55	Computer Networks Lab	O
1300	1DS21AI030	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1301	1DS21AI030	5	21ES57	Environmental Studies	A+
1302	1DS21AI030	5	21AIL584	Full Stack Development Lab	A+
1303	1DS21AI031	5	21AI51	Artificial Intelligence	A+
1304	1DS21AI031	5	21AI52	Advanced Machine Learning	A+
1305	1DS21AI031	5	21AI53	Computer Networks and Communication	B+
1306	1DS21AI031	5	21AI54	Introduction to Robotics	A+
1307	1DS21AI031	5	21AIL55	Computer Networks Lab	A+
1308	1DS21AI031	5	21RM56	Research Methodology and Intellectual Property Rights	A
1309	1DS21AI031	5	21ES57	Environmental Studies	A
1310	1DS21AI031	5	21AIL584	Full Stack Development Lab	A+
1311	1DS21AI032	5	21AI51	Artificial Intelligence	A
1312	1DS21AI032	5	21AI52	Advanced Machine Learning	A
1313	1DS21AI032	5	21AI53	Computer Networks and Communication	B+
1314	1DS21AI032	5	21AI54	Introduction to Robotics	A+
1315	1DS21AI032	5	21AIL55	Computer Networks Lab	A+
1316	1DS21AI032	5	21RM56	Research Methodology and Intellectual Property Rights	A
1317	1DS21AI032	5	21ES57	Environmental Studies	A
1318	1DS21AI032	5	21AIL584	Full Stack Development Lab	O
1319	1DS21AI033	5	21AI51	Artificial Intelligence	B+
1320	1DS21AI033	5	21AI52	Advanced Machine Learning	A
1321	1DS21AI033	5	21AI53	Computer Networks and Communication	B+
1322	1DS21AI033	5	21AI54	Introduction to Robotics	B+
1323	1DS21AI033	5	21AIL55	Computer Networks Lab	A
1324	1DS21AI033	5	21RM56	Research Methodology and Intellectual Property Rights	B
1325	1DS21AI033	5	21ES57	Environmental Studies	A+
1326	1DS21AI033	5	21AIL584	Full Stack Development Lab	O
1327	1DS21AI034	5	21AI51	Artificial Intelligence	O
1328	1DS21AI034	5	21AI52	Advanced Machine Learning	A+
1329	1DS21AI034	5	21AI53	Computer Networks and Communication	A+
1330	1DS21AI034	5	21AI54	Introduction to Robotics	O
1331	1DS21AI034	5	21AIL55	Computer Networks Lab	A+
1332	1DS21AI034	5	21RM56	Research Methodology and Intellectual Property Rights	A
1333	1DS21AI034	5	21ES57	Environmental Studies	A+
1334	1DS21AI034	5	21AIL584	Full Stack Development Lab	O
1335	1DS21AI035	5	21AI51	Artificial Intelligence	A+
1336	1DS21AI035	5	21AI52	Advanced Machine Learning	A
1337	1DS21AI035	5	21AI53	Computer Networks and Communication	B+
1338	1DS21AI035	5	21AI54	Introduction to Robotics	O
1339	1DS21AI035	5	21AIL55	Computer Networks Lab	A+
1340	1DS21AI035	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1341	1DS21AI035	5	21ES57	Environmental Studies	A+
1342	1DS21AI035	5	21AIL584	Full Stack Development Lab	A+
1343	1DS21AI036	5	21AI51	Artificial Intelligence	O
1344	1DS21AI036	5	21AI52	Advanced Machine Learning	O
1345	1DS21AI036	5	21AI53	Computer Networks and Communication	A+
1346	1DS21AI036	5	21AI54	Introduction to Robotics	O
1347	1DS21AI036	5	21AIL55	Computer Networks Lab	O
1348	1DS21AI036	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1349	1DS21AI036	5	21ES57	Environmental Studies	A+
1350	1DS21AI036	5	21AIL584	Full Stack Development Lab	O
1351	1DS21AI037	5	21AI51	Artificial Intelligence	O
1352	1DS21AI037	5	21AI52	Advanced Machine Learning	A+
1353	1DS21AI037	5	21AI53	Computer Networks and Communication	A+
1354	1DS21AI037	5	21AI54	Introduction to Robotics	O
1355	1DS21AI037	5	21AIL55	Computer Networks Lab	A+
1356	1DS21AI037	5	21RM56	Research Methodology and Intellectual Property Rights	A
1357	1DS21AI037	5	21ES57	Environmental Studies	A
1358	1DS21AI037	5	21AIL584	Full Stack Development Lab	O
1359	1DS21AI038	5	21AI51	Artificial Intelligence	A+
1360	1DS21AI038	5	21AI52	Advanced Machine Learning	A
1361	1DS21AI038	5	21AI53	Computer Networks and Communication	A
1362	1DS21AI038	5	21AI54	Introduction to Robotics	O
1363	1DS21AI038	5	21AIL55	Computer Networks Lab	F
1364	1DS21AI038	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1365	1DS21AI038	5	21ES57	Environmental Studies	A
1366	1DS21AI038	5	21AIL584	Full Stack Development Lab	O
1367	1DS21AI039	5	21AI51	Artificial Intelligence	A+
1368	1DS21AI039	5	21AI52	Advanced Machine Learning	A+
1369	1DS21AI039	5	21AI53	Computer Networks and Communication	A
1370	1DS21AI039	5	21AI54	Introduction to Robotics	A+
1371	1DS21AI039	5	21AIL55	Computer Networks Lab	A
1372	1DS21AI039	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1373	1DS21AI039	5	21ES57	Environmental Studies	A
1374	1DS21AI039	5	21AIL584	Full Stack Development Lab	O
1375	1DS21AI040	5	21AI51	Artificial Intelligence	O
1376	1DS21AI040	5	21AI52	Advanced Machine Learning	A+
1377	1DS21AI040	5	21AI53	Computer Networks and Communication	B+
1378	1DS21AI040	5	21AI54	Introduction to Robotics	A+
1379	1DS21AI040	5	21AIL55	Computer Networks Lab	O
1380	1DS21AI040	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1381	1DS21AI040	5	21ES57	Environmental Studies	A+
1382	1DS21AI040	5	21AIL584	Full Stack Development Lab	O
1383	1DS21AI041	5	21AI51	Artificial Intelligence	O
1384	1DS21AI041	5	21AI52	Advanced Machine Learning	A+
1385	1DS21AI041	5	21AI53	Computer Networks and Communication	B+
1386	1DS21AI041	5	21AI54	Introduction to Robotics	A+
1387	1DS21AI041	5	21AIL55	Computer Networks Lab	A+
1388	1DS21AI041	5	21RM56	Research Methodology and Intellectual Property Rights	A
1389	1DS21AI041	5	21ES57	Environmental Studies	O
1390	1DS21AI041	5	21AIL584	Full Stack Development Lab	O
1391	1DS21AI042	5	21AI51	Artificial Intelligence	O
1392	1DS21AI042	5	21AI52	Advanced Machine Learning	A+
1393	1DS21AI042	5	21AI53	Computer Networks and Communication	A+
1394	1DS21AI042	5	21AI54	Introduction to Robotics	O
1395	1DS21AI042	5	21AIL55	Computer Networks Lab	A+
1396	1DS21AI042	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1397	1DS21AI042	5	21ES57	Environmental Studies	O
1398	1DS21AI042	5	21AIL584	Full Stack Development Lab	O
1399	1DS21AI043	5	21AI51	Artificial Intelligence	O
1400	1DS21AI043	5	21AI52	Advanced Machine Learning	A+
1401	1DS21AI043	5	21AI53	Computer Networks and Communication	A+
1402	1DS21AI043	5	21AI54	Introduction to Robotics	O
1403	1DS21AI043	5	21AIL55	Computer Networks Lab	O
1404	1DS21AI043	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1405	1DS21AI043	5	21ES57	Environmental Studies	A+
1406	1DS21AI043	5	21AIL584	Full Stack Development Lab	O
1407	1DS21AI044	5	21AI51	Artificial Intelligence	A+
1408	1DS21AI044	5	21AI52	Advanced Machine Learning	A+
1409	1DS21AI044	5	21AI53	Computer Networks and Communication	B+
1410	1DS21AI044	5	21AI54	Introduction to Robotics	O
1411	1DS21AI044	5	21AIL55	Computer Networks Lab	A
1412	1DS21AI044	5	21RM56	Research Methodology and Intellectual Property Rights	A
1413	1DS21AI044	5	21ES57	Environmental Studies	A+
1414	1DS21AI044	5	21AIL584	Full Stack Development Lab	O
1415	1DS21AI045	5	21AI51	Artificial Intelligence	A
1416	1DS21AI045	5	21AI52	Advanced Machine Learning	A+
1417	1DS21AI045	5	21AI53	Computer Networks and Communication	A+
1418	1DS21AI045	5	21AI54	Introduction to Robotics	A+
1419	1DS21AI045	5	21AIL55	Computer Networks Lab	A+
1420	1DS21AI045	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1421	1DS21AI045	5	21ES57	Environmental Studies	A+
1422	1DS21AI045	5	21AIL584	Full Stack Development Lab	O
1423	1DS21AI046	5	21AI51	Artificial Intelligence	O
1424	1DS21AI046	5	21AI52	Advanced Machine Learning	A+
1425	1DS21AI046	5	21AI53	Computer Networks and Communication	A
1426	1DS21AI046	5	21AI54	Introduction to Robotics	A+
1427	1DS21AI046	5	21AIL55	Computer Networks Lab	A
1428	1DS21AI046	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1429	1DS21AI046	5	21ES57	Environmental Studies	A+
1430	1DS21AI046	5	21AIL584	Full Stack Development Lab	O
1431	1DS21AI047	5	21AI51	Artificial Intelligence	A+
1432	1DS21AI047	5	21AI52	Advanced Machine Learning	A+
1433	1DS21AI047	5	21AI53	Computer Networks and Communication	A+
1434	1DS21AI047	5	21AI54	Introduction to Robotics	O
1435	1DS21AI047	5	21AIL55	Computer Networks Lab	A+
1436	1DS21AI047	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1437	1DS21AI047	5	21ES57	Environmental Studies	A+
1438	1DS21AI047	5	21AIL584	Full Stack Development Lab	O
1439	1DS21AI048	5	21AI51	Artificial Intelligence	A
1440	1DS21AI048	5	21AI52	Advanced Machine Learning	A
1441	1DS21AI048	5	21AI53	Computer Networks and Communication	A
1442	1DS21AI048	5	21AI54	Introduction to Robotics	A+
1443	1DS21AI048	5	21AIL55	Computer Networks Lab	A
1444	1DS21AI048	5	21RM56	Research Methodology and Intellectual Property Rights	A
1445	1DS21AI048	5	21ES57	Environmental Studies	A+
1446	1DS21AI048	5	21AIL584	Full Stack Development Lab	A+
1447	1DS21AI049	5	21AI51	Artificial Intelligence	A+
1448	1DS21AI049	5	21AI52	Advanced Machine Learning	A+
1449	1DS21AI049	5	21AI53	Computer Networks and Communication	A
1450	1DS21AI049	5	21AI54	Introduction to Robotics	A+
1451	1DS21AI049	5	21AIL55	Computer Networks Lab	A+
1452	1DS21AI049	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1453	1DS21AI049	5	21ES57	Environmental Studies	A+
1454	1DS21AI049	5	21AIL584	Full Stack Development Lab	A+
1455	1DS21AI050	5	21AI51	Artificial Intelligence	O
1456	1DS21AI050	5	21AI52	Advanced Machine Learning	A+
1457	1DS21AI050	5	21AI53	Computer Networks and Communication	A+
1458	1DS21AI050	5	21AI54	Introduction to Robotics	O
1459	1DS21AI050	5	21AIL55	Computer Networks Lab	A+
1460	1DS21AI050	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1461	1DS21AI050	5	21ES57	Environmental Studies	A+
1462	1DS21AI050	5	21AIL584	Full Stack Development Lab	O
1463	1DS21AI051	5	21AI51	Artificial Intelligence	A
1464	1DS21AI051	5	21AI52	Advanced Machine Learning	A
1465	1DS21AI051	5	21AI53	Computer Networks and Communication	B+
1466	1DS21AI051	5	21AI54	Introduction to Robotics	A
1467	1DS21AI051	5	21AIL55	Computer Networks Lab	A
1468	1DS21AI051	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1469	1DS21AI051	5	21ES57	Environmental Studies	B+
1470	1DS21AI051	5	21AIL584	Full Stack Development Lab	A+
1471	1DS21AI052	5	21AI51	Artificial Intelligence	O
1472	1DS21AI052	5	21AI52	Advanced Machine Learning	O
1473	1DS21AI052	5	21AI53	Computer Networks and Communication	A+
1474	1DS21AI052	5	21AI54	Introduction to Robotics	O
1475	1DS21AI052	5	21AIL55	Computer Networks Lab	A+
1476	1DS21AI052	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1477	1DS21AI052	5	21ES57	Environmental Studies	O
1478	1DS21AI052	5	21AIL584	Full Stack Development Lab	O
1479	1DS21AI053	5	21AI51	Artificial Intelligence	A
1480	1DS21AI053	5	21AI52	Advanced Machine Learning	A
1481	1DS21AI053	5	21AI53	Computer Networks and Communication	A
1482	1DS21AI053	5	21AI54	Introduction to Robotics	A+
1483	1DS21AI053	5	21AIL55	Computer Networks Lab	A+
1484	1DS21AI053	5	21RM56	Research Methodology and Intellectual Property Rights	A
1485	1DS21AI053	5	21ES57	Environmental Studies	A
1486	1DS21AI053	5	21AIL584	Full Stack Development Lab	O
1487	1DS21AI054	5	21AI51	Artificial Intelligence	O
1488	1DS21AI054	5	21AI52	Advanced Machine Learning	A+
1489	1DS21AI054	5	21AI53	Computer Networks and Communication	A+
1490	1DS21AI054	5	21AI54	Introduction to Robotics	O
1491	1DS21AI054	5	21AIL55	Computer Networks Lab	O
1492	1DS21AI054	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1493	1DS21AI054	5	21ES57	Environmental Studies	O
1494	1DS21AI054	5	21AIL584	Full Stack Development Lab	O
1495	1DS21AI055	5	21AI51	Artificial Intelligence	O
1496	1DS21AI055	5	21AI52	Advanced Machine Learning	O
1497	1DS21AI055	5	21AI53	Computer Networks and Communication	O
1498	1DS21AI055	5	21AI54	Introduction to Robotics	O
1499	1DS21AI055	5	21AIL55	Computer Networks Lab	O
1500	1DS21AI055	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1501	1DS21AI055	5	21ES57	Environmental Studies	O
1502	1DS21AI055	5	21AIL584	Full Stack Development Lab	O
1503	1DS21AI056	5	21AI51	Artificial Intelligence	B+
1504	1DS21AI056	5	21AI52	Advanced Machine Learning	A
1505	1DS21AI056	5	21AI53	Computer Networks and Communication	B+
1506	1DS21AI056	5	21AI54	Introduction to Robotics	A
1507	1DS21AI056	5	21AIL55	Computer Networks Lab	A
1508	1DS21AI056	5	21RM56	Research Methodology and Intellectual Property Rights	C
1509	1DS21AI056	5	21ES57	Environmental Studies	A
1510	1DS21AI056	5	21AIL584	Full Stack Development Lab	A+
1511	1DS21AI057	5	21AI51	Artificial Intelligence	A+
1512	1DS21AI057	5	21AI52	Advanced Machine Learning	A+
1513	1DS21AI057	5	21AI53	Computer Networks and Communication	A+
1514	1DS21AI057	5	21AI54	Introduction to Robotics	A+
1515	1DS21AI057	5	21AIL55	Computer Networks Lab	O
1516	1DS21AI057	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1517	1DS21AI057	5	21ES57	Environmental Studies	A+
1518	1DS21AI057	5	21AIL584	Full Stack Development Lab	O
1519	1DS21AI058	5	21AI51	Artificial Intelligence	O
1520	1DS21AI058	5	21AI52	Advanced Machine Learning	O
1521	1DS21AI058	5	21AI53	Computer Networks and Communication	A+
1522	1DS21AI058	5	21AI54	Introduction to Robotics	O
1523	1DS21AI058	5	21AIL55	Computer Networks Lab	O
1524	1DS21AI058	5	21RM56	Research Methodology and Intellectual Property Rights	A+
1525	1DS21AI058	5	21ES57	Environmental Studies	O
1526	1DS21AI058	5	21AIL584	Full Stack Development Lab	O
1527	1DS21AI059	5	21AI51	Artificial Intelligence	A
1528	1DS21AI059	5	21AI52	Advanced Machine Learning	A
1529	1DS21AI059	5	21AI53	Computer Networks and Communication	B+
1530	1DS21AI059	5	21AI54	Introduction to Robotics	O
1531	1DS21AI059	5	21AIL55	Computer Networks Lab	A
1532	1DS21AI059	5	21RM56	Research Methodology and Intellectual Property Rights	B+
1533	1DS21AI059	5	21ES57	Environmental Studies	A
1534	1DS21AI059	5	21AIL584	Full Stack Development Lab	O
1535	1DS21AI001	6	21AI61	Natural Language Processing	A+
1536	1DS21AI001	6	21AI62	Applied Big Data and Cloud Computing	O
1537	1DS21AI001	6	21AI63	MLOps	A+
1538	1DS21AI001	6	21AI643	IoT and 5G	A+
1539	1DS21AI001	6	21MA651	Introduction to AI	B+
1540	1DS21AI001	6	21AIL66	NLP Lab	O
1541	1DS21AI001	6	21AIMP67	Mini Project	O
1542	1DS21AI001	6	21INT68	Innovation and Entrepreneurship	O
1543	1DS21AI002	6	21AI61	Natural Language Processing	O
1544	1DS21AI002	6	21AI62	Applied Big Data and Cloud Computing	O
1545	1DS21AI002	6	21AI63	MLOps	A+
1546	1DS21AI002	6	21AI643	IoT and 5G	A+
1547	1DS21AI002	6	21MA651	Introduction to AI	O
1548	1DS21AI002	6	21AIL66	NLP Lab	O
1549	1DS21AI002	6	21AIMP67	Mini Project	A+
1550	1DS21AI002	6	21INT68	Innovation and Entrepreneurship	O
1551	1DS21AI003	6	21AI61	Natural Language Processing	A
1552	1DS21AI003	6	21AI62	Applied Big Data and Cloud Computing	A
1553	1DS21AI003	6	21AI63	MLOps	A+
1554	1DS21AI003	6	21AI643	IoT and 5G	B+
1555	1DS21AI003	6	21MA651	Introduction to AI	C
1556	1DS21AI003	6	21AIL66	NLP Lab	O
1557	1DS21AI003	6	21AIMP67	Mini Project	O
1558	1DS21AI003	6	21INT68	Innovation and Entrepreneurship	O
1559	1DS21AI004	6	21AI61	Natural Language Processing	NE
1560	1DS21AI004	6	21AI62	Applied Big Data and Cloud Computing	NE
1561	1DS21AI004	6	21AI63	MLOps	NE
1562	1DS21AI004	6	21AI643	IoT and 5G	NE
1563	1DS21AI004	6	21MA651	Introduction to AI	P
1564	1DS21AI004	6	21AIL66	NLP Lab	NE
1565	1DS21AI004	6	21AIMP67	Mini Project	F
1566	1DS21AI004	6	21INT68	Innovation and Entrepreneurship	A+
1567	1DS21AI005	6	21AI61	Natural Language Processing	O
1568	1DS21AI005	6	21AI62	Applied Big Data and Cloud Computing	O
1569	1DS21AI005	6	21AI63	MLOps	A+
1570	1DS21AI005	6	21AI643	IoT and 5G	A+
1571	1DS21AI005	6	21MA651	Introduction to AI	O
1572	1DS21AI005	6	21AIL66	NLP Lab	O
1573	1DS21AI005	6	21AIMP67	Mini Project	O
1574	1DS21AI005	6	21INT68	Innovation and Entrepreneurship	O
1575	1DS21AI006	6	21AI61	Natural Language Processing	A
1576	1DS21AI006	6	21AI62	Applied Big Data and Cloud Computing	B+
1577	1DS21AI006	6	21AI63	MLOps	A
1578	1DS21AI006	6	21AI643	IoT and 5G	A
1579	1DS21AI006	6	21MA651	Introduction to AI	B+
1580	1DS21AI006	6	21AIL66	NLP Lab	A+
1581	1DS21AI006	6	21AIMP67	Mini Project	A+
1582	1DS21AI006	6	21INT68	Innovation and Entrepreneurship	O
1583	1DS21AI007	6	21AI61	Natural Language Processing	B
1584	1DS21AI007	6	21AI62	Applied Big Data and Cloud Computing	B+
1585	1DS21AI007	6	21AI63	MLOps	C
1586	1DS21AI007	6	21AI643	IoT and 5G	C
1587	1DS21AI007	6	21MA651	Introduction to AI	P
1588	1DS21AI007	6	21AIL66	NLP Lab	A+
1589	1DS21AI007	6	21AIMP67	Mini Project	O
1590	1DS21AI007	6	21INT68	Innovation and Entrepreneurship	A
1591	1DS21AI008	6	21AI61	Natural Language Processing	O
1592	1DS21AI008	6	21AI62	Applied Big Data and Cloud Computing	A+
1593	1DS21AI008	6	21AI63	MLOps	A
1594	1DS21AI008	6	21AI643	IoT and 5G	A
1595	1DS21AI008	6	21MA651	Introduction to AI	O
1596	1DS21AI008	6	21AIL66	NLP Lab	O
1597	1DS21AI008	6	21AIMP67	Mini Project	O
1598	1DS21AI008	6	21INT68	Innovation and Entrepreneurship	A+
1599	1DS21AI009	6	21AI61	Natural Language Processing	O
1600	1DS21AI009	6	21AI62	Applied Big Data and Cloud Computing	O
1601	1DS21AI009	6	21AI63	MLOps	A+
1602	1DS21AI009	6	21AI643	IoT and 5G	A+
1603	1DS21AI009	6	21MA651	Introduction to AI	O
1604	1DS21AI009	6	21AIL66	NLP Lab	O
1605	1DS21AI009	6	21AIMP67	Mini Project	O
1606	1DS21AI009	6	21INT68	Innovation and Entrepreneurship	O
1607	1DS21AI010	6	21AI61	Natural Language Processing	O
1608	1DS21AI010	6	21AI62	Applied Big Data and Cloud Computing	O
1609	1DS21AI010	6	21AI63	MLOps	A+
1610	1DS21AI010	6	21AI643	IoT and 5G	A+
1611	1DS21AI010	6	21MA651	Introduction to AI	A+
1612	1DS21AI010	6	21AIL66	NLP Lab	O
1613	1DS21AI010	6	21AIMP67	Mini Project	O
1614	1DS21AI010	6	21INT68	Innovation and Entrepreneurship	O
1615	1DS21AI011	6	21AI61	Natural Language Processing	A+
1616	1DS21AI011	6	21AI62	Applied Big Data and Cloud Computing	A+
1617	1DS21AI011	6	21AI63	MLOps	A+
1618	1DS21AI011	6	21AI643	IoT and 5G	A+
1619	1DS21AI011	6	21MA651	Introduction to AI	A
1620	1DS21AI011	6	21AIL66	NLP Lab	O
1621	1DS21AI011	6	21AIMP67	Mini Project	O
1622	1DS21AI011	6	21INT68	Innovation and Entrepreneurship	O
1623	1DS21AI012	6	21AI61	Natural Language Processing	O
1624	1DS21AI012	6	21AI62	Applied Big Data and Cloud Computing	O
1625	1DS21AI012	6	21AI63	MLOps	A+
1626	1DS21AI012	6	21AI643	IoT and 5G	O
1627	1DS21AI012	6	21MA651	Introduction to AI	O
1628	1DS21AI012	6	21AIL66	NLP Lab	O
1629	1DS21AI012	6	21AIMP67	Mini Project	O
1630	1DS21AI012	6	21INT68	Innovation and Entrepreneurship	O
1631	1DS21AI013	6	21AI61	Natural Language Processing	B+
1632	1DS21AI013	6	21AI62	Applied Big Data and Cloud Computing	A
1633	1DS21AI013	6	21AI63	MLOps	B+
1634	1DS21AI013	6	21AI643	IoT and 5G	B+
1635	1DS21AI013	6	21MA651	Introduction to AI	A+
1636	1DS21AI013	6	21AIL66	NLP Lab	A+
1637	1DS21AI013	6	21AIMP67	Mini Project	A+
1638	1DS21AI013	6	21INT68	Innovation and Entrepreneurship	A+
1639	1DS21AI014	6	21AI61	Natural Language Processing	B+
1640	1DS21AI014	6	21AI62	Applied Big Data and Cloud Computing	B+
1641	1DS21AI014	6	21AI63	MLOps	A
1642	1DS21AI014	6	21AI643	IoT and 5G	A
1643	1DS21AI014	6	21MA651	Introduction to AI	B+
1644	1DS21AI014	6	21AIL66	NLP Lab	O
1645	1DS21AI014	6	21AIMP67	Mini Project	A+
1646	1DS21AI014	6	21INT68	Innovation and Entrepreneurship	O
1647	1DS21AI015	6	21AI61	Natural Language Processing	A
1648	1DS21AI015	6	21AI62	Applied Big Data and Cloud Computing	A+
1649	1DS21AI015	6	21AI63	MLOps	B+
1650	1DS21AI015	6	21AI643	IoT and 5G	B+
1651	1DS21AI015	6	21MA651	Introduction to AI	A+
1652	1DS21AI015	6	21AIL66	NLP Lab	O
1653	1DS21AI015	6	21AIMP67	Mini Project	A+
1654	1DS21AI015	6	21INT68	Innovation and Entrepreneurship	O
1655	1DS21AI016	6	21AI61	Natural Language Processing	O
1656	1DS21AI016	6	21AI62	Applied Big Data and Cloud Computing	O
1657	1DS21AI016	6	21AI63	MLOps	A
1658	1DS21AI016	6	21AI643	IoT and 5G	A
1659	1DS21AI016	6	21MA651	Introduction to AI	A+
1660	1DS21AI016	6	21AIL66	NLP Lab	O
1661	1DS21AI016	6	21AIMP67	Mini Project	O
1662	1DS21AI016	6	21INT68	Innovation and Entrepreneurship	O
1663	1DS21AI017	6	21AI61	Natural Language Processing	O
1664	1DS21AI017	6	21AI62	Applied Big Data and Cloud Computing	O
1665	1DS21AI017	6	21AI63	MLOps	A+
1666	1DS21AI017	6	21AI643	IoT and 5G	O
1667	1DS21AI017	6	21MA651	Introduction to AI	O
1668	1DS21AI017	6	21AIL66	NLP Lab	O
1669	1DS21AI017	6	21AIMP67	Mini Project	O
1670	1DS21AI017	6	21INT68	Innovation and Entrepreneurship	O
1671	1DS21AI018	6	21AI61	Natural Language Processing	O
1672	1DS21AI018	6	21AI62	Applied Big Data and Cloud Computing	O
1673	1DS21AI018	6	21AI63	MLOps	O
1674	1DS21AI018	6	21AI643	IoT and 5G	A+
1675	1DS21AI018	6	21MA651	Introduction to AI	O
1676	1DS21AI018	6	21AIL66	NLP Lab	O
1677	1DS21AI018	6	21AIMP67	Mini Project	O
1678	1DS21AI018	6	21INT68	Innovation and Entrepreneurship	O
1679	1DS21AI019	6	21AI61	Natural Language Processing	A
1680	1DS21AI019	6	21AI62	Applied Big Data and Cloud Computing	A
1681	1DS21AI019	6	21AI63	MLOps	A
1682	1DS21AI019	6	21AI643	IoT and 5G	B+
1683	1DS21AI019	6	21MA651	Introduction to AI	B+
1684	1DS21AI019	6	21AIL66	NLP Lab	O
1685	1DS21AI019	6	21AIMP67	Mini Project	O
1686	1DS21AI019	6	21INT68	Innovation and Entrepreneurship	O
1687	1DS21AI020	6	21AI61	Natural Language Processing	A+
1688	1DS21AI020	6	21AI62	Applied Big Data and Cloud Computing	A+
1689	1DS21AI020	6	21AI63	MLOps	B+
1690	1DS21AI020	6	21AI643	IoT and 5G	B+
1691	1DS21AI020	6	21MA651	Introduction to AI	A
1692	1DS21AI020	6	21AIL66	NLP Lab	O
1693	1DS21AI020	6	21AIMP67	Mini Project	A+
1694	1DS21AI020	6	21INT68	Innovation and Entrepreneurship	O
1695	1DS21AI021	6	21AI61	Natural Language Processing	O
1696	1DS21AI021	6	21AI62	Applied Big Data and Cloud Computing	O
1697	1DS21AI021	6	21AI63	MLOps	A+
1698	1DS21AI021	6	21AI643	IoT and 5G	A+
1699	1DS21AI021	6	21MA651	Introduction to AI	A+
1700	1DS21AI021	6	21AIL66	NLP Lab	O
1701	1DS21AI021	6	21AIMP67	Mini Project	O
1702	1DS21AI021	6	21INT68	Innovation and Entrepreneurship	O
1703	1DS21AI022	6	21AI61	Natural Language Processing	A+
1704	1DS21AI022	6	21AI62	Applied Big Data and Cloud Computing	O
1705	1DS21AI022	6	21AI63	MLOps	A+
1706	1DS21AI022	6	21AI643	IoT and 5G	A
1707	1DS21AI022	6	21MA651	Introduction to AI	O
1708	1DS21AI022	6	21AIL66	NLP Lab	O
1709	1DS21AI022	6	21AIMP67	Mini Project	O
1710	1DS21AI022	6	21INT68	Innovation and Entrepreneurship	A+
1711	1DS21AI023	6	21AI61	Natural Language Processing	O
1712	1DS21AI023	6	21AI62	Applied Big Data and Cloud Computing	O
1713	1DS21AI023	6	21AI63	MLOps	O
1714	1DS21AI023	6	21AI643	IoT and 5G	O
1715	1DS21AI023	6	21MA651	Introduction to AI	O
1716	1DS21AI023	6	21AIL66	NLP Lab	O
1717	1DS21AI023	6	21AIMP67	Mini Project	O
1718	1DS21AI023	6	21INT68	Innovation and Entrepreneurship	O
1719	1DS21AI024	6	21AI61	Natural Language Processing	A
1720	1DS21AI024	6	21AI62	Applied Big Data and Cloud Computing	A+
1721	1DS21AI024	6	21AI63	MLOps	A+
1722	1DS21AI024	6	21AI643	IoT and 5G	A+
1723	1DS21AI024	6	21MA651	Introduction to AI	B+
1724	1DS21AI024	6	21AIL66	NLP Lab	A+
1725	1DS21AI024	6	21AIMP67	Mini Project	O
1726	1DS21AI024	6	21INT68	Innovation and Entrepreneurship	A+
1727	1DS21AI025	6	21AI61	Natural Language Processing	A+
1728	1DS21AI025	6	21AI62	Applied Big Data and Cloud Computing	O
1730	1DS21AI025	6	21AI643	IoT and 5G	A+
1731	1DS21AI025	6	21MA651	Introduction to AI	O
1732	1DS21AI025	6	21AIL66	NLP Lab	O
1733	1DS21AI025	6	21AIMP67	Mini Project	O
1734	1DS21AI025	6	21INT68	Innovation and Entrepreneurship	O
1735	1DS21AI026	6	21AI61	Natural Language Processing	B+
1736	1DS21AI026	6	21AI62	Applied Big Data and Cloud Computing	B+
1737	1DS21AI026	6	21AI63	MLOps	B+
1738	1DS21AI026	6	21AI643	IoT and 5G	B+
1739	1DS21AI026	6	21MA651	Introduction to AI	B+
1740	1DS21AI026	6	21AIL66	NLP Lab	O
1741	1DS21AI026	6	21AIMP67	Mini Project	O
1742	1DS21AI026	6	21INT68	Innovation and Entrepreneurship	O
1743	1DS21AI027	6	21AI61	Natural Language Processing	A+
1744	1DS21AI027	6	21AI62	Applied Big Data and Cloud Computing	A
1745	1DS21AI027	6	21AI63	MLOps	A
1746	1DS21AI027	6	21AI643	IoT and 5G	A
1747	1DS21AI027	6	21MA651	Introduction to AI	A+
1748	1DS21AI027	6	21AIL66	NLP Lab	O
1749	1DS21AI027	6	21AIMP67	Mini Project	O
1750	1DS21AI027	6	21INT68	Innovation and Entrepreneurship	O
1751	1DS21AI028	6	21AI61	Natural Language Processing	O
1752	1DS21AI028	6	21AI62	Applied Big Data and Cloud Computing	O
1753	1DS21AI028	6	21AI63	MLOps	A+
1754	1DS21AI028	6	21AI643	IoT and 5G	A+
1755	1DS21AI028	6	21MA651	Introduction to AI	A+
1756	1DS21AI028	6	21AIL66	NLP Lab	O
1757	1DS21AI028	6	21AIMP67	Mini Project	O
1758	1DS21AI028	6	21INT68	Innovation and Entrepreneurship	O
1759	1DS21AI029	6	21AI61	Natural Language Processing	NE
1760	1DS21AI029	6	21AI62	Applied Big Data and Cloud Computing	NE
1761	1DS21AI029	6	21AI63	MLOps	NE
1762	1DS21AI029	6	21AI643	IoT and 5G	NE
1763	1DS21AI029	6	21MA651	Introduction to AI	P
1764	1DS21AI029	6	21AIL66	NLP Lab	NE
1765	1DS21AI029	6	21AIMP67	Mini Project	F
1766	1DS21AI029	6	21INT68	Innovation and Entrepreneurship	A
1767	1DS21AI030	6	21AI61	Natural Language Processing	A
1768	1DS21AI030	6	21AI62	Applied Big Data and Cloud Computing	A+
1769	1DS21AI030	6	21AI63	MLOps	A+
1770	1DS21AI030	6	21AI643	IoT and 5G	A+
1771	1DS21AI030	6	21MA651	Introduction to AI	C
1772	1DS21AI030	6	21AIL66	NLP Lab	O
1773	1DS21AI030	6	21AIMP67	Mini Project	O
1774	1DS21AI030	6	21INT68	Innovation and Entrepreneurship	O
1775	1DS21AI031	6	21AI61	Natural Language Processing	O
1776	1DS21AI031	6	21AI62	Applied Big Data and Cloud Computing	O
1777	1DS21AI031	6	21AI63	MLOps	A+
1778	1DS21AI031	6	21AI643	IoT and 5G	A+
1779	1DS21AI031	6	21MA651	Introduction to AI	O
1780	1DS21AI031	6	21AIL66	NLP Lab	O
1781	1DS21AI031	6	21AIMP67	Mini Project	O
1782	1DS21AI031	6	21INT68	Innovation and Entrepreneurship	O
1783	1DS21AI032	6	21AI61	Natural Language Processing	A
1784	1DS21AI032	6	21AI62	Applied Big Data and Cloud Computing	A
1785	1DS21AI032	6	21AI63	MLOps	B+
1786	1DS21AI032	6	21AI643	IoT and 5G	A
1787	1DS21AI032	6	21MA651	Introduction to AI	B+
1788	1DS21AI032	6	21AIL66	NLP Lab	O
1789	1DS21AI032	6	21AIMP67	Mini Project	O
1790	1DS21AI032	6	21INT68	Innovation and Entrepreneurship	O
1791	1DS21AI033	6	21AI61	Natural Language Processing	B
1792	1DS21AI033	6	21AI62	Applied Big Data and Cloud Computing	A
1793	1DS21AI033	6	21AI63	MLOps	A
1794	1DS21AI033	6	21AI643	IoT and 5G	A
1795	1DS21AI033	6	21MA651	Introduction to AI	F
1796	1DS21AI033	6	21AIL66	NLP Lab	O
1797	1DS21AI033	6	21AIMP67	Mini Project	A+
1798	1DS21AI033	6	21INT68	Innovation and Entrepreneurship	O
1799	1DS21AI034	6	21AI61	Natural Language Processing	O
1800	1DS21AI034	6	21AI62	Applied Big Data and Cloud Computing	O
1801	1DS21AI034	6	21AI63	MLOps	O
1802	1DS21AI034	6	21AI643	IoT and 5G	O
1803	1DS21AI034	6	21MA651	Introduction to AI	O
1804	1DS21AI034	6	21AIL66	NLP Lab	O
1805	1DS21AI034	6	21AIMP67	Mini Project	O
1806	1DS21AI034	6	21INT68	Innovation and Entrepreneurship	O
1807	1DS21AI035	6	21AI61	Natural Language Processing	A+
1808	1DS21AI035	6	21AI62	Applied Big Data and Cloud Computing	A+
1809	1DS21AI035	6	21AI63	MLOps	A+
1810	1DS21AI035	6	21AI643	IoT and 5G	A+
1811	1DS21AI035	6	21MA651	Introduction to AI	A
1812	1DS21AI035	6	21AIL66	NLP Lab	O
1813	1DS21AI035	6	21AIMP67	Mini Project	A+
1814	1DS21AI035	6	21INT68	Innovation and Entrepreneurship	O
1815	1DS21AI036	6	21AI61	Natural Language Processing	O
1816	1DS21AI036	6	21AI62	Applied Big Data and Cloud Computing	O
1817	1DS21AI036	6	21AI63	MLOps	A+
1818	1DS21AI036	6	21AI643	IoT and 5G	O
1819	1DS21AI036	6	21MA651	Introduction to AI	A+
1820	1DS21AI036	6	21AIL66	NLP Lab	O
1821	1DS21AI036	6	21AIMP67	Mini Project	O
1822	1DS21AI036	6	21INT68	Innovation and Entrepreneurship	O
1823	1DS21AI037	6	21AI61	Natural Language Processing	O
1824	1DS21AI037	6	21AI62	Applied Big Data and Cloud Computing	O
1825	1DS21AI037	6	21AI63	MLOps	A+
1826	1DS21AI037	6	21AI643	IoT and 5G	A+
1827	1DS21AI037	6	21MA651	Introduction to AI	A+
1828	1DS21AI037	6	21AIL66	NLP Lab	O
1829	1DS21AI037	6	21AIMP67	Mini Project	O
1830	1DS21AI037	6	21INT68	Innovation and Entrepreneurship	A+
1831	1DS21AI038	6	21AI61	Natural Language Processing	A+
1832	1DS21AI038	6	21AI62	Applied Big Data and Cloud Computing	O
1833	1DS21AI038	6	21AI63	MLOps	A
1834	1DS21AI038	6	21AI643	IoT and 5G	A
1835	1DS21AI038	6	21MA651	Introduction to AI	A
1836	1DS21AI038	6	21AIL66	NLP Lab	O
1837	1DS21AI038	6	21AIMP67	Mini Project	A+
1838	1DS21AI038	6	21INT68	Innovation and Entrepreneurship	A+
1839	1DS21AI039	6	21AI61	Natural Language Processing	B+
1840	1DS21AI039	6	21AI62	Applied Big Data and Cloud Computing	A
1841	1DS21AI039	6	21AI63	MLOps	A
1842	1DS21AI039	6	21AI643	IoT and 5G	A+
1843	1DS21AI039	6	21MA651	Introduction to AI	A+
1844	1DS21AI039	6	21AIL66	NLP Lab	A+
1845	1DS21AI039	6	21AIMP67	Mini Project	A+
1846	1DS21AI039	6	21INT68	Innovation and Entrepreneurship	O
1847	1DS21AI040	6	21AI61	Natural Language Processing	O
1848	1DS21AI040	6	21AI62	Applied Big Data and Cloud Computing	O
1849	1DS21AI040	6	21AI63	MLOps	A
1850	1DS21AI040	6	21AI643	IoT and 5G	A
1851	1DS21AI040	6	21MA651	Introduction to AI	O
1852	1DS21AI040	6	21AIL66	NLP Lab	O
1853	1DS21AI040	6	21AIMP67	Mini Project	O
1854	1DS21AI040	6	21INT68	Innovation and Entrepreneurship	O
1855	1DS21AI041	6	21AI61	Natural Language Processing	O
1856	1DS21AI041	6	21AI62	Applied Big Data and Cloud Computing	O
1857	1DS21AI041	6	21AI63	MLOps	A+
1858	1DS21AI041	6	21AI643	IoT and 5G	A+
1859	1DS21AI041	6	21MA651	Introduction to AI	A+
1860	1DS21AI041	6	21AIL66	NLP Lab	O
1861	1DS21AI041	6	21AIMP67	Mini Project	O
1862	1DS21AI041	6	21INT68	Innovation and Entrepreneurship	O
1863	1DS21AI042	6	21AI61	Natural Language Processing	O
1864	1DS21AI042	6	21AI62	Applied Big Data and Cloud Computing	O
1865	1DS21AI042	6	21AI63	MLOps	A+
1866	1DS21AI042	6	21AI643	IoT and 5G	O
1867	1DS21AI042	6	21MA651	Introduction to AI	O
1868	1DS21AI042	6	21AIL66	NLP Lab	O
1869	1DS21AI042	6	21AIMP67	Mini Project	O
1870	1DS21AI042	6	21INT68	Innovation and Entrepreneurship	O
1871	1DS21AI043	6	21AI61	Natural Language Processing	O
1872	1DS21AI043	6	21AI62	Applied Big Data and Cloud Computing	O
1873	1DS21AI043	6	21AI63	MLOps	A+
1874	1DS21AI043	6	21AI643	IoT and 5G	O
1875	1DS21AI043	6	21MA651	Introduction to AI	A+
1876	1DS21AI043	6	21AIL66	NLP Lab	O
1877	1DS21AI043	6	21AIMP67	Mini Project	A+
1878	1DS21AI043	6	21INT68	Innovation and Entrepreneurship	O
1879	1DS21AI044	6	21AI61	Natural Language Processing	A+
1880	1DS21AI044	6	21AI62	Applied Big Data and Cloud Computing	O
1881	1DS21AI044	6	21AI63	MLOps	A+
1882	1DS21AI044	6	21AI643	IoT and 5G	A+
1883	1DS21AI044	6	21MA651	Introduction to AI	O
1884	1DS21AI044	6	21AIL66	NLP Lab	O
1885	1DS21AI044	6	21AIMP67	Mini Project	O
1886	1DS21AI044	6	21INT68	Innovation and Entrepreneurship	O
1887	1DS21AI045	6	21AI61	Natural Language Processing	A+
1888	1DS21AI045	6	21AI62	Applied Big Data and Cloud Computing	A+
1889	1DS21AI045	6	21AI63	MLOps	A+
1890	1DS21AI045	6	21AI643	IoT and 5G	A+
1891	1DS21AI045	6	21MA651	Introduction to AI	A
1892	1DS21AI045	6	21AIL66	NLP Lab	O
1893	1DS21AI045	6	21AIMP67	Mini Project	O
1894	1DS21AI045	6	21INT68	Innovation and Entrepreneurship	O
1895	1DS21AI046	6	21AI61	Natural Language Processing	A+
1896	1DS21AI046	6	21AI62	Applied Big Data and Cloud Computing	A+
1897	1DS21AI046	6	21AI63	MLOps	A+
1898	1DS21AI046	6	21AI643	IoT and 5G	A+
1899	1DS21AI046	6	21MA651	Introduction to AI	A+
1900	1DS21AI046	6	21AIL66	NLP Lab	O
1901	1DS21AI046	6	21AIMP67	Mini Project	O
1902	1DS21AI046	6	21INT68	Innovation and Entrepreneurship	O
1903	1DS21AI047	6	21AI61	Natural Language Processing	O
1904	1DS21AI047	6	21AI62	Applied Big Data and Cloud Computing	O
1905	1DS21AI047	6	21AI63	MLOps	A+
1906	1DS21AI047	6	21AI643	IoT and 5G	A+
1907	1DS21AI047	6	21MA651	Introduction to AI	O
1908	1DS21AI047	6	21AIL66	NLP Lab	O
1909	1DS21AI047	6	21AIMP67	Mini Project	A+
1910	1DS21AI047	6	21INT68	Innovation and Entrepreneurship	O
1911	1DS21AI048	6	21AI61	Natural Language Processing	A
1912	1DS21AI048	6	21AI62	Applied Big Data and Cloud Computing	A+
1913	1DS21AI048	6	21AI63	MLOps	A
1914	1DS21AI048	6	21AI643	IoT and 5G	A+
1915	1DS21AI048	6	21MA651	Introduction to AI	A
1916	1DS21AI048	6	21AIL66	NLP Lab	O
1917	1DS21AI048	6	21AIMP67	Mini Project	O
1918	1DS21AI048	6	21INT68	Innovation and Entrepreneurship	O
1919	1DS21AI049	6	21AI61	Natural Language Processing	A
1920	1DS21AI049	6	21AI62	Applied Big Data and Cloud Computing	O
1921	1DS21AI049	6	21AI63	MLOps	A+
1922	1DS21AI049	6	21AI643	IoT and 5G	A+
1923	1DS21AI049	6	21MA651	Introduction to AI	O
1924	1DS21AI049	6	21AIL66	NLP Lab	O
1925	1DS21AI049	6	21AIMP67	Mini Project	O
1926	1DS21AI049	6	21INT68	Innovation and Entrepreneurship	O
1927	1DS21AI050	6	21AI61	Natural Language Processing	A+
1928	1DS21AI050	6	21AI62	Applied Big Data and Cloud Computing	O
1929	1DS21AI050	6	21AI63	MLOps	A+
1930	1DS21AI050	6	21AI643	IoT and 5G	A+
1931	1DS21AI050	6	21MA651	Introduction to AI	A+
1932	1DS21AI050	6	21AIL66	NLP Lab	O
1933	1DS21AI050	6	21AIMP67	Mini Project	O
1934	1DS21AI050	6	21INT68	Innovation and Entrepreneurship	O
1935	1DS21AI051	6	21AI61	Natural Language Processing	B+
1936	1DS21AI051	6	21AI62	Applied Big Data and Cloud Computing	A+
1937	1DS21AI051	6	21AI63	MLOps	A
1938	1DS21AI051	6	21AI643	IoT and 5G	A
1939	1DS21AI051	6	21MA651	Introduction to AI	A+
1940	1DS21AI051	6	21AIL66	NLP Lab	A+
1941	1DS21AI051	6	21AIMP67	Mini Project	A+
1942	1DS21AI051	6	21INT68	Innovation and Entrepreneurship	O
1943	1DS21AI052	6	21AI61	Natural Language Processing	A+
1944	1DS21AI052	6	21AI62	Applied Big Data and Cloud Computing	O
1945	1DS21AI052	6	21AI63	MLOps	A+
1946	1DS21AI052	6	21AI643	IoT and 5G	A+
1947	1DS21AI052	6	21MA651	Introduction to AI	O
1948	1DS21AI052	6	21AIL66	NLP Lab	O
1949	1DS21AI052	6	21AIMP67	Mini Project	O
1950	1DS21AI052	6	21INT68	Innovation and Entrepreneurship	O
1951	1DS21AI053	6	21AI61	Natural Language Processing	A
1952	1DS21AI053	6	21AI62	Applied Big Data and Cloud Computing	O
1953	1DS21AI053	6	21AI63	MLOps	A+
1954	1DS21AI053	6	21AI643	IoT and 5G	A
1955	1DS21AI053	6	21MA651	Introduction to AI	A
1956	1DS21AI053	6	21AIL66	NLP Lab	O
1957	1DS21AI053	6	21AIMP67	Mini Project	A+
1958	1DS21AI053	6	21INT68	Innovation and Entrepreneurship	O
1959	1DS21AI054	6	21AI61	Natural Language Processing	O
1960	1DS21AI054	6	21AI62	Applied Big Data and Cloud Computing	O
1961	1DS21AI054	6	21AI63	MLOps	O
1962	1DS21AI054	6	21AI643	IoT and 5G	O
1963	1DS21AI054	6	21MA651	Introduction to AI	A+
1964	1DS21AI054	6	21AIL66	NLP Lab	O
1965	1DS21AI054	6	21AIMP67	Mini Project	O
1966	1DS21AI054	6	21INT68	Innovation and Entrepreneurship	O
1967	1DS21AI055	6	21AI61	Natural Language Processing	O
1968	1DS21AI055	6	21AI62	Applied Big Data and Cloud Computing	O
1969	1DS21AI055	6	21AI63	MLOps	O
1970	1DS21AI055	6	21AI643	IoT and 5G	O
1971	1DS21AI055	6	21MA651	Introduction to AI	O
1972	1DS21AI055	6	21AIL66	NLP Lab	O
1973	1DS21AI055	6	21AIMP67	Mini Project	O
1974	1DS21AI055	6	21INT68	Innovation and Entrepreneurship	O
1975	1DS21AI056	6	21AI61	Natural Language Processing	A
1976	1DS21AI056	6	21AI62	Applied Big Data and Cloud Computing	A
1977	1DS21AI056	6	21AI63	MLOps	A
1978	1DS21AI056	6	21AI643	IoT and 5G	A
1979	1DS21AI056	6	21MA651	Introduction to AI	B+
1980	1DS21AI056	6	21AIL66	NLP Lab	A+
1981	1DS21AI056	6	21AIMP67	Mini Project	A+
1982	1DS21AI056	6	21INT68	Innovation and Entrepreneurship	O
1983	1DS21AI057	6	21AI61	Natural Language Processing	O
1984	1DS21AI057	6	21AI62	Applied Big Data and Cloud Computing	O
1985	1DS21AI057	6	21AI63	MLOps	A+
1986	1DS21AI057	6	21AI643	IoT and 5G	O
1987	1DS21AI057	6	21MA651	Introduction to AI	A+
1988	1DS21AI057	6	21AIL66	NLP Lab	O
1989	1DS21AI057	6	21AIMP67	Mini Project	O
1990	1DS21AI057	6	21INT68	Innovation and Entrepreneurship	O
1991	1DS21AI058	6	21AI61	Natural Language Processing	O
1992	1DS21AI058	6	21AI62	Applied Big Data and Cloud Computing	O
1993	1DS21AI058	6	21AI63	MLOps	O
1994	1DS21AI058	6	21AI643	IoT and 5G	O
1995	1DS21AI058	6	21MA651	Introduction to AI	A+
1996	1DS21AI058	6	21AIL66	NLP Lab	O
1997	1DS21AI058	6	21AIMP67	Mini Project	O
1998	1DS21AI058	6	21INT68	Innovation and Entrepreneurship	O
1999	1DS21AI059	6	21AI61	Natural Language Processing	B+
2000	1DS21AI059	6	21AI62	Applied Big Data and Cloud Computing	A
2001	1DS21AI059	6	21AI63	MLOps	B+
2002	1DS21AI059	6	21AI643	IoT and 5G	B+
2003	1DS21AI059	6	21MA651	Introduction to AI	A+
2004	1DS21AI059	6	21AIL66	NLP Lab	A+
2005	1DS21AI059	6	21AIMP67	Mini Project	O
2006	1DS21AI059	6	21INT68	Innovation and Entrepreneurship	A+
2007	1DS21AI001	7	21HS71	Management and Entrepreneurship	A
2008	1DS21AI001	7	21AI72	Generative AI	A
2009	1DS21AI001	7	21AI731	Advanced Data Security and Privacy	A+
2010	1DS21AI001	7	21AI744	Applied AI	A+
2011	1DS21AI001	7	21AE751	AI in Practice	O
2012	1DS21AI001	7	21AIP76	Project Work	O
2013	1DS21AI002	7	21HS71	Management and Entrepreneurship	A+
2014	1DS21AI002	7	21AI72	Generative AI	O
2015	1DS21AI002	7	21AI731	Advanced Data Security and Privacy	A+
2016	1DS21AI002	7	21AI744	Applied AI	O
2017	1DS21AI002	7	21AE751	AI in Practice	A
2018	1DS21AI002	7	21AIP76	Project Work	O
2019	1DS21AI003	7	21HS71	Management and Entrepreneurship	A
2020	1DS21AI003	7	21AI72	Generative AI	A
2021	1DS21AI003	7	21AI731	Advanced Data Security and Privacy	B+
2022	1DS21AI003	7	21AI744	Applied AI	A+
2023	1DS21AI003	7	21AE751	AI in Practice	A+
2024	1DS21AI003	7	21AIP76	Project Work	O
2025	1DS21AI004	7	21HS71	Management and Entrepreneurship	NE
2026	1DS21AI004	7	21AI72	Generative AI	B
2027	1DS21AI004	7	21AI731	Advanced Data Security and Privacy	B
2028	1DS21AI004	7	21AI744	Applied AI	B
2029	1DS21AI004	7	21AE751	AI in Practice	C
2030	1DS21AI004	7	21AIP76	Project Work	B+
2031	1DS21AI005	7	21HS71	Management and Entrepreneurship	A+
2032	1DS21AI005	7	21AI72	Generative AI	O
2033	1DS21AI005	7	21AI731	Advanced Data Security and Privacy	A+
2034	1DS21AI005	7	21AI744	Applied AI	O
2035	1DS21AI005	7	21AE751	AI in Practice	O
2036	1DS21AI005	7	21AIP76	Project Work	O
2037	1DS21AI006	7	21HS71	Management and Entrepreneurship	A
2038	1DS21AI006	7	21AI72	Generative AI	A+
2039	1DS21AI006	7	21AI731	Advanced Data Security and Privacy	A
2040	1DS21AI006	7	21AI744	Applied AI	B+
2041	1DS21AI006	7	21AE751	AI in Practice	A
2042	1DS21AI006	7	21AIP76	Project Work	A+
2043	1DS21AI007	7	21HS71	Management and Entrepreneurship	B
2044	1DS21AI007	7	21AI72	Generative AI	B+
2045	1DS21AI007	7	21AI731	Advanced Data Security and Privacy	B
2046	1DS21AI007	7	21AI744	Applied AI	PP
2047	1DS21AI007	7	21AE751	AI in Practice	C
2048	1DS21AI007	7	21AIP76	Project Work	A
2049	1DS21AI008	7	21HS71	Management and Entrepreneurship	A
2050	1DS21AI008	7	21AI72	Generative AI	A+
2051	1DS21AI008	7	21AI731	Advanced Data Security and Privacy	A+
2052	1DS21AI008	7	21AI744	Applied AI	A
2053	1DS21AI008	7	21AE751	AI in Practice	O
2054	1DS21AI008	7	21AIP76	Project Work	O
2055	1DS21AI009	7	21HS71	Management and Entrepreneurship	A+
2056	1DS21AI009	7	21AI72	Generative AI	O
2057	1DS21AI009	7	21AI731	Advanced Data Security and Privacy	A+
2058	1DS21AI009	7	21AI744	Applied AI	O
2059	1DS21AI009	7	21AE751	AI in Practice	O
2060	1DS21AI009	7	21AIP76	Project Work	O
2061	1DS21AI010	7	21HS71	Management and Entrepreneurship	A+
2062	1DS21AI010	7	21AI72	Generative AI	O
2063	1DS21AI010	7	21AI731	Advanced Data Security and Privacy	O
2064	1DS21AI010	7	21AI744	Applied AI	O
2065	1DS21AI010	7	21AE751	AI in Practice	O
2066	1DS21AI010	7	21AIP76	Project Work	O
2067	1DS21AI011	7	21HS71	Management and Entrepreneurship	A+
2068	1DS21AI011	7	21AI72	Generative AI	A+
2069	1DS21AI011	7	21AI731	Advanced Data Security and Privacy	A+
2070	1DS21AI011	7	21AI744	Applied AI	A+
2071	1DS21AI011	7	21AE751	AI in Practice	A
2072	1DS21AI011	7	21AIP76	Project Work	O
2073	1DS21AI012	7	21HS71	Management and Entrepreneurship	A+
2074	1DS21AI012	7	21AI72	Generative AI	O
2075	1DS21AI012	7	21AI731	Advanced Data Security and Privacy	A+
2076	1DS21AI012	7	21AI744	Applied AI	O
2077	1DS21AI012	7	21AE751	AI in Practice	A
2078	1DS21AI012	7	21AIP76	Project Work	O
2079	1DS21AI013	7	21HS71	Management and Entrepreneurship	B+
2080	1DS21AI013	7	21AI72	Generative AI	C
2081	1DS21AI013	7	21AI731	Advanced Data Security and Privacy	B+
2082	1DS21AI013	7	21AI744	Applied AI	B
2083	1DS21AI013	7	21AE751	AI in Practice	P
2084	1DS21AI013	7	21AIP76	Project Work	B+
2085	1DS21AI014	7	21HS71	Management and Entrepreneurship	B
2086	1DS21AI014	7	21AI72	Generative AI	A+
2087	1DS21AI014	7	21AI731	Advanced Data Security and Privacy	B+
2088	1DS21AI014	7	21AI744	Applied AI	A
2089	1DS21AI014	7	21AE751	AI in Practice	A
2090	1DS21AI014	7	21AIP76	Project Work	O
2091	1DS21AI015	7	21HS71	Management and Entrepreneurship	A
2092	1DS21AI015	7	21AI72	Generative AI	A
2093	1DS21AI015	7	21AI731	Advanced Data Security and Privacy	A
2094	1DS21AI015	7	21AI744	Applied AI	B+
2095	1DS21AI015	7	21AE751	AI in Practice	A
2096	1DS21AI015	7	21AIP76	Project Work	O
2097	1DS21AI016	7	21HS71	Management and Entrepreneurship	A+
2098	1DS21AI016	7	21AI72	Generative AI	O
2099	1DS21AI016	7	21AI731	Advanced Data Security and Privacy	A+
2100	1DS21AI016	7	21AI744	Applied AI	A+
2101	1DS21AI016	7	21AE751	AI in Practice	A
2102	1DS21AI016	7	21AIP76	Project Work	O
2103	1DS21AI017	7	21HS71	Management and Entrepreneurship	O
2104	1DS21AI017	7	21AI72	Generative AI	O
2105	1DS21AI017	7	21AI731	Advanced Data Security and Privacy	A+
2106	1DS21AI017	7	21AI744	Applied AI	O
2107	1DS21AI017	7	21AE751	AI in Practice	O
2108	1DS21AI017	7	21AIP76	Project Work	O
2109	1DS21AI018	7	21HS71	Management and Entrepreneurship	A+
2110	1DS21AI018	7	21AI72	Generative AI	O
2111	1DS21AI018	7	21AI731	Advanced Data Security and Privacy	A+
2112	1DS21AI018	7	21AI744	Applied AI	A+
2113	1DS21AI018	7	21AE751	AI in Practice	A+
2114	1DS21AI018	7	21AIP76	Project Work	O
2115	1DS21AI019	7	21HS71	Management and Entrepreneurship	A
2116	1DS21AI019	7	21AI72	Generative AI	A+
2117	1DS21AI019	7	21AI731	Advanced Data Security and Privacy	A
2118	1DS21AI019	7	21AI744	Applied AI	B+
2119	1DS21AI019	7	21AE751	AI in Practice	B+
2120	1DS21AI019	7	21AIP76	Project Work	A+
2121	1DS21AI020	7	21HS71	Management and Entrepreneurship	A+
2122	1DS21AI020	7	21AI72	Generative AI	A
2123	1DS21AI020	7	21AI731	Advanced Data Security and Privacy	A
2124	1DS21AI020	7	21AI744	Applied AI	A+
2125	1DS21AI020	7	21AE751	AI in Practice	B+
2126	1DS21AI020	7	21AIP76	Project Work	O
2127	1DS21AI021	7	21HS71	Management and Entrepreneurship	A+
2128	1DS21AI021	7	21AI72	Generative AI	A+
2129	1DS21AI021	7	21AI731	Advanced Data Security and Privacy	A+
2130	1DS21AI021	7	21AI744	Applied AI	A
2131	1DS21AI021	7	21AE751	AI in Practice	A
2132	1DS21AI021	7	21AIP76	Project Work	O
2133	1DS21AI022	7	21HS71	Management and Entrepreneurship	A+
2134	1DS21AI022	7	21AI72	Generative AI	O
2135	1DS21AI022	7	21AI731	Advanced Data Security and Privacy	A+
2136	1DS21AI022	7	21AI744	Applied AI	O
2137	1DS21AI022	7	21AE751	AI in Practice	A
2138	1DS21AI022	7	21AIP76	Project Work	O
2139	1DS21AI023	7	21HS71	Management and Entrepreneurship	A+
2140	1DS21AI023	7	21AI72	Generative AI	O
2141	1DS21AI023	7	21AI731	Advanced Data Security and Privacy	A+
2142	1DS21AI023	7	21AI744	Applied AI	O
2143	1DS21AI023	7	21AE751	AI in Practice	A+
2144	1DS21AI023	7	21AIP76	Project Work	O
2145	1DS21AI024	7	21HS71	Management and Entrepreneurship	A+
2146	1DS21AI024	7	21AI72	Generative AI	O
2147	1DS21AI024	7	21AI731	Advanced Data Security and Privacy	A
2148	1DS21AI024	7	21AI744	Applied AI	A+
2149	1DS21AI024	7	21AE751	AI in Practice	B+
2150	1DS21AI024	7	21AIP76	Project Work	O
2151	1DS21AI025	7	21HS71	Management and Entrepreneurship	A+
2152	1DS21AI025	7	21AI72	Generative AI	A+
2153	1DS21AI025	7	21AI731	Advanced Data Security and Privacy	A+
2154	1DS21AI025	7	21AI744	Applied AI	A+
2155	1DS21AI025	7	21AE751	AI in Practice	O
2156	1DS21AI025	7	21AIP76	Project Work	O
2157	1DS21AI026	7	21HS71	Management and Entrepreneurship	A
2158	1DS21AI026	7	21AI72	Generative AI	B+
2159	1DS21AI026	7	21AI731	Advanced Data Security and Privacy	B+
2160	1DS21AI026	7	21AI744	Applied AI	A
2161	1DS21AI026	7	21AE751	AI in Practice	A+
2162	1DS21AI026	7	21AIP76	Project Work	A+
2163	1DS21AI027	7	21HS71	Management and Entrepreneurship	A+
2164	1DS21AI027	7	21AI72	Generative AI	A+
2165	1DS21AI027	7	21AI731	Advanced Data Security and Privacy	A
2166	1DS21AI027	7	21AI744	Applied AI	A+
2167	1DS21AI027	7	21AE751	AI in Practice	A
2168	1DS21AI027	7	21AIP76	Project Work	O
2169	1DS21AI028	7	21HS71	Management and Entrepreneurship	A+
2170	1DS21AI028	7	21AI72	Generative AI	O
2171	1DS21AI028	7	21AI731	Advanced Data Security and Privacy	A+
2172	1DS21AI028	7	21AI744	Applied AI	O
2173	1DS21AI028	7	21AE751	AI in Practice	O
2174	1DS21AI028	7	21AIP76	Project Work	O
2175	1DS21AI029	7	21HS71	Management and Entrepreneurship	NE
2176	1DS21AI029	7	21AI72	Generative AI	PP
2177	1DS21AI029	7	21AI731	Advanced Data Security and Privacy	C
2178	1DS21AI029	7	21AI744	Applied AI	C
2179	1DS21AI029	7	21AE751	AI in Practice	PP
2180	1DS21AI029	7	21AIP76	Project Work	B+
2181	1DS21AI030	7	21HS71	Management and Entrepreneurship	A+
2182	1DS21AI030	7	21AI72	Generative AI	O
2183	1DS21AI030	7	21AI731	Advanced Data Security and Privacy	B+
2184	1DS21AI030	7	21AI744	Applied AI	A+
2185	1DS21AI030	7	21AE751	AI in Practice	O
2186	1DS21AI030	7	21AIP76	Project Work	O
2187	1DS21AI031	7	21HS71	Management and Entrepreneurship	A+
2188	1DS21AI031	7	21AI72	Generative AI	A+
2189	1DS21AI031	7	21AI731	Advanced Data Security and Privacy	A+
2190	1DS21AI031	7	21AI744	Applied AI	A+
2191	1DS21AI031	7	21AE751	AI in Practice	O
2192	1DS21AI031	7	21AIP76	Project Work	O
2193	1DS21AI032	7	21HS71	Management and Entrepreneurship	A
2194	1DS21AI032	7	21AI72	Generative AI	A+
2195	1DS21AI032	7	21AI731	Advanced Data Security and Privacy	A
2196	1DS21AI032	7	21AI744	Applied AI	A
2197	1DS21AI032	7	21AE751	AI in Practice	B+
2198	1DS21AI032	7	21AIP76	Project Work	O
2199	1DS21AI033	7	21HS71	Management and Entrepreneurship	A
2200	1DS21AI033	7	21AI72	Generative AI	A
2201	1DS21AI033	7	21AI731	Advanced Data Security and Privacy	B+
2202	1DS21AI033	7	21AI744	Applied AI	A
2203	1DS21AI033	7	21AE751	AI in Practice	B+
2204	1DS21AI033	7	21AIP76	Project Work	A+
2205	1DS21AI034	7	21HS71	Management and Entrepreneurship	A+
2206	1DS21AI034	7	21AI72	Generative AI	O
2207	1DS21AI034	7	21AI731	Advanced Data Security and Privacy	A+
2208	1DS21AI034	7	21AI744	Applied AI	O
2209	1DS21AI034	7	21AE751	AI in Practice	O
2210	1DS21AI034	7	21AIP76	Project Work	O
2211	1DS21AI035	7	21HS71	Management and Entrepreneurship	A
2212	1DS21AI035	7	21AI72	Generative AI	A+
2213	1DS21AI035	7	21AI731	Advanced Data Security and Privacy	A
2214	1DS21AI035	7	21AI744	Applied AI	A+
2215	1DS21AI035	7	21AE751	AI in Practice	B+
2216	1DS21AI035	7	21AIP76	Project Work	O
2217	1DS21AI036	7	21HS71	Management and Entrepreneurship	O
2218	1DS21AI036	7	21AI72	Generative AI	O
2219	1DS21AI036	7	21AI731	Advanced Data Security and Privacy	A+
2220	1DS21AI036	7	21AI744	Applied AI	O
2221	1DS21AI036	7	21AE751	AI in Practice	O
2222	1DS21AI036	7	21AIP76	Project Work	O
2223	1DS21AI037	7	21HS71	Management and Entrepreneurship	A+
2224	1DS21AI037	7	21AI72	Generative AI	A+
2225	1DS21AI037	7	21AI731	Advanced Data Security and Privacy	A+
2226	1DS21AI037	7	21AI744	Applied AI	A+
2227	1DS21AI037	7	21AE751	AI in Practice	A+
2228	1DS21AI037	7	21AIP76	Project Work	O
2229	1DS21AI038	7	21HS71	Management and Entrepreneurship	A+
2230	1DS21AI038	7	21AI72	Generative AI	A+
2231	1DS21AI038	7	21AI731	Advanced Data Security and Privacy	A
2232	1DS21AI038	7	21AI744	Applied AI	A+
2233	1DS21AI038	7	21AE751	AI in Practice	B+
2234	1DS21AI038	7	21AIP76	Project Work	A+
2235	1DS21AI039	7	21HS71	Management and Entrepreneurship	A+
2236	1DS21AI039	7	21AI72	Generative AI	A+
2237	1DS21AI039	7	21AI731	Advanced Data Security and Privacy	A
2238	1DS21AI039	7	21AI744	Applied AI	A+
2239	1DS21AI039	7	21AE751	AI in Practice	C
2240	1DS21AI039	7	21AIP76	Project Work	O
2241	1DS21AI040	7	21HS71	Management and Entrepreneurship	A+
2242	1DS21AI040	7	21AI72	Generative AI	A+
2243	1DS21AI040	7	21AI731	Advanced Data Security and Privacy	A+
2244	1DS21AI040	7	21AI744	Applied AI	A+
2245	1DS21AI040	7	21AE751	AI in Practice	A
2246	1DS21AI040	7	21AIP76	Project Work	O
2247	1DS21AI041	7	21HS71	Management and Entrepreneurship	O
2248	1DS21AI041	7	21AI72	Generative AI	O
2249	1DS21AI041	7	21AI731	Advanced Data Security and Privacy	A+
2250	1DS21AI041	7	21AI744	Applied AI	A+
2251	1DS21AI041	7	21AE751	AI in Practice	A
2252	1DS21AI041	7	21AIP76	Project Work	O
2253	1DS21AI042	7	21HS71	Management and Entrepreneurship	O
2254	1DS21AI042	7	21AI72	Generative AI	O
2255	1DS21AI042	7	21AI731	Advanced Data Security and Privacy	A+
2256	1DS21AI042	7	21AI744	Applied AI	O
2257	1DS21AI042	7	21AE751	AI in Practice	O
2258	1DS21AI042	7	21AIP76	Project Work	O
2259	1DS21AI043	7	21HS71	Management and Entrepreneurship	A+
2260	1DS21AI043	7	21AI72	Generative AI	O
2261	1DS21AI043	7	21AI731	Advanced Data Security and Privacy	A+
2262	1DS21AI043	7	21AI744	Applied AI	A+
2263	1DS21AI043	7	21AE751	AI in Practice	B+
2264	1DS21AI043	7	21AIP76	Project Work	O
2265	1DS21AI044	7	21HS71	Management and Entrepreneurship	A+
2266	1DS21AI044	7	21AI72	Generative AI	A+
2267	1DS21AI044	7	21AI731	Advanced Data Security and Privacy	A
2268	1DS21AI044	7	21AI744	Applied AI	A+
2269	1DS21AI044	7	21AE751	AI in Practice	A+
2270	1DS21AI044	7	21AIP76	Project Work	O
2271	1DS21AI045	7	21HS71	Management and Entrepreneurship	A+
2272	1DS21AI045	7	21AI72	Generative AI	A+
2273	1DS21AI045	7	21AI731	Advanced Data Security and Privacy	A
2274	1DS21AI045	7	21AI744	Applied AI	A
2275	1DS21AI045	7	21AE751	AI in Practice	O
2276	1DS21AI045	7	21AIP76	Project Work	O
2277	1DS21AI046	7	21HS71	Management and Entrepreneurship	A
2278	1DS21AI046	7	21AI72	Generative AI	A+
2279	1DS21AI046	7	21AI731	Advanced Data Security and Privacy	A
2280	1DS21AI046	7	21AI744	Applied AI	A+
2281	1DS21AI046	7	21AE751	AI in Practice	A
2282	1DS21AI046	7	21AIP76	Project Work	O
2283	1DS21AI047	7	21HS71	Management and Entrepreneurship	A+
2284	1DS21AI047	7	21AI72	Generative AI	O
2285	1DS21AI047	7	21AI731	Advanced Data Security and Privacy	A+
2286	1DS21AI047	7	21AI744	Applied AI	O
2287	1DS21AI047	7	21AE751	AI in Practice	O
2288	1DS21AI047	7	21AIP76	Project Work	O
2289	1DS21AI048	7	21HS71	Management and Entrepreneurship	A+
2290	1DS21AI048	7	21AI72	Generative AI	A+
2291	1DS21AI048	7	21AI731	Advanced Data Security and Privacy	A+
2292	1DS21AI048	7	21AI744	Applied AI	A
2293	1DS21AI048	7	21AE751	AI in Practice	O
2294	1DS21AI048	7	21AIP76	Project Work	O
2295	1DS21AI049	7	21HS71	Management and Entrepreneurship	A
2296	1DS21AI049	7	21AI72	Generative AI	A+
2297	1DS21AI049	7	21AI731	Advanced Data Security and Privacy	A
2298	1DS21AI049	7	21AI744	Applied AI	A+
2299	1DS21AI049	7	21AE751	AI in Practice	A
2300	1DS21AI049	7	21AIP76	Project Work	O
2301	1DS21AI050	7	21HS71	Management and Entrepreneurship	A+
2302	1DS21AI050	7	21AI72	Generative AI	O
2303	1DS21AI050	7	21AI731	Advanced Data Security and Privacy	A+
2304	1DS21AI050	7	21AI744	Applied AI	A+
2305	1DS21AI050	7	21AE751	AI in Practice	A+
2306	1DS21AI050	7	21AIP76	Project Work	O
2307	1DS21AI051	7	21HS71	Management and Entrepreneurship	A
2308	1DS21AI051	7	21AI72	Generative AI	A
2309	1DS21AI051	7	21AI731	Advanced Data Security and Privacy	B+
2310	1DS21AI051	7	21AI744	Applied AI	B
2311	1DS21AI051	7	21AE751	AI in Practice	B+
2312	1DS21AI051	7	21AIP76	Project Work	A+
2313	1DS21AI052	7	21HS71	Management and Entrepreneurship	A+
2314	1DS21AI052	7	21AI72	Generative AI	A+
2315	1DS21AI052	7	21AI731	Advanced Data Security and Privacy	A
2316	1DS21AI052	7	21AI744	Applied AI	O
2317	1DS21AI052	7	21AE751	AI in Practice	A+
2318	1DS21AI052	7	21AIP76	Project Work	O
2319	1DS21AI053	7	21HS71	Management and Entrepreneurship	A
2320	1DS21AI053	7	21AI72	Generative AI	A
2321	1DS21AI053	7	21AI731	Advanced Data Security and Privacy	A
2322	1DS21AI053	7	21AI744	Applied AI	A
2323	1DS21AI053	7	21AE751	AI in Practice	B+
2324	1DS21AI053	7	21AIP76	Project Work	O
2325	1DS21AI054	7	21HS71	Management and Entrepreneurship	O
2326	1DS21AI054	7	21AI72	Generative AI	O
2327	1DS21AI054	7	21AI731	Advanced Data Security and Privacy	A+
2328	1DS21AI054	7	21AI744	Applied AI	O
2329	1DS21AI054	7	21AE751	AI in Practice	A+
2330	1DS21AI054	7	21AIP76	Project Work	O
2331	1DS21AI055	7	21HS71	Management and Entrepreneurship	O
2332	1DS21AI055	7	21AI72	Generative AI	O
2333	1DS21AI055	7	21AI731	Advanced Data Security and Privacy	O
2334	1DS21AI055	7	21AI744	Applied AI	O
2335	1DS21AI055	7	21AE751	AI in Practice	O
2336	1DS21AI055	7	21AIP76	Project Work	O
2337	1DS21AI056	7	21HS71	Management and Entrepreneurship	A
2338	1DS21AI056	7	21AI72	Generative AI	A
2339	1DS21AI056	7	21AI731	Advanced Data Security and Privacy	A
2340	1DS21AI056	7	21AI744	Applied AI	B+
2341	1DS21AI056	7	21AE751	AI in Practice	B+
2342	1DS21AI056	7	21AIP76	Project Work	A+
2343	1DS21AI057	7	21HS71	Management and Entrepreneurship	A+
2344	1DS21AI057	7	21AI72	Generative AI	A+
2345	1DS21AI057	7	21AI731	Advanced Data Security and Privacy	A+
2346	1DS21AI057	7	21AI744	Applied AI	A+
2347	1DS21AI057	7	21AE751	AI in Practice	O
2348	1DS21AI057	7	21AIP76	Project Work	O
2349	1DS21AI058	7	21HS71	Management and Entrepreneurship	O
2350	1DS21AI058	7	21AI72	Generative AI	O
2351	1DS21AI058	7	21AI731	Advanced Data Security and Privacy	A+
2352	1DS21AI058	7	21AI744	Applied AI	O
2353	1DS21AI058	7	21AE751	AI in Practice	O
2354	1DS21AI058	7	21AIP76	Project Work	O
2355	1DS21AI059	7	21HS71	Management and Entrepreneurship	B+
2356	1DS21AI059	7	21AI72	Generative AI	B+
2357	1DS21AI059	7	21AI731	Advanced Data Security and Privacy	B+
2358	1DS21AI059	7	21AI744	Applied AI	B
2359	1DS21AI059	7	21AE751	AI in Practice	C
2360	1DS21AI059	7	21AIP76	Project Work	O
2361	1DS21AI001	8	21AI81	Technical Seminar	O
2362	1DS21AI001	8	21INT82	Research Internship / Industry Internship	O
2363	1DS21AI001	8	21PE83	Physical Education	P
2364	1DS21AI001	8	21ATP1	Activity Points	P
2365	1DS21AI002	8	21AI81	Technical Seminar	A+
2366	1DS21AI002	8	21INT82	Research Internship / Industry Internship	O
2367	1DS21AI002	8	21PE83	Physical Education	P
2368	1DS21AI002	8	21ATP1	Activity Points	P
2369	1DS21AI003	8	21AI81	Technical Seminar	A
2370	1DS21AI003	8	21INT82	Research Internship / Industry Internship	O
2371	1DS21AI003	8	21PE83	Physical Education	P
2372	1DS21AI003	8	21ATP1	Activity Points	P
2373	1DS21AI004	8	21AI81	Technical Seminar	C
2374	1DS21AI004	8	21INT82	Research Internship / Industry Internship	B
2375	1DS21AI004	8	21PE83	Physical Education	P
2376	1DS21AI004	8	21ATP1	Activity Points	P
2377	1DS21AI005	8	21AI81	Technical Seminar	O
2378	1DS21AI005	8	21INT82	Research Internship / Industry Internship	O
2379	1DS21AI005	8	21PE83	Physical Education	P
2380	1DS21AI005	8	21ATP1	Activity Points	P
2381	1DS21AI006	8	21AI81	Technical Seminar	A
2382	1DS21AI006	8	21INT82	Research Internship / Industry Internship	B
2383	1DS21AI006	8	21PE83	Physical Education	P
2384	1DS21AI006	8	21ATP1	Activity Points	P
2385	1DS21AI007	8	21AI81	Technical Seminar	A
2386	1DS21AI007	8	21INT82	Research Internship / Industry Internship	O
2387	1DS21AI007	8	21PE83	Physical Education	P
2388	1DS21AI007	8	21ATP1	Activity Points	P
2389	1DS21AI008	8	21AI81	Technical Seminar	A+
2390	1DS21AI008	8	21INT82	Research Internship / Industry Internship	O
2391	1DS21AI008	8	21PE83	Physical Education	P
2392	1DS21AI008	8	21ATP1	Activity Points	P
2393	1DS21AI009	8	21AI81	Technical Seminar	A+
2394	1DS21AI009	8	21INT82	Research Internship / Industry Internship	O
2395	1DS21AI009	8	21PE83	Physical Education	P
2396	1DS21AI009	8	21ATP1	Activity Points	P
2397	1DS21AI010	8	21AI81	Technical Seminar	A+
2398	1DS21AI010	8	21INT82	Research Internship / Industry Internship	A+
2399	1DS21AI010	8	21PE83	Physical Education	P
2400	1DS21AI010	8	21ATP1	Activity Points	P
2401	1DS21AI011	8	21AI81	Technical Seminar	A+
2402	1DS21AI011	8	21INT82	Research Internship / Industry Internship	O
2403	1DS21AI011	8	21PE83	Physical Education	P
2404	1DS21AI011	8	21ATP1	Activity Points	P
2405	1DS21AI012	8	21AI81	Technical Seminar	O
2406	1DS21AI012	8	21INT82	Research Internship / Industry Internship	O
2407	1DS21AI012	8	21PE83	Physical Education	P
2408	1DS21AI012	8	21ATP1	Activity Points	P
2409	1DS21AI013	8	21AI81	Technical Seminar	C
2410	1DS21AI013	8	21INT82	Research Internship / Industry Internship	C
2411	1DS21AI013	8	21PE83	Physical Education	P
2412	1DS21AI013	8	21ATP1	Activity Points	P
2413	1DS21AI014	8	21AI81	Technical Seminar	B+
2414	1DS21AI014	8	21INT82	Research Internship / Industry Internship	A
2415	1DS21AI014	8	21PE83	Physical Education	P
2416	1DS21AI014	8	21ATP1	Activity Points	P
2417	1DS21AI015	8	21AI81	Technical Seminar	B+
2418	1DS21AI015	8	21INT82	Research Internship / Industry Internship	B+
2419	1DS21AI015	8	21PE83	Physical Education	P
2420	1DS21AI015	8	21ATP1	Activity Points	P
2421	1DS21AI016	8	21AI81	Technical Seminar	A+
2422	1DS21AI016	8	21INT82	Research Internship / Industry Internship	A+
2423	1DS21AI016	8	21PE83	Physical Education	P
2424	1DS21AI016	8	21ATP1	Activity Points	P
2425	1DS21AI017	8	21AI81	Technical Seminar	O
2426	1DS21AI017	8	21INT82	Research Internship / Industry Internship	A+
2427	1DS21AI017	8	21PE83	Physical Education	P
2428	1DS21AI017	8	21ATP1	Activity Points	P
2429	1DS21AI018	8	21AI81	Technical Seminar	O
2430	1DS21AI018	8	21INT82	Research Internship / Industry Internship	O
2431	1DS21AI018	8	21PE83	Physical Education	P
2432	1DS21AI018	8	21ATP1	Activity Points	P
2433	1DS21AI019	8	21AI81	Technical Seminar	B
2434	1DS21AI019	8	21INT82	Research Internship / Industry Internship	B+
2435	1DS21AI019	8	21PE83	Physical Education	P
2436	1DS21AI019	8	21ATP1	Activity Points	P
2437	1DS21AI020	8	21AI81	Technical Seminar	A
2438	1DS21AI020	8	21INT82	Research Internship / Industry Internship	A+
2439	1DS21AI020	8	21PE83	Physical Education	P
2440	1DS21AI020	8	21ATP1	Activity Points	P
2441	1DS21AI021	8	21AI81	Technical Seminar	A+
2442	1DS21AI021	8	21INT82	Research Internship / Industry Internship	A+
2443	1DS21AI021	8	21PE83	Physical Education	P
2444	1DS21AI021	8	21ATP1	Activity Points	P
2445	1DS21AI022	8	21AI81	Technical Seminar	A
2446	1DS21AI022	8	21INT82	Research Internship / Industry Internship	O
2447	1DS21AI022	8	21PE83	Physical Education	P
2448	1DS21AI022	8	21ATP1	Activity Points	P
2449	1DS21AI023	8	21AI81	Technical Seminar	O
2450	1DS21AI023	8	21INT82	Research Internship / Industry Internship	O
2451	1DS21AI023	8	21PE83	Physical Education	P
2452	1DS21AI023	8	21ATP1	Activity Points	P
2453	1DS21AI024	8	21AI81	Technical Seminar	A
2454	1DS21AI024	8	21INT82	Research Internship / Industry Internship	A+
2455	1DS21AI024	8	21PE83	Physical Education	P
2456	1DS21AI024	8	21ATP1	Activity Points	P
2457	1DS21AI025	8	21AI81	Technical Seminar	A+
2458	1DS21AI025	8	21INT82	Research Internship / Industry Internship	O
2459	1DS21AI025	8	21PE83	Physical Education	P
2460	1DS21AI025	8	21ATP1	Activity Points	P
2461	1DS21AI026	8	21AI81	Technical Seminar	O
2462	1DS21AI026	8	21INT82	Research Internship / Industry Internship	O
2463	1DS21AI026	8	21PE83	Physical Education	P
2464	1DS21AI026	8	21ATP1	Activity Points	P
2465	1DS21AI027	8	21AI81	Technical Seminar	A
2466	1DS21AI027	8	21INT82	Research Internship / Industry Internship	A
2467	1DS21AI027	8	21PE83	Physical Education	P
2468	1DS21AI027	8	21ATP1	Activity Points	P
2469	1DS21AI028	8	21AI81	Technical Seminar	O
2470	1DS21AI028	8	21INT82	Research Internship / Industry Internship	A+
2471	1DS21AI028	8	21PE83	Physical Education	P
2472	1DS21AI028	8	21ATP1	Activity Points	P
2473	1DS21AI029	8	21AI81	Technical Seminar	B
2474	1DS21AI029	8	21INT82	Research Internship / Industry Internship	B
2475	1DS21AI029	8	21PE83	Physical Education	P
2476	1DS21AI029	8	21ATP1	Activity Points	P
2477	1DS21AI030	8	21AI81	Technical Seminar	A
2478	1DS21AI030	8	21INT82	Research Internship / Industry Internship	O
2479	1DS21AI030	8	21PE83	Physical Education	P
2480	1DS21AI030	8	21ATP1	Activity Points	P
2481	1DS21AI031	8	21AI81	Technical Seminar	A+
2482	1DS21AI031	8	21INT82	Research Internship / Industry Internship	O
2483	1DS21AI031	8	21PE83	Physical Education	P
2484	1DS21AI031	8	21ATP1	Activity Points	P
2485	1DS21AI032	8	21AI81	Technical Seminar	A+
2486	1DS21AI032	8	21INT82	Research Internship / Industry Internship	A+
2487	1DS21AI032	8	21PE83	Physical Education	P
2488	1DS21AI032	8	21ATP1	Activity Points	P
2489	1DS21AI033	8	21AI81	Technical Seminar	A
2490	1DS21AI033	8	21INT82	Research Internship / Industry Internship	A
2491	1DS21AI033	8	21PE83	Physical Education	P
2492	1DS21AI033	8	21ATP1	Activity Points	P
2493	1DS21AI034	8	21AI81	Technical Seminar	O
2494	1DS21AI034	8	21INT82	Research Internship / Industry Internship	A+
2495	1DS21AI034	8	21PE83	Physical Education	P
2496	1DS21AI034	8	21ATP1	Activity Points	P
2497	1DS21AI035	8	21AI81	Technical Seminar	B+
2498	1DS21AI035	8	21INT82	Research Internship / Industry Internship	A+
2499	1DS21AI035	8	21PE83	Physical Education	P
2500	1DS21AI035	8	21ATP1	Activity Points	P
2501	1DS21AI036	8	21AI81	Technical Seminar	O
2502	1DS21AI036	8	21INT82	Research Internship / Industry Internship	O
2503	1DS21AI036	8	21PE83	Physical Education	P
2504	1DS21AI036	8	21ATP1	Activity Points	P
2505	1DS21AI037	8	21AI81	Technical Seminar	O
2506	1DS21AI037	8	21INT82	Research Internship / Industry Internship	O
2507	1DS21AI037	8	21PE83	Physical Education	P
2508	1DS21AI037	8	21ATP1	Activity Points	P
2509	1DS21AI038	8	21AI81	Technical Seminar	B
2510	1DS21AI038	8	21INT82	Research Internship / Industry Internship	A+
2511	1DS21AI038	8	21PE83	Physical Education	P
2512	1DS21AI038	8	21ATP1	Activity Points	P
2513	1DS21AI039	8	21AI81	Technical Seminar	O
2514	1DS21AI039	8	21INT82	Research Internship / Industry Internship	O
2515	1DS21AI039	8	21PE83	Physical Education	P
2516	1DS21AI039	8	21ATP1	Activity Points	P
2517	1DS21AI040	8	21AI81	Technical Seminar	O
2518	1DS21AI040	8	21INT82	Research Internship / Industry Internship	O
2519	1DS21AI040	8	21PE83	Physical Education	P
2520	1DS21AI040	8	21ATP1	Activity Points	P
2521	1DS21AI041	8	21AI81	Technical Seminar	O
2522	1DS21AI041	8	21INT82	Research Internship / Industry Internship	F
2523	1DS21AI041	8	21PE83	Physical Education	P
2524	1DS21AI041	8	21ATP1	Activity Points	P
2525	1DS21AI042	8	21AI81	Technical Seminar	O
2526	1DS21AI042	8	21INT82	Research Internship / Industry Internship	A+
2527	1DS21AI042	8	21PE83	Physical Education	P
2528	1DS21AI042	8	21ATP1	Activity Points	P
2529	1DS21AI043	8	21AI81	Technical Seminar	O
2530	1DS21AI043	8	21INT82	Research Internship / Industry Internship	O
2531	1DS21AI043	8	21PE83	Physical Education	P
2532	1DS21AI043	8	21ATP1	Activity Points	P
2533	1DS21AI044	8	21AI81	Technical Seminar	A+
2534	1DS21AI044	8	21INT82	Research Internship / Industry Internship	A+
2535	1DS21AI044	8	21PE83	Physical Education	P
2536	1DS21AI044	8	21ATP1	Activity Points	P
2537	1DS21AI045	8	21AI81	Technical Seminar	A+
2538	1DS21AI045	8	21INT82	Research Internship / Industry Internship	O
2539	1DS21AI045	8	21PE83	Physical Education	P
2540	1DS21AI045	8	21ATP1	Activity Points	P
2541	1DS21AI046	8	21AI81	Technical Seminar	O
2542	1DS21AI046	8	21INT82	Research Internship / Industry Internship	O
2543	1DS21AI046	8	21PE83	Physical Education	P
2544	1DS21AI046	8	21ATP1	Activity Points	P
2545	1DS21AI047	8	21AI81	Technical Seminar	A+
2546	1DS21AI047	8	21INT82	Research Internship / Industry Internship	O
2547	1DS21AI047	8	21PE83	Physical Education	P
2548	1DS21AI047	8	21ATP1	Activity Points	P
2549	1DS21AI048	8	21AI81	Technical Seminar	A+
2550	1DS21AI048	8	21INT82	Research Internship / Industry Internship	O
2551	1DS21AI048	8	21PE83	Physical Education	P
2552	1DS21AI048	8	21ATP1	Activity Points	P
2553	1DS21AI049	8	21AI81	Technical Seminar	A+
2554	1DS21AI049	8	21INT82	Research Internship / Industry Internship	O
2555	1DS21AI049	8	21PE83	Physical Education	P
2556	1DS21AI049	8	21ATP1	Activity Points	P
2557	1DS21AI050	8	21AI81	Technical Seminar	O
2558	1DS21AI050	8	21INT82	Research Internship / Industry Internship	A+
2559	1DS21AI050	8	21PE83	Physical Education	P
2560	1DS21AI050	8	21ATP1	Activity Points	P
2561	1DS21AI051	8	21AI81	Technical Seminar	A+
2562	1DS21AI051	8	21INT82	Research Internship / Industry Internship	A+
2563	1DS21AI051	8	21PE83	Physical Education	P
2564	1DS21AI051	8	21ATP1	Activity Points	P
2565	1DS21AI052	8	21AI81	Technical Seminar	O
2566	1DS21AI052	8	21INT82	Research Internship / Industry Internship	O
2567	1DS21AI052	8	21PE83	Physical Education	P
2568	1DS21AI052	8	21ATP1	Activity Points	P
2569	1DS21AI053	8	21AI81	Technical Seminar	A
2570	1DS21AI053	8	21INT82	Research Internship / Industry Internship	O
2571	1DS21AI053	8	21PE83	Physical Education	P
2572	1DS21AI053	8	21ATP1	Activity Points	P
2573	1DS21AI054	8	21AI81	Technical Seminar	A+
2574	1DS21AI054	8	21INT82	Research Internship / Industry Internship	A+
2575	1DS21AI054	8	21PE83	Physical Education	P
2576	1DS21AI054	8	21ATP1	Activity Points	P
2577	1DS21AI055	8	21AI81	Technical Seminar	O
2578	1DS21AI055	8	21INT82	Research Internship / Industry Internship	O
2579	1DS21AI055	8	21PE83	Physical Education	P
2580	1DS21AI055	8	21ATP1	Activity Points	P
2581	1DS21AI056	8	21AI81	Technical Seminar	A
2582	1DS21AI056	8	21INT82	Research Internship / Industry Internship	A+
2583	1DS21AI056	8	21PE83	Physical Education	P
2584	1DS21AI056	8	21ATP1	Activity Points	P
2585	1DS21AI057	8	21AI81	Technical Seminar	O
2586	1DS21AI057	8	21INT82	Research Internship / Industry Internship	O
2587	1DS21AI057	8	21PE83	Physical Education	P
2588	1DS21AI057	8	21ATP1	Activity Points	P
2589	1DS21AI058	8	21AI81	Technical Seminar	A
2590	1DS21AI058	8	21INT82	Research Internship / Industry Internship	A+
2591	1DS21AI058	8	21PE83	Physical Education	P
2592	1DS21AI058	8	21ATP1	Activity Points	P
2593	1DS21AI059	8	21AI81	Technical Seminar	A
2594	1DS21AI059	8	21INT82	Research Internship / Industry Internship	A+
2595	1DS21AI059	8	21PE83	Physical Education	P
2596	1DS21AI059	8	21ATP1	Activity Points	P
\.


--
-- Name: semester_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semester_results_id_seq', 354, true);


--
-- Name: student_results_sl_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_results_sl_no_seq', 1, false);


--
-- Name: subject_grades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subject_grades_id_seq', 2596, true);


--
-- Name: semester_results semester_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester_results
    ADD CONSTRAINT semester_results_pkey PRIMARY KEY (id);


--
-- Name: semester_results semester_results_usn_semester_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester_results
    ADD CONSTRAINT semester_results_usn_semester_key UNIQUE (usn, semester);


--
-- Name: student_results student_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_results
    ADD CONSTRAINT student_results_pkey PRIMARY KEY (sl_no);


--
-- Name: student_results student_results_usn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_results
    ADD CONSTRAINT student_results_usn_key UNIQUE (usn);


--
-- Name: subject_grades subject_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_grades
    ADD CONSTRAINT subject_grades_pkey PRIMARY KEY (id);


--
-- Name: subject_grades subject_grades_usn_subject_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_grades
    ADD CONSTRAINT subject_grades_usn_subject_code_key UNIQUE (usn, subject_code);


--
-- PostgreSQL database dump complete
--

\unrestrict bNSe1BzZSPshVpwUOpDJoatxy2nsONFEFhm4oVlPAfGIiWh6RUlenMfTNb04Bir

