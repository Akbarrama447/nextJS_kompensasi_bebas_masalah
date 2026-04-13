'use client';

import { ReactNode } from 'react';
import { FileX, PlusCircle } from 'lucide-react';

interface EmptyStateProps {
  title?: string;
  description?: string;
  icon?: ReactNode;
  action?: {
    label: string;
    onClick: () => void;
  };
}

/**
 * EmptyState — tampilkan saat tabel / list kosong.
 */
export default function EmptyState({
  title = 'Belum ada data',
  description = 'Data akan muncul di sini setelah ditambahkan.',
  icon,
  action,
}: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
      <div className="w-16 h-16 rounded-2xl bg-slate-100 flex items-center justify-center mb-4">
        {icon ?? <FileX className="w-7 h-7 text-slate-400" />}
      </div>
      <h3 className="text-sm font-semibold text-slate-700 mb-1">{title}</h3>
      <p className="text-xs text-slate-400 max-w-xs leading-relaxed">{description}</p>
      {action && (
        <button
          onClick={action.onClick}
          className="btn-primary mt-5"
        >
          <PlusCircle className="w-4 h-4" />
          {action.label}
        </button>
      )}
    </div>
  );
}
