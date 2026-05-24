import { NextRequest, NextResponse } from 'next/server'

export async function GET(req: NextRequest) {
  const response = NextResponse.redirect(new URL('/login', req.url))
  
  response.cookies.delete('nim')
  response.cookies.delete('nip')
  response.cookies.delete('role')
  response.cookies.delete('nama')
  
  return response
}
