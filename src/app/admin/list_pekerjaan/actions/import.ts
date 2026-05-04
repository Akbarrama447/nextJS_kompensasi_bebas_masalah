'use server';

/**
 * actions/import.ts
 * Server Action untuk proses import data mahasiswa massal dari Excel.
 * Menggunakan Prisma (bukan Supabase client).
 *
 * Flow:
 * 1. Buat record import_log (status: proses)
 * 2. Fetch semua kelas ke Map → hindari N+1
 * 3. Fetch role_id mahasiswa sekali
 * 4. Loop tiap mahasiswa:
 *    a. Validasi kelas ada di DB
 *    b. Jika belum ada → auto-provisioning (users + mahasiswa)
 *    c. Upsert kompen_awal (nim + semester_id sebagai unique key)
 * 5. Finalize import_log dengan status akhir
 */

import prisma, { Prisma } from '@/lib/prisma';
import bcrypt from 'bcryptjs';
import type { ParsedStudent } from '@/lib/excel-parser';

// ─────────────────────────────────────────
// Constants
// ─────────────────────────────────────────

/** ID status pada tabel ref_status_import */
const IMPORT_STATUS = {
  PROSES: 1,
  SELESAI: 2,
  GAGAL: 3,
  PARTIAL: 4,
} as const;

// ─────────────────────────────────────────
// Types
// ─────────────────────────────────────────

export interface ImportPayload {
  students: ParsedStudent[];
  semesterId: number;
  staffNip: string;
  namaFile: string;
}

export interface ImportResult {
  successCount: number;
  errors: { nim: string; nama: string; error: string }[];
  importLogId: number | null;
}

// ─────────────────────────────────────────
// Server Action
// ─────────────────────────────────────────

