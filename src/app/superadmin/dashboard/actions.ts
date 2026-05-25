'use server'

import prisma from '@/lib/prisma'
import { revalidatePath } from 'next/cache'

export async function setActiveSemester(semesterId: number) {
  try {
    // 1. Set all semesters as inactive
    await prisma.semester.updateMany({
      data: { is_aktif: false }
    })

    // 2. Set the selected semester as active
    await prisma.semester.update({
      where: { id: semesterId },
      data: { is_aktif: true }
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
    const { nama, tahun, periode } = data
    if (!nama || !tahun || !periode) {
      return { success: false, error: 'Semua kolom wajib diisi!' }
    }

    await prisma.semester.create({
      data: {
        nama,
        tahun: Number(tahun),
        periode,
        is_aktif: false // default to false
      }
    })

    revalidatePath('/superadmin/dashboard')
    return { success: true, message: 'Semester baru berhasil ditambahkan!' }
  } catch (error: any) {
    console.error('Error creating semester:', error)
    return { success: false, error: error.message || 'Gagal menambahkan semester' }
  }
}
