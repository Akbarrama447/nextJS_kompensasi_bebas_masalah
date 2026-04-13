/**
 * PARSER EXCEL KOMPEN POLINES
 *
 * Format file Excel Polines TIDAK standar:
 * Satu sheet bisa berisi BANYAK kelas, masing-masing dengan blok berulang:
 *
 *   Row N+0: ('Semester:', 20251, null, null, null)
 *   Row N+1: ('Minggu:', null, null, null, null)
 *   Row N+2: ('Kelas:', 'IK-1A', null, null, null)
 *   Row N+3: (null, null, null, null, null)        ← spacer
 *   Row N+4: ('NO', 'KELAS', 'NIM', 'NAMA', 'JAM') ← header
 *   Row N+5+: baris data siswa
 *   Row N+K: (null, null, null, null, null)        ← akhir blok
 *
 * GUNAKAN HANYA DI CLIENT COMPONENT — jangan import di server.
 */

import * as XLSX from 'xlsx';

export interface ParsedStudent {
  no: number;
  kelas: string;
  nim: string;
  nama: string;
  jam: number;
}

export interface ParsedBlock {
  semester: number; // e.g. 20251
  kelas: string;    // e.g. 'IK-1A'
  students: ParsedStudent[];
}

/**
 * Parse file Excel kompen Polines dari ArrayBuffer.
 * Hanya mahasiswa dengan JAM > 0 yang dimasukkan ke hasil.
 *
 * @param buffer - ArrayBuffer dari file upload (FileReader.readAsArrayBuffer)
 * @returns Array of ParsedBlock, satu per kelas yang ditemukan
 */
export function parseKompenExcel(buffer: ArrayBuffer): ParsedBlock[] {
  const wb = XLSX.read(buffer, { type: 'array' });
  const ws = wb.Sheets[wb.SheetNames[0]];
  const rows: any[][] = XLSX.utils.sheet_to_json(ws, {
    header: 1,
    defval: null,
  });

  const blocks: ParsedBlock[] = [];
  let i = 0;

  while (i < rows.length) {
    const row = rows[i];

    // Deteksi awal blok kelas: kolom pertama === 'Semester:' dengan nilai di kolom kedua
    if (row && row[0] === 'Semester:' && row[1] != null) {
      const semester = Number(row[1]); // e.g. 20251

      // Row N+2: ('Kelas:', 'IK-1A', ...)
      const kelasRow = rows[i + 2];
      const kelas = String(kelasRow?.[1] ?? '').trim();

      // Data siswa mulai di N+5 (skip: Semester, Minggu, Kelas, spacer, header)
      const dataStart = i + 5;
      const students: ParsedStudent[] = [];

      let j = dataStart;
      while (j < rows.length) {
        const r = rows[j];

        // Baris kosong = akhir blok kelas
        if (!r || r.every((cell: any) => cell == null)) break;

        // Blok berikutnya dimulai = akhir blok ini
        if (r[0] === 'Semester:') break;

        const no = Number(r[0] ?? 0);
        const nim = String(r[2] ?? '').trim();
        const nama = String(r[3] ?? '').trim();
        const jam = Number(r[4] ?? 0);

        // Filter: hanya mahasiswa dengan NIM valid DAN utang jam > 0
        if (nim && nama && jam > 0) {
          students.push({ no, kelas, nim, nama, jam });
        }

        j++;
      }

      // Hanya push blok jika ada data valid
      if (kelas && students.length > 0) {
        blocks.push({ semester, kelas, students });
      }

      i = j; // lanjut dari baris setelah akhir blok
    } else {
      i++;
    }
  }

  return blocks;
}

// ============================================================
// VALIDATION STATUS TYPES (untuk preview table)
// ============================================================

export type RowValidationStatus =
  | 'siap'       // kelas ada di DB, NIM sudah terdaftar → update kompen_awal
  | 'baru'       // kelas ada di DB, NIM belum ada → akan auto-register
  | 'error_kelas'; // kelas TIDAK ditemukan di DB → akan diskip

export interface ValidatedStudent extends ParsedStudent {
  validationStatus: RowValidationStatus;
  kelasId: number | null; // null jika error_kelas
}

export interface ValidationSummary {
  totalBlocks: number;
  totalStudents: number;
  siapCount: number;
  baruCount: number;
  errorKelasCount: number;
}

/**
 * Hitung summary dari hasil validasi.
 */
export function calcValidationSummary(
  students: ValidatedStudent[]
): ValidationSummary {
  return {
    totalBlocks: new Set(students.map((s) => s.kelas)).size,
    totalStudents: students.length,
    siapCount: students.filter((s) => s.validationStatus === 'siap').length,
    baruCount: students.filter((s) => s.validationStatus === 'baru').length,
    errorKelasCount: students.filter((s) => s.validationStatus === 'error_kelas').length,
  };
}

/**
 * Cek apakah ada setidaknya satu baris valid (siap atau baru).
 * Digunakan untuk mengaktifkan tombol "Konfirmasi Import".
 */
export function hasValidRows(students: ValidatedStudent[]): boolean {
  return students.some(
    (s) => s.validationStatus === 'siap' || s.validationStatus === 'baru'
  );
}
