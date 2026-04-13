'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { Settings, ShieldCheck, Wallet, Laptop, Info, Loader2 } from 'lucide-react';
import InlineSetting from '@/components/pengaturan/InlineSetting';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import toast from 'react-hot-toast';

interface SettingItem {
  id: number;
  kunci: string;
  nilai: string;
  label: string;
  grup: string;
}

export default function PengaturanPage() {
  const [loading, setLoading] = useState(true);
  const [settings, setSettings] = useState<SettingItem[]>([]);
  const supabase = createClient();

  const fetchSettings = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from('pengaturan')
        .select('*')
        .order('id', { ascending: true });

      if (error) throw error;
      setSettings(data ?? []);
    } catch (err: any) {
      toast.error(err.message);
    } finally {
      setLoading(false);
    }
  }, [supabase]);

  useEffect(() => {
    fetchSettings();
  }, [fetchSettings]);

  // Grouping logic
  const settingsByGroup = settings.reduce((acc: Record<string, SettingItem[]>, item) => {
    if (!acc[item.grup]) acc[item.grup] = [];
    acc[item.grup].push(item);
    return acc;
  }, {});

  const getGroupIcon = (groupName: string) => {
    switch (groupName.toLowerCase()) {
      case 'keuangan': return <Wallet className="w-5 h-5 text-green-600" />;
      case 'auth': return <ShieldCheck className="w-5 h-5 text-blue-600" />;
      case 'sistem': return <Laptop className="w-5 h-5 text-purple-600" />;
      default: return <Settings className="w-5 h-5 text-slate-600" />;
    }
  };

  return (
    <div className="space-y-8 max-w-4xl">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Pengaturan Sistem</h1>
        <p className="text-sm text-slate-500 mt-1">Konfigurasi variabel global, biaya kompen, dan metode autentikasi.</p>
      </div>

      {loading ? (
        <div className="space-y-6">
           <div className="card animate-pulse h-32" />
           <div className="card animate-pulse h-32" />
        </div>
      ) : (
        <div className="space-y-8 pb-20">
          {Object.entries(settingsByGroup).map(([group, groupItems]) => (
            <section key={group} className="space-y-3">
               <div className="flex items-center gap-2 px-1">
                  {getGroupIcon(group)}
                  <h2 className="text-sm font-bold text-slate-800 uppercase tracking-widest">{group}</h2>
               </div>
               
               <div className="card p-0 overflow-hidden">
                  <div className="px-6 py-2">
                     {groupItems.map((item) => (
                       <InlineSetting 
                         key={item.id} 
                         setting={item} 
                         onUpdate={fetchSettings} 
                       />
                     ))}
                  </div>
                  <div className="bg-slate-50/50 px-6 py-3 border-t border-slate-100 flex items-center gap-2">
                     <Info className="w-3.5 h-3.5 text-slate-400" />
                     <p className="text-[10px] text-slate-500 italic">Perubahan pada grup {group} akan langsung berdampak pada seluruh perhitungan sistem.</p>
                  </div>
               </div>
            </section>
          ))}

          {/* Tips Section */}
          <div className="bg-amber-50 border border-amber-200 rounded-xl p-6 flex gap-4">
             <div className="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center flex-shrink-0">
                <Settings className="w-5 h-5 text-amber-500" />
             </div>
             <div className="text-sm leading-relaxed">
                <p className="font-bold text-amber-900 mb-1">Tips Konfigurasi</p>
                <p className="text-amber-800">
                   Gunakan grup <strong>Keuangan</strong> untuk mengatur harga konversi kompen. 
                   Sistem akan menggunakan nilai ini secara real-time saat PJ Kelas melakukan submit ekuivalensi kolektif. 
                   Pastikan nilai dalam mata uang Rupiah tanpa titik.
                </p>
             </div>
          </div>
        </div>
      )}
    </div>
  );
}
