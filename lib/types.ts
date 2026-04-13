// ============================================================
// REF TABLES
// ============================================================

export interface RefStatusTugas {
  id: number;
  nama: string;
}

export interface RefTipePekerjaan {
  id: number;
  nama: string;
}

export interface RefStatusEkuivalensi {
  id: number;
  nama: string;
}

export interface RefStatusImport {
  id: number;
  nama: string;
}

// ============================================================
// MASTER DATA
// ============================================================

export interface Semester {
  id: number;
  nama: string;
  tahun: number;
  periode: string;
  is_aktif: boolean;
  mulai: string;
  selesai: string;
}

export interface Jurusan {
  id: number;
  nama_jurusan: string;
}

export interface Prodi {
  id: number;
  jurusan_id: number;
  nama_prodi: string;
}

export interface Kelas {
  id: number;
  prodi_id: number;
  nama_kelas: string;
}

export interface Gedung {
  id: number;
  jurusan_id: number;
  nama_gedung: string;
}

export interface Ruangan {
  id: number;
  gedung_id: number;
  nama_ruangan: string;
  kode_ruangan: string;
}

// ============================================================
// AUTH & USERS
// ============================================================

export interface Role {
  id: number;
  nama: string;
  key_menu: string[] | null;
  key_condition: Record<string, unknown> | null;
}

export interface User {
  user_id: number;
  email: string;
  kata_sandi: string;
  role_id: number;
  dibuat_pada: string;
}

export interface Mahasiswa {
  nim: string;
  user_id: number;
  nama: string;
  kelas_id: number;
}

export interface Staf {
  nip: string;
  user_id: number;
  nama: string;
  jurusan_id: number;
  tipe_staf: string;
}

// ============================================================
// VIEWS
// ============================================================

export interface VSisaKompen {
  nim: string;
  semester_id: number;
  total_jam_wajib: number;
  jam_selesai: number;
  sisa_jam: number;
}

export interface VMahasiswaDetail {
  nim: string;
  nama: string;
  kelas_id: number;
  nama_kelas: string;
  prodi_id: number;
  nama_prodi: string;
  jurusan_id: number;
  nama_jurusan: string;
}

// ============================================================
// CORE TABLES
// ============================================================

export interface ImportLog {
  id: number;
  staf_nip: string;
  semester_id: number;
  nama_file: string;
  total_baris: number;
  sukses_baris: number;
  error_details: ImportErrorDetail[] | null;
  status_import_id: number;
  created_at: string;
}

export interface ImportErrorDetail {
  nim: string;
  nama: string;
  error: string;
}

export interface KompenAwal {
  id: number;
  nim: string;
  semester_id: number;
  import_id: number;
  total_jam_wajib: number;
  created_at: string;
}

export interface DaftarPekerjaan {
  id: number;
  staf_nip: string;
  semester_id: number;
  judul: string;
  deskripsi: string;
  tipe_pekerjaan_id: number;
  poin_jam: number;
  kuota: number | null;
  ruangan_id: number | null;
  is_aktif: boolean;
  tanggal_mulai: string;
  tanggal_selesai: string | null;
  created_at: string;
}

// detail_pengerjaan shapes — stored as JSONB in penugasan
export interface DetailInternal {
  foto_mulai: string;
  meta_mulai: {
    lat: number;
    lng: number;
    ts: string;
    device: string;
  };
  foto_selesai: string;
  meta_selesai: {
    lat: number;
    lng: number;
    ts: string;
    device: string;
  };
}

export interface DetailEksternal {
  foto_nota: string;
  nominal: number;
}

export interface Penugasan {
  id: number;
  pekerjaan_id: number;
  nim: string;
  status_tugas_id: number;
  detail_pengerjaan: DetailInternal | DetailEksternal | null;
  catatan_verifikasi: string | null;
  diverifikasi_oleh_nip: string | null;
  waktu_verifikasi: string | null;
  created_at: string;
}

export interface EkuivalensiKelas {
  id: number;
  kelas_id: number;
  semester_id: number;
  penanggung_jawab_nim: string;
  nota_url: string;
  nominal_total: number;
  jam_diakui: number;
  status_ekuivalensi_id: number;
  verified_by_nip: string | null;
  catatan: string | null;
  created_at: string;
}

export interface LogPotongJam {
  id: number;
  nim: string;
  semester_id: number;
  penugasan_id: number | null;
  ekuivalensi_id: number | null;
  jam_dikurangi: number;
  keterangan: string;
  dibuat_pada: string;
}

export interface PengaturanSistem {
  id: number;
  grup: string;
  key: string;
  value: string;
  tipe_data: 'string' | 'integer' | 'float' | 'boolean';
  keterangan: string;
}

export interface Menu {
  id: number;
  key: string;
  label: string;
  icon: string | null;
  path: string;
  urutan: number;
  parent_id: number | null;
  created_at: string;
}

// ============================================================
// APP-LEVEL CONTEXT TYPES
// ============================================================

export type RoleSlug =
  | 'superadmin'
  | 'dosen'
  | 'kalab'
  | 'laboran'
  | 'mahasiswa';

export interface AppUser {
  // from supabase auth
  authId: string;
  email: string;
  // from users table
  userId: number;
  roleId: number;
  // from roles table
  roleName: RoleSlug;
  keyMenu: string[];
  // from mahasiswa OR staf table
  profile: Mahasiswa | Staf | null;
  // display helpers
  displayName: string;
}

// ============================================================
// STATUS ID CONSTANTS (never change — DB trigger depends on them)
// ============================================================

export const STATUS_TUGAS = {
  PROSES: 1,
  VERIFIKASI: 2,
  SELESAI: 3,
  DITOLAK: 4,
  AUTO_ASSIGNED: 5,
} as const;

export const STATUS_IMPORT = {
  PROSES: 1,
  SELESAI: 2,
  GAGAL: 3,
} as const;

export const STATUS_EKUIVALENSI = {
  PENDING: 1,
  APPROVED: 2,
  REJECTED: 3,
} as const;
