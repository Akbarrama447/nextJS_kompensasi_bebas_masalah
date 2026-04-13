'use client';

import { useState, useCallback } from 'react';
import { AlertCircle, Info, CheckCircle2, Upload, Loader2, XCircle } from 'lucide-react';
import ExcelDropzone from '@/components/import/ExcelDropzone';
import { parseKompenExcel, calcValidationSummary, hasValidRows } from '@/lib/excel-parser';
import type { ParsedBlock, ValidatedStudent } from '@/lib/excel-parser';
import { createClient } from '@/lib/supabase/client';
import { executeImport } from '@/app/actions/import';
import { useAuth } from '@/contexts/AuthContext';
import { formatTanggalWaktu, getStatusImportBadge } from '@/lib/utils';
import type { Staf } from '@/lib/types';
import toast from 'react-hot-toast';

// ─── Step type ───
type Step = 'upload' | 'preview' | 'executing' | 'done';

// ─────────────────────────────────────────
// Validation status pills
// ─────────────────────────────────────────
function ValidationPill({ status }: { status: ValidatedStudent['validationStatus'] }) {
  const map = {
    siap:        { cls: 'badge badge-green', label: 'Siap' },
    baru:        { cls: 'badge badge-blue',  label: 'Baru' },
    error_kelas: { cls: 'badge badge-red',   label: 'Error: Kelas' },
  };
  const s = map[status];
  return <span className={s.cls}>{s.label}</span>;
}

