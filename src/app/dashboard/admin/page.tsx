import prisma from "@/lib/prisma";

export default async function AdminDashboardPage() {
  // --- LOGIKA DATABASE (Prisma + PostgreSQL) ---
  // Mengambil jumlah data asli. Pastikan nama tabel 'pekerjaan' sesuai schema.prisma
  const aktifCount = await prisma.pekerjaan.count({
    where: { status: 'aktif' } // Ganti 'aktif' sesuai nilai di databasemu
  });

  const waitingCount = await prisma.pekerjaan.count({
    where: { status: 'menunggu' } // Ganti 'menunggu' sesuai nilai di databasemu
  });

  // Untuk sementara nama admin hardcode sesuai desain Figma
  const adminName = "Akbar Rama";

  return (
    <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh', backgroundColor: '#F8F9FA' }}>
      
      {/* --- 1. TOP HEADER (Pencarian & Profil) --- */}
      <header style={{ 
        display: 'flex', 
        justifyContent: 'space-between', // Flex: Kiri dan Kanan
        alignItems: 'center', 
        padding: '15px 40px', 
        backgroundColor: 'white', 
        boxShadow: '0 2px 5px rgba(0,0,0,0.03)',
        borderBottom: '1px solid #f0f0f0',
        fontFamily: 'sans-serif'
      }}>
        {/* Bagian Kiri: Search Bar */}
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          gap: '10px', 
          backgroundColor: '#F4F7FA', 
          padding: '10px 20px', 
          borderRadius: '25px', 
          width: '350px' 
        }}>
          {/* Ikon Pencarian Sederhana (bisa diganti ikon beneran nanti) */}
          <span style={{ color: '#aaa' }}>🔍</span>
          <input 
            type="text" 
            placeholder="Search..." 
            style={{ 
              border: 'none', 
              background: 'transparent', 
              outline: 'none', 
              width: '100%', 
              color: '#333' 
            }} 
          />
        </div>

        {/* Bagian Kanan: Profil User */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontWeight: 'bold', fontSize: '15px', color: '#0B1F2D' }}>{adminName}</div>
            <div style={{ fontSize: '12px', color: '#888' }}>Admin</div>
          </div>
          {/* Ikon Avatar Abu-abu */}
          <div style={{ 
            width: '45px', 
            height: '45px', 
            borderRadius: '50%', 
            backgroundColor: '#D9D9D9' // Abu-abu sesuai figma
          }}></div>
        </div>
      </header>

      {/* --- 2. MAIN CONTENT AREA (Light Gray Background) --- */}
      <main style={{ flex: 1, padding: '40px 40px', fontFamily: 'sans-serif' }}>
        
        {/* Teks Selamat Datang */}
        <div style={{ marginBottom: '40px' }}>
          <h1 style={{ fontSize: '28px', fontWeight: 'bold', color: '#0B1F2D', margin: 0 }}>
            Selamat Datang {adminName}!
          </h1>
          <p style={{ fontSize: '15px', color: '#666', marginTop: '8px' }}>
            Berikut ringkasan aktivitas kompensasi anda hari ini.
          </p>
        </div>

        {/* --- 3. CONTAINER KARTU (Menggunakan Flexbox) --- */}
        <div style={{ 
          display: 'flex', 
          gap: '30px', 
          flexWrap: 'wrap' // Responsif: turun ke bawah di layar kecil
        }}>
          
          {/* Kartu 1: Pekerjaan Aktif */}
          <div style={{ 
            flex: '1', 
            minWidth: '320px', 
            backgroundColor: 'white', 
            padding: '30px', 
            borderRadius: '20px', 
            boxShadow: '0 4px 15px rgba(0,0,0,0.05)', // Bayangan halus
            border: '1px solid #f0f0f0',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between'
          }}>
            <p style={{ color: '#888', fontSize: '15px', fontWeight: '500', margin: 0 }}>
              Pekerjaan Aktif
            </p>
            {/* Angka Besar - Warna gelap sesuai Figma */}
            <h2 style={{ fontSize: '48px', fontWeight: 'bold', color: '#0B1F2D', margin: '15px 0' }}>
              {aktifCount || 7}
            </h2>
            <p style={{ color: '#aaa', fontSize: '13px', margin: 0 }}>
              Pekerjaan yang sedang berjalan
            </p>
          </div>

          {/* Kartu 2: Menunggu Verifikasi */}
          <div style={{ 
            flex: '1', 
            minWidth: '320px', 
            backgroundColor: 'white', 
            padding: '30px', 
            borderRadius: '20px', 
            boxShadow: '0 4px 15px rgba(0,0,0,0.05)', // Bayangan halus
            border: '1px solid #f0f0f0',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between'
          }}>
            <p style={{ color: '#888', fontSize: '15px', fontWeight: '500', margin: 0 }}>
              Menunggu Verifikasi
            </p>
            {/* Angka Besar - Warna gelap sesuai Figma */}
            <h2 style={{ fontSize: '48px', fontWeight: 'bold', color: '#0B1F2D', margin: '15px 0' }}>
              {waitingCount || 2}
            </h2>
            <p style={{ color: '#aaa', fontSize: '13px', margin: 0 }}>
              Selesai namun belum disetujui
            </p>
          </div>

          {/* Spacer (Kartu kosong penyeimbang layout flex jika layar sangat lebar) */}
          <div style={{ flex: '1', minWidth: '320px', backgroundColor: 'transparent' }}></div>

        </div>
      </main>
    </div>
  );
}