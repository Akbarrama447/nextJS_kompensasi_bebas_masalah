'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { 
  Search, 
  Filter, 
  Loader2, 
  MapPin, 
  Clock, 
  ChevronRight, 
  Info,
  Calendar,
  Briefcase
} from 'lucide-react';
import { formatJam, formatTanggal } from '@/lib/utils';
import StatusBadge from '@/components/ui/StatusBadge';
import type { Mahasiswa } from '@/lib/types';
import toast from 'react-hot-toast';

interface TabMarketplaceProps {
  mahasiswaNim: string;
  semesterId: number;
}

export default function TabMarketplace({ mahasiswaNim, semesterId }: TabMarketplaceProps) {
  const [loading, setLoading] = useState(true);
  const [jobs, setJobs] = useState<any[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [applying, setApplying] = useState<number | null>(null);
  const supabase = createClient();

  const fetchAvailableJobs = useCallback(async () => {
    setLoading(true);
    try {
      // Fetch only needed columns to reduce payload size
      const { data, error } = await supabase
        .from('daftar_pekerjaan')
        .select(`
          id, judul, deskripsi, tipe_pekerjaan_id, poin_jam, kuota, tanggal_selesai, created_at,
          staf:staf_nip(nama),
          ruangan:ruangan_id(nama_ruangan),
          penugasan(status_tugas_id, nim)
        `)
        .eq('semester_id', semesterId)
        .eq('is_aktif', true)
        .order('created_at', { ascending: false });

      if (error) throw error;

      const processedJobs = data.map((job: any) => {
        // Optimization: Filter assignments once
        const assignments = job.penugasan || [];
        const activeCount = assignments.filter((p: any) => p.status_tugas_id !== 4).length;
        const isTakenByMe = assignments.some((p: any) => p.nim === mahasiswaNim && p.status_tugas_id !== 4);
        
        return {
          ...job,
          isTakenByMe,
          isFull: job.kuota !== null && activeCount >= job.kuota,
          quotaRemaining: job.kuota === null ? null : Math.max(0, job.kuota - activeCount)
        };
      });

      setJobs(processedJobs);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [supabase, semesterId, mahasiswaNim]);

  useEffect(() => {
    fetchAvailableJobs();
  }, [fetchAvailableJobs]);

  const handleApply = async (jobId: number) => {
    if (!confirm('Ambil pekerjaan ini? Anda wajib menyelesaikannya untuk mendapatkan pengurangan jam.')) return;
    
    setApplying(jobId);
    try {
      // 1. Double check quota and if already assigned
      const { data: currentJob, error: checkErr } = await supabase
        .from('daftar_pekerjaan')
        .select('*, penugasan:penugasan(status_tugas_id)')
        .eq('id', jobId)
        .single();
      
      if (checkErr) throw checkErr;

      const activeAssignments = currentJob.penugasan?.filter((p: any) => p.status_tugas_id !== 4).length || 0;
      if (currentJob.kuota !== null && activeAssignments >= currentJob.kuota) {
        throw new Error('Kuota pekerjaan sudah penuh.');
      }

      // 2. Insert penugasan
      const { error: insertErr } = await supabase
        .from('penugasan')
        .insert({
          pekerjaan_id: jobId,
          nim: mahasiswaNim,
          status_tugas_id: 1 // PROSES
        });
      
      if (insertErr) {
        if (insertErr.code === '23505') throw new Error('Anda sudah mengambil pekerjaan ini.');
        throw insertErr;
      }

      toast.success('Pekerjaan berhasil diambil!');
      fetchAvailableJobs();
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setApplying(null);
    }
  };

  const filteredJobs = jobs.filter(j => 
    j.judul.toLowerCase().includes(searchTerm.toLowerCase()) ||
    j.staf?.nama.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Search Header */}
      <div className="relative group">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-blue-500 transition-colors" />
        <input
          type="text"
          placeholder="Cari pekerjaan, nama dosen, atau lokasi..."
          className="input-base pl-12 h-14 text-base bg-slate-50 border-transparent focus:bg-white focus:border-blue-500 shadow-sm"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {[1,2,3,4].map(i => (
            <div key={i} className="h-48 bg-slate-100 rounded-2xl animate-pulse" />
          ))}
        </div>
      ) : filteredJobs.length === 0 ? (
        <div className="py-20 text-center">
          <div className="w-20 h-20 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-4">
             <Briefcase className="w-8 h-8 text-slate-300" />
          </div>
          <h3 className="text-lg font-bold text-slate-800">Tidak ada pekerjaan</h3>
          <p className="text-slate-500 max-w-sm mx-auto mt-2">Belum ada pekerjaan yang tersedia untuk diambil saat ini. Silakan cek kembali nanti.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {filteredJobs.map((job) => (
            <div 
              key={job.id} 
              className={`group flex flex-col p-6 rounded-2xl border transition-all duration-300 ${
                job.isTakenByMe 
                ? 'bg-blue-50/50 border-blue-200 shadow-blue-900/5' 
                : job.isFull 
                ? 'bg-slate-50 border-slate-200 grayscale opacity-60' 
                : 'bg-white border-slate-100 shadow-sm hover:shadow-xl hover:-translate-y-1'
              }`}
            >
              <div className="flex justify-between items-start mb-4">
                <div className="space-y-1">
                  <div className="flex items-center gap-2">
                    <StatusBadge id={job.tipe_pekerjaan_id} type="tipe_pekerjaan" />
                    {job.isTakenByMe && (
                      <span className="bg-blue-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider">
                        Sudah Diambil
                      </span>
                    )}
                  </div>
                  <h3 className="font-bold text-lg text-slate-900 leading-tight group-hover:text-blue-600 transition-colors">{job.judul}</h3>
                  <p className="text-sm text-slate-500 font-medium">Oleh: {job.staf?.nama}</p>
                </div>
                <div className="text-right">
                  <p className="text-2xl font-black text-blue-600">{formatJam(job.poin_jam)}</p>
                  <p className="text-[10px] font-bold text-slate-400 uppercase tracking-tighter">Jam Kompen</p>
                </div>
              </div>

              <div className="flex-1 space-y-3 mb-6">
                <div className="flex items-center gap-2 text-slate-600">
                  <MapPin className="w-3.5 h-3.5" />
                  <span className="text-xs font-medium">{job.ruangan?.nama_ruangan || 'Lokasi Menyesuaikan'}</span>
                </div>
                <div className="flex items-center gap-2 text-slate-600">
                  <Clock className="w-3.5 h-3.5" />
                  <span className="text-xs font-medium">Batas: {job.tanggal_selesai ? formatTanggal(job.tanggal_selesai) : 'Segera'}</span>
                </div>
                <p className="text-xs text-slate-500 line-clamp-2 leading-relaxed">
                  {job.deskripsi || 'Tidak ada deskripsi tambahan.'}
                </p>
              </div>

              <div className="flex items-center justify-between pt-4 border-t border-slate-100">
                <div className="flex items-center gap-1.5">
                  <div className={`w-2 h-2 rounded-full ${job.isFull ? 'bg-red-400' : 'bg-green-400 animate-pulse'}`} />
                  <p className="text-xs font-bold text-slate-600">
                    {job.kuota === null ? 'Kuota Tak Terbatas' : `Sisa ${job.quotaRemaining} Kuota`}
                  </p>
                </div>

                {!job.isTakenByMe && (
                  <button
                    onClick={() => handleApply(job.id)}
                    disabled={job.isFull || applying === job.id}
                    className={`flex items-center gap-2 px-4 py-2 rounded-xl font-bold text-sm transition-all ${
                      job.isFull 
                      ? 'bg-slate-200 text-slate-500 cursor-not-allowed' 
                      : 'bg-slate-900 text-white hover:bg-blue-600'
                    }`}
                  >
                    {applying === job.id ? <Loader2 className="w-4 h-4 animate-spin" /> : 'Ambil Pekerjaan'}
                  </button>
                )}

                {job.isTakenByMe && (
                  <button
                    disabled
                    className="flex items-center gap-2 px-4 py-2 rounded-xl font-bold text-sm bg-blue-100 text-blue-600 cursor-default"
                  >
                    Terdaftar
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Footer Info */}
      <div className="bg-amber-50 border border-amber-200 p-4 rounded-2xl flex gap-3">
         <Info className="w-5 h-5 text-amber-500 flex-shrink-0" />
         <p className="text-xs text-amber-800 leading-relaxed font-medium">
           <strong>Pastikan Anda sanggup:</strong> Pekerjaan yang sudah diambil tidak dapat dibatalkan secara mandiri. Segera hubungi dosen terkait jika terjadi kendala.
         </p>
      </div>
    </div>
  );
}
