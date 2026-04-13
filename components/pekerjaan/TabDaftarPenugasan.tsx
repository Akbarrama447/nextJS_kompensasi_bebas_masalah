'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { Search, Filter, Loader2, CheckCircle2 } from 'lucide-react';
import { formatTanggalWaktu } from '@/lib/utils';
import StatusBadge from '@/components/ui/StatusBadge';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import EmptyState from '@/components/ui/EmptyState';
import VerificationModal from './VerificationModal';
import toast from 'react-hot-toast';

interface TabDaftarPenugasanProps {
  staffNip: string;
  semesterId: number;
}

export default function TabDaftarPenugasan({ staffNip, semesterId }: TabDaftarPenugasanProps) {
  const [loading, setLoading] = useState(true);
  const [penugasanList, setPenugasanList] = useState<any[]>([]);
  const [filter, setFilter] = useState('pending'); // 'pending' | 'success' | 'all'
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTask, setSelectedTask] = useState<any>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const supabase = createClient();

  const fetchPenugasan = useCallback(async () => {
    setLoading(true);
    try {
      // Fetch assignments joined with job details for this staff
      let query = supabase
        .from('penugasan')
        .select(`
          id, nim, status_tugas_id, updated_at, detail_pengerjaan,
          mahasiswa:mahasiswa(nama, kelas:kelas(nama_kelas)),
          daftar_pekerjaan:pekerjaan_id!inner(judul, poin_jam, tipe_pekerjaan_id, semester_id)
        `)
        .eq('pekerjaan_id.staf_nip', staffNip)
        .eq('pekerjaan_id.semester_id', semesterId)
        .order('updated_at', { ascending: false });

      if (filter === 'pending') {
         query = query.in('status_tugas_id', [1, 2, 5]); // proses, verifikasi & auto_assigned
      } else if (filter === 'success') {
         query = query.eq('status_tugas_id', 3); // selesai
      }

      const { data, error } = await query;
      if (error) throw error;
      setPenugasanList(data ?? []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [supabase, staffNip, semesterId, filter]);

  useEffect(() => {
    fetchPenugasan();
  }, [fetchPenugasan]);

  const filteredData = penugasanList.filter(p =>
    p.mahasiswa?.nama.toLowerCase().includes(searchTerm.toLowerCase()) ||
    p.nim.includes(searchTerm) ||
    p.daftar_pekerjaan?.judul.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Search & Filter */}
      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input
            type="text"
            className="input-base pl-10"
            placeholder="Cari NIM, Nama Mahasiswa, atau Pekerjaan..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="flex bg-slate-100 p-1 rounded-lg">
          <button
            onClick={() => setFilter('pending')}
            className={`px-4 py-1.5 text-xs font-semibold rounded-md transition-all ${filter === 'pending' ? 'bg-white shadow-sm text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}
          >
            Pending
          </button>
          <button
            onClick={() => setFilter('success')}
            className={`px-4 py-1.5 text-xs font-semibold rounded-md transition-all ${filter === 'success' ? 'bg-white shadow-sm text-green-600' : 'text-slate-500 hover:text-slate-700'}`}
          >
            Selesai
          </button>
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-1.5 text-xs font-semibold rounded-md transition-all ${filter === 'all' ? 'bg-white shadow-sm text-slate-900' : 'text-slate-500 hover:text-slate-700'}`}
          >
            Semua
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="table-wrapper">
        <table className="table-base">
          <thead>
            <tr>
              <th>Mahasiswa</th>
              <th>Pekerjaan</th>
              <th>Jam</th>
              <th>Update Terakhir</th>
              <th>Status</th>
              <th className="text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <SkeletonRow cols={6} rows={5} />
            ) : filteredData.length === 0 ? (
              <tr>
                <td colSpan={6}><EmptyState title="Tidak ada penugasan" description="Mahasiswa belum mengambil atau menyelesaikan pekerjaan Anda." /></td>
              </tr>
            ) : (
              filteredData.map((p) => (
                <tr key={p.id}>
                  <td>
                    <p className="font-semibold text-slate-900">{p.mahasiswa?.nama}</p>
                    <p className="text-[10px] text-slate-500">{p.nim} • <span className="text-blue-600">{p.mahasiswa?.kelas?.nama_kelas}</span></p>
                  </td>
                  <td className="max-w-[180px]">
                    <p className="text-sm truncate font-medium text-slate-700">{p.daftar_pekerjaan?.judul}</p>
                  </td>
                  <td className="font-bold text-slate-600">{p.daftar_pekerjaan?.poin_jam}j</td>
                  <td className="text-xs text-slate-500">{formatTanggalWaktu(p.updated_at)}</td>
                  <td><StatusBadge id={p.status_tugas_id} type="status_tugas" /></td>
                  <td className="text-right">
                    {p.status_tugas_id === 2 ? (
                      <button
                        onClick={() => { setSelectedTask(p); setModalOpen(true); }}
                        className="btn-primary py-1 px-3 text-xs bg-blue-600 hover:bg-blue-700"
                      >
                        Verifikasi
                      </button>
                    ) : (
                      <button
                        onClick={() => { setSelectedTask(p); setModalOpen(true); }}
                        className="p-2 hover:bg-slate-100 rounded-lg text-slate-400"
                        title="Detail"
                      >
                        <CheckCircle2 className="w-5 h-5" />
                      </button>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <VerificationModal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        onSuccess={fetchPenugasan}
        penugasan={selectedTask}
        staffNip={staffNip}
      />
    </div>
  );
}
