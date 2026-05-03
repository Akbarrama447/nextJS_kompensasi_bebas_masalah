import React from 'react';

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ display: 'flex', minHeight: '100vh' }}>
      {/* SIDEBAR */}
      <aside style={{ width: '260px', backgroundColor: '#0B1F2D', color: 'white', display: 'flex', flexDirection: 'column', padding: '25px' }}>
        <div style={{ fontWeight: 'bold', fontSize: '20px', marginBottom: '40px' }}>Sistem Kompen</div>
        <nav style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '15px' }}>
          <div style={{ cursor: 'pointer', opacity: 0.8 }}>Dashboard</div>
          <div style={{ cursor: 'pointer', opacity: 0.8 }}>List Pekerjaan</div>
          <div style={{ cursor: 'pointer', opacity: 0.8 }}>Ekuivalen</div>
        </nav>
        <div style={{ borderTop: '1px solid #ffffff22', paddingTop: '20px' }}>
          <div style={{ fontSize: '14px', fontWeight: 'bold' }}>JOKO WIDODO</div>
          <div style={{ fontSize: '12px', opacity: 0.6 }}>Mahasiswa</div>
        </div>
      </aside>

      {/* ISI HALAMAN (Admin/Mahasiswa akan muncul di sini) */}
      <main style={{ flex: 1, backgroundColor: '#F8F9FA' }}>
        {children}
      </main>
    </div>
  );
}