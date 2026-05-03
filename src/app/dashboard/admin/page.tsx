// src/app/dashboard/admin/page.tsx

export default function AdminDashboardPage() {
  // Kita pakai angka manual dulu (Hardcoded) biar tampilannya muncul
  const aktifCount = 7; 
  const waitingCount = 2;
  const adminName = "Akbar Rama";

  return (
    <div style={{ padding: '40px', fontFamily: 'sans-serif' }}>
      
      {/* HEADER ATAS */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '40px' }}>
        <div>
          <h1 style={{ fontSize: '28px', fontWeight: 'bold', color: '#0B1F2D', margin: 0 }}>
            Selamat Datang, {adminName}
          </h1>
          <p style={{ fontSize: '15px', color: '#666', marginTop: '8px' }}>
            Berikut ringkasan aktivitas kompensasi anda
          </p>
        </div>

        {/* Profil Pojok Kanan */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontWeight: 'bold', color: '#0B1F2D' }}>{adminName}</div>
            <div style={{ fontSize: '12px', color: '#888' }}>Administrator</div>
          </div>
          <div style={{ width: '45px', height: '45px', borderRadius: '50%', backgroundColor: '#D9D9D9' }}></div>
        </div>
      </div>

      {/* KARTU STATISTIK */}
      <div style={{ display: 'flex', gap: '25px' }}>
        
        {/* Kartu 1 */}
        <div style={{ 
          flex: 1, 
          backgroundColor: 'white', 
          padding: '25px', 
          borderRadius: '15px', 
          boxShadow: '0 4px 12px rgba(0,0,0,0.05)',
          border: '1px solid #eee'
        }}>
          <p style={{ color: '#888', fontSize: '14px', margin: 0 }}>Pekerjaan Aktif</p>
          <h2 style={{ fontSize: '42px', fontWeight: 'bold', color: '#0B1F2D', margin: '10px 0' }}>
            {aktifCount}
          </h2>
          <p style={{ color: '#aaa', fontSize: '12px', margin: 0 }}>Pekerjaan yang aktif hari ini</p>
        </div>

        {/* Kartu 2 */}
        <div style={{ 
          flex: 1, 
          backgroundColor: 'white', 
          padding: '25px', 
          borderRadius: '15px', 
          boxShadow: '0 4px 12px rgba(0,0,0,0.05)',
          border: '1px solid #eee'
        }}>
          <p style={{ color: '#888', fontSize: '14px', margin: 0 }}>Menunggu Verifikasi</p>
          <h2 style={{ fontSize: '42px', fontWeight: 'bold', color: '#0B1F2D', margin: '10px 0' }}>
            {waitingCount}
          </h2>
          <p style={{ color: '#aaa', fontSize: '12px', margin: 0 }}>Silahkan segera diverifikasi</p>
        </div>

        {/* Spacer biar kartu nggak terlalu lebar kalau layarnya gede */}
        <div style={{ flex: 1 }}></div>
      </div>

    </div>
  );
}