'use client'

import UserHeader from '@/components/UserHeader'

// Tambahkan tugasAktif di sini
interface DashboardClientProps {
  namaMahasiswa: string
  sisaJam: number
  totalJamSelesai: number
  totalJamWajib: number
  tugasAktif: number // <-- Tambahan
}

export default function DashboardClient({
  namaMahasiswa,
  sisaJam,
  totalJamSelesai,
  totalJamWajib,
  tugasAktif, // <-- Tambahan
}: DashboardClientProps) {
  return (
    <>
      <UserHeader nama={namaMahasiswa} role="mahasiswa" />

      <div className="p-10 max-w-6xl">
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Selamat Datang, {namaMahasiswa.split(' ')[0]}</h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">Berikut ringkasan aktivitas kompensasi anda</p>
        </div>

        {/* --- KOTAK-KOTAK ANGKA DI ATAS --- */}
        <div className="grid grid-cols-4 gap-6 mb-8"> {/* Ubah grid-cols-3 jadi grid-cols-4 jika ingin menjejerkannya */}
          
          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Tugas Aktif</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{tugasAktif}</span> {/* <-- Tampilkan di sini */}
              <span className="text-sm font-medium text-slate-500">Tugas</span>
            </div>
          </div>

          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Sisa Jam Kompen</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{sisaJam}</span>
              <span className="text-sm font-medium text-slate-500">Jam</span>
            </div>
          </div>

          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Selesai</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{totalJamSelesai}</span>
              <span className="text-sm font-medium text-slate-500">Jam</span>
            </div>
          </div>

          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Wajib</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{totalJamWajib}</span>
              <span className="text-sm font-medium text-slate-500">Jam</span>
            </div>
          </div>

        </div>

        {/* --- MENU CEK PEKERJAAN --- */}
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
    </>
  )
}