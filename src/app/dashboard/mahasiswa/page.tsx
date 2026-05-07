import Sidebar from '@/components/Sidebar'; 
import UserHeader from '@/components/UserHeader'; 
import { cookies } from 'next/headers';
import prisma from '@/lib/prisma';
import Link from 'next/link';

// 1. Tambahkan interface di sini untuk mendefinisikan tipe data dari query SQL
interface SisaKompenResult {
  nim: string;
  semester_id: number;
  total_jam_wajib: number;
  jam_selesai: number;
  sisa_jam: number;
}

export default async function DashboardMahasiswa() {
  // Ambil NIM dari cookies
  const cookieStore = await cookies();
  // Fallback ke data dummy dari SQL kamu (Akbar Rama) kalau cookie belum diset
  const nim = cookieStore.get('nim')?.value || '33424202'; 

  // Ambil data profil mahasiswa dari tabel mahasiswa
  const mahasiswa = await prisma.mahasiswa.findUnique({
    where: { nim }
  });
  const userName = mahasiswa?.nama || "Mahasiswa";

  // 2. Tambahkan <SisaKompenResult[]> pada $queryRaw
  const statsRaw = await prisma.$queryRaw<SisaKompenResult[]>`
    SELECT * FROM public.v_sisa_kompen WHERE nim = ${nim}
  `;
  
  const stats = statsRaw[0] || {};
  
  // 3. Pastikan data diubah menjadi Number untuk menghindari tipe yang tidak sesuai
  const sisaJam = Number(stats.sisa_jam) || 0;
  const jamSelesai = Number(stats.jam_selesai) || 0;
  const totalJamWajib = Number(stats.total_jam_wajib) || 0;

  return (
    <Sidebar role="mahasiswa" activePath="/dashboard">
      {/* Navbar / Header */}
      <UserHeader nama={userName} role="mahasiswa" />

      {/* Content Section */}
      <main className="p-10 max-w-6xl">
        <div className="mb-8">
          {/* Ambil nama depan saja untuk sapaan */}
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">
            Selamat Datang, {userName.split(' ')[0]}
          </h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">
            Berikut ringkasan aktivitas kompensasi anda
          </p>
        </div>

        {/* Grid Statistik */}
        <div className="grid grid-cols-3 gap-6 mb-8">
          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Sisa Jam Kompen</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{sisaJam}</span>
              <span className="text-sm font-medium text-slate-500">Jam</span>
            </div>
          </div>

          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Selesai</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{jamSelesai}</span>
              <span className="text-sm font-medium text-slate-500">Jam</span>
            </div>
          </div>

          <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100">
            <p className="text-[#2e5299] font-semibold text-xs mb-3">Total Jam Wajib</p>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-slate-800">{totalJamWajib}</span>
              <span className="text-sm font-medium text-slate-500">Jam</span>
            </div>
          </div>
        </div>

        {/* Action Cards (Diubah menjadi Link agar bisa diklik) */}
        <div className="grid grid-cols-2 gap-6">
          <Link href="/dashboard/list-pekerjaan" className="bg-white p-7 rounded-2xl shadow-sm border border-slate-100 hover:border-[#2e5299]/30 transition-all cursor-pointer group block">
            <h3 className="text-[#2e5299] font-bold text-lg mb-1 group-hover:text-blue-700">Cek Pekerjaan</h3>
            <p className="text-slate-400 text-xs font-medium">Cek Daftar Pekerjaan Kompensasi</p>
          </Link>

          <Link href="/dashboard/ekuivalen" className="bg-white p-7 rounded-2xl shadow-sm border border-slate-100 hover:border-[#2e5299]/30 transition-all cursor-pointer group block">
            <h3 className="text-[#2e5299] font-bold text-lg mb-1 group-hover:text-blue-700">Cek Ekuivalen</h3>
            <p className="text-slate-400 text-xs font-medium">Cek Ekuivalen Kelas</p>
          </Link>
        </div>
      </main>
    </Sidebar>
  );
}