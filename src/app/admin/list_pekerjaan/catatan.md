# CATATAN PROGRES PENGEMBANGAN (ADMIN - LIST PEKERJAAN)

## ✅ TAHAP 1 SELESAI: TAB IMPORT MAHASISWA
Fitur Import Data Kompensasi via Excel telah dirombak dan dinyatakan **100% Selesai & Tangguh**. Berbagai perbaikan kritis yang telah diimplementasikan:
1. **Intelligent Parser**: Mampu mengenali dan melewati baris kosong atau metadata (seperti "Semester: 20251") secara otomatis.
2. **Auto-Provisioning Kelas**: Tidak ada lagi error *Foreign Key Constraint*. Jika kelas dari Excel belum ada di database, sistem akan otomatis membuatnya secara cerdas (*on-the-fly*).
3. **Proteksi Email Bentrok**: Dilengkapi dengan logika pembuatan *username* acak jika terdeteksi duplikasi email saat mendaftarkan akun `Users` untuk mahasiswa.
4. **Smart Fallback System**: Secara otomatis mencari ID Semester yang aktif dan NIP staf yang melakukan proses, mencegah server melempar error *null constraint*.
5. **Detailed Error UI**: Perombakan modal UI untuk menampilkan daftar pesan error secara spesifik dan presisi tiap barisnya langsung dari server.
6. **Safe Upsert Registration**: Menggunakan `findFirst` untuk mengatasi bug *unique compound index* Prisma, membuat sistem bisa menimpa maupun memperbarui data mahasiswa lama tanpa crash.


### Tambahan untuk Tab Import
1. **Fitur Pagination Preview**: Menambahkan pagination pada tabel preview data Excel sebelum di-import. Opsi tampilkan 10/25/50 data per halaman dengan navigasi prev/next. Sangat penting karena Import file Excel bisa berisi 250+ mahasiswa sekaligus.
2.
3.
4.

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

### CELAH MASALAH DALAM TAHAP 2
#### 📌 Problem Definition

Saya sedang membangun sistem kompensasi mahasiswa berbasis Next.js.

Dalam sistem ini:

* Mahasiswa memiliki kewajiban kompensasi dalam bentuk **jumlah jam (misalnya 8 jam, 10 jam, dll)**.
* Admin dapat membuat pekerjaan dengan parameter:

  * Nama pekerjaan
  * Total jam kompensasi per pekerjaan
  * Kuota maksimal orang
  * Lokasi / ruangan
  * Deskripsi

Contoh:
Mahasiswa:

* Budi → kebutuhan kompensasi: 8 jam

Pekerjaan:

* Membersihkan Ruangan
* Jam kompensasi: 10 jam
* Kuota: 3 orang

---

#### ⚠️ Permasalahan Utama

Terdapat konflik antara:

1. **Distribusi jam kompensasi**
2. **Batas kapasitas (kuota orang dalam ruangan)**

Kasus:

* Jika setiap orang mendapat 10 jam penuh → mahasiswa dengan kebutuhan 8 jam akan kelebihan
* Jika jam dibagi (parsial) → bisa muncul sisa jam
* Jika sisa jam diberikan ke mahasiswa lain → jumlah orang bisa melebihi kuota (over capacity)

Selain itu:

* Sistem tidak boleh menghasilkan kondisi ruangan melebihi kapasitas
* Sistem harus tetap mengakomodasi mahasiswa dengan kebutuhan jam kecil
* Sistem harus meminimalkan pekerjaan yang tidak terisi

---

#### 🎯 Goal Sistem

Membangun algoritma auto-assignment yang:

* Mengalokasikan pekerjaan ke mahasiswa secara otomatis
* Menjaga jumlah orang tidak melebihi kuota
* Memastikan distribusi jam tetap optimal dan adil
* Meminimalkan sisa jam yang tidak terpakai

---

#### 💡 Solusi yang Diinginkan

Gunakan pendekatan berikut:

