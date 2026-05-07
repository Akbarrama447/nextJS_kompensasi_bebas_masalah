--
-- PostgreSQL database dump
--

\restrict G0EHJk9xyLuZg1SJfn9y5Cgi7bTdRlzOdA1emqs36w8ab1OWXE3vZGO50gdD2Se

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-07 10:15:44

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
-- TOC entry 245 (class 1259 OID 19348)
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
-- TOC entry 244 (class 1259 OID 19347)
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
-- TOC entry 249 (class 1259 OID 19404)
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
-- TOC entry 248 (class 1259 OID 19403)
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
-- TOC entry 237 (class 1259 OID 19266)
-- Name: gedung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gedung (
    id integer NOT NULL,
    jurusan_id integer,
    nama_gedung character varying
);


ALTER TABLE public.gedung OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 19265)
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
-- TOC entry 247 (class 1259 OID 19379)
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
-- TOC entry 246 (class 1259 OID 19378)
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
-- TOC entry 220 (class 1259 OID 19070)
-- Name: jurusan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jurusan (
    id integer NOT NULL,
    nama_jurusan character varying
);


ALTER TABLE public.jurusan OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 19069)
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
-- TOC entry 240 (class 1259 OID 19300)
-- Name: kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kelas (
    id integer NOT NULL,
    prodi_id integer,
    nama_kelas character varying
);


ALTER TABLE public.kelas OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 19299)
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
-- TOC entry 253 (class 1259 OID 19469)
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
-- TOC entry 252 (class 1259 OID 19468)
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
-- TOC entry 255 (class 1259 OID 19494)
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
-- TOC entry 254 (class 1259 OID 19493)
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
-- TOC entry 243 (class 1259 OID 19327)
-- Name: mahasiswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mahasiswa (
    nim character varying NOT NULL,
    user_id integer,
    nama character varying
);


ALTER TABLE public.mahasiswa OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 19118)
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
-- TOC entry 221 (class 1259 OID 19117)
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
-- TOC entry 224 (class 1259 OID 19139)
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
-- TOC entry 223 (class 1259 OID 19138)
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
-- TOC entry 251 (class 1259 OID 19439)
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
-- TOC entry 250 (class 1259 OID 19438)
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
-- TOC entry 226 (class 1259 OID 19160)
-- Name: prodi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prodi (
    id integer NOT NULL,
    jurusan_id integer,
    nama_prodi character varying
);


ALTER TABLE public.prodi OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 19159)
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
-- TOC entry 227 (class 1259 OID 19173)
-- Name: ref_status_ekuivalensi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_ekuivalensi (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_ekuivalensi OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 19181)
-- Name: ref_status_import; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_import (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_import OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 19189)
-- Name: ref_status_tugas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_status_tugas (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_status_tugas OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 19197)
-- Name: ref_tipe_pekerjaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ref_tipe_pekerjaan (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.ref_tipe_pekerjaan OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 19935)
-- Name: registrasi_mahasiswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registrasi_mahasiswa (
    id integer NOT NULL,
    nim character varying,
    semester_id integer,
    kelas_id integer,
    status character varying DEFAULT 'Aktif'::character varying
);


ALTER TABLE public.registrasi_mahasiswa OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 19934)
-- Name: registrasi_mahasiswa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.registrasi_mahasiswa ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.registrasi_mahasiswa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 19205)
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
-- TOC entry 242 (class 1259 OID 19314)
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
-- TOC entry 241 (class 1259 OID 19313)
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
-- TOC entry 233 (class 1259 OID 19223)
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
-- TOC entry 232 (class 1259 OID 19222)
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
-- TOC entry 238 (class 1259 OID 19279)
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
-- TOC entry 235 (class 1259 OID 19243)
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
-- TOC entry 234 (class 1259 OID 19242)
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
-- TOC entry 259 (class 1259 OID 19961)
-- Name: v_mahasiswa_aktif; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_mahasiswa_aktif AS
 SELECT m.nim,
    m.nama,
    u.email,
    r.semester_id,
    r.status AS status_registrasi,
    k.nama_kelas,
    p.nama_prodi,
    j.nama_jurusan,
    s.is_aktif AS is_semester_aktif
   FROM ((((((public.mahasiswa m
     JOIN public.users u ON ((u.user_id = m.user_id)))
     JOIN public.registrasi_mahasiswa r ON (((r.nim)::text = (m.nim)::text)))
     JOIN public.semester s ON ((s.id = r.semester_id)))
     JOIN public.kelas k ON ((k.id = r.kelas_id)))
     JOIN public.prodi p ON ((p.id = k.prodi_id)))
     JOIN public.jurusan j ON ((j.id = p.jurusan_id)));


ALTER VIEW public.v_mahasiswa_aktif OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 19527)
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
-- TOC entry 260 (class 1259 OID 19966)
-- Name: v_status_pekerjaan; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_status_pekerjaan AS
SELECT
    NULL::integer AS pekerjaan_id,
    NULL::character varying AS judul,
    NULL::integer AS kuota,
    NULL::double precision AS poin_jam,
    NULL::boolean AS is_aktif,
    NULL::bigint AS kuota_terisi,
    NULL::bigint AS sisa_slot;


ALTER VIEW public.v_status_pekerjaan OWNER TO postgres;

--
-- TOC entry 5252 (class 0 OID 19348)
-- Dependencies: 245
-- Data for Name: daftar_pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daftar_pekerjaan (id, staf_nip, semester_id, judul, deskripsi, tipe_pekerjaan_id, poin_jam, kuota, ruangan_id, is_aktif, tanggal_mulai, tanggal_selesai, created_at) FROM stdin;
1	197501012005011001	1	Pendataan Buku Perpustakaan	Membantu mendata dan menginventarisasi buku-buku di perpustakaan	1	2	5	1	t	2024-09-10	2024-10-10	2026-04-20 16:48:48.570326
2	197501012005011001	1	Pembersihan Lab Komputer	Membersihkan dan merapikan lab komputer setelah praktikum	2	1	10	3	t	2024-09-15	2024-12-15	2026-04-20 16:48:48.570326
3	197502022006021002	1	Pengolahan Data Keuangan	Membantu entry data transaksi keuangan	1	1.5	3	7	t	2024-09-10	2024-10-31	2026-04-20 16:48:48.570326
8	197503032007031003	1	Maintenance Website Jurusan	Update konten dan perbaikan bug website	1	2.5	2	12	t	2024-09-10	2024-12-31	2026-04-20 16:48:48.570326
9	197501012005011001	1	Pengelolaan Surat Menyurat	Membantu administrasi surat di jurusan	1	1	4	5	t	2024-09-10	2024-12-31	2026-04-20 16:48:48.570326
4	197503032007031003	1	Tutor Mahasiswa Baru	Membimbing mahasiswa baru dalam adaptasi perkuliahan	2	3	8	9	t	2024-09-20	2024-11-20	2026-04-20 16:48:48.570326
5	197501012005011001	1	Survey Kepuasan Mahasiswa	Menyebarkan dan mengumpulkan kuesioner	1	1	15	5	t	2024-10-01	2024-10-30	2026-04-20 16:48:48.570326
6	198001042008041001	1	Asisten Praktikum Algoritma	Membantu dosen dalam praktikum algoritma	2	4	5	9	t	2024-09-10	2024-12-10	2026-04-20 16:48:48.570326
7	198002052009051002	1	Penelitian Dosen	Membantu pengumpulan data penelitian	1	2	3	11	t	2024-09-25	2024-11-25	2026-04-20 16:48:48.570326
10	197502022006021002	2	Pendampingan UMKM	Mendampingi UMKM binaan fakultas	2	3	5	7	f	2024-02-15	2024-05-15	2026-04-20 16:48:48.570326
11	197501012005011001	1	farrel basudewa	mcgg	1	9	5	10	t	2026-05-04	2026-05-05	2026-05-04 05:38:38.602
12	197501012005011001	1	test pekerjaan	test desk pekerjaan	1	6	1	8	t	2026-05-05	2026-05-07	2026-05-05 07:53:01.254
\.


--
-- TOC entry 5256 (class 0 OID 19404)
-- Dependencies: 249
-- Data for Name: ekuivalensi_kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ekuivalensi_kelas (id, kelas_id, semester_id, penanggung_jawab_nim, nota_url, nominal_total, jam_diakui, status_ekuivalensi_id, verified_by_nip, catatan, created_at) FROM stdin;
2	3	1	220101003	/nota/ekuivalensi_2.pdf	750000	15	2	197501012005011001	Valid	2024-09-07 10:30:00
3	6	1	220102001	/nota/ekuivalensi_3.pdf	300000	6	1	\N	Menunggu verifikasi	2024-09-10 14:15:00
4	10	1	220104001	/nota/ekuivalensi_4.pdf	1000000	20	3	197502022006021002	Bukti kurang lengkap	2024-09-12 11:00:00
5	13	1	220105001	/nota/ekuivalensi_5.pdf	450000	9	2	197503032007031003	Disetujui	2024-09-15 09:30:00
6	1	2	2372001	/nota/ekuivalensi_6.pdf	20000	10	2	\N	\N	2026-04-28 16:59:35.453043
1	1	2	220101001	/nota/ekuivalensi_1.pdf	500000	10	2	197501012005011001	Diterima	2024-09-05 09:00:00
\.


