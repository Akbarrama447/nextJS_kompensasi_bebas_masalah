import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET() {
  try {
    const data = await prisma.ekuivalensi_kelas.findMany({
      include: {
        kelas: true,
        mahasiswa: true,
        status_ekuivalensi: true,
      },
      orderBy: {
        created_at: "desc",
      },
    });

    return NextResponse.json(data);
  } catch (error) {
    console.error(error);

    return NextResponse.json(
      { message: "Gagal ambil data ekuivalensi" },
      { status: 500 }
    );
  }
}