'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const router = useRouter()
  const [nim, setNim] = useState('')
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
        body: JSON.stringify({ nim, password }),
      })

      const data = await res.json()

      if (!res.ok) {
        setError(data.error || 'Login gagal')
        return
      }

      const target =
        data.role === 'superadmin'
          ? '/superadmin/dashboard'
          : data.role === 'admin'
            ? '/admin/dashboard'
            : '/user/dashboard'
      router.push(target)
    } catch {
      setError('Terjadi kesalahan')
    } finally {
      setLoading(false);
    }
  }


  return (
    <div className="flex min-h-screen" suppressHydrationWarning>
      {/* Kolom Kiri - Branding */}
      {/* Tambahkan 'relative' dan 'overflow-hidden' agar grid tidak keluar batas */}
      <div className="relative hidden lg:flex flex-col w-1/2 bg-[#0F172A] items-center justify-center p-12 overflow-hidden">

        {/* Elemen Animasi Background Grid */}
        <div className="absolute inset-0 bg-grid-pattern animate-grid" />

        {/* (Opsional) Efek Gradient Mask agar grid terlihat memudar secara elegan ke arah pinggir */}
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,transparent_20%,#0F172A_80%)]" />

        {/* Elemen Kotak-Kotak Melayang */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="floating-square" style={{ left: '10%', width: '80px', height: '80px', animationDelay: '0s', animationDuration: '18s' }} />
          <div className="floating-square" style={{ left: '25%', width: '40px', height: '40px', animationDelay: '2s', animationDuration: '12s' }} />
          <div className="floating-square" style={{ left: '40%', width: '120px', height: '120px', animationDelay: '4s', animationDuration: '22s' }} />
          <div className="floating-square" style={{ left: '60%', width: '60px', height: '60px', animationDelay: '1s', animationDuration: '15s' }} />
          <div className="floating-square" style={{ left: '75%', width: '90px', height: '90px', animationDelay: '5s', animationDuration: '20s' }} />
          <div className="floating-square" style={{ left: '90%', width: '50px', height: '50px', animationDelay: '3s', animationDuration: '14s' }} />
        </div>

        {/* Konten Teks - Tambahkan 'relative' dan 'z-10' agar posisi teks tetap di depan animasi */}
        <div className="relative z-10 text-center space-y-4">
          <div>
            <h1 className="text-2xl font-bold text-white">
              Sistem Kompensasi dan Bebas Masalah
            </h1>
            <h2 className="text-xl font-bold text-[#0ea5e9]">
              Politeknik Negeri Semarang
            </h2>
          </div>
          <p className="text-slate-400 text-sm tracking-[6px] leading-relaxed">
            Platform managemen kompensasi mahasiswa <br />
            Politeknik Negeri Semarang
          </p>
        </div>
      </div>

      {/* Kolom Kanan - Form Login */}
      <div className="flex w-full lg:w-1/2 bg-slate-50 items-center justify-center p-8">
        <div className="w-full max-w-md bg-white rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] p-8 sm:p-10" suppressHydrationWarning>
          <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-25 h-25 object-contain mb-4 mx-auto" />
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-2 text-center">Selamat Datang</h2>
            <p className="text-sm text-gray-500  text-center">Masuk ke akun anda untuk melanjutkan</p>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 text-xs font-bold rounded-r-lg">
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-5" suppressHydrationWarning>
            <div suppressHydrationWarning>
              <label className="block text-sm font-semibold text-gray-900 mb-2">
                NIM / Email
              </label>
              <input
                type="text"
                value={nim}
                onChange={(e) => setNim(e.target.value)}
                className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all"
                placeholder="Masukkan NIM"
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