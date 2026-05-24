-- ============================================================
-- QUERY BUAT AKUN TEST (jalanin di SQL Editor / psql)
-- ============================================================

-- 1. Super Admin (login pake NIP atau email)
INSERT INTO public.users (email, kata_sandi, role_id)
VALUES ('admin@kampus.ac.id', '$2b$10$E0J87FgzbOn0ObPk3YM2MOitTWUHncZ19gZ7En8btAZcNozIjXKuS', 1)
RETURNING user_id;

INSERT INTO public.staf (nip, user_id, nama, jurusan_id, tipe_staf)
VALUES ('ADMIN001', (SELECT user_id FROM public.users WHERE email = 'admin@kampus.ac.id'), 'Super Admin', 1, 'admin');

-- 2. Staf Jurusan (login pake NIP atau email)
INSERT INTO public.users (email, kata_sandi, role_id)
VALUES ('staf@kampus.ac.id', '$2b$10$t4W7xcgPZLyPs8e9eNb53.Ua2eZ1xNbjPGOSkje.yIWMWVa7mHrBy', 2)
RETURNING user_id;

INSERT INTO public.staf (nip, user_id, nama, jurusan_id, tipe_staf)
VALUES ('STAF001', (SELECT user_id FROM public.users WHERE email = 'staf@kampus.ac.id'), 'Staf Jurusan', 1, 'staf_jurusan');

-- 3. Dosen (login pake NIP atau email)
INSERT INTO public.users (email, kata_sandi, role_id)
VALUES ('dosen@kampus.ac.id', '$2b$10$gh.SLH4khGlOdz.PC6UsGurK8.awheser.2Hyz2PLJNE1Zm5/l38K', 4)
RETURNING user_id;

INSERT INTO public.staf (nip, user_id, nama, jurusan_id, tipe_staf)
VALUES ('DOSEN001', (SELECT user_id FROM public.users WHERE email = 'dosen@kampus.ac.id'), 'Dosen Penguji', 1, 'dosen');

-- 4. Mahasiswa (login pake NIM atau email)
INSERT INTO public.users (email, kata_sandi, role_id)
VALUES ('mhs@kampus.ac.id', '$2b$10$sg2EUaOQCOYE/Scxh3s7xu/BDSoEhsu7ZIpVBdDjOq7lfm9r60Ynq', 3)
RETURNING user_id;

INSERT INTO public.mahasiswa (nim, user_id, nama)
VALUES ('MHS001', (SELECT user_id FROM public.users WHERE email = 'mhs@kampus.ac.id'), 'Mahasiswa Test');

-- ============================================================
-- ISI TABLE role_has_menus biar sidebar ke-filter
-- ============================================================

-- Role 1 (Super Admin) bisa akses semua menu
INSERT INTO public.role_has_menus (role_id, menus_id) VALUES
(1, 1), (1, 2), (1, 3);

-- Role 2 (Staf Jurusan) bisa akses dashboard & pekerjaan
INSERT INTO public.role_has_menus (role_id, menus_id) VALUES
(2, 1), (2, 2);

-- Role 3 (Mahasiswa) bisa akses dashboard, pekerjaan, ekuivalensi
INSERT INTO public.role_has_menus (role_id, menus_id) VALUES
(3, 1), (3, 2), (3, 3);

-- Role 4 (Dosen) bisa akses dashboard aja
INSERT INTO public.role_has_menus (role_id, menus_id) VALUES
(4, 1);
