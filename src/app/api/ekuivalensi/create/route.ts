import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { authErrorResponse, requireMahasiswa } from '@/lib/auth'
import { STATUS_EKUIVALENSI } from '@/lib/constants'

export async function POST(req: NextRequest) {
  try {
    const session = await requireMahasiswa()
    const body = await req.json()
    const { noTelepon } = body
    const nim = session.nim

    if (!noTelepon) {
      return NextResponse.json({ message: 'Nomor telepon perwakilan harus diisi' }, { status: 400 })
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
        status_ekuivalensi_id: STATUS_EKUIVALENSI.MENUNGGU,
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
      return acc + Math.floor(Math.max(0, totalJam - jamSelesai))
    }, 0)

    const nominalTotal = totalSisaJam * 2000

    const ekuivalensi = await prisma.ekuivalensi_kelas.create({
      data: {
        kelas_id: registrasi.kelas_id,
        semester_id: activeSemester.id,
        penanggung_jawab_nim: nim,
        jam_diakui: totalSisaJam,
        nominal_total: nominalTotal,
        status_ekuivalensi_id: STATUS_EKUIVALENSI.MENUNGGU,
        no_telepon: noTelepon,
      },
    })

    return NextResponse.json({
      success: true,
      ekuivalensi: {
        id: ekuivalensi.id,
        jam: Math.floor(Number(ekuivalensi.jam_diakui || 0)),
        nominal: Number(ekuivalensi.nominal_total),
        noTelepon: ekuivalensi.no_telepon,
        noTeleponChangeCount: ekuivalensi.no_telepon_change_count,
      },
    })
  } catch (error) {
    const authResponse = authErrorResponse(error)
    if (authResponse) return authResponse

    console.error('Create ekuivalensi error:', error)
    return NextResponse.json({ message: 'Gagal membuat pengajuan ekuivalensi' }, { status: 500 })
  }
}
