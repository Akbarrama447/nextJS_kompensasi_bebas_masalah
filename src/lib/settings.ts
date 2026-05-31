import prisma from '@/lib/prisma'

/**
 * Helper terpusat untuk membaca konfigurasi sistem dari tabel `pengaturan_sistem`.
 * Tidak ada nilai yang di-hardcode di logika bisnis — semua diambil dari DB.
 * Parameter `fallback` hanya dipakai bila key benar-benar belum ada di DB.
 */
export async function getSetting(key: string, fallback?: string): Promise<string | null> {
  try {
    const row = await prisma.pengaturan_sistem.findUnique({
      where: { key },
      select: { value: true },
    })
    return row?.value ?? fallback ?? null
  } catch (error) {
    console.error(`Error reading setting "${key}":`, error)
    return fallback ?? null
  }
}

export async function getNumericSetting(key: string, fallback: number): Promise<number> {
  const raw = await getSetting(key)
  if (raw === null) return fallback
  const parsed = Number(raw)
  return Number.isFinite(parsed) ? parsed : fallback
}

/** Tarif konversi 1 jam kompen ke rupiah untuk pengajuan ekuivalensi. */
export async function getTarifPerJam(): Promise<number> {
  return getNumericSetting('tarif_ekuivalensi_per_jam', 2000)
}