--
-- TOC entry 5244 (class 0 OID 19266)
-- Dependencies: 237
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
-- TOC entry 5254 (class 0 OID 19379)
-- Dependencies: 247
-- Data for Name: import_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.import_log (id, staf_nip, semester_id, nama_file, total_baris, sukses_baris, error_details, status_import_id, created_at) FROM stdin;
1	197501012005011001	1	import_mahasiswa_ganjil_2024.xlsx	100	98	{"errors": ["Baris 5: NIM duplikat", "Baris 23: Nama kosong"]}	2	2024-08-20 09:30:00
2	197501012005011001	1	import_kompen_awal_ganjil_2024.csv	150	150	\N	2	2024-08-21 10:15:00
3	197502022006021002	1	import_ekuivalensi.xlsx	25	23	{"errors": ["Baris 7: Kelas tidak ditemukan"]}	4	2024-09-01 14:20:00
4	197503032007031003	2	import_mahasiswa_genap_2024.csv	95	90	{"errors": ["Baris 12: NIM tidak valid"]}	4	2024-01-10 11:00:00
5	197501012005011001	3	data_lama_2023.xlsx	200	200	\N	2	2023-08-15 08:45:00
6	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	0	[{"nim": "4.33.25.0.01", "nama": "Aisa Reta Lestari", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.02", "nama": "ANDRIAN AMIRUDIN RAHMANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.03", "nama": "ANNISA NUR FARIKHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.04", "nama": "CHOIRUL RAISSA PASHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.05", "nama": "CHRISTYAN FABIANO YEHEZKIEL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.06", "nama": "DASI HAYU PERMANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.07", "nama": "DIMAS BAYU PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.08", "nama": "DZIDAN ADRIAN FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.09", "nama": "HERDIN SAVIRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.10", "nama": "IRSYAD ZAKI RAMDHANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.11", "nama": "KAVINDRA VABRIANANDA PUTRA MAHESWARA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.12", "nama": "KYLA CHAVELA EVANGELISTA WANGET", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.13", "nama": "MIKHAEL SURYA ADEPUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.14", "nama": "MOH FAREL AGUSTIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.15", "nama": "MUHAMMAD FAIQ AUDAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.16", "nama": "MUHAMMAD FAIZ FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.17", "nama": "MUHAMMAD FAQIH RAMADHAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.18", "nama": "NUR AINI WIDIYANTI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.19", "nama": "PRANAJA LUTHFI BELIAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.20", "nama": "RAFAEL MARCELLO DWI NANDA BORO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.21", "nama": "RASYA NAUFAL HARLIANDRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.22", "nama": "RIKI ULIR NIAM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.23", "nama": "SEANIRMA AIDA CANDRAWATI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.24", "nama": "TEGAR BAGUS SATRIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.0.25", "nama": "VICTOR ABDIEL KURNIAWAN RARES", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.01", "nama": "AHMAD FAJRIL FALAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.02", "nama": "ALIFANDI AHMAD SURYAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.03", "nama": "ANISA AULIA NURUSYIFA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.04", "nama": "ARINDA LUSYANA DEWI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.05", "nama": "BIMO RADYNDRA PRAMASARA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.06", "nama": "DAFFA ARMADHAN HIDMI MA'ARIF", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.07", "nama": "DARRYLL MARCHIAND MUCHAMMAD NAUVAL I", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.08", "nama": "DEA CANTIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.09", "nama": "GALIH VIRGI PRAMUDYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.10", "nama": "INAYAH CIKAL NURSHABRINA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.11", "nama": "IVAN SIGIT SANTOSO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.12", "nama": "KURNIA ANGGA DIMAS PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.13", "nama": "LUKMAN ARIF WICAKSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.14", "nama": "MAULIDYA NURUL MUHARROMAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.15", "nama": "MUHAMMAD ARYA BIMA SURYA PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.16", "nama": "MUHAMMAD DZAKYY AN NAFI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.17", "nama": "Muhammad Irfan", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.18", "nama": "MUHAMMAD RHAFI HAIRY MUSLIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.19", "nama": "MUKHLISH PRATAMA MULYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.20", "nama": "RAHMA APRILLIANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.21", "nama": "RASYA PANDU WICAKSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.22", "nama": "REVO SETYO KINASIH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.23", "nama": "RIDHO ARSYIL HAKIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.24", "nama": "RITA YULIA SARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.25", "nama": "RIZKY ADITYA WIJAYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.1.26", "nama": "VANNISA ALDIRA KIRANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.01", "nama": "AANG KUNADI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.02", "nama": "ALVIAN REZA MAHARDIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.03", "nama": "AMANDA CHRISTINA SITUMORANG", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.04", "nama": "AZKA GALUH BASUKI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.05", "nama": "BAGAS IDDEN LISTIYANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.06", "nama": "CHEETAH AMRULLAH SWASTIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.07", "nama": "DELA FAJAR MULIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.08", "nama": "EVAN OCTAVIAN RAMADHAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.09", "nama": "HADZIQ VINU MUFIDANY", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.10", "nama": "IRGI AKBAR FAHLEVI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.11", "nama": "JATMIKO SATRIO WIBOWO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.12", "nama": "LAKSAMANA AGUNG HADI NUGROHO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.13", "nama": "MILADIYAH ARINAL HAQ", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.14", "nama": "MUHAMMAD BARUNA SAYLENDRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.15", "nama": "MUHAMMAD FADHIL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.16", "nama": "NAUFAL AZKA FADHLILLAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.17", "nama": "NAZIFA CITRA NURVIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.18", "nama": "NIA SELVIA MAHDALENA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.19", "nama": "REIGZA NASYA PRATITHA RINGGIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.20", "nama": "RIZKY AKBAR ARDIANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.21", "nama": "SATRIA HATIM MARRENTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.22", "nama": "THOMAS ANDROMEDA ELANG BUANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.23", "nama": "ULFAN NAYAKA DIPTA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.24", "nama": "YUSUF RICKY HARTONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.25.2.25", "nama": "ZIYAUL FALAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.01", "nama": "ABIMANYU GILAR WALUYO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.02", "nama": "AHMAD CHOMSIN SYAHFRUDDIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.03", "nama": "AISY TSABITA AMRU", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.04", "nama": "AKBAR HAKIM MUZAKY", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.05", "nama": "ALFIN ROZZAQ NIRWANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.06", "nama": "ANISA NURWAHIDAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.07", "nama": "BASITH ANUGRAH YAFI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.08", "nama": "BENAYYA NOHAN ADMIRALDO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.09", "nama": "DANISH MAHDI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.10", "nama": "EGIE AMILIA VELISDIONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.11", "nama": "FEBY YUANGGI PUTRI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.12", "nama": "HANIF ALBANA ROZAD", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.13", "nama": "INDRA WIJAYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.14", "nama": "JONATHAN EDWARD SINAGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.15", "nama": "KATRINA AGNI HARTANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.16", "nama": "MUHAMMAD ALMAHDI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.17", "nama": "MUHAMMAD FAISAL REZA MUSTOFA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.18", "nama": "MUHAMMAD RIZKY FADHILA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.19", "nama": "MUHAMMAD SYAUQI ALGHIFARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.20", "nama": "NABILA RAMADANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.21", "nama": "NANDA ARIFIA CHOERUNISA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.22", "nama": "RAFIF ALI FAHREZI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.23", "nama": "RAKI ABHISTA PRAKOSO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.24", "nama": "SALMA ZAHRA RAMADHANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.25", "nama": "SATRIO ADZI PRIAMBODO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.0.26", "nama": "VIAN MAULANA RAMADHAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.01", "nama": "ANISA FARCHA NOVIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.02", "nama": "ARJUNA NATHA PRATISENA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.03", "nama": "ARYODIMAS DZAKI WITRYAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.04", "nama": "AZKA BARIQLANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.05", "nama": "CAHYO GADHANG PUTRO BASKORO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.06", "nama": "CANTIKA ALIFIA MAHARANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.07", "nama": "DEWANGGA RADITYA NUGROHO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.08", "nama": "EIREN WIBI HIDAYAT", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.09", "nama": "GANANG SYAIFULLAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.10", "nama": "HAFIZH IMAN WICAKSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.11", "nama": "KENCANA IKHSANUN NADJA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.12", "nama": "KHANSA INTANIA UTOMO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.13", "nama": "MI. AULIA KURNIA WIDYARANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.14", "nama": "MUHAMMAD ASDIF AFADA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.15", "nama": "MUHAMMAD BINTANG SATRIO UTOMO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.16", "nama": "MUHAMMAD ILHAM RIJAL THAARIQ", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.17", "nama": "MUHAMMAD MUMTAZA AL AFKAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.18", "nama": "NAJWA RAHMA HAPSARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.19", "nama": "PANDU SETYA NUGRAHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.20", "nama": "PUTRI LEVINA AGATHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.21", "nama": "RAUL HARYO FAUZIAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.22", "nama": "RAY EGANS PRAMUDYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.23", "nama": "RIKO ADITYA ZAKI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.24", "nama": "SENDI PRASETYO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.25", "nama": "SEPTIA ISNAENI SALSABILA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.1.26", "nama": "YUSUF FADHLIH FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.01", "nama": "ABYAN FAZA NARISWANGGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.02", "nama": "ADILA DIMAZ BUWANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.03", "nama": "ANNISA NAELIL IZATI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.04", "nama": "BAGASKARA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.05", "nama": "CEZAR NARESWARA RESPATI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.06", "nama": "DEVI IBNU NABILA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.07", "nama": "DIAH DWI ASTUTI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.08", "nama": "DIMAS ADHIE NUGROHO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.10", "nama": "GHUFRON AINUN NAJIB", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.11", "nama": "IZZA BAGHUZ SYAFI'I MA'ARIF", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.12", "nama": "M. OKSA SETYARSO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.13", "nama": "MUHAMMAD HIKMAL ALFARIDZY BACHTIAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.14", "nama": "MUHAMMAD IBRAHIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.15", "nama": "MUHAMMAD RAFA ENRICO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.16", "nama": "NABILA AZ ZAHRA MUNIR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.17", "nama": "PAULUS ALE KRISTIAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.18", "nama": "RAJABA HAMIM MAUDUDI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.19", "nama": "RIZTIKA MERISTA INDRIANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.20", "nama": "ROIHAN SAPUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.21", "nama": "SITI MIFTAHUS SA'DIYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.22", "nama": "SRI PUJANGGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.23", "nama": "TERRA SURYA NEGARI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.24", "nama": "ZALFA AZ ZAHRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.24.2.25", "nama": "ZULFIKRI ARYA PUTRA ISMAIL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.01", "nama": "ADRIANSYAH ALFARISYI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.02", "nama": "AGUNG HADI ASTANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.03", "nama": "AHMAD FARKHANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.04", "nama": "ANINDHA CAHYA MULIA SALIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.05", "nama": "ARIF KURNIA RAHMAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.06", "nama": "ATHAYA PANDU MARENO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.07", "nama": "DANIEL ADI PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.08", "nama": "DAVIN ALIFIANDA ADYTIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.09", "nama": "FAJAR DWI FIRMANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.10", "nama": "FITRIANA NAYLA NOVIANTI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.11", "nama": "GILANG MAULANATA PRAMUDYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.13", "nama": "ILHAM TARUPRASETYO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.14", "nama": "IRMA INNAYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.15", "nama": "KHILDA SALSABILA AZKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.16", "nama": "MARVELLINA DEVI WURDHANING", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.17", "nama": "MAULANA FAJAR ROHMANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.18", "nama": "MILA ROSITA DEWI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.19", "nama": "MUHAMAD HAYDAR AYDIN ALHAMDANI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.20", "nama": "MUHAMMAD SYAUQI MAULANA ANANSYAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.21", "nama": "MUHAMMAD ZAKIY FADHLULLAH AZHAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.22", "nama": "RACHMAD YOGO DWIYANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.23", "nama": "RAFI ARTHAYANA PUTRA DERIZMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.0.26", "nama": "TUBAGUS PRATAMA JULIANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.22.1.25", "nama": "TITO WAHYU PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.01", "nama": "AHMAD RIZKIADI BUDI WIRAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.02", "nama": "AKSOBHYA SAMATHA VARGA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.03", "nama": "ANINDITA NAJWA EKA SABRINA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.04", "nama": "ATSIILA ARYA NABIIH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.05", "nama": "AZANI FATTUR FADHIKA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.06", "nama": "DANU ALAMSYAH PUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.07", "nama": "FAISHAL ANANDA RACHMAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.08", "nama": "FAJAR WAHYU SURYAPUTRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.09", "nama": "HANIF ABDUSY SYAKUR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.10", "nama": "HELSA CHRISTABEL HARSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.11", "nama": "IBRAHIM ARYAN FARIDZI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.12", "nama": "IVAN RAKHA ADINATA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.13", "nama": "JONATHAN ORDRICK EDRA WIJAYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.15", "nama": "MIFTACHUSSURUR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.16", "nama": "MUHAMAD RIFKI SURYA PRATAMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.17", "nama": "MUHAMMAD FATWA SYAIKHONI", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.18", "nama": "MUHAMMAD RAFIF PASYA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.19", "nama": "NICHOLAS ERNESTO ANAK AGUNG", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.20", "nama": "RAHMALYANA AYUNINGTYAS", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.21", "nama": "RASYAD TANZILUR RAHMAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.22", "nama": "ROHIMATUN NURIN NADHIFAH", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.23", "nama": "TARISHA NAILA ANGELIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.24", "nama": "TRISTAN EKA WIRANATA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.1.25", "nama": "WARSENO BAMBANG SETYONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.01", "nama": "ADINDA RAHIMAH AZZAHRA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.02", "nama": "ADJIE RADHITYA KUSSENA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.03", "nama": "ADNAN BIMA ADHI NUGRAHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.04", "nama": "ALDO RAMADHANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.05", "nama": "AMMAR LUQMAN ARIFIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.06", "nama": "ANINDITA RAHMA AZALIA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.07", "nama": "AZKA NUR FADEL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.08", "nama": "BAGUS SADEWA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.09", "nama": "CHALLISTA RISKIANA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.10", "nama": "DIRGA PRIYANTO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.11", "nama": "FAIZ AKMAL NURHAKIM", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.12", "nama": "FATHURRAFI NADIO BUSONO", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.13", "nama": "GHAFARI ARIF JABBAR", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.14", "nama": "HASNA RUMAISHA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.15", "nama": "ILHAM AJI IRAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.16", "nama": "ILHAM INDRA ATMAJA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.17", "nama": "MUHAMAD ZA'IM SETYAWAN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.18", "nama": "MUHAMMAD DZAKY JAMALUDDIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.19", "nama": "MUHAMMAD HAIDAR ALY", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.20", "nama": "MUHAMMAD IMAM MUSTOFA KAMAL", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.21", "nama": "MUHAMMAD JANUAR RIFQI NANDA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.22", "nama": "MUHAMMAD ROOZIQIN", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.23", "nama": "PRABASWARA SHAFA AZARIOMA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.24", "nama": "SAHARDIAN PUTRA WIGUNA", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.25", "nama": "SALWA SALSABILA DAFFA'ATULHAQ", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}, {"nim": "4.33.23.2.26", "nama": "ZULVIKAR KHARISMA NUR MUHAMMAD", "error": "\\nInvalid `prisma.users.create()` invocation:\\n\\n\\nForeign key constraint violated on the constraint: `users_role_id_fkey`"}]	3	2026-05-03 13:14:36.445
7	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	0	[{"nim": "4.33.25.0.01", "nama": "Aisa Reta Lestari", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.02", "nama": "ANDRIAN AMIRUDIN RAHMANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.03", "nama": "ANNISA NUR FARIKHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.04", "nama": "CHOIRUL RAISSA PASHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.05", "nama": "CHRISTYAN FABIANO YEHEZKIEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.06", "nama": "DASI HAYU PERMANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.07", "nama": "DIMAS BAYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.08", "nama": "DZIDAN ADRIAN FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.09", "nama": "HERDIN SAVIRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.10", "nama": "IRSYAD ZAKI RAMDHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.11", "nama": "KAVINDRA VABRIANANDA PUTRA MAHESWARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.12", "nama": "KYLA CHAVELA EVANGELISTA WANGET", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.13", "nama": "MIKHAEL SURYA ADEPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.14", "nama": "MOH FAREL AGUSTIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.15", "nama": "MUHAMMAD FAIQ AUDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.16", "nama": "MUHAMMAD FAIZ FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.17", "nama": "MUHAMMAD FAQIH RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.18", "nama": "NUR AINI WIDIYANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.19", "nama": "PRANAJA LUTHFI BELIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.20", "nama": "RAFAEL MARCELLO DWI NANDA BORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.21", "nama": "RASYA NAUFAL HARLIANDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.22", "nama": "RIKI ULIR NIAM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.23", "nama": "SEANIRMA AIDA CANDRAWATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.24", "nama": "TEGAR BAGUS SATRIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.25", "nama": "VICTOR ABDIEL KURNIAWAN RARES", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.01", "nama": "AHMAD FAJRIL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.02", "nama": "ALIFANDI AHMAD SURYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.03", "nama": "ANISA AULIA NURUSYIFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.04", "nama": "ARINDA LUSYANA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.05", "nama": "BIMO RADYNDRA PRAMASARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.06", "nama": "DAFFA ARMADHAN HIDMI MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.07", "nama": "DARRYLL MARCHIAND MUCHAMMAD NAUVAL I", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.08", "nama": "DEA CANTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.09", "nama": "GALIH VIRGI PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.10", "nama": "INAYAH CIKAL NURSHABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.11", "nama": "IVAN SIGIT SANTOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.12", "nama": "KURNIA ANGGA DIMAS PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.13", "nama": "LUKMAN ARIF WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.14", "nama": "MAULIDYA NURUL MUHARROMAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.15", "nama": "MUHAMMAD ARYA BIMA SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.16", "nama": "MUHAMMAD DZAKYY AN NAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.17", "nama": "Muhammad Irfan", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.18", "nama": "MUHAMMAD RHAFI HAIRY MUSLIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.19", "nama": "MUKHLISH PRATAMA MULYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.20", "nama": "RAHMA APRILLIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.21", "nama": "RASYA PANDU WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.22", "nama": "REVO SETYO KINASIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.23", "nama": "RIDHO ARSYIL HAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.24", "nama": "RITA YULIA SARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.25", "nama": "RIZKY ADITYA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.26", "nama": "VANNISA ALDIRA KIRANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.01", "nama": "AANG KUNADI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.02", "nama": "ALVIAN REZA MAHARDIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.03", "nama": "AMANDA CHRISTINA SITUMORANG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.04", "nama": "AZKA GALUH BASUKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.05", "nama": "BAGAS IDDEN LISTIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.06", "nama": "CHEETAH AMRULLAH SWASTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.07", "nama": "DELA FAJAR MULIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.08", "nama": "EVAN OCTAVIAN RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.09", "nama": "HADZIQ VINU MUFIDANY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.10", "nama": "IRGI AKBAR FAHLEVI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.11", "nama": "JATMIKO SATRIO WIBOWO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.12", "nama": "LAKSAMANA AGUNG HADI NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.13", "nama": "MILADIYAH ARINAL HAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.14", "nama": "MUHAMMAD BARUNA SAYLENDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.15", "nama": "MUHAMMAD FADHIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.16", "nama": "NAUFAL AZKA FADHLILLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.17", "nama": "NAZIFA CITRA NURVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.18", "nama": "NIA SELVIA MAHDALENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.19", "nama": "REIGZA NASYA PRATITHA RINGGIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.20", "nama": "RIZKY AKBAR ARDIANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.21", "nama": "SATRIA HATIM MARRENTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.22", "nama": "THOMAS ANDROMEDA ELANG BUANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.23", "nama": "ULFAN NAYAKA DIPTA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.24", "nama": "YUSUF RICKY HARTONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.25", "nama": "ZIYAUL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.01", "nama": "ABIMANYU GILAR WALUYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.02", "nama": "AHMAD CHOMSIN SYAHFRUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.03", "nama": "AISY TSABITA AMRU", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.04", "nama": "AKBAR HAKIM MUZAKY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.05", "nama": "ALFIN ROZZAQ NIRWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.06", "nama": "ANISA NURWAHIDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.07", "nama": "BASITH ANUGRAH YAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.08", "nama": "BENAYYA NOHAN ADMIRALDO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.09", "nama": "DANISH MAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.10", "nama": "EGIE AMILIA VELISDIONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.11", "nama": "FEBY YUANGGI PUTRI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.12", "nama": "HANIF ALBANA ROZAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.13", "nama": "INDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.14", "nama": "JONATHAN EDWARD SINAGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.15", "nama": "KATRINA AGNI HARTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.16", "nama": "MUHAMMAD ALMAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.17", "nama": "MUHAMMAD FAISAL REZA MUSTOFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.18", "nama": "MUHAMMAD RIZKY FADHILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.19", "nama": "MUHAMMAD SYAUQI ALGHIFARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.20", "nama": "NABILA RAMADANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.21", "nama": "NANDA ARIFIA CHOERUNISA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.22", "nama": "RAFIF ALI FAHREZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.23", "nama": "RAKI ABHISTA PRAKOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.24", "nama": "SALMA ZAHRA RAMADHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.25", "nama": "SATRIO ADZI PRIAMBODO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.26", "nama": "VIAN MAULANA RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.01", "nama": "ANISA FARCHA NOVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.02", "nama": "ARJUNA NATHA PRATISENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.03", "nama": "ARYODIMAS DZAKI WITRYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.04", "nama": "AZKA BARIQLANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.05", "nama": "CAHYO GADHANG PUTRO BASKORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.06", "nama": "CANTIKA ALIFIA MAHARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.07", "nama": "DEWANGGA RADITYA NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.08", "nama": "EIREN WIBI HIDAYAT", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.09", "nama": "GANANG SYAIFULLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.10", "nama": "HAFIZH IMAN WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.11", "nama": "KENCANA IKHSANUN NADJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.12", "nama": "KHANSA INTANIA UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.13", "nama": "MI. AULIA KURNIA WIDYARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.14", "nama": "MUHAMMAD ASDIF AFADA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.15", "nama": "MUHAMMAD BINTANG SATRIO UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.16", "nama": "MUHAMMAD ILHAM RIJAL THAARIQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.17", "nama": "MUHAMMAD MUMTAZA AL AFKAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.18", "nama": "NAJWA RAHMA HAPSARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.19", "nama": "PANDU SETYA NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.20", "nama": "PUTRI LEVINA AGATHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.21", "nama": "RAUL HARYO FAUZIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.22", "nama": "RAY EGANS PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.23", "nama": "RIKO ADITYA ZAKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.24", "nama": "SENDI PRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.25", "nama": "SEPTIA ISNAENI SALSABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.26", "nama": "YUSUF FADHLIH FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.01", "nama": "ABYAN FAZA NARISWANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.02", "nama": "ADILA DIMAZ BUWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.03", "nama": "ANNISA NAELIL IZATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.04", "nama": "BAGASKARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.05", "nama": "CEZAR NARESWARA RESPATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.06", "nama": "DEVI IBNU NABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.07", "nama": "DIAH DWI ASTUTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.08", "nama": "DIMAS ADHIE NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.10", "nama": "GHUFRON AINUN NAJIB", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.11", "nama": "IZZA BAGHUZ SYAFI'I MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.12", "nama": "M. OKSA SETYARSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.13", "nama": "MUHAMMAD HIKMAL ALFARIDZY BACHTIAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.14", "nama": "MUHAMMAD IBRAHIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.15", "nama": "MUHAMMAD RAFA ENRICO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.16", "nama": "NABILA AZ ZAHRA MUNIR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.17", "nama": "PAULUS ALE KRISTIAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.18", "nama": "RAJABA HAMIM MAUDUDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.19", "nama": "RIZTIKA MERISTA INDRIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.20", "nama": "ROIHAN SAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.21", "nama": "SITI MIFTAHUS SA'DIYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.22", "nama": "SRI PUJANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.23", "nama": "TERRA SURYA NEGARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.24", "nama": "ZALFA AZ ZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.25", "nama": "ZULFIKRI ARYA PUTRA ISMAIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.01", "nama": "ADRIANSYAH ALFARISYI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.02", "nama": "AGUNG HADI ASTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.03", "nama": "AHMAD FARKHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.04", "nama": "ANINDHA CAHYA MULIA SALIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.05", "nama": "ARIF KURNIA RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.06", "nama": "ATHAYA PANDU MARENO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.07", "nama": "DANIEL ADI PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.08", "nama": "DAVIN ALIFIANDA ADYTIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.09", "nama": "FAJAR DWI FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.10", "nama": "FITRIANA NAYLA NOVIANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.11", "nama": "GILANG MAULANATA PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.13", "nama": "ILHAM TARUPRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.14", "nama": "IRMA INNAYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.15", "nama": "KHILDA SALSABILA AZKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.16", "nama": "MARVELLINA DEVI WURDHANING", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.17", "nama": "MAULANA FAJAR ROHMANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.18", "nama": "MILA ROSITA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.19", "nama": "MUHAMAD HAYDAR AYDIN ALHAMDANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.20", "nama": "MUHAMMAD SYAUQI MAULANA ANANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.21", "nama": "MUHAMMAD ZAKIY FADHLULLAH AZHAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.22", "nama": "RACHMAD YOGO DWIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.23", "nama": "RAFI ARTHAYANA PUTRA DERIZMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.26", "nama": "TUBAGUS PRATAMA JULIANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.22.1.25", "nama": "TITO WAHYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.01", "nama": "AHMAD RIZKIADI BUDI WIRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.02", "nama": "AKSOBHYA SAMATHA VARGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.03", "nama": "ANINDITA NAJWA EKA SABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.04", "nama": "ATSIILA ARYA NABIIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.05", "nama": "AZANI FATTUR FADHIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.06", "nama": "DANU ALAMSYAH PUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.07", "nama": "FAISHAL ANANDA RACHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.08", "nama": "FAJAR WAHYU SURYAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.09", "nama": "HANIF ABDUSY SYAKUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.10", "nama": "HELSA CHRISTABEL HARSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.11", "nama": "IBRAHIM ARYAN FARIDZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.12", "nama": "IVAN RAKHA ADINATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.13", "nama": "JONATHAN ORDRICK EDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.15", "nama": "MIFTACHUSSURUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.16", "nama": "MUHAMAD RIFKI SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.17", "nama": "MUHAMMAD FATWA SYAIKHONI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.18", "nama": "MUHAMMAD RAFIF PASYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.19", "nama": "NICHOLAS ERNESTO ANAK AGUNG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.20", "nama": "RAHMALYANA AYUNINGTYAS", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.21", "nama": "RASYAD TANZILUR RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.22", "nama": "ROHIMATUN NURIN NADHIFAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.23", "nama": "TARISHA NAILA ANGELIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.24", "nama": "TRISTAN EKA WIRANATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.25", "nama": "WARSENO BAMBANG SETYONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.01", "nama": "ADINDA RAHIMAH AZZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.02", "nama": "ADJIE RADHITYA KUSSENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.03", "nama": "ADNAN BIMA ADHI NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.04", "nama": "ALDO RAMADHANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.05", "nama": "AMMAR LUQMAN ARIFIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.06", "nama": "ANINDITA RAHMA AZALIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.07", "nama": "AZKA NUR FADEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.08", "nama": "BAGUS SADEWA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.09", "nama": "CHALLISTA RISKIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.10", "nama": "DIRGA PRIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.11", "nama": "FAIZ AKMAL NURHAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.12", "nama": "FATHURRAFI NADIO BUSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.13", "nama": "GHAFARI ARIF JABBAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.14", "nama": "HASNA RUMAISHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.15", "nama": "ILHAM AJI IRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.16", "nama": "ILHAM INDRA ATMAJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.17", "nama": "MUHAMAD ZA'IM SETYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.18", "nama": "MUHAMMAD DZAKY JAMALUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.19", "nama": "MUHAMMAD HAIDAR ALY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.20", "nama": "MUHAMMAD IMAM MUSTOFA KAMAL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.21", "nama": "MUHAMMAD JANUAR RIFQI NANDA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.22", "nama": "MUHAMMAD ROOZIQIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.23", "nama": "PRABASWARA SHAFA AZARIOMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.24", "nama": "SAHARDIAN PUTRA WIGUNA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.25", "nama": "SALWA SALSABILA DAFFA'ATULHAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.26", "nama": "ZULVIKAR KHARISMA NUR MUHAMMAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}]	3	2026-05-03 13:18:25.261
8	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	0	[{"nim": "4.33.25.0.01", "nama": "Aisa Reta Lestari", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.02", "nama": "ANDRIAN AMIRUDIN RAHMANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.03", "nama": "ANNISA NUR FARIKHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.04", "nama": "CHOIRUL RAISSA PASHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.05", "nama": "CHRISTYAN FABIANO YEHEZKIEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.06", "nama": "DASI HAYU PERMANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.07", "nama": "DIMAS BAYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.08", "nama": "DZIDAN ADRIAN FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.09", "nama": "HERDIN SAVIRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.10", "nama": "IRSYAD ZAKI RAMDHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.11", "nama": "KAVINDRA VABRIANANDA PUTRA MAHESWARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.12", "nama": "KYLA CHAVELA EVANGELISTA WANGET", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.13", "nama": "MIKHAEL SURYA ADEPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.14", "nama": "MOH FAREL AGUSTIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.15", "nama": "MUHAMMAD FAIQ AUDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.16", "nama": "MUHAMMAD FAIZ FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.17", "nama": "MUHAMMAD FAQIH RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.18", "nama": "NUR AINI WIDIYANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.19", "nama": "PRANAJA LUTHFI BELIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.20", "nama": "RAFAEL MARCELLO DWI NANDA BORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.21", "nama": "RASYA NAUFAL HARLIANDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.22", "nama": "RIKI ULIR NIAM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.23", "nama": "SEANIRMA AIDA CANDRAWATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.24", "nama": "TEGAR BAGUS SATRIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.0.25", "nama": "VICTOR ABDIEL KURNIAWAN RARES", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.01", "nama": "AHMAD FAJRIL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.02", "nama": "ALIFANDI AHMAD SURYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.03", "nama": "ANISA AULIA NURUSYIFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.04", "nama": "ARINDA LUSYANA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.05", "nama": "BIMO RADYNDRA PRAMASARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.06", "nama": "DAFFA ARMADHAN HIDMI MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.07", "nama": "DARRYLL MARCHIAND MUCHAMMAD NAUVAL I", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.08", "nama": "DEA CANTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.09", "nama": "GALIH VIRGI PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.10", "nama": "INAYAH CIKAL NURSHABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.11", "nama": "IVAN SIGIT SANTOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.12", "nama": "KURNIA ANGGA DIMAS PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.13", "nama": "LUKMAN ARIF WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.14", "nama": "MAULIDYA NURUL MUHARROMAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.15", "nama": "MUHAMMAD ARYA BIMA SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.16", "nama": "MUHAMMAD DZAKYY AN NAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.17", "nama": "Muhammad Irfan", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.18", "nama": "MUHAMMAD RHAFI HAIRY MUSLIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.19", "nama": "MUKHLISH PRATAMA MULYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.20", "nama": "RAHMA APRILLIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.21", "nama": "RASYA PANDU WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.22", "nama": "REVO SETYO KINASIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.23", "nama": "RIDHO ARSYIL HAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.24", "nama": "RITA YULIA SARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.25", "nama": "RIZKY ADITYA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.1.26", "nama": "VANNISA ALDIRA KIRANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.01", "nama": "AANG KUNADI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.02", "nama": "ALVIAN REZA MAHARDIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.03", "nama": "AMANDA CHRISTINA SITUMORANG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.04", "nama": "AZKA GALUH BASUKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.05", "nama": "BAGAS IDDEN LISTIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.06", "nama": "CHEETAH AMRULLAH SWASTIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.07", "nama": "DELA FAJAR MULIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.08", "nama": "EVAN OCTAVIAN RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.09", "nama": "HADZIQ VINU MUFIDANY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.10", "nama": "IRGI AKBAR FAHLEVI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.11", "nama": "JATMIKO SATRIO WIBOWO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.12", "nama": "LAKSAMANA AGUNG HADI NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.13", "nama": "MILADIYAH ARINAL HAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.14", "nama": "MUHAMMAD BARUNA SAYLENDRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.15", "nama": "MUHAMMAD FADHIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.16", "nama": "NAUFAL AZKA FADHLILLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.17", "nama": "NAZIFA CITRA NURVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.18", "nama": "NIA SELVIA MAHDALENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.19", "nama": "REIGZA NASYA PRATITHA RINGGIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.20", "nama": "RIZKY AKBAR ARDIANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.21", "nama": "SATRIA HATIM MARRENTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.22", "nama": "THOMAS ANDROMEDA ELANG BUANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.23", "nama": "ULFAN NAYAKA DIPTA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.24", "nama": "YUSUF RICKY HARTONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.25.2.25", "nama": "ZIYAUL FALAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.01", "nama": "ABIMANYU GILAR WALUYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.02", "nama": "AHMAD CHOMSIN SYAHFRUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.03", "nama": "AISY TSABITA AMRU", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.04", "nama": "AKBAR HAKIM MUZAKY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.05", "nama": "ALFIN ROZZAQ NIRWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.06", "nama": "ANISA NURWAHIDAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.07", "nama": "BASITH ANUGRAH YAFI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.08", "nama": "BENAYYA NOHAN ADMIRALDO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.09", "nama": "DANISH MAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.10", "nama": "EGIE AMILIA VELISDIONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.11", "nama": "FEBY YUANGGI PUTRI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.12", "nama": "HANIF ALBANA ROZAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.13", "nama": "INDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.14", "nama": "JONATHAN EDWARD SINAGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.15", "nama": "KATRINA AGNI HARTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.16", "nama": "MUHAMMAD ALMAHDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.17", "nama": "MUHAMMAD FAISAL REZA MUSTOFA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.18", "nama": "MUHAMMAD RIZKY FADHILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.19", "nama": "MUHAMMAD SYAUQI ALGHIFARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.20", "nama": "NABILA RAMADANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.21", "nama": "NANDA ARIFIA CHOERUNISA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.22", "nama": "RAFIF ALI FAHREZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.23", "nama": "RAKI ABHISTA PRAKOSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.24", "nama": "SALMA ZAHRA RAMADHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.25", "nama": "SATRIO ADZI PRIAMBODO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.0.26", "nama": "VIAN MAULANA RAMADHAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.01", "nama": "ANISA FARCHA NOVIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.02", "nama": "ARJUNA NATHA PRATISENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.03", "nama": "ARYODIMAS DZAKI WITRYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.04", "nama": "AZKA BARIQLANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.05", "nama": "CAHYO GADHANG PUTRO BASKORO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.06", "nama": "CANTIKA ALIFIA MAHARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.07", "nama": "DEWANGGA RADITYA NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.08", "nama": "EIREN WIBI HIDAYAT", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.09", "nama": "GANANG SYAIFULLAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.10", "nama": "HAFIZH IMAN WICAKSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.11", "nama": "KENCANA IKHSANUN NADJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.12", "nama": "KHANSA INTANIA UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.13", "nama": "MI. AULIA KURNIA WIDYARANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.14", "nama": "MUHAMMAD ASDIF AFADA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.15", "nama": "MUHAMMAD BINTANG SATRIO UTOMO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.16", "nama": "MUHAMMAD ILHAM RIJAL THAARIQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.17", "nama": "MUHAMMAD MUMTAZA AL AFKAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.18", "nama": "NAJWA RAHMA HAPSARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.19", "nama": "PANDU SETYA NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.20", "nama": "PUTRI LEVINA AGATHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.21", "nama": "RAUL HARYO FAUZIAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.22", "nama": "RAY EGANS PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.23", "nama": "RIKO ADITYA ZAKI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.24", "nama": "SENDI PRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.25", "nama": "SEPTIA ISNAENI SALSABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.1.26", "nama": "YUSUF FADHLIH FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.01", "nama": "ABYAN FAZA NARISWANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.02", "nama": "ADILA DIMAZ BUWANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.03", "nama": "ANNISA NAELIL IZATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.04", "nama": "BAGASKARA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.05", "nama": "CEZAR NARESWARA RESPATI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.06", "nama": "DEVI IBNU NABILA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.07", "nama": "DIAH DWI ASTUTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.08", "nama": "DIMAS ADHIE NUGROHO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.10", "nama": "GHUFRON AINUN NAJIB", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.11", "nama": "IZZA BAGHUZ SYAFI'I MA'ARIF", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.12", "nama": "M. OKSA SETYARSO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.13", "nama": "MUHAMMAD HIKMAL ALFARIDZY BACHTIAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.14", "nama": "MUHAMMAD IBRAHIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.15", "nama": "MUHAMMAD RAFA ENRICO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.16", "nama": "NABILA AZ ZAHRA MUNIR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.17", "nama": "PAULUS ALE KRISTIAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.18", "nama": "RAJABA HAMIM MAUDUDI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.19", "nama": "RIZTIKA MERISTA INDRIANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.20", "nama": "ROIHAN SAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.21", "nama": "SITI MIFTAHUS SA'DIYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.22", "nama": "SRI PUJANGGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.23", "nama": "TERRA SURYA NEGARI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.24", "nama": "ZALFA AZ ZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.24.2.25", "nama": "ZULFIKRI ARYA PUTRA ISMAIL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.01", "nama": "ADRIANSYAH ALFARISYI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.02", "nama": "AGUNG HADI ASTANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.03", "nama": "AHMAD FARKHANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.04", "nama": "ANINDHA CAHYA MULIA SALIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.05", "nama": "ARIF KURNIA RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.06", "nama": "ATHAYA PANDU MARENO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.07", "nama": "DANIEL ADI PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.08", "nama": "DAVIN ALIFIANDA ADYTIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.09", "nama": "FAJAR DWI FIRMANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.10", "nama": "FITRIANA NAYLA NOVIANTI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.11", "nama": "GILANG MAULANATA PRAMUDYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.13", "nama": "ILHAM TARUPRASETYO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.14", "nama": "IRMA INNAYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.15", "nama": "KHILDA SALSABILA AZKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.16", "nama": "MARVELLINA DEVI WURDHANING", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.17", "nama": "MAULANA FAJAR ROHMANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.18", "nama": "MILA ROSITA DEWI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.19", "nama": "MUHAMAD HAYDAR AYDIN ALHAMDANI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.20", "nama": "MUHAMMAD SYAUQI MAULANA ANANSYAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.21", "nama": "MUHAMMAD ZAKIY FADHLULLAH AZHAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.22", "nama": "RACHMAD YOGO DWIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.23", "nama": "RAFI ARTHAYANA PUTRA DERIZMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.0.26", "nama": "TUBAGUS PRATAMA JULIANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.22.1.25", "nama": "TITO WAHYU PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.01", "nama": "AHMAD RIZKIADI BUDI WIRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.02", "nama": "AKSOBHYA SAMATHA VARGA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.03", "nama": "ANINDITA NAJWA EKA SABRINA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.04", "nama": "ATSIILA ARYA NABIIH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.05", "nama": "AZANI FATTUR FADHIKA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.06", "nama": "DANU ALAMSYAH PUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.07", "nama": "FAISHAL ANANDA RACHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.08", "nama": "FAJAR WAHYU SURYAPUTRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.09", "nama": "HANIF ABDUSY SYAKUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.10", "nama": "HELSA CHRISTABEL HARSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.11", "nama": "IBRAHIM ARYAN FARIDZI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.12", "nama": "IVAN RAKHA ADINATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.13", "nama": "JONATHAN ORDRICK EDRA WIJAYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.15", "nama": "MIFTACHUSSURUR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.16", "nama": "MUHAMAD RIFKI SURYA PRATAMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.17", "nama": "MUHAMMAD FATWA SYAIKHONI", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.18", "nama": "MUHAMMAD RAFIF PASYA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.19", "nama": "NICHOLAS ERNESTO ANAK AGUNG", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.20", "nama": "RAHMALYANA AYUNINGTYAS", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.21", "nama": "RASYAD TANZILUR RAHMAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.22", "nama": "ROHIMATUN NURIN NADHIFAH", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.23", "nama": "TARISHA NAILA ANGELIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.24", "nama": "TRISTAN EKA WIRANATA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.1.25", "nama": "WARSENO BAMBANG SETYONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.01", "nama": "ADINDA RAHIMAH AZZAHRA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.02", "nama": "ADJIE RADHITYA KUSSENA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.03", "nama": "ADNAN BIMA ADHI NUGRAHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.04", "nama": "ALDO RAMADHANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.05", "nama": "AMMAR LUQMAN ARIFIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.06", "nama": "ANINDITA RAHMA AZALIA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.07", "nama": "AZKA NUR FADEL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.08", "nama": "BAGUS SADEWA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.09", "nama": "CHALLISTA RISKIANA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.10", "nama": "DIRGA PRIYANTO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.11", "nama": "FAIZ AKMAL NURHAKIM", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.12", "nama": "FATHURRAFI NADIO BUSONO", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.13", "nama": "GHAFARI ARIF JABBAR", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.14", "nama": "HASNA RUMAISHA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.15", "nama": "ILHAM AJI IRAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.16", "nama": "ILHAM INDRA ATMAJA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.17", "nama": "MUHAMAD ZA'IM SETYAWAN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.18", "nama": "MUHAMMAD DZAKY JAMALUDDIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.19", "nama": "MUHAMMAD HAIDAR ALY", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.20", "nama": "MUHAMMAD IMAM MUSTOFA KAMAL", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.21", "nama": "MUHAMMAD JANUAR RIFQI NANDA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.22", "nama": "MUHAMMAD ROOZIQIN", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.23", "nama": "PRABASWARA SHAFA AZARIOMA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.24", "nama": "SAHARDIAN PUTRA WIGUNA", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.25", "nama": "SALWA SALSABILA DAFFA'ATULHAQ", "error": "Cannot read properties of undefined (reading 'findFirst')"}, {"nim": "4.33.23.2.26", "nama": "ZULVIKAR KHARISMA NUR MUHAMMAD", "error": "Cannot read properties of undefined (reading 'findFirst')"}]	3	2026-05-03 13:32:00.246
9	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	2	2026-05-03 13:34:10.664
10	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	2	2026-05-04 07:32:27.339
11	197501012005011001	1	kompen-mhs-TI-1A.xlsx	226	226	null	2	2026-05-05 07:51:45.433
\.


--
-- TOC entry 5227 (class 0 OID 19070)
-- Dependencies: 220
-- Data for Name: jurusan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jurusan (id, nama_jurusan) FROM stdin;
1	Fakultas Teknik
2	Fakultas Ekonomi
3	Fakultas Ilmu Komputer
4	Fakultas Hukum
\.


--
-- TOC entry 5247 (class 0 OID 19300)
-- Dependencies: 240
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
16	\N	TI-1A
17	\N	TI-1B
18	\N	TI-1C
19	\N	TI-2A
20	\N	TI-2B
21	\N	TI-2C
22	\N	TI-3A
23	\N	TI-3B
24	\N	TI-3C
\.


--
-- TOC entry 5260 (class 0 OID 19469)
-- Dependencies: 253
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
22	4.33.25.0.03	1	11	0	2026-05-03 13:34:11.089
23	4.33.25.0.04	1	11	0	2026-05-03 13:34:11.121
24	4.33.25.0.05	1	11	0	2026-05-03 13:34:11.159
25	4.33.25.0.06	1	11	40	2026-05-03 13:34:11.195
26	4.33.25.0.07	1	11	0	2026-05-03 13:34:11.228
27	4.33.25.0.08	1	11	0	2026-05-03 13:34:11.259
28	4.33.25.0.09	1	11	0	2026-05-03 13:34:11.292
29	4.33.25.0.10	1	11	0	2026-05-03 13:34:11.328
31	4.33.25.0.12	1	11	0	2026-05-03 13:34:11.392
32	4.33.25.0.13	1	11	0	2026-05-03 13:34:11.424
33	4.33.25.0.14	1	11	0	2026-05-03 13:34:11.459
34	4.33.25.0.15	1	11	0	2026-05-03 13:34:11.491
35	4.33.25.0.16	1	11	0	2026-05-03 13:34:11.518
36	4.33.25.0.17	1	11	0	2026-05-03 13:34:11.549
37	4.33.25.0.18	1	11	0	2026-05-03 13:34:11.586
38	4.33.25.0.19	1	11	0	2026-05-03 13:34:11.63
39	4.33.25.0.20	1	11	0	2026-05-03 13:34:11.664
40	4.33.25.0.21	1	11	456	2026-05-03 13:34:11.691
41	4.33.25.0.22	1	11	0	2026-05-03 13:34:11.748
42	4.33.25.0.23	1	11	0	2026-05-03 13:34:11.777
43	4.33.25.0.24	1	11	0	2026-05-03 13:34:11.815
44	4.33.25.0.25	1	11	0	2026-05-03 13:34:11.848
45	4.33.25.1.01	1	11	0	2026-05-03 13:34:11.881
46	4.33.25.1.02	1	11	0	2026-05-03 13:34:11.92
47	4.33.25.1.03	1	11	0	2026-05-03 13:34:11.956
48	4.33.25.1.04	1	11	0	2026-05-03 13:34:11.988
50	4.33.25.1.06	1	11	0	2026-05-03 13:34:12.072
51	4.33.25.1.07	1	11	0	2026-05-03 13:34:12.127
52	4.33.25.1.08	1	11	0	2026-05-03 13:34:12.167
53	4.33.25.1.09	1	11	0	2026-05-03 13:34:12.202
54	4.33.25.1.10	1	11	0	2026-05-03 13:34:12.236
55	4.33.25.1.11	1	11	0	2026-05-03 13:34:12.262
56	4.33.25.1.12	1	11	0	2026-05-03 13:34:12.29
57	4.33.25.1.13	1	11	0	2026-05-03 13:34:12.319
58	4.33.25.1.14	1	11	0	2026-05-03 13:34:12.35
59	4.33.25.1.15	1	11	0	2026-05-03 13:34:12.38
60	4.33.25.1.16	1	11	0	2026-05-03 13:34:12.42
61	4.33.25.1.17	1	11	0	2026-05-03 13:34:12.453
62	4.33.25.1.18	1	11	0	2026-05-03 13:34:12.518
63	4.33.25.1.19	1	11	0	2026-05-03 13:34:12.557
64	4.33.25.1.20	1	11	0	2026-05-03 13:34:12.591
65	4.33.25.1.21	1	11	0	2026-05-03 13:34:12.64
66	4.33.25.1.22	1	11	0	2026-05-03 13:34:12.683
67	4.33.25.1.23	1	11	0	2026-05-03 13:34:12.723
69	4.33.25.1.25	1	11	0	2026-05-03 13:34:12.795
70	4.33.25.1.26	1	11	0	2026-05-03 13:34:12.829
71	4.33.25.2.01	1	11	96	2026-05-03 13:34:12.858
72	4.33.25.2.02	1	11	0	2026-05-03 13:34:12.886
73	4.33.25.2.03	1	11	0	2026-05-03 13:34:12.921
74	4.33.25.2.04	1	11	24	2026-05-03 13:34:12.954
75	4.33.25.2.05	1	11	0	2026-05-03 13:34:12.992
76	4.33.25.2.06	1	11	0	2026-05-03 13:34:13.044
77	4.33.25.2.07	1	11	0	2026-05-03 13:34:13.12
78	4.33.25.2.08	1	11	0	2026-05-03 13:34:13.173
79	4.33.25.2.09	1	11	0	2026-05-03 13:34:13.207
80	4.33.25.2.10	1	11	16	2026-05-03 13:34:13.24
81	4.33.25.2.11	1	11	0	2026-05-03 13:34:13.274
82	4.33.25.2.12	1	11	8	2026-05-03 13:34:13.307
83	4.33.25.2.13	1	11	0	2026-05-03 13:34:13.345
84	4.33.25.2.14	1	11	0	2026-05-03 13:34:13.364
85	4.33.25.2.15	1	11	0	2026-05-03 13:34:13.387
86	4.33.25.2.16	1	11	0	2026-05-03 13:34:13.417
88	4.33.25.2.18	1	11	0	2026-05-03 13:34:13.491
89	4.33.25.2.19	1	11	0	2026-05-03 13:34:13.521
90	4.33.25.2.20	1	11	96	2026-05-03 13:34:13.572
91	4.33.25.2.21	1	11	0	2026-05-03 13:34:13.604
92	4.33.25.2.22	1	11	0	2026-05-03 13:34:13.633
93	4.33.25.2.23	1	11	8	2026-05-03 13:34:13.662
94	4.33.25.2.24	1	11	0	2026-05-03 13:34:13.694
95	4.33.25.2.25	1	11	0	2026-05-03 13:34:13.731
96	4.33.24.0.01	1	11	32	2026-05-03 13:34:13.772
97	4.33.24.0.02	1	11	0	2026-05-03 13:34:13.811
98	4.33.24.0.03	1	11	0	2026-05-03 13:34:13.843
99	4.33.24.0.04	1	11	0	2026-05-03 13:34:13.876
100	4.33.24.0.05	1	11	0	2026-05-03 13:34:13.926
101	4.33.24.0.06	1	11	776	2026-05-03 13:34:13.954
102	4.33.24.0.07	1	11	0	2026-05-03 13:34:13.982
103	4.33.24.0.08	1	11	0	2026-05-03 13:34:14.015
104	4.33.24.0.09	1	11	0	2026-05-03 13:34:14.045
105	4.33.24.0.10	1	11	0	2026-05-03 13:34:14.072
107	4.33.24.0.12	1	11	0	2026-05-03 13:34:14.128
108	4.33.24.0.13	1	11	0	2026-05-03 13:34:14.156
109	4.33.24.0.14	1	11	0	2026-05-03 13:34:14.185
21	4.33.25.0.02	1	11	0	2026-05-03 13:34:11.051
112	4.33.24.0.17	1	11	0	2026-05-03 13:34:14.276
113	4.33.24.0.18	1	11	0	2026-05-03 13:34:14.301
114	4.33.24.0.19	1	11	0	2026-05-03 13:34:14.331
115	4.33.24.0.20	1	11	0	2026-05-03 13:34:14.374
116	4.33.24.0.21	1	11	0	2026-05-03 13:34:14.4
117	4.33.24.0.22	1	11	0	2026-05-03 13:34:14.428
118	4.33.24.0.23	1	11	0	2026-05-03 13:34:14.457
119	4.33.24.0.24	1	11	0	2026-05-03 13:34:14.49
121	4.33.24.0.26	1	11	0	2026-05-03 13:34:14.548
122	4.33.24.1.01	1	11	0	2026-05-03 13:34:14.577
123	4.33.24.1.02	1	11	0	2026-05-03 13:34:14.612
124	4.33.24.1.03	1	11	0	2026-05-03 13:34:14.644
125	4.33.24.1.04	1	11	0	2026-05-03 13:34:14.672
126	4.33.24.1.05	1	11	0	2026-05-03 13:34:14.7
127	4.33.24.1.06	1	11	0	2026-05-03 13:34:14.734
128	4.33.24.1.07	1	11	40	2026-05-03 13:34:14.762
129	4.33.24.1.08	1	11	8	2026-05-03 13:34:14.786
130	4.33.24.1.09	1	11	0	2026-05-03 13:34:14.813
131	4.33.24.1.10	1	11	0	2026-05-03 13:34:14.838
132	4.33.24.1.11	1	11	0	2026-05-03 13:34:14.866
133	4.33.24.1.12	1	11	0	2026-05-03 13:34:14.895
134	4.33.24.1.13	1	11	8	2026-05-03 13:34:14.93
135	4.33.24.1.14	1	11	0	2026-05-03 13:34:14.961
136	4.33.24.1.15	1	11	0	2026-05-03 13:34:14.986
137	4.33.24.1.16	1	11	0	2026-05-03 13:34:15.014
138	4.33.24.1.17	1	11	0	2026-05-03 13:34:15.037
140	4.33.24.1.19	1	11	0	2026-05-03 13:34:15.097
141	4.33.24.1.20	1	11	0	2026-05-03 13:34:15.121
142	4.33.24.1.21	1	11	0	2026-05-03 13:34:15.142
143	4.33.24.1.22	1	11	0	2026-05-03 13:34:15.161
144	4.33.24.1.23	1	11	0	2026-05-03 13:34:15.185
145	4.33.24.1.24	1	11	0	2026-05-03 13:34:15.209
146	4.33.24.1.25	1	11	0	2026-05-03 13:34:15.235
147	4.33.24.1.26	1	11	0	2026-05-03 13:34:15.262
148	4.33.24.2.01	1	11	0	2026-05-03 13:34:15.283
149	4.33.24.2.02	1	11	0	2026-05-03 13:34:15.305
150	4.33.24.2.03	1	11	0	2026-05-03 13:34:15.325
151	4.33.24.2.04	1	11	0	2026-05-03 13:34:15.345
152	4.33.24.2.05	1	11	0	2026-05-03 13:34:15.366
153	4.33.24.2.06	1	11	0	2026-05-03 13:34:15.396
154	4.33.24.2.07	1	11	0	2026-05-03 13:34:15.437
155	4.33.24.2.08	1	11	0	2026-05-03 13:34:15.45
156	4.33.24.2.10	1	11	0	2026-05-03 13:34:15.461
157	4.33.24.2.11	1	11	0	2026-05-03 13:34:15.48
159	4.33.24.2.13	1	11	0	2026-05-03 13:34:15.508
160	4.33.24.2.14	1	11	0	2026-05-03 13:34:15.522
161	4.33.24.2.15	1	11	0	2026-05-03 13:34:15.535
162	4.33.24.2.16	1	11	0	2026-05-03 13:34:15.548
163	4.33.24.2.17	1	11	24	2026-05-03 13:34:15.558
164	4.33.24.2.18	1	11	0	2026-05-03 13:34:15.569
165	4.33.24.2.19	1	11	0	2026-05-03 13:34:15.585
166	4.33.24.2.20	1	11	24	2026-05-03 13:34:15.595
167	4.33.24.2.21	1	11	0	2026-05-03 13:34:15.605
168	4.33.24.2.22	1	11	24	2026-05-03 13:34:15.615
169	4.33.24.2.23	1	11	16	2026-05-03 13:34:15.626
170	4.33.24.2.24	1	11	0	2026-05-03 13:34:15.636
171	4.33.24.2.25	1	11	16	2026-05-03 13:34:15.645
172	4.33.23.0.01	1	11	8	2026-05-03 13:34:15.654
173	4.33.23.0.02	1	11	0	2026-05-03 13:34:15.665
174	4.33.23.0.03	1	11	24	2026-05-03 13:34:15.674
175	4.33.23.0.04	1	11	0	2026-05-03 13:34:15.684
176	4.33.23.0.05	1	11	0	2026-05-03 13:34:15.694
178	4.33.23.0.07	1	11	0	2026-05-03 13:34:15.711
179	4.33.23.0.08	1	11	0	2026-05-03 13:34:15.721
180	4.33.23.0.09	1	11	0	2026-05-03 13:34:15.729
181	4.33.23.0.10	1	11	0	2026-05-03 13:34:15.736
182	4.33.23.0.11	1	11	16	2026-05-03 13:34:15.743
183	4.33.23.0.13	1	11	0	2026-05-03 13:34:15.752
184	4.33.23.0.14	1	11	0	2026-05-03 13:34:15.76
185	4.33.23.0.15	1	11	0	2026-05-03 13:34:15.768
186	4.33.23.0.16	1	11	0	2026-05-03 13:34:15.773
187	4.33.23.0.17	1	11	40	2026-05-03 13:34:15.778
188	4.33.23.0.18	1	11	24	2026-05-03 13:34:15.783
189	4.33.23.0.19	1	11	0	2026-05-03 13:34:15.787
190	4.33.23.0.20	1	11	0	2026-05-03 13:34:15.795
191	4.33.23.0.21	1	11	0	2026-05-03 13:34:15.8
192	4.33.23.0.22	1	11	0	2026-05-03 13:34:15.804
193	4.33.23.0.23	1	11	0	2026-05-03 13:34:15.807
194	4.33.23.0.26	1	11	8	2026-05-03 13:34:15.81
195	4.33.22.1.25	1	11	80	2026-05-03 13:34:15.815
197	4.33.23.1.02	1	11	0	2026-05-03 13:34:15.822
198	4.33.23.1.03	1	11	0	2026-05-03 13:34:15.825
199	4.33.23.1.04	1	11	0	2026-05-03 13:34:15.829
200	4.33.23.1.05	1	11	0	2026-05-03 13:34:15.833
201	4.33.23.1.06	1	11	0	2026-05-03 13:34:15.837
202	4.33.23.1.07	1	11	0	2026-05-03 13:34:15.84
203	4.33.23.1.08	1	11	0	2026-05-03 13:34:15.844
204	4.33.23.1.09	1	11	0	2026-05-03 13:34:15.849
205	4.33.23.1.10	1	11	0	2026-05-03 13:34:15.853
206	4.33.23.1.11	1	11	0	2026-05-03 13:34:15.857
207	4.33.23.1.12	1	11	0	2026-05-03 13:34:15.86
208	4.33.23.1.13	1	11	0	2026-05-03 13:34:15.865
209	4.33.23.1.15	1	11	0	2026-05-03 13:34:15.869
210	4.33.23.1.16	1	11	40	2026-05-03 13:34:15.872
211	4.33.23.1.17	1	11	32	2026-05-03 13:34:15.876
212	4.33.23.1.18	1	11	0	2026-05-03 13:34:15.881
213	4.33.23.1.19	1	11	0	2026-05-03 13:34:15.884
214	4.33.23.1.20	1	11	0	2026-05-03 13:34:15.888
216	4.33.23.1.22	1	11	0	2026-05-03 13:34:15.898
111	4.33.24.0.16	1	11	0	2026-05-03 13:34:14.244
230	4.33.23.2.11	1	11	40	2026-05-03 13:34:15.965
231	4.33.23.2.12	1	11	0	2026-05-03 13:34:15.971
232	4.33.23.2.13	1	11	16	2026-05-03 13:34:15.976
233	4.33.23.2.14	1	11	0	2026-05-03 13:34:15.982
234	4.33.23.2.15	1	11	0	2026-05-03 13:34:15.987
235	4.33.23.2.16	1	11	16	2026-05-03 13:34:15.992
236	4.33.23.2.17	1	11	0	2026-05-03 13:34:15.997
237	4.33.23.2.18	1	11	0	2026-05-03 13:34:16.002
238	4.33.23.2.19	1	11	0	2026-05-03 13:34:16.007
239	4.33.23.2.20	1	11	32	2026-05-03 13:34:16.011
240	4.33.23.2.21	1	11	0	2026-05-03 13:34:16.018
241	4.33.23.2.22	1	11	40	2026-05-03 13:34:16.026
242	4.33.23.2.23	1	11	32	2026-05-03 13:34:16.033
20	4.33.25.0.01	1	11	0	2026-05-03 13:34:11.011
30	4.33.25.0.11	1	11	0	2026-05-03 13:34:11.359
49	4.33.25.1.05	1	11	8	2026-05-03 13:34:12.029
68	4.33.25.1.24	1	11	8	2026-05-03 13:34:12.763
87	4.33.25.2.17	1	11	0	2026-05-03 13:34:13.455
106	4.33.24.0.11	1	11	0	2026-05-03 13:34:14.098
110	4.33.24.0.15	1	11	0	2026-05-03 13:34:14.214
120	4.33.24.0.25	1	11	0	2026-05-03 13:34:14.518
139	4.33.24.1.18	1	11	0	2026-05-03 13:34:15.059
158	4.33.24.2.12	1	11	0	2026-05-03 13:34:15.49
177	4.33.23.0.06	1	11	8	2026-05-03 13:34:15.703
196	4.33.23.1.01	1	11	0	2026-05-03 13:34:15.819
215	4.33.23.1.21	1	11	0	2026-05-03 13:34:15.891
217	4.33.23.1.23	1	11	0	2026-05-03 13:34:15.901
218	4.33.23.1.24	1	11	16	2026-05-03 13:34:15.905
219	4.33.23.1.25	1	11	0	2026-05-03 13:34:15.909
220	4.33.23.2.01	1	11	0	2026-05-03 13:34:15.913
221	4.33.23.2.02	1	11	56	2026-05-03 13:34:15.918
222	4.33.23.2.03	1	11	8	2026-05-03 13:34:15.922
223	4.33.23.2.04	1	11	0	2026-05-03 13:34:15.925
224	4.33.23.2.05	1	11	0	2026-05-03 13:34:15.93
225	4.33.23.2.06	1	11	0	2026-05-03 13:34:15.935
226	4.33.23.2.07	1	11	40	2026-05-03 13:34:15.939
227	4.33.23.2.08	1	11	0	2026-05-03 13:34:15.943
228	4.33.23.2.09	1	11	0	2026-05-03 13:34:15.949
229	4.33.23.2.10	1	11	72	2026-05-03 13:34:15.957
243	4.33.23.2.24	1	11	72	2026-05-03 13:34:16.042
244	4.33.23.2.25	1	11	0	2026-05-03 13:34:16.05
245	4.33.23.2.26	1	11	40	2026-05-03 13:34:16.055
\.


--
-- TOC entry 5262 (class 0 OID 19494)
-- Dependencies: 255
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
-- TOC entry 5250 (class 0 OID 19327)
-- Dependencies: 243
-- Data for Name: mahasiswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mahasiswa (nim, user_id, nama) FROM stdin;
220101001	7	Andi Pratama
220101002	8	Budi Wibowo
220101003	9	Citra Dewi
220101004	10	Dian Sastro
220101005	11	Eko Prasetyo
220102001	\N	Fajar Nugroho
220102002	\N	Gita Rahayu
220103001	\N	Hendra Setiawan
220104001	\N	Indah Permata
220105001	\N	Joko Susilo
220105002	\N	Kartika Sari
220105003	\N	Lukman Hakim
210101001	\N	Mega Lestari
210101002	\N	Nanda Putri
220106001	\N	Oscar Simanjuntak
2372001	12	Akbar Testing
4.33.25.0.01	239	Aisa Reta Lestari
4.33.25.0.02	240	ANDRIAN AMIRUDIN RAHMANTO
4.33.25.0.03	241	ANNISA NUR FARIKHA
4.33.25.0.04	242	CHOIRUL RAISSA PASHA
4.33.25.0.05	243	CHRISTYAN FABIANO YEHEZKIEL
4.33.25.0.06	244	DASI HAYU PERMANA
4.33.25.0.07	245	DIMAS BAYU PRATAMA
4.33.25.0.08	246	DZIDAN ADRIAN FIRMANSYAH
4.33.25.0.09	247	HERDIN SAVIRA
4.33.25.0.10	248	IRSYAD ZAKI RAMDHANI
4.33.25.0.11	249	KAVINDRA VABRIANANDA PUTRA MAHESWARA
4.33.25.0.12	250	KYLA CHAVELA EVANGELISTA WANGET
4.33.25.0.13	251	MIKHAEL SURYA ADEPUTRA
4.33.25.0.14	252	MOH FAREL AGUSTIN
4.33.25.0.15	253	MUHAMMAD FAIQ AUDAH
4.33.25.0.16	254	MUHAMMAD FAIZ FIRMANSYAH
4.33.25.0.17	255	MUHAMMAD FAQIH RAMADHAN
4.33.25.0.18	256	NUR AINI WIDIYANTI
4.33.25.0.19	257	PRANAJA LUTHFI BELIAN
4.33.25.0.20	258	RAFAEL MARCELLO DWI NANDA BORO
4.33.25.0.21	259	RASYA NAUFAL HARLIANDRA
4.33.25.0.22	260	RIKI ULIR NIAM
4.33.25.0.23	261	SEANIRMA AIDA CANDRAWATI
4.33.25.0.24	262	TEGAR BAGUS SATRIA
4.33.25.0.25	263	VICTOR ABDIEL KURNIAWAN RARES
4.33.25.1.01	264	AHMAD FAJRIL FALAH
4.33.25.1.02	265	ALIFANDI AHMAD SURYAWAN
4.33.25.1.03	266	ANISA AULIA NURUSYIFA
4.33.25.1.04	267	ARINDA LUSYANA DEWI
4.33.25.1.05	268	BIMO RADYNDRA PRAMASARA
4.33.25.1.06	269	DAFFA ARMADHAN HIDMI MA'ARIF
4.33.25.1.07	270	DARRYLL MARCHIAND MUCHAMMAD NAUVAL I
4.33.25.1.08	271	DEA CANTIKA
4.33.25.1.09	272	GALIH VIRGI PRAMUDYA
4.33.25.1.10	273	INAYAH CIKAL NURSHABRINA
4.33.25.1.11	274	IVAN SIGIT SANTOSO
4.33.25.1.12	275	KURNIA ANGGA DIMAS PRATAMA
4.33.25.1.13	276	LUKMAN ARIF WICAKSONO
4.33.25.1.14	277	MAULIDYA NURUL MUHARROMAH
4.33.25.1.15	278	MUHAMMAD ARYA BIMA SURYA PRATAMA
4.33.25.1.16	279	MUHAMMAD DZAKYY AN NAFI
4.33.25.1.17	280	Muhammad Irfan
4.33.25.1.18	281	MUHAMMAD RHAFI HAIRY MUSLIM
4.33.25.1.19	282	MUKHLISH PRATAMA MULYA
4.33.25.1.20	283	RAHMA APRILLIANA
4.33.25.1.21	284	RASYA PANDU WICAKSONO
4.33.25.1.22	285	REVO SETYO KINASIH
4.33.25.1.23	286	RIDHO ARSYIL HAKIM
4.33.25.1.24	287	RITA YULIA SARI
4.33.25.1.25	288	RIZKY ADITYA WIJAYA
4.33.25.1.26	289	VANNISA ALDIRA KIRANI
4.33.25.2.01	290	AANG KUNADI
4.33.25.2.02	291	ALVIAN REZA MAHARDIKA
4.33.25.2.03	292	AMANDA CHRISTINA SITUMORANG
4.33.25.2.04	293	AZKA GALUH BASUKI
4.33.25.2.05	294	BAGAS IDDEN LISTIYANTO
4.33.25.2.06	295	CHEETAH AMRULLAH SWASTIKA
4.33.25.2.07	296	DELA FAJAR MULIA
4.33.25.2.08	297	EVAN OCTAVIAN RAMADHAN
4.33.25.2.09	298	HADZIQ VINU MUFIDANY
4.33.25.2.10	299	IRGI AKBAR FAHLEVI
4.33.25.2.11	300	JATMIKO SATRIO WIBOWO
4.33.25.2.12	301	LAKSAMANA AGUNG HADI NUGROHO
4.33.25.2.13	302	MILADIYAH ARINAL HAQ
4.33.25.2.14	303	MUHAMMAD BARUNA SAYLENDRA
4.33.25.2.15	304	MUHAMMAD FADHIL
4.33.25.2.16	305	NAUFAL AZKA FADHLILLAH
4.33.25.2.17	306	NAZIFA CITRA NURVIANI
4.33.25.2.18	307	NIA SELVIA MAHDALENA
4.33.25.2.19	308	REIGZA NASYA PRATITHA RINGGIANI
4.33.25.2.20	309	RIZKY AKBAR ARDIANSYAH
4.33.25.2.21	310	SATRIA HATIM MARRENTO
4.33.25.2.22	311	THOMAS ANDROMEDA ELANG BUANA
4.33.25.2.23	312	ULFAN NAYAKA DIPTA
4.33.25.2.24	313	YUSUF RICKY HARTONO
4.33.25.2.25	314	ZIYAUL FALAH
4.33.24.0.01	315	ABIMANYU GILAR WALUYO
4.33.24.0.02	316	AHMAD CHOMSIN SYAHFRUDDIN
4.33.24.0.03	317	AISY TSABITA AMRU
4.33.24.0.04	318	AKBAR HAKIM MUZAKY
4.33.24.0.05	319	ALFIN ROZZAQ NIRWANA
4.33.24.0.06	320	ANISA NURWAHIDAH
4.33.24.0.07	321	BASITH ANUGRAH YAFI
4.33.24.0.08	322	BENAYYA NOHAN ADMIRALDO
4.33.24.0.09	323	DANISH MAHDI
4.33.24.0.10	324	EGIE AMILIA VELISDIONO
4.33.24.0.11	325	FEBY YUANGGI PUTRI
4.33.24.0.12	326	HANIF ALBANA ROZAD
4.33.24.0.13	327	INDRA WIJAYA
4.33.24.0.14	328	JONATHAN EDWARD SINAGA
4.33.24.0.15	329	KATRINA AGNI HARTANTO
4.33.24.0.16	330	MUHAMMAD ALMAHDI
4.33.24.0.17	331	MUHAMMAD FAISAL REZA MUSTOFA
4.33.24.0.18	332	MUHAMMAD RIZKY FADHILA
4.33.24.0.19	333	MUHAMMAD SYAUQI ALGHIFARI
4.33.24.0.20	334	NABILA RAMADANI
4.33.24.0.21	335	NANDA ARIFIA CHOERUNISA
4.33.24.0.22	336	RAFIF ALI FAHREZI
4.33.24.0.23	337	RAKI ABHISTA PRAKOSO
4.33.24.0.24	338	SALMA ZAHRA RAMADHANI
4.33.24.0.25	339	SATRIO ADZI PRIAMBODO
4.33.24.0.26	340	VIAN MAULANA RAMADHAN
4.33.24.1.01	341	ANISA FARCHA NOVIANI
4.33.24.1.02	342	ARJUNA NATHA PRATISENA
4.33.24.1.03	343	ARYODIMAS DZAKI WITRYAWAN
4.33.24.1.04	344	AZKA BARIQLANA
4.33.24.1.05	345	CAHYO GADHANG PUTRO BASKORO
4.33.24.1.06	346	CANTIKA ALIFIA MAHARANI
4.33.24.1.07	347	DEWANGGA RADITYA NUGROHO
4.33.24.1.08	348	EIREN WIBI HIDAYAT
4.33.24.1.09	349	GANANG SYAIFULLAH
4.33.24.1.10	350	HAFIZH IMAN WICAKSONO
4.33.24.1.11	351	KENCANA IKHSANUN NADJA
4.33.24.1.12	352	KHANSA INTANIA UTOMO
4.33.24.1.13	353	MI. AULIA KURNIA WIDYARANI
4.33.24.1.14	354	MUHAMMAD ASDIF AFADA
4.33.24.1.15	355	MUHAMMAD BINTANG SATRIO UTOMO
4.33.24.1.16	356	MUHAMMAD ILHAM RIJAL THAARIQ
4.33.24.1.17	357	MUHAMMAD MUMTAZA AL AFKAR
4.33.24.1.18	358	NAJWA RAHMA HAPSARI
4.33.24.1.19	359	PANDU SETYA NUGRAHA
4.33.24.1.20	360	PUTRI LEVINA AGATHA
4.33.24.1.21	361	RAUL HARYO FAUZIAN
4.33.24.1.22	362	RAY EGANS PRAMUDYA
4.33.24.1.23	363	RIKO ADITYA ZAKI
4.33.24.1.24	364	SENDI PRASETYO
4.33.24.1.25	365	SEPTIA ISNAENI SALSABILA
4.33.24.1.26	366	YUSUF FADHLIH FIRMANSYAH
4.33.24.2.01	367	ABYAN FAZA NARISWANGGA
4.33.24.2.02	368	ADILA DIMAZ BUWANA
4.33.24.2.03	369	ANNISA NAELIL IZATI
4.33.24.2.04	370	BAGASKARA
4.33.24.2.05	371	CEZAR NARESWARA RESPATI
4.33.24.2.06	372	DEVI IBNU NABILA
4.33.24.2.07	373	DIAH DWI ASTUTI
4.33.24.2.08	374	DIMAS ADHIE NUGROHO
4.33.24.2.10	375	GHUFRON AINUN NAJIB
4.33.24.2.11	376	IZZA BAGHUZ SYAFI'I MA'ARIF
4.33.24.2.12	377	M. OKSA SETYARSO
4.33.24.2.13	378	MUHAMMAD HIKMAL ALFARIDZY BACHTIAR
4.33.24.2.14	379	MUHAMMAD IBRAHIM
4.33.24.2.15	380	MUHAMMAD RAFA ENRICO
4.33.24.2.16	381	NABILA AZ ZAHRA MUNIR
4.33.24.2.17	382	PAULUS ALE KRISTIAWAN
4.33.24.2.18	383	RAJABA HAMIM MAUDUDI
4.33.24.2.19	384	RIZTIKA MERISTA INDRIANI
4.33.24.2.20	385	ROIHAN SAPUTRA
4.33.24.2.21	386	SITI MIFTAHUS SA'DIYAH
4.33.24.2.22	387	SRI PUJANGGA
4.33.24.2.23	388	TERRA SURYA NEGARI
4.33.24.2.24	389	ZALFA AZ ZAHRA
4.33.24.2.25	390	ZULFIKRI ARYA PUTRA ISMAIL
4.33.23.0.01	391	ADRIANSYAH ALFARISYI
4.33.23.0.02	392	AGUNG HADI ASTANTO
4.33.23.0.03	393	AHMAD FARKHANI
4.33.23.0.04	394	ANINDHA CAHYA MULIA SALIM
4.33.23.0.05	395	ARIF KURNIA RAHMAN
4.33.23.0.06	396	ATHAYA PANDU MARENO
4.33.23.0.07	397	DANIEL ADI PRATAMA
4.33.23.0.08	398	DAVIN ALIFIANDA ADYTIA
4.33.23.0.09	399	FAJAR DWI FIRMANSYAH
4.33.23.0.10	400	FITRIANA NAYLA NOVIANTI
4.33.23.0.11	401	GILANG MAULANATA PRAMUDYA
4.33.23.0.13	402	ILHAM TARUPRASETYO
4.33.23.0.14	403	IRMA INNAYAH
4.33.23.0.15	404	KHILDA SALSABILA AZKA
4.33.23.0.16	405	MARVELLINA DEVI WURDHANING
4.33.23.0.17	406	MAULANA FAJAR ROHMANI
4.33.23.0.18	407	MILA ROSITA DEWI
4.33.23.0.19	408	MUHAMAD HAYDAR AYDIN ALHAMDANI
4.33.23.0.20	409	MUHAMMAD SYAUQI MAULANA ANANSYAH
4.33.23.0.21	410	MUHAMMAD ZAKIY FADHLULLAH AZHAR
4.33.23.0.22	411	RACHMAD YOGO DWIYANTO
4.33.23.0.23	412	RAFI ARTHAYANA PUTRA DERIZMA
4.33.23.0.26	413	TUBAGUS PRATAMA JULIANTO
4.33.22.1.25	414	TITO WAHYU PRATAMA
4.33.23.1.01	415	AHMAD RIZKIADI BUDI WIRAWAN
4.33.23.1.02	416	AKSOBHYA SAMATHA VARGA
4.33.23.1.03	417	ANINDITA NAJWA EKA SABRINA
4.33.23.1.04	418	ATSIILA ARYA NABIIH
4.33.23.1.05	419	AZANI FATTUR FADHIKA
4.33.23.1.06	420	DANU ALAMSYAH PUTRA
4.33.23.1.07	421	FAISHAL ANANDA RACHMAN
4.33.23.1.08	422	FAJAR WAHYU SURYAPUTRA
4.33.23.1.09	423	HANIF ABDUSY SYAKUR
4.33.23.1.10	424	HELSA CHRISTABEL HARSONO
4.33.23.1.11	425	IBRAHIM ARYAN FARIDZI
4.33.23.1.12	426	IVAN RAKHA ADINATA
4.33.23.1.13	427	JONATHAN ORDRICK EDRA WIJAYA
4.33.23.1.15	428	MIFTACHUSSURUR
4.33.23.1.16	429	MUHAMAD RIFKI SURYA PRATAMA
4.33.23.1.17	430	MUHAMMAD FATWA SYAIKHONI
4.33.23.1.18	431	MUHAMMAD RAFIF PASYA
4.33.23.1.19	432	NICHOLAS ERNESTO ANAK AGUNG
4.33.23.1.20	433	RAHMALYANA AYUNINGTYAS
4.33.23.1.21	434	RASYAD TANZILUR RAHMAN
4.33.23.1.22	435	ROHIMATUN NURIN NADHIFAH
4.33.23.1.23	436	TARISHA NAILA ANGELIN
4.33.23.1.24	437	TRISTAN EKA WIRANATA
4.33.23.1.25	438	WARSENO BAMBANG SETYONO
4.33.23.2.01	439	ADINDA RAHIMAH AZZAHRA
4.33.23.2.02	440	ADJIE RADHITYA KUSSENA
4.33.23.2.03	441	ADNAN BIMA ADHI NUGRAHA
4.33.23.2.04	442	ALDO RAMADHANA
4.33.23.2.05	443	AMMAR LUQMAN ARIFIN
4.33.23.2.06	444	ANINDITA RAHMA AZALIA
4.33.23.2.07	445	AZKA NUR FADEL
4.33.23.2.08	446	BAGUS SADEWA
4.33.23.2.09	447	CHALLISTA RISKIANA
4.33.23.2.10	448	DIRGA PRIYANTO
4.33.23.2.11	449	FAIZ AKMAL NURHAKIM
4.33.23.2.12	450	FATHURRAFI NADIO BUSONO
4.33.23.2.13	451	GHAFARI ARIF JABBAR
4.33.23.2.14	452	HASNA RUMAISHA
4.33.23.2.15	453	ILHAM AJI IRAWAN
4.33.23.2.16	454	ILHAM INDRA ATMAJA
4.33.23.2.17	455	MUHAMAD ZA'IM SETYAWAN
4.33.23.2.18	456	MUHAMMAD DZAKY JAMALUDDIN
4.33.23.2.19	457	MUHAMMAD HAIDAR ALY
4.33.23.2.20	458	MUHAMMAD IMAM MUSTOFA KAMAL
4.33.23.2.21	459	MUHAMMAD JANUAR RIFQI NANDA
4.33.23.2.22	460	MUHAMMAD ROOZIQIN
4.33.23.2.23	461	PRABASWARA SHAFA AZARIOMA
4.33.23.2.24	462	SAHARDIAN PUTRA WIGUNA
4.33.23.2.25	463	SALWA SALSABILA DAFFA'ATULHAQ
4.33.23.2.26	464	ZULVIKAR KHARISMA NUR MUHAMMAD
\.


--
-- TOC entry 5229 (class 0 OID 19118)
-- Dependencies: 222
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menus (id, key, label, icon, path, urutan, parent_id, created_at) FROM stdin;
1	dashboard	Dashboard	LayoutDashboard	/user/dashboard	1	\N	2026-04-20 16:48:48.500836
3	ekuivalensi	Ekuivalensi	BookOpen	/user/ekuivalensi	3	\N	2026-04-20 16:48:48.500836
2	pekerjaan	List Pekerjaan	Briefcase	/user/list_perkerjaan	2	\N	2026-04-20 16:48:48.500836
\.


--
-- TOC entry 5231 (class 0 OID 19139)
-- Dependencies: 224
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
-- TOC entry 5258 (class 0 OID 19439)
-- Dependencies: 251
-- Data for Name: penugasan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.penugasan (id, pekerjaan_id, nim, status_tugas_id, detail_pengerjaan, catatan_verifikasi, diverifikasi_oleh_nip, waktu_verifikasi, created_at, updated_at) FROM stdin;
2	1	220101002	3	{"file": "/tugas/budi_perpus.pdf", "progress": 100}	\N	\N	\N	2024-09-21 09:00:00	2024-10-10 10:00:00
3	2	220101003	4	{"laporan": "Bersih semua lab", "progress": 100}	Pekerjaan rapi	197501012005011001	2024-12-10 14:00:00	2024-09-25 10:00:00	2024-12-10 14:00:00
4	2	220101004	2	{"catatan": "Masih proses", "progress": 60}	\N	\N	\N	2024-09-26 11:00:00	2024-12-05 09:00:00
5	2	220101005	1	{"progress": 0}	\N	\N	\N	2024-09-27 08:30:00	\N
6	3	220102001	4	{"file": "/tugas/fajar_keuangan.xlsx", "progress": 100}	Data lengkap	197502022006021002	2024-10-20 11:00:00	2024-09-15 13:00:00	2024-10-20 11:00:00
7	4	220105001	4	{"feedback": "Membantu banget", "progress": 100}	Tutor yang baik	197503032007031003	2024-11-15 15:30:00	2024-09-25 09:00:00	2024-11-15 15:30:00
9	5	220101001	4	{"file": "/tugas/andi_survey.xlsx", "progress": 100}	Data lengkap 100 responden	197501012005011001	2024-10-28 10:00:00	2024-10-05 09:00:00	2024-10-28 10:00:00
10	6	220105001	4	{"nilai": "A", "progress": 100}	Asisten yang baik	198001042008041001	2024-12-05 13:00:00	2024-09-15 14:00:00	2024-12-05 13:00:00
11	6	220105002	2	{"progress": 50}	\N	\N	\N	2024-09-16 09:00:00	2024-11-20 10:00:00
12	7	220103001	1	{"progress": 0}	\N	\N	\N	2024-10-01 10:00:00	\N
1	1	2372001	3	{"fileName": "bukti_1_1777879512867.jpg"}	Selesai dengan baik	197501012005011001	2024-10-15 09:00:00	2024-09-20 08:00:00	2026-05-04 07:25:12.873
13	1	210101001	1	\N	\N	\N	\N	2026-05-04 07:32:58.815	\N
14	1	210101002	1	\N	\N	\N	\N	2026-05-04 07:32:58.824	\N
15	1	220101001	1	\N	\N	\N	\N	2026-05-04 07:32:58.827	\N
16	1	220101002	1	\N	\N	\N	\N	2026-05-04 07:32:58.831	\N
17	1	220101003	1	\N	\N	\N	\N	2026-05-04 07:32:58.847	\N
18	2	220102001	1	\N	\N	\N	\N	2026-05-04 07:32:58.853	\N
19	2	220102002	1	\N	\N	\N	\N	2026-05-04 07:32:58.859	\N
20	2	220104001	1	\N	\N	\N	\N	2026-05-04 07:32:58.865	\N
21	2	220105001	1	\N	\N	\N	\N	2026-05-04 07:32:58.87	\N
22	2	220105003	1	\N	\N	\N	\N	2026-05-04 07:32:58.873	\N
23	2	220106001	1	\N	\N	\N	\N	2026-05-04 07:32:58.878	\N
24	2	4.33.22.1.25	1	\N	\N	\N	\N	2026-05-04 07:32:58.881	\N
25	2	4.33.23.0.01	1	\N	\N	\N	\N	2026-05-04 07:32:58.886	\N
26	3	4.33.23.0.03	1	\N	\N	\N	\N	2026-05-04 07:32:58.891	\N
27	3	4.33.23.0.06	1	\N	\N	\N	\N	2026-05-04 07:32:58.898	\N
28	3	4.33.23.0.11	1	\N	\N	\N	\N	2026-05-04 07:32:58.902	\N
29	8	4.33.23.0.17	1	\N	\N	\N	\N	2026-05-04 07:32:58.906	\N
30	8	4.33.23.0.18	1	\N	\N	\N	\N	2026-05-04 07:32:58.911	\N
31	9	4.33.23.0.26	1	\N	\N	\N	\N	2026-05-04 07:32:58.915	\N
32	9	4.33.23.1.16	1	\N	\N	\N	\N	2026-05-04 07:32:58.919	\N
33	9	4.33.23.1.17	1	\N	\N	\N	\N	2026-05-04 07:32:58.923	\N
34	9	4.33.23.1.24	1	\N	\N	\N	\N	2026-05-04 07:32:58.927	\N
35	4	4.33.23.2.02	1	\N	\N	\N	\N	2026-05-04 07:32:58.932	\N
36	4	4.33.23.2.03	1	\N	\N	\N	\N	2026-05-04 07:32:58.935	\N
37	4	4.33.23.2.07	1	\N	\N	\N	\N	2026-05-04 07:32:58.94	\N
38	4	4.33.23.2.10	1	\N	\N	\N	\N	2026-05-04 07:32:58.943	\N
39	4	4.33.23.2.11	1	\N	\N	\N	\N	2026-05-04 07:32:58.947	\N
40	4	4.33.23.2.13	1	\N	\N	\N	\N	2026-05-04 07:32:58.949	\N
41	4	4.33.23.2.16	1	\N	\N	\N	\N	2026-05-04 07:32:58.953	\N
42	4	4.33.23.2.20	1	\N	\N	\N	\N	2026-05-04 07:32:58.956	\N
43	5	4.33.23.2.22	1	\N	\N	\N	\N	2026-05-04 07:32:58.961	\N
44	5	4.33.23.2.23	1	\N	\N	\N	\N	2026-05-04 07:32:58.964	\N
45	5	4.33.23.2.24	1	\N	\N	\N	\N	2026-05-04 07:32:58.969	\N
46	5	4.33.23.2.26	1	\N	\N	\N	\N	2026-05-04 07:32:58.975	\N
47	5	4.33.24.0.01	1	\N	\N	\N	\N	2026-05-04 07:32:58.978	\N
48	5	4.33.24.0.06	1	\N	\N	\N	\N	2026-05-04 07:32:58.982	\N
49	5	4.33.24.1.07	1	\N	\N	\N	\N	2026-05-04 07:32:58.985	\N
50	5	4.33.24.1.08	1	\N	\N	\N	\N	2026-05-04 07:32:58.989	\N
51	5	4.33.24.1.13	1	\N	\N	\N	\N	2026-05-04 07:32:58.998	\N
52	5	4.33.24.2.17	1	\N	\N	\N	\N	2026-05-04 07:32:59.002	\N
53	5	4.33.24.2.20	1	\N	\N	\N	\N	2026-05-04 07:32:59.005	\N
54	5	4.33.24.2.22	1	\N	\N	\N	\N	2026-05-04 07:32:59.009	\N
55	5	4.33.24.2.23	1	\N	\N	\N	\N	2026-05-04 07:32:59.013	\N
56	5	4.33.24.2.25	1	\N	\N	\N	\N	2026-05-04 07:32:59.016	\N
57	5	4.33.25.0.06	1	\N	\N	\N	\N	2026-05-04 07:32:59.019	\N
58	6	4.33.25.0.21	1	\N	\N	\N	\N	2026-05-04 07:32:59.024	\N
59	6	4.33.25.1.05	1	\N	\N	\N	\N	2026-05-04 07:32:59.027	\N
60	6	4.33.25.1.24	1	\N	\N	\N	\N	2026-05-04 07:32:59.031	\N
61	6	4.33.25.2.01	1	\N	\N	\N	\N	2026-05-04 07:32:59.034	\N
62	7	4.33.25.2.04	1	\N	\N	\N	\N	2026-05-04 07:32:59.038	\N
63	7	4.33.25.2.10	1	\N	\N	\N	\N	2026-05-04 07:32:59.041	\N
64	11	4.33.25.2.12	1	\N	\N	\N	\N	2026-05-04 07:32:59.045	\N
65	11	4.33.25.2.20	1	\N	\N	\N	\N	2026-05-04 07:32:59.047	\N
66	11	4.33.25.2.23	1	\N	\N	\N	\N	2026-05-04 07:32:59.052	\N
67	11	210101001	1	\N	\N	\N	\N	2026-05-04 07:32:59.057	\N
68	11	210101002	1	\N	\N	\N	\N	2026-05-04 07:32:59.06	\N
8	4	220105002	2	{"catatan": "Tinggal 2 sesi lagi", "progress": 80}	gblk	\N	\N	2024-09-26 10:00:00	2024-11-10 14:00:00
\.


--
-- TOC entry 5233 (class 0 OID 19160)
-- Dependencies: 226
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
-- TOC entry 5234 (class 0 OID 19173)
-- Dependencies: 227
-- Data for Name: ref_status_ekuivalensi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_ekuivalensi (id, nama) FROM stdin;
1	Menunggu Verifikasi
2	Disetujui
3	Ditolak
4	Revisi
\.


--
-- TOC entry 5235 (class 0 OID 19181)
-- Dependencies: 228
-- Data for Name: ref_status_import; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_status_import (id, nama) FROM stdin;
1	Proses
2	Berhasil
3	Gagal
4	Partial
\.


--
-- TOC entry 5236 (class 0 OID 19189)
-- Dependencies: 229
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
-- TOC entry 5237 (class 0 OID 19197)
-- Dependencies: 230
-- Data for Name: ref_tipe_pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ref_tipe_pekerjaan (id, nama) FROM stdin;
1	Internal
2	External
\.


--
-- TOC entry 5264 (class 0 OID 19935)
-- Dependencies: 258
-- Data for Name: registrasi_mahasiswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registrasi_mahasiswa (id, nim, semester_id, kelas_id, status) FROM stdin;
1	4.33.25.0.01	1	16	Aktif
2	4.33.25.0.02	1	16	Aktif
3	4.33.25.0.03	1	16	Aktif
4	4.33.25.0.04	1	16	Aktif
5	4.33.25.0.05	1	16	Aktif
6	4.33.25.0.06	1	16	Aktif
7	4.33.25.0.07	1	16	Aktif
8	4.33.25.0.08	1	16	Aktif
9	4.33.25.0.09	1	16	Aktif
10	4.33.25.0.10	1	16	Aktif
11	4.33.25.0.11	1	16	Aktif
12	4.33.25.0.12	1	16	Aktif
13	4.33.25.0.13	1	16	Aktif
14	4.33.25.0.14	1	16	Aktif
15	4.33.25.0.15	1	16	Aktif
16	4.33.25.0.16	1	16	Aktif
17	4.33.25.0.17	1	16	Aktif
18	4.33.25.0.18	1	16	Aktif
19	4.33.25.0.19	1	16	Aktif
20	4.33.25.0.20	1	16	Aktif
21	4.33.25.0.21	1	16	Aktif
22	4.33.25.0.22	1	16	Aktif
23	4.33.25.0.23	1	16	Aktif
24	4.33.25.0.24	1	16	Aktif
25	4.33.25.0.25	1	16	Aktif
26	4.33.25.1.01	1	17	Aktif
27	4.33.25.1.02	1	17	Aktif
28	4.33.25.1.03	1	17	Aktif
29	4.33.25.1.04	1	17	Aktif
30	4.33.25.1.05	1	17	Aktif
31	4.33.25.1.06	1	17	Aktif
32	4.33.25.1.07	1	17	Aktif
33	4.33.25.1.08	1	17	Aktif
34	4.33.25.1.09	1	17	Aktif
35	4.33.25.1.10	1	17	Aktif
36	4.33.25.1.11	1	17	Aktif
37	4.33.25.1.12	1	17	Aktif
38	4.33.25.1.13	1	17	Aktif
39	4.33.25.1.14	1	17	Aktif
40	4.33.25.1.15	1	17	Aktif
41	4.33.25.1.16	1	17	Aktif
42	4.33.25.1.17	1	17	Aktif
43	4.33.25.1.18	1	17	Aktif
44	4.33.25.1.19	1	17	Aktif
45	4.33.25.1.20	1	17	Aktif
46	4.33.25.1.21	1	17	Aktif
47	4.33.25.1.22	1	17	Aktif
48	4.33.25.1.23	1	17	Aktif
49	4.33.25.1.24	1	17	Aktif
50	4.33.25.1.25	1	17	Aktif
51	4.33.25.1.26	1	17	Aktif
52	4.33.25.2.01	1	18	Aktif
53	4.33.25.2.02	1	18	Aktif
54	4.33.25.2.03	1	18	Aktif
55	4.33.25.2.04	1	18	Aktif
56	4.33.25.2.05	1	18	Aktif
57	4.33.25.2.06	1	18	Aktif
58	4.33.25.2.07	1	18	Aktif
59	4.33.25.2.08	1	18	Aktif
60	4.33.25.2.09	1	18	Aktif
61	4.33.25.2.10	1	18	Aktif
62	4.33.25.2.11	1	18	Aktif
63	4.33.25.2.12	1	18	Aktif
64	4.33.25.2.13	1	18	Aktif
65	4.33.25.2.14	1	18	Aktif
66	4.33.25.2.15	1	18	Aktif
67	4.33.25.2.16	1	18	Aktif
68	4.33.25.2.17	1	18	Aktif
69	4.33.25.2.18	1	18	Aktif
70	4.33.25.2.19	1	18	Aktif
71	4.33.25.2.20	1	18	Aktif
72	4.33.25.2.21	1	18	Aktif
73	4.33.25.2.22	1	18	Aktif
74	4.33.25.2.23	1	18	Aktif
75	4.33.25.2.24	1	18	Aktif
76	4.33.25.2.25	1	18	Aktif
77	4.33.24.0.01	1	19	Aktif
78	4.33.24.0.02	1	19	Aktif
79	4.33.24.0.03	1	19	Aktif
80	4.33.24.0.04	1	19	Aktif
81	4.33.24.0.05	1	19	Aktif
82	4.33.24.0.06	1	19	Aktif
83	4.33.24.0.07	1	19	Aktif
84	4.33.24.0.08	1	19	Aktif
85	4.33.24.0.09	1	19	Aktif
86	4.33.24.0.10	1	19	Aktif
87	4.33.24.0.11	1	19	Aktif
88	4.33.24.0.12	1	19	Aktif
89	4.33.24.0.13	1	19	Aktif
90	4.33.24.0.14	1	19	Aktif
91	4.33.24.0.15	1	19	Aktif
92	4.33.24.0.16	1	19	Aktif
93	4.33.24.0.17	1	19	Aktif
94	4.33.24.0.18	1	19	Aktif
95	4.33.24.0.19	1	19	Aktif
96	4.33.24.0.20	1	19	Aktif
97	4.33.24.0.21	1	19	Aktif
98	4.33.24.0.22	1	19	Aktif
99	4.33.24.0.23	1	19	Aktif
100	4.33.24.0.24	1	19	Aktif
101	4.33.24.0.25	1	19	Aktif
102	4.33.24.0.26	1	19	Aktif
103	4.33.24.1.01	1	20	Aktif
104	4.33.24.1.02	1	20	Aktif
105	4.33.24.1.03	1	20	Aktif
106	4.33.24.1.04	1	20	Aktif
107	4.33.24.1.05	1	20	Aktif
108	4.33.24.1.06	1	20	Aktif
109	4.33.24.1.07	1	20	Aktif
110	4.33.24.1.08	1	20	Aktif
111	4.33.24.1.09	1	20	Aktif
112	4.33.24.1.10	1	20	Aktif
113	4.33.24.1.11	1	20	Aktif
114	4.33.24.1.12	1	20	Aktif
115	4.33.24.1.13	1	20	Aktif
116	4.33.24.1.14	1	20	Aktif
117	4.33.24.1.15	1	20	Aktif
118	4.33.24.1.16	1	20	Aktif
119	4.33.24.1.17	1	20	Aktif
120	4.33.24.1.18	1	20	Aktif
121	4.33.24.1.19	1	20	Aktif
122	4.33.24.1.20	1	20	Aktif
123	4.33.24.1.21	1	20	Aktif
124	4.33.24.1.22	1	20	Aktif
125	4.33.24.1.23	1	20	Aktif
126	4.33.24.1.24	1	20	Aktif
127	4.33.24.1.25	1	20	Aktif
128	4.33.24.1.26	1	20	Aktif
129	4.33.24.2.01	1	21	Aktif
130	4.33.24.2.02	1	21	Aktif
131	4.33.24.2.03	1	21	Aktif
132	4.33.24.2.04	1	21	Aktif
133	4.33.24.2.05	1	21	Aktif
134	4.33.24.2.06	1	21	Aktif
135	4.33.24.2.07	1	21	Aktif
136	4.33.24.2.08	1	21	Aktif
137	4.33.24.2.10	1	21	Aktif
138	4.33.24.2.11	1	21	Aktif
139	4.33.24.2.12	1	21	Aktif
140	4.33.24.2.13	1	21	Aktif
141	4.33.24.2.14	1	21	Aktif
142	4.33.24.2.15	1	21	Aktif
143	4.33.24.2.16	1	21	Aktif
144	4.33.24.2.17	1	21	Aktif
145	4.33.24.2.18	1	21	Aktif
146	4.33.24.2.19	1	21	Aktif
147	4.33.24.2.20	1	21	Aktif
148	4.33.24.2.21	1	21	Aktif
149	4.33.24.2.22	1	21	Aktif
150	4.33.24.2.23	1	21	Aktif
151	4.33.24.2.24	1	21	Aktif
152	4.33.24.2.25	1	21	Aktif
153	4.33.23.0.01	1	22	Aktif
154	4.33.23.0.02	1	22	Aktif
155	4.33.23.0.03	1	22	Aktif
156	4.33.23.0.04	1	22	Aktif
157	4.33.23.0.05	1	22	Aktif
158	4.33.23.0.06	1	22	Aktif
159	4.33.23.0.07	1	22	Aktif
160	4.33.23.0.08	1	22	Aktif
161	4.33.23.0.09	1	22	Aktif
162	4.33.23.0.10	1	22	Aktif
163	4.33.23.0.11	1	22	Aktif
164	4.33.23.0.13	1	22	Aktif
165	4.33.23.0.14	1	22	Aktif
166	4.33.23.0.15	1	22	Aktif
167	4.33.23.0.16	1	22	Aktif
168	4.33.23.0.17	1	22	Aktif
169	4.33.23.0.18	1	22	Aktif
170	4.33.23.0.19	1	22	Aktif
171	4.33.23.0.20	1	22	Aktif
172	4.33.23.0.21	1	22	Aktif
173	4.33.23.0.22	1	22	Aktif
174	4.33.23.0.23	1	22	Aktif
175	4.33.23.0.26	1	22	Aktif
176	4.33.22.1.25	1	23	Aktif
177	4.33.23.1.01	1	23	Aktif
178	4.33.23.1.02	1	23	Aktif
179	4.33.23.1.03	1	23	Aktif
180	4.33.23.1.04	1	23	Aktif
181	4.33.23.1.05	1	23	Aktif
182	4.33.23.1.06	1	23	Aktif
183	4.33.23.1.07	1	23	Aktif
184	4.33.23.1.08	1	23	Aktif
185	4.33.23.1.09	1	23	Aktif
186	4.33.23.1.10	1	23	Aktif
187	4.33.23.1.11	1	23	Aktif
188	4.33.23.1.12	1	23	Aktif
189	4.33.23.1.13	1	23	Aktif
190	4.33.23.1.15	1	23	Aktif
191	4.33.23.1.16	1	23	Aktif
192	4.33.23.1.17	1	23	Aktif
193	4.33.23.1.18	1	23	Aktif
194	4.33.23.1.19	1	23	Aktif
195	4.33.23.1.20	1	23	Aktif
196	4.33.23.1.21	1	23	Aktif
197	4.33.23.1.22	1	23	Aktif
198	4.33.23.1.23	1	23	Aktif
199	4.33.23.1.24	1	23	Aktif
200	4.33.23.1.25	1	23	Aktif
201	4.33.23.2.01	1	24	Aktif
202	4.33.23.2.02	1	24	Aktif
203	4.33.23.2.03	1	24	Aktif
204	4.33.23.2.04	1	24	Aktif
205	4.33.23.2.05	1	24	Aktif
206	4.33.23.2.06	1	24	Aktif
207	4.33.23.2.07	1	24	Aktif
208	4.33.23.2.08	1	24	Aktif
209	4.33.23.2.09	1	24	Aktif
210	4.33.23.2.10	1	24	Aktif
211	4.33.23.2.11	1	24	Aktif
212	4.33.23.2.12	1	24	Aktif
213	4.33.23.2.13	1	24	Aktif
214	4.33.23.2.14	1	24	Aktif
215	4.33.23.2.15	1	24	Aktif
216	4.33.23.2.16	1	24	Aktif
217	4.33.23.2.17	1	24	Aktif
218	4.33.23.2.18	1	24	Aktif
219	4.33.23.2.19	1	24	Aktif
220	4.33.23.2.20	1	24	Aktif
221	4.33.23.2.21	1	24	Aktif
222	4.33.23.2.22	1	24	Aktif
223	4.33.23.2.23	1	24	Aktif
224	4.33.23.2.24	1	24	Aktif
225	4.33.23.2.25	1	24	Aktif
226	4.33.23.2.26	1	24	Aktif
\.


--
-- TOC entry 5238 (class 0 OID 19205)
-- Dependencies: 231
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nama, key_menu, key_condition) FROM stdin;
1	Super Admin	["all"]	{"all": true}
2	Staf Jurusan	["daftar_pekerjaan", "penugasan", "verifikasi"]	{"jurusan_only": true}
3	Mahasiswa	["pekerjaan", "riwayat", "profil"]	{"self_only": true}
4	Dosen	["verifikasi", "laporan"]	{"jurusan_only": true}
\.


--
-- TOC entry 5249 (class 0 OID 19314)
-- Dependencies: 242
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
-- TOC entry 5240 (class 0 OID 19223)
-- Dependencies: 233
-- Data for Name: semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester (id, nama, tahun, periode, is_aktif, mulai, selesai) FROM stdin;
1	Ganjil 2024/2025	2024	Ganjil	t	2024-09-01	2025-01-15
2	Genap 2023/2024	2024	Genap	f	2024-02-01	2024-06-30
3	Ganjil 2023/2024	2023	Ganjil	f	2023-09-01	2024-01-15
4	Pendek 2024	2024	Pendek	f	2024-07-01	2024-08-30
\.


--
-- TOC entry 5245 (class 0 OID 19279)
-- Dependencies: 238
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
-- TOC entry 5242 (class 0 OID 19243)
-- Dependencies: 235
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
239	43325001@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.636
240	43325002@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.669
241	43325003@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.683
242	43325004@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.703
243	43325005@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.717
244	43325006@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.736
245	43325007@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.75
246	43325008@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.766
247	43325009@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.78
248	43325010@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.795
249	43325011@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.811
250	43325012@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.826
251	43325013@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.843
252	43325014@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.863
253	43325015@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.877
254	43325016@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.892
255	43325017@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.908
256	43325018@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.923
257	43325019@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.939
258	43325020@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.954
259	43325021@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.966
260	43325022@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.982
261	43325023@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:25.996
262	43325024@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.014
263	43325025@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.028
264	43325101@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.044
265	43325102@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.059
266	43325103@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.077
267	43325104@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.093
268	43325105@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.104
269	43325106@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.124
270	43325107@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.139
271	43325108@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.158
272	43325109@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.174
273	43325110@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.195
274	43325111@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.208
275	43325112@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.226
276	43325113@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.242
277	43325114@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.26
278	43325115@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.274
279	43325116@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.289
280	43325117@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.303
281	43325118@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.316
282	43325119@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.334
283	43325120@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.351
284	43325121@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.367
285	43325122@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.381
286	43325123@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.399
287	43325124@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.413
288	43325125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.429
289	43325126@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.45
290	43325201@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.466
291	43325202@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.48
292	43325203@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.521
293	43325204@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.535
294	43325205@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.549
295	43325206@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.565
296	43325207@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.577
297	43325208@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.592
298	43325209@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.609
299	43325210@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.622
300	43325211@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.639
301	43325212@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.653
302	43325213@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.671
303	43325214@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.685
304	43325215@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.704
305	43325216@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.717
306	43325217@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.732
307	43325218@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.747
308	43325219@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.761
309	43325220@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.778
310	43325221@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.791
311	43325222@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.808
312	43325223@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.832
313	43325224@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.844
314	43325225@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.856
315	43324001@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.872
316	43324002@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.887
317	43324003@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.9
318	43324004@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.916
319	43324005@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.927
320	43324006@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.939
321	43324007@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.954
322	43324008@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.966
323	43324009@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.98
324	43324010@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:26.994
325	43324011@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.01
326	43324012@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.026
327	43324013@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.039
328	43324014@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.055
329	43324015@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.071
330	43324016@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.087
331	43324017@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.102
332	43324018@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.116
333	43324019@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.129
334	43324020@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.143
335	43324021@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.155
336	43324022@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.166
337	43324023@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.179
338	43324024@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.194
339	43324025@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.206
340	43324026@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.217
341	43324101@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.23
342	43324102@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.241
343	43324103@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.256
344	43324104@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.271
345	43324105@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.282
346	43324106@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.297
347	43324107@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.31
348	43324108@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.32
349	43324109@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.334
350	43324110@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.344
351	43324111@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.355
352	43324112@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.37
353	43324113@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.38
354	43324114@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.392
355	43324115@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.405
356	43324116@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.419
357	43324117@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.433
358	43324118@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.444
359	43324119@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.459
360	43324120@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.473
361	43324121@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.483
362	43324122@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.498
363	43324123@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.512
364	43324124@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.523
365	43324125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.537
366	43324126@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.548
367	43324201@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.559
368	43324202@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.573
369	43324203@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.583
370	43324204@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.594
371	43324205@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.609
372	43324206@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.621
373	43324207@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.634
374	43324208@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.654
375	43324210@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.664
376	43324211@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.68
377	43324212@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.692
378	43324213@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.706
379	43324214@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.721
380	43324215@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.735
381	43324216@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.749
382	43324217@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.763
383	43324218@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.775
384	43324219@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.788
385	43324220@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.801
386	43324221@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.816
387	43324222@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.831
388	43324223@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.845
389	43324224@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.857
390	43324225@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.875
391	43323001@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.891
392	43323002@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.903
393	43323003@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.916
394	43323004@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.928
395	43323005@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.937
396	43323006@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.946
397	43323007@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.96
398	43323008@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.972
399	43323009@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:27.989
400	43323010@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.002
401	43323011@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.013
402	43323013@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.026
403	43323014@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.037
404	43323015@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.047
405	43323016@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.061
406	43323017@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.07
407	43323018@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.082
408	43323019@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.098
409	43323020@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.111
410	43323021@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.123
411	43323022@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.134
412	43323023@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.145
413	43323026@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.155
414	43322125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.17
415	43323101@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.18
416	43323102@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.193
417	43323103@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.206
418	43323104@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.222
419	43323105@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.238
420	43323106@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.254
421	43323107@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.27
422	43323108@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.284
423	43323109@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.302
424	43323110@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.319
425	43323111@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.334
426	43323112@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.346
427	43323113@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.359
428	43323115@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.373
429	43323116@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.387
430	43323117@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.402
431	43323118@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.417
432	43323119@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.43
433	43323120@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.449
434	43323121@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.464
435	43323122@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.48
436	43323123@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.493
437	43323124@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.507
438	43323125@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.526
439	43323201@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.55
440	43323202@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.568
441	43323203@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.594
442	43323204@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.615
443	43323205@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.631
444	43323206@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.661
445	43323207@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.682
446	43323208@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.7
447	43323209@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.721
448	43323210@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.735
449	43323211@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.762
450	43323212@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.776
451	43323213@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.792
452	43323214@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.806
453	43323215@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.822
454	43323216@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.836
455	43323217@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.858
456	43323218@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.871
457	43323219@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.885
458	43323220@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.902
459	43323221@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.916
460	43323222@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.932
461	43323223@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.946
462	43323224@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.963
463	43323225@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.978
464	43323226@student.polines.ac.id	$2b$10$JVyMAKcR7Hzs9lE67rDy6.uYroo9O7q3nIWXZW8L1xTNOTSWk31Na	3	2026-05-03 13:18:28.995
12	2372001@student.polines.ac.id	$2b$10$nahxFaFGgEpxGBb2iDZwBeG7a3mbEpFEAXQ.xMaJUj9C2fhZBkh4K	\N	2026-04-27 23:26:57.954988
\.


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 244
-- Name: daftar_pekerjaan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daftar_pekerjaan_id_seq', 12, true);


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 248
-- Name: ekuivalensi_kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ekuivalensi_kelas_id_seq', 6, true);


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 236
-- Name: gedung_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gedung_id_seq', 7, true);


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 246
-- Name: import_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.import_log_id_seq', 11, true);


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 219
-- Name: jurusan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jurusan_id_seq', 4, true);


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 239
-- Name: kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kelas_id_seq', 24, true);


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 252
-- Name: kompen_awal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kompen_awal_id_seq', 245, true);


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 254
-- Name: log_potong_jam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_potong_jam_id_seq', 13, true);


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 221
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menus_id_seq', 11, true);


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 223
-- Name: pengaturan_sistem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pengaturan_sistem_id_seq', 7, true);


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 250
-- Name: penugasan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.penugasan_id_seq', 68, true);


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 225
-- Name: prodi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prodi_id_seq', 10, true);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 257
-- Name: registrasi_mahasiswa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registrasi_mahasiswa_id_seq', 226, true);


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 241
-- Name: ruangan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ruangan_id_seq', 12, true);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 232
-- Name: semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semester_id_seq', 4, true);


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 234
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 464, true);


--
-- TOC entry 5026 (class 2606 OID 19357)
-- Name: daftar_pekerjaan daftar_pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_pkey PRIMARY KEY (id);


--
-- TOC entry 5030 (class 2606 OID 19412)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_pkey PRIMARY KEY (id);


--
-- TOC entry 5012 (class 2606 OID 19273)
-- Name: gedung gedung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedung
    ADD CONSTRAINT gedung_pkey PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 19387)
-- Name: import_log import_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 19077)
-- Name: jurusan jurusan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jurusan
    ADD CONSTRAINT jurusan_pkey PRIMARY KEY (id);


--
-- TOC entry 5018 (class 2606 OID 19307)
-- Name: kelas kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_pkey PRIMARY KEY (id);


--
-- TOC entry 5034 (class 2606 OID 19477)
-- Name: kompen_awal kompen_awal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_pkey PRIMARY KEY (id);


--
-- TOC entry 5036 (class 2606 OID 19502)
-- Name: log_potong_jam log_potong_jam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_pkey PRIMARY KEY (id);


--
-- TOC entry 5022 (class 2606 OID 19334)
-- Name: mahasiswa mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (nim);


--
-- TOC entry 5024 (class 2606 OID 19336)
-- Name: mahasiswa mahasiswa_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_user_id_key UNIQUE (user_id);


--
-- TOC entry 4986 (class 2606 OID 19132)
-- Name: menus menus_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_key_key UNIQUE (key);


--
-- TOC entry 4988 (class 2606 OID 19130)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- TOC entry 4990 (class 2606 OID 19148)
-- Name: pengaturan_sistem pengaturan_sistem_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengaturan_sistem
    ADD CONSTRAINT pengaturan_sistem_key_key UNIQUE (key);


--
-- TOC entry 4992 (class 2606 OID 19146)
-- Name: pengaturan_sistem pengaturan_sistem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengaturan_sistem
    ADD CONSTRAINT pengaturan_sistem_pkey PRIMARY KEY (id);


--
-- TOC entry 5032 (class 2606 OID 19447)
-- Name: penugasan penugasan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_pkey PRIMARY KEY (id);


--
-- TOC entry 4994 (class 2606 OID 19167)
-- Name: prodi prodi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodi
    ADD CONSTRAINT prodi_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 19180)
-- Name: ref_status_ekuivalensi ref_status_ekuivalensi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_ekuivalensi
    ADD CONSTRAINT ref_status_ekuivalensi_pkey PRIMARY KEY (id);


--
-- TOC entry 4998 (class 2606 OID 19188)
-- Name: ref_status_import ref_status_import_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_import
    ADD CONSTRAINT ref_status_import_pkey PRIMARY KEY (id);


--
-- TOC entry 5000 (class 2606 OID 19196)
-- Name: ref_status_tugas ref_status_tugas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_status_tugas
    ADD CONSTRAINT ref_status_tugas_pkey PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 19204)
