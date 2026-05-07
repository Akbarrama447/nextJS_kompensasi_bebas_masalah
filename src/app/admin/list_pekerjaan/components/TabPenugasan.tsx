"use client";

import { useState, useEffect } from "react";
import { Info, Clock, MapPin, X, CheckCircle, XCircle, Loader2, Search } from "lucide-react";
import { getAllSemesters, getUniqueTahunAkademik } from "../actions/semester";

interface SemesterData {
  id: number;
  nama: string;
  tahun?: number;
  periode?: string;
  is_aktif?: boolean;
}

export default function TabPenugasan() {
  const [modalState, setModalState] = useState<"closed" | "verifikasi" | "tolak">("closed");
  const [selectedData, setSelectedData] = useState<any>(null);
  const [tahunFilter, setTahunFilter] = useState<number | "">("");
  const [semesterFilter, setSemesterFilter] = useState<number | "">("");
  const [searchQuery, setSearchQuery] = useState("");
  const [allSemesters, setAllSemesters] = useState<SemesterData[]>([]);
  const [tahunList, setTahunList] = useState<number[]>([]);
  const [isLoadingFilters, setIsLoadingFilters] = useState(true);

  const dummyData = [
    { id: 1, nama: "FAREL DEKA", nim: "3.34.24.1.08", kelas: "IK-1B", pekerjaan: "Benarkan PC", jam: "8j", tanggal: "19 April 2026", status: "Proses", semester: "Ganjil 2024/2025", tipePekerjaan: "Internal", tahun: 2024 },
    { id: 2, nama: "RAYA AKBAR PAMUNGKAS", nim: "3.34.24.0.10", kelas: "IK-1B", pekerjaan: "Benarkan pc lab MulMed", jam: "8j", tanggal: "19 April 2026", status: "Proses", semester: "Ganjil 2024/2025", tipePekerjaan: "Eksternal", tahun: 2024 }
  ];

  useEffect(() => {
    const loadFilters = async () => {
      setIsLoadingFilters(true);
      try {
        const [semesters, tahun] = await Promise.all([
          getAllSemesters(),
          getUniqueTahunAkademik(),
        ]);
        setAllSemesters(semesters);
        setTahunList(tahun);

        if (tahun.length > 0) {
          setTahunFilter(tahun[0]);
        }
      } catch (error) {
        console.error("Error loading filters:", error);
      } finally {
        setIsLoadingFilters(false);
      }
    };

    loadFilters();
  }, []);

  useEffect(() => {
    if (tahunFilter) {
      const semestersForTahun = allSemesters.filter(s => s.tahun === tahunFilter);
      setSemesterFilter(semestersForTahun.length > 0 ? semestersForTahun[0].id : "");
    }
  }, [tahunFilter, allSemesters]);

  const filteredData = dummyData.filter((item) => {
    const matchesTahun = tahunFilter === "" || item.tahun === tahunFilter;
    const matchesSearch =
      searchQuery === "" ||
      item.nama.toLowerCase().includes(searchQuery.toLowerCase()) ||
      item.nim.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesTahun && matchesSearch;
  });

  const openVerifikasi = (data: any) => {
    setSelectedData(data);
    setModalState("verifikasi");
  };

  const handleTolakClick = () => {
    setModalState("tolak");
  };

  const handleClose = () => {
    setModalState("closed");
    setSelectedData(null);
  };

  const semestersForTahun = tahunFilter
    ? allSemesters.filter(s => s.tahun === tahunFilter)
    : [];

  return (
    <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-4" suppressHydrationWarning>
      {/* Filters Section */}
      <div className="mb-6 space-y-4">
        {/* Row 1: Search + Status Filter */}
        <div className="flex flex-col sm:flex-row gap-2 md:gap-3">
          <div className="flex-1 relative">
            <input
              placeholder="Cari NIM, Nama..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all placeholder-gray-400"
            />
            <Search size={16} className="absolute left-3 top-2.5 text-gray-400" />
          </div>

          <div className="flex border border-gray-200 rounded-lg overflow-hidden divide-x divide-gray-200 shadow-sm">
            <button className="px-2 md:px-4 py-2 bg-blue-50 text-blue-600 font-medium text-xs md:text-sm hover:bg-blue-100 transition-colors focus:outline-none whitespace-nowrap">
              Pending
            </button>
            <button className="px-2 md:px-4 py-2 text-xs md:text-sm text-gray-600 bg-white hover:bg-gray-50 transition-colors focus:outline-none whitespace-nowrap">
              Selesai
            </button>
            <button className="px-2 md:px-4 py-2 text-xs md:text-sm text-gray-600 bg-white hover:bg-gray-50 transition-colors focus:outline-none whitespace-nowrap">
              Semua
            </button>
          </div>
        </div>

        {/* Row 2: Tahun & Semester Filters */}
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="flex-1">
            <label className="block text-xs font-medium text-gray-600 mb-1.5">Tahun Akademik</label>
            {isLoadingFilters ? (
              <div className="h-9 bg-gray-100 rounded-lg animate-pulse" />
            ) : (
              <select
                value={tahunFilter}
                onChange={(e) => setTahunFilter(e.target.value ? Number(e.target.value) : "")}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white"
              >
                <option value="">Semua Tahun</option>
                {tahunList.map((tahun) => (
                  <option key={tahun} value={tahun}>
                    {tahun}
                  </option>
                ))}
              </select>
            )}
          </div>

          <div className="flex-1">
            <label className="block text-xs font-medium text-gray-600 mb-1.5">Semester</label>
            {isLoadingFilters ? (
              <div className="h-9 bg-gray-100 rounded-lg animate-pulse" />
            ) : (
              <select
                value={semesterFilter}
                onChange={(e) => setSemesterFilter(e.target.value ? Number(e.target.value) : "")}
                disabled={!tahunFilter}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white disabled:bg-gray-50 disabled:text-gray-400"
              >
                <option value="">Semua Semester</option>
                {semestersForTahun.map((sem) => (
                  <option key={sem.id} value={sem.id}>
                    {sem.nama}
                  </option>
                ))}
              </select>
            )}
          </div>
        </div>
      </div>

      {/* Empty State */}
      {filteredData.length === 0 ? (
        <div className="py-12 text-center">
          <p className="text-gray-500 text-sm mb-1">Tidak ada data untuk periode ini</p>
          {tahunFilter && <p className="text-gray-400 text-xs">Coba ubah filter tahun atau semester</p>}
        </div>
      ) : (
        /* Table */
        <div className="border border-gray-200 rounded-lg overflow-x-auto">
          <table className="w-full text-xs md:text-sm text-left">
            <thead className="bg-gray-50 text-gray-600 text-[10px] md:text-xs uppercase font-medium">
              <tr className="border-b border-gray-200">
                <th className="px-4 py-3 text-center w-12">No</th>
                <th className="px-4 py-3">Mahasiswa</th>
                <th className="px-4 py-3 hidden md:table-cell">Pekerjaan</th>
                <th className="px-4 py-3 text-center hidden lg:table-cell">Tipe</th>
                <th className="px-4 py-3 text-center hidden lg:table-cell">Jam</th>
                <th className="px-4 py-3 text-center hidden xl:table-cell">Semester</th>
                <th className="px-4 py-3 text-center">Status</th>
                <th className="px-4 py-3 text-center">Aksi</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-gray-100">
              {filteredData.map((item, index) => (
                <tr key={item.id} className="hover:bg-gray-50/50 transition-colors">
                  <td className="px-4 py-3 text-center text-gray-600 font-medium">{index + 1}</td>
                  <td className="px-4 py-3">
                    <p className="font-medium text-gray-800 text-xs md:text-sm">{item.nama}</p>
                    <p className="text-[9px] md:text-xs text-blue-600 mt-0.5">{item.nim} {item.kelas}</p>
                    <p className="text-[9px] md:hidden text-gray-600 mt-1">{item.pekerjaan}</p>
                  </td>
                  <td className="px-4 py-3 text-gray-600 hidden md:table-cell text-xs">{item.pekerjaan}</td>
                  <td className="px-4 py-3 text-center hidden lg:table-cell">
                    <span
                      className={`inline-flex items-center px-2 py-1 rounded-full text-[9px] font-bold uppercase ${
                        item.tipePekerjaan === "Internal"
                          ? "bg-blue-100 text-blue-700"
                          : "bg-orange-100 text-orange-700"
                      }`}
                    >
                      {item.tipePekerjaan}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-center text-gray-600 hidden lg:table-cell text-xs">{item.jam}</td>
                  <td className="px-4 py-3 text-center text-gray-600 hidden xl:table-cell text-xs text-slate-500">{item.semester}</td>
                  <td className="px-4 py-3 text-center">
                    <span className="px-2 py-1 bg-yellow-50 text-yellow-600 border border-yellow-200 rounded-md text-[9px] md:text-xs font-medium whitespace-nowrap">{item.status}</span>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <button
                      onClick={() => openVerifikasi(item)}
                      className="text-[var(--color-primary)] hover:text-white bg-blue-50 hover:bg-[var(--color-primary)] px-2 md:px-3 py-1 md:py-1.5 rounded-lg text-[9px] md:text-xs font-medium transition-colors border border-blue-100 hover:border-[var(--color-primary)] focus:outline-none whitespace-nowrap"
                    >
                      Verifikasi
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
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
                  Verifikasi
                </span>
              </div>
            </div>

            {/* Body */}
            <div className="p-6">
              {/* Info Box */}
              <div className="flex items-start gap-3 p-4 bg-slate-50 border border-gray-200 rounded-xl mb-6">
                <Info className="w-6 h-6 text-[var(--color-primary)] shrink-0 mt-0.5" />
                <div>
                  <h3 className="font-semibold text-gray-900 text-base">{selectedData.pekerjaan}</h3>
                  <p className="text-gray-500 mt-0.5">Poin jam yang akan dikurangi: <span className="text-[var(--color-primary)] font-semibold">{selectedData.jam}</span></p>
                </div>
              </div>

              {/* Photos Grid */}
              <div className="grid grid-cols-2 gap-6 mb-2">
                {/* Foto Mulai */}
                <div>
                  <h4 className="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wider">Foto Mulai</h4>
                  <div className="aspect-video bg-[url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCI+CjxyZWN0IHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgZmlsbD0iI2ZmZmZmZiI+PC9yZWN0Pgo8cmVjdCB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIGZpbGw9IiNmM2Y0ZjYiPjwvcmVjdD4KPHJlY3QgeD0iMTAiIHk9IjEwIiB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIGZpbGw9IiNmM2Y0ZjYiPjwvcmVjdD4KPC9zdmc+')] rounded-xl border border-gray-200 overflow-hidden mb-3">
                    {/* Placeholder for actual image */}
                  </div>
                  <div className="flex flex-col gap-1.5 p-3 border border-gray-200 rounded-xl">
                    <div className="flex items-center gap-2 text-gray-600 text-sm">
                      <Clock className="w-4 h-4 shrink-0 text-gray-400" />
                      <span>{selectedData.tanggal} pukul 07.00</span>
                    </div>
                    <div className="flex items-center gap-2 text-[var(--color-primary)] text-sm font-medium cursor-pointer hover:underline">
                      <MapPin className="w-4 h-4 shrink-0" />
                      <span>Lihat Lokasi Mulai</span>
                    </div>
                  </div>
                </div>

                {/* Foto Selesai */}
                <div>
                  <h4 className="text-xs font-semibold text-gray-500 mb-2 uppercase tracking-wider">Foto Selesai</h4>
                  <div className="aspect-video bg-[url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCI+CjxyZWN0IHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgZmlsbD0iI2ZmZmZmZiI+PC9yZWN0Pgo8cmVjdCB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIGZpbGw9IiNmM2Y0ZjYiPjwvcmVjdD4KPHJlY3QgeD0iMTAiIHk9IjEwIiB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIGZpbGw9IiNmM2Y0ZjYiPjwvcmVjdD4KPC9zdmc+')] rounded-xl border border-gray-200 overflow-hidden mb-3">
                    {/* Placeholder for actual image */}
                  </div>
                  <div className="flex flex-col gap-1.5 p-3 border border-gray-200 rounded-xl">
                    <div className="flex items-center gap-2 text-gray-600 text-sm">
                      <Clock className="w-4 h-4 shrink-0 text-gray-400" />
                      <span>{selectedData.tanggal} pukul 15.00</span>
                    </div>
                    <div className="flex items-center gap-2 text-[var(--color-primary)] text-sm font-medium cursor-pointer hover:underline">
                      <MapPin className="w-4 h-4 shrink-0" />
                      <span>Lihat Lokasi Selesai</span>
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
                  onClick={handleClose}
                  className="flex items-center gap-2 px-6 py-2.5 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity focus:outline-none"
                >
                  <CheckCircle className="w-5 h-5" />
                  Setujui & Potong Jam
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Modal Tolak */}
      {modalState === "tolak" && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in duration-200">
            {/* Header */}
            <div className="flex justify-between items-center p-5 border-b border-gray-200">
              <h2 className="text-lg font-bold text-gray-900">Tolak Penugasan</h2>
              <button
                onClick={handleClose}
                className="text-gray-400 hover:text-gray-600 focus:outline-none"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            {/* Body */}
            <div className="p-6">
              <p className="text-gray-700 text-sm mb-6">
                Berikan alasan penolakan yang jelas agar mahasiswa dapat memperbaikinya.
              </p>

              <div>
                <label className="block font-semibold text-gray-900 mb-2">
                  Alasan Penolakan <span className="text-red-500">*</span>
                </label>
                <textarea
                  rows={4}
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
                onClick={handleClose}
                className="px-5 py-2.5 bg-red-100 border border-red-300 text-red-700 font-medium text-sm rounded-lg hover:bg-red-200 transition-colors focus:outline-none"
              >
                Konfirmasi Tolak
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}