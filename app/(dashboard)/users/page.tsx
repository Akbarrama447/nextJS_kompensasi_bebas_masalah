'use client';

import { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { Users, Search, UserCheck, Shield, Mail } from 'lucide-react';
import { SkeletonRow } from '@/components/ui/SkeletonRow';
import { ROLE_LABELS } from '@/lib/menu-config';
import toast from 'react-hot-toast';

export default function UsersPage() {
  const [loading, setLoading] = useState(true);
  const [users, setUsers] = useState<any[]>([]);
  const [search, setSearch] = useState('');
  const supabase = createClient();

  const fetchUsers = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from('users')
      .select('user_id, email, roles(nama)')
      .order('user_id', { ascending: false })
      .limit(50);
    setUsers(data ?? []);
    setLoading(false);
  }, [supabase]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const filtered = users.filter(u => u.email.toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Manajemen User</h1>
          <p className="text-sm text-slate-500 mt-1">Daftar user yang terdaftar di dalam sistem.</p>
        </div>
      </div>

      <div className="relative">
         <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
         <input 
           className="input-base pl-10" 
           placeholder="Cari user berdasarkan email..." 
           value={search}
           onChange={(e) => setSearch(e.target.value)}
         />
      </div>

      <div className="card p-0 overflow-hidden">
        <table className="table-base">
          <thead>
            <tr>
              <th>ID User</th>
              <th>Email / Identitas</th>
              <th>Hak Akses</th>
              <th className="text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <SkeletonRow cols={4} rows={10} />
            ) : filtered.length === 0 ? (
               <tr><td colSpan={4} className="py-10 text-center text-slate-400">User tidak ditemukan.</td></tr>
            ) : (
              filtered.map((u) => (
                <tr key={u.user_id}>
                  <td className="text-xs font-mono text-slate-400">#{u.user_id}</td>
                  <td>
                    <div className="flex items-center gap-2">
                       <Mail className="w-3.5 h-3.5 text-slate-400" />
                       <span className="font-medium text-slate-700">{u.email}</span>
                    </div>
                  </td>
                  <td>
                    <div className="flex items-center gap-2">
                       <Shield className="w-3.5 h-3.5 text-blue-400" />
                       <span className="text-xs font-bold text-slate-600 uppercase tracking-tight">
                         {u.roles?.nama || 'Unknown'}
                       </span>
                    </div>
                  </td>
                  <td className="text-right">
                    <button 
                      onClick={() => toast('Edit user melalui Supabase Auth', { icon: '🔑' })} 
                      className="text-xs text-blue-600 font-bold hover:underline"
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
  );
}
