'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const router = useRouter()
  const [identifier, setIdentifier] = useState('') 
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ identifier, password }), 
      })

      const data = await res.json()

      if (res.ok) {
        const userRole = data.role; 
        console.log("Login sukses, role:", userRole);

        // Pakai window.location biar cookie nempel sempurna
        if (userRole === 'User') {
          window.location.href = '/user/dashboard';
        } else {
          window.location.href = '/user/dashboard';
        }
        return; 
        
      } else {
        setError(data.error || 'Login gagal');
      }

    } catch (err) {
      setError('Terjadi kesalahan koneksi ke server');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex min-h-screen" suppressHydrationWarning>
      {/* Kolom Kiri - Branding */}
      <div className="hidden lg:flex flex-col w-1/2 bg-[#0F172A] items-center justify-center p-12">
        <div className="max-w-md text-center space-y-6">
          <div className="space-y-2">
            <h1 className="text-3xl font-bold text-white tracking-tight">SITAMA</h1>
            <h2 className="text-xl font-medium text-[#0ea5e9]">Politeknik Negeri Semarang</h2>
          </div>
          <p className="text-slate-400 text-sm leading-relaxed">
            Sistem Informasi Tugas Akhir dan Manajemen Kompensasi <br />
            untuk lingkungan civitas akademika Polines.
          </p>
        </div>
      </div>

      {/* Kolom Kanan - Form Login */}
      <div className="flex w-full lg:w-1/2 bg-slate-50 items-center justify-center p-8">
        <div className="w-full max-w-md bg-white rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] p-8 sm:p-10" suppressHydrationWarning>
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Selamat Datang</h2>
            <p className="text-sm text-gray-500">Masuk ke akun anda untuk melanjutkan</p>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 text-xs font-bold rounded-r-lg">
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-5" suppressHydrationWarning>
            <div suppressHydrationWarning>
              <label className="block text-sm font-semibold text-gray-900 mb-2">
                NIM
              </label>
              <input
                type="text"
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                className="w-full px-5 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl outline-none transition-all text-sm"
                placeholder="Contoh: 3.34.24.2.02"
                required
                suppressHydrationWarning
              />
            </div>

            <div suppressHydrationWarning>
              <label className="block text-sm font-semibold text-gray-900 mb-2">
                Password
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-5 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl outline-none transition-all text-sm"
                placeholder="••••••••"
                required
                suppressHydrationWarning
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-[#2563EB] hover:bg-blue-700 text-white font-medium py-3 rounded-lg transition-colors mt-4 disabled:opacity-50"
              suppressHydrationWarning
            >
              {loading ? 'Memproses...' : 'Sign In'}
            </button>
          </form>

          <div className="mt-10 text-center">
             <p className="text-[10px] text-slate-400 font-medium">Lupa password? Hubungi Admin Jurusan.</p>
          </div>
        </div>
      </div>
    </div>
  )
}