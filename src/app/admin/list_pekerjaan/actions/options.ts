'use server';

import prisma from '@/lib/prisma';
import type { OptionsData } from '../types';

export async function getOptions(): Promise<OptionsData> {
  try {
    let [tipePekerjaan, ruangan, semesterAktif, kelas] = await Promise.all([
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
      prisma.kelas.findMany({
        select: { id: true, nama_kelas: true },
        orderBy: { nama_kelas: 'asc' },
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
      kelas: kelas.map(k => ({ id: k.id, nama_kelas: k.nama_kelas || '' })),
    };
  } catch (error) {
    console.error('Error fetching options:', error);
    return {
      tipe_pekerjaan: [],
      ruangan: [],
      semester_aktif: null,
      kelas: [],
    };
  }
}

export async function getMahasiswaByKelas(kelasId: number) {
  try {
    const activeSemester = await prisma.semester.findFirst({
      where: { is_aktif: true },
      select: { id: true },
    });

    if (!activeSemester) return [];

    const mahasiswaList = await prisma.mahasiswa.findMany({
      where: {
        registrasi_mahasiswa: {
          some: {
            kelas_id: kelasId,
            semester_id: activeSemester.id,
          },
        },
      },
      select: {
        nim: true,
        nama: true,
        kompen_awal: {
          where: { semester_id: activeSemester.id },
          select: { total_jam_wajib: true }
        },
        penugasan: {
          where: {
            pekerjaan: { semester_id: activeSemester.id },
            status_tugas_id: {
              notIn: [4] // 4 = DIVERIFIKASI
            }
          },
          select: {
            pekerjaan: {
              select: { poin_jam: true }
            }
          }
        }
      },
      orderBy: { nama: 'asc' },
    });

    return mahasiswaList.map(mhs => {
      const totalWajib = mhs.kompen_awal[0]?.total_jam_wajib || 0;
      const jamTerpakai = mhs.penugasan.reduce((acc, p) => acc + (p.pekerjaan?.poin_jam || 0), 0);
      const jamSisa = Math.max(0, totalWajib - jamTerpakai);

      return {
        nim: mhs.nim,
        nama: mhs.nama || 'Tanpa Nama',
        jam_sisa: jamSisa
      };
    }).filter(mhs => mhs.jam_sisa > 0);
  } catch (error) {
    console.error('Error fetching mahasiswa by kelas:', error);
    return [];
  }
}