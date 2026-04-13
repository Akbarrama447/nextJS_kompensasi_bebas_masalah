'use client';

import { useState } from 'react';
import Modal, { ModalFooter } from '@/components/ui/Modal';
import { createClient } from '@/lib/supabase/client';
import { Calendar, Save, X } from 'lucide-react';
import toast from 'react-hot-toast';

interface AddSemesterModalProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export default function AddSemesterModal({ open, onClose, onSuccess }: AddSemesterModalProps) {
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({
    nama: '',
    tahun: new Date().getFullYear(),
    periode: 'Ganjil',
    is_aktif: false
  });

  const supabase = createClient();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.nama) return toast.error('Nama semester wajib diisi');

    setLoading(true);
    try {
      // Jika diset aktif, nonaktifkan semester lain dulu
      if (form.is_aktif) {
        await supabase.from('semester').update({ is_aktif: false }).neq('id', 0);
      }

      const { error } = await supabase.from('semester').insert([form]);
      
      if (error) throw error;

      toast.success('Semester berhasil ditambahkan');
      onSuccess();
      onClose();
      // Reset form
      setForm({
        nama: '',
        tahun: new Date().getFullYear(),
        periode: 'Ganjil',
        is_aktif: false
      });
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Modal
      open={open}
      onClose={onClose}
      title="Tambah Semester Baru"
      footer={
        <ModalFooter align="end">
          <button onClick={onClose} className="btn-ghost" disabled={loading}>Batal</button>
          <button onClick={handleSubmit} className="btn-primary" disabled={loading}>
            {loading ? 'Menyimpan...' : <><Save className="w-4 h-4" /> Simpan Semester</>}
          </button>
        </ModalFooter>
      }
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="space-y-1.5">
          <label className="text-sm font-semibold text-slate-700">Nama Semester</label>
          <input
            type="text"
            placeholder="Contoh: Genap 2023/2024"
            className="input-base"
            value={form.nama}
            onChange={(e) => setForm({ ...form, nama: e.target.value })}
            required
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Tahun</label>
            <input
              type="number"
              className="input-base"
              value={form.tahun}
              onChange={(e) => setForm({ ...form, tahun: parseInt(e.target.value) })}
              required
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-sm font-semibold text-slate-700">Periode</label>
            <select
              className="input-base"
              value={form.periode}
              onChange={(e) => setForm({ ...form, periode: e.target.value })}
            >
              <option value="Ganjil">Ganjil</option>
              <option value="Genap">Genap</option>
              <option value="Antara">Antara</option>
            </select>
          </div>
        </div>

        <div className="flex items-center gap-3 p-4 bg-slate-50 rounded-xl border border-slate-100">
           <input
             type="checkbox"
             id="is_aktif"
             className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
             checked={form.is_aktif}
             onChange={(e) => setForm({ ...form, is_aktif: e.target.checked })}
           />
           <label htmlFor="is_aktif" className="text-sm font-medium text-slate-700 cursor-pointer">
             Aktifkan semester ini secara otomatis
           </label>
        </div>
      </form>
    </Modal>
  );
}
