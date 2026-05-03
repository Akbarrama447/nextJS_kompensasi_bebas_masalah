"use client";

import { useState, useRef } from "react";

export default function TabImport() {
    const fileInputRef = useRef<HTMLInputElement>(null);
    const [modalState, setModalState] = useState<"hidden" | "uploading" | "success" | "error">("hidden");
    const [errorMessage, setErrorMessage] = useState("");

    const handleImportClick = () => {
        fileInputRef.current?.click();
    };

    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;

        // Reset the input value so the same file can be selected again
        e.target.value = "";

        // Simple validation for Excel/CSV extensions
        const validExtensions = ['.xlsx', '.csv'];
        const isExtensionValid = validExtensions.some(ext => file.name.toLowerCase().endsWith(ext));
        
        if (!isExtensionValid) {
            setErrorMessage("Format file tidak didukung. Harap upload file .xlsx atau .csv saja.");
            setModalState("error");
            return;
        }

        // Simulate upload process
        setModalState("uploading");
        
        setTimeout(() => {
            // Dummy logic: Simulate an error if the filename contains "error"
            if (file.name.toLowerCase().includes("error")) {
                setErrorMessage("Gagal membaca data Excel. Format kolom tidak sesuai dengan template sistem.");
                setModalState("error");
            } else {
                setModalState("success");
            }
        }, 1500); // Simulate 1.5 seconds loading
    };

    return (
        <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-4" suppressHydrationWarning>
            {/* Hidden File Input */}
            <input 
                type="file" 
                ref={fileInputRef} 
                onChange={handleFileChange} 
                accept=".xlsx, .csv" 
                className="hidden" 
            />

            {/* Action Bar */}
            <div className="flex justify-end mb-4">
                <button 
                    onClick={handleImportClick}
                    className="px-3 md:px-4 py-1.5 md:py-2 border border-gray-200 text-gray-700 font-medium text-xs md:text-sm rounded-lg hover:bg-gray-50 transition-colors bg-white shadow-sm focus:outline-none whitespace-nowrap"
                >
                    Import Excel
                </button>
            </div>

            {/* Table */}
            <div className="border border-gray-200 rounded-lg overflow-x-auto">
                <table className="w-full text-xs md:text-sm text-left">
                    <thead className="bg-gray-50 text-gray-600 text-[10px] md:text-xs uppercase font-medium">
                        <tr className="border-b border-gray-200">
                            <th className="px-2 md:px-4 py-2 md:py-3">Nama</th>
                            <th className="px-2 md:px-4 py-2 md:py-3 text-center">NIM</th>
                            <th className="px-2 md:px-4 py-2 md:py-3 text-center hidden md:table-cell">Kelas</th>
                            <th className="px-2 md:px-4 py-2 md:py-3 text-center">Jam Kompen</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        <tr className="hover:bg-gray-50/50 transition-colors">
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-800 font-medium text-xs md:text-sm">Andi Simukto</td>
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 text-center text-xs">3.34.24.2.09</td>
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 text-center hidden md:table-cell text-xs">IK-2C</td>
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 text-center text-xs">2 jam</td>
                        </tr>
                        <tr className="hover:bg-gray-50/50 transition-colors">
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-800 font-medium text-xs md:text-sm">Dini Cantika</td>
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 text-center text-xs">3.34.24.2.17</td>
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 text-center hidden md:table-cell text-xs">IK-2C</td>
                            <td className="px-2 md:px-4 py-2 md:py-3 text-gray-600 text-center text-xs">6 jam</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            {/* Popup Modal */}
            {modalState !== "hidden" && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
                    <div className="bg-white rounded-xl shadow-xl p-6 max-w-sm w-full mx-4 border border-gray-100 animate-in fade-in zoom-in duration-200">
                        
                        {/* State: Uploading */}
                        {modalState === "uploading" && (
                            <div className="flex flex-col items-center py-4">
                                <div className="w-10 h-10 border-4 border-blue-100 border-t-blue-600 rounded-full animate-spin mb-4"></div>
                                <h3 className="text-lg font-semibold text-gray-900">Mengunggah Data...</h3>
                                <p className="text-sm text-gray-500 mt-1">Harap tunggu sebentar.</p>
                            </div>
                        )}

                        {/* State: Success */}
                        {modalState === "success" && (
                            <div className="flex flex-col items-center py-2">
                                <div className="w-14 h-14 bg-green-100 text-green-600 rounded-full flex items-center justify-center mb-4">
                                    <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                                    </svg>
                                </div>
                                <h3 className="text-xl font-bold text-gray-900">Berhasil!</h3>
                                <p className="text-sm text-gray-500 mt-2 text-center">Data mahasiswa berhasil diimpor dari Excel.</p>
                                <button 
                                    onClick={() => setModalState("hidden")} 
                                    className="mt-6 w-full py-2.5 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors focus:outline-none"
                                >
                                    Selesai
                                </button>
                            </div>
                        )}

                        {/* State: Error */}
                        {modalState === "error" && (
                            <div className="flex flex-col items-center py-2">
                                <div className="w-14 h-14 bg-red-100 text-red-600 rounded-full flex items-center justify-center mb-4">
                                    <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                                    </svg>
                                </div>
                                <h3 className="text-xl font-bold text-gray-900">Gagal Mengimpor</h3>
                                <p className="text-sm text-gray-600 mt-2 text-center leading-relaxed">{errorMessage}</p>
                                <button 
                                    onClick={() => setModalState("hidden")} 
                                    className="mt-6 w-full py-2.5 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition-colors focus:outline-none"
                                >
                                    Coba Lagi
                                </button>
                            </div>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}