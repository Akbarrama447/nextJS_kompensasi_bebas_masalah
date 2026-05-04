# CATATAN PROGRES PENGEMBANGAN (ADMIN - LIST PEKERJAAN)

## ✅ TAHAP 1 SELESAI: TAB IMPORT MAHASISWA
Fitur Import Data Kompensasi via Excel telah dirombak dan dinyatakan **100% Selesai & Tangguh**. Berbagai perbaikan kritis yang telah diimplementasikan:
1. **Intelligent Parser**: Mampu mengenali dan melewati baris kosong atau metadata (seperti "Semester: 20251") secara otomatis.
2. **Auto-Provisioning Kelas**: Tidak ada lagi error *Foreign Key Constraint*. Jika kelas dari Excel belum ada di database, sistem akan otomatis membuatnya secara cerdas (*on-the-fly*).
3. **Proteksi Email Bentrok**: Dilengkapi dengan logika pembuatan *username* acak jika terdeteksi duplikasi email saat mendaftarkan akun `Users` untuk mahasiswa.
4. **Smart Fallback System**: Secara otomatis mencari ID Semester yang aktif dan NIP staf yang melakukan proses, mencegah server melempar error *null constraint*.
5. **Detailed Error UI**: Perombakan modal UI untuk menampilkan daftar pesan error secara spesifik dan presisi tiap barisnya langsung dari server.
6. **Safe Upsert Registration**: Menggunakan `findFirst` untuk mengatasi bug *unique compound index* Prisma, membuat sistem bisa menimpa maupun memperbarui data mahasiswa lama tanpa crash.

---

## ✅ TAHAP 2 SELESAI: TAB KELOLA (Daftar Pekerjaan & Generate Plotting)

### Files yang Dibuat:
| File | Keterangan |
|------|-----------|
| `types/index.ts` | TypeScript interfaces (PekerjaanForm, PekerjaanRow, OptionsData, PlottingConfig, dll) |
| `actions/options.ts` | Server action untuk fetch dropdown options |
| `actions/pekerjaan.ts` | Server actions: CRUD pekerjaan |
| `actions/plotting.ts` | Server action: generate plotting |

### Files yang Diperbarui:
| File | Keterangan |
|------|-----------|
| `components/TabKelola.tsx` | Full integration dengan server actions |

---

### Fitur yang Diimplementasikan:

#### 1. Tambah Pekerjaan (Create)
- **Endpoint:** `createPekerjaan(data)`
- **Input:** judul, deskripsi, tipe_pekerjaan_id, poin_jam, quota, tanggal_mulai, tanggal_selesai, ruangan_id
- **Validasi:**
  - Auto-detect semester aktif jika null
  - Auto-detect staf jika null
  - Validasi tipe_pekerjaan_id exists
  - Validasi ruangan_id exists (jika ada)
- **Output:** `{ success: true, id }` atau `{ success: false, error }`
- **DB:** `prisma.daftar_pekerjaan.create()`

#### 2. Lihat Daftar Pekerjaan (Read)
- **Endpoint:** `getDaftarPekerjaan(filters?)`
- **Input:** `{ semester_id?, is_aktif? }`
- **Output:** Array `PekerjaanRow[]` dengan fields:
  - id, judul, tipe, poin, kuotatersisa, kuotatotal, tanggal_mulai, tanggal_selesai, is_aktif
  - Relations: staf, ruangan, tipe_pekerjaan
- **DB:** `prisma.daftar_pekerjaan.findMany()` + hitung kuotatersisa dari count penugasan aktif

#### 3. Hapus Pekerjaan (Delete)
- **Endpoint:** `deletePekerjaan(id)`
- **Validasi:** Cek apakah ada penugasan aktif
- **Output:** `{ success: true }` atau `{ success: false, error }`
- **DB:** Soft delete (`is_aktif = false`)

#### 4. Generate Plotting (Auto-Distribusi)
- **Endpoint:** `generatePlotting(config?)`
- **Input:** `{ semester_id?, maxJamPerHari?: 8, sortBy?: 'nim' | 'jam_kompen' }`
- **Algoritma Distribusi:**
  1. Fetch pekerjaan dengan `is_aktif=true` dan `kuota_sisa > 0`
  2. Fetch mahasiswa dengan `total_jam_wajib > 0` dan belum punya penugasan aktif
  3. Hitung `jam_sisa = total_jam_wajib - jam_sudah_dapat`
  4. Urutkan: NIM asc ATAU terkecil jam kompen
  5. Distribusi per pekerjaan:
     - Bagi poin_jam ke beberapa mahasiswa dengan integer division
     - Sisa (remainder) diberikan ke mahasiswa terakhir
     - Jika mhs sudah penuh/maxJam, lanjut ke mhs berikutnya
  6. Insert ke tabel Penugasan
- **Output:** `{ success: true, processedCount, assignmentCount, results[] }`
- **DB:** `prisma.penugasan.create()` (per mahasiswa)

---

### Auto-Provisioning:
- Tipe pekerjaan "Internal" dan "Eksternal" akan otomatis dibuat jika tabel `ref_tipe_pekerjaan` kosong

---

### Fields di Form:
| Field | Tipe | Required | Keterangan |
|-------|-----|----------|-----------|
| Nama Pekerjaan | text | ✅ | Judul pekerjaan |
| Tipe Pekerjaan | select | ✅ | Dari ref_tipe_pekerjaan |
| Poin (Jam Kompen) | number | ✅ | Float, min 1 |
| Total Kuota | number | ✅ | Jumlah mahasiswa |
| Ruangan | select | - | Dari Ruangan |
| Tanggal Mulai | date | - | Optional |
| Tanggal Selesai | date | ✅ | Batas akhir |
| Deskripsi | textarea | - | Optional |

---

### Tabel Database yang Tershubung:
| Tabel | Relasi |
|-------|-------|
| `daftar_pekerjaan` | Pekerjaan utama |
| `ref_tipe_pekerjaan` | Lookup tipe (Internal/Eksternal) |
| `ruangan` | Lokasi pekerjaan |
| `semester` | Periode |
| `staf` | Pembuat |
| `penugasan` | Hasil plotting (mahasiswa yang ditugaskan) |

---

## ⏳ TAHAP SELANJUTNYA: 3 TAB TERSISA