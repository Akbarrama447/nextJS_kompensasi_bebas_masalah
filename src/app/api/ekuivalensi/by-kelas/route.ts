import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const namaKelas = searchParams.get('kelas')

    if (!namaKelas) {
      return NextResponse.json({ error: 'Parameter kelas diperlukan' }, { status: 400 })
    }

    const kelas = await prisma.kelas.findFirst({
      where: { nama_kelas: namaKelas },
    })

    if (!kelas) {
      return NextResponse.json({ mahasiswa: [], ekuivalensi: null })
    }

    const semesterAktif = await prisma.semester.findFirst({
      where: { is_aktif: true },
    })

    if (!semesterAktif) {
      return NextResponse.json({ mahasiswa: [], ekuivalensi: null })
    }

    const registrations = await prisma.registrasi_mahasiswa.findMany({
      where: {
        kelas_id: kelas.id,
        semester_id: semesterAktif.id,
        status: 'Aktif',
      },
      include: {
        mahasiswa: {
          include: {
            kompen_awal: {
              where: { semester_id: semesterAktif.id },
              take: 1,
            },
          },
        },
      },
    })

    const nims = registrations.map((r) => r.nim).filter(Boolean) as string[]

    const logSum = await prisma.log_potong_jam.groupBy({
      by: ['nim'],
      where: {
        nim: { in: nims },
        semester_id: semesterAktif.id,
      },
      _sum: { jam_dikurangi: true },
    })

    const jamSelesaiMap = new Map<string, number>()
    for (const log of logSum) {
      if (log.nim) jamSelesaiMap.set(log.nim, log._sum.jam_dikurangi || 0)
    }

    const ekuivalensi = await prisma.ekuivalensi_kelas.findFirst({
      where: {
        kelas_id: kelas.id,
        semester_id: semesterAktif.id,
      },
      orderBy: { created_at: 'desc' },
    })

    if (!ekuivalensi) {
      return NextResponse.json({ mahasiswa: [], ekuivalensi: null })
    }

    const mahasiswa = registrations
      .map((r) => {
        const studentNim = r.nim || ''
        const totalJam = r.mahasiswa?.kompen_awal[0]?.total_jam_wajib || 0
        const jamSelesai = jamSelesaiMap.get(studentNim) || 0
        const sisaJam = Math.max(0, totalJam - jamSelesai)
        return {
          nama: r.mahasiswa?.nama || '',
          nim: studentNim,
          jam: sisaJam,
        }
      })
      .filter((m) => m.jam > 0)

    return NextResponse.json({
      mahasiswa,
      ekuivalensi: ekuivalensi
        ? {
            id: ekuivalensi.id,
            statusId: ekuivalensi.status_ekuivalensi_id,
            jam: ekuivalensi.jam_diakui || 0,
            nominal: Number(ekuivalensi.nominal_total || 0),
            tanggal: ekuivalensi.created_at,
            notaUrl: ekuivalensi.nota_url || '',
            catatan: ekuivalensi.catatan || '',
            noTelepon: ekuivalensi.no_telepon || '',
            noTeleponChangeCount: ekuivalensi.no_telepon_change_count ?? 0,
          }
        : null,
    })
  } catch (error) {
    console.error('Fetch by-kelas error:', error)
    return NextResponse.json({ error: 'Gagal mengambil data ekuivalensi' }, { status: 500 })
  }
}
