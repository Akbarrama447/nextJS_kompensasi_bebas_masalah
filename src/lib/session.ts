import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'

export interface SessionInfo {
  identifier: string
  nama: string
}

/**
 * Validates that the current request has a valid superadmin session.
 * Superadmin = staf dengan tipe_staf='superadmin' atau role admin (role_id=3).
 * Throws an error if unauthorized.
 */
export async function requireSuperadmin(): Promise<SessionInfo> {
  const cookieStore = await cookies()
  const nip = cookieStore.get('nip')?.value

  if (!nip) {
    throw new Error('Unauthorized: Tidak ada session login')
  }

  const staf = await prisma.staf.findUnique({
    where: { nip },
    include: {
      user: {
        include: { role: true }
      }
    }
  })

  if (!staf) {
    throw new Error('Unauthorized: Data staf tidak ditemukan')
  }

  // Superadmin = role 'Super Admin' atau tipe_staf='superadmin'
  const roleName = staf.user?.role?.nama?.toLowerCase() || ''
  const isSuperadmin =
    staf.tipe_staf === 'superadmin' ||
    roleName === 'super admin' ||
    roleName === 'admin'

  if (!isSuperadmin) {
    throw new Error('Unauthorized: Hanya superadmin yang dapat mengakses fitur ini')
  }

  return {
    identifier: nip,
    nama: staf.nama || 'Superadmin',
  }
}

/**
 * Mendapatkan informasi session saat ini tanpa throw error.
 * Returns null jika tidak ada session valid.
 */
export async function getSession(): Promise<SessionInfo | null> {
  try {
    return await requireSuperadmin()
  } catch {
    return null
  }
}
