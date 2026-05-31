import prisma from '@/lib/prisma'
import { cookies } from 'next/headers'

/**
 * Mengambil NIP staf yang sedang login dari cookie sesi.
 * Tidak ada NIP yang di-hardcode — bila cookie tidak ada / tidak valid,
 * mengembalikan null sehingga pemanggil bisa menolak operasi.
 */
export async function getCurrentStaffNip(): Promise<string | null> {
  const cookieStore = await cookies()
  const nip = cookieStore.get('nip')?.value
  if (!nip) return null

  const staf = await prisma.staf.findUnique({
    where: { nip },
    select: { nip: true },
  })
  return staf?.nip ?? null
}
