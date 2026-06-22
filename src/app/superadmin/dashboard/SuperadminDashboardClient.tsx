"use client";

import { useState, useTransition } from "react";
import { 
  Users, GraduationCap, Calendar, PlusCircle, 
  Building2, CheckCircle2, Search, Sparkles, Clock, AlertCircle
} from "lucide-react";
import { setActiveSemester, createSemester } from "./actions";

interface SemesterType {
  id: number;
  nama: string | null;
  tahun: number | null;
  periode: string | null;
  is_aktif: boolean | null;
}

interface ProdiStat {
  id: number;
  nama: string | null;
  totalKelas: number;
  totalMahasiswa: number;
  totalJamKompen: number;
}

interface JurusanStat {
  id: number;
  nama: string | null;
  totalProdi: number;
  totalMahasiswa: number;
  totalJamKompen: number;
  prodis: ProdiStat[];
}

interface SuperadminDashboardClientProps {
  stats: {
    totalStudents: number;
    totalStaff: number;
    totalJurusan: number;
    totalProdi: number;
    totalActiveKompenHours: number;
  };
  semesters: SemesterType[];
  jurusanStats: JurusanStat[];
}

export default function SuperadminDashboardClient({
  stats,
  semesters: initialSemesters,
  jurusanStats,
}: SuperadminDashboardClientProps) {
  const [semesters, setSemesters] = useState<SemesterType[]>(initialSemesters);
  const [selectedSemesterId, setSelectedSemesterId] = useState<number>(
    initialSemesters.find(s => s.is_aktif)?.id || (initialSemesters[0]?.id ?? 0)
  );
  
  // Semester Creator Form State
  const [newSemesterName, setNewSemesterName] = useState("");
  const [newSemesterTahun, setNewSemesterTahun] = useState(new Date().getFullYear());
  const [newSemesterPeriode, setNewSemesterPeriode] = useState("Ganjil");
  
  // Search & Filter state for Jurusan/Prodi
  const [searchTerm, setSearchTerm] = useState("");
  const [activeTab, setActiveTab] = useState<"jurusan" | "prodi">("jurusan");
  
  const [isPending, startTransition] = useTransition();
  const [isSubmittingNewSem, setIsSubmittingNewSem] = useState(false);
  const [message, setMessage] = useState<{ type: "success" | "error"; text: string } | null>(null);

  const activeSemester = semesters.find(s => s.is_aktif);

  const handleSetActiveSemester = async () => {
    if (!selectedSemesterId) return;
    setMessage(null);

    startTransition(async () => {
      const result = await setActiveSemester(selectedSemesterId);
      if (result.success) {
        setMessage({ type: "success", text: result.message || "" });
        setSemesters(prev =>
          prev.map(s => ({
            ...s,
            is_aktif: s.id === selectedSemesterId,
          }))
        );
      } else {
        setMessage({ type: "error", text: result.error || "Terjadi kesalahan" });
      }
    });
  };

  const handleCreateSemester = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newSemesterName || !newSemesterTahun) return;
    setMessage(null);
    setIsSubmittingNewSem(true);

    const result = await createSemester({
      nama: newSemesterName,
      tahun: Number(newSemesterTahun),
      periode: newSemesterPeriode,
    });

    setIsSubmittingNewSem(false);

    if (result.success) {
      setMessage({ type: "success", text: result.message || "" });
      setNewSemesterName("");
      // Fetch latest list mock/reload
      const newSem: SemesterType = {
        id: Math.max(...semesters.map(s => s.id), 0) + 1,
        nama: newSemesterName,
        tahun: Number(newSemesterTahun),
        periode: newSemesterPeriode,
        is_aktif: false,
      };
      setSemesters(prev => [newSem, ...prev]);
    } else {
      setMessage({ type: "error", text: result.error || "Gagal membuat semester baru" });
    }
  };

  // Process data for prodi list tab
  const allProdis: (ProdiStat & { jurusanNama: string })[] = [];
  jurusanStats.forEach(j => {
    j.prodis.forEach(p => {
      allProdis.push({
        ...p,
        jurusanNama: j.nama || "Tidak Diketahui",
      });
    });
  });

  const filteredJurusans = jurusanStats.filter(j =>
    j.nama?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const filteredProdis = allProdis.filter(p =>
    p.nama?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    p.jurusanNama.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="w-full flex flex-col min-h-screen bg-slate-50/50 font-sans text-slate-800 pb-12 animate-in fade-in duration-300">
      
      {/* HEADER SECTION */}
      <div className="px-6 md:px-10 py-8 bg-white border-b border-slate-100 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="text-left">
          <h1 className="text-2xl font-black text-slate-900 tracking-tight mt-2">Dashboard Superadmin</h1>
          <p className="text-slate-400 text-xs font-bold uppercase tracking-wider mt-1">Konfigurasi & Pengawasan Sistem Utama</p>
        </div>
        
        {/* Active Semester Badge */}
        <div className="bg-gradient-to-r from-[#2e5299] to-[#1e3d73] text-white px-5 py-3 rounded-2xl shadow-md flex items-center gap-3 self-start sm:self-center">
          <Calendar size={20} className="text-blue-200" />
          <div className="text-left">
            <p className="text-[10px] text-blue-200 uppercase font-black tracking-widest">Semester Aktif</p>
            <p className="text-sm font-bold">{activeSemester?.nama || "Belum Ditentukan"}</p>
          </div>
        </div>
      </div>

      <div className="px-6 md:px-10 mt-8 space-y-8">
        
        {/* ALERT NOTIFICATION */}
        {message && (
          <div className={`p-4 rounded-2xl flex items-center gap-3 border shadow-sm animate-in slide-in-from-top duration-300 ${
            message.type === "success" 
              ? "bg-emerald-50 border-emerald-100 text-emerald-800" 
              : "bg-rose-50 border-rose-100 text-rose-800"
          }`}>
            {message.type === "success" ? <CheckCircle2 size={20} className="text-emerald-500 shrink-0" /> : <AlertCircle size={20} className="text-rose-500 shrink-0" />}
            <span className="text-sm font-semibold">{message.text}</span>
          </div>
        )}

        {/* METRICS CARD GRID */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6">
          
          {/* Card 1: Students */}
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:translate-y-[-4px] hover:shadow-md transition-all duration-300 group">
            <div className="w-12 h-12 bg-blue-50 text-[#2e5299] rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
              <GraduationCap size={24} />
            </div>
            <div className="text-left">
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total Mahasiswa</p>
              <p className="text-2xl font-black text-slate-900 mt-0.5">{stats.totalStudents}</p>
            </div>
          </div>

          {/* Card 2: Staff/Admin */}
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:translate-y-[-4px] hover:shadow-md transition-all duration-300 group">
            <div className="w-12 h-12 bg-indigo-50 text-indigo-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
              <Users size={24} />
            </div>
            <div className="text-left">
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total Staf (Admin)</p>
              <p className="text-2xl font-black text-slate-900 mt-0.5">{stats.totalStaff}</p>
            </div>
          </div>

          {/* Card 3: Jurusan */}
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:translate-y-[-4px] hover:shadow-md transition-all duration-300 group">
            <div className="w-12 h-12 bg-purple-50 text-purple-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
              <Building2 size={24} />
            </div>
            <div className="text-left">
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total Jurusan</p>
              <p className="text-2xl font-black text-slate-900 mt-0.5">{stats.totalJurusan}</p>
            </div>
          </div>

          {/* Card 4: Prodi */}
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:translate-y-[-4px] hover:shadow-md transition-all duration-300 group">
            <div className="w-12 h-12 bg-pink-50 text-pink-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
              <Sparkles size={24} />
            </div>
            <div className="text-left">
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total Prodi</p>
              <p className="text-2xl font-black text-slate-900 mt-0.5">{stats.totalProdi}</p>
            </div>
          </div>

          {/* Card 5: Cumulative Kompen Hours */}
          <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:translate-y-[-4px] hover:shadow-md transition-all duration-300 group">
            <div className="w-12 h-12 bg-orange-50 text-orange-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
              <Clock size={24} />
            </div>
            <div className="text-left">
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Jam Kompen Aktif</p>
              <p className="text-2xl font-black text-slate-900 mt-0.5">{stats.totalActiveKompenHours} Jam</p>
            </div>
          </div>
        </div>

        {/* WORK BENCH ROW */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          
          {/* LEFT AREA: SEMESTER MANAGEMENT PANELS */}
          <div className="lg:col-span-1 space-y-8">
            
            {/* Panel 1: Set Active Semester */}
            <div className="bg-white rounded-[2rem] border border-slate-100 shadow-sm p-8 text-left">
              <div className="flex items-center gap-3 mb-6">
                <div className="p-2 bg-[#2e5299]/10 text-[#2e5299] rounded-xl"><Calendar size={20}/></div>
                <div>
                  <h3 className="text-base font-black text-slate-900">Semester Aktif</h3>
                  <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Ganti Periode Berlaku Sistem</p>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <label className="block text-xs font-black text-slate-400 uppercase tracking-wider mb-2">Pilih Semester</label>
                  <select
                    value={selectedSemesterId}
                    onChange={(e) => setSelectedSemesterId(Number(e.target.value))}
                    className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm focus:border-[#2e5299] outline-none transition-all"
                  >
                    {semesters.map(s => (
                      <option key={s.id} value={s.id}>
                        {s.nama} {s.is_aktif ? "(Aktif Sekarang)" : ""}
                      </option>
                    ))}
                  </select>
                </div>

                <button
                  onClick={handleSetActiveSemester}
                  disabled={isPending || selectedSemesterId === activeSemester?.id}
                  className="w-full py-3.5 bg-[#2e5299] text-white font-black text-xs uppercase tracking-widest rounded-2xl shadow-md hover:bg-[#1e3d73] active:scale-95 disabled:opacity-50 transition-all"
                >
                  {isPending ? "Menyimpan..." : "Terapkan Semester Aktif"}
                </button>
              </div>
            </div>

            {/* Panel 2: Create New Semester */}
            <div className="bg-white rounded-[2rem] border border-slate-100 shadow-sm p-8 text-left">
              <div className="flex items-center gap-3 mb-6">
                <div className="p-2 bg-emerald-50 text-emerald-600 rounded-xl"><PlusCircle size={20}/></div>
                <div>
                  <h3 className="text-base font-black text-slate-900">Tambah Semester</h3>
                  <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Buat Periode Baru</p>
                </div>
              </div>

              <form onSubmit={handleCreateSemester} className="space-y-4">
                <div>
                  <label className="block text-xs font-black text-slate-400 uppercase tracking-wider mb-2">Nama Semester</label>
                  <input
                    type="text"
                    required
                    placeholder="contoh: 2026/2027 Ganjil"
                    value={newSemesterName}
                    onChange={(e) => setNewSemesterName(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm focus:border-[#2e5299] outline-none transition-all placeholder:text-slate-400"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-black text-slate-400 uppercase tracking-wider mb-2">Tahun</label>
                    <input
                      type="number"
                      required
                      value={newSemesterTahun}
                      onChange={(e) => setNewSemesterTahun(Number(e.target.value))}
                      className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm focus:border-[#2e5299] outline-none transition-all"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-black text-slate-400 uppercase tracking-wider mb-2">Periode</label>
                    <select
                      value={newSemesterPeriode}
                      onChange={(e) => setNewSemesterPeriode(e.target.value)}
                      className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm focus:border-[#2e5299] outline-none transition-all"
                    >
                      <option value="Ganjil">Ganjil</option>
                      <option value="Genap">Genap</option>
                    </select>
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={isSubmittingNewSem}
                  className="w-full py-3.5 bg-emerald-600 text-white font-black text-xs uppercase tracking-widest rounded-2xl shadow-md hover:bg-emerald-700 active:scale-95 transition-all"
                >
                  {isSubmittingNewSem ? "Membuat..." : "Simpan Semester"}
                </button>
              </form>
            </div>

          </div>

          {/* RIGHT AREA: JURUSAN & PRODI ANALYTICS AND SEARCH */}
          <div className="lg:col-span-2 space-y-8">
            <div className="bg-white rounded-[2rem] border border-slate-100 shadow-sm overflow-hidden flex flex-col h-full min-h-[500px]">
              
              {/* Tab Header Controls */}
              <div className="p-8 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div className="text-left">
                  <h3 className="text-lg font-black text-slate-900">Analitik Jurusan & Prodi</h3>
                  <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wider mt-0.5">Daftar Akumulasi Jam Kompen Akademik</p>
                </div>
                
                {/* Search Input bar */}
                <div className="relative group max-w-xs w-full">
                  <input
                    type="text"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    placeholder="Cari..."
                    className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-2xl text-xs outline-none focus:border-[#2e5299] focus:bg-white transition-all placeholder:text-slate-400"
                  />
                  <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-[#2e5299] transition-colors" />
                </div>
              </div>

              {/* Navigation Tabs */}
              <div className="px-8 border-b border-slate-50 flex gap-4">
                <button
                  onClick={() => { setActiveTab("jurusan"); setSearchTerm(""); }}
                  className={`py-4 text-xs font-black uppercase tracking-wider border-b-2 transition-all ${
                    activeTab === "jurusan" 
                      ? "border-[#2e5299] text-[#2e5299]" 
                      : "border-transparent text-slate-400 hover:text-slate-600"
                  }`}
                >
                  Jurusan ({jurusanStats.length})
                </button>
                <button
                  onClick={() => { setActiveTab("prodi"); setSearchTerm(""); }}
                  className={`py-4 text-xs font-black uppercase tracking-wider border-b-2 transition-all ${
                    activeTab === "prodi" 
                      ? "border-[#2e5299] text-[#2e5299]" 
                      : "border-transparent text-slate-400 hover:text-slate-600"
                  }`}
                >
                  Prodi ({allProdis.length})
                </button>
              </div>

              {/* Data Table Container */}
              <div className="flex-1 overflow-x-auto">
                {activeTab === "jurusan" ? (
                  /* Jurusan Table */
                  <table className="w-full text-left border-collapse">
                    <thead>
                      <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-black uppercase tracking-wider">
                        <th className="py-4 px-8">Nama Jurusan</th>
                        <th className="py-4 px-6 text-center">Jumlah Prodi</th>
                        <th className="py-4 px-6 text-center">Mahasiswa</th>
                        <th className="py-4 px-8 text-right">Jam Kompen Aktif</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-50">
                      {filteredJurusans.length > 0 ? (
                        filteredJurusans.map(j => (
                          <tr key={j.id} className="hover:bg-slate-50/30 transition-colors">
                            <td className="py-4.5 px-8 font-bold text-sm text-slate-800">{j.nama || "-"}</td>
                            <td className="py-4.5 px-6 text-center"><span className="px-2.5 py-1 bg-purple-50 text-purple-700 text-xs font-bold rounded-lg">{j.totalProdi}</span></td>
                            <td className="py-4.5 px-6 text-center"><span className="px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-bold rounded-lg">{j.totalMahasiswa} Mhs</span></td>
                            <td className="py-4.5 px-8 text-right font-black text-sm text-slate-900">{j.totalJamKompen} Jam</td>
                          </tr>
                        ))
                      ) : (
                        <tr>
                          <td colSpan={4} className="py-12 text-center text-slate-400 text-sm font-semibold">Tidak ada jurusan ditemukan</td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                ) : (
                  /* Prodi Table */
                  <table className="w-full text-left border-collapse">
                    <thead>
                      <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-black uppercase tracking-wider">
                        <th className="py-4 px-8">Program Studi</th>
                        <th className="py-4 px-6">Jurusan</th>
                        <th className="py-4 px-6 text-center">Kelas</th>
                        <th className="py-4 px-6 text-center">Mahasiswa</th>
                        <th className="py-4 px-8 text-right">Jam Kompen Aktif</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-50">
                      {filteredProdis.length > 0 ? (
                        filteredProdis.map(p => (
                          <tr key={p.id} className="hover:bg-slate-50/30 transition-colors">
                            <td className="py-4.5 px-8 font-bold text-sm text-slate-800">{p.nama || "-"}</td>
                            <td className="py-4.5 px-6 text-xs font-bold text-slate-500">{p.jurusanNama}</td>
                            <td className="py-4.5 px-6 text-center"><span className="px-2.5 py-1 bg-purple-50 text-purple-700 text-xs font-bold rounded-lg">{p.totalKelas}</span></td>
                            <td className="py-4.5 px-6 text-center"><span className="px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-bold rounded-lg">{p.totalMahasiswa} Mhs</span></td>
                            <td className="py-4.5 px-8 text-right font-black text-sm text-slate-900">{p.totalJamKompen} Jam</td>
                          </tr>
                        ))
                      ) : (
                        <tr>
                          <td colSpan={5} className="py-12 text-center text-slate-400 text-sm font-semibold">Tidak ada program studi ditemukan</td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                )}
              </div>

            </div>
          </div>

        </div>

      </div>

    </div>
  );
}
