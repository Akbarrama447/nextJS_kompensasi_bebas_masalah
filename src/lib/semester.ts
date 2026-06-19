import prisma from '@/lib/prisma'

/**
 * Mengembalikan ID semester aktif (is_aktif = true).
 * Fallback ke semester terbaru bila belum ada yang ditandai aktif.
 * Mengembalikan null bila tabel semester benar-benar kosong.
 */
export async function getActiveSemesterId(): Promise<number | null> {
  const active = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true },
  })
  if (active) return active.id

  const latest = await prisma.semester.findFirst({
    orderBy: [{ tahun: 'desc' }, { id: 'desc' }],
    select: { id: true },
  })
  return latest?.id ?? null
}

/**
 * Resolusi semester yang dipakai untuk sebuah query:
 * pakai semester yang diminta jika ada, kalau tidak pakai semester aktif.
 */
export async function resolveSemesterId(requested?: number): Promise<number | null> {
  if (requested) return requested
  return getActiveSemesterId()
}
