export default function DashboardMahasiswa() {
  return (
    // Background utama menggunakan warna Slate terang agar menyatu dengan patahan menu
    <div className="flex min-h-screen bg-[#f1f5f9] font-sans antialiased text-slate-900">
      
      {/* ================= SIDEBAR ================= */}
      <aside className="w-64 bg-[#2e5299] text-white flex flex-col shadow-lg">
        {/* Logo Section */}
        <div className="flex items-center gap-2.5 p-6 mb-2">
          <div className="bg-white p-1 rounded-md shadow-sm">
            <svg className="w-6 h-6 text-[#2e5299]" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
            </svg>
          </div>
          <div className="flex flex-col">
            <span className="text-base font-semibold leading-none">Sistem</span>
            <span className="text-base font-semibold leading-tight">Kompen</span>
          </div>
        </div>

        {/* Navigation Menu */}
        <nav className="flex-1">
          {/* Dashboard - Menu Aktif */}
          <div className="flex items-center gap-3 bg-[#f1f5f9] text-[#2e5299] ml-4 py-2.5 px-5 rounded-l-full mb-1">
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
            </svg>
            <span className="font-semibold text-[14px]">Dashboard</span>
          </div>

          {/* List Pekerjaan */}
          <div className="flex items-center gap-3 px-9 py-3 text-white/80 hover:text-white transition-colors cursor-pointer">
            <svg className="w-5 h-5 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 10h16M4 14h16M4 18h16" />
            </svg>
            <span className="font-medium text-[14px]">List Pekerjaan</span>
          </div>

          {/* Ekuivalen */}
          <div className="flex items-center gap-3 px-9 py-3 text-white/80 hover:text-white transition-colors cursor-pointer">
            <svg className="w-5 h-5 opacity-80" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
            <span className="font-medium text-[14px]">Ekuivalen</span>
          </div>
        </nav>

        {/* User Footer Sidebar */}
        <div className="p-6 border-t border-white/10">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-9 h-9 rounded-full bg-white/20 border border-white/20"></div>
            <div className="flex flex-col">
              <span className="text-sm font-semibold text-white">Joko Widodo</span>
              <span className="text-[11px] text-white/60">Mahasiswa</span>
            </div>
          </div>
          <button className="flex items-center gap-2 text-white/60 hover:text-white text-xs font-medium transition-colors">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            Keluar
          </button>
        </div>
      </aside>

      {/* ================= MAIN CONTENT ================= */}
      <main className="flex-1 flex flex-col">
        {/* Navbar */}
        <header className="bg-white h-16 px-10 flex items-center justify-between border-b border-slate-200">
          
          {/* SEARCH BAR */}
          <div className="relative w-80 group">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg className="w-4 h-4 text-slate-400 group-focus-within:text-[#2e5299] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <input 
              type="text" 
              placeholder="cari sesuatu..." 
              className="w-full bg-slate-50 border border-slate-200 text-sm text-slate-600 rounded-lg pl-10 pr-4 py-2 outline-none focus:ring-1 focus:ring-[#2e5299]/30 focus:border-[#2e5299]/50 transition-all placeholder:text-slate-400"
            />
          </div>

          <div className="flex items-center gap-3">
            <div className="flex flex-col text-right">
              <span className="text-sm font-bold text-slate-700">Joko Widodo</span>
              <span className="text-[11px] text-[#2e5299] font-bold">Mahasiswa</span>
            </div>
            <div className="w-9 h-9 rounded-full bg-slate-100 border border-slate-200 shadow-sm"></div>
          </div>
        </header>

        {/* Content Section */}
        <div className="p-10 max-w-6xl">
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Selamat Datang, Joko</h2>
            <p className="text-sm text-[#2e5299] font-medium opacity-80">Berikut ringkasan aktivitas kompensasi anda</p>
          </div>

          {/* Grid Statistik */}
          <div className="grid grid-cols-3 gap-6 mb-8">
            <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
              <p className="text-[#2e5299] font-semibold text-xs mb-3">Sisa Jam Kompen</p>
              <div className="flex items-baseline gap-1">
                <span className="text-3xl font-bold text-slate-800">0</span>
                <span className="text-sm font-medium text-slate-500">Jam</span>
              </div>
            </div>

            <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
              <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Selesai</p>
              <div className="flex items-baseline gap-1">
                <span className="text-3xl font-bold text-slate-800">0</span>
                <span className="text-sm font-medium text-slate-500">Jam</span>
              </div>
            </div>

            <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
              <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Wajib</p>
              <div className="flex items-baseline gap-1">
                <span className="text-3xl font-bold text-slate-800">0</span>
                <span className="text-sm font-medium text-slate-500">Jam</span>
              </div>
            </div>
          </div>

          {/* Action Cards */}
          <div className="grid grid-cols-2 gap-6">
            <div className="bg-white p-7 rounded-2xl shadow-sm border border-slate-100 hover:border-[#2e5299]/30 transition-all cursor-pointer group">
              <h3 className="text-[#2e5299] font-bold text-lg mb-1 group-hover:text-blue-700">Cek Pekerjaan</h3>
              <p className="text-slate-400 text-xs font-medium">Cek Daftar Pekerjaan Kompensasi</p>
            </div>

            <div className="bg-white p-7 rounded-2xl shadow-sm border border-slate-100 hover:border-[#2e5299]/30 transition-all cursor-pointer group">
              <h3 className="text-[#2e5299] font-bold text-lg mb-1 group-hover:text-blue-700">Cek Ekuivalen</h3>
              <p className="text-slate-400 text-xs font-medium">Cek Ekuivalen Kelas</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}