import { EyeOff, Plus, X, RefreshCw, Trash2, Loader2, CheckCircle, AlertCircle, ChevronLeft, ChevronRight, Search, MapPin, Settings, UserPlus, Users as UsersIcon } from "lucide-react";
import { useState, useEffect, useCallback } from "react";
import { getOptions, getMahasiswaByKelas } from "../actions/options";
import { getDaftarPekerjaan, createPekerjaan, deletePekerjaan } from "../actions/pekerjaan";
import { generatePlotting, assignMahasiswaManual } from "../actions/plotting";
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
    kelas: [],
  });

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isPlotting, setIsPlotting] = useState(false);
  const [formData, setFormData] = useState<FormData>(emptyForm);
  const [error, setError] = useState("");
  const [successMsg, setSuccessMsg] = useState("");
  const [roomSearch, setRoomSearch] = useState("");
  const [isRoomDropdownOpen, setIsRoomDropdownOpen] = useState(false);

  // Manage Job Modal States
  const [isManageModalOpen, setIsManageModalOpen] = useState(false);
  const [selectedJob, setSelectedJob] = useState<PekerjaanRow | null>(null);
  const [isPlottingSubmitting, setIsPlottingSubmitting] = useState(false);
  const [plottingKelasId, setPlottingKelasId] = useState<number>(0);
  const [plottingNim, setPlottingNim] = useState<string>("");
  const [mahasiswaOptions, setMahasiswaOptions] = useState<{ nim: string, nama: string }[]>([]);
  const [isMahasiswaLoading, setIsMahasiswaLoading] = useState(false);

  // Searchable States for Manage Modal
  const [kelasPlottingSearch, setKelasPlottingSearch] = useState("");
  const [mhsPlottingSearch, setMhsPlottingSearch] = useState("");
  const [isKelasPlottingOpen, setIsKelasPlottingOpen] = useState(false);
  const [isMhsPlottingOpen, setIsMhsPlottingOpen] = useState(false);

  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [totalData, setTotalData] = useState(0);

  const totalPages = Math.ceil(totalData / limit);
  const startItem = totalData === 0 ? 0 : (page - 1) * limit + 1;
  const endItem = Math.min(page * limit, totalData);

  const fetchData = useCallback(async () => {
    setIsLoading(true);
    try {
      const offset = (page - 1) * limit;
      const [pekerjaanData, optionsData] = await Promise.all([
        getDaftarPekerjaan({ limit, offset }),
        getOptions(),
      ]);

      if ('data' in pekerjaanData) {
        setDataPekerjaan(pekerjaanData.data);
        setTotalData(pekerjaanData.total);
      } else {
        setDataPekerjaan(pekerjaanData);
        setTotalData(pekerjaanData.length);
      }
      setOptions(optionsData);
    } catch (err) {
      console.error("Error fetching data:", err);
    } finally {
      setIsLoading(false);
    }
  }, [page, limit]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  // Handle click outside to close dropdowns
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as HTMLElement;
      if (!target.closest(".room-select-container")) {
        setIsRoomDropdownOpen(false);
      }
      if (!target.closest(".kelas-plotting-container")) {
        setIsKelasPlottingOpen(false);
      }
      if (!target.closest(".mhs-plotting-container")) {
        setIsMhsPlottingOpen(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  // Fetch Mahasiswa when class is selected in Manage Modal
  useEffect(() => {
    if (plottingKelasId) {
      const fetchMhs = async () => {
        setIsMahasiswaLoading(true);
        const mhs = await getMahasiswaByKelas(plottingKelasId);
        setMahasiswaOptions(mhs);
        setIsMahasiswaLoading(false);
      };
      fetchMhs();
    } else {
      setMahasiswaOptions([]);
      setPlottingNim("");
      setMhsPlottingSearch("");
    }
  }, [plottingKelasId]);

  const handleOpenModal = () => {
    setError("");
    setSuccessMsg("");
    setFormData(emptyForm);
    setRoomSearch("");
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setFormData(emptyForm);
    setError("");
  };

  const handleOpenManageModal = (job: PekerjaanRow) => {
    setSelectedJob(job);
    setPlottingKelasId(0);
    setPlottingNim("");
    setKelasPlottingSearch("");
    setMhsPlottingSearch("");
    setError("");
    setSuccessMsg("");
    setIsManageModalOpen(true);
  };

  const handleCloseManageModal = () => {
    setIsManageModalOpen(false);
    setSelectedJob(null);
    setError("");
    setSuccessMsg("");
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

  const handleDelete = async () => {
    if (!selectedJob) return;
    if (!confirm(`Yakin ingin menghapus pekerjaan "${selectedJob.judul}"?`)) return;

    try {
      const result = await deletePekerjaan(selectedJob.id);
      if (result.success) {
        setSuccessMsg("Pekerjaan berhasil dihapus");
        setTimeout(() => {
          handleCloseManageModal();
          fetchData();
        }, 1000);
      } else {
        setError(result.error || "Gagal menghapus pekerjaan");
      }
    } catch (err) {
      setError("Terjadi kesalahan sistem");
    }
  };

  const handleManualPlot = async () => {
    if (!selectedJob || !plottingNim) {
      setError("Pilih mahasiswa terlebih dahulu");
      return;
    }

    setIsPlottingSubmitting(true);
    setError("");
    setSuccessMsg("");

    try {
      const result = await assignMahasiswaManual(selectedJob.id, plottingNim);
      if (result.success) {
        setSuccessMsg("Berhasil mem-plot mahasiswa secara manual");
        setPlottingNim("");
        setMhsPlottingSearch("");
        // Refresh job data to update quota
        fetchData();
        // Update local selected job to reflect changes in modal
        const updatedJob = { ...selectedJob, kuotatersisa: selectedJob.kuotatersisa - 1 };
        setSelectedJob(updatedJob);
      } else {
        setError(result.error || "Gagal mem-plot mahasiswa");
      }
    } catch (err) {
      setError("Terjadi kesalahan sistem");
    } finally {
      setIsPlottingSubmitting(false);
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
      {/* Error/Success Messages Main */}
      {error && !isModalOpen && !isManageModalOpen && (
        <div className="mb-4 flex items-center gap-2 p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
          <AlertCircle className="w-4 h-4" />
          {error}
        </div>
      )}
      {successMsg && !isModalOpen && !isManageModalOpen && (
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
            Tambah Pekerjaan
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
                      className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium text-white ${item.tipe_pekerjaan?.nama === "Internal"
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
                      onClick={() => handleOpenManageModal(item)}
                      className="text-gray-400 hover:text-[var(--color-primary)] transition-colors focus:outline-none p-1.5 hover:bg-blue-50 rounded-lg"
                      title="Kelola Pekerjaan"
                    >
                      <Settings className="w-4.5 h-4.5 mx-auto" />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {totalData > 0 && (
        <div className="flex items-center justify-between mt-4 pt-3 border-t border-gray-100">
          <div className="flex items-center gap-2">
            <span className="text-xs text-gray-500">Tampilkan</span>
            <select
              value={limit}
              onChange={(e) => {
                setLimit(Number(e.target.value));
                setPage(1);
              }}
              className="px-2 py-1 text-xs border border-gray-200 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500/20"
            >
              <option value={10}>10</option>
              <option value={25}>25</option>
              <option value={50}>50</option>
            </select>
            <span className="text-xs text-gray-500">data</span>
          </div>

          <div className="flex items-center gap-2">
            <span className="text-xs text-gray-500">
              {startItem}-{endItem} dari {totalData}
            </span>
            <button
              onClick={() => setPage(page - 1)}
              disabled={page === 1}
              className="p-1 border border-gray-200 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              title="Halaman sebelumnya"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <button
              onClick={() => setPage(page + 1)}
              disabled={page >= totalPages}
              className="p-1 border border-gray-200 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              title="Halaman selanjutnya"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

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

              <div className="relative room-select-container">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Ruangan (Opsional)
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <MapPin className="h-4 w-4 text-gray-400" />
                  </div>
                  <input
                    type="text"
                    placeholder="Cari atau pilih ruangan..."
                    value={roomSearch}
                    onFocus={() => setIsRoomDropdownOpen(true)}
                    onChange={(e) => {
                      setRoomSearch(e.target.value);
                      setIsRoomDropdownOpen(true);
                      if (e.target.value === "") {
                        setFormData(prev => ({ ...prev, ruangan_id: "" }));
                      }
                    }}
                    className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                  />
                  {isRoomDropdownOpen && (
                    <div className="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg max-h-48 overflow-y-auto">
                      <div 
                        className="px-3 py-2 hover:bg-gray-100 cursor-pointer text-sm text-gray-500 italic border-b border-gray-50"
                        onClick={() => {
                          setFormData(prev => ({ ...prev, ruangan_id: "" }));
                          setRoomSearch("");
                          setIsRoomDropdownOpen(false);
                        }}
                      >
                        Tidak ada ruangan
                      </div>
                      {options.ruangan
                        .filter(r => 
                          r.nama_ruangan.toLowerCase().includes(roomSearch.toLowerCase()) ||
                          (r.gedung && r.gedung.toLowerCase().includes(roomSearch.toLowerCase()))
                        )
                        .map((ruangan) => (
                          <div
                            key={ruangan.id}
                            className="px-3 py-2 hover:bg-blue-50 cursor-pointer text-sm transition-colors border-b last:border-0 border-gray-50"
                            onClick={() => {
                              setFormData(prev => ({ ...prev, ruangan_id: ruangan.id }));
                              setRoomSearch(`${ruangan.nama_ruangan}${ruangan.gedung ? ` (${ruangan.gedung})` : ""}`);
                              setIsRoomDropdownOpen(false);
                            }}
                          >
                            <span className="font-medium text-gray-900">{ruangan.nama_ruangan}</span>
                            {ruangan.gedung && <span className="ml-2 text-gray-500 text-xs">Gedung {ruangan.gedung}</span>}
                          </div>
                        ))}
                      {options.ruangan.filter(r => 
                          r.nama_ruangan.toLowerCase().includes(roomSearch.toLowerCase()) ||
                          (r.gedung && r.gedung.toLowerCase().includes(roomSearch.toLowerCase()))
                        ).length === 0 && roomSearch !== "" && (
                          <div className="px-3 py-4 text-center text-gray-400 text-xs italic">
                            Ruangan tidak ditemukan
                          </div>
                        )}
                    </div>
                  )}
                </div>
                {/* Hidden input for form submission if needed, but we use formData state */}
                <input type="hidden" name="ruangan_id" value={formData.ruangan_id} />
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

      {/* Modal Kelola Pekerjaan (Unified Manage Modal) */}
      {isManageModalOpen && selectedJob && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in duration-200 max-h-[90vh] flex flex-col">
            {/* Modal Header */}
            <div className="flex justify-between items-center p-5 border-b border-gray-100 bg-white sticky top-0 z-10">
              <div>
                <h3 className="text-lg font-bold text-gray-900">
                  Kelola Pekerjaan
                </h3>
                <p className="text-xs text-blue-600 font-medium mt-0.5">{selectedJob.judul}</p>
              </div>
              <button
                onClick={handleCloseManageModal}
                className="text-gray-400 hover:text-gray-600 focus:outline-none p-1.5 rounded-lg hover:bg-gray-100 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="overflow-y-auto flex-1 p-5 space-y-8">
              {/* Messages inside modal */}
              {error && (isManageModalOpen) && (
                <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
                  <AlertCircle className="w-4 h-4" />
                  {error}
                </div>
              )}
              {successMsg && (isManageModalOpen) && (
                <div className="flex items-center gap-2 p-3 bg-green-50 border border-green-200 rounded-lg text-green-700 text-sm">
                  <CheckCircle className="w-4 h-4" />
                  {successMsg}
                </div>
              )}

              {/* Job Summary */}
              <div className="grid grid-cols-2 gap-4 p-4 bg-gray-50 rounded-xl border border-gray-100">
                <div>
                  <p className="text-[10px] uppercase font-bold text-gray-400 tracking-wider">Kuota Sisa</p>
                  <p className="text-lg font-bold text-gray-900">{selectedJob.kuotatersisa}/{selectedJob.kuotatotal}</p>
                </div>
                <div>
                  <p className="text-[10px] uppercase font-bold text-gray-400 tracking-wider">Poin Jam</p>
                  <p className="text-lg font-bold text-[var(--color-primary)]">{selectedJob.poin} Jam</p>
                </div>
              </div>

              {/* Plotting Section */}
              <div className="space-y-4">
                <div className="flex items-center gap-2 pb-2 border-b border-gray-100">
                  <UserPlus className="w-5 h-5 text-[var(--color-primary)]" />
                  <h4 className="font-bold text-gray-900 text-sm">Plot Mahasiswa Manual</h4>
                </div>

                <div className="space-y-4">
                  {/* Select Kelas */}
                  <div className="relative kelas-plotting-container">
                    <label className="block text-[11px] font-bold text-gray-500 mb-1.5 uppercase tracking-wide">Pilih Kelas</label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <UsersIcon className="h-4 w-4 text-gray-400" />
                      </div>
                      <input
                        type="text"
                        placeholder="Ketik nama kelas..."
                        value={kelasPlottingSearch}
                        onFocus={() => setIsKelasPlottingOpen(true)}
                        onChange={(e) => {
                          setKelasPlottingSearch(e.target.value);
                          setIsKelasPlottingOpen(true);
                          if (e.target.value === "") {
                            setPlottingKelasId(0);
                          }
                        }}
                        className="w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm bg-white shadow-sm"
                      />
                      {isKelasPlottingOpen && (
                        <div className="absolute z-30 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-xl max-h-40 overflow-y-auto animate-in fade-in slide-in-from-top-2 duration-150">
                          {options.kelas
                            .filter(k => k.nama_kelas.toLowerCase().includes(kelasPlottingSearch.toLowerCase()))
                            .map((k) => (
                              <div
                                key={k.id}
                                className="px-4 py-2.5 hover:bg-blue-50 cursor-pointer text-sm font-medium text-gray-700 transition-colors border-b border-gray-50 last:border-0"
                                onClick={() => {
                                  setPlottingKelasId(k.id);
                                  setKelasPlottingSearch(k.nama_kelas);
                                  setIsKelasPlottingOpen(false);
                                }}
                              >
                                {k.nama_kelas}
                              </div>
                            ))}
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Select Mahasiswa */}
                  <div className={`relative mhs-plotting-container ${!plottingKelasId && "opacity-50 pointer-events-none"}`}>
                    <label className="block text-[11px] font-bold text-gray-500 mb-1.5 uppercase tracking-wide">Pilih Mahasiswa</label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        {isMahasiswaLoading ? <Loader2 className="h-4 w-4 text-blue-500 animate-spin" /> : <Search className="h-4 w-4 text-gray-400" />}
                      </div>
                      <input
                        type="text"
                        placeholder={plottingKelasId ? "Ketik nama atau NIM..." : "Pilih kelas dulu"}
                        value={mhsPlottingSearch}
                        onFocus={() => setIsMhsPlottingOpen(true)}
                        onChange={(e) => {
                          setMhsPlottingSearch(e.target.value);
                          setIsMhsPlottingOpen(true);
                          if (e.target.value === "") {
                            setPlottingNim("");
                          }
                        }}
                        className="w-full pl-10 pr-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm bg-white shadow-sm"
                      />
                      {isMhsPlottingOpen && plottingKelasId && (
                        <div className="absolute z-30 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-xl max-h-48 overflow-y-auto animate-in fade-in slide-in-from-top-2 duration-150">
                          {mahasiswaOptions
                            .filter(m => 
                              m.nama.toLowerCase().includes(mhsPlottingSearch.toLowerCase()) ||
                              m.nim.includes(mhsPlottingSearch)
                            )
                            .map((m) => (
                              <div
                                key={m.nim}
                                className="px-4 py-2.5 hover:bg-blue-50 cursor-pointer text-sm transition-colors border-b border-gray-50 last:border-0"
                                onClick={() => {
                                  setPlottingNim(m.nim);
                                  setMhsPlottingSearch(m.nama);
                                  setIsMhsPlottingOpen(false);
                                }}
                              >
                                <p className="font-bold text-gray-900">{m.nama}</p>
                                <p className="text-[10px] text-blue-600 font-medium">{m.nim}</p>
                              </div>
                            ))}
                          {mahasiswaOptions.filter(m => 
                              m.nama.toLowerCase().includes(mhsPlottingSearch.toLowerCase()) ||
                              m.nim.includes(mhsPlottingSearch)
                            ).length === 0 && (
                            <div className="px-4 py-8 text-center text-gray-400 text-xs italic bg-gray-50">
                              Mahasiswa tidak ditemukan
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  </div>

                  <button
                    onClick={handleManualPlot}
                    disabled={isPlottingSubmitting || !plottingNim || selectedJob.kuotatersisa === 0}
                    className="w-full py-2.5 bg-[var(--color-primary)] text-white font-bold text-sm rounded-lg hover:opacity-90 transition-opacity focus:outline-none disabled:opacity-50 shadow-md flex items-center justify-center gap-2"
                  >
                    {isPlottingSubmitting ? (
                      <>
                        <Loader2 className="w-4 h-4 animate-spin" />
                        Sedang Mem-plot...
                      </>
                    ) : (
                      <>
                        <CheckCircle className="w-4 h-4" />
                        Plot Mahasiswa Ke Pekerjaan Ini
                      </>
                    )}
                  </button>
                </div>
              </div>

              {/* Danger Zone */}
              <div className="pt-6 border-t border-gray-100">
                <h4 className="text-[11px] font-bold text-red-500 mb-4 uppercase tracking-widest">Zona Berbahaya</h4>
                <button
                  onClick={handleDelete}
                  className="w-full flex items-center justify-center gap-2 px-4 py-2.5 border border-red-200 text-red-600 text-sm font-bold rounded-lg hover:bg-red-50 transition-colors"
                >
                  <Trash2 className="w-4 h-4" />
                  Hapus Pekerjaan Permanen
                </button>
              </div>
            </div>

            {/* Modal Footer */}
            <div className="p-4 border-t border-gray-100 bg-gray-50 flex justify-end">
              <button
                onClick={handleCloseManageModal}
                className="px-6 py-2 border border-gray-300 text-gray-700 font-bold text-xs rounded-lg hover:bg-gray-200 transition-colors bg-white shadow-sm"
              >
                Tutup
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}