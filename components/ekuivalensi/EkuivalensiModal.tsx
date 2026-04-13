'use client';

import { useState, useEffect } from 'react';
import Modal, { ModalFooter } from '@/components/ui/Modal';
import { createClient } from '@/lib/supabase/client';
import { useRouter } from 'next/navigation';
import { Check, XCircle, Info, Users, Image as ImageIcon } from 'lucide-react';
import { formatRupiah, formatJam } from '@/lib/utils';
import toast from 'react-hot-toast';
import StatusBadge from '@/components/ui/StatusBadge';

interface EkuivalensiModalProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
  ekuivalensi: any; // ekuivalensi_kelas with class and student joins
  staffNip: string;
}

export default function EkuivalensiModal({ open, onClose, onSuccess, ekuivalensi, staffNip }: EkuivalensiModalProps) {
  const [saving, setSaving] = useState(false);
  const [students, setStudents] = useState<any[]>([]);
  const [loadingStudents, setLoadingStudents] = useState(false);
  const supabase = createClient();
  const router = useRouter();

  useEffect(() => {
    if (open && ekuivalensi) {
      fetchClassDebt();
    }
  }, [open, ekuivalensi]);

  const fetchClassDebt = async () => {
    setLoadingStudents(true);
    try {
      // Fetch current debt for all students in this class for the specific semester
      const { data, error } = await supabase
        .from('v_sisa_kompen')
        .select('nim, sisa_jam')
        .eq('kelas_id', ekuivalensi.kelas_id)
        .eq('semester_id', ekuivalensi.semester_id);
      
      if (error) throw error;
      setStudents(data ?? []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoadingStudents(false);
    }
  };

  if (!ekuivalensi) return null;

  const handleApprove = async () => {
    const confirmMsg = `Setujui ekuivalensi kelas ${ekuivalensi.kelas?.nama_kelas}? Semua mahasiswa di kelas ini akan otomatis lunas jam kompennya untuk semester ini.`;
    if (!confirm(confirmMsg)) return;

    setSaving(true);
    try {
      // 1. Update status Ekuivalensi to 'Selesai' (3)
      const { error: updateError } = await supabase
        .from('ekuivalensi_kelas')
        .update({
          status_ekuivalensi_id: 3, // Selesai
          diverifikasi_oleh_nip: staffNip,
          waktu_verifikasi: new Date().toISOString()
        })
        .eq('id', ekuivalensi.id);

      if (updateError) throw updateError;

      // 2. BULK BATCH INSERT to log_potong_jam
      // Map all students to an array of log objects
      const logs = students.map(s => ({
        nim: s.nim,
        semester_id: ekuivalensi.semester_id,
        ekuivalensi_id: ekuivalensi.id, // Explicit ID
        penugasan_id: null,           // Explicitly NULL for chk_satu_sumber
        jam_dikurangi: s.sisa_jam,    // Reduce exactly what they owe
        keterangan: `Ekuivalensi: ${ekuivalensi.catatan || 'Iuran Kelas'}`
      }));

      if (logs.length > 0) {
        const { error: batchError } = await supabase.from('log_potong_jam').insert(logs);
        if (batchError) throw batchError;
      }

      toast.success(`Berhasil! ${logs.length} mahasiswa telah dilunaskan.`);
      
      // 3. UI Sync: Refresh and success callback
      router.refresh(); 
      onSuccess();
      onClose();
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setSaving(false);
    }
  };

  const handleReject = async () => {
    const alasan = prompt('Alasan penolakan:');
    if (alasan === null) return;
    if (!alasan.trim()) { toast.error('Alasan wajib diisi'); return; }

    setSaving(true);
    const { error } = await supabase
      .from('ekuivalensi_kelas')
      .update({
        status_ekuivalensi_id: 4, // Ditolak
        catatan_verifikasi: alasan.trim()
      })
      .eq('id', ekuivalensi.id);
    
    setSaving(false);
    if (error) toast.error(error.message);
    else {
      toast.success('Ekuivalensi ditolak');
      onSuccess();
      onClose();
    }
  };

  const isPending = ekuivalensi.status_ekuivalensi_id === 1;

  return (
    <Modal
      open={open}
      onClose={onClose}
      size="lg"
      title={
        <div className="flex items-center gap-3">
          <span>Detail Ekuivalensi Kelas</span>
          <StatusBadge id={ekuivalensi.status_ekuivalensi_id} type="ekuivalensi" />
        </div>
      }
      footer={
        isPending && (
          <ModalFooter align="between">
            <button onClick={handleReject} disabled={saving} className="btn-danger w-full sm:w-auto justify-center">
              <XCircle className="w-4 h-4" /> Tolak
            </button>
            <button 
              onClick={handleApprove} 
              disabled={saving || loadingStudents} 
              className="btn-primary w-full sm:w-auto justify-center bg-green-600 hover:bg-green-700 shadow-lg shadow-green-900/20"
            >
              {saving ? 'Memproses Bulk...' : <><Check className="w-4 h-4" /> Setujui & Lunas Massal</>}
            </button>
          </ModalFooter>
        )
      }
    >
      <div className="space-y-6">
        {/* Header Info */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="card bg-slate-50 border-slate-100 p-4">
             <div className="flex items-center gap-3 mb-3">
                <div className="w-10 h-10 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center">
                   <Users className="w-5 h-5" />
                </div>
                <div>
                   <p className="text-xs text-slate-500 font-medium">Kelas</p>
                   <p className="font-bold text-slate-900">{ekuivalensi.kelas?.nama_kelas}</p>
                </div>
             </div>
             <p className="text-xs text-slate-500 mb-1">Catatan Pengaju (PJ):</p>
             <p className="text-sm border-l-2 border-blue-400 pl-3 py-1 bg-white italic text-slate-700">
                "{ekuivalensi.catatan || 'Tidak ada catatan'}"
             </p>
          </div>

          <div className="card bg-slate-50 border-slate-100 p-4">
             <p className="text-xs text-slate-500 font-medium mb-3">Total Nominal Nota:</p>
             <p className="text-2xl font-black text-slate-900">{formatRupiah(ekuivalensi.nominal_total || 0)}</p>
             <div className="mt-4">
                <button 
                  onClick={() => window.open(ekuivalensi.foto_nota, '_blank')}
                  className="w-full btn-ghost bg-white border border-slate-200 text-xs py-2 hover:bg-slate-50"
                >
                   <ImageIcon className="w-3.5 h-3.5" /> Lihat Bukti Nota
                </button>
             </div>
          </div>
        </div>

        {/* Student List (Bulk Preview) */}
        <div className="space-y-3">
           <div className="flex items-center justify-between">
              <h3 className="text-sm font-bold text-slate-800 flex items-center gap-2">
                 Daftar Mahasiswa Kelas
                 <span className="bg-slate-200 text-slate-600 px-2 py-0.5 rounded text-[10px] font-bold">{students.length} Orang</span>
              </h3>
              {loadingStudents && <div className="text-[10px] text-blue-600 animate-pulse">Menghitung hutang jam...</div>}
           </div>

           <div className="table-wrapper max-h-[300px] overflow-y-auto border border-slate-100 rounded-xl">
              <table className="table-base table-compact">
                 <thead className="sticky top-0 bg-slate-50 z-10 shadow-sm">
                    <tr>
                       <th>NIM</th>
                       <th>Nama</th>
                       <th className="text-right">Hutang Jam</th>
                       <th className="text-center">Potongan</th>
                    </tr>
                 </thead>
                 <tbody>
                    {students.map((s) => (
                       <tr key={s.nim}>
                          <td className="font-mono text-[10px]">{s.nim}</td>
                          <td className="text-xs font-medium truncate max-w-[140px]">{s.nama}</td>
                          <td className="text-right text-xs font-bold text-red-500">{formatJam(s.sisa_jam)}</td>
                          <td className="text-center">
                             <span className="text-[10px] font-bold text-green-600 bg-green-50 px-2 py-0.5 rounded">
                               -{formatJam(s.sisa_jam)}
                             </span>
                          </td>
                       </tr>
                    ))}
                 </tbody>
              </table>
           </div>
           
           <div className="bg-blue-50 border border-blue-100 p-3 rounded-lg flex gap-3">
              <Info className="w-4 h-4 text-blue-500 flex-shrink-0 mt-0.5" />
              <p className="text-[11px] text-blue-800 leading-normal">
                 Sistem secara otomatis menghitung sisa hutang jam setiap mahasiswa di atas. 
                 Menyetujui ekuivalensi ini akan membuat sisa jam mereka menjadi <strong>0.0 (Lunas)</strong> untuk semester aktif.
              </p>
           </div>
        </div>
      </div>
    </Modal>
  );
}
