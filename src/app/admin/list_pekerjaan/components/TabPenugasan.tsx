"use client";

import { useState, useEffect, useCallback } from "react";
import { Info, Clock, X, CheckCircle, XCircle, Loader2, AlertCircle, ChevronLeft, ChevronRight } from "lucide-react";
import { getDaftarKompen, verifyPenugasan, rejectPenugasan } from "../actions/penugasan";
import { getOptions } from "../actions/options";
import type { MahasiswaKompenRow, OptionsData } from "../types";

type StatusFilter = "belum_ditugaskan" | "sedang_dikerjakan" | "selesai" | "semua";

export default function TabPenugasan() {
  const [dataMahasiswa, setDataMahasiswa] = useState<MahasiswaKompenRow[]>([]);
  const [options, setOptions] = useState<OptionsData>({
    tipe_pekerjaan: [],
    ruangan: [],
    semester_aktif: null,
  });

  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [modalState, setModalState] = useState<"closed" | "verifikasi" | "tolak">("closed");
  const [selectedData, setSelectedData] = useState<MahasiswaKompenRow | null>(null);
  const [statusFilter, setStatusFilter] = useState<StatusFilter>("semua");
  const [search, setSearch] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const [successMsg, setSuccessMsg] = useState("");

  const [formAlasan, setFormAlasan] = useState({ penugasan_id: 0, catatan: "" });

  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [totalData, setTotalData] = useState(0);

  const totalPages = Math.ceil(totalData / limit);
  const startItem = totalData === 0 ? 0 : (page - 1) * limit + 1;
  const endItem = Math.min(page * limit, totalData);

  const fetchData = useCallback(async () => {
    setIsLoading(true);
    setErrorMessage("");
    try {
      const offset = (page - 1) * limit;
      console.log('Fetching with:', { page, limit, offset, statusFilter, search });
      const [kompenData, optionsData] = await Promise.all([
        getDaftarKompen({
          limit,
          offset,
          status_filter: statusFilter,
          search: search,
        }),
        getOptions(),
      ]);

      console.log('Result:', kompenData);
      setDataMahasiswa(kompenData.data);
      setTotalData(kompenData.total);
      setOptions(optionsData);
    } catch (err) {
      console.error("Error fetching data:", err);
      setErrorMessage("Gagal memuat data");
    } finally {
      setIsLoading(false);
    }
  }, [page, limit, statusFilter, search]);

  useEffect(() => {
    fetchData();
  }, [page, limit, statusFilter, search]);

  useEffect(() => {
    setPage(1);
  }, [statusFilter, search]);

  const openVerifikasi = (data: MahasiswaKompenRow) => {
    setSelectedData(data);
    setErrorMessage("");
    setSuccessMsg("");
    setModalState("verifikasi");
  };

  const handleTolakClick = () => {
    setModalState("tolak");
    setErrorMessage("");
  };

  const handleClose = () => {
    setModalState("closed");
    setSelectedData(null);
    setFormAlasan({ penugasan_id: 0, catatan: "" });
  };

  const handleVerify = async () => {
    if (!selectedData || !selectedData.penugasan_id) return;

    setIsSubmitting(true);
    setErrorMessage("");
    setSuccessMsg("");

    try {
      const staffNip = options.semester_aktif?.nama ? "196801011990031001" : "196801011990031001";

      const result = await verifyPenugasan({
        penugasan_id: selectedData.penugasan_id,
        verifikasi_oleh_nip: staffNip,
      });

      if (result.success) {
        setSuccessMsg("Penugasan berhasil diverifikasi dan jam kompen dipotong");
        setTimeout(() => {
          handleClose();
          fetchData();
        }, 1500);
      } else {
        setErrorMessage(result.error || "Gagal memverifikasi penugasan");
      }
    } catch {
      setErrorMessage("Terjadi kesalahan sistem");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleReject = async () => {
    if (!selectedData || !selectedData.penugasan_id) return;
    if (!formAlasan.catatan.trim()) {
      setErrorMessage("Alasan penolakan wajib diisi");
      return;
    }

    setIsSubmitting(true);
    setErrorMessage("");

    try {
      const result = await rejectPenugasan({
        penugasan_id: selectedData.penugasan_id,
        catatan_verifikasi: formAlasan.catatan,
      });

      if (result.success) {
        setSuccessMsg("Penugasan berhasil ditolak");
        setTimeout(() => {
          handleClose();
          fetchData();
        }, 1500);
      } else {
        setErrorMessage(result.error || "Gagal menolak penugasan");
      }
    } catch {
      setErrorMessage("Terjadi kesalahan sistem");
    } finally {
      setIsSubmitting(false);
    }
  };

  const getStatusBadge = (statusId: number | null, statusNama: string | null) => {
    if (!statusId) {
      return (
        <span className="px-2 py-1 border rounded-md text-xs font-medium bg-gray-50 text-gray-500 border-gray-200">
          Belum Ditugaskan
        </span>
      );
    }

    const styles: Record<string, string> = {
      "1": "bg-gray-100 text-gray-600 border-gray-200",
      "2": "bg-blue-50 text-blue-600 border-blue-200",
      "3": "bg-yellow-50 text-yellow-600 border-yellow-200",
      "4": "bg-green-50 text-green-600 border-green-200",
    };
    const style = styles[String(statusId)] || styles["1"];
    return (
      <span className={`px-2 py-1 border rounded-md text-xs font-medium ${style}`}>
        {statusNama || 'Unknown'}
      </span>
    );
  };

  const formatDate = (dateString: string) => {
    if (!dateString) return "-";
    const date = new Date(dateString);
    return date.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "long",
      year: "numeric",
    });
  };

  return (
    <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-4" suppressHydrationWarning>
      {(errorMessage || successMsg) && (
        <div className={`mb-4 flex items-center gap-2 p-3 text-sm ${errorMessage
            ? "bg-red-50 border border-red-200 rounded-lg text-red-700"
            : "bg-green-50 border border-green-200 rounded-lg text-green-700"
          }`}>
          {errorMessage ? <AlertCircle className="w-4 h-4" /> : <CheckCircle className="w-4 h-4" />}
          {errorMessage || successMsg}
        </div>
      )}

      {/* Filter Tabs */}
      <div className="flex flex-col sm:flex-row gap-2 md:gap-3 mb-4" suppressHydrationWarning>
        <input
          placeholder="Cari NIM, Nama..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="flex-1 px-3 md:px-4 py-1.5 md:py-2 border border-gray-200 rounded-lg text-xs md:text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all placeholder-gray-400"
        />

        <div className="flex border border-gray-200 rounded-lg overflow-hidden divide-x divide-gray-200 shadow-sm">
          <button
            onClick={() => setStatusFilter("belum_ditugaskan")}
            className={`px-2 md:px-4 py-1.5 md:py-2 font-medium text-xs md:text-sm transition-colors focus:outline-none whitespace-nowrap ${statusFilter === "belum_ditugaskan"
                ? "bg-blue-50 text-blue-600"
                : "text-gray-600 bg-white hover:bg-gray-50"
              }`}
          >
            Belum Ditugaskan
          </button>
          <button
            onClick={() => setStatusFilter("sedang_dikerjakan")}
            className={`px-2 md:px-4 py-1.5 md:py-2 font-medium text-xs md:text-sm transition-colors focus:outline-none whitespace-nowrap ${statusFilter === "sedang_dikerjakan"
                ? "bg-blue-50 text-blue-600"
                : "text-gray-600 bg-white hover:bg-gray-50"
              }`}
          >
            Sedang Dikerjakan
          </button>
          <button
            onClick={() => setStatusFilter("selesai")}
            className={`px-2 md:px-4 py-1.5 md:py-2 font-medium text-xs md:text-sm transition-colors focus:outline-none whitespace-nowrap ${statusFilter === "selesai"
                ? "bg-blue-50 text-blue-600"
                : "text-gray-600 bg-white hover:bg-gray-50"
              }`}
          >
            Selesai
          </button>
          <button
            onClick={() => setStatusFilter("semua")}
            className={`px-2 md:px-4 py-1.5 md:py-2 font-medium text-xs md:text-sm transition-colors focus:outline-none whitespace-nowrap ${statusFilter === "semua"
                ? "bg-blue-50 text-blue-600"
                : "text-gray-600 bg-white hover:bg-gray-50"
              }`}
          >
            Semua
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="border border-gray-200 rounded-lg overflow-x-auto">
        <table className="w-full text-xs md:text-sm text-left">
          <thead className="bg-gray-50 text-gray-600 text-[10px] md:text-xs uppercase font-medium">
            <tr className="border-b border-gray-200">
              <th className="px-2 md:px-4 py-2 md:py-3 text-center w-12">No</th>
              <th className="px-2 md:px-4 py-2 md:py-3">Mahasiswa</th>
              <th className="px-2 md:px-4 py-2 md:py-3 hidden md:table-cell">Pekerjaan</th>
              <th className="px-2 md:px-4 py-2 md:py-3 text-center hidden lg:table-cell">Jam Kompen</th>
              <th className="px-2 md:px-4 py-2 md:py-3 text-center hidden xl:table-cell">Jam Ditugaskan</th>
              <th className="px-2 md:px-4 py-2 md:py-3 text-center">Status</th>
              <th className="px-2 md:px-4 py-2 md:py-3 text-center">Aksi</th>
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
            ) : dataMahasiswa.length === 0 ? (
              <tr>
                <td colSpan={7} className="px-4 py-8 text-center text-gray-500">
                  {statusFilter === "belum_ditugaskan"
                    ? "Tidak ada mahasiswa yang belum dapat pekerjaan."
                    : statusFilter === "selesai"
                      ? "Tidak ada yang menyelesaikan pekerjaan."
                      : "Tidak ada data."}
                </td>
              </tr>
            ) : (
              dataMahasiswa.map((item, index) => (
                <tr key={item.nim} className="hover:bg-gray-50/50 transition-colors">
                  <td className="px-2 md:px-4 py-2 md:py-3 text-center text-gray-500 text-xs">
                    {index + 1 + (page - 1) * limit}
                  </td>
                  <td className="px-2 md:px-4 py-2 md:py-3">
                    <p className="font-medium text-gray-800 text-xs md:text-sm">{item.nama}</p>
                    <p className="text-[9px] md:text-xs text-blue-600 mt-0.5">{item.nim}</p>
                  </td>
                  <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 hidden md:table-cell text-xs">
                    <div className="flex flex-col gap-2">
                      {item.penugasans && item.penugasans.length > 0 ? (
                        item.penugasans.map((p, i) => (
                          <div key={p.id} className={i > 0 ? "pt-2 border-t border-gray-100" : ""}>
                            {p.pekerjaan_judul || "-"}
                          </div>
                        ))
                      ) : (
                        "-"
                      )}
                    </div>
                  </td>
                  <td className="px-2 md:px-4 py-2 md:py-3 text-center text-gray-600 hidden lg:table-cell text-xs">
                    {item.jam_sisa}/{item.total_jam_wajib}
                  </td>
                  <td className="px-2 md:px-4 py-2 md:py-3 text-center text-gray-600 hidden xl:table-cell text-xs">
                    <div className="flex flex-col gap-2">
                      {item.penugasans && item.penugasans.length > 0 ? (
                        item.penugasans.map((p, i) => (
                          <div key={p.id} className={i > 0 ? "pt-2 border-t border-gray-100" : ""}>
                            {p.poin_jam ? `${p.poin_jam} jam` : "-"}
                          </div>
                        ))
                      ) : (
                        "-"
                      )}
                    </div>
                  </td>
                  <td className="px-2 md:px-4 py-2 md:py-3 text-center">
                    <div className="flex flex-col gap-2 items-center">
                      {item.penugasans && item.penugasans.length > 0 ? (
                        item.penugasans.map((p, i) => (
                          <div key={p.id} className={i > 0 ? "pt-2 border-t border-gray-100 w-full flex justify-center" : "w-full flex justify-center"}>
                            {getStatusBadge(p.status_tugas_id, p.status_nama)}
                          </div>
                        ))
                      ) : (
                        getStatusBadge(null, null)
                      )}
                    </div>
                  </td>
                  <td className="px-2 md:px-4 py-2 md:py-3 text-center">
                    <div className="flex flex-col gap-2 items-center">
                      {item.penugasans && item.penugasans.length > 0 ? (
                        item.penugasans.map((p, i) => (
                          <div key={p.id} className={i > 0 ? "pt-2 border-t border-gray-100 w-full flex justify-center" : "w-full flex justify-center"}>
                            {p.status_tugas_id === 3 && (
                              <button
                                onClick={() => openVerifikasi({
                                  ...item,
                                  penugasan_id: p.id,
                                  pekerjaan_judul: p.pekerjaan_judul,
                                  poin_jam: p.poin_jam,
                                  status_tugas_id: p.status_tugas_id,
                                  status_nama: p.status_nama,
                                })}
                                className="text-[var(--color-primary)] hover:text-white bg-blue-50 hover:bg-[var(--color-primary)] px-2 md:px-3 py-1 md:py-1.5 rounded-lg text-[9px] md:text-xs font-medium transition-colors border border-blue-100 hover:border-[var(--color-primary)] focus:outline-none whitespace-nowrap"
                              >
                                Verifikasi
                              </button>
                            )}
                          </div>
                        ))
                      ) : (
                        "-"
                      )}
                    </div>
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

      {/* Modal Verifikasi */}
      {modalState === "verifikasi" && selectedData && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
            {/* Header */}
            <div className="flex items-center gap-3 p-5 border-b border-gray-200">
              <h2 className="text-lg font-semibold text-gray-900 tracking-wide">{selectedData.nama}</h2>
              <span className="text-gray-300">|</span>
              <span className="text-gray-500 font-medium">{selectedData.nim}</span>
              <div className="ml-auto">
                <span className="px-4 py-1.5 bg-blue-100 text-blue-600 rounded-full text-sm font-medium border border-blue-200">
                  {selectedData.status_nama || 'Belum Ditugaskan'}
                </span>
              </div>
            </div>

            {/* Body */}
            <div className="p-6">
              {/* Error/Success */}
              {(errorMessage || successMsg) && (
                <div className={`mb-4 flex items-center gap-2 p-3 text-sm ${errorMessage
                    ? "bg-red-50 border border-red-200 rounded-lg text-red-700"
                    : "bg-green-50 border border-green-200 rounded-lg text-green-700"
                  }`}>
                  {errorMessage ? <AlertCircle className="w-4 h-4" /> : <CheckCircle className="w-4 h-4" />}
                  {errorMessage || successMsg}
                </div>
              )}

              {/* Info Box */}
              <div className="flex items-start gap-3 p-4 bg-slate-50 border border-gray-200 rounded-xl mb-6">
                <Info className="w-6 h-6 text-[var(--color-primary)] shrink-0 mt-0.5" />
                <div>
                  <h3 className="font-semibold text-gray-900 text-base">{selectedData.pekerjaan_judul || 'Belum ada pekerjaan'}</h3>
                  <p className="text-gray-500 mt-0.5">Poin jam yang akan dikurangi: <span className="text-[var(--color-primary)] font-semibold">{selectedData.poin_jam || 0} jam</span></p>
                  <p className="text-gray-500 mt-1">Jam kompen tersisa: <span className="text-[var(--color-primary)] font-semibold">{selectedData.jam_sisa}/{selectedData.total_jam_wajib}</span></p>
                </div>
              </div>

              {/* Photos Grid - Placeholder */}
              <div className="grid grid-cols-2 gap-6 mb-2">
                <div>
                  <h4 className="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wider">Foto Mulai</h4>
                  <div className="aspect-video bg-gray-100 rounded-xl border border-gray-200 overflow-hidden mb-3 flex items-center justify-center">
                    <span className="text-gray-400 text-sm">Belum ada foto</span>
                  </div>
                  <div className="flex flex-col gap-1.5 p-3 border border-gray-200 rounded-xl">
                    <div className="flex items-center gap-2 text-gray-600 text-sm">
                      <Clock className="w-4 h-4 shrink-0 text-gray-400" />
                      <span>{formatDate(selectedData.created_at || "")}</span>
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wider">Foto Selesai</h4>
                  <div className="aspect-video bg-gray-100 rounded-xl border border-gray-200 overflow-hidden mb-3 flex items-center justify-center">
                    <span className="text-gray-400 text-sm">Belum ada foto</span>
                  </div>
                  <div className="flex flex-col gap-1.5 p-3 border border-gray-200 rounded-xl">
                    <div className="flex items-center gap-2 text-gray-600 text-sm">
                      <Clock className="w-4 h-4 shrink-0 text-gray-400" />
                      <span>{formatDate(selectedData.created_at || "")}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Footer / Actions */}
            <div className="flex justify-between items-center p-5 border-t border-gray-100 bg-gray-50/50">
              <button
                onClick={handleTolakClick}
                className="flex items-center gap-2 px-6 py-2.5 border border-red-300 text-red-600 bg-red-50 hover:bg-red-100 font-medium text-sm rounded-lg transition-colors focus:outline-none"
              >
                <XCircle className="w-5 h-5" />
                Tolak
              </button>
              <div className="flex gap-3">
                <button
                  onClick={handleClose}
                  className="px-6 py-2.5 border border-gray-300 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-100 transition-colors focus:outline-none bg-white"
                >
                  Tutup
                </button>
                <button
                  onClick={handleVerify}
                  disabled={isSubmitting}
                  className="flex items-center gap-2 px-6 py-2.5 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity focus:outline-none disabled:opacity-50"
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="w-5 h-5 animate-spin" />
                      Memproses...
                    </>
                  ) : (
                    <>
                      <CheckCircle className="w-5 h-5" />
                      Setujui & Potong Jam
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal Tolak */}
      {modalState === "tolak" && selectedData && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in duration-200">
            {/* Header */}
            <div className="flex justify-between items-center p-5 border-b border-gray-200">
              <h2 className="text-lg font-bold text-gray-900">Tolak Penugasan</h2>
              <button
                onClick={() => setModalState("verifikasi")}
                className="text-gray-400 hover:text-gray-600 focus:outline-none"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            {/* Body */}
            <div className="p-6">
              {(errorMessage || successMsg) && (
                <div className={`mb-4 flex items-center gap-2 p-3 text-sm ${errorMessage
                    ? "bg-red-50 border border-red-200 rounded-lg text-red-700"
                    : "bg-green-50 border border-green-200 rounded-lg text-green-700"
                  }`}>
                  {errorMessage ? <AlertCircle className="w-4 h-4" /> : <CheckCircle className="w-4 h-4" />}
                  {errorMessage || successMsg}
                </div>
              )}

              <p className="text-gray-700 text-sm mb-6">
                Berikan alasan penolakan yang jelas agar mahasiswa dapat memperbaikinya.
              </p>

              <div>
                <label className="block font-semibold text-gray-900 mb-2">
                  Alasan Penolakan <span className="text-red-500">*</span>
                </label>
                <textarea
                  rows={4}
                  value={formAlasan.catatan}
                  onChange={(e) => setFormAlasan(prev => ({ ...prev, catatan: e.target.value }))}
                  placeholder="misal : Foto tidak jelas, metadata lokasi tidak sesuai ruangan..."
                  className="w-full p-3 border border-blue-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm resize-none"
                ></textarea>
              </div>
            </div>

            {/* Footer */}
            <div className="flex justify-end gap-3 p-5 border-t border-gray-100 bg-gray-50/50">
              <button
                onClick={() => setModalState("verifikasi")}
                className="px-5 py-2.5 border border-gray-300 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-100 transition-colors focus:outline-none bg-white"
              >
                Batal
              </button>
              <button
                onClick={handleReject}
                disabled={isSubmitting}
                className="px-5 py-2.5 bg-red-100 border border-red-300 text-red-700 font-medium text-sm rounded-lg hover:bg-red-200 transition-colors focus:outline-none disabled:opacity-50"
              >
                {isSubmitting ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin inline mr-2" />
                    Memproses...
                  </>
                ) : (
                  "Konfirmasi Tolak"
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}