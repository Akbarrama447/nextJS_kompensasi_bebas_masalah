'use client';

import { useState, useEffect, useCallback } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { createClient } from '@/lib/supabase/client';
import { FileText, Plus, Search, Loader2, Info, Upload } from 'lucide-react';
import { formatTanggal, formatRupiah, formatJam } from '@/lib/utils';
import StatusBadge from '@/components/ui/StatusBadge';
import EmptyState from '@/components/ui/EmptyState';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import EkuivalensiModal from '@/components/ekuivalensi/EkuivalensiModal';
import type { Mahasiswa, Staf } from '@/lib/types';
import toast from 'react-hot-toast';

export default function EkuivalensiPage() {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<any[]>([]);
  const [semester, setSemester] = useState<any>(null);
  
  // Modal states
  const [selectedItem, setSelectedItem] = useState<any>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const supabase = createClient();

  // Fetch active semester & config
  const fetchBase = useCallback(async () => {
    const { data: sem } = await supabase.from('semester').select('*').eq('is_aktif', true).maybeSingle();
    setSemester(sem);
  }, [supabase]);

  const fetchData = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    try {
      let query = supabase
        .from('ekuivalensi_kelas')
        .select(`
          *,
          kelas:kelas(id, nama_kelas),
          staf:staf_nip(nama)
        `)
        .order('created_at', { ascending: false });

      // If Student, only show their class
      if (user.roleName === 'mahasiswa') {
        const profile = user.profile as Mahasiswa;
        query = query.eq('kelas_id', profile.kelas_id);
      }

      const { data: list, error } = await query;
      if (error) throw error;
      setData(list ?? []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [user, supabase]);

  useEffect(() => {
    fetchBase();
    fetchData();
  }, [fetchBase, fetchData]);

  const handleOpenDetail = (item: any) => {
    setSelectedItem(item);
    setModalOpen(true);
  };

  const isAdmin = user?.roleName !== 'mahasiswa';

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Ekuivalensi Barang/Kelas</h1>
          <p className="text-sm text-slate-500 mt-1">
            {isAdmin 
              ? 'Verifikasi pengajuan iuran kolektif dari Penanggung Jawab Kelas.' 
              : 'Informasi pelunasan kompen kolektif melalui iuran barang atau kelas.'}
          </p>
        </div>

        {!isAdmin && data.length === 0 && (
           <button className="btn-primary">
              <Plus className="w-4 h-4" /> Ajukan Pelunasan Pajak
           </button>
        )}
      </div>

      {!semester && !loading && (
        <div className="card text-center py-10">
          <p className="text-slate-500">Tidak ada semester aktif.</p>
        </div>
      )}

      {semester && (
        <div className="space-y-5">
           {/* Summary for Students */}
           {!isAdmin && data.find(d => d.status_ekuivalensi_id === 1) && (
             <div className="bg-blue-50 border border-blue-100 rounded-xl p-5 flex gap-4">
                <div className="w-12 h-12 bg-white rounded-xl shadow-sm flex items-center justify-center flex-shrink-0">
                   <Loader2 className="w-6 h-6 text-blue-500 animate-spin" />
                </div>
                <div>
                   <p className="font-bold text-blue-900">Pengajuan Sedang Diproses</p>
                   <p className="text-sm text-blue-700 leading-snug">
                     PJ Kelas Anda telah mensubmit bukti nota. Mohon tunggu verifikasi admin sebelum sisa jam Anda terupdate otomatis.
                   </p>
                </div>
             </div>
           )}

           {/* Table */}
           <div className="table-wrapper">
              <table className="table-base">
                 <thead>
                    <tr>
                       <th>Kelas</th>
                       <th>Tanggal</th>
                       <th>Nominal</th>
                       <th>Semester</th>
                       <th>Status</th>
                       <th className="text-right">Aksi</th>
                    </tr>
                 </thead>
                 <tbody>
                    {loading ? (
                       <SkeletonRow cols={6} rows={3} />
                    ) : data.length === 0 ? (
                       <tr>
                          <td colSpan={6}><EmptyState title="Belum ada ekuivalensi" description="Belum ada data pelunasan kolektif untuk kelas ini." /></td>
                       </tr>
                    ) : (
                       data.map((item) => (
                          <tr key={item.id}>
                             <td className="font-bold text-slate-900">{item.kelas?.nama_kelas}</td>
                             <td className="text-sm text-slate-500">{formatTanggal(item.created_at)}</td>
                             <td className="font-mono">{formatRupiah(item.nominal_total)}</td>
                             <td className="text-xs text-slate-600">{semester.nama}</td>
                             <td><StatusBadge id={item.status_ekuivalensi_id} type="ekuivalensi" /></td>
                             <td className="text-right">
                                <button 
                                  onClick={() => handleOpenDetail(item)}
                                  className="btn-ghost text-blue-600 hover:bg-blue-50 py-1"
                                >
                                   {isAdmin && item.status_ekuivalensi_id === 1 ? 'Verifikasi' : 'Detail'}
                                </button>
                             </td>
                          </tr>
                       ))
                    )}
                 </tbody>
              </table>
           </div>
        </div>
      )}

      {isAdmin && (
         <EkuivalensiModal
           open={modalOpen}
           onClose={() => setModalOpen(false)}
           onSuccess={fetchData}
           ekuivalensi={selectedItem}
           staffNip={(user?.profile as Staf)?.nip}
         />
      )}
    </div>
  );
}
