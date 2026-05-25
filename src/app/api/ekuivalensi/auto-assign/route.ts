import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

async function autoAssign() {
  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
  })

  if (!activeSemester) {
    return { message: 'Tidak ada semester aktif' }
  }

  const twoWeeksAgo = new Date()
  twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14)

  const allRegs = await prisma.registrasi_mahasiswa.findMany({
    where: {
      semester_id: activeSemester.id,
      status: 'Aktif',
    },
    include: {
      mahasiswa: {
        include: {
          kompen_awal: {
            where: { semester_id: activeSemester.id },
            take: 1,
          },
          penugasan: {
            where: {
              pekerjaan: { semester_id: activeSemester.id },
            },
            select: {
              id: true,
              status_tugas_id: true,
              created_at: true,
              updated_at: true,
            },
          },
        },
      },
    },
  })

  const nims = allRegs.map((r) => r.nim).filter(Boolean) as string[]

  const logSum = await prisma.log_potong_jam.groupBy({
    by: ['nim'],
    where: {
      nim: { in: nims },
      semester_id: activeSemester.id,
    },
    _sum: { jam_dikurangi: true },
  })

  const jamSelesaiMap = new Map<string, number>()
  for (const log of logSum) {
    if (log.nim) jamSelesaiMap.set(log.nim, log._sum.jam_dikurangi || 0)
  }

  const idleByClass = new Map<number, { nim: string; sisaJam: number }[]>()

  for (const r of allRegs) {
    if (!r.nim || !r.kelas_id) continue

    const totalJam = r.mahasiswa?.kompen_awal[0]?.total_jam_wajib || 0
    const jamSelesai = jamSelesaiMap.get(r.nim) || 0
    const sisaJam = Math.max(0, totalJam - jamSelesai)

    if (sisaJam <= 0) continue

    const penugasans = r.mahasiswa?.penugasan || []

    const isIdle = penugasans.length === 0 ||
      penugasans.every((p) => {
        if (p.status_tugas_id === 3 || p.status_tugas_id === 4) return false
        const dateKey = p.status_tugas_id === 2 ? p.updated_at : p.created_at
        return dateKey && new Date(dateKey) < twoWeeksAgo
      })

    if (isIdle) {
      if (!idleByClass.has(r.kelas_id)) {
        idleByClass.set(r.kelas_id, [])
      }
      idleByClass.get(r.kelas_id)!.push({ nim: r.nim, sisaJam })
    }
  }

  const created: number[] = []
  const skipped: number[] = []

  for (const [kelasId, idleStudents] of idleByClass) {
    const existing = await prisma.ekuivalensi_kelas.findFirst({
      where: {
        kelas_id: kelasId,
        semester_id: activeSemester.id,
        status_ekuivalensi_id: { in: [1, 2] },
      },
    })

    if (existing) {
      skipped.push(kelasId)
      continue
    }

    const totalJamDiakui = idleStudents.reduce((acc, s) => acc + s.sisaJam, 0)
    const nominalTotal = totalJamDiakui * 2000

    await prisma.ekuivalensi_kelas.create({
      data: {
        kelas_id: kelasId,
        semester_id: activeSemester.id,
        jam_diakui: totalJamDiakui,
        nominal_total: nominalTotal,
        status_ekuivalensi_id: 1,
        catatan: 'Auto-generated: mahasiswa tidak mendapat/mengerjakan tugas',
      },
    })

    created.push(kelasId)
  }

  return {
    success: true,
    created: created.length,
    skipped: skipped.length,
    createdClasses: created,
    skippedClasses: skipped,
  }
}

export async function POST() {
  try {
    const result = await autoAssign()
    return NextResponse.json(result)
  } catch (error) {
    console.error('Auto-assign error:', error)
    return NextResponse.json({ message: 'Gagal auto-assign ekuivalensi' }, { status: 500 })
  }
}

export async function GET() {
  try {
    const result = await autoAssign()
    return NextResponse.json(result)
  } catch (error) {
    console.error('Auto-assign error:', error)
    return NextResponse.json({ message: 'Gagal auto-assign ekuivalensi' }, { status: 500 })
  }
}
