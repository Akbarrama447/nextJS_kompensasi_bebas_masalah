-- =====================================================
-- LEVEL 1: Tabel tanpa foreign key (independent)
-- =====================================================

CREATE TABLE public.jurusan (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    nama_jurusan character varying,
    CONSTRAINT jurusan_pkey PRIMARY KEY (id)
);

CREATE TABLE public.ref_status_ekuivalensi (
    id integer NOT NULL,
    nama character varying,
    CONSTRAINT ref_status_ekuivalensi_pkey PRIMARY KEY (id)
);

CREATE TABLE public.ref_status_import (
    id integer NOT NULL,
    nama character varying,
    CONSTRAINT ref_status_import_pkey PRIMARY KEY (id)
);

CREATE TABLE public.ref_status_tugas (
    id integer NOT NULL,
    nama character varying,
    CONSTRAINT ref_status_tugas_pkey PRIMARY KEY (id)
);

CREATE TABLE public.ref_tipe_pekerjaan (
    id integer NOT NULL,
    nama character varying,
    CONSTRAINT ref_tipe_pekerjaan_pkey PRIMARY KEY (id)
);

CREATE TABLE public.roles (
    id integer NOT NULL,
    nama character varying,
    key_menu jsonb,
    key_condition jsonb,
    CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TABLE public.semester (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    nama character varying,
    tahun integer,
    periode character varying,
    is_aktif boolean DEFAULT false,
    mulai date,
    selesai date,
    CONSTRAINT semester_pkey PRIMARY KEY (id)
);

CREATE TABLE public.menus (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    key character varying NOT NULL UNIQUE,
    label character varying NOT NULL,
    icon character varying,
    path character varying NOT NULL,
    urutan integer DEFAULT 0,
    parent_id integer,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT menus_pkey PRIMARY KEY (id),
    CONSTRAINT menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menus(id)
);

CREATE TABLE public.pengaturan_sistem (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    grup character varying,
    key character varying UNIQUE,
    value character varying,
    tipe_data character varying,
    keterangan text,
    CONSTRAINT pengaturan_sistem_pkey PRIMARY KEY (id)
);

-- =====================================================
-- LEVEL 2: Tabel yang butuh LEVEL 1
-- =====================================================

CREATE TABLE public.users (
    user_id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    email character varying UNIQUE,
    kata_sandi character varying,
    role_id integer,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT users_pkey PRIMARY KEY (user_id),
    CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id)
);

CREATE TABLE public.prodi (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    jurusan_id integer,
    nama_prodi character varying,
    CONSTRAINT prodi_pkey PRIMARY KEY (id),
    CONSTRAINT prodi_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id)
);

CREATE TABLE public.gedung (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    jurusan_id integer,
    nama_gedung character varying,
    CONSTRAINT gedung_pkey PRIMARY KEY (id),
    CONSTRAINT gedung_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id)
);

-- =====================================================
-- LEVEL 3: Tabel yang butuh LEVEL 2
-- =====================================================

CREATE TABLE public.staf (
    nip character varying NOT NULL,
    user_id integer UNIQUE,
    nama character varying,
    jurusan_id integer,
    tipe_staf character varying,
    CONSTRAINT staf_pkey PRIMARY KEY (nip),
    CONSTRAINT staf_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id),
    CONSTRAINT staf_jurusan_id_fkey FOREIGN KEY (jurusan_id) REFERENCES public.jurusan(id)
);

CREATE TABLE public.kelas (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    prodi_id integer,
    nama_kelas character varying,
    CONSTRAINT kelas_pkey PRIMARY KEY (id),
    CONSTRAINT kelas_prodi_id_fkey FOREIGN KEY (prodi_id) REFERENCES public.prodi(id)
);

CREATE TABLE public.ruangan (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    gedung_id integer,
    nama_ruangan character varying,
    kode_ruangan character varying,
    CONSTRAINT ruangan_pkey PRIMARY KEY (id),
    CONSTRAINT ruangan_gedung_id_fkey FOREIGN KEY (gedung_id) REFERENCES public.gedung(id)
);

CREATE TABLE public.mahasiswa (
    nim character varying NOT NULL,
    user_id integer UNIQUE,
    nama character varying,
    CONSTRAINT mahasiswa_pkey PRIMARY KEY (nim),
    CONSTRAINT mahasiswa_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);

CREATE TABLE public.registrasi_mahasiswa (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    nim character varying,
    semester_id integer,
    kelas_id integer,
    status character varying DEFAULT 'Aktif',
    CONSTRAINT registrasi_mahasiswa_pkey PRIMARY KEY (id),
    CONSTRAINT registrasi_mahasiswa_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim),
    CONSTRAINT registrasi_mahasiswa_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id),
    CONSTRAINT registrasi_mahasiswa_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id),
    CONSTRAINT registrasi_mahasiswa_unique UNIQUE (nim, semester_id)
);