-- Name: ref_tipe_pekerjaan ref_tipe_pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ref_tipe_pekerjaan
    ADD CONSTRAINT ref_tipe_pekerjaan_pkey PRIMARY KEY (id);


--
-- TOC entry 5038 (class 2606 OID 19943)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_pkey PRIMARY KEY (id);


--
-- TOC entry 5040 (class 2606 OID 19945)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_unique UNIQUE (nim, semester_id);


--
-- TOC entry 5004 (class 2606 OID 19212)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5020 (class 2606 OID 19321)
-- Name: ruangan ruangan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_pkey PRIMARY KEY (id);


--
-- TOC entry 5006 (class 2606 OID 19231)
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 19286)
-- Name: staf staf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_pkey PRIMARY KEY (nip);


--
-- TOC entry 5016 (class 2606 OID 19288)
-- Name: staf staf_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_user_id_key UNIQUE (user_id);


--
-- TOC entry 5008 (class 2606 OID 19253)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5010 (class 2606 OID 19251)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5225 (class 2618 OID 19969)
-- Name: v_status_pekerjaan _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.v_status_pekerjaan AS
 SELECT dp.id AS pekerjaan_id,
    dp.judul,
    dp.kuota,
    dp.poin_jam,
    dp.is_aktif,
    count(p.id) FILTER (WHERE (p.status_tugas_id <> 5)) AS kuota_terisi,
    (dp.kuota - count(p.id) FILTER (WHERE (p.status_tugas_id <> 5))) AS sisa_slot
   FROM (public.daftar_pekerjaan dp
     LEFT JOIN public.penugasan p ON ((p.pekerjaan_id = dp.id)))
  GROUP BY dp.id;


