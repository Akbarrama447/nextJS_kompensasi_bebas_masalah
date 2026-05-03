-- =====================================================
-- MIGRATION: Add registrasi_mahasiswa table
-- Untuk handle kelas per semester (flexible registration)
-- Safe untuk production - tidak drop tabel existing
-- =====================================================

-- STEP 1: Drop view lama yang depend on kelas_id
DROP VIEW IF EXISTS public.v_mahasiswa_detail CASCADE;

-- STEP 2: Remove foreign key constraint dari mahasiswa.kelas_id (jika ada)
ALTER TABLE public.mahasiswa DROP CONSTRAINT IF EXISTS mahasiswa_kelas_id_fkey;

-- STEP 3: Drop kolom kelas_id dari mahasiswa (data akan pindah ke registrasi_mahasiswa)
ALTER TABLE public.mahasiswa DROP COLUMN IF EXISTS kelas_id;

-- STEP 3: Create table registrasi_mahasiswa (baru)
CREATE TABLE IF NOT EXISTS public.registrasi_mahasiswa (
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

-- STEP 4: Create/Replace view v_mahasiswa_aktif
CREATE OR REPLACE VIEW public.v_mahasiswa_aktif AS
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

-- STEP 5: Create/Replace view v_status_pekerjaan
CREATE OR REPLACE VIEW public.v_status_pekerjaan AS
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

-- =====================================================
-- OPTIONAL: Migrate existing data (jika mahasiswa sebelumnya punya kelas_id)
-- Uncomment kalo mahasiswa lama sudah punya kelas_id
-- =====================================================
-- INSERT INTO public.registrasi_mahasiswa (nim, semester_id, kelas_id, status)
-- SELECT m.nim, s.id, m.kelas_id, 'Aktif'
-- FROM public.mahasiswa m
-- CROSS JOIN public.semester s
-- WHERE m.kelas_id IS NOT NULL AND s.is_aktif = true
-- ON CONFLICT (nim, semester_id) DO NOTHING;

-- =====================================================
-- Migration completed
-- =====================================================
COMMIT;
