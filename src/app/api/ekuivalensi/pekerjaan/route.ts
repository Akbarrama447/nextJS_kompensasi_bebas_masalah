import prisma from "@/lib/prisma";
import { NextRequest, NextResponse } from "next/server";
import { authErrorResponse, requireAdmin } from "@/lib/auth";
import { STATUS_EKUIVALENSI } from "@/lib/constants";

export async function POST(req: NextRequest) {
  try {
    await requireAdmin();

    const body = await req.json();
    const { ekuivalensiId, keterangan_pekerjaan, kelas } = body;

    if (!keterangan_pekerjaan) {
      return NextResponse.json(
        { message: "keterangan_pekerjaan diperlukan" },
        { status: 400 }
      );
    }

    let targetId = ekuivalensiId;

    // Jika ekuivalensiId tidak diberikan, cari atau buat baru berdasarkan kelas + semester aktif
    if (!targetId) {
      if (!kelas) {
        return NextResponse.json(
          { message: "kelas diperlukan jika ekuivalensiId tidak diberikan" },
          { status: 400 }
        );
      }

      const activeSemester = await prisma.semester.findFirst({
        where: { is_aktif: true },
      });

      if (!activeSemester) {
        return NextResponse.json(
          { message: "Tidak ada semester aktif" },
          { status: 404 }
        );
      }

      const kelasData = await prisma.kelas.findFirst({
        where: { nama_kelas: kelas },
      });

      if (!kelasData) {
        return NextResponse.json(
          { message: "Kelas tidak ditemukan" },
          { status: 404 }
        );
      }

      // Cari ekuivalensi yang sudah ada
      const existing = await prisma.ekuivalensi_kelas.findFirst({
        where: {
          kelas_id: kelasData.id,
          semester_id: activeSemester.id,
        },
      });

      if (existing) {
        targetId = existing.id;
      } else {
        // Buat baru — langsung return karena keterangan_pekerjaan sudah di-set
        await prisma.ekuivalensi_kelas.create({
          data: {
            kelas_id: kelasData.id,
            semester_id: activeSemester.id,
            keterangan_pekerjaan: keterangan_pekerjaan,
            status_ekuivalensi_id: STATUS_EKUIVALENSI.MENUNGGU,
          },
        });

        return NextResponse.json({
          success: true,
          message: "Pekerjaan berhasil disimpan",
        });
      }
    } else {
      // Validasi ekuivalensiId exists
      const existing = await prisma.ekuivalensi_kelas.findUnique({
        where: { id: targetId },
      });

      if (!existing) {
        return NextResponse.json(
          { message: "Data ekuivalensi tidak ditemukan" },
          { status: 404 }
        );
      }
    }

    // Update existing record
    await prisma.ekuivalensi_kelas.update({
      where: { id: targetId },
      data: {
        keterangan_pekerjaan: keterangan_pekerjaan,
      },
    });

    return NextResponse.json({
      success: true,
      message: "Pekerjaan berhasil disimpan",
    });
  } catch (error) {
    const authResponse = authErrorResponse(error);
    if (authResponse) return authResponse;

    console.error("Save pekerjaan error:", error);
    return NextResponse.json(
      { message: "Terjadi kesalahan server saat menyimpan pekerjaan" },
      { status: 500 }
    );
  }
}
