import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { authErrorResponse, requireAdmin } from '@/lib/auth'
import { STATUS_EKUIVALENSI } from '@/lib/constants'

export async function POST(req: NextRequest) {
  try {
    const admin = await requireAdmin()
    const body = await req.json()
    const { ekuivalensiId, statusId, catatan } = body

    if (!ekuivalensiId || !statusId) {
      return NextResponse.json({ message: 'ekuivalensiId dan statusId diperlukan' }, { status: 400 })
    }

    const ekuivalensi = await prisma.ekuivalensi_kelas.findUnique({
      where: { id: ekuivalensiId },
      include: { kelas: true, semester: true },
    })

    if (!ekuivalensi) {
      return NextResponse.json({ message: 'Data ekuivalensi tidak ditemukan' }, { status: 404 })
    }

    if (ekuivalensi.status_ekuivalensi_id === STATUS_EKUIVALENSI.DISETUJUI) {
      return NextResponse.json({ success: true, message: 'Ekuivalensi sudah disetujui sebelumnya' })
    }

    await prisma.$transaction(async (tx) => {
      await tx.ekuivalensi_kelas.update({
        where: { id: ekuivalensiId },
        data: {
          status_ekuivalensi_id: statusId,
          verified_by_nip: admin.nip,
          catatan: catatan || null,
        },
      })

      if (statusId === STATUS_EKUIVALENSI.DISETUJUI && ekuivalensi.jam_diakui && ekuivalensi.kelas_id && ekuivalensi.semester_id) {
        const sudahAda = await tx.log_potong_jam.findFirst({
          where: { ekuivalensi_id: ekuivalensiId },
          select: { id: true },
        })

        if (sudahAda) return

        const registrations = await tx.registrasi_mahasiswa.findMany({
          where: {
            kelas_id: ekuivalensi.kelas_id,
            semester_id: ekuivalensi.semester_id,
            status: 'Aktif',
          },
        })

        if (registrations.length > 0) {
          const jamPerStudent = ekuivalensi.jam_diakui / registrations.length

          await tx.log_potong_jam.createMany({
            data: registrations.map((r) => ({
              nim: r.nim || '',
              semester_id: ekuivalensi.semester_id,
              ekuivalensi_id: ekuivalensiId,
              jam_dikurangi: Math.round(jamPerStudent * 100) / 100,
              keterangan: `Ekuivalensi kelas ${ekuivalensi.kelas?.nama_kelas || ''}`,
            })),
          })
        }
      }
    })

    return NextResponse.json({ success: true, message: 'Berhasil melakukan verifikasi' })
  } catch (error) {
    const authResponse = authErrorResponse(error)
    if (authResponse) return authResponse

    console.error('Verify error:', error)
    return NextResponse.json({ message: 'Terjadi kesalahan server' }, { status: 500 })
  }
}
