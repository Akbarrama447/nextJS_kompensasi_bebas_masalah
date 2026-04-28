import Sidebar from '@/components/Sidebar'
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
    <Sidebar role="mahasiswa" activePath="/user/ekuivalensi">
      <main className="flex-1 flex flex-col">
        <header className="bg-white h-16 px-10 flex items-center justify-between border-b border-slate-200">
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
              <span className="text-sm font-bold text-slate-700">{ekuivalensi[0]?.mahasiswa?.nama || 'Mahasiswa'}</span>
              <span className="text-[11px] text-[#2e5299] font-bold">Mahasiswa</span>
            </div>
            <div className="w-9 h-9 rounded-full bg-slate-100 border border-slate-200 shadow-sm"></div>
          </div>
        </header>

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