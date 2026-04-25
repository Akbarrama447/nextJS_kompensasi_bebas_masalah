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
        <button className="px-4 py-2 border border-green-600 text-green-600 rounded-lg hover:bg-green-50 font-medium">
          + Ajukan Pelunasan Kompensasi
        </button>
      </div>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                NIM
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Nama
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Jam
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {ekuivalensi.map((item) => (
              <tr key={item.id}>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {item.penanggung_jawab_nim}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {item.mahasiswa?.nama}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
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