--
-- TOC entry 5050 (class 2606 OID 19373)
-- Name: daftar_pekerjaan daftar_pekerjaan_ruangan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_ruangan_id_fkey FOREIGN KEY (ruangan_id) REFERENCES public.ruangan(id);


--
-- TOC entry 5051 (class 2606 OID 19363)
-- Name: daftar_pekerjaan daftar_pekerjaan_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 5052 (class 2606 OID 19358)
-- Name: daftar_pekerjaan daftar_pekerjaan_staf_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip);


--
-- TOC entry 5053 (class 2606 OID 19368)
-- Name: daftar_pekerjaan daftar_pekerjaan_tipe_pekerjaan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daftar_pekerjaan
    ADD CONSTRAINT daftar_pekerjaan_tipe_pekerjaan_id_fkey FOREIGN KEY (tipe_pekerjaan_id) REFERENCES public.ref_tipe_pekerjaan(id);


--
-- TOC entry 5057 (class 2606 OID 19413)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_kelas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id);


--
-- TOC entry 5058 (class 2606 OID 19423)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_penanggung_jawab_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_penanggung_jawab_nim_fkey FOREIGN KEY (penanggung_jawab_nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 5059 (class 2606 OID 19418)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 5060 (class 2606 OID 19428)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_status_ekuivalensi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_status_ekuivalensi_id_fkey FOREIGN KEY (status_ekuivalensi_id) REFERENCES public.ref_status_ekuivalensi(id);


--
-- TOC entry 5061 (class 2606 OID 19433)
-- Name: ekuivalensi_kelas ekuivalensi_kelas_verified_by_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ekuivalensi_kelas
    ADD CONSTRAINT ekuivalensi_kelas_verified_by_nip_fkey FOREIGN KEY (verified_by_nip) REFERENCES public.staf(nip);


--
-- TOC entry 5044 (class 2606 OID 19274)
-- Name: gedung gedung_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedung
    ADD CONSTRAINT gedung_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- TOC entry 5054 (class 2606 OID 19393)
-- Name: import_log import_log_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 5055 (class 2606 OID 19388)
-- Name: import_log import_log_staf_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip);