// ─────────────────────────────────────────
// Main import page
// ─────────────────────────────────────────
export default function ImportPage() {
  const { user } = useAuth();
  const supabase = createClient();

  // Steps
  const [step, setStep] = useState<Step>('upload');

  // Step 1 — file
  const [file, setFile] = useState<File | null>(null);
  const [parsing, setParsing] = useState(false);
  const [blocks, setBlocks] = useState<ParsedBlock[]>([]);

  // Step 2 — validation
  const [validatedStudents, setValidatedStudents] = useState<ValidatedStudent[]>([]);
  const [validating, setValidating] = useState(false);
  const [semesterId, setSemesterId] = useState<number | null>(null);
  const [activeSemester, setActiveSemester] = useState<{ id: number; nama: string } | null>(null);

  // Step 3 — execution
  const [progress, setProgress] = useState(0);
  const [successCount, setSuccessCount] = useState(0);
  const [importErrors, setImportErrors] = useState<{ nim: string; nama: string; error: string }[]>([]);

  // History
  const [importLogs, setImportLogs] = useState<any[]>([]);
  const [logsLoaded, setLogsLoaded] = useState(false);

  // ── Fetch active semester on mount ──
  const fetchActiveSemester = useCallback(async () => {
    const { data } = await supabase
      .from('semester')
      .select('id, nama')
      .eq('is_aktif', true)
      .maybeSingle();
    if (data) {
      setActiveSemester(data);
      setSemesterId(data.id);
    }
  }, [supabase]);

  // ── Fetch import history ──
  const fetchHistory = useCallback(async () => {
    if (!user) return;
    const profile = user.profile as Staf;
    const { data } = await supabase
      .from('import_log')
      .select('id, nama_file, created_at, total_baris, sukses_baris, status_import_id, error_details')
      .eq('staf_nip', profile?.nip ?? '')
      .order('created_at', { ascending: false })
      .limit(20);
    setImportLogs(data ?? []);
    setLogsLoaded(true);
  }, [user, supabase]);

  // ── Step 1: handle file parsed ──
  const handleFileParsed = useCallback(async (f: File, buffer: ArrayBuffer) => {
    setParsing(true);
    setFile(f);
    await fetchActiveSemester();
    try {
      const parsed = parseKompenExcel(buffer);
      setBlocks(parsed);
      if (parsed.length === 0) {
        toast.error('Tidak ada data valid ditemukan di file ini.');
        setParsing(false);
        return;
      }
      // Start pre-validation
      await runValidation(parsed);
    } catch (err) {
      toast.error('Gagal membaca file Excel. Pastikan format sesuai.');
    }
    setParsing(false);
  }, [fetchActiveSemester]);

  // ── Pre-validation against DB ──
  const runValidation = async (parsedBlocks: ParsedBlock[]) => {
    setValidating(true);
    try {
      // Fetch all kelas names
      const { data: kelasList } = await supabase.from('kelas').select('id, nama_kelas');
      const kelasMap = new Map((kelasList ?? []).map((k) => [k.nama_kelas, k.id]));

      // Collect all NIMs from parsed data
      const allStudents = parsedBlocks.flatMap((b) => b.students);
      const allNims = allStudents.map((s) => s.nim);

      // Batch fetch existing mahasiswa
      const { data: existingMhs } = await supabase
        .from('mahasiswa')
        .select('nim')
        .in('nim', allNims);
      const existingSet = new Set((existingMhs ?? []).map((m) => m.nim));

      // Build validated students
      const validated: ValidatedStudent[] = allStudents.map((s) => {
        const kelasId = kelasMap.get(s.kelas) ?? null;
        if (!kelasId) return { ...s, validationStatus: 'error_kelas', kelasId: null };
        if (existingSet.has(s.nim)) return { ...s, validationStatus: 'siap', kelasId };
        return { ...s, validationStatus: 'baru', kelasId };
      });

      setValidatedStudents(validated);
      setStep('preview');
    } finally {
      setValidating(false);
    }
  };

  // ── Step 3: Execute import ──
  const handleConfirmImport = async () => {
    if (!semesterId || !file || !user) return;
    const profile = user.profile as Staf;

    // Only import non-error students
    const validStudents = validatedStudents
      .filter((s) => s.validationStatus !== 'error_kelas')
      .map(({ no, kelas, nim, nama, jam }) => ({ no, kelas, nim, nama, jam }));

    setStep('executing');
    setProgress(0);

    // Simulate progress ticks while server action runs
    const interval = setInterval(() => {
      setProgress((p) => Math.min(p + 2, 92));
    }, 300);

    try {
      const result = await executeImport({
        students: validStudents,
        semesterId,
        staffNip: profile?.nip ?? '',
        namaFile: file.name,
      });

      clearInterval(interval);
      setProgress(100);
      setSuccessCount(result.successCount);
      setImportErrors(result.errors);
      setStep('done');

      if (result.errors.length === 0) {
        toast.success(`Import berhasil! ${result.successCount} mahasiswa diproses.`);
      } else {
        toast(`Import selesai: ${result.successCount} berhasil, ${result.errors.length} gagal.`, { icon: '⚠️' });
      }
      await fetchHistory();
    } catch (err) {
      clearInterval(interval);
      toast.error('Import gagal. Silakan coba lagi.');
      setStep('preview');
    }
  };

  const summary = calcValidationSummary(validatedStudents);
  const canImport = hasValidRows(validatedStudents);

  return (
    <div className="space-y-6 max-w-5xl">
      {/* Page title */}
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Import Excel Kompen</h1>
        <p className="text-slate-500 text-sm mt-1">Upload file Excel Polines untuk registrasi data kompen mahasiswa.</p>
      </div>

      {/* Prerequisite warning */}
      <div className="flex gap-3 bg-amber-50 border border-amber-200 rounded-xl px-5 py-4">
        <AlertCircle className="w-5 h-5 text-amber-500 flex-shrink-0 mt-0.5" />
        <div className="text-sm text-amber-800">
          <p className="font-medium mb-0.5">Prasyarat Penting</p>
          <p>Pastikan master data <strong>Jurusan</strong>, <strong>Prodi</strong>, dan <strong>Kelas</strong> sudah diisi sebelum import.
          Sistem akan gagal jika nama kelas di Excel (misal: <code className="bg-amber-100 px-1 rounded">IK-1A</code>) tidak ditemukan di tabel kelas.</p>
        </div>
      </div>

      {/* ── STEP 1: Upload ── */}
      {(step === 'upload' || parsing || validating) && (
        <div className="card space-y-4">
          <h2 className="font-semibold text-slate-800 flex items-center gap-2">
            <span className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
            Upload File Excel
          </h2>
          <ExcelDropzone onFileParsed={handleFileParsed} disabled={parsing || validating} />
          {(parsing || validating) && (
            <div className="flex items-center gap-2 text-sm text-blue-600">
              <Loader2 className="w-4 h-4 animate-spin" />
              {parsing ? 'Membaca file Excel...' : 'Memvalidasi data ke database...'}
            </div>
          )}
        </div>
      )}

      {/* ── STEP 2: Preview + Validation ── */}
      {step === 'preview' && (
        <div className="card space-y-5">
          <h2 className="font-semibold text-slate-800 flex items-center gap-2">
            <span className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs font-bold">2</span>
            Preview &amp; Validasi
          </h2>

          {/* Summary chips */}
          <div className="flex flex-wrap gap-3">
            <div className="flex items-center gap-1.5 text-sm font-medium">
              <Info className="w-4 h-4 text-slate-400" />
              <span className="text-slate-600">{summary.totalBlocks} kelas, {summary.totalStudents} mahasiswa</span>
            </div>
            <span className="badge badge-green">{summary.siapCount} Siap</span>
            <span className="badge badge-blue">{summary.baruCount} Baru (akan didaftarkan)</span>
            {summary.errorKelasCount > 0 && (
              <span className="badge badge-red">{summary.errorKelasCount} Error Kelas (akan diskip)</span>
            )}
          </div>

          {/* Semester info */}
          {activeSemester && (
            <div className="flex items-center gap-2 text-sm text-slate-600 bg-slate-50 rounded-lg px-4 py-2.5">
              <Info className="w-4 h-4 text-slate-400" />
              Menggunakan semester aktif: <strong>{activeSemester.nama}</strong>
            </div>
          )}

          {/* Table */}
          <div className="table-wrapper max-h-[400px] overflow-y-auto">
            <table className="table-base">
              <thead>
                <tr>
                  <th>Status</th>
                  <th>NIM</th>
                  <th>Nama</th>
                  <th>Kelas</th>
                  <th className="text-right">Jam Wajib</th>
                </tr>
              </thead>
              <tbody>
                {validatedStudents.map((s, i) => (
                  <tr key={i} className={s.validationStatus === 'error_kelas' ? 'opacity-50' : ''}>
                    <td><ValidationPill status={s.validationStatus} /></td>
                    <td className="font-mono text-xs">{s.nim}</td>
                    <td>{s.nama}</td>
                    <td>{s.kelas}</td>
                    <td className="text-right font-semibold">{s.jam}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Actions */}
          <div className="flex flex-col sm:flex-row gap-3 pt-2">
            <button
              onClick={() => { setStep('upload'); setValidatedStudents([]); setBlocks([]); }}
              className="btn-ghost w-full sm:w-auto justify-center"
            >
              Batalkan
            </button>
            <button
              onClick={handleConfirmImport}
              disabled={!canImport}
              className="btn-primary w-full sm:w-auto justify-center"
            >
              <Upload className="w-4 h-4" />
              Konfirmasi Import ({summary.siapCount + summary.baruCount} mahasiswa)
            </button>
          </div>
        </div>
      )}

      {/* ── STEP 3: Executing ── */}
      {step === 'executing' && (
        <div className="card space-y-4">
          <h2 className="font-semibold text-slate-800 flex items-center gap-2">
            <Loader2 className="w-4 h-4 animate-spin text-blue-600" />
            Memproses Import...
          </h2>
          <div className="h-3 bg-slate-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-blue-500 rounded-full transition-all duration-300"
              style={{ width: `${progress}%` }}
            />
          </div>
          <p className="text-sm text-slate-500">Mohon tunggu. Jangan tutup halaman ini.</p>
        </div>
      )}

      {/* ── STEP 4: Done ── */}
      {step === 'done' && (
        <div className="card space-y-4">
          <div className="flex items-center gap-3">
            <CheckCircle2 className="w-6 h-6 text-green-500" />
            <h2 className="font-semibold text-slate-800">Import Selesai</h2>
          </div>
          <div className="flex gap-6 text-sm">
            <div>
              <p className="text-slate-500">Berhasil</p>
              <p className="text-2xl font-bold text-green-600">{successCount}</p>
            </div>
            <div>
              <p className="text-slate-500">Gagal</p>
              <p className="text-2xl font-bold text-red-500">{importErrors.length}</p>
            </div>
          </div>

          {importErrors.length > 0 && (
            <div className="table-wrapper">
              <table className="table-base">
                <thead><tr><th>NIM</th><th>Nama</th><th>Error</th></tr></thead>
                <tbody>
                  {importErrors.map((e, i) => (
                    <tr key={i}>
                      <td className="font-mono text-xs">{e.nim}</td>
                      <td>{e.nama}</td>
                      <td className="text-red-600 text-xs">{e.error}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          <button
            onClick={() => { setStep('upload'); setValidatedStudents([]); setBlocks([]); setFile(null); }}
            className="btn-primary"
          >
            Import File Baru
          </button>
        </div>
      )}

      {/* ── Import History ── */}
      <div className="card space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="font-semibold text-slate-800">Riwayat Import</h2>
          <button onClick={fetchHistory} className="text-xs text-blue-600 hover:underline">
            Refresh
          </button>
        </div>
        {!logsLoaded ? (
          <button onClick={fetchHistory} className="btn-ghost text-sm">
            Muat riwayat import
          </button>
        ) : importLogs.length === 0 ? (
          <p className="text-sm text-slate-400">Belum ada riwayat import.</p>
        ) : (
          <div className="table-wrapper">
            <table className="table-base">
              <thead>
                <tr>
                  <th>Nama File</th>
                  <th>Tanggal</th>
                  <th>Total</th>
                  <th>Sukses</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {importLogs.map((log) => {
                  const badge = getStatusImportBadge(log.status_import_id);
                  return (
                    <tr key={log.id}>
                      <td className="max-w-[200px] truncate font-medium">{log.nama_file}</td>
                      <td className="text-xs text-slate-500">{formatTanggalWaktu(log.created_at)}</td>
                      <td>{log.total_baris}</td>
                      <td>{log.sukses_baris}</td>
                      <td><span className={`badge ${badge.className}`}>{badge.label}</span></td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
