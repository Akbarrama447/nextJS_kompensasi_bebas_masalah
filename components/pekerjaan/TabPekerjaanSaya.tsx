'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { STATUS_TUGAS } from '@/lib/types';
import { formatJam, formatTanggal } from '@/lib/utils';
import { 
  Play, 
  CheckCircle2, 
  Clock, 
  MapPin, 
  Camera, 
  AlertCircle,
  ChevronRight,
  ExternalLink,
  Receipt
} from 'lucide-react';
import toast from 'react-hot-toast';
import CameraModal from './CameraModal';
import StatusBadge from '@/components/ui/StatusBadge';

interface TabPekerjaanSayaProps {
  mahasiswaNim: string;
  semesterId: number;
}

export default function TabPekerjaanSaya({ mahasiswaNim, semesterId }: TabPekerjaanSayaProps) {
  const [assignments, setAssignments] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [cameraConfig, setCameraConfig] = useState<{ open: boolean; title: string; type: 'start' | 'finish' | 'external'; assignmentId: number | null }>({
    open: false,
    title: '',
    type: 'start',
    assignmentId: null
  });
  const [externalAmount, setExternalAmount] = useState<string>('');
  const [showExternalInput, setShowExternalInput] = useState(false);
  
  const supabase = createClient();

  const fetchMyAssignments = useCallback(async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('penugasan')
        .select(`
          *,
          pekerjaan:pekerjaan_id(
            id, judul, deskripsi, tipe_pekerjaan_id, poin_jam, 
            ruangan:ruangan_id(nama_ruangan),
            staf:staf_nip(nama)
          )
        `)
        .eq('nim', mahasiswaNim)
        .eq('pekerjaan_id.semester_id', semesterId)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setAssignments(data || []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [mahasiswaNim, semesterId, supabase]);

  useEffect(() => {
    fetchMyAssignments();
  }, [fetchMyAssignments]);

  const handleUpload = async (file: File) => {
     const fileExt = file.name.split('.').pop();
     const fileName = `${Math.random().toString(36).substring(2)}-${Date.now()}.${fileExt}`;
     const filePath = `bukti/${mahasiswaNim}/${fileName}`;

     const { error: uploadError } = await supabase.storage
       .from('kompen_assets') // Updated bucket name
       .upload(filePath, file);

     if (uploadError) throw uploadError;

     const { data: { publicUrl } } = supabase.storage
       .from('kompen_assets')
       .getPublicUrl(filePath);

     return publicUrl;
  };

  const onCapture = async (file: File, meta: any) => {
    if (!cameraConfig.assignmentId) return;
    
    const loadingToast = toast.loading('Mengunggah bukti...');
    try {
      const imageUrl = await handleUpload(file);
      const assignment = assignments.find(a => a.id === cameraConfig.assignmentId);
      
      let newDetail = { ...(assignment.detail_pengerjaan || {}) };
      let newStatus = assignment.status_tugas_id;

      if (cameraConfig.type === 'start') {
        newDetail.foto_mulai = imageUrl;
        newDetail.meta_mulai = meta;
      } else if (cameraConfig.type === 'finish') {
        newDetail.foto_selesai = imageUrl;
        newDetail.meta_selesai = meta;
        newStatus = STATUS_TUGAS.VERIFIKASI; // Move to verification
      } else if (cameraConfig.type === 'external') {
        newDetail.foto_nota = imageUrl;
        newDetail.nominal = parseInt(externalAmount.replace(/[^0-9]/g, ''));
        newStatus = STATUS_TUGAS.VERIFIKASI;
      }

      const { error } = await supabase
        .from('penugasan')
        .update({
          detail_pengerjaan: newDetail,
          status_tugas_id: newStatus,
          updated_at: new Date().toISOString()
        })
        .eq('id', cameraConfig.assignmentId);

      if (error) throw error;

      toast.success('Bukti berhasil disimpan', { id: loadingToast });
      fetchMyAssignments();
      setCameraConfig({ ...cameraConfig, open: false });
      setShowExternalInput(false);
      setExternalAmount('');
    } catch (err: any) {
      toast.error('Gagal: ' + err.message, { id: loadingToast });
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <Clock className="w-8 h-8 animate-spin text-blue-600 opacity-20" />
      </div>
    );
  }

  if (assignments.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-slate-400 bg-slate-50 rounded-2xl border border-dashed border-slate-200">
        <AlertCircle className="w-12 h-12 mb-4 opacity-20" />
        <p className="text-sm font-medium">Anda belum mengambil pekerjaan apapun.</p>
        <p className="text-xs mt-1">Gunakan tab "Marketplace" untuk mencari pekerjaan.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="overflow-hidden bg-white">
        <div className="grid grid-cols-1 gap-4">
          {assignments.map((item) => {
            const isInternal = item.pekerjaan?.tipe_pekerjaan_id === 1;
            const hasStarted = !!item.detail_pengerjaan?.foto_mulai;
            const isCompleted = item.status_tugas_id === STATUS_TUGAS.VERIFIKASI || item.status_tugas_id === STATUS_TUGAS.SELESAI;
            
            return (
              <div 
                key={item.id} 
                className={`group relative flex flex-col md:flex-row md:items-center justify-between p-5 rounded-2xl border transition-all duration-300 ${isCompleted ? 'bg-slate-50/50 border-slate-100' : 'bg-white border-slate-200 hover:border-blue-300 hover:shadow-md'}`}
              >
                <div className="flex gap-4 items-start">
                  <div className={`w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 ${isCompleted ? 'bg-green-100 text-green-600' : 'bg-blue-100 text-blue-600'}`}>
                    {isInternal ? <Clock className="w-6 h-6" /> : <Receipt className="w-6 h-6" />}
                  </div>
                  <div>
                    <h3 className="font-bold text-slate-900 group-hover:text-blue-600 transition-colors uppercase tracking-tight">
                      {item.pekerjaan?.judul}
                    </h3>
                    <div className="flex flex-wrap items-center gap-x-4 gap-y-1 mt-1">
                      <span className="text-xs font-medium text-slate-500 flex items-center gap-1">
                        <MapPin className="w-3 h-3" /> {item.pekerjaan?.ruangan?.nama_ruangan || 'Lokasi Fleksibel'}
                      </span>
                      <span className="text-xs font-bold text-blue-600 bg-blue-50 px-2 py-0.5 rounded">
                        +{formatJam(item.pekerjaan?.poin_jam || 0)}
                      </span>
                      <span className="text-[10px] text-slate-400 font-medium">
                        Dibuat: {formatTanggal(item.created_at)}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-4 mt-4 md:mt-0 pt-4 md:pt-0 border-t md:border-0 border-slate-100">
                  <StatusBadge id={item.status_tugas_id} type="status_tugas" />
                  
                  {!isCompleted && item.status_tugas_id !== STATUS_TUGAS.DITOLAK && (
                    <div className="flex items-center gap-2">
                      {isInternal ? (
                        !hasStarted ? (
                          <button 
                            onClick={() => setCameraConfig({ open: true, title: 'Mulai Pekerjaan', type: 'start', assignmentId: item.id })}
                            className="flex items-center gap-2 px-5 py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 shadow-lg shadow-blue-900/20 active:scale-95 transition-all"
                          >
                            <Play className="w-3.5 h-3.5 fill-current" /> Mulai Sekarang
                          </button>
                        ) : (
                          <button 
                            onClick={() => setCameraConfig({ open: true, title: 'Selesaikan Pekerjaan', type: 'finish', assignmentId: item.id })}
                            className="flex items-center gap-2 px-5 py-2.5 bg-green-600 text-white rounded-xl text-xs font-bold hover:bg-green-700 shadow-lg shadow-green-900/20 active:scale-95 transition-all"
                          >
                            <CheckCircle2 className="w-3.5 h-3.5" /> Selesaikan Kompen
                          </button>
                        )
                      ) : (
                        <button 
                          onClick={() => {
                            setCameraConfig({ ...cameraConfig, assignmentId: item.id, type: 'external' });
                            setShowExternalInput(true);
                          }}
                          className="flex items-center gap-2 px-5 py-2.5 bg-amber-600 text-white rounded-xl text-xs font-bold hover:bg-amber-700 shadow-lg shadow-amber-900/20 active:scale-95 transition-all"
                        >
                          <Camera className="w-3.5 h-3.5" /> Upload Nota
                        </button>
                      )}
                    </div>
                  )}

                  {isCompleted && (
                    <div className="flex items-center text-slate-400 group-hover:text-blue-500">
                       <ChevronRight className="w-5 h-5" />
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* External Data Input Overlay */}
      {showExternalInput && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <div className="bg-white rounded-3xl p-6 w-full max-w-sm shadow-2xl space-y-4">
            <h3 className="text-xl font-bold text-slate-900">Input Data Nota</h3>
            <p className="text-sm text-slate-500">Masukkan nominal sesuai yang tertera pada nota/struk.</p>
            <div className="space-y-2">
              <label className="text-xs font-bold text-slate-700">Nominal Harga (Rp)</label>
              <input 
                 type="text" 
                 placeholder="Contoh: 50000"
                 value={externalAmount}
                 onChange={(e) => setExternalAmount(e.target.value.replace(/[^0-9]/g, ''))}
                 className="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 outline-none text-lg font-bold"
              />
            </div>
            <div className="flex gap-3 pt-2">
               <button 
                 onClick={() => { setShowExternalInput(false); setExternalAmount(''); }}
                 className="flex-1 btn-ghost border border-slate-200"
               >
                 Batal
               </button>
               <button 
                 disabled={!externalAmount}
                 onClick={() => {
                   setCameraConfig({ ...cameraConfig, open: true, title: 'Foto Nota' });
                   setShowExternalInput(false);
                 }}
                 className="flex-1 btn-primary bg-blue-600 disabled:opacity-50"
               >
                 Lanjut Foto <ChevronRight className="w-4 h-4 ml-1" />
               </button>
            </div>
          </div>
        </div>
      )}

      {/* Camera Capture Modal */}
      <CameraModal 
        open={cameraConfig.open}
        onClose={() => setCameraConfig({ ...cameraConfig, open: false })}
        title={cameraConfig.title}
        onCapture={onCapture}
      />
    </div>
  );
}
