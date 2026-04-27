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
    <div>
      <h1 className="text-2xl font-bold text-gray-900 mb-6">Ekuivalensi</h1>

      <div className="flex gap-2 mb-6">
        <span className="px-4 py-2 font-bold text-sm text-gray-900 bg-gray-100 rounded-lg">
          Verifikasi pengajuan iuran kolektif dari penanggung jawab kelas
        </span>
      </div>

      <div className="bg-white rounded-lg shadow overflow-hidden border border-gray-300">
        <table className="min-w-full divide-y divide-gray-400">
          <thead className="bg-gray-100">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                NIM
              </th>
              <th className="px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                Nama
              </th>
              <th className="px-6 py-3 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
                Jam
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-400">
            {ekuivalensi.map((item) => (
              <tr key={item.id}>
                <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                  {item.penanggung_jawab_nim}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                  {item.mahasiswa?.nama}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                  {item.jam_diakui} Jam
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}