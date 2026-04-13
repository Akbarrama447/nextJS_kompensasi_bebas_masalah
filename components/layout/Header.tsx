'use client';

import { Menu, Bell, GraduationCap, Search } from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { getInitials } from '@/lib/utils';
import { ROLE_LABELS } from '@/lib/menu-config';

interface HeaderProps {
  onMenuClick: () => void;
}

export default function Header({ onMenuClick }: HeaderProps) {
  const { user } = useAuth();

  return (
    <header
      className={[
        'fixed top-0 right-0 z-30 h-16',
        // On desktop, offset by sidebar width; on mobile: full width
        'left-0 md:left-[240px]',
        'bg-white border-b border-slate-100',
        'flex items-center px-4 md:px-6 gap-4',
        'shadow-sm',
      ].join(' ')}
    >
      {/* ── Hamburger (mobile only) ── */}
      <button
        onClick={onMenuClick}
        id="btn-sidebar-toggle"
        className="md:hidden flex-shrink-0 p-2 rounded-lg text-slate-500
                   hover:bg-slate-100 hover:text-slate-700 transition-colors"
        aria-label="Buka menu navigasi"
      >
        <Menu className="w-5 h-5" />
      </button>

      {/* Mobile logo (when sidebar hidden) */}
      <div className="md:hidden flex items-center gap-2 flex-shrink-0">
        <div className="w-7 h-7 bg-blue-600 rounded-lg flex items-center justify-center">
          <GraduationCap className="w-4 h-4 text-white" />
        </div>
        <span className="text-sm font-semibold text-slate-800">Kompen</span>
      </div>

      {/* ── Search bar (desktop, decorative for now) ── */}
      <div className="hidden md:flex items-center gap-2 flex-1 max-w-xs bg-slate-50 border border-slate-200 rounded-lg px-3 py-2">
        <Search className="w-4 h-4 text-slate-400 flex-shrink-0" />
        <span className="text-sm text-slate-400">Cari...</span>
      </div>

      {/* ── Spacer ── */}
      <div className="flex-1" />

      {/* ── Semester tag ── */}
      <div className="hidden sm:flex items-center">
        <span className="text-xs font-medium text-slate-500 bg-slate-100 px-3 py-1.5 rounded-full">
          Semester Aktif
        </span>
      </div>

      {/* ── Notification bell ── */}
      <button
        className="relative p-2 rounded-lg text-slate-500 hover:bg-slate-100
                   hover:text-slate-700 transition-colors"
        aria-label="Notifikasi"
      >
        <Bell className="w-5 h-5" />
        {/* Indicator dot */}
        <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-blue-500 rounded-full ring-2 ring-white" />
      </button>

      {/* ── Avatar (desktop) ── */}
      <div className="hidden md:flex items-center gap-3">
        <div className="text-right min-w-0">
          <p className="text-sm font-medium text-slate-800 leading-tight truncate max-w-[140px]">
            {user?.displayName ?? '...'}
          </p>
          <p className="text-xs text-slate-500 capitalize">
            {user?.roleName ? ROLE_LABELS[user.roleName] ?? user.roleName : '—'}
          </p>
        </div>
        <div className="w-9 h-9 rounded-full bg-blue-600 flex items-center justify-center flex-shrink-0 text-white text-xs font-bold shadow-sm">
          {user?.displayName ? getInitials(user.displayName) : '?'}
        </div>
      </div>
    </header>
  );
}
