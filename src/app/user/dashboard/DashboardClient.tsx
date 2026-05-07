'use client'

import UserHeader from '@/components/UserHeader'
import { AlertCircle, Calendar } from 'lucide-react'

interface DashboardClientProps {
  namaMahasiswa: string
  sisaJam: number
  totalJamSelesai: number
  totalJamWajib: number
  activeSemester?: {
    id: number
    nama: string
    tahun?: number
    periode?: string
    mulai?: Date | null
    selesai?: Date | null
  } | null
}

export default function DashboardClient({
  namaMahasiswa,
  sisaJam,
  totalJamSelesai,
  totalJamWajib,
  activeSemester,
}: DashboardClientProps) {
  const isActiveSemesterEmpty = !activeSemester || !activeSemester.nama

  const calculateDaysRemaining = () => {
    if (!activeSemester?.selesai) return null
    const now = new Date()
    const endDate = new Date(activeSemester.selesai)
    const daysRemaining = Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
    return daysRemaining > 0 ? daysRemaining : 0
  }

  const daysRemaining = calculateDaysRemaining()

  return (
    <>
      <UserHeader nama={namaMahasiswa} role="mahasiswa" />

      <div className="p-10 max-w-6xl">
        {/* Semester Status Card - Prominent */}
        {isActiveSemesterEmpty ? (
          <div className="mb-8 p-6 bg-red-50 border border-red-200 rounded-2xl flex items-center gap-4">
            <AlertCircle className="text-red-600 w-6 h-6 shrink-0" />
            <div>
              <h3 className="font-bold text-red-800 text-sm">Tidak Ada Semester Aktif</h3>
              <p className="text-red-600 text-xs mt-1">Silakan hubungi admin untuk mengatur semester aktif terlebih dahulu.</p>
            </div>
          </div>
        ) : (
          <div className="mb-8 p-6 bg-blue-50 border border-blue-200 rounded-2xl">
            <div className="flex items-start justify-between">
              <div className="flex items-start gap-3">
                <Calendar className="text-[#2e5299] w-5 h-5 shrink-0 mt-0.5" />
                <div>
                  <p className="text-[#2e5299] font-bold text-sm uppercase tracking-wider mb-1">Semester Berjalan</p>
                  <div className="flex gap-4 flex-col md:flex-row md:items-center">
                    <h2 className="text-lg font-bold text-slate-800">{activeSemester.nama}</h2>
                    {activeSemester.tahun && (
                      <span className="text-sm font-medium text-slate-600">Tahun: {activeSemester.tahun}</span>
                    )}
                  </div>
                </div>
              </div>
              {daysRemaining !== null && (
                <div className="text-right">
                  <p className="text-[#2e5299] font-bold text-2xl">{daysRemaining}</p>
                  <p className="text-slate-500 text-xs font-medium">Hari Tersisa</p>
                </div>
              )}
            </div>
          </div>
        )}

        <div className="mb-8">
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Selamat Datang, {namaMahasiswa.split(' ')[0]}</h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">Berikut ringkasan aktivitas kompensasi anda</p>
        </div>

        <div className="grid grid-cols-3 gap-6 mb-8">
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
