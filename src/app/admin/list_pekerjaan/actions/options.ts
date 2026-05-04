'use server';

import prisma from '@/lib/prisma';
import type { OptionsData } from '../types';

export async function getOptions(): Promise<OptionsData> {
  try {
    let [tipePekerjaan, ruangan, semesterAktif] = await Promise.all([
      prisma.ref_tipe_pekerjaan.findMany({
        select: { id: true, nama: true },
        orderBy: { id: 'asc' },
      }),
      prisma.ruangan.findMany({
        include: {
          gedung: {
            select: { nama_gedung: true },
          },
        },
        orderBy: { nama_ruangan: 'asc' },
      }),
      prisma.semester.findFirst({
        where: { is_aktif: true },
        select: { id: true, nama: true },
      }),
    ]);

    // Jika tipe pekerjaan kosong, buat default dengan upsert
    if (tipePekerjaan.length === 0) {
      const defaultTypes = [
        { id: 1, nama: 'Internal' },
        { id: 2, nama: 'Eksternal' },
      ];
      
      for (const type of defaultTypes) {
        try {
          await prisma.ref_tipe_pekerjaan.upsert({
            where: { id: type.id },
            update: {},
            create: type,
          });
        } catch (e) {
          // Ignore duplicate errors
        }
      }
      
      tipePekerjaan = await prisma.ref_tipe_pekerjaan.findMany({
        select: { id: true, nama: true },
        orderBy: { id: 'asc' },
      });
    }

    const formattedRuangan = ruangan.map((r) => ({
      id: r.id,
      nama_ruangan: r.nama_ruangan || '',
      gedung: r.gedung?.nama_gedung || undefined,
    }));

    return {
      tipe_pekerjaan: tipePekerjaan.map(t => ({ id: t.id, nama: t.nama || '' })),
      ruangan: formattedRuangan,
      semester_aktif: semesterAktif ? { id: semesterAktif.id, nama: semesterAktif.nama || '' } : null,
    };
  } catch (error) {
    console.error('Error fetching options:', error);
    return {
      tipe_pekerjaan: [],
      ruangan: [],
      semester_aktif: null,
    };
  }
}