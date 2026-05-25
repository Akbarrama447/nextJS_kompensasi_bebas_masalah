-- ============================================================
-- PISAH MENU USER DAN ADMIN
-- ============================================================

-- 1. Update path menu existing buat user/mahasiswa
UPDATE public.menus SET path = '/user/dashboard',       urutan = 1 WHERE key = 'dashboard';
UPDATE public.menus SET path = '/user/list_perkerjaan', urutan = 2 WHERE key = 'pekerjaan';
UPDATE public.menus SET path = '/user/ekuivalensi',     urutan = 3 WHERE key = 'ekuivalensi';

-- 2. Insert menu baru khusus admin (pake key beda biar unique)
INSERT INTO public.menus (key, label, icon, path, urutan) VALUES 
('dashboard_admin', 'Dashboard',    'LayoutDashboard', '/admin/dashboard',       1),
('pekerjaan_admin', 'Pekerjaan',    'Briefcase',       '/admin/list_pekerjaan',  2),
('laporan',        'Laporan',       'FileText',        '/admin/laporan',         3),
('pengaturan',     'Pengaturan',    'Settings',        '/admin/pengaturan',      4)
ON CONFLICT (key) DO UPDATE SET path = EXCLUDED.path, urutan = EXCLUDED.urutan;

-- 3. Reset role_has_menus
TRUNCATE TABLE public.role_has_menus;

-- 4. Role 1,2,4 (admin) lihat menu admin
INSERT INTO public.role_has_menus (role_id, menus_id)
SELECT 1, id FROM public.menus WHERE key IN ('dashboard_admin', 'pekerjaan_admin', 'laporan', 'pengaturan');
INSERT INTO public.role_has_menus (role_id, menus_id)
SELECT 2, id FROM public.menus WHERE key IN ('dashboard_admin', 'pekerjaan_admin');
INSERT INTO public.role_has_menus (role_id, menus_id)
SELECT 4, id FROM public.menus WHERE key IN ('dashboard_admin');

-- 5. Role 3 (mahasiswa) lihat menu user
INSERT INTO public.role_has_menus (role_id, menus_id)
SELECT 3, id FROM public.menus WHERE key IN ('dashboard', 'pekerjaan', 'ekuivalensi');
