import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { compare } from 'bcryptjs'

export async function POST(req: NextRequest) {
  try {
    const { nim, password } = await req.json()

    if (!nim || !password) {
      return NextResponse.json({ error: 'NIM dan password wajib diisi' }, { status: 400 })
    }

    // Try to find in mahasiswa first
    let userRecord = null;
    let isStaf = false;

    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { nim },
      include: { user: true },
    })

    if (mahasiswa) {
      userRecord = mahasiswa;
    } else {
      // Try to find in staf
      const staf = await prisma.staf.findUnique({
        where: { nip: nim },
        include: { user: true },
      })
      if (staf) {
        userRecord = staf;
        isStaf = true;
      }
    }

    if (!userRecord) {
      return NextResponse.json({ error: 'NIM atau NIP tidak ditemukan' }, { status: 401 })
    }

    const isValidPassword = await compare(password, userRecord.user?.kata_sandi || '')
    if (!isValidPassword) {
      return NextResponse.json({ error: 'Password salah' }, { status: 401 })
    }

    const response = NextResponse.json({ 
      success: true, 
      message: 'Login berhasil',
      nama: userRecord.nama,
      role: isStaf ? 'admin' : 'mahasiswa',
    })

    if (isStaf) {
      response.cookies.delete('nim')
      response.cookies.set('nip', nim, {
        httpOnly: true,
        path: '/',
        maxAge: 60 * 60 * 24,
      })
    } else {
      response.cookies.delete('nip')
      response.cookies.set('nim', nim, {
        httpOnly: true,
        path: '/',
        maxAge: 60 * 60 * 24,
      })
    }

    return response
  } catch (error) {
    console.error('Login error:', error)
    return NextResponse.json({ error: 'Terjadi kesalahan server' }, { status: 500 })
  }
}