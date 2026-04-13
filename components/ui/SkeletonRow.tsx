'use client';

interface SkeletonRowProps {
  cols?: number;
  rows?: number;
}

/**
 * SkeletonRow — placeholder loading state untuk tabel.
 * Gunakan di dalam <tbody> tag.
 */
export function SkeletonRow({ cols = 5, rows = 5 }: SkeletonRowProps) {
  return (
    <>
      {Array.from({ length: rows }).map((_, ri) => (
        <tr key={ri}>
          {Array.from({ length: cols }).map((_, ci) => (
            <td key={ci} className="px-4 py-3.5 border-t border-slate-100">
              <div
                className="skeleton h-4 rounded"
                style={{ width: ci === 0 ? '40px' : `${60 + (ci * 17) % 40}%` }}
              />
            </td>
          ))}
        </tr>
      ))}
    </>
  );
}

/**
 * SkeletonCard — placeholder untuk card metric.
 */
export function SkeletonCard() {
  return (
    <div className="card animate-pulse space-y-3">
      <div className="skeleton h-3 w-1/3 rounded" />
      <div className="skeleton h-8 w-1/2 rounded" />
      <div className="skeleton h-3 w-2/3 rounded" />
    </div>
  );
}
