import prisma from "@/lib/prisma";
import { NextRequest, NextResponse } from "next/server";
import { authErrorResponse, requireAdmin } from "@/lib/auth";

export async function POST(req: NextRequest) {
  try {
    await requireAdmin();

    const body = await req.json();
    const { ekuivalensiId, link_barang } = body;

    if (!ekuivalensiId || link_barang === undefined) {
      return NextResponse.json(
        { message: "ekuivalensiId dan link_barang diperlukan" },
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
        link_barang: link_barang,
      },
    });

    return NextResponse.json({
      success: true,
      message: "Link barang berhasil disimpan",
    });
  } catch (error) {
    const authResponse = authErrorResponse(error);
    if (authResponse) return authResponse;

    console.error("Save link barang error:", error);
    return NextResponse.json(
      { message: "Terjadi kesalahan server saat menyimpan link barang" },
      { status: 500 }
    );
  }
}
