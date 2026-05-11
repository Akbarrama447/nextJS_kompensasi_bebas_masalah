import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET() {
  try {
    const kelas = await prisma.kelas.findMany({
      select: { id: true, nama_kelas: true },
      orderBy: { nama_kelas: 'asc' },
    })
    return NextResponse.json(kelas)
  } catch (error) {
    console.error('Fetch kelas error:', error)
    return NextResponse.json({ error: 'Gagal mengambil data kelas' }, { status: 500 })
  }
}
