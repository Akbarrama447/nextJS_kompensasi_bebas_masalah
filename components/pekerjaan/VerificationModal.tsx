'use client';

import { useState, useEffect } from 'react';
import Modal, { ModalFooter } from '@/components/ui/Modal';
import { createClient } from '@/lib/supabase/client';
import StatusBadge from '@/components/ui/StatusBadge';
import { MapPin, ExternalLink, ZoomIn, Check, XCircle, AlertCircle, Info, Clock } from 'lucide-react';
import { formatRupiah, formatTanggalWaktu } from '@/lib/utils';
import toast from 'react-hot-toast';
import RejectModal from './RejectModal';

interface VerificationModalProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
  penugasan: any; // Joined penugasan with pekerjaan details
  staffNip: string;
}

export default function VerificationModal({ open, onClose, onSuccess, penugasan, staffNip }: VerificationModalProps) {
  const [saving, setSaving] = useState(false);
  const [rejectOpen, setRejectOpen] = useState(false);
  const [correctedNominal, setCorrectedNominal] = useState<number>(0);
  const [showZoom, setShowZoom] = useState(false);
  const supabase = createClient();

  useEffect(() => {
    if (penugasan?.detail_pengerjaan?.nominal) {
      setCorrectedNominal(penugasan.detail_pengerjaan.nominal);
    }
  }, [penugasan]);

  if (!penugasan) return null;

  const isInternal = penugasan.daftar_pekerjaan.tipe_pekerjaan_id === 1;
  const detail = penugasan.detail_pengerjaan;
  const isPending = penugasan.status_tugas_id === 2;

  const handleApprove = async () => {
    setSaving(true);
    try {
      // 1. Update Penugasan status to 'Selesai' (3)
      const { error: updateError } = await supabase
        .from('penugasan')
        .update({
          status_tugas_id: 3,
          diverifikasi_oleh_nip: staffNip,
          waktu_verifikasi: new Date().toISOString(),
          // Save corrected nominal if external
          detail_pengerjaan: !isInternal ? { ...detail, nominal: correctedNominal } : detail
        })
        .eq('id', penugasan.id);

      if (updateError) throw updateError;

      // 2. Insert to log_potong_jam (satisfies chk_satu_sumber)
      const { error: logError } = await supabase
        .from('log_potong_jam')
        .insert({
          nim: penugasan.nim,
          semester_id: penugasan.daftar_pekerjaan.semester_id,
          penugasan_id: penugasan.id,
          ekuivalensi_id: null,
          jam_dikurangi: penugasan.daftar_pekerjaan.poin_jam,
          keterangan: `Selesai: ${penugasan.daftar_pekerjaan.judul}`
        });

      if (logError) throw logError;

      toast.success(`Berhasil memverifikasi. Hutang jam ${penugasan.mahasiswa.nama} berkurang.`);
      onSuccess();
      onClose();
    } catch (err: any) {
      toast.error(err.message || 'Gagal memverifikasi');
    } finally {
      setSaving(false);
    }
  };

  const openInMaps = (lat: number, lng: number) => {
    window.open(`https://www.google.com/maps?q=${lat},${lng}`, '_blank');
  };

  return (
    <>
      <Modal
        open={open}
        onClose={onClose}
        size="lg"
        title={
          <div className="flex flex-col sm:flex-row sm:items-center gap-2">
            <span className="truncate max-w-[200px]">{penugasan.mahasiswa.nama}</span>
            <span className="hidden sm:inline text-slate-300">|</span>
            <span className="text-xs text-slate-500 font-normal">{penugasan.nim}</span>
            <StatusBadge id={penugasan.status_tugas_id} type="status_tugas" />
          </div>
        }
        footer={
          isPending && (
            <ModalFooter align="between">
              <button
                onClick={() => setRejectOpen(true)}
                className="btn-danger w-full sm:w-auto justify-center"
                disabled={saving}
              >
                <XCircle className="w-4 h-4" /> Tolak
              </button>
              <button
                onClick={handleApprove}
                className="btn-primary w-full sm:w-auto justify-center bg-green-600 hover:bg-green-700"
                disabled={saving}
              >
                {saving ? 'Memproses...' : <><Check className="w-4 h-4" /> Setujui & Potong Jam</>}
              </button>
            </ModalFooter>
          )
        }
      >
        <div className="space-y-6">
          {/* Info Banner */}
          <div className="bg-slate-50 border border-slate-100 rounded-xl p-4 flex gap-3">
            <Info className="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" />
            <div className="text-sm">
              <p className="font-medium text-slate-900">{penugasan.daftar_pekerjaan.judul}</p>
              <p className="text-slate-500">Poin jam yang akan dikurangi: <span className="font-bold text-blue-600">{penugasan.daftar_pekerjaan.poin_jam} jam</span></p>
            </div>
          </div>

          {isInternal ? (
            /* ── INTERNAL: Before & After View ── */
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {/* Foto Mulai */}
              <div className="space-y-2">
                <label className="text-xs font-bold text-slate-400 uppercase tracking-wider">Foto Mulai</label>
                <div className="relative group aspect-video bg-slate-100 rounded-xl overflow-hidden border border-slate-200">
                  <img src={detail?.foto_mulai} alt="Mulai" className="w-full h-full object-cover" />
                  <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-all flex items-center justify-center opacity-0 group-hover:opacity-100">
                    <button onClick={() => window.open(detail?.foto_mulai, '_blank')} className="bg-white p-2 rounded-lg shadow-lg">
                      <ZoomIn className="w-5 h-5 text-slate-700" />
                    </button>
                  </div>
                </div>
                <div className="bg-white border border-slate-100 rounded-lg p-3 space-y-2">
                  <p className="text-[11px] text-slate-500 flex items-center gap-1.5">
                    <Clock className="w-3 h-3" /> {formatTanggalWaktu(detail?.meta_mulai?.ts)}
                  </p>
                  <button
                    onClick={() => openInMaps(detail?.meta_mulai?.lat, detail?.meta_mulai?.lng)}
                    className="text-[11px] text-blue-600 font-medium hover:underline flex items-center gap-1.5"
                  >
                    <MapPin className="w-3 h-3" /> Lihat Lokasi Mulai
                  </button>
                </div>
              </div>

              {/* Foto Selesai */}
              <div className="space-y-2">
                <label className="text-xs font-bold text-slate-400 uppercase tracking-wider">Foto Selesai</label>
                <div className="relative group aspect-video bg-slate-100 rounded-xl overflow-hidden border border-slate-200">
                  <img src={detail?.foto_selesai} alt="Selesai" className="w-full h-full object-cover" />
                  <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-all flex items-center justify-center opacity-0 group-hover:opacity-100">
                    <button onClick={() => window.open(detail?.foto_selesai, '_blank')} className="bg-white p-2 rounded-lg shadow-lg">
                      <ZoomIn className="w-5 h-5 text-slate-700" />
                    </button>
                  </div>
                </div>
                <div className="bg-white border border-slate-100 rounded-lg p-3 space-y-2">
                  <p className="text-[11px] text-slate-500 flex items-center gap-1.5">
                    <Clock className="w-3 h-3" /> {formatTanggalWaktu(detail?.meta_selesai?.ts)}
                  </p>
                  <button
                    onClick={() => openInMaps(detail?.meta_selesai?.lat, detail?.meta_selesai?.lng)}
                    className="text-[11px] text-blue-600 font-medium hover:underline flex items-center gap-1.5"
                  >
                    <MapPin className="w-3 h-3" /> Lihat Lokasi Selesai
                  </button>
                </div>
              </div>
            </div>
          ) : (
            /* ── EXTERNAL: Nota + Nominal ── */
            <div className="space-y-4">
              <label className="text-xs font-bold text-slate-400 uppercase tracking-wider">Foto Bukti / Nota</label>
              <div className="relative group max-w-md mx-auto aspect-[3/4] bg-slate-100 rounded-xl overflow-hidden border border-slate-200 shadow-sm cursor-zoom-in" onClick={() => setShowZoom(true)}>
                <img src={detail?.foto_nota} alt="Nota" className="w-full h-full object-contain" />
                <div className="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-all" />
                <div className="absolute bottom-4 right-4 bg-white/90 backdrop-blur px-3 py-2 rounded-lg text-xs font-bold text-slate-800 flex items-center gap-2 border border-slate-200 shadow-lg">
                  <ZoomIn className="w-4 h-4" /> Klik untuk perbesar
                </div>
              </div>

              <div className="card bg-blue-50 border-blue-100 space-y-3">
                <div className="flex items-center justify-between">
                  <label htmlFor="corrected" className="text-sm font-semibold text-blue-900">Nominal yang Diakui</label>
                  <span className="text-[10px] text-blue-500 px-2 py-0.5 bg-blue-100 rounded-full font-bold">Corrigible</span>
                </div>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 font-bold">Rp</span>
                  <input
                    id="corrected"
                    type="number"
                    className="input-base pl-10 text-lg font-bold text-slate-900 focus:ring-blue-500"
                    value={correctedNominal}
                    onChange={(e) => setCorrectedNominal(Number(e.target.value))}
                    disabled={!isPending}
                  />
                </div>
                <p className="text-xs text-blue-600/70 italic">*Admin dapat memperbaiki nominal di atas jika mahasiswa salah input berdasarkan foto nota.</p>
              </div>
            </div>
          )}

          {/* Catatan existing jika ada */}
          {penugasan.catatan_verifikasi && (
            <div className="card bg-red-50 border-red-100">
              <p className="text-xs font-bold text-red-600 uppercase mb-1">Catatan Penolakan Sebelumnya</p>
              <p className="text-sm text-red-700">{penugasan.catatan_verifikasi}</p>
            </div>
          )}
        </div>
      </Modal>

      {/* Reject Overlay */}
      <RejectModal
        open={rejectOpen}
        onClose={() => setRejectOpen(false)}
        onSuccess={() => {
          setRejectOpen(false);
          onSuccess();
          onClose();
        }}
        penugasanId={penugasan.id}
      />

      {/* Image Zoom Modal */}
      {showZoom && !isInternal && (
        <div className="fixed inset-0 z-[200] bg-black/90 flex items-center justify-center p-4 cursor-zoom-out" onClick={() => setShowZoom(false)}>
           <img src={detail?.foto_nota} alt="Nota Zoom" className="max-w-full max-h-full object-contain" />
           <button className="absolute top-6 right-6 p-3 bg-white/10 hover:bg-white/20 rounded-full text-white transition-colors">
              <XCircle className="w-8 h-8" />
           </button>
        </div>
      )}
    </>
  );
}
