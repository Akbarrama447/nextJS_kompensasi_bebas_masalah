import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { compare } from 'bcryptjs'

export async function POST(req: NextRequest) {
  try {
    const { nim, password } = await req.json()

    if (!nim || !password) {
      return NextResponse.json({ error: 'NIM dan password wajib diisi' }, { status: 400 })
    }

    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { nim },
      include: { user: true },
    })

    if (!mahasiswa) {
      return NextResponse.json({ error: 'NIM tidak ditemukan' }, { status: 401 })
    }

    const isValidPassword = await compare(password, mahasiswa.user?.kata_sandi || '')
    if (!isValidPassword) {
      return NextResponse.json({ error: 'Password salah' }, { status: 401 })
    }

    const response = NextResponse.json({ 
      success: true, 
      message: 'Login berhasil',
      nama: mahasiswa.nama,
    })

    response.cookies.set('nim', nim, {
      httpOnly: true,
      path: '/',
      maxAge: 60 * 60 * 24,
    })

    return response
  } catch (error) {
    console.error('Login error:', error)
    return NextResponse.json({ error: 'Terjadi kesalahan server' }, { status: 500 })
  }
}