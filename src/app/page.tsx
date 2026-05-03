'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const router = useRouter();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    // Logika: Jika email ada kata 'admin', masuk dashboard admin. Jika tidak, ke mahasiswa.
    if (email.includes('admin')) {
      router.push('/dashboard/admin');
    } else {
      router.push('/dashboard/mahasiswa');
    }
  };

  return (
    <div style={{ display: 'flex', height: '100vh', width: '100%', fontFamily: 'sans-serif' }}>
      <div style={{ flex: 1, backgroundColor: '#0B1F2D', display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', color: 'white', padding: '40px', textAlign: 'center' }}>
        <h2 style={{ fontSize: '24px' }}>Sistem Kompensasi dan Bebas Masalah</h2>
        <h1 style={{ fontSize: '28px', color: '#00A3FF' }}>Politeknik Negeri Semarang</h1>
      </div>
      <div style={{ flex: 1, display: 'flex', justifyContent: 'center', alignItems: 'center', backgroundColor: '#F4F7FA' }}>
        <form onSubmit={handleLogin} style={{ width: '400px', backgroundColor: 'white', padding: '40px', borderRadius: '20px', boxShadow: '0 10px 25px rgba(0,0,0,0.05)' }}>
          <h2 style={{ marginBottom: '30px' }}>Selamat Datang</h2>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
            <input type="email" required placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} />
            <input type="password" required placeholder="Password" style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} />
            <button type="submit" style={{ backgroundColor: '#0066FF', color: 'white', padding: '12px', borderRadius: '8px', border: 'none', fontWeight: 'bold', cursor: 'pointer' }}>Masuk</button>
          </div>
        </form>
      </div>
    </div>
  );
}