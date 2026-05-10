import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { ekuivalensiId, statusId, catatan } = body;

    if (!ekuivalensiId || !statusId) {
      return NextResponse.json({ message: "ID dan Status wajib diisi" }, { status: 400 });
    }

    // 1. Siapkan data yang akan diupdate
    const updateData: any = {
      status_ekuivalensi_id: Number(statusId),
      catatan: catatan || null,
      // verified_by_nip: "ADMIN_DEMO", // Hardcoded for now based on middleware
    };

    // 2. Jika disetujui (statusId = 2), ubah jam_diakui dan nominal_total menjadi 0
    if (Number(statusId) === 2) {
      updateData.jam_diakui = 0;
      updateData.nominal_total = 0;
    }

    // 3. Update status ekuivalensi
    const updatedEkuivalensi = await prisma.ekuivalensi_kelas.update({
      where: { id: Number(ekuivalensiId) },
      data: updateData,
    });

    return NextResponse.json({ message: "Berhasil update status", data: updatedEkuivalensi });
  } catch (err) {
    console.error("Error verifying ekuivalensi:", err);
    return NextResponse.json({ message: "Gagal update status" }, { status: 500 });
  }
}
