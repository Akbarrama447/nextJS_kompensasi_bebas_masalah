'use client';

import { getStatusTugasBadge, getStatusEkuivalensiBadge, getStatusImportBadge, getTipePekerjaanBadge } from '@/lib/utils';

type BadgeType = 'status_tugas' | 'ekuivalensi' | 'import' | 'tipe_pekerjaan';

interface StatusBadgeProps {
  id: number;
  type: BadgeType;
  /** Override label teks */
  label?: string;
}

/**
 * StatusBadge — selalu tampilkan nama (dari helper), bukan angka mentah.
 */
export default function StatusBadge({ id, type, label }: StatusBadgeProps) {
  let style: { className: string; label: string };

  switch (type) {
    case 'status_tugas':
      style = getStatusTugasBadge(id);
      break;
    case 'ekuivalensi':
      style = getStatusEkuivalensiBadge(id);
      break;
    case 'import':
      style = getStatusImportBadge(id);
      break;
    case 'tipe_pekerjaan':
      style = getTipePekerjaanBadge(id);
      break;
    default:
      style = { className: 'badge badge-slate', label: String(id) };
  }

  return (
    <span className={`badge ${style.className}`}>
      {label ?? style.label}
    </span>
  );
}
