import Sidebar from '@/components/Sidebar'
import SidebarLayout from '@/components/SidebarLayout'
import UserHeader from '@/components/UserHeader'
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
    <SidebarLayout
      sidebar={<Sidebar role="mahasiswa" activePath="/user/dashboard" />}
    >
      <main className="flex-1 flex flex-col">
        <UserHeader nama={namaMahasiswa} role="mahasiswa" />

        <div className="p-4 sm:p-6 lg:p-10 max-w-6xl mx-auto w-full">
          <div className="mb-6 sm:mb-8">
            <h2 className="text-xl sm:text-2xl font-bold text-slate-800 mb-0.5">Selamat Datang, {namaMahasiswa.split(' ')[0]}</h2>
            <p className="text-xs sm:text-sm text-[#2e5299] font-medium opacity-80">Berikut ringkasan aktivitas kompensasi anda</p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 mb-6 sm:mb-8">
            <div className="bg-white p-4 sm:p-6 rounded-2xl shadow-sm border border-slate-100">
              <p className="text-[#2e5299] font-semibold text-xs mb-3">Sisa Jam Kompen</p>
              <div className="flex items-baseline gap-1">
                <span className="text-2xl sm:text-3xl font-bold text-slate-800">0</span>
                <span className="text-sm font-medium text-slate-500">Jam</span>
              </div>
            </div>

            <div className="bg-white p-4 sm:p-6 rounded-2xl shadow-sm border border-slate-100">
              <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Selesai</p>
              <div className="flex items-baseline gap-1">
                <span className="text-2xl sm:text-3xl font-bold text-slate-800">0</span>
                <span className="text-sm font-medium text-slate-500">Jam</span>
              </div>
            </div>

            <div className="bg-white p-4 sm:p-6 rounded-2xl shadow-sm border border-slate-100 sm:col-span-2 lg:col-span-1">
              <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Wajib</p>
              <div className="flex items-baseline gap-1">
                <span className="text-2xl sm:text-3xl font-bold text-slate-800">0</span>
                <span className="text-sm font-medium text-slate-500">Jam</span>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-6">
            <div className="bg-white p-5 sm:p-7 rounded-2xl shadow-sm border border-slate-100 hover:border-[#2e5299]/30 transition-all cursor-pointer group">
              <h3 className="text-[#2e5299] font-bold text-base sm:text-lg mb-1 group-hover:text-blue-700">Cek Pekerjaan</h3>
              <p className="text-slate-400 text-xs font-medium">Cek Daftar Pekerjaan Kompensasi</p>
            </div>

            <div className="bg-white p-5 sm:p-7 rounded-2xl shadow-sm border border-slate-100 hover:border-[#2e5299]/30 transition-all cursor-pointer group">
              <h3 className="text-[#2e5299] font-bold text-base sm:text-lg mb-1 group-hover:text-blue-700">Cek Ekuivalen</h3>
              <p className="text-slate-400 text-xs font-medium">Cek Ekuivalen Kelas</p>
            </div>
          </div>
        </div>
      </main>
    </SidebarLayout>
  )
}