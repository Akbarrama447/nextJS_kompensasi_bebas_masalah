import Sidebar from '@/components/Sidebar'
import UserHeader from '@/components/UserHeader'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'

export default async function EkuivalensiPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value || '2372001'

  let ekuivalensi: any[] = []
  let namaMahasiswa = 'Mahasiswa Demo'
  
  try {
    ekuivalensi = nim 
      ? await prisma.ekuivalensi_kelas.findMany({
          where: { penanggung_jawab_nim: nim },
          include: { mahasiswa: true },
        })
      : []
    namaMahasiswa = ekuivalensi[0]?.mahasiswa?.nama || 'Mahasiswa Demo'
  } catch {
    namaMahasiswa = 'Mahasiswa Demo'
    ekuivalensi = [
      {
        id: 1,
        penanggung_jawab_nim: nim,
        mahasiswa: { nama: 'Mahasiswa Demo' },
        jam_diakui: 10,
      }
    ]
  }

  return (
    <Sidebar role="mahasiswa" activePath="/user/ekuivalensi">
      <main className="flex-1 flex flex-col">
        <UserHeader nama={namaMahasiswa} role="mahasiswa" />

        <div className="p-10 max-w-6xl">
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Ekuivalensi</h2>
            <p className="text-sm text-[#2e5299] font-medium opacity-80">Verifikasi pengajuan iuran kolektif dari penanggung jawab kelas</p>
          </div>

          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
            <table className="min-w-full divide-y divide-gray-400">
              <thead className="bg-slate-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">NIM</th>
                  <th className="px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Nama</th>
                  <th className="px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">Jam</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-400">
                {ekuivalensi.map((item) => (
                  <tr key={item.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item.penanggung_jawab_nim}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item.mahasiswa?.nama}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item.jam_diakui} Jam</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </Sidebar>
  )
}