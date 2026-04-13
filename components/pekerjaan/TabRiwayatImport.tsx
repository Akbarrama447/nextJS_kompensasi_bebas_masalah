'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { formatTanggalWaktu, getStatusImportBadge } from '@/lib/utils';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import EmptyState from '@/components/ui/EmptyState';
import { FileSpreadsheet, AlertTriangle, Info } from 'lucide-react';
import toast from 'react-hot-toast';

interface TabRiwayatImportProps {
  staffNip: string;
}

export default function TabRiwayatImport({ staffNip }: TabRiwayatImportProps) {
  const [loading, setLoading] = useState(true);
  const [logs, setLogs] = useState<any[]>([]);
  const supabase = createClient();

  const fetchLogs = useCallback(async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('import_log')
        .select(`
          *,
          semester:semester_id(nama)
        `)
        .eq('staf_nip', staffNip)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setLogs(data ?? []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [supabase, staffNip]);

  useEffect(() => {
    fetchLogs();
  }, [fetchLogs]);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
         <h2 className="text-sm font-bold text-slate-800">Riwayat Import Berkas</h2>
         <button onClick={fetchLogs} className="text-xs text-blue-600 hover:underline">Refresh Riwayat</button>
      </div>

      <div className="table-wrapper">
        <table className="table-base">
          <thead>
            <tr>
              <th>Berkas / Semester</th>
              <th>Waktu</th>
              <th className="text-center">Baris</th>
              <th className="text-center">Sukses</th>
              <th>Status</th>
              <th className="text-right">Detail</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <SkeletonRow cols={6} rows={5} />
            ) : logs.length === 0 ? (
              <tr>
                <td colSpan={6}><EmptyState title="Belum pernah import" description="Data riwayat import excel Anda akan muncul di sini." /></td>
              </tr>
            ) : (
              logs.map((log) => {
                const badge = getStatusImportBadge(log.status_import_id);
                return (
                  <tr key={log.id}>
                    <td>
                       <div className="flex items-center gap-3">
                          <FileSpreadsheet className="w-4 h-4 text-slate-400" />
                          <div>
                             <p className="font-semibold text-slate-900 truncate max-w-[150px]">{log.nama_file}</p>
                             <p className="text-[10px] text-slate-400">Semester: {log.semester?.nama}</p>
                          </div>
                       </div>
                    </td>
                    <td className="text-xs text-slate-500">{formatTanggalWaktu(log.created_at)}</td>
                    <td className="text-center font-mono">{log.total_baris}</td>
                    <td className="text-center font-mono font-bold text-green-600">{log.sukses_baris}</td>
                    <td>
                       <span className={`badge ${badge.className}`}>{badge.label}</span>
                    </td>
                    <td className="text-right">
                       <button 
                         onClick={() => {
                           if (log.error_details) {
                             console.table(log.error_details);
                             toast('Cek console log (F12) untuk detail error', { icon: '🔍' });
                           } else {
                             toast.success('Import ini lunas tanpa error');
                           }
                         }}
                         className="p-1.5 hover:bg-slate-100 rounded-lg text-slate-400"
                        >
                          <Info className="w-4 h-4" />
                       </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 flex gap-3">
         <AlertTriangle className="w-4 h-4 text-amber-500 flex-shrink-0 mt-0.5" />
         <p className="text-[11px] text-slate-500 leading-relaxed italic">
            Log riwayat ini hanya menampilkan berkas yang Anda import sendiri. 
            Superadmin dapat melihat riwayat import dari seluruh staf melalui menu Manajemen Data.
         </p>
      </div>
    </div>
  );
}