--
-- TOC entry 5056 (class 2606 OID 19398)
-- Name: import_log import_log_status_import_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_log
    ADD CONSTRAINT import_log_status_import_id_fkey FOREIGN KEY (status_import_id) REFERENCES public.ref_status_import(id);


--
-- TOC entry 5047 (class 2606 OID 19308)
-- Name: kelas kelas_prodi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_prodi_id_fkey FOREIGN KEY (prodi_id) REFERENCES public.prodi(id);


--
-- TOC entry 5066 (class 2606 OID 19488)
-- Name: kompen_awal kompen_awal_import_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_import_id_fkey FOREIGN KEY (import_id) REFERENCES public.import_log(id);


--
-- TOC entry 5067 (class 2606 OID 19478)
-- Name: kompen_awal kompen_awal_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 5068 (class 2606 OID 19483)
-- Name: kompen_awal kompen_awal_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kompen_awal
    ADD CONSTRAINT kompen_awal_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 5069 (class 2606 OID 19518)
-- Name: log_potong_jam log_potong_jam_ekuivalensi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_ekuivalensi_id_fkey FOREIGN KEY (ekuivalensi_id) REFERENCES public.ekuivalensi_kelas(id);


--
-- TOC entry 5070 (class 2606 OID 19503)
-- Name: log_potong_jam log_potong_jam_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 5071 (class 2606 OID 19513)
-- Name: log_potong_jam log_potong_jam_penugasan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_penugasan_id_fkey FOREIGN KEY (penugasan_id) REFERENCES public.penugasan(id);


