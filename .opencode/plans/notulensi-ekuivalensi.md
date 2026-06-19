# Notulensi Perbaikan Ekuivalensi

## Latar Belakang
- Admin hanya melihat **1 ekuivalensi terakhir** per kelas (`findFirst`)
- Siswa bisa bikin **multiple ekuivalensi** untuk kelas yang sama karena pengecekan duplikat hanya ngecek status `MENUNGGU` (1), bukan semua status

## Perubahan yang Dilakukan

### 1. `src/app/api/ekuivalensi/create/route.ts`
**Lokasi:** Baris 33-46
**Sebelum:**
```ts
status_ekuivalensi_id: 1,
```
**Sesudah:**
```ts
status_ekuivalensi_id: { not: 3 },
```
Cegah submission baru jika sudah ada ekuivalensi yang MENUNGGU(1) atau DISETUJUI(2). Hanya DITOLAK(3) yang boleh submit ulang.

### 2. `src/app/api/ekuivalensi/by-kelas/route.ts`
**Lokasi:** Baris 63-69
**Sebelum:** `findFirst` + `orderBy: 'desc'` → return 1 ekuivalensi
**Sesudah:** `findMany` → return array semua ekuivalensi
- Include `mahasiswa` (penanggung_jawab) buat dapetin nama
- Response: `ekuivalensi` berubah dari object jadi array

### 3. `src/app/admin/ekuivalensi/ClientPage.tsx`
**State:**
- `ekuivalensi` (object) → `ekuivalensiList` (array)
- Tambah `selectedEkuivalensiId` buat track mana yg di-popup

**Render:**
- Di bawah tabel mahasiswa, tambah tabel daftar ekuivalensi:

| No | Penanggung Jawab | Jam | Nominal | Tanggal | Status | Verifikasi |
|---|---|---|---|---|---|---|
| 1 | Nama Mhs (NIM) | 10 | Rp. xxx | 28/04/26 | DISETUJUI ✅ | — |
| 2 | Nama Mhs (NIM) | 10 | Rp. xxx | 05/09/24 | MENUNGGU 🟡 | [Setuju] [Tolak] |

- **Status MENUNGGU** → tombol Setuju & Tolak aktif
- **Status DISETUJUI** → badge hijau
- **Status DITOLAK** → badge merah + catatan

**Popup:**
- `handleVerify(2, selectedId)` untuk approve
- `handleVerify(3, selectedId, alasan)` untuk tolak
- `PopupBukti` & `PopupTolak` dinamis sesuai `selectedEkuivalensiId`

## Status Akhir
- ✅ `ref_status_import`: 1=SELESAI, 2=GAGAL
- ✅ `ref_status_ekuivalensi`: 1=MENUNGGU, 2=DISETUJUI, 3=DITOLAK
- 🟡 Belum diimplement (plan mode)
