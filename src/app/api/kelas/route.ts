import prisma from "@/lib/prisma";
import { NextResponse } from "next/server";

export async function GET() {
  try {
    const classes = await prisma.kelas.findMany({
      orderBy: {
        nama_kelas: 'asc'
      }
    });
    return NextResponse.json(classes);
  } catch (err) {
    console.error("Error fetching classes:", err);
    return NextResponse.json({ error: "Failed to fetch classes" }, { status: 500 });
  }
}
