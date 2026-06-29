import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl
  const nim = req.cookies.get('nim')?.value
  const nip = req.cookies.get('nip')?.value
  const role = req.cookies.get('role')?.value
  const isAuthenticated = !!(nim || nip)

  if (pathname === '/login' || pathname === '/api/login') {
    return NextResponse.next()
  }

  if (pathname.startsWith('/api/') && !isAuthenticated) {
    return NextResponse.json({ message: 'Unauthorized: Silakan login terlebih dahulu' }, { status: 401 })
  }

  if (pathname === '/' || pathname === '/user' || pathname === '/admin' || pathname === '/superadmin') {
    if (isAuthenticated) {
      let target = '/user/dashboard'
      if (role === 'superadmin') {
        target = '/superadmin/dashboard'
      } else if (role === 'admin') {
        target = '/admin/dashboard'
      }
      return NextResponse.redirect(new URL(target, req.url))
    }
    return NextResponse.redirect(new URL('/login', req.url))
  }

  if (pathname.startsWith('/user') && !nim) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  if (pathname.startsWith('/admin') && !nip) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  // Superadmin routes — requires nip AND role='superadmin'
  if (pathname.startsWith('/superadmin')) {
    if (!nip || role !== 'superadmin') {
      return NextResponse.redirect(new URL('/login', req.url))
    }
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/', '/user', '/user/:path*', '/admin', '/admin/:path*', '/superadmin', '/superadmin/:path*', '/login', '/api/:path*'],
}
