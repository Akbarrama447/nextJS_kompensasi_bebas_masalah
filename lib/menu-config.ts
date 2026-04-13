/**
 * ALL_MENUS — sumber kebenaran untuk sidebar navigation.
 *
 * Sidebar TIDAK hardcode menu per role.
 * Sidebar memfilter array ini berdasarkan roles.key_menu yang tersimpan di DB.
 *
 * SEED DATA terbaru untuk tabel roles.key_menu:
 *   superadmin : ["dashboard", "semester", "pengaturan", "users", "pekerjaan", "ekuivalensi"]
 *   dosen      : ["dashboard", "pekerjaan", "ekuivalensi"]
 *   kalab      : ["dashboard", "pekerjaan", "ekuivalensi"]
 *   laboran    : ["dashboard", "pekerjaan"]
 *   mahasiswa  : ["dashboard", "kompen_saya", "pekerjaan", "ekuivalensi"]
 *
 * CATATAN ARSITEKTUR:
 *   - 'import'      → Action button di /dashboard/pekerjaan (Tab Kelola Pekerjaan)
 *   - 'generate'    → Action button di /dashboard/pekerjaan (Tab Kelola Pekerjaan)
 *   - 'verifikasi'  → Tab Penugasan di /dashboard/pekerjaan
 *   - 'penugasan'   → Tab Penugasan di /dashboard/pekerjaan
 *   Keempatnya TIDAK muncul di sidebar agar UX lebih bersih.
 */

export interface MenuConfig {
  key: string;
  label: string;
  icon: string; // Nama Lucide icon
  href: string;
}

export const ALL_MENUS: MenuConfig[] = [
  {
    key: 'dashboard',
    label: 'Dashboard',
    icon: 'LayoutDashboard',
    href: '/dashboard',
  },
  {
    key: 'pekerjaan',
    label: 'Daftar Pekerjaan',
    icon: 'Briefcase',
    href: '/pekerjaan',
  },
  {
    key: 'kompen_saya',
    label: 'Kompen Saya',
    icon: 'User',
    href: '/kompen-saya',
  },
  {
    key: 'ekuivalensi',
    label: 'Ekuivalensi',
    icon: 'FileText',
    href: '/ekuivalensi',
  },
  {
    key: 'semester',
    label: 'Semester',
    icon: 'Calendar',
    href: '/semester',
  },
  {
    key: 'pengaturan',
    label: 'Pengaturan Sistem',
    icon: 'Settings',
    href: '/pengaturan',
  },
  {
    key: 'users',
    label: 'Manajemen User',
    icon: 'Users',
    href: '/users',
  },
];

/**
 * Key-key yang digunakan untuk feature-gating di dalam halaman
 * (bukan routing/sidebar), misalnya menampilkan tombol Import atau
 * tab Penugasan di dalam /dashboard/pekerjaan.
 *
 * Sidebar tidak merender key ini, tapi komponen halaman bisa
 * menggunakan useHasMenu() untuk cek aksesnya.
 */
export const FEATURE_KEYS = {
  IMPORT: 'import',
  GENERATE: 'generate',
  VERIFIKASI: 'verifikasi',
  PENUGASAN: 'penugasan',
} as const;

/**
 * Filter menu berdasarkan key_menu dari roles table.
 * - Jika key_menu null/empty → hanya tampilkan 'dashboard'
 * - Jika ada key yang tidak match ALL_MENUS → skip dengan silent (graceful fallback)
 * - Key seperti 'import','generate','verifikasi','penugasan' tidak ada di ALL_MENUS
 *   sehingga otomatis tidak muncul di sidebar — mereka hanya digunakan untuk
 *   feature-gating di dalam komponen halaman via useHasMenu().
 */
export function getVisibleMenus(keyMenu: string[] | null | undefined): MenuConfig[] {
  if (!keyMenu || keyMenu.length === 0) {
    return ALL_MENUS.filter((m) => m.key === 'dashboard');
  }

  const keySet = new Set(keyMenu);
  // Filter ALL_MENUS — keys tidak ada di ALL_MENUS akan ter-skip otomatis
  return ALL_MENUS.filter((m) => keySet.has(m.key));
}

/**
 * Role slug ke display label.
 */
export const ROLE_LABELS: Record<string, string> = {
  superadmin: 'Super Admin',
  dosen: 'Dosen',
  kalab: 'Ka. Lab',
  laboran: 'Laboran',
  mahasiswa: 'Mahasiswa',
};
