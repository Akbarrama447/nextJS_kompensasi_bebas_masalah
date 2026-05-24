# NOTULENSI — Pengerjaan Web Kompen

**Tanggal:** 10 Mei 2026  
**Lokasi:** `/src/app/user/list_perkerjaan` & sistem auth

---

## 1. Perbaikan Halaman List Pekerjaan (Mahasiswa)

### Bug Fixes
| # | Masalah | Solusi |
|---|---------|--------|
| 1 | Typo `activePath="/user/list_pekerjaan"` | Diubah ke `"/user/list_perkerjaan"` |
| 2 | `console.log` debug di production | Dihapus |
| 3 | Folder `public/uploads` belum dicek | Dipastikan sudah ada |
| 4 | Dropdown filter cuma muncul "Semua" & "Internal" | Diubah ambil data dari DB (`allTipePekerjaan`) instead of dari penugasan user |
| 5 | Modal kamera ilang pas mode "Konfirmasi Mulai" | Kamera muncul di semua mode, cuma `disabled` beda |
| 6 | Foto wajib di semua kondisi | Foto wajib cuma pas "Akhiri", pas "Mulai" opsional |
| 7 | Nominatim API tanpa error handling | Ditambah AbortController + timeout 5s + fallback koordinat |
| 8 | Geolocation ditolak user | Muncul "Akses lokasi ditolak" |
| 9 | Semua pake type `any` | Diganti interface proper (`Penugasan`, `Pekerjaan`, `StatusTugas`, dll) |
| 10 | `status_tugas_id` type mismatch (number vs null) | Dijadikan `number \| null` + null safety |
| 11 | Kolom Aksi kosong kalo status > 2 | Muncul label status (Selesai/Diverifikasi/Ditolak) |

### Files Changed
- `src/app/user/list_perkerjaan/page.tsx`
- `src/app/user/list_perkerjaan/PekerjaanSayaClient.tsx`
- `src/app/user/list_perkerjaan/action.tsx`

---

## 2. Sistem Login & Role-based Routing

### Prisma
- Menambahkan model `role_has_menus` dengan relasi ke `roles` & `menus`
- Generate Prisma client ulang

### Login API (`src/app/api/login/route.ts`)
- **Sebelum:** Cuma handle login mahasiswa via NIM
- **Sesudah:** Handle login mahasiswa (via NIM/email) & admin/staf (via NIP/email)
- Set cookie `role`, `nama`, `nim`, `nip`

### Login Page (`src/app/login/page.tsx`)
- **Sebelum:** Hardcoded redirect ke `/user/dashboard`
- **Sesudah:** Redirect dinamis — admin → `/admin/dashboard`, mahasiswa → `/user/dashboard`

### Middleware (`src/middleware.ts`)
- **Sebelum:** Admin pake demo cookie, gada role cookie
- **Sesudah:** Pake cookie `role`, admin tanpa login diarahkan ke `/login`, gada demo fallback

### Sidebar (`src/components/Sidebar.tsx`)
- **Sebelum:** Menampilkan semua menu + hardcode dashboard admin + path rewriting hack
- **Sesudah:** Filter menu murni via `role_has_menus`, gada path rewriting, gada hardcode

### Logout (`src/app/logout/route.ts`)
- Hapus semua cookies (`role`, `nama`, `nim`, `nip`)

---

## 3. SQL Query Files

| File | Fungsi |
|------|--------|
| `query_login.sql` | Insert akun test (admin, staf, dosen, mahasiswa) + seed `role_has_menus` |
| `query_separate_menus.sql` | Pisah menu user dan admin di tabel `menus` + `role_has_menus` |

### Akun Test
| Role | Login | Password |
|------|-------|----------|
| Super Admin | `ADMIN001` / `admin@kampus.ac.id` | `admin123` |
| Staf Jurusan | `STAF001` / `staf@kampus.ac.id` | `staf123` |
| Dosen | `DOSEN001` / `dosen@kampus.ac.id` | `dosen123` |
| Mahasiswa | `MHS001` / `mhs@kampus.ac.id` | `mhs123` |

---

## 4. Catatan Lain

- Error pre-existing di `admin/dashboard/page.tsx` (type `StatusCount[]`) masih ada, belum diperbaiki
- Hydration warning di console (attribute `fdprocessedid`) akibat browser extension, bukan kode
- Semua file changes sudah di-test build (compiled successfully)
