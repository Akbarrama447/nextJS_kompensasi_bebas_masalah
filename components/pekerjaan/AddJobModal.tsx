'use client';

import { useState, useEffect } from 'react';
import Modal, { ModalFooter } from '@/components/ui/Modal';
import { createClient } from '@/lib/supabase/client';
import type { Ruangan } from '@/lib/types';
import toast from 'react-hot-toast';

interface JobFormData {
  judul: string;
  deskripsi: string;
  tipe_pekerjaan_id: number;
  poin_jam: string;
  kuota: string;
  ruangan_id: string;
  tanggal_mulai: string;
  tanggal_selesai: string;
  is_aktif: boolean;
}

const DEFAULT_FORM: JobFormData = {
  judul: '', deskripsi: '', tipe_pekerjaan_id: 1,
  poin_jam: '', kuota: '', ruangan_id: '',
  tanggal_mulai: '', tanggal_selesai: '', is_aktif: true,
};

interface AddJobModalProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
  staffNip: string;
  semesterId: number;
  editingJob?: any; // existing job for edit mode
}

export default function AddJobModal({ open, onClose, onSuccess, staffNip, semesterId, editingJob }: AddJobModalProps) {
  const [form, setForm] = useState<JobFormData>(DEFAULT_FORM);
  const [ruanganList, setRuanganList] = useState<Ruangan[]>([]);
  const [saving, setSaving] = useState(false);
  const supabase = createClient();
  const isEdit = !!editingJob;

  useEffect(() => {
    if (open) {
      supabase
        .from('ruangan')
        .select('id, nama_ruangan, kode_ruangan')
        .then(({ data }) => {
          setRuanganList((data as Ruangan[]) ?? []);
        });
      if (editingJob) {
        setForm({
          judul: editingJob.judul ?? '',
          deskripsi: editingJob.deskripsi ?? '',
          tipe_pekerjaan_id: editingJob.tipe_pekerjaan_id ?? 1,
          poin_jam: String(editingJob.poin_jam ?? ''),
          kuota: editingJob.kuota != null ? String(editingJob.kuota) : '',
          ruangan_id: editingJob.ruangan_id != null ? String(editingJob.ruangan_id) : '',
          tanggal_mulai: editingJob.tanggal_mulai ?? '',
          tanggal_selesai: editingJob.tanggal_selesai ?? '',
          is_aktif: editingJob.is_aktif ?? true,
        });
      } else {
        setForm(DEFAULT_FORM);
      }
    }
  }, [open, editingJob]);

  const set = (key: keyof JobFormData, val: any) => setForm((f) => ({ ...f, [key]: val }));

  const handleSave = async () => {
    if (!form.judul.trim()) { toast.error('Judul wajib diisi'); return; }
    if (!form.poin_jam || isNaN(Number(form.poin_jam))) { toast.error('Poin jam harus angka valid'); return; }
    setSaving(true);

    const payload = {
      staf_nip: staffNip,
      semester_id: semesterId,
      judul: form.judul.trim(),
      deskripsi: form.deskripsi.trim(),
      tipe_pekerjaan_id: form.tipe_pekerjaan_id,
      poin_jam: Number(form.poin_jam),
      kuota: form.kuota ? Number(form.kuota) : null,
      ruangan_id: form.tipe_pekerjaan_id === 1 && form.ruangan_id ? Number(form.ruangan_id) : null,
      tanggal_mulai: form.tanggal_mulai || null,
      tanggal_selesai: form.tanggal_selesai || null,
      is_aktif: form.is_aktif,
    };

    const { error } = isEdit
      ? await supabase.from('daftar_pekerjaan').update(payload).eq('id', editingJob.id)
      : await supabase.from('daftar_pekerjaan').insert(payload);

    setSaving(false);
    if (error) { toast.error(error.message); return; }
    toast.success(isEdit ? 'Pekerjaan diperbarui' : 'Pekerjaan berhasil ditambahkan');
    onSuccess();
    onClose();
  };

  const inputCls = 'input-base';

  return (
    <Modal
      open={open}
      onClose={onClose}
      size="lg"
      title={isEdit ? 'Edit Pekerjaan' : 'Tambah Pekerjaan Baru'}
      footer={
        <ModalFooter align="end">
          <button onClick={onClose} className="btn-ghost" disabled={saving}>Batal</button>
          <button onClick={handleSave} disabled={saving} className="btn-primary">
            {saving ? 'Menyimpan...' : isEdit ? 'Simpan Perubahan' : 'Tambah Pekerjaan'}
          </button>
        </ModalFooter>
      }
    >
      <div className="space-y-4">
        {/* Judul */}
        <div>
          <label className="label-base">Judul Pekerjaan <span className="text-red-500">*</span></label>
          <input className={inputCls} value={form.judul} onChange={(e) => set('judul', e.target.value)} placeholder="misal: Bersih-bersih Lab Kimia" />
        </div>

        {/* Deskripsi */}
        <div>
          <label className="label-base">Deskripsi</label>
          <textarea className={`${inputCls} resize-none`} rows={3} value={form.deskripsi} onChange={(e) => set('deskripsi', e.target.value)} placeholder="Detail tugas yang perlu dilakukan..." />
        </div>

        {/* Tipe + Poin + Kuota */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div>
            <label className="label-base">Tipe Pekerjaan</label>
            <select className={inputCls} value={form.tipe_pekerjaan_id} onChange={(e) => set('tipe_pekerjaan_id', Number(e.target.value))}>
              <option value={1}>Internal</option>
              <option value={2}>Eksternal</option>
            </select>
          </div>
          <div>
            <label className="label-base">Poin Jam <span className="text-red-500">*</span></label>
            <input className={inputCls} type="number" min="0" step="0.5" value={form.poin_jam} onChange={(e) => set('poin_jam', e.target.value)} placeholder="misal: 8" />
          </div>
          <div>
            <label className="label-base">Kuota <span className="text-slate-400 font-normal text-xs">(kosong = tak terbatas)</span></label>
            <input className={inputCls} type="number" min="1" value={form.kuota} onChange={(e) => set('kuota', e.target.value)} placeholder="optional" />
          </div>
        </div>

        {/* Ruangan — hanya muncul jika tipe internal */}
        {form.tipe_pekerjaan_id === 1 && (
          <div>
            <label className="label-base">Ruangan</label>
            <select className={inputCls} value={form.ruangan_id} onChange={(e) => set('ruangan_id', e.target.value)}>
              <option value="">— Pilih ruangan —</option>
              {ruanganList.map((r) => (
                <option key={r.id} value={r.id}>{r.kode_ruangan} — {r.nama_ruangan}</option>
              ))}
            </select>
          </div>
        )}

        {/* Tanggal */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="label-base">Tanggal Mulai</label>
            <input className={inputCls} type="date" value={form.tanggal_mulai} onChange={(e) => set('tanggal_mulai', e.target.value)} />
          </div>
          <div>
            <label className="label-base">Tanggal Selesai <span className="text-slate-400 font-normal text-xs">(opsional)</span></label>
            <input className={inputCls} type="date" value={form.tanggal_selesai} onChange={(e) => set('tanggal_selesai', e.target.value)} />
          </div>
        </div>

        {/* is_aktif toggle */}
        <label className="flex items-center gap-3 cursor-pointer select-none">
          <div className="relative">
            <input type="checkbox" className="sr-only peer" checked={form.is_aktif} onChange={(e) => set('is_aktif', e.target.checked)} />
            <div className="w-10 h-6 bg-slate-200 rounded-full peer-checked:bg-blue-600 transition-colors" />
            <div className="absolute top-1 left-1 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-4" />
          </div>
          <span className="text-sm text-slate-700 font-medium">Aktif (mahasiswa bisa mengambil)</span>
        </label>
      </div>
    </Modal>
  );
}
