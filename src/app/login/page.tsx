'use client'

import { useState } from 'react'
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

      router.push('/user/dashboard')
    } catch {
      setError('Terjadi kesalahan koneksi')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex min-h-screen">
      {/* Kolom Kiri - Bagian Branding */}
      <div className="hidden lg:flex flex-col w-1/2 bg-[#0F172A] items-center justify-center p-12">
        <div className="text-center space-y-4">
          <div>
            <h1 className="text-2xl font-bold text-white">
              Sistem Kompensasi dan Bebas Masalah
            </h1>
            <h2 className="text-xl font-bold text-[#0ea5e9]">
              Politeknik Negeri Semarang
            </h2>
          </div>
          <p className="text-slate-400 text-sm tracking-wide leading-relaxed">
            Platform manajemen kompensasi <br />
            mahasiswa Politeknik Negeri Semarang
          </p>
        </div>
      </div>

      {/* Kolom Kanan - Bagian Form Login */}
      <div className="flex w-full lg:w-1/2 bg-slate-50 items-center justify-center p-8">
        <div className="w-full max-w-md bg-white rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] p-8 sm:p-10">
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Selamat Datang</h2>
            <p className="text-sm text-gray-500">Masuk ke akun anda untuk melanjutkan</p>
          </div>

          {error && (
            <div className="mb-4 p-3 bg-red-50 text-red-600 text-sm rounded-lg">
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-5">
            {/* Input NIM */}
            <div>
              <label className="block text-sm font-semibold text-gray-900 mb-2">
                NIM
              </label>
              <input
                type="text"
                value={nim}
                onChange={(e) => setNim(e.target.value)}
                className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-black"
                placeholder="Masukkan NIM"
                required
              />
            </div>

            {/* Input Password */}
            <div>
              <label className="block text-sm font-semibold text-gray-900 mb-2">
                Password
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all text-black"
                placeholder="Masukkan Password"
                required
              />
            </div>

            {/* Tombol Masuk */}
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-[#2563EB] hover:bg-blue-700 text-white font-medium py-3 rounded-lg transition-colors mt-4 disabled:opacity-50"
            >
              {loading ? 'Memuat...' : 'Masuk'}
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}