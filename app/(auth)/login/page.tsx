'use client';

import { useState, useTransition, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import { Eye, EyeOff, LogIn, GraduationCap, Lock, Mail, Loader2 } from 'lucide-react';
import toast from 'react-hot-toast';

function LoginFormContent() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isPending, startTransition] = useTransition();

  const router = useRouter();
  const searchParams = useSearchParams();
  const redirectTo = searchParams.get('redirectedFrom') ?? '/dashboard';
  const supabase = createClient();

  const handleLogin = () => {
    if (!email.trim() || !password.trim()) {
      toast.error('Email dan kata sandi wajib diisi');
      return;
    }

    startTransition(async () => {
      const { error } = await supabase.auth.signInWithPassword({ email, password });

      if (error) {
        if (error.message.includes('Invalid login credentials')) {
          toast.error('Email atau kata sandi salah');
        } else {
          toast.error(error.message);
        }
        return;
      }

      toast.success('Login berhasil! Mengarahkan...');
      router.push(redirectTo);
      router.refresh();
    });
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') handleLogin();
  };

  return (
    <div className="min-h-screen flex">
      {/* ── Left Panel: Branding (hidden on mobile) ── */}
      <div className="hidden md:flex md:w-1/2 lg:w-[55%] relative bg-slate-900 flex-col items-center justify-center p-12 overflow-hidden">
        {/* Grid pattern overlay */}
        <div
          className="absolute inset-0 opacity-[0.04]"
          style={{
            backgroundImage: `
              linear-gradient(rgba(255,255,255,1) 1px, transparent 1px),
              linear-gradient(90deg, rgba(255,255,255,1) 1px, transparent 1px)
            `,
            backgroundSize: '40px 40px',
          }}
        />

        {/* Gradient orbs */}
        <div className="absolute top-1/4 left-1/4 w-80 h-80 bg-blue-600 rounded-full opacity-10 blur-3xl" />
        <div className="absolute bottom-1/4 right-1/4 w-64 h-64 bg-indigo-500 rounded-full opacity-10 blur-3xl" />

        {/* Content */}
        <div className="relative z-10 text-center max-w-sm">
          {/* Logo */}
          <div className="flex items-center justify-center gap-3 mb-8">
            <div className="w-14 h-14 rounded-2xl bg-blue-600 flex items-center justify-center shadow-xl shadow-blue-900/40">
              <GraduationCap className="w-7 h-7 text-white" />
            </div>
          </div>

          <h1 className="text-3xl font-bold text-white mb-3 tracking-tight">
            Sistem Kompen
            <span className="block text-blue-400">Polines</span>
          </h1>
          <p className="text-slate-400 text-base leading-relaxed">
            Platform manajemen kompensasi mahasiswa Politeknik Negeri Semarang
          </p>

          {/* Stats row */}
          <div className="mt-12 grid grid-cols-3 gap-4">
            {[
              { label: 'Mahasiswa', value: '5k+' },
              { label: 'Pekerjaan', value: '200+' },
              { label: 'Semester', value: 'Aktif' },
            ].map((stat) => (
              <div
                key={stat.label}
                className="bg-white/5 rounded-xl p-4 border border-white/10 backdrop-blur-sm"
              >
                <p className="text-xl font-bold text-white">{stat.value}</p>
                <p className="text-xs text-slate-400 mt-1">{stat.label}</p>
              </div>
            ))}
          </div>

          {/* Quote */}
          <div className="mt-10 p-4 rounded-xl bg-white/5 border border-white/10">
            <p className="text-sm text-slate-300 italic leading-relaxed">
              "Selesaikan kompensasi Anda tepat waktu untuk menunjang
              kelancaran studi."
            </p>
          </div>
        </div>
      </div>

      {/* ── Right Panel: Login Form ── */}
      <div className="flex-1 flex flex-col items-center justify-center bg-slate-50 p-6 md:p-12">
        {/* Mobile logo */}
        <div className="flex md:hidden items-center gap-3 mb-8">
          <div className="w-10 h-10 rounded-xl bg-blue-600 flex items-center justify-center">
            <GraduationCap className="w-5 h-5 text-white" />
          </div>
          <h1 className="text-xl font-bold text-slate-900">Sistem Kompen</h1>
        </div>

        <div className="w-full max-w-md">
          {/* Card */}
          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-8">
            <div className="mb-8">
              <h2 className="text-2xl font-bold text-slate-900">Selamat datang</h2>
              <p className="text-slate-500 text-sm mt-1">
                Masuk ke akun Anda untuk melanjutkan
              </p>
            </div>

            <div className="space-y-5">
              {/* Email */}
              <div>
                <label htmlFor="email" className="label-base">
                  Email
                </label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    onKeyDown={handleKeyDown}
                    placeholder="nama@polines.ac.id"
                    autoComplete="email"
                    disabled={isPending}
                    className="input-base pl-10"
                  />
                </div>
              </div>

              {/* Password */}
              <div>
                <label htmlFor="password" className="label-base">
                  Kata Sandi
                </label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    onKeyDown={handleKeyDown}
                    placeholder="••••••••"
                    autoComplete="current-password"
                    disabled={isPending}
                    className="input-base pl-10 pr-10"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword((v) => !v)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"
                    aria-label={showPassword ? 'Sembunyikan sandi' : 'Tampilkan sandi'}
                  >
                    {showPassword ? (
                      <EyeOff className="w-4 h-4" />
                    ) : (
                      <Eye className="w-4 h-4" />
                    )}
                  </button>
                </div>
              </div>

              {/* Submit */}
              <button
                id="btn-login"
                onClick={handleLogin}
                disabled={isPending}
                className="btn-primary w-full justify-center py-2.5 mt-2"
              >
                {isPending ? (
                  <>
                    <span className="inline-block w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                    Memproses...
                  </>
                ) : (
                  <>
                    <LogIn className="w-4 h-4" />
                    Masuk
                  </>
                )}
              </button>
            </div>
          </div>

          {/* Default credentials hint (dev only) */}
          <p className="text-center text-xs text-slate-400 mt-6">
            Mahasiswa baru: password default{' '}
            <code className="bg-slate-200 px-1 rounded text-slate-600">
              Polines123!
            </code>
          </p>
        </div>
      </div>
    </div>
  );
}

export default function LoginPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen bg-white flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
      </div>
    }>
      <LoginFormContent />
    </Suspense>
  );
}
