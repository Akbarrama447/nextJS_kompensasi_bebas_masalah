import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { compare } from 'bcryptjs'

export async function POST(req: NextRequest) {
  try {
    const { identifier, password } = await req.json()

    if (!identifier || !password) {
      return NextResponse.json({ error: 'NIM/NIP dan password wajib diisi' }, { status: 400 })
    }

    let userData: { nama: string; role: string; userId: number; nim?: string; nip?: string } | null = null

    const mahasiswa = await prisma.mahasiswa.findUnique({
      where: { nim: identifier },
      include: { user: true },
    })

    if (mahasiswa && mahasiswa.user) {
      userData = {
        nama: mahasiswa.nama || 'Mahasiswa',
        role: 'mahasiswa',
        userId: mahasiswa.user.user_id,
        nim: mahasiswa.nim,
      }
    }

    if (!userData) {
      const staf = await prisma.staf.findUnique({
        where: { nip: identifier },
        include: { user: true },
      })

      if (staf && staf.user) {
        userData = {
          nama: staf.nama || 'Admin',
          role: 'admin',
          userId: staf.user.user_id,
          nip: staf.nip,
        }
      }
    }

    if (!userData) {
      return NextResponse.json({ error: 'NIM/NIP tidak ditemukan' }, { status: 401 })
    }

    const user = await prisma.users.findUnique({
      where: { user_id: userData.userId },
    })

    if (!user) {
      return NextResponse.json({ error: 'User tidak ditemukan' }, { status: 401 })
    }

    const isValidPassword = await compare(password, user.kata_sandi || '')
    if (!isValidPassword) {
      return NextResponse.json({ error: 'Password salah' }, { status: 401 })
    }

    const redirectPath = userData.role === 'admin' ? '/admin/dashboard' : '/user/dashboard'

    const response = NextResponse.json({
      success: true,
      message: 'Login berhasil',
      nama: userData.nama,
      role: userData.role,
      redirect: redirectPath,
    })

    response.cookies.set('user_id', String(userData.userId), {
      httpOnly: true,
      path: '/',
      maxAge: 60 * 60 * 24,
    })

    response.cookies.set('role', userData.role, {
      httpOnly: true,
      path: '/',
      maxAge: 60 * 60 * 24,
    })

    if (userData.nim) {
      response.cookies.set('nim', userData.nim, {
        httpOnly: true,
        path: '/',
        maxAge: 60 * 60 * 24,
      })
    }

    if (userData.nip) {
      response.cookies.set('nip', userData.nip, {
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