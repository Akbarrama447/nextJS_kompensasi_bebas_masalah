'use client';

import { useState, useEffect, useCallback } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { createClient } from '@/lib/supabase/client';
import { formatJam, formatTanggalWaktu } from '@/lib/utils';
import StatusBadge from '@/components/ui/StatusBadge';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import EmptyState from '@/components/ui/EmptyState';
import { Clock, CheckCircle, FileText, Briefcase, Info, AlertCircle } from 'lucide-react';
import type { Mahasiswa } from '@/lib/types';
import toast from 'react-hot-toast';

export default function KompenSayaPage() {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [metrics, setMetrics] = useState<any>(null);
  const [history, setHistory] = useState<any[]>([]);
  const supabase = createClient();

  const fetchKompen = useCallback(async () => {
    if (!user || user.roleName !== 'mahasiswa') return;
    const profile = user.profile as Mahasiswa;
    setLoading(true);

    try {
      // 1. Fetch current sisa_jam metrics from view
      const { data: mData } = await supabase
        .from('v_sisa_kompen')
        .select('sisa_jam, jam_selesai, total_jam_wajib, semester_nama')
        .eq('nim', profile.nim)
        .eq('is_aktif', true)
        .maybeSingle();
      
      setMetrics(mData);

      // 2. Fetch log_potong_jam with specific columns
      const { data: hData, error: hErr } = await supabase
        .from('log_potong_jam')
        .select(`
          id, nim, semester_id, jam_dikurangi, keterangan, created_at, penugasan_id, ekuivalensi_id,
          penugasan:penugasan_id(
            id,
            daftar_pekerjaan:pekerjaan_id(judul)
          ),
          ekuivalensi:ekuivalensi_id(
            id,
            catatan
          )
        `)
        .eq('nim', profile.nim)
        .order('created_at', { ascending: false });

      if (hErr) throw hErr;
      setHistory(hData ?? []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [user, supabase]);

  useEffect(() => {
    fetchKompen();
  }, [fetchKompen]);

  if (!user || user.roleName !== 'mahasiswa') return null;

  const progress = metrics?.total_jam_wajib > 0 
    ? (metrics.jam_selesai / metrics.total_jam_wajib) * 100 
    : 0;

  return (
    <div className="space-y-8 max-w-5xl">
       {/* Header */}
       <div>
          <h1 className="text-2xl font-bold text-slate-900">Riwayat & Progress Kompen</h1>
          <p className="text-sm text-slate-500 mt-1">Pantau sisa jam kompen dan riwayat pelunasan Anda.</p>
       </div>

       {/* Progress Card */}
       <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="col-span-1 card flex flex-col items-center justify-center p-8 gap-4 bg-white border-blue-100 border-2">
             <div className="relative inline-flex items-center justify-center">
                <svg width="120" height="120" viewBox="0 0 120 120">
                   <circle cx="60" cy="60" r="50" fill="none" stroke="#f1f5f9" strokeWidth="10" />
                   <circle 
                     cx="60" cy="60" r="50" fill="none" 
                     stroke={progress >= 100 ? '#22c55e' : '#3b82f6'} 
                     strokeWidth="10" strokeLinecap="round" 
                     strokeDasharray={314} 
                     strokeDashoffset={314 - (Math.min(100, progress) / 100) * 314}
                     className="transition-all duration-1000 ease-out"
                     transform="rotate(-90 60 60)"
                   />
                </svg>
                <div className="absolute text-center">
                   <p className="text-2xl font-black text-slate-900">{Math.round(progress)}%</p>
                </div>
             </div>
             <p className="text-sm font-bold text-slate-800">Tingkat Kelunasan</p>
          </div>

          <div className="md:col-span-2 grid grid-cols-1 sm:grid-cols-2 gap-4">
             <div className="card bg-slate-50 border-slate-100 flex items-start gap-4">
                <div className="w-10 h-10 rounded-lg bg-red-100 text-red-600 flex items-center justify-center flex-shrink-0">
                   <Clock className="w-5 h-5" />
                </div>
                <div>
                   <p className="text-xs text-slate-500 font-medium">Sisa Hutang</p>
                   <p className="text-2xl font-black text-slate-900">{formatJam(metrics?.sisa_jam || 0)} <span className="text-sm font-normal text-slate-400 font-mono">jam</span></p>
                </div>
             </div>
             <div className="card bg-slate-50 border-slate-100 flex items-start gap-4">
                <div className="w-10 h-10 rounded-lg bg-green-100 text-green-600 flex items-center justify-center flex-shrink-0">
                   <CheckCircle className="w-5 h-5" />
                </div>
                <div>
                   <p className="text-xs text-slate-500 font-medium">Jam Selesai</p>
                   <p className="text-2xl font-black text-slate-900">{formatJam(metrics?.jam_selesai || 0)} <span className="text-sm font-normal text-slate-400 font-mono">jam</span></p>
                </div>
             </div>
             <div className="sm:col-span-2 card bg-blue-600 text-white flex items-center justify-between p-4 shadow-lg shadow-blue-900/10">
                <div className="flex items-center gap-3">
                   <AlertCircle className="w-5 h-5 text-blue-200" />
                   <div>
                      <p className="text-[10px] uppercase font-bold tracking-wider text-blue-100">Semester Aktif</p>
                      <p className="text-sm font-semibold">{metrics?.semester_nama || 'Sedang Dimuat...'}</p>
                   </div>
                </div>
                <div className="text-right">
                   <p className="text-[10px] uppercase font-bold tracking-wider text-blue-100">Total Wajib</p>
                   <p className="text-lg font-black">{formatJam(metrics?.total_jam_wajib || 0)} j</p>
                </div>
             </div>
          </div>
       </div>

       {/* History Table */}
       <div className="space-y-4">
          <div className="flex items-center justify-between">
             <h2 className="text-lg font-bold text-slate-800">Riwayat Potongan Jam</h2>
             <button onClick={fetchKompen} className="text-xs text-blue-600 hover:underline">Refresh Data</button>
          </div>

          <div className="table-wrapper">
             <table className="table-base">
                <thead>
                   <tr>
                      <th>Sumber Potongan</th>
                      <th>Tanggal</th>
                      <th className="text-right">Jam Dikurangi</th>
                      <th>Status</th>
                   </tr>
                </thead>
                <tbody>
                   {loading ? (
                      <SkeletonRow cols={4} rows={5} />
                   ) : history.length === 0 ? (
                      <tr>
                         <td colSpan={4}><EmptyState title="Belum ada riwayat" description="Data potongan jam akan muncul di sini setelah verifikasi admin." /></td>
                      </tr>
                   ) : (
                      history.map((log) => (
                         <tr key={log.id}>
                            <td className="max-w-[300px]">
                               <div className="flex items-center gap-3">
                                  {log.penugasan_id ? (
                                     <div className="w-8 h-8 rounded bg-blue-50 text-blue-500 flex items-center justify-center flex-shrink-0">
                                        <Briefcase className="w-4 h-4" />
                                     </div>
                                  ) : (
                                     <div className="w-8 h-8 rounded bg-purple-50 text-purple-500 flex items-center justify-center flex-shrink-0">
                                        <FileText className="w-4 h-4" />
                                     </div>
                                  )}
                                  <div className="truncate">
                                     <p className="font-semibold text-slate-900 truncate">
                                        {log.penugasan_id 
                                          ? log.penugasan?.daftar_pekerjaan?.judul 
                                          : `Ekuivalensi: ${log.ekuivalensi?.catatan || 'Kolektif Kelas'}`}
                                     </p>
                                     <p className="text-[10px] text-slate-400 capitalize">
                                        Sumber: {log.penugasan_id ? 'Pekerjaan Mandiri' : 'Ekuivalensi Barang/Kelas'}
                                     </p>
                                  </div>
                               </div>
                            </td>
                            <td className="text-xs text-slate-500">{formatTanggalWaktu(log.created_at)}</td>
                            <td className="text-right font-black text-green-600">-{formatJam(log.jam_dikurangi)} j</td>
                            <td>
                               <StatusBadge id={3} type="status_tugas" label="Lunas" />
                            </td>
                         </tr>
                      ))
                   )}
                </tbody>
             </table>
          </div>
       </div>

       {/* Helpful Info */}
       <div className="bg-slate-50 border border-slate-200 rounded-xl p-6 flex gap-4">
          <Info className="w-6 h-6 text-slate-400 flex-shrink-0" />
          <div className="text-sm text-slate-600 leading-relaxed">
             <p className="font-bold text-slate-800 mb-1">Butuh bantuan?</p>
             Jika terdapat selisih jam atau data yang tidak sesuai di riwayat di atas, silakan hubungi 
             <strong> Bagian Akademik (Gedung Direktorat)</strong> atau tanyakan langsung ke dosen pemberi tugas kompen terkait.
          </div>
       </div>
    </div>
  );
}
