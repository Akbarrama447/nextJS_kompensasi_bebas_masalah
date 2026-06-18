import { NextResponse } from 'next/server';
import prisma from '@/lib/prisma';

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url);
  const kelasParam = searchParams.get('kelas');

  if (!kelasParam) {
    return NextResponse.json({ message: 'parameter kelas wajib' }, { status: 400 });
  }

  try {
    const activeSemester = await prisma.semester.findFirst({
      where: { is_aktif: true },
    });

    if (!activeSemester) {
      return NextResponse.json({ message: 'Tidak ada semester aktif' }, { status: 404 });
    }

    const currentClass = await prisma.kelas.findFirst({
      where: { nama_kelas: kelasParam },
      include: { prodi: true },
    });

    if (!currentClass || !currentClass.prodi_id) {
      return NextResponse.json({ message: 'Kelas atau Prodi tidak ditemukan' }, { status: 404 });
    }

    const prodi = currentClass.prodi!;

    const ekuivalensiList = await prisma.ekuivalensi_kelas.findMany({
      where: {
        kelas: { prodi_id: prodi.id },
        semester_id: activeSemester.id,
      },
      include: {
        kelas: true,
        mahasiswa: true,
        status_ekuivalensi: true,
      },
    });

    const exportData: any[] = [];

    // Ambil data semua mahasiswa aktif di prodi ini untuk keperluan auto-assign
    const allRegs = await prisma.registrasi_mahasiswa.findMany({
      where: {
        kelas: { prodi_id: prodi.id },
        semester_id: activeSemester.id,
        status: 'Aktif',
      },
      include: {
        mahasiswa: {
          include: {
            kompen_awal: {
              where: { semester_id: activeSemester.id },
              take: 1,
            },
          },
        },
      },
    });

    const nims = allRegs.map((r) => r.nim).filter(Boolean) as string[];
    const logSum = await prisma.log_potong_jam.groupBy({
      by: ['nim'],
      where: {
        nim: { in: nims },
        semester_id: activeSemester.id,
      },
      _sum: { jam_dikurangi: true },
    });
    
    const jamSelesaiMap = new Map<string, number>();
    for (const log of logSum) {
      if (log.nim) jamSelesaiMap.set(log.nim, log._sum.jam_dikurangi || 0);
    }

    for (const eq of ekuivalensiList) {
      let statusLabel = 'Pending';
      if (eq.status_ekuivalensi_id === 2) statusLabel = 'DISETUJUI';
      if (eq.status_ekuivalensi_id === 3) statusLabel = 'DITOLAK';
      const pekerjaan = eq.keterangan_pekerjaan || '';
      const jamDiakui = Math.floor(eq.jam_diakui || 0);

      if (eq.mahasiswa) {
        exportData.push({
          NIM: eq.mahasiswa.nim,
          Nama: eq.mahasiswa.nama,
          Kelas: eq.kelas?.nama_kelas || '',
          Prodi: prodi.nama_prodi || '',
          Semester: activeSemester.nama || '',
          Pekerjaan: pekerjaan,
          'Jam Diakui': jamDiakui,
          'Total Nominal (Rp)': jamDiakui * 2000,
          Status: statusLabel,
          Tipe: 'Penanggung Jawab',
        });
      } else if (eq.kelas_id) {
        const classRegs = allRegs.filter((r) => r.kelas_id === eq.kelas_id);
        
        for (const r of classRegs) {
          if (!r.mahasiswa) continue;
          
          const totalJamWajib = r.mahasiswa.kompen_awal?.[0]?.total_jam_wajib || 0;
          const jamSelesai = jamSelesaiMap.get(r.nim!) || 0;
          const sisaJam = Math.floor(Math.max(0, totalJamWajib - jamSelesai));

          if (sisaJam > 0) {
            exportData.push({
              NIM: r.nim,
              Nama: r.mahasiswa.nama,
              Kelas: eq.kelas?.nama_kelas || '',
              Prodi: prodi.nama_prodi || '',
              Semester: activeSemester.nama || '',
              Pekerjaan: pekerjaan,
              'Jam Diakui': sisaJam,
              'Total Nominal (Rp)': sisaJam * 2000,
              Status: statusLabel,
              Tipe: 'Auto-Assign',
            });
          }
        }
      }
    }

    return NextResponse.json({
      prodiName: prodi.nama_prodi || 'Prodi',
      semesterName: activeSemester.nama || 'Semester',
      data: exportData
    }, { status: 200 });

  } catch (error) {
    console.error('Export error:', error);
    return NextResponse.json({ message: 'Terjadi kesalahan saat export' }, { status: 500 });
  }
}
