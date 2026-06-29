import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { authErrorResponse, requireAdmin } from '@/lib/auth'

export async function GET() {
  try {
    await requireAdmin()

    const kelas = await prisma.kelas.findMany({
      select: { id: true, nama_kelas: true },
      orderBy: { nama_kelas: 'asc' },
    })
    return NextResponse.json(kelas)
  } catch (error) {
    const authResponse = authErrorResponse(error)
    if (authResponse) return authResponse

    console.error('Fetch kelas error:', error)
    return NextResponse.json({ error: 'Gagal mengambil data kelas' }, { status: 500 })
  }
}
