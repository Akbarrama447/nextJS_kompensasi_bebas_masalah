export interface PekerjaanForm {
  judul: string;
  deskripsi?: string;
  tipe_pekerjaan_id: number;
  poin_jam: number;
  kategori?: number;
  quota?: number;
  tanggal_mulai?: string;
  tanggal_selesai: string;
  ruangan_id?: number;
  semester_id?: number;
}

export interface PekerjaanRow {
  id: number;
  judul: string;
  tipe: string;
  poin: number;
  kuotatersisa: number;
  kuotatotal: number;
  tanggal_mulai: string | null;
  tanggal_selesai: string | null;
  is_aktif: boolean;
  created_at: string;
  staf?: {
    nip: string;
    nama: string;
  };
  ruangan?: {
    id: number;
    nama_ruangan: string;
  };
  tipe_pekerjaan?: {
    id: number;
    nama: string;
  };
}

export interface OptionsData {
  tipe_pekerjaan: { id: number; nama: string }[];
  ruangan: { id: number; nama_ruangan: string; gedung?: string }[];
  semester_aktif: { id: number; nama: string } | null;
}

export interface PlottingConfig {
  semester_id?: number;
  maxJamPerHari?: number;
  sortBy?: 'nim' | 'jam_kompen';
}

export interface PlottingAssignment {
  nim: string;
  nama: string;
  jam_diberi: number;
}

export interface PlottingPekerjaanResult {
  pekerjaan_id: number;
  pekerjaan: string;
  assignments: PlottingAssignment[];
}

export interface PlottingResult {
  success: boolean;
  processedCount?: number;
  assignmentCount?: number;
  results?: PlottingPekerjaanResult[];
  error?: string;
}

export interface CreateResult {
  success: boolean;
  id?: number;
  error?: string;
}

export interface DeleteResult {
  success: boolean;
  error?: string;
}

export interface PenugasanRow {
  id: number;
  nim: string;
  mahasiswa_nama: string;
  pekerjaan_id: number;
  pekerjaan_judul: string;
  poin_jam: number;
  status_tugas_id: number;
  status_nama: string;
  created_at: string;
  catatan_verifikasi: string | null;
  diverifikasi_oleh_nip: string | null;
  waktu_verifikasi: string | null;
}

export interface VerifyParams {
  penugasan_id: number;
  verifikasi_oleh_nip: string;
}

export interface RejectParams {
  penugasan_id: number;
  catatan_verifikasi: string;
}

export interface VerifyResult {
  success: boolean;
  error?: string;
}

export interface GetDaftarPenugasanParams {
  semester_id?: number;
  status_filter?: 'pending' | 'selesai' | 'semua';
  limit?: number;
  offset?: number;
  search?: string;
}

export interface GetDaftarPenugasanResult {
  data: PenugasanRow[];
  total: number;
}

export interface MahasiswaKompenRow {
  nim: string;
  nama: string;
  total_jam_wajib: number;
  jam_sudah_dikurangi: number;
  jam_sisa: number;
  status_tugas_id: number | null;
  status_nama: string | null;
  pekerjaan_id: number | null;
  pekerjaan_judul: string | null;
  poin_jam: number | null;
  penugasan_id: number | null;
  created_at: string | null;
  penugasans?: {
    id: number;
    pekerjaan_id: number | null;
    pekerjaan_judul: string | null;
    poin_jam: number | null;
    status_tugas_id: number | null;
    status_nama: string | null;
    created_at: string | null;
  }[];
}

export interface GetDaftarKompenParams {
  semester_id?: number;
  status_filter?: 'belum_ditugaskan' | 'sedang_dikerjakan' | 'selesai' | 'semua';
  limit?: number;
  offset?: number;
  search?: string;
}

export interface GetDaftarKompenResult {
  data: MahasiswaKompenRow[];
  total: number;
}