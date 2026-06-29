import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export class AuthError extends Error {
  status: number

  constructor(message: string, status: number) {
    super(message)
    this.name = 'AuthError'
    this.status = status
  }
}

export type AuthActor =
  | {
      type: 'mahasiswa'
      nim: string
      nama: string
    }
  | {
      type: 'staff'
      nip: string
      nama: string
      roleName: string
      tipeStaf: string | null
    }

export function authErrorResponse(error: unknown) {
  if (error instanceof AuthError) {
    return NextResponse.json({ message: error.message }, { status: error.status })
  }

  return null
}

export async function getAuthActor(): Promise<AuthActor | null> {
  const cookieStore = await cookies()
  const nip = cookieStore.get('nip')?.value
  const nim = cookieStore.get('nim')?.value

  if (nip) {
    const staf = await prisma.staf.findUnique({
      where: { nip },
      select: {
        nip: true,
        nama: true,
        tipe_staf: true,
        user: {
          select: {
            role: {
              select: { nama: true },
            },
          },
        },
      },
    })

    if (!staf) return null

    return {
      type: 'staff',
      nip: staf.nip,
      nama: staf.nama || 'Admin',
      roleName: staf.user?.role?.nama?.toLowerCase() || '',
      tipeStaf: staf.tipe_staf,
    }
  }

  if (nim) {
    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { nim },
      select: { nim: true, nama: true },
    })

    if (!mahasiswa) return null

    return {
      type: 'mahasiswa',
      nim: mahasiswa.nim,
      nama: mahasiswa.nama || 'Mahasiswa',
    }
  }

  return null
}

export async function requireAdmin(): Promise<Extract<AuthActor, { type: 'staff' }>> {
  const actor = await getAuthActor()

  if (!actor) {
    throw new AuthError('Unauthorized: Silakan login terlebih dahulu', 401)
  }

  if (actor.type !== 'staff') {
    throw new AuthError('Forbidden: Akses admin diperlukan', 403)
  }

  return actor
}

export async function requireMahasiswa(): Promise<Extract<AuthActor, { type: 'mahasiswa' }>> {
  const actor = await getAuthActor()

  if (!actor) {
    throw new AuthError('Unauthorized: Silakan login terlebih dahulu', 401)
  }

  if (actor.type !== 'mahasiswa') {
    throw new AuthError('Forbidden: Akses mahasiswa diperlukan', 403)
  }

  return actor
}

export async function requireAuthenticated(): Promise<AuthActor> {
  const actor = await getAuthActor()

  if (!actor) {
    throw new AuthError('Unauthorized: Silakan login terlebih dahulu', 401)
  }

  return actor
}

export async function assertMahasiswaInClass(nim: string, kelasId: number | null, semesterId: number | null) {
  if (!kelasId || !semesterId) {
    throw new AuthError('Forbidden: Data kelas tidak valid', 403)
  }

  const registration = await prisma.registrasi_mahasiswa.findFirst({
    where: {
      nim,
      kelas_id: kelasId,
      semester_id: semesterId,
      status: 'Aktif',
    },
    select: { id: true },
  })

  if (!registration) {
    throw new AuthError('Forbidden: Kamu tidak terdaftar di kelas ini', 403)
  }
}
