import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url);
  const kelas = searchParams.get("kelas");

  if (!kelas) {
    return NextResponse.json({ message: "kelas wajib" }, { status: 400 });
  }

  try {
    // 0. Cari semester aktif
    const activeSemester = await prisma.semester.findFirst({
      where: { is_aktif: true }
    });

    if (!activeSemester) {
      return NextResponse.json({ message: "Tidak ada semester aktif" }, { status: 404 });
    }

    // 1. Ambil data UTAMA dari tabel ekuivalensi_kelas, lalu dihubungkan (join) ke tabel lain
    const ekuivalensi = await prisma.ekuivalensi_kelas.findFirst({
      where: {
        kelas: {
            nama_kelas: kelas
        },
        semester_id: activeSemester.id
      },
      include: {
        status_ekuivalensi: true,
        mahasiswa: true, // Penanggung Jawab
        kelas: true      // Data Kelas
      }
    });

    // 2. Mapping ke UI
    let studentList: any[] = [];
    if (ekuivalensi) {
      if (ekuivalensi.mahasiswa) {
        // Ada Penanggung Jawab (dari pengajuan user)
        studentList = [{
          nama: ekuivalensi.mahasiswa.nama,
          nim: ekuivalensi.mahasiswa.nim,
          jam: Math.floor(ekuivalensi.jam_diakui || 0),
        }];
      } else if (ekuivalensi.kelas_id) {
        // Auto-assign: tidak ada penanggung jawab, ambil semua mahasiswa di kelas ini
        const regs = await prisma.registrasi_mahasiswa.findMany({
          where: {
            kelas_id: ekuivalensi.kelas_id,
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

        // Hitung sisa jam per mahasiswa
        const nims = regs.map((r) => r.nim).filter(Boolean) as string[];
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

        studentList = regs
          .filter((r) => r.mahasiswa)
          .map((r) => {
            const totalJam = r.mahasiswa?.kompen_awal?.[0]?.total_jam_wajib || 0;
            const jamSelesai = jamSelesaiMap.get(r.nim!) || 0;
            const sisaJam = Math.floor(Math.max(0, totalJam - jamSelesai));
            return {
              nama: r.mahasiswa!.nama,
              nim: r.nim,
              jam: sisaJam,
            };
          })
          .filter((s) => s.jam > 0);
      }
    }

    return NextResponse.json({
      mahasiswa: studentList, // Penanggung jawab (1 data) atau semua mahasiswa kelas (auto-assign)
      ekuivalensi: ekuivalensi ? {
        id: ekuivalensi.id,
        status: ekuivalensi.status_ekuivalensi?.nama?.toLowerCase() || 'pending',
        statusId: ekuivalensi.status_ekuivalensi_id,
        notaUrl: ekuivalensi.nota_url,
        // Nominal dihitung otomatis dari jam_diakui * 2000 sesuai instruksi
        nominal: (ekuivalensi.jam_diakui || 0) * 2000,
        jam: Math.floor(ekuivalensi.jam_diakui || 0),
        catatan: ekuivalensi.catatan || '',
        keterangan_pekerjaan: ekuivalensi.keterangan_pekerjaan || '',
        link_barang: ekuivalensi.link_barang || '',
        noTelepon: ekuivalensi.no_telepon || '',
        noTeleponChangeCount: ekuivalensi.no_telepon_change_count ?? 0,
        tanggal: ekuivalensi.created_at
      } : null
    });
  } catch (err) {
    console.error(err);
    return NextResponse.json(
      { message: "error ambil data" },
      { status: 500 }
    );
  }
}
