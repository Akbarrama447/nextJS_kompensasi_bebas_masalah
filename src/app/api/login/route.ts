import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { compare } from 'bcryptjs'

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const { identifier, password } = body

    if (!identifier || !password) {
      return NextResponse.json({ error: 'NIM/Email/NIP dan password wajib diisi' }, { status: 400 })
    }

    let user: any = null
    let profile: any = null
    let roleType = ''
    let nim: string | null = null
    let nip: string | null = null

    if (identifier.includes('@')) {
      user = await prisma.users.findUnique({
        where: { email: identifier },
        include: { mahasiswa: true, staf: true, role: true },
      })
      if (user?.mahasiswa) {
        profile = user.mahasiswa
        roleType = 'mahasiswa'
        nim = profile.nim
      } else if (user?.staf) {
        profile = user.staf
        roleType = 'admin'
        nip = profile.nip
      }
    } else {
      const mahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim: identifier },
        include: { user: { include: { role: true } } },
      })
      if (mahasiswa?.user) {
        user = mahasiswa.user
        profile = mahasiswa
        roleType = 'mahasiswa'
        nim = profile.nim
      } else {
        const staf = await prisma.staf.findUnique({
          where: { nip: identifier },
          include: { user: { include: { role: true } } },
        })
        if (staf?.user) {
          user = staf.user
          profile = staf
          roleType = 'admin'
          nip = profile.nip
        }
      }
    }

    if (!user || !profile) {
      return NextResponse.json({ error: 'Akun tidak ditemukan' }, { status: 401 })
    }

    const isValidPassword = await compare(password, user.kata_sandi || '')
    if (!isValidPassword) {
      return NextResponse.json({ error: 'Password salah' }, { status: 401 })
    }

    const response = NextResponse.json({
      success: true,
      message: 'Login berhasil',
      nama: profile.nama,
      role: roleType,
    })

    const cookieOptions = {
      httpOnly: true,
      path: '/',
      maxAge: 60 * 60 * 24,
    }

    if (nim) {
      response.cookies.set('nim', nim, cookieOptions)
    }
    if (nip) {
      response.cookies.set('nip', nip, cookieOptions)
    }
    response.cookies.set('role', roleType, cookieOptions)
    response.cookies.set('nama', profile.nama || '', { ...cookieOptions, httpOnly: false })

    return response
  } catch (error) {
    console.error('Login error:', error)
    return NextResponse.json({ error: 'Terjadi kesalahan server' }, { status: 500 })
  }
}
