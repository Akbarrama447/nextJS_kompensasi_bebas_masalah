import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl
  const nim = req.cookies.get('nim')?.value
  const nip = req.cookies.get('nip')?.value
  const role = req.cookies.get('role')?.value
  const isAuthenticated = !!(nim || nip)

  if (pathname === '/login' || pathname.startsWith('/api/')) {
    return NextResponse.next()
  }

  if (pathname === '/' || pathname === '/user' || pathname === '/admin') {
    if (isAuthenticated) {
      const target = role === 'admin' ? '/admin/dashboard' : '/user/dashboard'
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

  return NextResponse.next()
}

export const config = {
  matcher: ['/', '/user', '/user/:path*', '/admin', '/admin/:path*', '/login', '/api/:path*'],
}
