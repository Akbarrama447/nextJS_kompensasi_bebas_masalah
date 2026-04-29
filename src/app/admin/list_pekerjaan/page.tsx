import Sidebar from '@/components/Sidebar'
import UserHeader from '@/components/UserHeader'

export default function AdminListPekerjaan() {
  return (
    <Sidebar role="admin" activePath="/admin/list_pekerjaan">
      <main className="flex-1 flex flex-col">
        <UserHeader nama="Admin Demo" role="admin" />

        <div className="p-6 bg-[#f1f5f9] min-h-screen">
          {/* Header */}
          <div className="mb-4">
            <h1 className="text-xl font-semibold text-gray-800">
              Kelola Pekerjaan & Penugasan
            </h1>
            <p className="text-sm text-gray-500">
              Atur daftar pekerjaan Anda dan verifikasi penyelesaian mahasiswa
            </p>
          </div>

          {/* Tabs + Actions */}
          <div className="flex justify-between items-center mb-4">
            {/* Tabs */}
            <div className="flex gap-2">
              <button className="px-4 py-2 text-sm bg-blue-100 text-blue-600 rounded-md font-medium">
                Kelola
              </button>
              <button className="px-4 py-2 text-sm bg-white border rounded-md text-gray-600">
                Penugasan
              </button>
              <button className="px-4 py-2 text-sm bg-white border rounded-md text-gray-600">
                Riwayat
              </button>
            </div>

            {/* Actions */}
            <div className="flex gap-2">
              <button className="px-3 py-2 text-sm border rounded-md bg-white">
                Import Excel
              </button>
              <button className="px-3 py-2 text-sm border rounded-md bg-white">
                Generate Plotting
              </button>
              <button className="px-3 py-2 text-sm bg-blue-600 text-white rounded-md">
                + Tambah Manual
              </button>
            </div>
          </div>

          {/* Filter */}
          <div className="mb-4">
            <button className="px-4 py-2 text-sm bg-white border rounded-md">
              Aktif Anda
            </button>
          </div>

          {/* Table */}
          <div className="bg-white rounded-xl border overflow-hidden">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-600">
                <tr>
                  <th className="text-left px-4 py-3">PEKERJAAN</th>
                  <th className="text-left px-4 py-3">TIPE</th>
                  <th className="text-left px-4 py-3">POIN</th>
                  <th className="text-left px-4 py-3">KUOTA SISA</th>
                  <th className="text-left px-4 py-3">TANGGAL SELESAI</th>
                  <th className="text-left px-4 py-3">STATUS</th>
                  <th className="text-left px-4 py-3">AKSI</th>
                </tr>
              </thead>

              <tbody>
                {/* Row 1 */}
                <tr className="border-t">
                  <td className="px-4 py-3">Benerin PC</td>
                  <td className="px-4 py-3">
                    <span className="px-2 py-1 text-xs bg-blue-100 text-blue-600 rounded-full">
                      Internal
                    </span>
                  </td>
                  <td className="px-4 py-3">2 jam</td>
                  <td className="px-4 py-3">0/10</td>
                  <td className="px-4 py-3">12 April 2026</td>
                  <td className="px-4 py-3">
                    <span className="px-3 py-1 text-xs bg-blue-500 text-white rounded-full">
                      Aktif
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-400">•••</td>
                </tr>

                {/* Row 2 */}
                <tr className="border-t">
                  <td className="px-4 py-3">Benerin PC</td>
                  <td className="px-4 py-3">
                    <span className="px-2 py-1 text-xs bg-blue-100 text-blue-600 rounded-full">
                      Internal
                    </span>
                  </td>
                  <td className="px-4 py-3">6 jam</td>
                  <td className="px-4 py-3">0/10</td>
                  <td className="px-4 py-3">12 April 2026</td>
                  <td className="px-4 py-3">
                    <span className="px-3 py-1 text-xs bg-blue-500 text-white rounded-full">
                      Aktif
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-400">•••</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </Sidebar>
  )
}
