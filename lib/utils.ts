// ============================================================
// FORMAT HELPERS
// ============================================================

/**
 * Format angka ke Rupiah.
 * Contoh: 50000 → "Rp 50.000"
 */
export const formatRupiah = (n: number): string =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
  }).format(n);

/**
 * Format jam ke string.
 * Contoh: 8 → "8 jam"
 */
export const formatJam = (n: number): string => `${n} jam`;

/**
 * Format tanggal ISO ke tanggal lokal Indonesia.
 * Contoh: "2025-08-01" → "1 Agustus 2025"
 */
export const formatTanggal = (s: string): string =>
  new Date(s).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  });

/**
 * Format tanggal + waktu.
 * Contoh: "2025-08-01T10:30:00Z" → "1 Agustus 2025, 10.30"
 */
export const formatTanggalWaktu = (s: string): string =>
  new Date(s).toLocaleString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });

/**
 * Ambil inisial dari nama lengkap (maks 2 kata).
 * Contoh: "Achmad Naufal Hakim" → "AN"
 */
export const getInitials = (nama: string): string =>
  nama
    .split(' ')
    .slice(0, 2)
    .map((w) => w[0])
    .join('')
    .toUpperCase();

// ============================================================
// STATUS BADGE HELPERS
// ============================================================

export type BadgeVariant =
  | 'yellow'
  | 'blue'
  | 'green'
  | 'red'
  | 'purple'
  | 'slate';

interface BadgeStyle {
  className: string;
  label: string;
}

/**
 * Mapping status_tugas_id → badge style
 * IDs are fixed by DB constraint — do not change.
 *  1 = proses, 2 = verifikasi, 3 = selesai, 4 = ditolak, 5 = auto_assigned
 */
export const getStatusTugasBadge = (statusId: number): BadgeStyle => {
  const map: Record<number, BadgeStyle> = {
    1: {
      className:
        'bg-yellow-100 text-yellow-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Proses',
    },
    2: {
      className:
        'bg-blue-100 text-blue-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Verifikasi',
    },
    3: {
      className:
        'bg-green-100 text-green-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Selesai',
    },
    4: {
      className:
        'bg-red-100 text-red-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Ditolak',
    },
    5: {
      className:
        'bg-purple-100 text-purple-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Auto Assigned',
    },
  };
  return (
    map[statusId] ?? {
      className:
        'bg-slate-100 text-slate-600 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Unknown',
    }
  );
};

/**
 * Mapping status_ekuivalensi_id → badge style
 *  1 = pending, 2 = approved, 3 = rejected
 */
export const getStatusEkuivalensiBadge = (statusId: number): BadgeStyle => {
  const map: Record<number, BadgeStyle> = {
    1: {
      className:
        'bg-yellow-100 text-yellow-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Pending',
    },
    2: {
      className:
        'bg-green-100 text-green-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Disetujui',
    },
    3: {
      className:
        'bg-red-100 text-red-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Ditolak',
    },
  };
  return (
    map[statusId] ?? {
      className:
        'bg-slate-100 text-slate-600 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Unknown',
    }
  );
};

/**
 * Mapping status_import_id → badge style
 *  1 = proses, 2 = selesai, 3 = gagal
 */
export const getStatusImportBadge = (statusId: number): BadgeStyle => {
  const map: Record<number, BadgeStyle> = {
    1: {
      className:
        'bg-yellow-100 text-yellow-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Proses',
    },
    2: {
      className:
        'bg-green-100 text-green-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Selesai',
    },
    3: {
      className:
        'bg-red-100 text-red-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Gagal',
    },
  };
  return (
    map[statusId] ?? {
      className:
        'bg-slate-100 text-slate-600 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Unknown',
    }
  );
};

/**
 * Tipe pekerjaan badge:
 *  1 = internal (biru), 2 = eksternal (amber)
 */
export const getTipePekerjaanBadge = (tipeId: number): BadgeStyle => {
  const map: Record<number, BadgeStyle> = {
    1: {
      className:
        'bg-blue-100 text-blue-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Internal',
    },
    2: {
      className:
        'bg-amber-100 text-amber-800 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Eksternal',
    },
  };
  return (
    map[tipeId] ?? {
      className:
        'bg-slate-100 text-slate-600 rounded-full px-2 py-0.5 text-xs font-medium',
      label: 'Lainnya',
    }
  );
};

// ============================================================
// MISC HELPERS
// ============================================================

/**
 * Hitung persentase progres (antara 0–100).
 */
export const calcProgress = (done: number, total: number): number => {
  if (!total || total === 0) return 0;
  return Math.min(100, Math.round((done / total) * 100));
};

/**
 * Clamping a number between min & max.
 */
export const clamp = (value: number, min: number, max: number): number =>
  Math.min(Math.max(value, min), max);

/**
 * Delay helper untuk penggunaan di async flow.
 */
export const sleep = (ms: number): Promise<void> =>
  new Promise((resolve) => setTimeout(resolve, ms));

/**
 * Cek apakah error Supabase adalah unique constraint violation (code 23505).
 */
export const isUniqueViolation = (error: { code?: string } | null): boolean =>
  error?.code === '23505';

/**
 * Cek apakah error Supabase adalah FK violation (code 23503).
 */
export const isFKViolation = (error: { code?: string } | null): boolean =>
  error?.code === '23503';

/**
 * Ambil pesan error yang human-readable dari Supabase error.
 * Trigger RAISE EXCEPTION sudah human-readable, jadi langsung pakai .message.
 */
export const getErrorMessage = (error: unknown): string => {
  if (!error) return 'Terjadi kesalahan tidak diketahui';
  if (typeof error === 'string') return error;
  if (error instanceof Error) return error.message;
  if (typeof error === 'object' && 'message' in error) {
    return String((error as { message: unknown }).message);
  }
  return 'Terjadi kesalahan tidak diketahui';
};
