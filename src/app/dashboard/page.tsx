import prisma from "@/lib/prisma";

export default async function MahasiswaDashboard() {
  // Ambil data dari PostgreSQL lewat Prisma
  const user = await prisma.user.findFirst({ where: { role: 'mahasiswa' } });

  return (
    <div style={{ padding: '40px' }}>
      <header style={{ marginBottom: '30px' }}>
        <h1 style={{ fontSize: '24px' }}>Selamat Datang, {user?.name || 'Joko'}</h1>
        <p style={{ color: '#666' }}>Berikut ringkasan aktivitas kompensasi anda</p>
      </header>
      <div style={{ display: 'flex', gap: '20px', flexWrap: 'wrap' }}>
        {['Sisa Jam Kompen', 'Total Jam Selesai', 'Total Jam Wajib'].map((item) => (
          <div key={item} style={{ flex: 1, minWidth: '250px', backgroundColor: 'white', padding: '25px', borderRadius: '15px', boxShadow: '0 4px 6px rgba(0,0,0,0.05)' }}>
            <p style={{ color: '#666', fontSize: '14px' }}>{item}</p>
            <h2 style={{ fontSize: '32px', marginTop: '10px' }}>0 Jam</h2>
          </div>
        ))}
      </div>
    </div>
  );
}