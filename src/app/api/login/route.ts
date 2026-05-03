import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function POST(req: NextRequest) {
  try {
    const { identifier } = await req.json() // Kita cuekin field 'password'

    // 1. Verifikasi User: Cari berdasarkan Email atau NIM
    const user = await prisma.users.findFirst({
      where: {
        OR: [
          { email: identifier },
          { mahasiswa: { nim: identifier } }
        ]
      },
      include: {
        mahasiswa: true,
        role: true
      }
    })

    // Kalau user nggak ada di database, tetep kasih tau biar gak bingung
    if (!user) {
      return NextResponse.json({ error: 'NIM atau Email tidak terdaftar di sistem' }, { status: 404 })
    }

    // 2. BYPASS LOGIC: Langsung Login Berhasil
    console.log(`--- BYPASS LOGIN SUCCESS ---`)
    console.log(`User: ${user.email} | NIM: ${user.mahasiswa?.nim || 'N/A'}`)

    const response = NextResponse.json({ 
      success: true, 
      message: 'Login berhasil (Mode Dev)',
      nama: user.mahasiswa?.nama || user.email,
      role: user.role?.nama
    })

    // 3. Set Cookie buat Middleware
    response.cookies.set('token', 'bypass-token-sitama', { 
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