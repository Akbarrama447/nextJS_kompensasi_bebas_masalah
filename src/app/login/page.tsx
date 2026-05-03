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
    <div className="flex min-h-screen bg-white">
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
      <div className="flex w-full lg:w-1/2 bg-slate-50 items-center justify-center p-6 md:p-12">
        <div className="w-full max-w-sm bg-white rounded-3xl shadow-lg p-8 md:p-10 border border-slate-100">
          <div className="mb-10 text-center lg:text-left">
            <h2 className="text-2xl font-black text-slate-800 mb-2">Welcome Back!</h2>
            <p className="text-xs text-slate-400 font-medium uppercase tracking-widest">Silahkan masuk ke akun anda</p>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 text-xs font-bold rounded-r-lg">
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-6">
            <div>
              <label className="block text-[11px] uppercase tracking-widest font-bold text-slate-500 mb-2">NIM / Email</label>
              <input
                type="text"
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                className="w-full px-5 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl outline-none transition-all text-sm"
                placeholder="Contoh: 3.34.24.2.02"
                required
              />
            </div>

            <div>
              <label className="block text-[11px] uppercase tracking-widest font-bold text-slate-500 mb-2">Password</label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-5 py-3.5 bg-slate-50 border border-slate-200 rounded-2xl outline-none transition-all text-sm"
                placeholder="••••••••"
                required
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-[#2563EB] hover:bg-[#1d4ed8] text-white text-sm font-bold py-4 rounded-2xl transition-all shadow-lg disabled:opacity-50"
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