import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl
  
  // Ambil cookie 'token' yang kita set di API login
  const token = req.cookies.get('token')?.value
  const isAuthenticated = !!token

  // 1. Kalau akses root atau dashboard tanpa login, lempar ke login
  if (pathname === '/' || pathname === '/user' || pathname === '/admin') {
    if (isAuthenticated) {
      // Untuk sementara kita default ke user dashboard kalau login sukses
      return NextResponse.redirect(new URL('/user/dashboard', req.url))
    } else {
      return NextResponse.redirect(new URL('/login', req.url))
    }
  }

  // 2. Proteksi folder /user dan /admin
  // Jika mencoba masuk tapi tidak ada token, tendang ke login
  if ((pathname.startsWith('/user') || pathname.startsWith('/admin')) && !isAuthenticated) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/', '/user/:path*', '/admin/:path*'],
};