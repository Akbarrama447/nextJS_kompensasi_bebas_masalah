"use client";

import { FileText, CheckCircle, AlertTriangle } from "lucide-react";

export default function TabRiwayat() {
    return (
        <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-6" suppressHydrationWarning>
            <div className="flex justify-between items-center mb-6">
                <h2 className="text-lg font-bold text-gray-900">Riwayat Import Berkas</h2>
                <button className="text-[var(--color-primary)] font-medium text-sm hover:underline focus:outline-none">
                    Refresh Riwayat
                </button>
            </div>

            <div className="border border-gray-200 rounded-lg overflow-hidden mb-6">
                <table className="w-full text-sm text-left">
                    <thead className="bg-gray-50 text-gray-600 text-xs uppercase font-medium">
                        <tr className="border-b border-gray-200">
                            <th className="px-4 py-3">BERKAS / SEMESTER</th>
                            <th className="px-4 py-3 text-center">WAKTU</th>
                            <th className="px-4 py-3 text-center">BARIS</th>
                            <th className="px-4 py-3 text-center">SUKSES</th>
                            <th className="px-4 py-3 text-center">STATUS</th>
                            <th className="px-4 py-3 text-center">DETAIL</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        <tr className="hover:bg-gray-50/50 transition-colors">
                            <td className="px-4 py-4">
                                <div className="flex items-center gap-3">
                                    <div className="p-2 bg-gray-100 rounded-lg border border-gray-200">
                                        <FileText className="w-5 h-5 text-gray-500" />
                                    </div>
                                    <div>
                                        <p className="font-medium text-gray-800">kompen-mhs-IK-1A.xl...</p>
                                        <p className="text-xs text-gray-500 mt-0.5">Semester: 20251</p>
                                    </div>
                                </div>
                            </td>
                            <td className="px-4 py-3 text-center text-gray-600 font-medium">12 April 2026 pukul 15.67</td>
                            <td className="px-4 py-3 text-center text-gray-600">54</td>
                            <td className="px-4 py-3 text-center text-gray-600">54</td>
                            <td className="px-4 py-3 text-center">
                                <span className="inline-flex items-center px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-medium border border-green-200/60">
                                    Selesai
                                </span>
                            </td>
                            <td className="px-4 py-3 text-center">
                                <button className="text-gray-400 hover:text-gray-600 transition-colors focus:outline-none">
                                    <CheckCircle className="w-5 h-5 mx-auto" />
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div className="flex items-start gap-3 p-4 bg-yellow-50/80 border border-yellow-200/80 text-yellow-800 rounded-xl text-sm">
                <AlertTriangle className="w-5 h-5 shrink-0 text-yellow-600 mt-0.5" />
                <p className="leading-relaxed">
                    Log riwayat ini hanya menampilkan berkas yang Anda import sendiri. Superadmin dapat melihat riwayat import dari seluruh staf melalui menu Manajemen Data.
                </p>
            </div>
        </div>
    );
}