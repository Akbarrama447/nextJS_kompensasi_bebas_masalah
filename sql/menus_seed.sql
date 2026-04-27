-- Seed Menu untuk Mahasiswa
INSERT INTO public.menus (key, label, icon, path, urutan) VALUES
('dashboard_mahasiswa', 'Dashboard', 'LayoutDashboard', '/user/dashboard', 1),
('ekuivalensi', 'Ekuivalensi', 'BookOpen', '/user/ekuivalensi', 2),
('laporan', 'Laporan', 'FileText', '/user/laporan', 3);

-- Seed Menu untuk Admin
INSERT INTO public.menus (key, label, icon, path, urutan, parent_id) VALUES
('dashboard_admin', 'Dashboard', 'LayoutDashboard', '/admin/dashboard', 1, NULL),
('manajemen_mahasiswa', 'Mahasiswa', 'Users', '/admin/mahasiswa', 2, NULL),
('persetujuan', 'Persetujuan', 'FileCheck', '/admin/persetujuan', 3, NULL),
('pengaturan', 'Pengaturan', 'Settings', '/admin/pengaturan', 4, NULL);