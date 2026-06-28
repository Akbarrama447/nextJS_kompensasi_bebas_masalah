'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Eye, EyeOff } from 'lucide-react'

export default function LoginPage() {
  const router = useRouter()
  const [identifier, setIdentifier] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [showPassword, setShowPassword] = useState(false)

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

      if (!res.ok) {
        setError(data.error || 'Login gagal')
        return
      }

      if (data.role === 'superadmin') {
        router.push('/superadmin/dashboard')
      } else if (data.role === 'admin') {
        router.push('/admin/dashboard')
      } else {
        router.push('/user/dashboard')
      }
    } catch {
      setError('Terjadi kesalahan')
    } finally {
      setLoading(false)
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
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Selamat Datang</h2>
            <p className="text-sm text-gray-500">Masuk ke akun anda untuk melanjutkan</p>
          </div>

          {error && (
            <div className="mb-4 p-3 bg-red-50 text-red-600 text-sm rounded-lg">
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
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-gray-900"
                placeholder="Masukkan NIM atau Email"
                required
                suppressHydrationWarning
              />
            </div>

            <div suppressHydrationWarning>
              <label className="block text-sm font-semibold text-gray-900 mb-2">
                Password
              </label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full px-4 py-2.5 pr-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-gray-900"
                  placeholder="Masukkan Password"
                  required
                  suppressHydrationWarning
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"
                  tabIndex={-1}
                >
                  {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-[#2563EB] hover:bg-blue-700 text-white font-medium py-3 rounded-lg transition-colors mt-4 disabled:opacity-50"
              suppressHydrationWarning
            >
              {loading ? 'Memuat...' : 'Masuk'}
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}