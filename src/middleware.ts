import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'
import { verifySession } from '@/lib/session'

const PUBLIC_PATHS = ['/login', '/logout']

function isPublicPath(pathname: string) {
  return PUBLIC_PATHS.some(p => pathname === p || pathname.startsWith(p + '/'))
}

function isApiPath(pathname: string) {
  return pathname.startsWith('/api/')
}

export async function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl

  if (isPublicPath(pathname)) {
    return NextResponse.next()
  }

  const sessionToken = req.cookies.get('session')?.value
  const session = sessionToken ? await verifySession(sessionToken) : null
  const isAuthenticated = !!session

  if (pathname === '/' || pathname === '/user' || pathname === '/admin') {
    if (isAuthenticated) {
      const target = session!.role === 'superadmin'
        ? '/superadmin/dashboard'
        : session!.role === 'admin' || session!.role === 'staf'
          ? '/admin/dashboard'
          : '/user/dashboard'
      return NextResponse.redirect(new URL(target, req.url))
    }
    return NextResponse.redirect(new URL('/login', req.url))
  }

  if (pathname.startsWith('/user') && session?.role !== 'mahasiswa') {
    return NextResponse.redirect(new URL(isAuthenticated ? '/login' : '/login', req.url))
  }

  if (pathname.startsWith('/admin') && session?.role !== 'admin' && session?.role !== 'staf') {
    return NextResponse.redirect(new URL(isAuthenticated ? '/login' : '/login', req.url))
  }

  if (pathname.startsWith('/superadmin') && session?.role !== 'superadmin') {
    if (isAuthenticated) {
      const target = session!.role === 'mahasiswa' ? '/user/dashboard' : '/admin/dashboard'
      return NextResponse.redirect(new URL(target, req.url))
    }
    return NextResponse.redirect(new URL('/login', req.url))
  }

  if (isApiPath(pathname) && !pathname.startsWith('/api/login')) {
    if (!isAuthenticated) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }
  }

  return NextResponse.next()
}

export const config = {
  matcher: [
    '/',
    '/user',
    '/user/:path*',
    '/admin',
    '/admin/:path*',
    '/superadmin',
    '/superadmin/:path*',
    '/login',
    '/api/:path*'
  ],
}