export async function executeImport(payload: ImportPayload): Promise<ImportResult> {
  const { students, semesterId, staffNip, namaFile } = payload;
  const errors: { nim: string; nama: string; error: string }[] = [];
  let successCount = 0;

  // ── 0. Validasi & Fallback Staf NIP ──────────────────────────────────
  let finalStaffNip = staffNip;
  const staffExists = await prisma.staf.findUnique({ where: { nip: staffNip } });
  
  if (!staffExists) {
    const fallbackStaf = await prisma.staf.findFirst({ select: { nip: true } });
    if (fallbackStaf) {
      finalStaffNip = fallbackStaf.nip;
    } else {
      return {
        successCount: 0,
        errors: [{ nim: '-', nama: '-', error: 'Tidak ada data staf di database. Mohon buat data staf terlebih dahulu.' }],
        importLogId: null,
      };
    }
  }

  // ── 0.1 Validasi Semester ───────────────────────────────────────────
  let finalSemesterId = semesterId;
  const semesterExists = await prisma.semester.findUnique({ where: { id: semesterId } });
  if (!semesterExists) {
    const activeSemester = await prisma.semester.findFirst({ where: { is_aktif: true }, select: { id: true } });
    if (activeSemester) {
      finalSemesterId = activeSemester.id;
    } else {
      const firstSemester = await prisma.semester.findFirst({ select: { id: true } });
      if (firstSemester) {
        finalSemesterId = firstSemester.id;
      } else {
         return {
          successCount: 0,
          errors: [{ nim: '-', nama: '-', error: 'Tidak ada data semester di database.' }],
          importLogId: null,
        };
      }
    }
  }

  // ── 1. Buat record import_log (status: proses) ──────────────────────────
  let importLog: { id: number };
  try {
    importLog = await prisma.import_log.create({
      data: {
        staf_nip: finalStaffNip,
        semester_id: finalSemesterId,
        nama_file: namaFile,
        total_baris: students.length,
        sukses_baris: 0,
        status_import_id: IMPORT_STATUS.PROSES,
      },
      select: { id: true },
    });
  } catch (e) {
    console.error("Gagal membuat log import:", e);
    const msg = e instanceof Error ? e.message : String(e);
    try {
      const fs = require('fs');
      fs.writeFileSync('last_import_error.txt', `Systemic Error (import_log.create): ${msg}`);
    } catch (err) {}
    
    return {
      successCount: 0,
      errors: [{ 
        nim: '-', 
        nama: '-', 
        error: `Gagal memulai proses database. Error: ${msg}` 
      }],
      importLogId: null,
    };
  }

  // ── 2. Fetch semua kelas sekali — hindari N+1 ───────────────────────────
  const kelasList = await prisma.kelas.findMany({
    select: { id: true, nama_kelas: true },
  });
  // Normalisasi nama kelas (hapus spasi, lowercase) agar pencocokan kebal typo
  const normalizeKelas = (k: string) => k.replace(/\s+/g, '').toLowerCase();
  const kelasMap = new Map(kelasList.map((k) => [normalizeKelas(k.nama_kelas ?? ''), k.id]));

  // ── 3. Fetch role mahasiswa sekali ──────────────────────────────────────
  // Cari role mahasiswa — case insensitive
  let mhsRole = await prisma.roles.findFirst({
    where: { nama: { equals: 'mahasiswa', mode: 'insensitive' } },
    select: { id: true },
  });

  // Fallback: jika role 'mahasiswa' nggak ada, pake role pertama yang tersedia
  if (!mhsRole) {
    mhsRole = await prisma.roles.findFirst({
      select: { id: true },
      orderBy: { id: 'asc' },
    });
  }

  // Jika masih nggak ada role sama sekali, buat role mahasiswa
  if (!mhsRole) {
    mhsRole = await prisma.roles.create({
      data: {
        id: 1,
        nama: 'mahasiswa',
      },
      select: { id: true },
    });
  }

  const defaultPassword = process.env.DEFAULT_STUDENT_PASSWORD ?? 'Polines123!';
  const hashedPassword = await bcrypt.hash(defaultPassword, 10);

  // ── 4. Proses tiap mahasiswa ─────────────────────────────────────────────
  for (const student of students) {
    try {
      // A. Validasi kelas & Auto-Create Kelas
      const normalizedStudentKelas = student.kelas.replace(/\s+/g, '').toLowerCase();
      let kelasId = kelasMap.get(normalizedStudentKelas);
      
      if (!kelasId) {
        // Jika kelas belum ada, buat otomatis di tabel kelas
        const newKelas = await prisma.kelas.create({
          data: {
            nama_kelas: student.kelas.trim(), // Simpan nama asli sesuai Excel (contoh: "IK-1A")
          },
        });
        
        kelasId = newKelas.id;
        
        // Tambahkan ke memori (kelasMap) agar mahasiswa berikutnya di kelas yang sama tidak perlu insert ulang
        kelasMap.set(normalizedStudentKelas, kelasId);
      }

      // B. Cek apakah mahasiswa sudah ada
      const existingMhs = await prisma.mahasiswa.findUnique({
        where: { nim: student.nim },
        select: { nim: true },
      });

      if (!existingMhs) {
        // C. AUTO-PROVISIONING — buat akun baru
        let defaultEmail = `${student.nim.replace(/\./g, '')}@student.polines.ac.id`;
        
        // Poin 4: Proteksi Bentrok Email
        const emailExists = await prisma.users.findUnique({ where: { email: defaultEmail } });
        if (emailExists) {
           defaultEmail = `${student.nim.replace(/\./g, '')}_${Math.floor(Math.random() * 1000)}@student.polines.ac.id`;
        }

        // C1. Buat record di tabel users
        const newUser = await prisma.users.create({
          data: {
            email: defaultEmail,
            kata_sandi: hashedPassword,
            role_id: mhsRole.id,
          },
          select: { user_id: true },
        });

        // C2. Buat record mahasiswa
        await prisma.mahasiswa.create({
          data: {
            nim: student.nim,
            nama: student.nama,
            user_id: newUser.user_id,
          },
        });
      }

      // Poin 3 & Poin 2: Selalu pastikan dia terdaftar di kelas untuk semester ini (finalSemesterId)
      const existingReg = await prisma.registrasi_mahasiswa.findFirst({
        where: {
          nim: student.nim,
          semester_id: finalSemesterId
        }
      });

      if (!existingReg) {
        await prisma.registrasi_mahasiswa.create({
          data: {
            nim: student.nim,
            semester_id: finalSemesterId, // Menggunakan finalSemesterId
            kelas_id: kelasId,
            status: 'Aktif',
          },
        });
      }

      // D. Upsert kompen_awal
      const existingKompen = await prisma.kompen_awal.findFirst({
        where: { nim: student.nim, semester_id: finalSemesterId }, // Menggunakan finalSemesterId
        select: { id: true },
      });

      if (existingKompen) {
        await prisma.kompen_awal.update({
          where: { id: existingKompen.id },
          data: {
            total_jam_wajib: student.jam,
            import_id: importLog.id,
          },
        });
      } else {
        await prisma.kompen_awal.create({
          data: {
            nim: student.nim,
            semester_id: finalSemesterId, // Menggunakan finalSemesterId
            import_id: importLog.id,
            total_jam_wajib: student.jam,
          },
        });
      }

      successCount++;
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      // LOG ERROR AGAR BISA DILIHAT DI TERMINAL NEXT.JS
      console.log(`[IMPORT GAGAL] NIM: ${student.nim} | ALASAN: ${msg}`);
      errors.push({ nim: student.nim, nama: student.nama, error: msg });
    }
  }

  // ── 5. Finalize import_log ──────────────────────────────────────────────
  // Tulis error ke file supaya AI bisa membacanya tanpa UI web
  if (errors.length > 0) {
    try {
      const fs = require('fs');
      fs.writeFileSync('last_import_error.txt', JSON.stringify(errors, null, 2));
    } catch (err) {}
  }

  // Status: GAGAL jika 0 sukses, PARTIAL jika ada error + ada sukses, SELESAI jika tanpa error
  const finalStatus =
    successCount === 0
      ? IMPORT_STATUS.GAGAL
      : errors.length > 0
        ? IMPORT_STATUS.PARTIAL
        : IMPORT_STATUS.SELESAI;

  // Untuk field Json? nullable, Prisma butuh Prisma.JsonNull (bukan JS null)
  await prisma.import_log.update({
    where: { id: importLog.id },
    data: {
      sukses_baris: successCount,
      error_details: errors.length > 0 ? errors : Prisma.JsonNull,
      status_import_id: finalStatus,
    },
  });

  return { successCount, errors, importLogId: importLog.id };
}
