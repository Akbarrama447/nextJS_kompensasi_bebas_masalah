'use server'

import prisma from '@/lib/prisma'

export async function getAllSemesters() {
  try {
    const semesters = await prisma.semester.findMany({
      select: {
        id: true,
        nama: true,
        tahun: true,
        periode: true,
        is_aktif: true,
        mulai: true,
        selesai: true,
      },
      orderBy: [{ tahun: 'desc' }, { id: 'desc' }],
    })
    return semesters
  } catch (error) {
    console.error('Error fetching semesters:', error)
    return []
  }
}

export async function getUniqueTahunAkademik() {
  try {
    const semesters = await prisma.semester.findMany({
      select: { tahun: true },
      distinct: ['tahun'],
      orderBy: { tahun: 'desc' },
    })
    return semesters.map(s => s.tahun).filter(Boolean) as number[]
  } catch (error) {
    console.error('Error fetching tahun akademik:', error)
    return []
  }
}

export async function getSemestersByTahun(tahun: number) {
  try {
    const semesters = await prisma.semester.findMany({
      where: { tahun },
      select: {
        id: true,
        nama: true,
        periode: true,
        is_aktif: true,
      },
      orderBy: { id: 'asc' },
    })
    return semesters
  } catch (error) {
    console.error('Error fetching semesters by tahun:', error)
    return []
  }
}
