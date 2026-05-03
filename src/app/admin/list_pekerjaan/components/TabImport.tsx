"use client";

import { useState, useRef, useCallback } from "react";
import { CheckCircle, XCircle, AlertCircle, FileSpreadsheet } from "lucide-react";
import { parseExcelFile, type ParsedStudent } from "@/lib/excel-parser";
import { executeImport } from "@/app/admin/list_pekerjaan/actions/import";

// ─────────────────────────────────────────
// Types
// ─────────────────────────────────────────

type ModalState = "hidden" | "parsing" | "preview" | "importing" | "success" | "error";

interface ImportSummary {
  successCount: number;
  errorCount: number;
  importLogId: number | null;
}

// ─────────────────────────────────────────
// Konstanta — sesuaikan dengan data nyata
// ─────────────────────────────────────────

// TODO: Ambil dari cookie/session admin yang login
const STAFF_NIP = "196801011990031001";
// TODO: Ambil dari semester aktif di DB
const SEMESTER_ID = 1;

// ─────────────────────────────────────────
// Component
// ─────────────────────────────────────────

export default function TabImport() {
    const fileInputRef = useRef<HTMLInputElement>(null);

    const [modalState, setModalState] = useState<ModalState>("hidden");
    const [errorMessage, setErrorMessage] = useState("");
    const [parseErrors, setParseErrors] = useState<string[]>([]);
    const [students, setStudents] = useState<ParsedStudent[]>([]);
    const [currentFileName, setCurrentFileName] = useState("");
    const [summary, setSummary] = useState<ImportSummary | null>(null);

    // ── File selection ───────────────────────────────────────────────────
    const handleImportClick = () => fileInputRef.current?.click();

    const handleFileChange = useCallback(async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;
        e.target.value = ""; // reset agar file yang sama bisa dipilih ulang

        const validExtensions = [".xlsx", ".csv"];
        const isValid = validExtensions.some((ext) => file.name.toLowerCase().endsWith(ext));

        if (!isValid) {
            setErrorMessage("Format file tidak didukung. Harap upload file .xlsx atau .csv saja.");
            setModalState("error");
            return;
        }

        // Parsing fase
        setCurrentFileName(file.name);
        setModalState("parsing");

        try {
            const result = await parseExcelFile(file);

            if (result.students.length === 0 && result.errors.length > 0) {
                // Gagal total — kemungkinan header salah
                setErrorMessage(result.errors[0]);
                setModalState("error");
                return;
            }

            setStudents(result.students);
            setParseErrors(result.errors);
            setModalState("preview");
        } catch (err) {
            setErrorMessage(err instanceof Error ? err.message : "Gagal membaca file.");
            setModalState("error");
        }
    }, []);

    // ── Eksekusi import ke DB ────────────────────────────────────────────
    const handleConfirmImport = async () => {
        if (students.length === 0) return;

        setModalState("importing");

        try {
            const result = await executeImport({
                students,
                semesterId: SEMESTER_ID,
                staffNip: STAFF_NIP,
                namaFile: currentFileName,
            });

            setSummary({
                successCount: result.successCount,
                errorCount: result.errors.length,
                importLogId: result.importLogId,
            });
            
            // Masukkan error dari database ke dalam list error UI
            setParseErrors(result.errors.map(e => 
                `NIM ${e.nim} (${e.nama}): ${e.error}`
            ));
            
            setModalState("success");
        } catch (error) {
            console.error(error);
            const msg = error instanceof Error ? error.message : String(error);
            setErrorMessage(`Gagal menghubungi server: ${msg}`);
            setModalState("error");
        }
    };

    const handleClose = () => {
        setModalState("hidden");
        setStudents([]);
        setParseErrors([]);
        setSummary(null);
        setErrorMessage("");
        setCurrentFileName("");
    };

    return (
        <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-6">
            {/* Hidden File Input */}
            <input
                type="file"
                ref={fileInputRef}
                onChange={handleFileChange}
                accept=".xlsx,.csv"
                className="hidden"
            />

            {/* Action Bar — tombol Import Excel */}
            <div className="flex justify-end mb-3">
                <button
                    onClick={handleImportClick}
                    className="px-5 py-2 border border-gray-200 text-gray-600 text-sm font-medium rounded-lg bg-white hover:border-gray-300 hover:text-gray-800 transition-colors focus:outline-none"
                >
                    Import Excel
                </button>
            </div>


            {/* Table Preview */}
            <div className="border border-gray-200 rounded-lg overflow-hidden">
                <table className="w-full text-sm text-left">
                    <thead className="bg-gray-50 text-gray-600 text-xs uppercase font-medium">
                        <tr className="border-b border-gray-200">
                            <th className="px-4 py-3">Mahasiswa</th>
                            <th className="px-4 py-3 text-center">NIM</th>
                            <th className="px-4 py-3 text-center">Kelas</th>
                            <th className="px-4 py-3 text-center">Jam Kompen</th>
                            <th className="px-4 py-3 text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                        {students.length === 0 ? (
                            <tr>
                                <td colSpan={5} className="px-4 py-10 text-center text-gray-400 text-sm">
                                    Belum ada data. Upload file Excel untuk melihat preview.
                                </td>
                            </tr>
                        ) : (
                            students.map((s, i) => (
                                <tr key={i} className="hover:bg-gray-50/50 transition-colors">
                                    <td className="px-4 py-3">
                                        <p className="font-medium text-gray-800">{s.nama}</p>
                                    </td>
                                    <td className="px-4 py-3 text-gray-600 text-center">{s.nim}</td>
                                    <td className="px-4 py-3 text-gray-600 text-center">{s.kelas}</td>
                                    <td className="px-4 py-3 text-gray-600 text-center">{s.jam} jam</td>
                                    <td className="px-4 py-3 text-center">
                                        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 bg-green-50 text-green-700 border border-green-200 rounded-md text-xs font-medium">
                                            Siap Import
                                        </span>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>

            {/* Parse errors note */}
            {parseErrors.length > 0 && (
                <div className="mt-4 flex items-start gap-2 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                    <AlertCircle className="w-4 h-4 text-yellow-600 shrink-0 mt-0.5" />
                    <div>
                        <p className="text-xs font-semibold text-yellow-800 mb-1">{parseErrors.length} baris dilewati saat parsing:</p>
                        <ul className="text-xs text-yellow-700 list-disc list-inside space-y-0.5">
                            {parseErrors.slice(0, 5).map((e, i) => <li key={i}>{e}</li>)}
                            {parseErrors.length > 5 && <li>...dan {parseErrors.length - 5} lainnya.</li>}
                        </ul>
                    </div>
                </div>
            )}

            {/* Action: Confirm import button (muncul setelah preview) */}
            {students.length > 0 && (
                <div className="mt-5 flex justify-end">
                    <button
                        onClick={handleConfirmImport}
                        className="flex items-center gap-2 px-6 py-2.5 bg-[var(--color-primary)] text-white font-medium text-sm rounded-lg hover:opacity-90 transition-opacity focus:outline-none shadow-sm"
                    >
                        <FileSpreadsheet className="w-4 h-4" />
                        Import {students.length} Mahasiswa ke Database
                    </button>
                </div>
            )}

            {/* ── Modals ───────────────────────────────────────────────────────── */}
            {modalState !== "hidden" && modalState !== "preview" && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
                    <div className="bg-white rounded-xl shadow-xl max-w-sm w-full overflow-hidden animate-in fade-in zoom-in duration-200">

                        {/* Parsing */}
                        {modalState === "parsing" && (
                            <div className="flex flex-col items-center p-8">
                                <div className="w-12 h-12 border-4 border-blue-100 border-t-blue-600 rounded-full animate-spin mb-4" />
                                <h3 className="text-lg font-bold text-gray-900">Membaca File...</h3>
                                <p className="text-sm text-gray-500 mt-1">Sedang mem-parsing data Excel.</p>
                            </div>
                        )}

                        {/* Importing */}
                        {modalState === "importing" && (
                            <div className="flex flex-col items-center p-8">
                                <div className="w-12 h-12 border-4 border-blue-100 border-t-blue-600 rounded-full animate-spin mb-4" />
                                <h3 className="text-lg font-bold text-gray-900">Mengimport Data...</h3>
                                <p className="text-sm text-gray-500 mt-1 text-center">
                                    Memproses {students.length} mahasiswa. Harap tunggu.
                                </p>
                            </div>
                        )}

                        {/* Success */}
                        {modalState === "success" && summary && (
                            <div className="flex flex-col items-center p-8">
                                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mb-4">
                                    <CheckCircle className="w-8 h-8 text-green-600" />
                                </div>
                                <h3 className="text-xl font-bold text-gray-900">Import Selesai!</h3>
                                <div className="mt-4 w-full flex gap-3">
                                    <div className="flex-1 bg-green-50 border border-green-200 rounded-lg p-3 text-center">
                                        <p className="text-2xl font-bold text-green-700">{summary.successCount}</p>
                                        <p className="text-xs text-green-600 mt-0.5">Berhasil</p>
                                    </div>
                                    <div className="flex-1 bg-red-50 border border-red-200 rounded-lg p-3 text-center">
                                        <p className="text-2xl font-bold text-red-700">{summary.errorCount}</p>
                                        <p className="text-xs text-red-600 mt-0.5">Gagal</p>
                                    </div>
                                </div>
                                
                                {/* Tampilkan detail error jika ada */}
                                {parseErrors.length > 0 && (
                                    <div className="mt-4 w-full text-left bg-red-50/50 p-3 rounded-lg border border-red-100 max-h-32 overflow-y-auto">
                                        <p className="text-xs font-semibold text-red-800 mb-1">Detail Gagal:</p>
                                        <ul className="text-xs text-red-600 space-y-1">
                                            {parseErrors.map((err, i) => (
                                                <li key={i} className="border-b border-red-100/50 pb-1 last:border-0">{err}</li>
                                            ))}
                                        </ul>
                                    </div>
                                )}

                                <button
                                    onClick={handleClose}
                                    className="mt-6 w-full py-2.5 bg-[var(--color-primary)] text-white font-medium rounded-lg hover:opacity-90 transition-opacity focus:outline-none"
                                >
                                    Selesai
                                </button>
                            </div>
                        )}

                        {/* Error */}
                        {modalState === "error" && (
                            <div className="flex flex-col items-center p-8">
                                <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mb-4">
                                    <XCircle className="w-8 h-8 text-red-600" />
                                </div>
                                <h3 className="text-xl font-bold text-gray-900">Gagal</h3>
                                <p className="text-sm text-gray-600 mt-2 text-center leading-relaxed">{errorMessage}</p>
                                <button
                                    onClick={handleClose}
                                    className="mt-6 w-full py-2.5 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition-colors focus:outline-none"
                                >
                                    Tutup
                                </button>
                            </div>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}