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