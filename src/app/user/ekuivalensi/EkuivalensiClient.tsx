'use client'

import UserHeader from '@/components/UserHeader'

interface EkuivalensiData {
  id: number | string
  penanggung_jawab_nim: string
  mahasiswa?: { nama: string }
  jam_diakui: number
}

interface EkuivalensiClientProps {
  namaMahasiswa: string
  ekuivalensi: EkuivalensiData[]
}

export default function EkuivalensiClient({
  namaMahasiswa,
  ekuivalensi,
}: EkuivalensiClientProps) {
  return (
    <>
      <UserHeader nama={namaMahasiswa} role="mahasiswa" />

      <div className="p-10 max-w-6xl">
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Ekuivalensi</h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">
            Verifikasi pengajuan iuran kolektif
          </p>
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
              {ekuivalensi.length > 0 ? (
                ekuivalensi.map((item) => (
                  <tr key={item.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item.penanggung_jawab_nim}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item.mahasiswa?.nama}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-blue-600">{item.jam_diakui} Jam</td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={3} className="px-6 py-8 text-center text-sm text-slate-400">
                    Tidak ada data ekuivalensi
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </>
  )
}
