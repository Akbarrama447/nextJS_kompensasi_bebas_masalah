'use client';

import { usePathname } from 'next/navigation';
import Link from 'next/link';
import {
  LayoutDashboard,
  Briefcase,
  User,
  FileText,
  Calendar,
  Settings,
  Users,
  GraduationCap,
  ChevronRight,
  LogOut,
} from 'lucide-react';
import { useAuth } from '@/contexts/AuthContext';
import { getVisibleMenus, ROLE_LABELS } from '@/lib/menu-config';
import { getInitials } from '@/lib/utils';

// Map icon string → Lucide component
// Hanya berisi ikon yang benar-benar ada di ALL_MENUS
const ICON_MAP: Record<string, React.ElementType> = {
  LayoutDashboard,
  Briefcase,
  User,
  FileText,
  Calendar,
  Settings,
  Users,
};

interface SidebarProps {
  open: boolean;
  onClose: () => void;
}

export default function Sidebar({ open, onClose }: SidebarProps) {
  const pathname = usePathname();
  const { user, signOut } = useAuth();

  const visibleMenus = getVisibleMenus(user?.keyMenu ?? null);

  // A menu item is active if the pathname exactly matches OR starts with href
  // (except dashboard which must be exact to avoid matching everything)
  const isActive = (href: string) => {
    if (href === '/dashboard') return pathname === '/dashboard';
    return pathname.startsWith(href);
  };

  return (
    <>
      {/* ── Mobile Backdrop ── */}
      {open && (
        <div
          className="sidebar-backdrop"
          onClick={onClose}
          aria-hidden="true"
        />
      )}

      {/* ── Sidebar Panel ── */}
      <aside
        className={[
          // Base: fixed, full-height, above content
          'fixed top-0 left-0 h-full z-50 flex flex-col',
          'bg-slate-900 text-slate-300',
          // Width
          'w-[240px]',
          // Desktop: always visible — Mobile: slide in/out
          'transition-transform duration-250 ease-in-out',
          'md:translate-x-0',
          open ? 'translate-x-0' : '-translate-x-full',
        ].join(' ')}
        aria-label="Sidebar navigasi"
      >
        {/* Logo */}
        <div className="flex items-center gap-3 px-5 h-16 border-b border-slate-800 flex-shrink-0">
          <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center flex-shrink-0 shadow-lg shadow-blue-900/40">
            <GraduationCap className="w-4 h-4 text-white" />
          </div>
          <div className="min-w-0">
            <p className="text-white text-sm font-semibold truncate leading-tight">
              Sistem Kompen
            </p>
            <p className="text-slate-500 text-[10px] truncate">Polines</p>
          </div>
        </div>

        {/* Nav menu — scrollable */}
        <nav className="flex-1 overflow-y-auto py-4 px-3 space-y-0.5">
          {visibleMenus.map((menu) => {
            const Icon = ICON_MAP[menu.icon] ?? LayoutDashboard;
            const active = isActive(menu.href);

            return (
              <Link
                key={menu.key}
                href={menu.href}
                onClick={onClose}
                className={[
                  'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium',
                  'transition-colors duration-150 group',
                  active
                    ? 'bg-slate-700 text-white'
                    : 'text-slate-400 hover:bg-slate-800 hover:text-slate-200',
                ].join(' ')}
                aria-current={active ? 'page' : undefined}
              >
                <Icon
                  className={[
                    'w-4 h-4 flex-shrink-0 transition-colors',
                    active ? 'text-blue-400' : 'text-slate-500 group-hover:text-slate-300',
                  ].join(' ')}
                />
                <span className="truncate flex-1">{menu.label}</span>
                {active && (
                  <ChevronRight className="w-3 h-3 text-blue-400 flex-shrink-0" />
                )}
              </Link>
            );
          })}
        </nav>

        {/* User profile + sign out */}
        <div className="border-t border-slate-800 p-3 flex-shrink-0">
          <div className="flex items-center gap-3 px-2 py-2">
            {/* Avatar */}
            <div className="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center flex-shrink-0 text-white text-xs font-bold">
              {user?.displayName ? getInitials(user.displayName) : '?'}
            </div>
            {/* Info */}
            <div className="min-w-0 flex-1">
              <p className="text-slate-200 text-sm font-medium truncate leading-tight">
                {user?.displayName ?? '...'}
              </p>
              <p className="text-slate-500 text-[11px] truncate capitalize">
                {user?.roleName ? ROLE_LABELS[user.roleName] ?? user.roleName : '—'}
              </p>
            </div>
          </div>

          {/* Sign out */}
          <button
            onClick={signOut}
            className="w-full mt-1.5 flex items-center gap-2 px-3 py-2 rounded-lg
                       text-slate-400 hover:bg-red-900/30 hover:text-red-400
                       text-xs font-medium transition-colors duration-150"
          >
            <LogOut className="w-3.5 h-3.5 flex-shrink-0" />
            Keluar
          </button>
        </div>
      </aside>
    </>
  );
}
