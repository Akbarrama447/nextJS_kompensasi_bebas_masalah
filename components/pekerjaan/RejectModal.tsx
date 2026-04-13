'use client';

import { useState } from 'react';
import Modal, { ModalFooter } from '@/components/ui/Modal';
import { createClient } from '@/lib/supabase/client';
import toast from 'react-hot-toast';

interface RejectModalProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
  penugasanId: number;
}

export default function RejectModal({ open, onClose, onSuccess, penugasanId }: RejectModalProps) {
  const [alasan, setAlasan] = useState('');
  const [saving, setSaving] = useState(false);
  const supabase = createClient();

  const handleReject = async () => {
    if (!alasan.trim()) { toast.error('Alasan penolakan wajib diisi'); return; }
    setSaving(true);

    const { error } = await supabase
      .from('penugasan')
      .update({ status_tugas_id: 4, catatan_verifikasi: alasan.trim() })
      .eq('id', penugasanId);

    setSaving(false);
    if (error) { toast.error(error.message); return; }
    toast.success('Penugasan ditolak');
    setAlasan('');
    onSuccess();
    onClose();
  };

  return (
    <Modal
      open={open}
      onClose={onClose}
      size="sm"
      title="Tolak Penugasan"
      footer={
        <ModalFooter align="end">
          <button onClick={onClose} className="btn-ghost" disabled={saving}>Batal</button>
          <button onClick={handleReject} disabled={saving} className="btn-danger border border-red-300 bg-red-600 text-white hover:bg-red-700">
            {saving ? 'Menolak...' : 'Konfirmasi Tolak'}
          </button>
        </ModalFooter>
      }
    >
      <div className="space-y-3">
        <p className="text-sm text-slate-600">Berikan alasan penolakan yang jelas agar mahasiswa dapat memperbaikinya.</p>
        <label className="label-base">Alasan Penolakan <span className="text-red-500">*</span></label>
        <textarea
          className="input-base resize-none"
          rows={4}
          value={alasan}
          onChange={(e) => setAlasan(e.target.value)}
          placeholder="misal: Foto tidak jelas, metadata lokasi tidak sesuai ruangan..."
          autoFocus
        />
      </div>
    </Modal>
  );
}
