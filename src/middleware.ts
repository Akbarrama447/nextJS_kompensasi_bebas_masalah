import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(req: NextRequest) {
  const { pathname } = req.nextUrl
  const nim = req.cookies.get('nim')?.value
  const nip = req.cookies.get('nip')?.value
  const isAuthenticated = !!(nim || nip)

  // Allow login and API routes to pass through
  if (pathname === '/login' || pathname.startsWith('/api/')) {
    return NextResponse.next()
  }

  // Root, /user, /admin pages
  if (pathname === '/' || pathname === '/user' || pathname === '/admin') {
    if (isAuthenticated) {
      return NextResponse.redirect(new URL(nim ? '/user/dashboard' : '/admin', req.url))
    } else {
      return NextResponse.redirect(new URL('/login', req.url))
    }
  }

  // Protect /user/* routes
  if (pathname.startsWith('/user') && !nim) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  // Auto-create demo admin cookie (no redirect needed)
  if (pathname.startsWith('/admin') && !nip) {
    const res = NextResponse.next()
    res.cookies.set('nip', 'ADMIN_DEMO', {
      httpOnly: true,
      path: '/',
      maxAge: 60 * 60 * 24,
    })
    return res
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/', '/user', '/user/:path*', '/admin', '/admin/:path*', '/login', '/api/:path*'],
}
