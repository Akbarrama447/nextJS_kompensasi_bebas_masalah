"use client";

export default function TabPenugasan() {
    return (
        <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-4">
            {/* Search + Filter */}
            <div className="flex gap-3 mb-4">
                <input
                    placeholder="Cari NIM, Nama Mahasiswa..."
                    className="flex-1 px-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all placeholder-gray-400"
                />

                <div className="flex border border-gray-200 rounded-lg overflow-hidden divide-x divide-gray-200 shadow-sm">
                    <button className="px-4 py-2 bg-blue-50 text-blue-600 font-medium text-sm hover:bg-blue-100 transition-colors">
                        Pending
                    </button>
                    <button className="px-4 py-2 text-sm text-gray-600 bg-white hover:bg-gray-50 transition-colors">
                        Selesai
                    </button>
                    <button className="px-4 py-2 text-sm text-gray-600 bg-white hover:bg-gray-50 transition-colors">
                        Semua
                    </button>
                </div>
            </div>

            {/* Table */}
            <div className="border border-gray-200 rounded-lg overflow-hidden">
                <table className="w-full text-sm text-left">
                    <thead className="bg-gray-50 text-gray-600 text-xs uppercase font-medium">
                        <tr className="border-b border-gray-200">
                            <th className="px-4 py-3">Mahasiswa</th>
                            <th className="px-4 py-3">Pekerjaan</th>
                            <th className="px-4 py-3 text-center">Jam</th>
                            <th className="px-4 py-3 text-center">Update</th>
                            <th className="px-4 py-3 text-center">Status</th>
                            <th className="px-4 py-3 text-center">Aksi</th>
                        </tr>
                    </thead>

                    <tbody className="divide-y divide-gray-100">
                        {[1, 2, 3, 4].map((_, i) => (
                            <tr key={i} className="hover:bg-gray-50/50 transition-colors">
                                <td className="px-4 py-3">
                                    <p className="font-medium text-gray-800">FAREL DEKA</p>
                                    <p className="text-xs text-blue-600 mt-0.5">3.34.xxx IK-1B</p>
                                </td>
                                <td className="px-4 py-3 text-gray-600">Benarkan PC</td>
                                <td className="px-4 py-3 text-center text-gray-600">8j</td>
                                <td className="px-4 py-3 text-center text-gray-600">19 April 2026</td>
                                <td className="px-4 py-3 text-center">
                                    <span className="px-2.5 py-1 bg-yellow-50 text-yellow-600 border border-yellow-200 rounded-md text-xs font-medium">Proses</span>
                                </td>
                                <td className="px-4 py-3 text-center">
                                    <button className="text-green-600 hover:text-green-700 bg-green-50 hover:bg-green-100 px-2 py-1 rounded-md text-xs transition-colors border border-green-100" title="Terima">
                                        ✔
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}