--
-- TOC entry 5072 (class 2606 OID 19508)
-- Name: log_potong_jam log_potong_jam_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_potong_jam
    ADD CONSTRAINT log_potong_jam_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 5049 (class 2606 OID 19337)
-- Name: mahasiswa mahasiswa_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5041 (class 2606 OID 19133)
-- Name: menus menus_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menus(id);


--
-- TOC entry 5062 (class 2606 OID 19463)
-- Name: penugasan penugasan_diverifikasi_oleh_nip_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_diverifikasi_oleh_nip_fkey FOREIGN KEY (diverifikasi_oleh_nip) REFERENCES public.staf(nip);


--
-- TOC entry 5063 (class 2606 OID 19453)
-- Name: penugasan penugasan_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 5064 (class 2606 OID 19448)
-- Name: penugasan penugasan_pekerjaan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_pekerjaan_id_fkey FOREIGN KEY (pekerjaan_id) REFERENCES public.daftar_pekerjaan(id);


--
-- TOC entry 5065 (class 2606 OID 19458)
-- Name: penugasan penugasan_status_tugas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penugasan
    ADD CONSTRAINT penugasan_status_tugas_id_fkey FOREIGN KEY (status_tugas_id) REFERENCES public.ref_status_tugas(id);


--
-- TOC entry 5042 (class 2606 OID 19168)
-- Name: prodi prodi_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodi
    ADD CONSTRAINT prodi_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- TOC entry 5073 (class 2606 OID 19956)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_kelas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id);


--
-- TOC entry 5074 (class 2606 OID 19946)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_nim_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim);


--
-- TOC entry 5075 (class 2606 OID 19951)
-- Name: registrasi_mahasiswa registrasi_mahasiswa_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrasi_mahasiswa
    ADD CONSTRAINT registrasi_mahasiswa_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id);


--
-- TOC entry 5048 (class 2606 OID 19322)
-- Name: ruangan ruangan_gedung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_gedung_id_fkey FOREIGN KEY (gedung_id) REFERENCES public.gedung(id);


--
-- TOC entry 5045 (class 2606 OID 19294)
-- Name: staf staf_jurusan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id);


--
-- TOC entry 5046 (class 2606 OID 19289)
-- Name: staf staf_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staf
    ADD CONSTRAINT staf_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 5043 (class 2606 OID 19254)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-05-07 10:15:45

--
-- PostgreSQL database dump complete
--

\unrestrict G0EHJk9xyLuZg1SJfn9y5Cgi7bTdRlzOdA1emqs36w8ab1OWXE3vZGO50gdD2Se

