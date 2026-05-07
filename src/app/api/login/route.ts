import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { compare } from 'bcryptjs'

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const { nim, password } = body

    // 1. Validasi input kosong
    if (!nim || !password) {
      return NextResponse.json(
        { error: 'NIM dan password wajib diisi' }, 
        { status: 400 }
      )
    }

    // 2. Cari mahasiswa beserta relasi usernya
    // Pastikan nim dijadikan String untuk mencegah error type mismatch jika input berupa angka
    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { nim: String(nim) }, 
      include: { 
        user: true 
      },
    })

    // 3. Validasi keberadaan mahasiswa dan akun usernya
    if (!mahasiswa || !mahasiswa.user) {
      return NextResponse.json(
        { error: 'NIM tidak ditemukan atau akun belum aktif' }, 
        { status: 401 }
      )
    }

    // 4. Verifikasi password dengan bcrypt
    const hashedPassword = mahasiswa.user.kata_sandi || ''
    const isValidPassword = await compare(password, hashedPassword)
    
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

    // 6. Set Cookie untuk session
    response.cookies.set({
      name: 'nim',
      value: String(nim),
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