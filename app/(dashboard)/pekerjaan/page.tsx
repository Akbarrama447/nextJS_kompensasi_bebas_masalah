'use client';

import { useState, useEffect } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { createClient } from '@/lib/supabase/client';
import TabKelolaPekerjaan from '@/components/pekerjaan/TabKelolaPekerjaan';
import TabDaftarPenugasan from '@/components/pekerjaan/TabDaftarPenugasan';
import TabMarketplace from '@/components/pekerjaan/TabMarketplace';
import TabPekerjaanSaya from '@/components/pekerjaan/TabPekerjaanSaya';
import { Briefcase, ClipboardList, ShoppingBag, Loader2, FileSpreadsheet } from 'lucide-react';
import TabRiwayatImport from '@/components/pekerjaan/TabRiwayatImport';
import type { Staf, Mahasiswa } from '@/lib/types';

type TabType = 'kelola' | 'penugasan' | 'riwayat' | 'marketplace' | 'pekerjaan-saya';

export default function PekerjaanPage() {
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState<TabType>(user?.roleName === 'mahasiswa' ? 'marketplace' : 'kelola');
  const [semesterId, setSemesterId] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);
  const supabase = createClient();

  useEffect(() => {
    // Get active semester
    supabase
      .from('semester')
      .select('id')
      .eq('is_aktif', true)
      .maybeSingle()
      .then(({ data }) => {
        if (data) setSemesterId(data.id);
        setLoading(false);
      });
  }, [supabase]);

  const isStaf = user?.roleName !== 'mahasiswa';
  const profile = user?.profile;

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">
            {activeTab === 'marketplace' ? 'Daftar Pekerjaan Tersedia' : 
             activeTab === 'pekerjaan-saya' ? 'Pekerjaan Saya' : 'Kelola Pekerjaan & Penugasan'}
          </h1>
          <p className="text-sm text-slate-500 mt-1">
            {activeTab === 'marketplace'
              ? 'Pilih pekerjaan yang sesuai untuk melunasi jam kompen Anda.'
              : activeTab === 'pekerjaan-saya'
              ? 'Mulai dan selesaikan pekerjaan yang telah Anda ambil.'
              : 'Atur daftar pekerjaan Anda dan verifikasi penyelesaian mahasiswa.'}
          </p>
        </div>

        {/* Tab Switcher */}
        {user && (
          <div className="flex bg-slate-200/50 p-1.5 rounded-xl border border-slate-200 overflow-x-auto">
            {isStaf ? (
              <>
                <button
                  onClick={() => setActiveTab('kelola')}
                  className={`flex items-center gap-2 px-4 py-2 text-sm font-semibold rounded-lg transition-all whitespace-nowrap ${activeTab === 'kelola' ? 'bg-white shadow-sm text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}
                >
                  <Briefcase className="w-4 h-4" /> Kelola
                </button>
                <button
                  onClick={() => setActiveTab('penugasan')}
                  className={`flex items-center gap-2 px-4 py-2 text-sm font-semibold rounded-lg transition-all whitespace-nowrap ${activeTab === 'penugasan' ? 'bg-white shadow-sm text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}
                >
                  <ClipboardList className="w-4 h-4" /> Penugasan
                </button>
                <button
                  onClick={() => setActiveTab('riwayat')}
                  className={`flex items-center gap-2 px-4 py-2 text-sm font-semibold rounded-lg transition-all whitespace-nowrap ${activeTab === 'riwayat' ? 'bg-white shadow-sm text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}
                >
                  <FileSpreadsheet className="w-4 h-4" /> Riwayat
                </button>
              </>
            ) : (
              <>
                <button
                  onClick={() => setActiveTab('marketplace')}
                  className={`flex items-center gap-2 px-4 py-2 text-sm font-semibold rounded-lg transition-all whitespace-nowrap ${activeTab === 'marketplace' ? 'bg-white shadow-sm text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}
                >
                  <ShoppingBag className="w-4 h-4" /> Marketplace
                </button>
                <button
                  onClick={() => setActiveTab('pekerjaan-saya')}
                  className={`flex items-center gap-2 px-4 py-2 text-sm font-semibold rounded-lg transition-all whitespace-nowrap ${activeTab === 'pekerjaan-saya' ? 'bg-white shadow-sm text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}
                >
                  <ClipboardList className="w-4 h-4" /> Pekerjaan Saya
                </button>
              </>
            )}
          </div>
        )}
      </div>

      {loading || !user ? (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm min-h-[400px] p-6 flex items-center justify-center">
           <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
        </div>
      ) : semesterId || activeTab === 'riwayat' ? (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm min-h-[500px] p-6">
          {activeTab === 'kelola' && isStaf && semesterId && (
            <TabKelolaPekerjaan staffNip={(profile as Staf).nip} semesterId={semesterId} />
          )}
          {activeTab === 'penugasan' && isStaf && semesterId && (
            <TabDaftarPenugasan staffNip={(profile as Staf).nip} semesterId={semesterId} />
          )}
          {activeTab === 'riwayat' && isStaf && (
            <TabRiwayatImport staffNip={(profile as Staf).nip} />
          )}
          {activeTab === 'marketplace' && semesterId && (
              <TabMarketplace mahasiswaNim={(profile as Mahasiswa).nim} semesterId={semesterId} />
          )}
          {activeTab === 'pekerjaan-saya' && semesterId && (
              <TabPekerjaanSaya mahasiswaNim={(profile as Mahasiswa).nim} semesterId={semesterId} />
          )}
        </div>
      ) : (
        <div className="card text-center py-20">
          <p className="text-slate-500">Tidak ada semester aktif yang berjalan.</p>
        </div>
      )}
    </div>
  );
}