1. **Pisahkan konsep:**

   * Total jam pekerjaan (workload)
   * Kuota orang (capacity constraint)

2. **Assignment Strategy:**

   * Pilih maksimal N orang sesuai kuota
   * Distribusikan total jam ke orang-orang tersebut
   * Jika ada sisa jam:
     → dialokasikan ke orang yang sama (bukan menambah orang baru)

3. **Aturan tambahan:**

   * Mahasiswa boleh menerima jam lebih dari kebutuhannya dalam batas tertentu (misal +2 jam)
   * Tidak boleh menambah jumlah orang melebihi kuota
   * Prioritaskan mahasiswa dengan kebutuhan jam paling kecil terlebih dahulu agar beban mereka cepat selesai.

4. **Fallback Mechanism:**

   * Jika tidak ada kombinasi ideal:
     → tetap gunakan maksimal kuota orang
     → distribusi jam dilakukan seoptimal mungkin

---

#### 🧠 Expected Output dari AI Agent

Tolong hasilkan:

1. Desain algoritma (step-by-step)
2. Pseudocode / implementasi logic (JavaScript / TypeScript)
3. Struktur data yang direkomendasikan
4. Penanganan edge case (contoh: semua mahasiswa jam kecil, atau jam tidak habis terbagi)
5. (Opsional) Saran peningkatan sistem untuk skala besar

---

#### 🚫 Constraint Penting

* Tidak boleh menambah jumlah orang melebihi kuota
* Tidak boleh membiarkan pekerjaan kosong jika masih ada mahasiswa yang bisa mengisi
* Harus mempertimbangkan real-world constraint (kapasitas ruangan)



---

## ⏳ TAHAP 3 (DALAM RENCANA): TAB PENUGASAN (Verifikasi & Validasi)

### Overview
Tab Penugasan berfungsi untuk memverifikasi pekerjaan mahasiswa yang sudah selesai dikerjakan. Admin dapat menyetujui (verifikasi) atau menolak penugasan dengan alasan penolakan.

### Status Penugasan (dari ref_status_tugas)
| ID | Status | Keterangan |
|----|--------|-----------|
| 1 | MENUNGGU | Belum mulai mengerjakan |
| 2 | SEDANG_DIKERJAKAN | Sedang dikerjakan mahasiswa |
| 3 | SELESAI | Selesai, menunggu verifikasi admin |
| 4 | DIVERIFIKASI | Sudah diverifikasi dan jam kompen dipotong |

### Files yang Akan Dibuat:
| File | Keterangan |
|------|-----------|
| `actions/penugasan.ts` | Server actions: getDaftarPenugasan, verifyPenugasan, rejectPenugasan |
| `types/index.ts` | Tambahkan type PenugasanRow, VerifyResult, VerifyParams, RejectParams |

### Files yang Dimodifikasi:
| File | Keterangan |
|------|-----------|
| `components/TabPenugasan.tsx` | Replace dummy data dengan fetch dari DB + full fitur |

---

### Backend: Server Actions

#### 1. Get Daftar Penugasan
- **Endpoint:** `getDaftarPenugasan(params?)`
- **Input:** `{ semester_id?, status_filter?, limit?: 10, offset?: 0 }`
- **Output:** `{ data: PenugasanRow[], total: number }`
- **Filter Status:**
  - "pending" = status_tugas_id IN (1, 2) - Belum selesai
  - "selesai" = status_tugas_id = 3 - Menunggu verifikasi
  - "semua" = semua status
- **DB:** `prisma.penugasan.findMany()` dengan relations:
  - mahasiswa (nama, nim)
  - pekerjaan (judul, poin_jam)
  - status_tugas (nama)
- **Includes:** Semester aktif otomatis jika tidak ditentukan

