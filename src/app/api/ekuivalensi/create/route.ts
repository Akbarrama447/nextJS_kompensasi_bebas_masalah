import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const { nim } = body

    if (!nim) {
      return NextResponse.json({ message: 'NIM diperlukan' }, { status: 400 })
    }

    const activeSemester = await prisma.semester.findFirst({
      where: { is_aktif: true },
    })

    if (!activeSemester) {
      return NextResponse.json({ message: 'Tidak ada semester aktif' }, { status: 400 })
    }

    const registrasi = await prisma.registrasi_mahasiswa.findFirst({
      where: {
        nim,
        semester_id: activeSemester.id,
        status: 'Aktif',
      },
    })

    if (!registrasi?.kelas_id) {
      return NextResponse.json({ message: 'Kelas tidak ditemukan' }, { status: 400 })
    }

    const existing = await prisma.ekuivalensi_kelas.findFirst({
      where: {
        kelas_id: registrasi.kelas_id,
        semester_id: activeSemester.id,
        status_ekuivalensi_id: 1,
      },
    })

    if (existing) {
      return NextResponse.json(
        { message: 'Sudah ada pengajuan ekuivalensi yang menunggu', ekuivalensi: { id: existing.id } },
        { status: 400 }
      )
    }

    const allRegs = await prisma.registrasi_mahasiswa.findMany({
      where: {
        kelas_id: registrasi.kelas_id,
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

    const totalSisaJam = allRegs.reduce((acc, r) => {
      const totalJam = r.mahasiswa?.kompen_awal[0]?.total_jam_wajib || 0
      const jamSelesai = jamSelesaiMap.get(r.nim || '') || 0
      return acc + Math.max(0, totalJam - jamSelesai)
    }, 0)

    const setting = await prisma.pengaturan_sistem.findFirst({
      where: { key: 'poin_per_jam' },
    })
    const rate = setting?.value ? parseInt(setting.value) : 10000
    const nominalTotal = totalSisaJam * rate

    const ekuivalensi = await prisma.ekuivalensi_kelas.create({
      data: {
        kelas_id: registrasi.kelas_id,
        semester_id: activeSemester.id,
        penanggung_jawab_nim: nim,
        jam_diakui: totalSisaJam,
        nominal_total: nominalTotal,
        status_ekuivalensi_id: 1,
      },
    })

    return NextResponse.json({
      success: true,
      ekuivalensi: {
        id: ekuivalensi.id,
        jam: ekuivalensi.jam_diakui,
        nominal: Number(ekuivalensi.nominal_total),
      },
    })
  } catch (error) {
    console.error('Create ekuivalensi error:', error)
    return NextResponse.json({ message: 'Gagal membuat pengajuan ekuivalensi' }, { status: 500 })
  }
}
