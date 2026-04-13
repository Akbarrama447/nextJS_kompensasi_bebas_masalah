'use client';

import { useEffect, useRef, ReactNode } from 'react';
import { X } from 'lucide-react';
import { createPortal } from 'react-dom';

// ─────────────────────────────────────────
// Types
// ─────────────────────────────────────────

interface ModalProps {
  /** Judul header modal */
  title: ReactNode;
  /** Konten utama modal (akan di-scroll jika overflow) */
  children: ReactNode;
  /** Footer sticky di bagian bawah (buttons, actions) */
  footer?: ReactNode;
  /** Kontrol visibility */
  open: boolean;
  /** Callback saat modal ditutup */
  onClose: () => void;
  /** Ukuran modal (hanya berlaku di desktop/ md+) */
  size?: 'sm' | 'md' | 'lg' | 'xl';
  /** Tutup modal saat klik backdrop */
  closeOnBackdrop?: boolean;
  /** Max height badan modal sebelum scroll, default 60vh */
  maxBodyHeight?: string;
}

const sizeMap: Record<string, string> = {
  sm: 'md:max-w-sm',
  md: 'md:max-w-lg',
  lg: 'md:max-w-2xl',
  xl: 'md:max-w-4xl',
};

// ─────────────────────────────────────────
// Component
// ─────────────────────────────────────────

export default function Modal({
  title,
  children,
  footer,
  open,
  onClose,
  size = 'md',
  closeOnBackdrop = true,
  maxBodyHeight = '60vh',
}: ModalProps) {
  const contentRef = useRef<HTMLDivElement>(null);

  // Lock body scroll when modal open
  useEffect(() => {
    if (open) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [open]);

  // Close on Escape key
  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && open) onClose();
    };
    window.addEventListener('keydown', handleKey);
    return () => window.removeEventListener('keydown', handleKey);
  }, [open, onClose]);

  if (!open) return null;

  const modalElement = (
    /* ── Backdrop ── */
    <div
      className="modal-backdrop fixed inset-0 z-[100] flex items-end md:items-center justify-center bg-black/50 backdrop-blur-sm"
      onClick={closeOnBackdrop ? onClose : undefined}
      aria-modal="true"
      role="dialog"
      aria-labelledby="modal-title"
    >
      {/*
        ── Modal Panel ──
        Mobile: bottom sheet (rounded-t-2xl, slide-up animation)
        Desktop: centered dialog (rounded-2xl)
      */}
      <div
        ref={contentRef}
        onClick={(e) => e.stopPropagation()}
        className={[
          'modal-content bg-white w-full flex flex-col',
          // Mobile: bottom sheet
          'rounded-t-2xl max-h-[92dvh]',
          // Desktop: centered dialog
          `md:rounded-2xl md:shadow-xl md:mx-4 ${sizeMap[size]}`,
          // Ensure it doesn't overflow viewport
          'overflow-hidden',
        ].join(' ')}
        style={{ maxHeight: '92dvh' }}
      >
        {/* ── Header ── */}
        <div className="flex items-start justify-between gap-4 px-6 py-4 border-b border-slate-100 flex-shrink-0">
          <div id="modal-title" className="flex-1 min-w-0">
            {typeof title === 'string' ? (
              <h2 className="text-base font-semibold text-slate-900 leading-snug">
                {title}
              </h2>
            ) : (
              title
            )}
          </div>
          <button
            onClick={onClose}
            className="flex-shrink-0 p-1.5 rounded-lg text-slate-400 hover:bg-slate-100
                       hover:text-slate-600 transition-colors"
            aria-label="Tutup modal"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* ── Scrollable Body ── */}
        <div
          className="flex-1 overflow-y-auto px-6 py-5"
          style={{ maxHeight: maxBodyHeight }}
        >
          {children}
        </div>

        {/* ── Sticky Footer (optional) ── */}
        {footer && (
          <div className="flex-shrink-0 px-6 py-4 border-t border-slate-100 bg-white">
            {footer}
          </div>
        )}
      </div>
    </div>
  );

  // Render via portal to avoid stacking context issues
  if (typeof window === 'undefined') return null;
  return createPortal(modalElement, document.body);
}

// ─────────────────────────────────────────
// Modal Footer helper components
// ─────────────────────────────────────────

/**
 * Standar footer dengan dua tombol: kiri (cancel/danger) + kanan (confirm/primary).
 * Otomatis stack vertikal di mobile, horizontal di desktop.
 */
export function ModalFooter({
  children,
  align = 'between',
}: {
  children: ReactNode;
  align?: 'between' | 'end' | 'start';
}) {
  const alignClass =
    align === 'between'
      ? 'justify-between'
      : align === 'end'
      ? 'justify-end'
      : 'justify-start';

  return (
    <div
      className={`flex flex-col-reverse sm:flex-row gap-3 ${alignClass}`}
    >
      {children}
    </div>
  );
}