#### 2. Verify Penugasan (Setuju + Potong Jam)
- **Endpoint:** `verifyPenugasan(id, nipStaf)`
- **Input:** `{ penugasan_id, verifikasi_oleh_nip }`
- **Logika:**
  1. Fetch penugasan untuk dapat `pekerjaan.poin_jam` dan `mahasiswa.nim`
  2. Insert ke `Log_potong_jam` (nim, semester_id, penugasan_id, jam_dikurangi)
  3. Update `penugasan`: 
     - `status_tugas_id` = 4 (DIVERIFIKASI)
     - `diverifikasi_oleh_nip` = nip staf
     - `waktu_verifikasi` = NOW()
- **Output:** `{ success: true }` atau `{ success: false, error }`
- **DB:** 
  - `prisma.log_potong_jam.create()`
  - `prisma.penugasan.update()`

#### 3. Reject Penugasan (Tolak)
- **Endpoint:** `rejectPenugasan(id, alasan)`
- **Input:** `{ penugasan_id, catatan_verifikasi }`
- **Logika:**
  1. Update `penugasan`:
     - `status_tugas_id` = 2 (SEDANG_DIKERJAKAN) - Kembalikan ke status proses
     - `catatan_verifikasi` = alasan penolakan dari admin
     - `diverifikasi_oleh_nip` = tetap (null)
     - `waktu_verifikasi` = null
- **Output:** `{ success: true }` atau `{ success: false, error }`
- **DB:** `prisma.penugasan.update()`

---

### Frontend: TabPenugasan.tsx

#### Fitur:
1. **List Penugasan** - Tampilkan tabel dengan data dari DB
2. **Filter Tabs** - Pending | Selesai | Semua
3. **Pagination** - 10/25/50 data per halaman (sama seperti TabKelola)
4. **Modal Verifikasi** - Preview bukti + konfirmasi setuju
5. **Modal Tolak** - Input alasan penolakan

#### UI Components:
| Komponen | Deskripsi |
|----------|-----------|
| Filter Tabs | 3 tombol: Pending (bg-blue), Selesai, Semua |
| Search | Input cari NIM/nama mahasiswa |
| Tabel | Kolom: Mahasiswa, Pekerjaan, Jam, Tanggal, Status, Aksi |
| Pagination | Dropdown limit + prev/next + info "Menampilkan X-Y dari Z" |
| Modal Verifikasi | Preview foto mulai/selesai + tombol Setuju/Tolak |
| Modal Tolak | Textarea alasan + konfirmasi |

#### TypeScript Interfaces (PenugasanRow):
```typescript
interface PenugasanRow {
  id: number;
  nim: string;
  mahasiswa_nama: string;
  pekerjaan_id: number;
  pekerjaan_judul: string;
  poin_jam: number;
  status_tugas_id: number;
  status_nama: string;
  created_at: string;
  catatan_verifikasi: string | null;
  diverifikasi_oleh_nip: string | null;
  waktu_verifikasi: string | null;
}
```

---

### Best Practice: Logika Potong Jam

```
1. Ambil poin_jam dari pekerjaan terkait (dari relasi penugasan.pekerjaan)
2. Ambil semester_id dari pekerjaan (dari relasi penugasan.pekerjaan.semester)
3. Ambil nim mahasiswa dari penugasan.mahasiswa
4. Insert Log_potong_jam:
   { nim, semester_id, penugasan_id, jam_dikurangi: poin_jam }
5. Update status penugasan ke DIVERIFIKASI (4)
6. Simpan diverifikasi_oleh_nip dan waktu_verifikasi
```

---

### Tabel Database yang Tershubung:
| Tabel | Relasi |
|-------|-------|
| `penugasan` | Data utama penugasan |
| `mahasiswa` | Info mahasiswa (nim, nama) |
| `daftar_pekerjaan` | Pekerjaan yang ditugaskan (judul, poin_jam) |
| `ref_status_tugas` | Status penugasan (1-4) |
| `log_potong_jam` | Record pemotongan jam kompen |
| `staf` | Siapa yang memverifikasi |
| `semester` | Semester aktif |

---
