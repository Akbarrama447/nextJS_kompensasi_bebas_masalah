/**
 * excel-parser.ts
 * Utility untuk mem-parse file Excel (.xlsx) atau CSV (.csv)
 * menjadi array ParsedStudent yang siap diproses server action.
 */

import * as XLSX from 'xlsx';

// ─────────────────────────────────────────
// Types
// ─────────────────────────────────────────

export interface ParsedStudent {
  nim: string;
  nama: string;
  kelas: string;
  jam: number;
}

export interface ParseResult {
  students: ParsedStudent[];
  errors: string[]; // baris yang gagal di-parse
}

// ─────────────────────────────────────────
// Main Parser
// ─────────────────────────────────────────

export async function parseExcelFile(file: File): Promise<ParseResult> {
  const students: ParsedStudent[] = [];
  const errors: string[] = [];

  // Baca file sebagai ArrayBuffer
  const buffer = await file.arrayBuffer();
  const workbook = XLSX.read(buffer, { type: 'array' });

  // Ambil sheet pertama
  const sheetName = workbook.SheetNames[0];
  if (!sheetName) {
    return { students: [], errors: ['File tidak memiliki sheet.'] };
  }

  const sheet = workbook.Sheets[sheetName];

  // Konversi ke format array 2D (baris dan kolom array)
  // header: 1 artinya kita minta output array dari array (bukan objek JSON)
  const rows = XLSX.utils.sheet_to_json<any[]>(sheet, {
    header: 1,
    defval: '',
  });

  if (rows.length === 0) {
    return { students: [], errors: ['Sheet kosong atau tidak ada data.'] };
  }

  // Variabel untuk melacak index kolom jika kita menemukan header
  let nimIdx = -1;
  let namaIdx = -1;
  let kelasIdx = -1;
  let jamIdx = -1;

  // Scan baris demi baris
  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const lineNum = i + 1; // Untuk pesan error (1-indexed)

    // 1. Cek apakah baris ini adalah baris Header
    let tempNim = -1, tempNama = -1, tempKelas = -1, tempJam = -1;
    
    for (let j = 0; j < row.length; j++) {
      const cell = String(row[j]).toLowerCase().trim();
      if (cell === 'nim' || cell === 'no. induk') tempNim = j;
      else if (cell === 'nama' || cell === 'nama mahasiswa') tempNama = j;
      else if (cell === 'kelas' || cell === 'nama kelas') tempKelas = j;
      else if (cell === 'jam' || cell === 'jam kompen' || cell === 'total jam' || cell === 'jam wajib') tempJam = j;
    }

    // Jika kita menemukan minimal kolom NIM dan NAMA, kita anggap ini baris header
    if (tempNim !== -1 && tempNama !== -1) {
      nimIdx = tempNim;
      namaIdx = tempNama;
      if (tempKelas !== -1) kelasIdx = tempKelas;
      if (tempJam !== -1) jamIdx = tempJam;
      continue; // Lanjut ke baris berikutnya (karena baris ini cuma header)
    }

    // 2. Jika kita sudah punya referensi kolom (dari header sebelumnya), kita coba parse datanya
    if (nimIdx !== -1 && namaIdx !== -1 && kelasIdx !== -1 && jamIdx !== -1) {
      const nim = String(row[nimIdx] ?? '').trim();
      const nama = String(row[namaIdx] ?? '').trim();
      const kelas = String(row[kelasIdx] ?? '').trim();
      const jamRaw = String(row[jamIdx] ?? '').trim();

      // Skip baris jika NIM dan NAMA kosong (pasti baris judul seperti "Semester: 20251" atau baris kosong)
      if (!nim && !nama) {
        continue;
      }

      // Skip jika kebetulan NIM berisi kata-kata header yang nyasar
      if (nim.toLowerCase().includes('nim') || nama.toLowerCase().includes('nama')) {
        continue;
      }

      // Validasi data (kalau salah satu ada yang isi, tapi yang lain kosong)
      if (!nim) { errors.push(`Baris ${lineNum}: NIM kosong untuk mahasiswa "${nama}".`); continue; }
      if (!nama) { errors.push(`Baris ${lineNum}: Nama kosong (NIM: ${nim}).`); continue; }
      if (!kelas) { errors.push(`Baris ${lineNum}: Kelas kosong (NIM: ${nim}).`); continue; }

      const jam = parseFloat(jamRaw);
      // Jam bisa 0, jadi validasinya hanya cek NaN atau negatif
      if (isNaN(jam) || jam < 0) {
        errors.push(`Baris ${lineNum}: Jam tidak valid "${jamRaw}" (NIM: ${nim}).`);
        continue;
      }

      students.push({ nim, nama, kelas, jam });
    }
  }

  // Jika sampai akhir tidak pernah ketemu header
  if (students.length === 0 && errors.length === 0) {
     return { 
       students: [], 
       errors: ['Gagal menemukan kolom NIM, NAMA, KELAS, dan JAM di dalam file. Pastikan nama header sesuai.'] 
     };
  }

  return { students, errors };
}
