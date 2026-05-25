import prisma from "@/lib/prisma";
import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { ekuivalensiId, keterangan_pekerjaan } = body;

    if (!ekuivalensiId || !keterangan_pekerjaan) {
      return NextResponse.json(
        { message: "ekuivalensiId dan keterangan_pekerjaan diperlukan" },
        { status: 400 }
      );
    }

    const ekuivalensi = await prisma.ekuivalensi_kelas.findUnique({
      where: { id: ekuivalensiId },
    });

    if (!ekuivalensi) {
      return NextResponse.json(
        { message: "Data ekuivalensi tidak ditemukan" },
        { status: 404 }
      );
    }

    await prisma.ekuivalensi_kelas.update({
      where: { id: ekuivalensiId },
      data: {
        keterangan_pekerjaan: keterangan_pekerjaan,
      },
    });

    return NextResponse.json({
      success: true,
      message: "Pekerjaan berhasil disimpan",
    });
  } catch (error) {
    console.error("Save pekerjaan error:", error);
    return NextResponse.json(
      { message: "Terjadi kesalahan server saat menyimpan pekerjaan" },
      { status: 500 }
    );
  }
}
