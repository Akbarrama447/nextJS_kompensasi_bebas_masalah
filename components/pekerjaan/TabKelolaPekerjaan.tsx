'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { useRouter } from 'next/navigation';
import {
  Plus,
  Shuffle,
  Loader2,
  Edit2,
  Eye,
  EyeOff,
  Trash2,
  Users,
  FileSpreadsheet
} from 'lucide-react';
import { formatJam, formatTanggal } from '@/lib/utils';
import StatusBadge from '@/components/ui/StatusBadge';
import AddJobModal from './AddJobModal';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import EmptyState from '@/components/ui/EmptyState';
import toast from 'react-hot-toast';

interface TabKelolaPekerjaanProps {
  staffNip: string;
  semesterId: number;
}

export default function TabKelolaPekerjaan({ staffNip, semesterId }: TabKelolaPekerjaanProps) {
  const [loading, setLoading] = useState(true);
  const [plotting, setPlotting] = useState(false);
  const [pekerjaan, setPekerjaan] = useState<any[]>([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [editingJob, setEditingJob] = useState<any>(null);
  const supabase = createClient();
  const router = useRouter();

  const fetchPekerjaan = useCallback(async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('daftar_pekerjaan')
        .select(`
          id, judul, deskripsi, tipe_pekerjaan_id, poin_jam, kuota, is_aktif, tanggal_selesai, created_at,
          penugasan:penugasan(status_tugas_id)
        `)
        .eq('staf_nip', staffNip)
        .eq('semester_id', semesterId)
        .order('created_at', { ascending: false });

      if (error) throw error;

      const dataWithQuota = data.map((job: any) => {
        const activeAssignments = job.penugasan?.filter((p: any) => p.status_tugas_id !== 4).length || 0;
        return {
          ...job,
          quotaRemaining: job.kuota === null ? 'Unlimited' : Math.max(0, job.kuota - activeAssignments)
        };
      });

      setPekerjaan(dataWithQuota);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [supabase, staffNip, semesterId]);

  useEffect(() => {
    fetchPekerjaan();
  }, [fetchPekerjaan]);

  const handleToggleAktif = async (id: number, current: boolean) => {
    const { error } = await supabase.from('daftar_pekerjaan').update({ is_aktif: !current }).eq('id', id);
    if (error) toast.error(error.message);
    else fetchPekerjaan();
  };

  const handleDelete = async (id: number) => {
    if (!confirm('Hapus pekerjaan ini?')) return;
    const { error } = await supabase.from('daftar_pekerjaan').delete().eq('id', id);
    if (error) toast.error(error.message);
    else fetchPekerjaan();
  };

  const handleGeneratePlotting = async () => {
    if (!confirm("Jalankan algoritma plotting otomatis?")) return;
    setPlotting(true);
    try {
      // 1. Fetch Students with debt ordered by sisa_jam DESC
      const { data: sisaData, error: fetchErr } = await supabase
        .from('v_sisa_kompen')
        .select('nim, sisa_jam')
        .eq('semester_id', semesterId)
        .gt('sisa_jam', 0)
        .order('sisa_jam', { ascending: false });

      if (fetchErr) throw fetchErr;
      if (!sisaData || sisaData.length === 0) {
        toast('Tidak ada mahasiswa dengan hutang jam.', { icon: 'ℹ️' });
        return;
      }

      // 1.1 Fetch Mahasiswa details to get kelas_id
      const nims = sisaData.map(s => s.nim);
      const { data: mhsData } = await supabase
        .from('mahasiswa')
        .select('nim, kelas_id')
        .in('nim', nims);

      const mhsMap = new Map((mhsData || []).map(m => [m.nim, m.kelas_id]));

      // Flatten the data for easier processing
      const students = sisaData.map((s: any) => ({
        nim: s.nim,
        sisa_jam: s.sisa_jam,
        kelas_id: mhsMap.get(s.nim)
      }));

      // 2. Fetch Classes that are currently in pending ekuivalensi
      const { data: pendingEkuivalensi } = await supabase
        .from('ekuivalensi_kelas')
        .select('kelas_id')
        .eq('semester_id', semesterId)
        .eq('status_ekuivalensi_id', 1);

      const blockedKelasIds = new Set(pendingEkuivalensi?.map(e => e.kelas_id) || []);

      // 3. Filter out candidates from blocked classes
      const validCandidates = students.filter(s => s.kelas_id && !blockedKelasIds.has(s.kelas_id));

      if (validCandidates.length === 0) {
        toast.error('Semua mahasiswa berkendala sedang dalam proses verifikasi nota kelas.');
        setPlotting(false);
        return;
      }

      // 4. Fetch Active Jobs specifically for THIS STAFF in this semester
      const { data: jobs, error: jobErr } = await supabase
        .from('daftar_pekerjaan')
        .select('id, poin_jam, kuota')
        .eq('semester_id', semesterId)
        .eq('staf_nip', staffNip)
        .eq('is_aktif', true);

      if (jobErr) throw jobErr;

      // 5. Fetch Existing Assignments for these jobs to calculate remaining quota
      const { data: existing } = await supabase
        .from('penugasan')
        .select('nim, pekerjaan_id')
        .in('pekerjaan_id', jobs?.map(j => j.id) || [])
        .neq('status_tugas_id', 4); // exclude rejected/deleted

      const assignedSet = new Set(existing?.map(e => `${e.nim}-${e.pekerjaan_id}`));
      const quotaMap: Record<number, number> = {};
      jobs?.forEach(j => { quotaMap[j.id] = j.kuota === null ? 999 : j.kuota; });
      existing?.forEach(e => { if (quotaMap[e.pekerjaan_id]) quotaMap[e.pekerjaan_id]--; });

      const sortedJobs = [...(jobs || [])].sort((a, b) => b.poin_jam - a.poin_jam);
      const assignments: any[] = [];

      for (const student of validCandidates) {
        for (const job of sortedJobs) {
          if (assignedSet.has(`${student.nim}-${job.id}`)) continue;
          if (quotaMap[job.id] <= 0) continue;
          assignments.push({ pekerjaan_id: job.id, nim: student.nim, status_tugas_id: 1 });
          quotaMap[job.id]--;
          assignedSet.add(`${student.nim}-${job.id}`);
          break;
        }
      }

      if (assignments.length > 0) {
        const { error: insErr } = await supabase.from('penugasan').insert(assignments);
        if (insErr) {
          console.error("Plotting Error:", insErr);
          throw new Error(`Gagal menyimpan plotting: ${insErr.message}`);
        }
        
        toast.success(`${assignments.length} penugasan berhasil dibuat.`);
        fetchPekerjaan();
      } else {
        toast('Tidak ada plotting yang bisa dilakukan.', { icon: 'ℹ️' });
      }
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setPlotting(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row gap-3 justify-between">
        <div className="flex bg-slate-100 p-1 rounded-lg self-start">
          <button className="px-3 py-1.5 text-xs font-semibold bg-white rounded-md shadow-sm text-slate-900 flex items-center gap-1.5">
            <Users className="w-3.5 h-3.5" /> Aktif Anda
          </button>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => router.push('/import')}
            className="btn-ghost border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 flex items-center gap-2"
          >
            <FileSpreadsheet className="w-4 h-4 text-green-600" />
            <span className="font-semibold text-sm">Import Excel</span>
          </button>

          <button
            onClick={handleGeneratePlotting}
            disabled={plotting || loading}
            className="btn-ghost border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 flex items-center gap-2"
          >
            {plotting ? <Loader2 className="w-4 h-4 animate-spin text-blue-500" /> : <Shuffle className="w-4 h-4" />}
            <span className="font-semibold text-sm">Generate Plotting</span>
          </button>

          <button
            onClick={() => { setEditingJob(null); setModalOpen(true); }}
            className="btn-primary flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            <span className="font-semibold text-sm">Tambah Manual</span>
          </button>
        </div>
      </div>

      <div className="table-wrapper">
        <table className="table-base">
          <thead>
            <tr>
              <th>Pekerjaan</th>
              <th>Tipe</th>
              <th>Poin</th>
              <th>Kuota Sisa</th>
              <th>Tgl Selesai</th>
              <th>Status</th>
              <th className="text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <SkeletonRow cols={7} rows={5} />
            ) : pekerjaan.length === 0 ? (
              <tr>
                <td colSpan={7}>
                  <EmptyState title="Belum ada pekerjaan" description="Tambahkan pekerjaan manual atau gunakan Generate Plotting." />
                </td>
              </tr>
            ) : (
              pekerjaan.map((job) => (
                <tr key={job.id}>
                  <td className="max-w-[200px] truncate font-semibold text-slate-900">{job.judul}</td>
                  <td><StatusBadge id={job.tipe_pekerjaan_id} type="tipe_pekerjaan" /></td>
                  <td className="font-bold text-blue-600">{formatJam(job.poin_jam)}</td>
                  <td className="font-medium text-slate-700">
                    {job.quotaRemaining} {job.kuota !== null && `/ ${job.kuota}`}
                  </td>
                  <td className="text-xs text-slate-500">{job.tanggal_selesai ? formatTanggal(job.tanggal_selesai) : '—'}</td>
                  <td>
                    <span className={`inline-flex items-center gap-1.5 text-xs font-medium px-2 py-0.5 rounded-full ${job.is_aktif ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500'}`}>
                      <span className={`w-1.5 h-1.5 rounded-full ${job.is_aktif ? 'bg-green-500' : 'bg-slate-400'}`} />
                      {job.is_aktif ? 'Aktif' : 'Draft'}
                    </span>
                  </td>
                  <td className="text-right">
                    <div className="flex justify-end gap-1">
                      <button onClick={() => { setEditingJob(job); setModalOpen(true); }} className="p-2 hover:bg-slate-100 rounded-lg text-slate-500"><Edit2 className="w-4 h-4" /></button>
                      <button onClick={() => handleToggleAktif(job.id, job.is_aktif)} className="p-2 hover:bg-slate-100 rounded-lg text-slate-500">
                        {job.is_aktif ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                      <button onClick={() => handleDelete(job.id)} className="p-2 hover:bg-red-50 rounded-lg text-red-500"><Trash2 className="w-4 h-4" /></button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <AddJobModal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        onSuccess={fetchPekerjaan}
        staffNip={staffNip}
        semesterId={semesterId}
        editingJob={editingJob}
      />
    </div>
  );
}
