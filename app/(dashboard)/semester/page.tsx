'use client';

import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { Calendar, Plus, CheckCircle2, AlertCircle } from 'lucide-react';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import AddSemesterModal from '@/components/semester/AddSemesterModal';
import toast from 'react-hot-toast';

export default function SemesterPage() {
  const [loading, setLoading] = useState(true);
  const [semesters, setSemesters] = useState<any[]>([]);
  const [modalOpen, setModalOpen] = useState(false);
  const supabase = createClient();

  const fetchSemesters = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from('semester').select('*').order('tahun', { ascending: false });
    setSemesters(data ?? []);
    setLoading(false);
  }, [supabase]);

  useEffect(() => {
    fetchSemesters();
  }, [fetchSemesters]);

  const handleSetActive = async (id: number) => {
    await supabase.from('semester').update({ is_aktif: false }).neq('id', 0);
    const { error } = await supabase.from('semester').update({ is_aktif: true }).eq('id', id);
    if (error) toast.error(error.message);
    else {
      toast.success('Semester aktif diperbarui');
      fetchSemesters();
    }
  };

  return (
    <div className="space-y-6 max-w-4xl">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Manajemen Semester</h1>
          <p className="text-sm text-slate-500 mt-1">Hanya satu semester yang dapat berstatus aktif di satu waktu.</p>
        </div>
        <button className="btn-primary" onClick={() => setModalOpen(true)}>
          <Plus className="w-4 h-4" /> Tambah Semester
        </button>
      </div>

      <AddSemesterModal 
        open={modalOpen} 
        onClose={() => setModalOpen(false)} 
        onSuccess={fetchSemesters} 
      />

      <div className="card p-0 overflow-hidden">
        <table className="table-base">
          <thead>
            <tr>
              <th>Semester / Tahun</th>
              <th>Periode</th>
              <th className="text-center">Status</th>
              <th className="text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <SkeletonRow cols={4} rows={3} />
            ) : (
              semesters.map((s) => (
                <tr key={s.id} className={s.is_aktif ? 'bg-blue-50/30' : ''}>
                  <td>
                    <div className="flex items-center gap-3">
                       <Calendar className={`w-4 h-4 ${s.is_aktif ? 'text-blue-600' : 'text-slate-400'}`} />
                       <span className="font-bold text-slate-900">{s.nama}</span>
                    </div>
                  </td>
                  <td className="text-sm text-slate-500">{s.periode || '—'}</td>
                  <td className="text-center">
                    {s.is_aktif ? (
                      <span className="badge badge-green inline-flex items-center gap-1">
                        <CheckCircle2 className="w-3 h-3" /> Aktif
                      </span>
                    ) : (
                      <span className="badge badge-slate">Nonaktif</span>
                    )}
                  </td>
                  <td className="text-right">
                    {!s.is_aktif && (
                      <button 
                        onClick={() => handleSetActive(s.id)}
                        className="text-xs font-bold text-blue-600 hover:underline"
                      >
                        Aktifkan
                      </button>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <div className="flex gap-3 bg-blue-50 border border-blue-100 p-4 rounded-xl">
         <AlertCircle className="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" />
         <p className="text-xs text-blue-800 leading-relaxed">
            <strong>Penting:</strong> Mengganti semester aktif akan mengubah filter default pada seluruh dashboard Mahasiswa dan Staf. 
            Pastikan periode akademik baru sudah benar sebelum mengaktifkannya.
         </p>
      </div>
    </div>
  );
}
