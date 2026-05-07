import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { compare } from 'bcryptjs'

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const identifier = body.identifier || body.nim
    const { password } = body

    if (!identifier || !password) {
      return NextResponse.json({ error: 'NIM/Email dan password wajib diisi' }, { status: 400 })
    }

    let user = null
    let mahasiswa = null

    if (identifier.includes('@')) {
      user = await prisma.users.findUnique({
        where: { email: identifier },
        include: { mahasiswa: true },
      })
      mahasiswa = user?.mahasiswa
    } else {
      mahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim: identifier },
        include: { user: true },
      })
      user = mahasiswa?.user
    }

    if (!user || !mahasiswa) {
      return NextResponse.json({ error: 'NIM atau Email tidak ditemukan' }, { status: 401 })
    }

    const isValidPassword = await compare(password, user.kata_sandi || '')
    if (!isValidPassword) {
      return NextResponse.json(
        { error: 'Password salah' }, 
        { status: 401 }
      )
    }

    // 5. Buat respons sukses
    const response = NextResponse.json(
      { 
        success: true, 
        message: 'Login berhasil',
        nama: mahasiswa.nama,
      },
      { status: 200 }
    )

    response.cookies.set('nim', mahasiswa.nim, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      path: '/',
      maxAge: 60 * 60 * 24, // Berlaku 24 jam
    })

    return response

  } catch (error) {
    console.error('Login error:', error)
    return NextResponse.json(
      { error: 'Terjadi kesalahan pada server' }, 
      { status: 500 }
    )
  }
}