'use client'

import UserHeader from '@/components/UserHeader'

interface StatusCount {
  id: number
  nama: string
  count: number
}

interface DashboardAdminClientProps {
  namaAdmin: string
  pekerjaanAktif: number
  statusCounts: StatusCount[]
}

export default function DashboardAdminClient({
  namaAdmin,
  pekerjaanAktif,
  statusCounts,
}: DashboardAdminClientProps) {
  return (
    <>
      <UserHeader nama={namaAdmin} role="admin" />

      <div className="p-10 max-w-6xl">
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Selamat Datang, {namaAdmin.split(' ')[0]}</h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">Berikut ringkasan aktivitas kompensasi</p>
        </div>

        <div className="grid grid-cols-2 gap-6 mb-8">
          <div className="bg-white p-7 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Pekerjaan Aktif</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{pekerjaanAktif}</span>
              <span className="text-sm font-medium text-slate-500">Pekerjaan</span>
            </div>
          </div>

          <div className="bg-white p-7 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Penugasan</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">
                {statusCounts.reduce((sum, s) => sum + s.count, 0)}
              </span>
              <span className="text-sm font-medium text-slate-500">Tugas</span>
            </div>
          </div>
        </div>

        <h3 className="text-lg font-bold text-slate-700 mb-4">Status Penugasan</h3>
        <div className="grid grid-cols-2 gap-4">
          {statusCounts.map((status) => (
            <div key={status.id} className="bg-white p-5 rounded-xl shadow-sm border border-slate-100">
              <p className="text-slate-500 font-medium text-xs mb-2">{status.nama}</p>
              <div className="flex items-baseline gap-1">
                <span className="text-2xl font-bold text-slate-800">{status.count}</span>
                <span className="text-xs font-medium text-slate-400">Tugas</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  )
}