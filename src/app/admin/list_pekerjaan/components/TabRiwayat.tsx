"use client";

import { FileText, CheckCircle, AlertTriangle, ChevronLeft, ChevronRight, X, Clock, Database, User, Search, RefreshCcw } from "lucide-react";
import { useState, useEffect, useCallback } from "react";
import { getImportHistory } from "../actions/import";

export default function TabRiwayat() {
    const [logs, setLogs] = useState<any[]>([]);
    const [page, setPage] = useState(1);
    const [limit, setLimit] = useState(10);
    const [total, setTotal] = useState(0);
    const [totalPages, setTotalPages] = useState(0);
    const [loading, setLoading] = useState(true);

    // Modal state
    const [selectedError, setSelectedError] = useState<any | null>(null);

    const fetchHistory = useCallback(async () => {
        setLoading(true);
        try {
            const res = await getImportHistory(page, limit);
            if (res.success) {
                setLogs(res.data);
                setTotal(res.total);
                setTotalPages(res.totalPages);
            }
        } catch (e) {
            console.error(e);
        } finally {
            setLoading(false);
        }
    }, [page, limit]);

    useEffect(() => {
        fetchHistory();
    }, [fetchHistory]);

    const handleRefresh = () => {
        setPage(1);
        fetchHistory();
    };

    const handleLimitChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        setLimit(Number(e.target.value));
        setPage(1);
    };

    const formatDate = (dateString: string | Date | null) => {
        if (!dateString) return "-";
        return new Intl.DateTimeFormat('id-ID', {
            day: 'numeric', month: 'short', year: 'numeric',
            hour: '2-digit', minute: '2-digit'
        }).format(new Date(dateString));
    };

    const getStatusColor = (statusId: number | null) => {
        if (!statusId) return "bg-blue-100 text-blue-700 border-blue-200"; // SEDANG_DIPROSES (default/running)
        switch (statusId) {
            case 1: return "bg-green-100 text-green-700 border-green-200"; // SELESAI
            case 2: return "bg-red-100 text-red-700 border-red-200"; // GAGAL
            default: return "bg-slate-100 text-slate-700 border-slate-200";
        }
    };

    return (
        <div className="bg-white border border-gray-200 shadow-sm rounded-xl p-6 relative" suppressHydrationWarning>
            {/* Header & Controls */}
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
                <div>
                    <h2 className="text-lg font-bold text-gray-900">Riwayat Import Berkas</h2>
                    <p className="text-sm text-gray-500">Melihat daftar berkas excel yang telah diunggah ke database.</p>
                </div>
                
                <div className="flex items-center gap-3 self-end md:self-auto">
                    <div className="flex items-center gap-2 text-sm text-gray-600 bg-gray-50 border border-gray-200 rounded-lg px-3 py-2">
                        <span>Tampilkan:</span>
                        <select 
                            className="bg-transparent font-medium text-gray-900 outline-none cursor-pointer"
                            value={limit}
                            onChange={handleLimitChange}
                        >
                            <option value={10}>10</option>
                            <option value={20}>20</option>
                            <option value={50}>50</option>
                        </select>
                    </div>
                    <button 
                        onClick={handleRefresh}
                        className="flex items-center gap-2 px-3 py-2 bg-blue-50 text-blue-600 font-medium text-sm rounded-lg hover:bg-blue-100 transition-colors"
                    >
                        <RefreshCcw size={16} className={loading ? "animate-spin" : ""} />
                        Refresh
                    </button>
                </div>
            </div>

            {/* Table */}
            <div className="border border-gray-200 rounded-lg overflow-hidden mb-6">
                <div className="overflow-x-auto">
                    <table className="w-full text-sm text-left">
                        <thead className="bg-gray-50 text-gray-600 text-[11px] uppercase tracking-wider font-bold">
                            <tr className="border-b border-gray-200">
                                <th className="px-5 py-4">Berkas / Admin</th>
                                <th className="px-5 py-4">Semester</th>
                                <th className="px-5 py-4 text-center">Waktu</th>
                                <th className="px-5 py-4 text-center">Status Data</th>
                                <th className="px-5 py-4 text-center">Kondisi</th>
                                <th className="px-5 py-4 text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                            {loading && logs.length === 0 ? (
                                <tr>
                                    <td colSpan={6} className="px-5 py-10 text-center text-gray-500">
                                        <div className="flex flex-col items-center gap-2">
                                            <RefreshCcw className="w-6 h-6 animate-spin text-blue-500" />
                                            <span>Memuat riwayat...</span>
                                        </div>
                                    </td>
                                </tr>
                            ) : logs.length === 0 ? (
                                <tr>
                                    <td colSpan={6} className="px-5 py-10 text-center text-gray-500">
                                        Belum ada riwayat import data.
                                    </td>
                                </tr>
                            ) : (
                                logs.map((log) => (
                                    <tr key={log.id} className="hover:bg-gray-50/50 transition-colors group">
                                        <td className="px-5 py-4">
                                            <div className="flex items-center gap-3">
                                                <div className="p-2.5 bg-blue-50 text-blue-600 rounded-lg border border-blue-100">
                                                    <FileText className="w-5 h-5" />
                                                </div>
                                                <div className="flex flex-col max-w-[200px]">
                                                    <span className="font-bold text-gray-800 truncate" title={log.nama_file}>
                                                        {log.nama_file}
                                                    </span>
                                                    <span className="text-xs text-gray-500 flex items-center gap-1 mt-0.5">
                                                        <User size={12} /> {log.staf?.nama || log.staf_nip || "Sistem"}
                                                    </span>
                                                </div>
                                            </div>
                                        </td>
                                        <td className="px-5 py-4">
                                            <span className="font-medium text-gray-700 bg-gray-100 px-2.5 py-1 rounded-md text-xs border border-gray-200">
                                                {log.semester?.nama || "Tidak ada"}
                                            </span>
                                        </td>
                                        <td className="px-5 py-4 text-center">
                                            <div className="flex flex-col items-center text-xs text-gray-600">
                                                <Clock size={14} className="mb-1 text-gray-400" />
                                                <span>{formatDate(log.created_at)}</span>
                                            </div>
                                        </td>
                                        <td className="px-5 py-4 text-center">
                                            <div className="flex flex-col items-center">
                                                <div className="text-xs font-bold text-gray-800">{log.sukses_baris} / {log.total_baris} Baris</div>
                                                <div className="w-full bg-gray-200 rounded-full h-1.5 mt-1.5 max-w-[80px]">
                                                    <div 
                                                        className="bg-blue-600 h-1.5 rounded-full" 
                                                        style={{ width: `${Math.min(100, (log.sukses_baris / Math.max(1, log.total_baris)) * 100)}%` }}
                                                    ></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td className="px-5 py-4 text-center">
                                            <span className={`px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider border ${getStatusColor(log.status_import_id)}`}>
                                                {log.status_import?.nama || "SEDANG_DIPROSES"}
                                            </span>
                                        </td>
                                        <td className="px-5 py-4 text-center">
                                            <button 
                                                onClick={() => setSelectedError(log)}
                                                disabled={!log.error_details || (Array.isArray(log.error_details) && log.error_details.length === 0)}
                                                className={`px-4 py-1.5 rounded-lg text-xs font-bold transition-all ${
                                                    log.error_details && (!Array.isArray(log.error_details) || log.error_details.length > 0)
                                                        ? 'bg-white border border-gray-300 text-gray-700 hover:bg-gray-50 hover:border-gray-400 shadow-sm' 
                                                        : 'bg-transparent text-gray-300 cursor-not-allowed opacity-50'
                                                }`}
                                            >
                                                Detail
                                            </button>
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Pagination Controls */}
            {totalPages > 1 && (
                <div className="flex items-center justify-between text-sm text-gray-600">
                    <span className="font-medium">
                        Menampilkan {((page - 1) * limit) + 1} - {Math.min(page * limit, total)} dari {total} data
                    </span>
                    <div className="flex items-center gap-1.5">
                        <button 
                            onClick={() => setPage(p => Math.max(1, p - 1))}
                            disabled={page === 1}
                            className="p-1.5 border border-gray-200 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                        >
                            <ChevronLeft size={18} />
                        </button>
                        <div className="px-3 py-1.5 bg-gray-50 border border-gray-200 rounded-lg font-bold text-gray-800">
                            {page} / {totalPages}
                        </div>
                        <button 
                            onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                            disabled={page === totalPages}
                            className="p-1.5 border border-gray-200 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                        >
                            <ChevronRight size={18} />
                        </button>
                    </div>
                </div>
            )}

            {/* Error Detail Modal */}
            {selectedError && selectedError.error_details && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm animate-in fade-in duration-200">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl overflow-hidden flex flex-col max-h-[85vh] animate-in zoom-in-95 duration-200">
                        {/* Modal Header */}
                        <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between bg-gray-50/50">
                            <div className="flex items-center gap-3">
                                <div className="p-2 bg-red-100 text-red-600 rounded-lg">
                                    <AlertTriangle size={20} />
                                </div>
                                <div>
                                    <h3 className="font-bold text-gray-900 leading-tight">Detail Kegagalan Import</h3>
                                    <p className="text-xs text-gray-500 mt-0.5">{selectedError.nama_file}</p>
                                </div>
                            </div>
                            <button 
                                onClick={() => setSelectedError(null)}
                                className="p-2 text-gray-400 hover:text-gray-700 hover:bg-gray-200 rounded-full transition-colors"
                            >
                                <X size={20} />
                            </button>
                        </div>
                        
                        {/* Modal Body */}
                        <div className="p-6 overflow-y-auto bg-gray-50/30">
                            <div className="bg-white border border-red-100 rounded-xl overflow-hidden">
                                <div className="bg-red-50 px-4 py-2 border-b border-red-100 flex justify-between items-center text-xs font-bold text-red-800 uppercase tracking-wider">
                                    <span>NIM / Identifier</span>
                                    <span>Pesan Error</span>
                                </div>
                                <ul className="divide-y divide-gray-100">
                                    {Array.isArray(selectedError.error_details) ? (
                                        selectedError.error_details.map((err: any, idx: number) => (
                                            <li key={idx} className="p-4 hover:bg-red-50/30 transition-colors flex flex-col md:flex-row md:items-start gap-2 md:gap-6">
                                                <div className="md:w-1/3 flex flex-col shrink-0">
                                                    <span className="font-bold text-gray-900">{err.nim || "-"}</span>
                                                    <span className="text-xs text-gray-500">{err.nama || "-"}</span>
                                                </div>
                                                <div className="text-sm text-red-600 font-medium">
                                                    {err.error || "Unknown error"}
                                                </div>
                                            </li>
                                        ))
                                    ) : (
                                        <li className="p-4 text-sm text-gray-700 break-words">
                                            {JSON.stringify(selectedError.error_details)}
                                        </li>
                                    )}
                                </ul>
                            </div>
                        </div>

                        {/* Modal Footer */}
                        <div className="px-6 py-4 border-t border-gray-100 bg-white flex justify-end">
                            <button 
                                onClick={() => setSelectedError(null)}
                                className="px-6 py-2 bg-gray-900 text-white text-sm font-bold rounded-lg hover:bg-gray-800 transition-colors"
                            >
                                Tutup
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}