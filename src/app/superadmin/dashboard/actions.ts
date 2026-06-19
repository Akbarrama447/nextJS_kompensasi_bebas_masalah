'use server'

import prisma from '@/lib/prisma'
import { revalidatePath } from 'next/cache'
import { requireSuperadmin } from '@/lib/session'
import { logAudit } from '@/lib/audit'

export async function setActiveSemester(semesterId: number) {
  try {
    const session = await requireSuperadmin()

    await prisma.semester.updateMany({
      data: { is_aktif: false }
    })

    await prisma.semester.update({
      where: { id: semesterId },
      data: { is_aktif: true }
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'SET_ACTIVE_SEMESTER',
      target: `semester_id=${semesterId}`,
    })

    revalidatePath('/superadmin/dashboard')
    return { success: true, message: 'Semester aktif berhasil diperbarui!' }
  } catch (error: any) {
    console.error('Error setting active semester:', error)
    return { success: false, error: error.message || 'Gagal mengubah semester aktif' }
  }
}

export async function createSemester(data: { nama: string; tahun: number; periode: string }) {
  try {
    const session = await requireSuperadmin()

    const { nama, tahun, periode } = data
    if (!nama || !tahun || !periode) {
      return { success: false, error: 'Semua kolom wajib diisi!' }
    }

    await prisma.semester.create({
      data: {
        nama,
        tahun: Number(tahun),
        periode,
        is_aktif: false
      }
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'CREATE_SEMESTER',
      target: nama,
      detail: { tahun, periode },
    })

    revalidatePath('/superadmin/dashboard')
    return { success: true, message: 'Semester baru berhasil ditambahkan!' }
  } catch (error: any) {
    console.error('Error creating semester:', error)
    return { success: false, error: error.message || 'Gagal menambahkan semester' }
  }
}
