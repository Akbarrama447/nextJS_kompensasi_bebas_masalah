'use server';

import { supabaseAdmin } from '@/lib/supabase/admin';
import type { ParsedStudent } from '@/lib/excel-parser';

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

  // 1. Create import_log record (status: proses = 1)
  const { data: log, error: logErr } = await supabaseAdmin
    .from('import_log')
    .insert({
      staf_nip: staffNip,
      semester_id: semesterId,
      nama_file: namaFile,
      total_baris: students.length,
      sukses_baris: 0,
      status_import_id: 1,
    })
    .select('id')
    .single();

  if (logErr || !log) {
    return { successCount: 0, errors: [{ nim: '-', nama: '-', error: `Gagal membuat log import: ${logErr?.message}` }], importLogId: null };
  }

  // 2. Fetch all kelas ONCE — avoid N+1
  const { data: kelasList } = await supabaseAdmin
    .from('kelas')
    .select('id, nama_kelas');
  const kelasMap = new Map((kelasList ?? []).map((k) => [k.nama_kelas, k.id]));

  // 3. Fetch mahasiswa role_id ONCE
  const { data: mhsRole } = await supabaseAdmin
    .from('roles')
    .select('id')
    .ilike('nama', 'mahasiswa')
    .single();

  const defaultPassword = process.env.DEFAULT_STUDENT_PASSWORD ?? 'Polines123!';

  // 4. Process each student
  for (const student of students) {
    try {
      // A. Resolve kelas_id
      const kelasId = kelasMap.get(student.kelas);
      if (!kelasId) {
        errors.push({ nim: student.nim, nama: student.nama, error: `Kelas '${student.kelas}' tidak ditemukan di database` });
        continue;
      }

      // B. Check if mahasiswa exists
      const { data: existingMhs } = await supabaseAdmin
        .from('mahasiswa')
        .select('nim')
        .eq('nim', student.nim)
        .maybeSingle();

      if (!existingMhs) {
        // C. AUTO-PROVISIONING
        const defaultEmail = `${student.nim.replace(/\./g, '')}@student.polines.ac.id`;

        // C1. Create Supabase Auth user
        const { data: authUser, error: authErr } = await supabaseAdmin.auth.admin.createUser({
          email: defaultEmail,
          password: defaultPassword,
          email_confirm: true,
        });
        if (authErr) throw new Error(`Auth: ${authErr.message}`);

        // C2. Create users table row
        const { data: newUser, error: userErr } = await supabaseAdmin
          .from('users')
          .insert({
            email: defaultEmail,
            kata_sandi: '[managed by supabase auth]',
            role_id: mhsRole?.id ?? 5,
          })
          .select('user_id')
          .single();
        if (userErr) throw new Error(`User: ${userErr.message}`);

        // C3. Create mahasiswa row
        const { error: mhsErr } = await supabaseAdmin
          .from('mahasiswa')
          .insert({
            nim: student.nim,
            nama: student.nama,
            user_id: newUser.user_id,
            kelas_id: kelasId,
          });
        if (mhsErr) throw new Error(`Mahasiswa: ${mhsErr.message}`);
      }

      // D. Upsert kompen_awal
      const { error: kompenErr } = await supabaseAdmin
        .from('kompen_awal')
        .upsert(
          {
            nim: student.nim,
            semester_id: semesterId,
            import_id: log.id,
            total_jam_wajib: student.jam,
          },
          { onConflict: 'nim,semester_id' }
        );
      if (kompenErr) throw new Error(`Kompen: ${kompenErr.message}`);

      successCount++;
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      errors.push({ nim: student.nim, nama: student.nama, error: msg });
    }
  }

  // 5. Finalize import_log
  const finalStatus = errors.length === 0 ? 2 : successCount === 0 ? 3 : 2;
  await supabaseAdmin
    .from('import_log')
    .update({
      sukses_baris: successCount,
      error_details: errors.length > 0 ? errors : null,
      status_import_id: finalStatus,
    })
    .eq('id', log.id);

  return { successCount, errors, importLogId: log.id };
}