-- =====================================================
-- LEVEL 4: Tabel yang butuh LEVEL 3
-- =====================================================

CREATE TABLE public.daftar_pekerjaan (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
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
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT daftar_pekerjaan_pkey PRIMARY KEY (id),
    CONSTRAINT daftar_pekerjaan_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip),
    CONSTRAINT daftar_pekerjaan_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id),
    CONSTRAINT daftar_pekerjaan_tipe_pekerjaan_id_fkey FOREIGN KEY (tipe_pekerjaan_id) REFERENCES public.ref_tipe_pekerjaan(id),
    CONSTRAINT daftar_pekerjaan_ruangan_id_fkey FOREIGN KEY (ruangan_id) REFERENCES public.ruangan(id)
);

CREATE TABLE public.import_log (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    staf_nip character varying,
    semester_id integer,
    nama_file character varying,
    total_baris integer,
    sukses_baris integer,
    error_details jsonb,
    status_import_id integer,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT import_log_pkey PRIMARY KEY (id),
    CONSTRAINT import_log_staf_nip_fkey FOREIGN KEY (staf_nip) REFERENCES public.staf(nip),
    CONSTRAINT import_log_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id),
    CONSTRAINT import_log_status_import_id_fkey FOREIGN KEY (status_import_id) REFERENCES public.ref_status_import(id)
);

CREATE TABLE public.ekuivalensi_kelas (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    kelas_id integer,
    semester_id integer,
    penanggung_jawab_nim character varying,
    nota_url text,
    nominal_total numeric,
    jam_diakui double precision,
    status_ekuivalensi_id integer,
    verified_by_nip character varying,
    catatan text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT ekuivalensi_kelas_pkey PRIMARY KEY (id),
    CONSTRAINT ekuivalensi_kelas_kelas_id_fkey FOREIGN KEY (kelas_id) REFERENCES public.kelas(id),
    CONSTRAINT ekuivalensi_kelas_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id),
    CONSTRAINT ekuivalensi_kelas_penanggung_jawab_nim_fkey FOREIGN KEY (penanggung_jawab_nim) REFERENCES public.mahasiswa(nim),
    CONSTRAINT ekuivalensi_kelas_status_ekuivalensi_id_fkey FOREIGN KEY (status_ekuivalensi_id) REFERENCES public.ref_status_ekuivalensi(id),
    CONSTRAINT ekuivalensi_kelas_verified_by_nip_fkey FOREIGN KEY (verified_by_nip) REFERENCES public.staf(nip)
);

-- =====================================================
-- LEVEL 5: Tabel yang butuh LEVEL 4 (paling akhir)
-- =====================================================

CREATE TABLE public.penugasan (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    pekerjaan_id integer,
    nim character varying,
    status_tugas_id integer,
    detail_pengerjaan jsonb,
    catatan_verifikasi text,
    diverifikasi_oleh_nip character varying,
    waktu_verifikasi timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    CONSTRAINT penugasan_pkey PRIMARY KEY (id),
    CONSTRAINT penugasan_pekerjaan_id_fkey FOREIGN KEY (pekerjaan_id) REFERENCES public.daftar_pekerjaan(id),
    CONSTRAINT penugasan_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim),
    CONSTRAINT penugasan_status_tugas_id_fkey FOREIGN KEY (status_tugas_id) REFERENCES public.ref_status_tugas(id),
    CONSTRAINT penugasan_diverifikasi_oleh_nip_fkey FOREIGN KEY (diverifikasi_oleh_nip) REFERENCES public.staf(nip)
);

CREATE TABLE public.kompen_awal (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    nim character varying,
    semester_id integer,
    import_id integer,
    total_jam_wajib double precision,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT kompen_awal_pkey PRIMARY KEY (id),
    CONSTRAINT kompen_awal_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim),
    CONSTRAINT kompen_awal_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id),
    CONSTRAINT kompen_awal_import_id_fkey FOREIGN KEY (import_id) REFERENCES public.import_log(id)
);

CREATE TABLE public.log_potong_jam (
    id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
    nim character varying,
    semester_id integer,
    penugasan_id integer,
    ekuivalensi_id integer,
    jam_dikurangi double precision,
    keterangan text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    CONSTRAINT log_potong_jam_pkey PRIMARY KEY (id),
    CONSTRAINT log_potong_jam_nim_fkey FOREIGN KEY (nim) REFERENCES public.mahasiswa(nim),
    CONSTRAINT log_potong_jam_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semester(id),
    CONSTRAINT log_potong_jam_penugasan_id_fkey FOREIGN KEY (penugasan_id) REFERENCES public.penugasan(id),
    CONSTRAINT log_potong_jam_ekuivalensi_id_fkey FOREIGN KEY (ekuivalensi_id) REFERENCES public.ekuivalensi_kelas(id)
);

