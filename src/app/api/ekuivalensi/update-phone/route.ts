import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

const MAX_CHANGE = 5

export async function PATCH(req: NextRequest) {
  try {
    const body = await req.json()
    const { ekuivalensiId, noTelepon, nim } = body

    if (!ekuivalensiId || !noTelepon || !nim) {
      return NextResponse.json({ message: 'Data tidak lengkap' }, { status: 400 })
    }

    const ekuivalensi = await prisma.ekuivalensi_kelas.findUnique({
      where: { id: ekuivalensiId },
      select: {
        id: true,
        kelas_id: true,
        semester_id: true,
        no_telepon: true,
        no_telepon_change_count: true,
      },
    })

    if (!ekuivalensi) {
      return NextResponse.json({ message: 'Data ekuivalensi tidak ditemukan' }, { status: 404 })
    }

    const isInClass = await prisma.registrasi_mahasiswa.findFirst({
      where: {
        nim,
        kelas_id: ekuivalensi.kelas_id ?? undefined,
        semester_id: ekuivalensi.semester_id ?? undefined,
        status: 'Aktif',
      },
    })

    if (!isInClass) {
      return NextResponse.json({ message: 'Kamu tidak terdaftar di kelas ini' }, { status: 403 })
    }

    const currentCount = ekuivalensi.no_telepon_change_count ?? 0

    if (currentCount >= MAX_CHANGE) {
      return NextResponse.json(
        { message: `Nomor telepon sudah tidak bisa diubah. Maksimal ${MAX_CHANGE} kali perubahan.` },
        { status: 400 }
      )
    }

    const updated = await prisma.ekuivalensi_kelas.update({
      where: { id: ekuivalensiId },
      data: {
        no_telepon: noTelepon,
        no_telepon_change_count: currentCount + 1,
      },
      select: {
        no_telepon: true,
        no_telepon_change_count: true,
      },
    })

    return NextResponse.json({
      success: true,
      noTelepon: updated.no_telepon,
      noTeleponChangeCount: updated.no_telepon_change_count,
      sisaUbah: MAX_CHANGE - (updated.no_telepon_change_count ?? 0),
    })
  } catch (error) {
    console.error('Update phone error:', error)
    return NextResponse.json({ message: 'Gagal mengupdate nomor telepon' }, { status: 500 })
  }
}
