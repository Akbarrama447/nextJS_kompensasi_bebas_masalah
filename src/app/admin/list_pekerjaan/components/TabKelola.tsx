"use client";

import { EyeOff, Plus, X, RefreshCw, Trash2, Loader2, CheckCircle, AlertCircle } from "lucide-react";
import { useState, useEffect, useCallback } from "react";
import { getOptions } from "../actions/options";
import { getDaftarPekerjaan, createPekerjaan, deletePekerjaan } from "../actions/pekerjaan";
import { generatePlotting } from "../actions/plotting";
import type { OptionsData, PekerjaanRow } from "../types";

interface FormData {
  judul: string;
  tipe_pekerjaan_id: number | "";
  poin_jam: string;
  kuota: string;
  tanggal_mulai: string;
  tanggal_selesai: string;
  ruangan_id: number | "";
  deskripsi: string;
}

const emptyForm: FormData = {
  judul: "",
  tipe_pekerjaan_id: "",
  poin_jam: "",
  kuota: "",
  tanggal_mulai: "",
  tanggal_selesai: "",
  ruangan_id: "",
  deskripsi: "",
};

export default function TabKelola() {
  const [dataPekerjaan, setDataPekerjaan] = useState<PekerjaanRow[]>([]);
  const [options, setOptions] = useState<OptionsData>({
    tipe_pekerjaan: [],
    ruangan: [],
    semester_aktif: null,
  });
  
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isPlotting, setIsPlotting] = useState(false);
  const [formData, setFormData] = useState<FormData>(emptyForm);
  const [error, setError] = useState("");
  const [successMsg, setSuccessMsg] = useState("");

  const fetchData = useCallback(async () => {
    setIsLoading(true);
    try {
      const [pekerjaanData, optionsData] = await Promise.all([
        getDaftarPekerjaan({}),
        getOptions(),
      ]);
      setDataPekerjaan(pekerjaanData);
      setOptions(optionsData);
    } catch (err) {
      console.error("Error fetching data:", err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleOpenModal = () => {
    setError("");
    setSuccessMsg("");
    setFormData(emptyForm);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setFormData(emptyForm);
    setError("");
  };

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError("");
    setSuccessMsg("");

    try {
      const result = await createPekerjaan({
        judul: formData.judul,
        deskripsi: formData.deskripsi || undefined,
        tipe_pekerjaan_id: Number(formData.tipe_pekerjaan_id),
        poin_jam: parseFloat(formData.poin_jam),
        quota: Number(formData.kuota),
        tanggal_mulai: formData.tanggal_mulai || undefined,
        tanggal_selesai: formData.tanggal_selesai,
        ruangan_id: formData.ruangan_id ? Number(formData.ruangan_id) : undefined,
      });

      if (result.success) {
        setSuccessMsg("Pekerjaan berhasil ditambahkan");
        setTimeout(() => {
          handleCloseModal();
          fetchData();
        }, 1000);
      } else {
        setError(result.error || "Gagal menambahkan pekerjaan");
      }
    } catch (err) {
      setError("Terjadi kesalahan sistem");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Yakin ingin menghapus pekerjaan ini?")) return;

    try {
      const result = await deletePekerjaan(id);
      if (result.success) {
        fetchData();
      } else {
        alert(result.error || "Gagal menghapus pekerjaan");
      }
    } catch (err) {
      alert("Terjadi kesalahan sistem");
    }
  };

  const handleGeneratePlotting = async () => {
    setIsPlotting(true);
    setError("");
    setSuccessMsg("");

    try {
      const result = await generatePlotting({
        sortBy: "nim",
        maxJamPerHari: 8,
      });

      if (result.success) {
        setSuccessMsg(
          `Berhasil! ${result.processedCount} pekerjaan diproses, ${result.assignmentCount} mahasiswa ditugaskan`
        );
        fetchData();
      } else {
        setError(result.error || "Gagal generate plotting");
      }
    } catch (err) {
      setError("Terjadi kesalahan sistem");
    } finally {
      setIsPlotting(false);
    }
  };

  const formatDate = (dateString: string | null) => {
    if (!dateString) return "-";
    const date = new Date(dateString);
    return date.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "long",
      year: "numeric",
    });
  };

  return (
    <div
      className="bg-white border border-gray-200 shadow-sm rounded-xl p-4"
      suppressHydrationWarning
    >
      {/* Error/Success Messages */}
      {error && (
        <div className="mb-4 flex items-center gap-2 p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
          <AlertCircle className="w-4 h-4" />
          {error}
        </div>
      )}
      {successMsg && (
        <div className="mb-4 flex items-center gap-2 p-3 bg-green-50 border border-green-200 rounded-lg text-green-700 text-sm">
          <CheckCircle className="w-4 h-4" />
          {successMsg}
        </div>
      )}

      {/* Action Bar */}
      <div className="flex justify-end items-center mb-4">
        <div className="flex gap-3">
          <button
            onClick={handleGeneratePlotting}
            disabled={isPlotting || isLoading}
            className="flex items-center gap-1.5 px-4 py-2 border border-gray-200 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-50 transition-colors bg-white shadow-sm focus:outline-none disabled:opacity-50"
          >
            {isPlotting ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                Memproses...
              </>
            ) : (
              <>
                <RefreshCw className="w-4 h-4" />
                Generate Plotting
              </>
            )}
          </button>
          <button
            onClick={handleOpenModal}
            className="flex items-center gap-1.5 px-4 py-2 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity shadow-sm focus:outline-none"
          >
            <Plus className="w-4 h-4" />
            Tambah Manual
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="border border-gray-200 rounded-lg overflow-hidden">
        <table className="w-full text-sm text-left">
          <thead className="bg-gray-50 text-gray-600 text-xs uppercase font-medium">
            <tr className="border-b border-gray-200">
              <th className="px-4 py-3">Pekerjaan</th>
              <th className="px-4 py-3 text-center">Tipe</th>
              <th className="px-4 py-3 text-center">Poin</th>
              <th className="px-4 py-3 text-center">Kuota Sisa</th>
              <th className="px-4 py-3 text-center">Tanggal Selesai</th>
              <th className="px-4 py-3 text-center">Status</th>
              <th className="px-4 py-3 text-center">Aksi</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {isLoading ? (
              <tr>
                <td colSpan={7} className="px-4 py-8 text-center text-gray-500">
                  <Loader2 className="w-5 h-5 animate-spin mx-auto mb-2" />
                  Memuat data...
                </td>
              </tr>
            ) : dataPekerjaan.length === 0 ? (
              <tr>
                <td colSpan={7} className="px-4 py-8 text-center text-gray-500">
                  Belum ada data pekerjaan.
                </td>
              </tr>
            ) : (
              dataPekerjaan.map((item) => (
                <tr
                  key={item.id}
                  className="hover:bg-gray-50/50 transition-colors"
                >
                  <td className="px-4 py-3 text-gray-800 font-medium">
                    {item.judul}
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span
                      className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium text-white ${
                        item.tipe_pekerjaan?.nama === "Internal"
                          ? "bg-[var(--color-primary)]"
                          : "bg-orange-500"
                      }`}
                    >
                      {item.tipe}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-600 text-center">
                    {item.poin} jam
                  </td>
                  <td className="px-4 py-3 text-gray-600 text-center">
                    {item.kuotatersisa}/{item.kuotatotal}
                  </td>
                  <td className="px-4 py-3 text-gray-600 text-center">
                    {formatDate(item.tanggal_selesai)}
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 bg-[var(--color-primary)] text-white rounded-full text-xs font-medium">
                      {item.is_aktif ? "Aktif" : "Nonaktif"}
                      <span className="w-1.5 h-1.5 bg-white rounded-full"></span>
                    </span>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <button
                      onClick={() => handleDelete(item.id)}
                      className="text-gray-400 hover:text-red-600 transition-colors focus:outline-none p-1"
                      title="Hapus"
                    >
                      <Trash2 className="w-4 h-4 mx-auto" />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Modal Tambah Manual */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-md mx-4 overflow-hidden animate-in fade-in zoom-in duration-200 max-h-[90vh] overflow-y-auto">
            {/* Modal Header */}
            <div className="flex justify-between items-center p-4 border-b border-gray-100 sticky top-0 bg-white">
              <h3 className="text-lg font-bold text-gray-900">
                Tambah Pekerjaan Manual
              </h3>
              <button
                onClick={handleCloseModal}
                className="text-gray-400 hover:text-gray-600 focus:outline-none p-1 rounded-md hover:bg-gray-100 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Modal Body (Form) */}
            <form onSubmit={handleSubmit} className="p-4 flex flex-col gap-4">
              {error && (
                <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
                  <AlertCircle className="w-4 h-4" />
                  {error}
                </div>
              )}

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Nama Pekerjaan <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  name="judul"
                  required
                  value={formData.judul}
                  onChange={handleInputChange}
                  placeholder="Contoh: Benerin PC Laboratorium"
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Tipe Pekerjaan <span className="text-red-500">*</span>
                </label>
                <select
                  name="tipe_pekerjaan_id"
                  required
                  value={formData.tipe_pekerjaan_id}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm bg-white"
                >
                  <option value="">Pilih Tipe</option>
                  {options.tipe_pekerjaan.map((tipe) => (
                    <option key={tipe.id} value={tipe.id}>
                      {tipe.nama}
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Poin (Jam Kompen){" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="poin_jam"
                    required
                    min="1"
                    step="0.5"
                    value={formData.poin_jam}
                    onChange={handleInputChange}
                    placeholder="Contoh: 8"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Total Kuota Mahasiswa{" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="number"
                    name="kuota"
                    required
                    min="1"
                    value={formData.kuota}
                    onChange={handleInputChange}
                    placeholder="Contoh: 3"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Ruangan (Opsional)
                </label>
                <select
                  name="ruangan_id"
                  value={formData.ruangan_id}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm bg-white"
                >
                  <option value="">Pilih Ruangan</option>
                  {options.ruangan.map((ruangan) => (
                    <option key={ruangan.id} value={ruangan.id}>
                      {ruangan.nama_ruangan}
                      {ruangan.gedung ? ` (${ruangan.gedung})` : ""}
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Tanggal Mulai
                  </label>
                  <input
                    type="date"
                    name="tanggal_mulai"
                    value={formData.tanggal_mulai}
                    onChange={handleInputChange}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Tanggal Selesai{" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="date"
                    name="tanggal_selesai"
                    required
                    value={formData.tanggal_selesai}
                    onChange={handleInputChange}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Deskripsi
                </label>
                <textarea
                  name="deskripsi"
                  rows={3}
                  value={formData.deskripsi}
                  onChange={handleInputChange}
                  placeholder="Deskripsi pekerjaan..."
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm resize-none"
                />
              </div>

              {/* Form Actions */}
              <div className="flex justify-end gap-2 mt-4 pt-4 border-t border-gray-100">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="px-4 py-2 border border-gray-300 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-50 transition-colors focus:outline-none"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="flex items-center gap-2 px-4 py-2 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity focus:outline-none disabled:opacity-50"
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="w-4 h-4 animate-spin" />
                      Menyimpan...
                    </>
                  ) : (
                    "Simpan Pekerjaan"
                  )}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}