-- =====================================================
-- Cek hasil: harusnya 22 tabel
-- =====================================================

create view public.v_mahasiswa_aktif as
 SELECT 
    m.nim,
    m.nama,
    u.email,
    r.semester_id,
    r.status as status_registrasi,
    k.nama_kelas,
    p.nama_prodi,
    j.nama_jurusan,
    s.is_aktif as is_semester_aktif
   FROM public.mahasiswa m
     JOIN public.users u ON u.user_id = m.user_id
     JOIN public.registrasi_mahasiswa r ON r.nim = m.nim
     JOIN public.semester s ON s.id = r.semester_id
     JOIN public.kelas k ON k.id = r.kelas_id
     JOIN public.prodi p ON p.id = k.prodi_id
     JOIN public.jurusan j ON j.id = p.jurusan_id;

create view public.v_status_pekerjaan as
 SELECT 
    dp.id as pekerjaan_id,
    dp.judul,
    dp.kuota,
    dp.poin_jam,
    dp.is_aktif,
    count(p.id) FILTER (WHERE p.status_tugas_id != 5) AS kuota_terisi,
    (dp.kuota - count(p.id) FILTER (WHERE p.status_tugas_id != 5)) AS sisa_slot
   FROM public.daftar_pekerjaan dp
     LEFT JOIN public.penugasan p ON p.pekerjaan_id = dp.id
  GROUP BY dp.id;

  create view public.v_sisa_kompen as
select
  k.nim,
  k.semester_id,
  k.total_jam_wajib,
  COALESCE(sum(l.jam_dikurangi), 0::double precision) as jam_selesai,
  k.total_jam_wajib - COALESCE(sum(l.jam_dikurangi), 0::double precision) as sisa_jam
from
  kompen_awal k
  left join log_potong_jam l on l.nim::text = k.nim::text
  and l.semester_id = k.semester_id
group by
  k.nim,
  k.semester_id,
  k.total_jam_wajib;

-- ==========================================
-- INSERT DATA DUMMY
-- ==========================================

-- 1. INSERT DATA JURUSAN & KELAS (DUMMY)
INSERT INTO public.jurusan (nama_jurusan) VALUES ('Teknik Elektro');
INSERT INTO public.prodi (jurusan_id, nama_prodi) VALUES (1, 'D3 Teknik Informatika');
INSERT INTO public.kelas (prodi_id, nama_kelas) VALUES (1, 'IK-2C');

-- 2. INSERT SEMESTER AKTIF
INSERT INTO public.semester (nama, tahun, periode, is_aktif, mulai, selesai) 
VALUES ('Ganjil 2025/2026', 2026, 'Ganjil', true, '2026-09-01', '2027-01-30');

-- 3. INSERT USER (Password: Polines123!)
-- Gunakan OVERRIDING SYSTEM VALUE karena user_id adalah GENERATED ALWAYS
INSERT INTO public.users (user_id, email, kata_sandi, role_id) OVERRIDING SYSTEM VALUE VALUES
(101, 'admin@polines.ac.id', '$2b$10$EPZ9S63mS9.vH6A.9m99u.7N.xXfH2/6P6X9.9m99u.7N.xXfH2/', 1), -- Admin
(102, 'dosen@polines.ac.id', '$2b$10$EPZ9S63mS9.vH6A.9m99u.7N.xXfH2/6P6X9.9m99u.7N.xXfH2/', 4), -- Dosen
(103, 'akbar@mhs.polines.ac.id', '$2b$10$EPZ9S63mS9.vH6A.9m99u.7N.xXfH2/6P6X9.9m99u.7N.xXfH2/', 3); -- Mahasiswa

-- 4. INSERT PROFIL ENTITAS
INSERT INTO public.staf (nip, user_id, nama, jurusan_id, tipe_staf) VALUES
('198001012024011001', 101, 'Super Admin Kompen', 1, 'admin'),
('197505052005011002', 102, 'Sir Danu Prakoso', 1, 'dosen');

INSERT INTO public.mahasiswa (nim, user_id, nama) VALUES
('33424202', 103, 'Akbar Rama');

-- 5. REGISTRASI SEMESTER (Kunci agar Mahasiswa Aktif muncul di Dashboard)
INSERT INTO public.registrasi_mahasiswa (nim, semester_id, kelas_id, status) VALUES
('33424202', 1, 1, 'Aktif');








