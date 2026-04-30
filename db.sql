--
-- PostgreSQL database dump
--

\restrict yvAVmDfNNxnuWTLRSlCEo5FFfCuAgdWsF5VvgWwVeh3M8Nmm3vKvztrLWFR87lV

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: daftar_pekerjaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daftar_pekerjaan (
    id integer NOT NULL,
    staf_nip character varying,
    semester_id integer,
    judul character varying,
    deskripsi text,
    tipe_pekerjaan_id integer,
    poin_jam double precision,
    kuota integer,
    ruangan_id integer,
    is_aktif boolean DEFAULT true,
    tanggal_mulai date,
    tanggal_selesai date,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.daftar_pekerjaan OWNER TO postgres;

--
-- Name: daftar_pekerjaan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.daftar_pekerjaan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.daftar_pekerjaan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ekuivalensi_kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ekuivalensi_kelas (
    id integer NOT NULL,
    kelas_id integer,
    semester_id integer,
    penanggung_jawab_nim character varying,
    nota_url text,
    nominal_total numeric,
    jam_diakui double precision,
    status_ekuivalensi_id integer,
    verified_by_nip character varying,
    catatan text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ekuivalensi_kelas OWNER TO postgres;

--
-- Name: ekuivalensi_kelas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ekuivalensi_kelas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ekuivalensi_kelas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gedung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gedung (
    id integer NOT NULL,
    jurusan_id integer,
    nama_gedung character varying
);


ALTER TABLE public.gedung OWNER TO postgres;

--
-- Name: gedung_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.gedung ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.gedung_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: import_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.import_log (
    id integer NOT NULL,
    staf_nip character varying,
    semester_id integer,
    nama_file character varying,
    total_baris integer,
    sukses_baris integer,
    error_details jsonb,
    status_import_id integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.import_log OWNER TO postgres;

--
-- Name: import_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.import_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.import_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: jurusan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jurusan (
    id integer NOT NULL,
    nama_jurusan character varying
);


ALTER TABLE public.jurusan OWNER TO postgres;

--
-- Name: jurusan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.jurusan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.jurusan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kelas (
    id integer NOT NULL,
    prodi_id integer,
    nama_kelas character varying
);


ALTER TABLE public.kelas OWNER TO postgres;

--
-- Name: kelas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.kelas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kelas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kompen_awal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kompen_awal (
    id integer NOT NULL,
    nim character varying,
    semester_id integer,
    import_id integer,
    total_jam_wajib double precision,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.kompen_awal OWNER TO postgres;

--
-- Name: kompen_awal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.kompen_awal ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.kompen_awal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: log_potong_jam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_potong_jam (
    id integer NOT NULL,
    nim character varying,
    semester_id integer,
    penugasan_id integer,
    ekuivalensi_id integer,
    jam_dikurangi double precision,
    keterangan text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone
);


ALTER TABLE public.log_potong_jam OWNER TO postgres;

--
-- Name: log_potong_jam_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.log_potong_jam ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.log_potong_jam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: mahasiswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mahasiswa (
    nim character varying NOT NULL,
    user_id integer,
    nama character varying,
    kelas_id integer
);


ALTER TABLE public.mahasiswa OWNER TO postgres;

--
-- Name: menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menus (
    id integer NOT NULL,
    key character varying NOT NULL,
    label character varying NOT NULL,
    icon character varying,
    path character varying NOT NULL,
    urutan integer DEFAULT 0,
    parent_id integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.menus OWNER TO postgres;

--
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.menus ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pengaturan_sistem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pengaturan_sistem (
    id integer NOT NULL,
    grup character varying,
    key character varying,
    value character varying,
    tipe_data character varying,
    keterangan text
);


ALTER TABLE public.pengaturan_sistem OWNER TO postgres;

--
-- Name: pengaturan_sistem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pengaturan_sistem ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pengaturan_sistem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: penugasan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.penugasan (
    id integer NOT NULL,
    pekerjaan_id integer,
    nim character varying,
    status_tugas_id integer,
    detail_pengerjaan jsonb,
    catatan_verifikasi text,
    diverifikasi_oleh_nip character varying,
    waktu_verifikasi timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone
);


ALTER TABLE public.penugasan OWNER TO postgres;

--
-- Name: penugasan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.penugasan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.penugasan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: prodi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prodi (
    id integer NOT NULL,
    jurusan_id integer,
    nama_prodi character varying
);


ALTER TABLE public.prodi OWNER TO postgres;

--
-- Name: prodi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.prodi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.prodi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ref_status_ekuivalensi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_ekuivalensi (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_ekuivalensi OWNER TO postgres;

--
-- Name: ref_status_import; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_import (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_import OWNER TO postgres;

--
-- Name: ref_status_tugas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_tugas (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_tugas OWNER TO postgres;

--
-- Name: ref_tipe_pekerjaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_tipe_pekerjaan (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_tipe_pekerjaan OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nama character varying,
    key_menu jsonb,
    key_condition jsonb
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: ruangan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruangan (
    id integer NOT NULL,
    gedung_id integer,
    nama_ruangan character varying,
    kode_ruangan character varying
);


ALTER TABLE public.ruangan OWNER TO postgres;

--
-- Name: ruangan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ruangan ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ruangan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: semester; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semester (
    id integer NOT NULL,
    nama character varying,
    tahun integer,
    periode character varying,
    is_aktif boolean DEFAULT false,
    mulai date,
    selesai date
);


ALTER TABLE public.semester OWNER TO postgres;

--
-- Name: semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.semester ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.semester_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: staf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staf (
    nip character varying NOT NULL,
    user_id integer,
    nama character varying,
    jurusan_id integer,
    tipe_staf character varying
);


ALTER TABLE public.staf OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying,
    kata_sandi character varying,
    role_id integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_mahasiswa_detail; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_mahasiswa_detail AS
 SELECT m.nim,
    m.nama,
    m.user_id,
    k.id AS kelas_id,
    k.nama_kelas,
    p.id AS prodi_id,
    p.nama_prodi,
    j.id AS jurusan_id,
    j.nama_jurusan
   FROM (((public.mahasiswa m
     JOIN public.kelas k ON ((k.id = m.kelas_id)))
     JOIN public.prodi p ON ((p.id = k.prodi_id)))
     JOIN public.jurusan j ON ((j.id = p.jurusan_id)));


ALTER VIEW public.v_mahasiswa_detail OWNER TO postgres;

--
-- Name: v_sisa_kompen; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_sisa_kompen AS
 SELECT k.nim,
    k.semester_id,
    k.total_jam_wajib,
    COALESCE(sum(l.jam_dikurangi), (0)::double precision) AS jam_selesai,
    (k.total_jam_wajib - COALESCE(sum(l.jam_dikurangi), (0)::double precision)) AS sisa_jam
   FROM (public.kompen_awal k
     LEFT JOIN public.log_potong_jam l ON ((((l.nim)::text = (k.nim)::text) AND (l.semester_id = k.semester_id))))
  GROUP BY k.nim, k.semester_id, k.total_jam_wajib;


ALTER VIEW public.v_sisa_kompen OWNER TO postgres;

--
-- Data for Name: daftar_pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daftar_pekerjaan (id, staf_nip, semester_id, judul, deskripsi, tipe_pekerjaan_id, poin_jam, kuota, ruangan_id, is_aktif, tanggal_mulai, tanggal_selesai, created_at) FROM stdin;
1	197501012005011001	1	Pendataan Buku Perpustakaan	Membantu mendata dan menginventarisasi buku-buku di perpustakaan	1	2	5	1	t	2024-09-10	2024-10-10	2026-04-20 16:48:48.570326
2	197501012005011001	1	Pembersihan Lab Komputer	Membersihkan dan merapikan lab komputer setelah praktikum	2	1	10	3	t	2024-09-15	2024-12-15	2026-04-20 16:48:48.570326
3	197502022006021002	1	Pengolahan Data Keuangan	Membantu entry data transaksi keuangan	1	1.5	3	7	t	2024-09-10	2024-10-31	2026-04-20 16:48:48.570326
4	197503032007031003	1	Tutor Mahasiswa Baru	Membimbing mahasiswa baru dalam adaptasi perkuliahan	3	3	8	9	t	2024-09-20	2024-11-20	2026-04-20 16:48:48.570326
5	197501012005011001	1	Survey Kepuasan Mahasiswa	Menyebarkan dan mengumpulkan kuesioner	5	1	15	5	t	2024-10-01	2024-10-30	2026-04-20 16:48:48.570326
6	198001042008041001	1	Asisten Praktikum Algoritma	Membantu dosen dalam praktikum algoritma	3	4	5	9	t	2024-09-10	2024-12-10	2026-04-20 16:48:48.570326
7	198002052009051002	1	Penelitian Dosen	Membantu pengumpulan data penelitian	4	2	3	11	t	2024-09-25	2024-11-25	2026-04-20 16:48:48.570326
8	197503032007031003	1	Maintenance Website Jurusan	Update konten dan perbaikan bug website	1	2.5	2	12	t	2024-09-10	2024-12-31	2026-04-20 16:48:48.570326
9	197501012005011001	1	Pengelolaan Surat Menyurat	Membantu administrasi surat di jurusan	1	1	4	5	t	2024-09-10	2024-12-31	2026-04-20 16:48:48.570326
10	197502022006021002	2	Pendampingan UMKM	Mendampingi UMKM binaan fakultas	5	3	5	7	f	2024-02-15	2024-05-15	2026-04-20 16:48:48.570326
\.


--
-- Data for Name: ekuivalensi_kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ekuivalensi_kelas (id, kelas_id, semester_id, penanggung_jawab_nim, nota_url, nominal_total, jam_diakui, status_ekuivalensi_id, verified_by_nip, catatan, created_at) FROM stdin;
1	1	1	220101001	/nota/ekuivalensi_1.pdf	500000	10	2	197501012005011001	Diterima	2024-09-05 09:00:00
2	3	1	220101003	/nota/ekuivalensi_2.pdf	750000	15	2	197501012005011001	Valid	2024-09-07 10:30:00
3	6	1	220102001	/nota/ekuivalensi_3.pdf	300000	6	1	\N	Menunggu verifikasi	2024-09-10 14:15:00
4	10	1	220104001	/nota/ekuivalensi_4.pdf	1000000	20	3	197502022006021002	Bukti kurang lengkap	2024-09-12 11:00:00
5	13	1	220105001	/nota/ekuivalensi_5.pdf	450000	9	2	197503032007031003	Disetujui	2024-09-15 09:30:00
6	1	2	2372001	/nota/ekuivalensi_6.pdf	20000	10	2	\N	\N	2026-04-28 16:59:35.453043
\.


--
-- Data for Name: gedung; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gedung (id, jurusan_id, nama_gedung) FROM stdin;
1	1	Gedung Teknik A
2	1	Gedung Teknik B
3	2	Gedung Ekonomi
4	3	Gedung Ilkom
5	4	Gedung Hukum
6	1	Laboratorium Pusat
7	3	Gedung Digital Center
\.


--
-- Data for Name: import_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.import_log (id, staf_nip, semester_id, nama_file, total_baris, sukses_baris, error_details, status_import_id, created_at) FROM stdin;
1	197501012005011001	1	import_mahasiswa_ganjil_2024.xlsx	100	98	{"errors": ["Baris 5: NIM duplikat", "Baris 23: Nama kosong"]}	2	2024-08-20 09:30:00
2	197501012005011001	1	import_kompen_awal_ganjil_2024.csv	150	150	\N	2	2024-08-21 10:15:00
3	197502022006021002	1	import_ekuivalensi.xlsx	25	23	{"errors": ["Baris 7: Kelas tidak ditemukan"]}	4	2024-09-01 14:20:00
4	197503032007031003	2	import_mahasiswa_genap_2024.csv	95	90	{"errors": ["Baris 12: NIM tidak valid"]}	4	2024-01-10 11:00:00
5	197501012005011001	3	data_lama_2023.xlsx	200	200	\N	2	2023-08-15 08:45:00
\.


--
-- Data for Name: jurusan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jurusan (id, nama_jurusan) FROM stdin;
1	Fakultas Teknik
2	Fakultas Ekonomi
3	Fakultas Ilmu Komputer
4	Fakultas Hukum
\.


--
-- Data for Name: kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kelas (id, prodi_id, nama_kelas) FROM stdin;
1	1	IF-1A
2	1	IF-1B
3	1	IF-2A
4	1	IF-2B
5	1	IF-3A
6	2	TS-1
7	2	TS-2
8	3	TE-1
9	4	TM-1
10	5	MN-1A
11	5	MN-1B
12	6	AK-1
13	8	IK-1
14	8	IK-2
15	9	SI-1
\.


--
-- Data for Name: kompen_awal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kompen_awal (id, nim, semester_id, import_id, total_jam_wajib, created_at) FROM stdin;
1	220101001	1	2	30	2024-08-21 10:30:00
2	220101002	1	2	30	2024-08-21 10:30:00
3	220101003	1	2	30	2024-08-21 10:30:00
4	220101004	1	2	30	2024-08-21 10:30:00
5	220101005	1	2	30	2024-08-21 10:30:00
6	220102001	1	2	30	2024-08-21 10:30:00
7	220102002	1	2	30	2024-08-21 10:30:00
8	220103001	1	2	30	2024-08-21 10:30:00
9	220104001	1	2	30	2024-08-21 10:30:00
10	220105001	1	2	30	2024-08-21 10:30:00
11	220105002	1	2	30	2024-08-21 10:30:00
12	220105003	1	2	30	2024-08-21 10:30:00
13	210101001	1	2	25	2024-08-21 10:30:00
14	210101002	1	2	25	2024-08-21 10:30:00
15	220106001	1	2	30	2024-08-21 10:30:00
16	220101001	2	4	30	2024-01-11 09:00:00
17	220101002	2	4	30	2024-01-11 09:00:00
18	220101003	2	4	30	2024-01-11 09:00:00
19	220105001	3	5	25	2023-08-16 09:00:00
\.


--
-- Data for Name: log_potong_jam; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_potong_jam (id, nim, semester_id, penugasan_id, ekuivalensi_id, jam_dikurangi, keterangan, created_at, updated_at) FROM stdin;
1	220101001	1	1	\N	2	Pendataan buku perpustakaan	2024-10-15 09:00:00	\N
2	220101001	1	5	\N	1	Survey kepuasan mahasiswa	2024-10-28 10:00:00	\N
3	220101001	1	\N	1	10	Ekuivalensi kegiatan organisasi	2024-09-05 09:00:00	\N
4	220101002	1	2	\N	2	Pendataan buku perpustakaan	2024-10-10 10:00:00	\N
5	220101003	1	3	\N	1	Pembersihan lab komputer	2024-12-10 14:00:00	\N
6	220101003	1	\N	2	15	Ekuivalensi lomba	2024-09-07 10:30:00	\N
7	220101004	1	4	\N	0.6	Pembersihan lab komputer (progress 60%)	2024-12-05 09:00:00	2024-12-05 09:00:00
8	220102001	1	6	\N	1.5	Pengolahan data keuangan	2024-10-20 11:00:00	\N
9	220105001	1	7	\N	3	Tutor mahasiswa baru	2024-11-15 15:30:00	\N
10	220105001	1	10	\N	4	Asisten praktikum algoritma	2024-12-05 13:00:00	\N
11	220105001	1	\N	5	9	Ekuivalensi magang	2024-09-15 09:30:00	\N
12	220105002	1	8	\N	2.4	Tutor mahasiswa baru (80%)	2024-11-10 14:00:00	2024-11-10 14:00:00
13	220101001	2	\N	\N	5	Cuti semester	2024-03-01 08:00:00	\N
\.


--
-- Data for Name: mahasiswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mahasiswa (nim, user_id, nama, kelas_id) FROM stdin;
220101001	7	Andi Pratama	1
220101002	8	Budi Wibowo	1
220101003	9	Citra Dewi	2
220101004	10	Dian Sastro	2
220101005	11	Eko Prasetyo	3
220102001	\N	Fajar Nugroho	6
220102002	\N	Gita Rahayu	6
220103001	\N	Hendra Setiawan	8
220104001	\N	Indah Permata	10
220105001	\N	Joko Susilo	13
220105002	\N	Kartika Sari	14
220105003	\N	Lukman Hakim	15
210101001	\N	Mega Lestari	4
210101002	\N	Nanda Putri	5
220106001	\N	Oscar Simanjuntak	11
2372001	12	Akbar Testing	1
\.


--
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menus (id, key, label, icon, path, urutan, parent_id, created_at) FROM stdin;
1	dashboard	Dashboard	LayoutDashboard	/user/dashboard	1	\N	2026-04-20 16:48:48.500836
2	pekerjaan	List Pekerjaan	Briefcase	/user/pekerjaan	2	\N	2026-04-20 16:48:48.500836
3	ekuivalensi	Ekuivalensi	BookOpen	/user/ekuivalensi	3	\N	2026-04-20 16:48:48.500836
\.


--
-- Data for Name: pengaturan_sistem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pengaturan_sistem (id, grup, key, value, tipe_data, keterangan) FROM stdin;
1	kompen	jam_wajib_per_semester	30	integer	Jumlah jam wajib kompen per semester
2	kompen	maks_penugasan_per_mahasiswa	5	integer	Maksimal penugasan aktif per mahasiswa
3	kompen	poin_per_jam	10000	integer	Nilai poin per jam kompen (dalam rupiah)
4	email	smtp_host	smtp.kampus.ac.id	string	SMTP server untuk email
5	email	smtp_port	587	integer	Port SMTP
6	app	nama_aplikasi	Sistem Kompen	string	Nama aplikasi
7	app	logo_url	/assets/logo.png	string	URL logo aplikasi
\.


--
-- Data for Name: penugasan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.penugasan (id, pekerjaan_id, nim, status_tugas_id, detail_pengerjaan, catatan_verifikasi, diverifikasi_oleh_nip, waktu_verifikasi, created_at, updated_at) FROM stdin;
1	1	220101001	4	{"file": "/tugas/andi_perpus.pdf", "progress": 100}	Selesai dengan baik	197501012005011001	2024-10-15 09:00:00	2024-09-20 08:00:00	2024-10-15 09:00:00
2	1	220101002	3	{"file": "/tugas/budi_perpus.pdf", "progress": 100}	\N	\N	\N	2024-09-21 09:00:00	2024-10-10 10:00:00
3	2	220101003	4	{"laporan": "Bersih semua lab", "progress": 100}	Pekerjaan rapi	197501012005011001	2024-12-10 14:00:00	2024-09-25 10:00:00	2024-12-10 14:00:00
4	2	220101004	2	{"catatan": "Masih proses", "progress": 60}	\N	\N	\N	2024-09-26 11:00:00	2024-12-05 09:00:00
5	2	220101005	1	{"progress": 0}	\N	\N	\N	2024-09-27 08:30:00	\N
6	3	220102001	4	{"file": "/tugas/fajar_keuangan.xlsx", "progress": 100}	Data lengkap	197502022006021002	2024-10-20 11:00:00	2024-09-15 13:00:00	2024-10-20 11:00:00
7	4	220105001	4	{"feedback": "Membantu banget", "progress": 100}	Tutor yang baik	197503032007031003	2024-11-15 15:30:00	2024-09-25 09:00:00	2024-11-15 15:30:00
8	4	220105002	3	{"catatan": "Tinggal 2 sesi lagi", "progress": 80}	\N	\N	\N	2024-09-26 10:00:00	2024-11-10 14:00:00
9	5	220101001	4	{"file": "/tugas/andi_survey.xlsx", "progress": 100}	Data lengkap 100 responden	197501012005011001	2024-10-28 10:00:00	2024-10-05 09:00:00	2024-10-28 10:00:00
10	6	220105001	4	{"nilai": "A", "progress": 100}	Asisten yang baik	198001042008041001	2024-12-05 13:00:00	2024-09-15 14:00:00	2024-12-05 13:00:00
11	6	220105002	2	{"progress": 50}	\N	\N	\N	2024-09-16 09:00:00	2024-11-20 10:00:00
12	7	220103001	1	{"progress": 0}	\N	\N	\N	2024-10-01 10:00:00	\N
\.


--
-- Data for Name: prodi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prodi (id, jurusan_id, nama_prodi) FROM stdin;
1	1	Teknik Informatika
2	1	Teknik Sipil
3	1	Teknik Elektro
4	1	Teknik Mesin
5	2	Manajemen
6	2	Akuntansi
7	2	Ekonomi Pembangunan
8	3	Ilmu Komputer
9	3	Sistem Informasi
10	4	Ilmu Hukum
\.


--
-- Data for Name: ref_status_ekuivalensi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_ekuivalensi (id, nama) FROM stdin;
1	Menunggu Verifikasi
2	Disetujui
3	Ditolak
4	Revisi
\.


--
-- Data for Name: ref_status_import; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_import (id, nama) FROM stdin;
1	Proses
2	Berhasil
3	Gagal
4	Partial
\.


--
-- Data for Name: ref_status_tugas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_tugas (id, nama) FROM stdin;
1	Menunggu
2	Sedang Dikerjakan
3	Selesai
4	Diverifikasi
5	Ditolak
\.


--
-- Data for Name: ref_tipe_pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_tipe_pekerjaan (id, nama) FROM stdin;
1	Administrasi
2	Lapangan
3	Pengajaran
4	Penelitian
5	Pengabdian Masyarakat
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nama, key_menu, key_condition) FROM stdin;
1	Super Admin	["all"]	{"all": true}
2	Staf Jurusan	["daftar_pekerjaan", "penugasan", "verifikasi"]	{"jurusan_only": true}
3	Mahasiswa	["pekerjaan", "riwayat", "profil"]	{"self_only": true}
4	Dosen	["verifikasi", "laporan"]	{"jurusan_only": true}
\.


--
-- Data for Name: ruangan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ruangan (id, gedung_id, nama_ruangan, kode_ruangan) FROM stdin;
1	1	Ruang Kuliah A101	A101
2	1	Ruang Kuliah A102	A102
3	1	Laboratorium Komputer A	LAB-A
4	2	Ruang Kuliah B201	B201
5	2	Ruang Sidang Teknik	RS-TK
6	3	Ruang Kuliah C301	C301
7	3	Laboratorium Ekonomi	LAB-EK
8	4	Ruang Kuliah D401	D401
9	4	Laboratorium Ilkom	LAB-ILKOM
10	5	Ruang Kuliah E501	E501
11	6	Laboratorium Pusat A	LAB-PUSAT
12	7	Digital Lab	DIGILAB
\.


--
-- Data for Name: semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester (id, nama, tahun, periode, is_aktif, mulai, selesai) FROM stdin;
1	Ganjil 2024/2025	2024	Ganjil	t	2024-09-01	2025-01-15
2	Genap 2023/2024	2024	Genap	f	2024-02-01	2024-06-30
3	Ganjil 2023/2024	2023	Ganjil	f	2023-09-01	2024-01-15
4	Pendek 2024	2024	Pendek	f	2024-07-01	2024-08-30
\.


--
-- Data for Name: staf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staf (nip, user_id, nama, jurusan_id, tipe_staf) FROM stdin;
197501012005011001	2	Dr. Ahmad Wijaya, S.T., M.T.	1	staf_jurusan
197502022006021002	3	Dr. Budi Santoso, S.E., M.E.	2	staf_jurusan
197503032007031003	4	Ir. Cipto Junaedy, M.Kom.	3	staf_jurusan
198001042008041001	5	Prof. Dedi Mulyadi, S.H., M.H.	4	dosen
198002052009051002	6	Dr. Eka Putri, S.Si., M.Si.	1	dosen
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, kata_sandi, role_id, created_at) FROM stdin;
1	admin@kampus.ac.id	$2a$10$encrypted_hash_here	1	2026-04-20 16:48:48.516293
2	staf_teknik@kampus.ac.id	$2a$10$encrypted_hash_here	2	2026-04-20 16:48:48.516293
3	staf_ekonomi@kampus.ac.id	$2a$10$encrypted_hash_here	2	2026-04-20 16:48:48.516293
4	staf_ilkom@kampus.ac.id	$2a$10$encrypted_hash_here	2	2026-04-20 16:48:48.516293
5	dosen_budi@kampus.ac.id	$2a$10$encrypted_hash_here	4	2026-04-20 16:48:48.516293
6	dosen_siti@kampus.ac.id	$2a$10$encrypted_hash_here	4	2026-04-20 16:48:48.516293
7	mahasiswa1@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
8	mahasiswa2@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
9	mahasiswa3@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
10	mahasiswa4@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
11	mahasiswa5@kampus.ac.id	$2a$10$encrypted_hash_here	3	2026-04-20 16:48:48.516293
12	2372001@student.polnes.ac.id	$2b$10$nahxFaFGgEpxGBb2iDZwBeG7a3mbEpFEAXQ.xMaJUj9C2fhZBkh4K	\N	2026-04-27 23:26:57.954988
\.


--
-- Name: daftar_pekerjaan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daftar_pekerjaan_id_seq', 10, true);


--
-- Name: ekuivalensi_kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ekuivalensi_kelas_id_seq', 6, true);


--
-- Name: gedung_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gedung_id_seq', 7, true);


--
-- Name: import_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.import_log_id_seq', 5, true);


--
-- Name: jurusan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jurusan_id_seq', 4, true);


--
-- Name: kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kelas_id_seq', 15, true);


--
-- Name: kompen_awal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kompen_awal_id_seq', 19, true);


--
-- Name: log_potong_jam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_potong_jam_id_seq', 13, true);


--
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menus_id_seq', 10, true);


--
-- Name: pengaturan_sistem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pengaturan_sistem_id_seq', 7, true);


--
-- Name: penugasan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.penugasan_id_seq', 12, true);


--
-- Name: prodi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prodi_id_seq', 10, true);


--
-- Name: ruangan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ruangan_id_seq', 12, true);


--
-- Name: semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semester_id_seq', 4, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 12, true);


--
-- Name: daftar_pekerjaan daftar_pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_pkey PRIMARY KEY (id);


--
-- Name: ekuivalensi_kelas ekuivalensi_kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_pkey PRIMARY KEY (id);


--
-- Name: gedung gedung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedung
    ADD CONSTRAINT gedung_pkey PRIMARY KEY (id);


--
-- Name: import_log import_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_pkey PRIMARY KEY (id);


--
-- Name: jurusan jurusan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jurusan
    ADD CONSTRAINT jurusan_pkey PRIMARY KEY (id);


--
-- Name: kelas kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_pkey PRIMARY KEY (id);


--
-- Name: kompen_awal kompen_awal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_pkey PRIMARY KEY (id);


--
-- Name: log_potong_jam log_potong_jam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_pkey PRIMARY KEY (id);


--
-- Name: mahasiswa mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (nim);


--
-- Name: mahasiswa mahasiswa_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_user_id_key UNIQUE (user_id);


--
-- Name: menus menus_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_key_key UNIQUE (key);


--
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- Name: pengaturan_sistem pengaturan_sistem_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengaturan_sistem
    ADD CONSTRAINT pengaturan_sistem_key_key UNIQUE (key);


--
-- Name: pengaturan_sistem pengaturan_sistem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengaturan_sistem
    ADD CONSTRAINT pengaturan_sistem_pkey PRIMARY KEY (id);


--
-- Name: penugasan penugasan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_pkey PRIMARY KEY (id);


--
-- Name: prodi prodi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodi
    ADD CONSTRAINT prodi_pkey PRIMARY KEY (id);


--
-- Name: ref_status_ekuivalensi ref_status_ekuivalensi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_ekuivalensi
    ADD CONSTRAINT ref_status_ekuivalensi_pkey PRIMARY KEY (id);


--
-- Name: ref_status_import ref_status_import_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_import
    ADD CONSTRAINT ref_status_import_pkey PRIMARY KEY (id);


--
-- Name: ref_status_tugas ref_status_tugas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_tugas
    ADD CONSTRAINT ref_status_tugas_pkey PRIMARY KEY (id);


--
-- Name: ref_tipe_pekerjaan ref_tipe_pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_tipe_pekerjaan
    ADD CONSTRAINT ref_tipe_pekerjaan_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: ruangan ruangan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_pkey PRIMARY KEY (id);


--
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id);


--
-- Name: staf staf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_pkey PRIMARY KEY (nip);


--
-- Name: staf staf_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_user_id_key UNIQUE (user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: daftar_pekerjaan daftar_pekerjaan_ruangan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_ruangan_id_fkey FOREIGN KEY (ruangan_id) REFERENCES public.ruangan(id);


--
-- Name: daftar_pekerjaan daftar_pekerjaan_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- Name: daftar_pekerjaan daftar_pekerjaan_staf_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip);


--
-- Name: daftar_pekerjaan daftar_pekerjaan_tipe_pekerjaan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_tipe_pekerjaan_id_fkey FOREIGN KEY (tipe_pekerjaan_id) REFERENCES public.ref_tipe_pekerjaan(id);


--
-- Name: ekuivalensi_kelas ekuivalensi_kelas_kelas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id);


--
-- Name: ekuivalensi_kelas ekuivalensi_kelas_penanggung_jawab_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_penanggung_jawab_nim_fkey FOREIGN KEY (penanggung_jawab_nim) REFERENCES public.mahasiswa(nim);


--
-- Name: ekuivalensi_kelas ekuivalensi_kelas_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- Name: ekuivalensi_kelas ekuivalensi_kelas_status_ekuivalensi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_status_ekuivalensi_id_fkey FOREIGN KEY (status_ekuivalensi_id) REFERENCES public.ref_status_ekuivalensi(id);


--
-- Name: ekuivalensi_kelas ekuivalensi_kelas_verified_by_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_verified_by_nip_fkey FOREIGN KEY (verified_by_nip) REFERENCES public.staf(nip);


--
-- Name: gedung gedung_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedung
    ADD CONSTRAINT gedung_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- Name: import_log import_log_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- Name: import_log import_log_staf_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip);


--
-- Name: import_log import_log_status_import_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_status_import_id_fkey FOREIGN KEY (status_import_id) REFERENCES public.ref_status_import(id);


--
-- Name: kelas kelas_prodi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_prodi_id_fkey FOREIGN KEY (prodi_id) REFERENCES public.prodi(id);


--
-- Name: kompen_awal kompen_awal_import_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_import_id_fkey FOREIGN KEY (import_id) REFERENCES public.import_log(id);


--
-- Name: kompen_awal kompen_awal_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- Name: kompen_awal kompen_awal_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- Name: log_potong_jam log_potong_jam_ekuivalensi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_ekuivalensi_id_fkey FOREIGN KEY (ekuivalensi_id) REFERENCES public.ekuivalensi_kelas(id);


--
-- Name: log_potong_jam log_potong_jam_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- Name: log_potong_jam log_potong_jam_penugasan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_penugasan_id_fkey FOREIGN KEY (penugasan_id) REFERENCES public.penugasan(id);


--
-- Name: log_potong_jam log_potong_jam_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- Name: mahasiswa mahasiswa_kelas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id);


--
-- Name: mahasiswa mahasiswa_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: menus menus_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menus(id);


--
-- Name: penugasan penugasan_diverifikasi_oleh_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_diverifikasi_oleh_nip_fkey FOREIGN KEY (diverifikasi_oleh_nip) REFERENCES public.staf(nip);


--
-- Name: penugasan penugasan_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- Name: penugasan penugasan_pekerjaan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_pekerjaan_id_fkey FOREIGN KEY (pekerjaan_id) REFERENCES public.daftar_pekerjaan(id);


--
-- Name: penugasan penugasan_status_tugas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_status_tugas_id_fkey FOREIGN KEY (status_tugas_id) REFERENCES public.ref_status_tugas(id);


--
-- Name: prodi prodi_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodi
    ADD CONSTRAINT prodi_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- Name: ruangan ruangan_gedung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_gedung_id_fkey FOREIGN KEY (gedung_id) REFERENCES public.gedung(id);


--
-- Name: staf staf_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- Name: staf staf_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict yvAVmDfNNxnuWTLRSlCEo5FFfCuAgdWsF5VvgWwVeh3M8Nmm3vKvztrLWFR87lV

