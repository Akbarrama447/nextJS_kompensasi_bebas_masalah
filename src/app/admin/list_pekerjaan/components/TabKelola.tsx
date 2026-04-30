"use client";

import { EyeOff, Plus, X } from "lucide-react";
import { useState } from "react";

interface PekerjaanData {
    id: number;
    pekerjaan: string;
    tipe: "Internal" | "Eksternal";
    poin: number;
    kuotaSisa: number;
    kuotaTotal: number;
    tanggalSelesai: string;
    status: "Aktif" | "Nonaktif";
}

export default function TabKelola() {
    // Dummy Data - Siap disambung ke DB
    const [dataPekerjaan, setDataPekerjaan] = useState<PekerjaanData[]>([
        {
            id: 1,
            pekerjaan: "Benerin PC",
            tipe: "Internal",
            poin: 2,
            kuotaSisa: 0,
            kuotaTotal: 10,
            tanggalSelesai: "2026-04-12",
            status: "Aktif",
        },
        {
            id: 2,
            pekerjaan: "Input Data Alumni",
            tipe: "Eksternal",
            poin: 6,
            kuotaSisa: 2,
            kuotaTotal: 10,
            tanggalSelesai: "2026-04-15",
            status: "Aktif",
        }
    ]);

    const [isModalOpen, setIsModalOpen] = useState(false);

    // Form State
    const [formData, setFormData] = useState({
        pekerjaan: "",
        tipe: "Internal" as "Internal" | "Eksternal",
        poin: "",
        kuotaTotal: "",
        tanggalSelesai: "",
    });

    const handleOpenModal = () => setIsModalOpen(true);
    const handleCloseModal = () => {
        setIsModalOpen(false);
        setFormData({
            pekerjaan: "",
            tipe: "Internal",
            poin: "",
            kuotaTotal: "",
            tanggalSelesai: "",
        });
    };

    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        
        const newItem: PekerjaanData = {
            id: Date.now(),
            pekerjaan: formData.pekerjaan,
            tipe: formData.tipe,
            poin: parseInt(formData.poin) || 0,
            kuotaSisa: parseInt(formData.kuotaTotal) || 0, // initially sisa == total
            kuotaTotal: parseInt(formData.kuotaTotal) || 0,
            tanggalSelesai: formData.tanggalSelesai,
            status: "Aktif",
        };

        setDataPekerjaan([newItem, ...dataPekerjaan]);
        handleCloseModal();
    };

    // Format YYYY-MM-DD ke DD MMMM YYYY
    const formatDate = (dateString: string) => {
        if (!dateString) return "-";
        const date = new Date(dateString);
        return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
    };

    return (
        <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-4">
            {/* Action Bar */}
            <div className="flex justify-end items-center mb-4">
                <div className="flex gap-3">
                    <button className="px-4 py-2 border border-gray-200 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-50 transition-colors bg-white shadow-sm focus:outline-none">
                        Generate Plotting
                    </button>
                    <button 
                        onClick={handleOpenModal}
                        className="flex items-center gap-1.5 px-4 py-2 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity shadow-sm focus:outline-none"
                    >
                        <Plus className="w-4 h-4" />
                        Tambah Manual
                    </button>
                </div>
            </div>

            {/* Table */}
            <div className="border border-gray-200 rounded-lg overflow-hidden">
                <table className="w-full text-sm text-left">
                    <thead className="bg-gray-50 text-gray-600 text-xs uppercase font-medium">
                        <tr className="border-b border-gray-200">
                            <th className="px-4 py-3">Pekerjaan</th>
                            <th className="px-4 py-3 text-center">Tipe</th>
                            <th className="px-4 py-3 text-center">Poin</th>
                            <th className="px-4 py-3 text-center">Kuota Sisa</th>
                            <th className="px-4 py-3 text-center">Tanggal Selesai</th>
                            <th className="px-4 py-3 text-center">Status</th>
                            <th className="px-4 py-3 text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        {dataPekerjaan.map((item) => (
                            <tr key={item.id} className="hover:bg-gray-50/50 transition-colors">
                                <td className="px-4 py-3 text-gray-800 font-medium">{item.pekerjaan}</td>
                                <td className="px-4 py-3 text-center">
                                    <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium text-white ${item.tipe === 'Internal' ? 'bg-[var(--color-primary)]' : 'bg-orange-500'}`}>
                                        {item.tipe}
                                    </span>
                                </td>
                                <td className="px-4 py-3 text-gray-600 text-center">{item.poin} jam</td>
                                <td className="px-4 py-3 text-gray-600 text-center">{item.kuotaSisa}/{item.kuotaTotal}</td>
                                <td className="px-4 py-3 text-gray-600 text-center">{formatDate(item.tanggalSelesai)}</td>
                                <td className="px-4 py-3 text-center">
                                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 bg-[var(--color-primary)] text-white rounded-full text-xs font-medium">
                                        {item.status}
                                        <span className="w-1.5 h-1.5 bg-white rounded-full"></span>
                                    </span>
                                </td>
                                <td className="px-4 py-3 text-center">
                                    <button className="text-gray-400 hover:text-gray-600 transition-colors focus:outline-none">
                                        <EyeOff className="w-4 h-4 mx-auto" />
                                    </button>
                                </td>
                            </tr>
                        ))}
                        
                        {dataPekerjaan.length === 0 && (
                            <tr>
                                <td colSpan={7} className="px-4 py-8 text-center text-gray-500">
                                    Belum ada data pekerjaan.
                                </td>
                            </tr>
                        )}
                    </tbody>
                </table>
            </div>

            {/* Modal Tambah Manual */}
            {isModalOpen && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
                    <div className="bg-white rounded-xl shadow-xl w-full max-w-md mx-4 overflow-hidden animate-in fade-in zoom-in duration-200">
                        {/* Modal Header */}
                        <div className="flex justify-between items-center p-4 border-b border-gray-100">
                            <h3 className="text-lg font-bold text-gray-900">Tambah Pekerjaan Manual</h3>
                            <button 
                                onClick={handleCloseModal}
                                className="text-gray-400 hover:text-gray-600 focus:outline-none p-1 rounded-md hover:bg-gray-100 transition-colors"
                            >
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        {/* Modal Body (Form) */}
                        <form onSubmit={handleSubmit} className="p-4 flex flex-col gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Nama Pekerjaan</label>
                                <input 
                                    type="text" 
                                    name="pekerjaan"
                                    required
                                    value={formData.pekerjaan}
                                    onChange={handleInputChange}
                                    placeholder="Contoh: Benerin PC Laboratorium"
                                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                                />
                            </div>
                            
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Tipe Pekerjaan</label>
                                <select 
                                    name="tipe"
                                    required
                                    value={formData.tipe}
                                    onChange={handleInputChange}
                                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm bg-white"
                                >
                                    <option value="Internal">Internal</option>
                                    <option value="Eksternal">Eksternal</option>
                                </select>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Poin (Jam Kompen)</label>
                                    <input 
                                        type="number" 
                                        name="poin"
                                        required
                                        min="1"
                                        value={formData.poin}
                                        onChange={handleInputChange}
                                        placeholder="Contoh: 2"
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Total Kuota Mahasiswa</label>
                                    <input 
                                        type="number" 
                                        name="kuotaTotal"
                                        required
                                        min="1"
                                        value={formData.kuotaTotal}
                                        onChange={handleInputChange}
                                        placeholder="Contoh: 10"
                                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                                    />
                                </div>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Tanggal Selesai</label>
                                <input 
                                    type="date" 
                                    name="tanggalSelesai"
                                    required
                                    value={formData.tanggalSelesai}
                                    onChange={handleInputChange}
                                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-sm"
                                />
                            </div>

                            {/* Form Actions */}
                            <div className="flex justify-end gap-2 mt-4 pt-4 border-t border-gray-100">
                                <button 
                                    type="button"
                                    onClick={handleCloseModal}
                                    className="px-4 py-2 border border-gray-300 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-50 transition-colors focus:outline-none"
                                >
                                    Batal
                                </button>
                                <button 
                                    type="submit"
                                    className="px-4 py-2 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity focus:outline-none"
                                >
                                    Simpan Pekerjaan
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}