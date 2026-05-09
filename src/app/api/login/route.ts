import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const identifier = body.identifier || body.nim

    if (!identifier) {
      return NextResponse.json({ error: 'NIM/Email wajib diisi' }, { status: 400 })
    }

    let user = null
    let mahasiswa = null

    if (identifier.includes('@')) {
      user = await prisma.users.findUnique({
        where: { email: identifier },
        include: { mahasiswa: true, role: true },
      })
      mahasiswa = user?.mahasiswa
    } else {
      mahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim: identifier },
        include: { user: { include: { role: true } } },
      })
      user = mahasiswa?.user
    }

    if (!user || !mahasiswa) {
      return NextResponse.json({ error: 'NIM atau Email tidak ditemukan' }, { status: 401 })
    }

    // Bypass password check - anyone can login

    const response = NextResponse.json({ 
      success: true, 
      message: 'Login berhasil (Mode Dev - Bypass Password)',
      nama: mahasiswa.nama,
      role: user.role?.nama
    })

    response.cookies.set('nim', mahasiswa.nim, {
      httpOnly: true,
      path: '/',
      maxAge: 60 * 60 * 24 // Berlaku 1 hari
    })

    return response

  } catch (error: any) {
    console.error('--- DETAIL ERROR LOGIN ---')
    console.error(error.message)
    return NextResponse.json({ error: 'Terjadi kesalahan server' }, { status: 500 })
  }
}