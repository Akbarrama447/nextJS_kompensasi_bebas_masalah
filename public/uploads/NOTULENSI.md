# NOTULENSI

---

## Sabtu, 23 Mei 2026 — 21:58 WIB

### Perbaikan Routing Sidebar (Role-Based Menu)

**Latar Belakang:** Sidebar admin menampilkan link ke `/user/...` bukan `/admin/...` karena data tabel `menus` dan `role_has_menus` tidak dikelola dengan benar.

**Perubahan yang dilakukan:**

#### 1. `prisma/seed.ts` — Seed Menu Admin & Mahasiswa
- Mengubah key menu admin dari `dashboard` → `dashboard_admin`, `pekerjaan` → `pekerjaan_admin` (menambahkan suffix `_admin`) untuk menghindari conflict unique constraint dengan menu mahasiswa
- Memperbaiki fungsi `seedMenus()`: sebelumnya hanya seed salah satu set menu (admin ATAU mahasiswa) karena bug kondisi `studentAccounts.length === 0`. Sekarang seed **kedua set menu** secara bersamaan

#### 2. `prisma/seed.ts` — Seed `role_has_menus`
- Menambahkan fungsi baru `seedRoleHasMenus()` yang mengisi tabel junction `role_has_menus`
- Mapping role → menu:
  - `role_id = 1` (mahasiswa) → menu mahasiswa (`dashboard`, `pekerjaan`, `ekuivalensi`)
  - `role_id = 2` (staf) → menu terbatas (`dashboard_admin`, `pekerjaan_admin`)
  - `role_id = 3` (admin) → semua menu admin (`dashboard_admin`, `pekerjaan_admin`, `laporan`, `pengaturan`)

#### 3. `src/app/admin/ekuivalensi/page.tsx`
- Memperbaiki `activePath` dari `"/ekuivalensi"` menjadi `"/admin/ekuivalensi"` agar sidebar dapat me-highlight menu yang aktif dengan benar

**Catatan:** Sidebar (`Sidebar.tsx:34`) masih memiliki hardcode `roleId = 3` untuk role mahasiswa (seharusnya `1`). Tidak diperbaiki karena di luar scope perubahan ini. Efek samping: admin (role_id=3 di DB) akan melihat menu mahasiswa juga di sidebar.

---
