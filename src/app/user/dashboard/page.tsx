import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'

export default async function DashboardMahasiswa() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value || ''

  const mahasiswa = await prisma.mahasiswa.findUnique({
    where: { nim },
    include: { user: true }
  })

  const namaMahasiswa = mahasiswa?.nama || 'Mahasiswa'
  
  return (
    <Sidebar role="mahasiswa" activePath="/user/dashboard">
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
              <span className="text-sm font-bold text-slate-700">{namaMahasiswa}</span>
              <span className="text-[11px] text-[#2e5299] font-bold">Mahasiswa</span>
            </div>
            <div className="w-9 h-9 rounded-full bg-slate-100 border border-slate-200 shadow-sm"></div>
          </div>
        </header>

        {/* Content Section */}
        <div className="p-10 max-w-6xl">
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Selamat Datang, {namaMahasiswa.split(' ')[0]}</h2>
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
    </Sidebar>
  )
}