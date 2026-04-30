import Sidebar from '@/components/Sidebar'
import SidebarLayout from '@/components/SidebarLayout'
import UserHeader from '@/components/UserHeader'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'

export default async function EkuivalensiPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value

  const ekuivalensi = nim 
    ? await prisma.ekuivalensi_kelas.findMany({
        where: { penanggung_jawab_nim: nim },
        include: { mahasiswa: true },
      })
    : []

  return (
    <SidebarLayout
      sidebar={<Sidebar role="mahasiswa" activePath="/user/ekuivalensi" />}
    >
      <main className="flex-1 flex flex-col">
        <UserHeader nama={ekuivalensi[0]?.mahasiswa?.nama || 'Mahasiswa'} role="mahasiswa" />

        <div className="p-4 sm:p-6 lg:p-10 max-w-6xl mx-auto w-full">
          <div className="mb-6 sm:mb-8">
            <h2 className="text-xl sm:text-2xl font-bold text-slate-800 mb-0.5">Ekuivalensi</h2>
            <p className="text-xs sm:text-sm text-[#2e5299] font-medium opacity-80">Verifikasi pengajuan iuran kolektif dari penanggung jawab kelas</p>
          </div>

          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-400">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="px-4 sm:px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">NIM</th>
                    <th className="px-4 sm:px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Nama</th>
                    <th className="px-4 sm:px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Jam</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-400">
                  {ekuivalensi.map((item) => (
                    <tr key={item.id}>
                      <td className="px-4 sm:px-6 py-3 sm:py-4 whitespace-nowrap text-xs sm:text-sm font-bold text-gray-900">{item.penanggung_jawab_nim}</td>
                      <td className="px-4 sm:px-6 py-3 sm:py-4 whitespace-nowrap text-xs sm:text-sm font-bold text-gray-900">{item.mahasiswa?.nama}</td>
                      <td className="px-4 sm:px-6 py-3 sm:py-4 whitespace-nowrap text-xs sm:text-sm font-bold text-gray-900">{item.jam_diakui} Jam</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
    </SidebarLayout>
  )
}