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
    // Karena tabel utama adalah ekuivalensi_kelas, maka yang ditampilkan di tabel UI
    // adalah sang Penanggung Jawab pengajuan tersebut (beserta jam_diakui-nya).
    let studentList: any[] = [];
    if (ekuivalensi && ekuivalensi.mahasiswa) {
        studentList = [{
            nama: ekuivalensi.mahasiswa.nama,
            nim: ekuivalensi.mahasiswa.nim,
            jam: ekuivalensi.jam_diakui || 0,
        }];
    }

    return NextResponse.json({
      mahasiswa: studentList, // Akan berisi array dengan 1 data penanggung jawab
      ekuivalensi: ekuivalensi ? {
        id: ekuivalensi.id,
        status: ekuivalensi.status_ekuivalensi?.nama?.toLowerCase() || 'pending',
        statusId: ekuivalensi.status_ekuivalensi_id,
        notaUrl: ekuivalensi.nota_url,
        // Nominal dihitung otomatis dari jam_diakui * 2000 sesuai instruksi
        nominal: (ekuivalensi.jam_diakui || 0) * 2000,
        jam: ekuivalensi.jam_diakui || 0,
        catatan: ekuivalensi.catatan || '',
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