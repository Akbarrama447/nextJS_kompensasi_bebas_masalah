'use server';

import prisma from '@/lib/prisma';
import type {
  LaporanKompensasiResult,
  LaporanMahasiswaData,
  LaporanAngkatan,
  ExportFiltersResult,
} from '../types';

interface GetDataLaporanKompensasiParams {
  semester_id: number;
  angkatan?: 1 | 2 | 3; // undefined = semua angkatan
  prodi_id?: number; // undefined = semua prodi
  kelas_id?: number; // undefined = semua kelas
}

export async function getExportFilters(): Promise<ExportFiltersResult> {
  const [prodiData, kelasData] = await Promise.all([
    prisma.prodi.findMany({
      select: { id: true, nama_prodi: true },
      orderBy: { nama_prodi: 'asc' },
    }),
    prisma.kelas.findMany({
      select: { id: true, nama_kelas: true, prodi_id: true },
      orderBy: { nama_kelas: 'asc' },
    }),
  ]);

  return {
    prodi: prodiData.map(p => ({ id: p.id, nama: p.nama_prodi || '' })),
    kelas: kelasData.map(k => ({
      id: k.id,
      nama: k.nama_kelas || '',
      prodi_id: k.prodi_id,
    })),
  };
}

/**
 * Extract angkatan number from kelas name (e.g., "1A" -> 1, "2B" -> 2, "TI-1A" -> 1, "IK-2B" -> 2)
 */
function getAngkatanFromKelas(nama_kelas: string): number | null {
  if (!nama_kelas || nama_kelas === '-') return null;

  // Try matching digit at start first (e.g., "1A" -> 1, "2B" -> 2)
  const matchStart = nama_kelas.match(/^(\d)/);
  if (matchStart) return parseInt(matchStart[1]);

  // Fallback: find any digit in the string (e.g., "TI-1A" -> 1, "IK-2B" -> 2)
  const matchAny = nama_kelas.match(/(\d)/);
  if (matchAny) return parseInt(matchAny[1]);

  return null;
}

/**
 * Get data laporan kompensasi mahasiswa untuk export
 * Mengambil semua mahasiswa yang memiliki kompen_awal > 0 di semester tertentu
 */
export async function getDataLaporanKompensasi(
  params: GetDataLaporanKompensasiParams
): Promise<LaporanKompensasiResult> {
  const { semester_id, angkatan, prodi_id, kelas_id } = params;

  try {
    // 1. Get semester info
    const semester = await prisma.semester.findUnique({
      where: { id: semester_id },
      select: { id: true, nama: true, tahun: true },
    });

    if (!semester) {
      return { success: false, error: 'Semester tidak ditemukan' };
    }

    let prodiNama = '';

    // 3. Get all kompen_awal for this semester with jam > 0
    const kompenData = await prisma.kompen_awal.findMany({
      where: {
        semester_id,
        total_jam_wajib: { gt: 0 },
      },
      include: {
        mahasiswa: {
          select: {
            nim: true,
            nama: true,
          },
        },
      },
      orderBy: {
        nim: 'asc',
      },
    });

    if (kompenData.length === 0) {
      return { success: false, error: 'Tidak ada data mahasiswa dengan kompensasi' };
    }

    const nimList = kompenData.map(k => k.nim).filter((n): n is string => n !== null);

    // 4. Get registrasi_mahasiswa (untuk dapat kelas dan filter prodi/kelas)
    const registrasiMap = new Map<string, string>(); // nim -> nama_kelas
    const nimProdiMap = new Map<string, number>(); // nim -> prodi_id
    const nimKelasMap = new Map<string, number>(); // nim -> kelas_id
    const registrasiData = await prisma.registrasi_mahasiswa.findMany({
      where: {
        nim: { in: nimList },
        semester_id,
      },
      include: {
        kelas: {
          select: {
            id: true,
            nama_kelas: true,
            prodi_id: true,
            prodi: {
              select: {
                nama_prodi: true,
              },
            },
          },
        },
      },
    });

    for (const reg of registrasiData) {
      if (reg.nim && reg.kelas?.nama_kelas) {
        registrasiMap.set(reg.nim, reg.kelas.nama_kelas);
      }
      if (reg.nim && reg.kelas?.prodi_id) {
        nimProdiMap.set(reg.nim, reg.kelas.prodi_id);
      }
      if (reg.nim && reg.kelas?.id) {
        nimKelasMap.set(reg.nim, reg.kelas.id);
      }
      // Ambil metadata dari siswa pertama yang cocok
      if (!prodiNama && reg.kelas?.prodi?.nama_prodi) {
        prodiNama = reg.kelas.prodi.nama_prodi;
      }
    }

    // Fallback jika tidak ada data registrasi
    if (!prodiNama) prodiNama = 'D4 Teknik Informatika';

    // 5. Get all penugasan for these students in this semester
    const penugasanData = await prisma.penugasan.findMany({
      where: {
        nim: { in: nimList },
        pekerjaan: {
          semester_id,
        },
      },
      include: {
        pekerjaan: {
          select: {
            judul: true,
            poin_jam: true,
          },
        },
      },
    });

    // Group penugasan by nim
    const penugasanByNim = new Map<string, typeof penugasanData>();
    for (const p of penugasanData) {
      if (p.nim) {
        if (!penugasanByNim.has(p.nim)) {
          penugasanByNim.set(p.nim, []);
        }
        penugasanByNim.get(p.nim)!.push(p);
      }
    }

    // 6. Get log_potong_jam (total jam yang sudah dikurangi)
    const logPotong = await prisma.log_potong_jam.groupBy({
      by: ['nim'],
      where: {
        nim: { in: nimList },
        semester_id,
      },
      _sum: {
        jam_dikurangi: true,
      },
    });

    const potongMap = new Map<string, number>();
    for (const lp of logPotong) {
      if (lp.nim) {
        potongMap.set(lp.nim, lp._sum.jam_dikurangi ?? 0);
      }
    }

    // 7. Build mahasiswa data with calculations
    const mahasiswaDataList: (LaporanMahasiswaData & { angkatan: number | null })[] = [];

    for (const kompen of kompenData) {
      if (!kompen.nim || !kompen.mahasiswa) continue;

      const nim = kompen.nim;
      const nama = kompen.mahasiswa.nama || '';
      const kelas = registrasiMap.get(nim) || '-';
      const angkatanNum = getAngkatanFromKelas(kelas);

      // Skip if angkatan filter is set and doesn't match
      if (angkatan !== undefined && angkatanNum !== angkatan) {
        continue;
      }

      // Skip if prodi filter is set and doesn't match
      if (prodi_id !== undefined) {
        const mhsProdiId = nimProdiMap.get(nim);
        if (mhsProdiId !== prodi_id) {
          continue;
        }
      }

      // Skip if kelas filter is set and doesn't match
      if (kelas_id !== undefined) {
        const mhsKelasId = nimKelasMap.get(nim);
        if (mhsKelasId !== kelas_id) {
          continue;
        }
      }

      const totalJamWajib = kompen.total_jam_wajib ?? 0;
      const jamSudahDikurangi = potongMap.get(nim) ?? 0;
      const jamSisa = totalJamWajib - jamSudahDikurangi;
      const statusLunas = jamSisa <= 0;

      // Get list of pekerjaan
      const penugasanList = penugasanByNim.get(nim) || [];
      const pekerjaanList = penugasanList
        .map(p => p.pekerjaan?.judul)
        .filter((j): j is string => !!j);

      mahasiswaDataList.push({
        nim,
        nama,
        kelas,
        total_jam_wajib: totalJamWajib,
        jam_sudah_dikurangi: jamSudahDikurangi,
        jam_sisa: jamSisa,
        status_lunas: statusLunas,
        pekerjaan_list: pekerjaanList,
        angkatan: angkatanNum,
      });
    }

    // 8. Group by angkatan
    const angkatanMap = new Map<number, LaporanMahasiswaData[]>();
    for (const m of mahasiswaDataList) {
      const angkatanKey = m.angkatan ?? 0; // 0 = tidak diketahui

      if (!angkatanMap.has(angkatanKey)) {
        angkatanMap.set(angkatanKey, []);
      }

      // Remove angkatan property before adding to map
      const { angkatan: _, ...mahasiswaData } = m;
      angkatanMap.get(angkatanKey)!.push(mahasiswaData);
    }

    // 9. Build result structure
    const mahasiswaByAngkatan: LaporanAngkatan[] = [];
    const sortedAngkatan = Array.from(angkatanMap.keys()).sort((a, b) => a - b);

    for (const angkatanNum of sortedAngkatan) {
      const mahasiswaList = angkatanMap.get(angkatanNum)!;

      // Sort by kelas then nama
      mahasiswaList.sort((a, b) => {
        if (a.kelas !== b.kelas) return a.kelas.localeCompare(b.kelas);
        return a.nama.localeCompare(b.nama);
      });

      // Calculate summary
      const totalMahasiswa = mahasiswaList.length;
      const totalLunas = mahasiswaList.filter(m => m.status_lunas).length;
      const totalBelumLunas = totalMahasiswa - totalLunas;

      mahasiswaByAngkatan.push({
        angkatan: angkatanNum,
        mahasiswa: mahasiswaList,
        summary: {
          total_mahasiswa: totalMahasiswa,
          total_lunas: totalLunas,
          total_belum_lunas: totalBelumLunas,
        },
      });
    }

    if (mahasiswaByAngkatan.length === 0) {
      const debugInfo = {
        totalKompenData: kompenData.length,
        totalMahasiswaDataList: mahasiswaDataList.length,
        angkatanMapKeys: Array.from(angkatanMap.keys()),
      };
      console.error('Export laporan empty:', debugInfo);
      return { success: false, error: 'Tidak ada data mahasiswa untuk angkatan yang dipilih' };
    }

    // 10. Build final result
    const tanggalGenerate = new Date().toISOString();

    return {
      success: true,
      data: {
        metadata: {
          semester_nama: semester.nama || '',
          semester_tahun: semester.tahun || 0,
          prodi_nama: prodiNama,
          tanggal_generate: tanggalGenerate,
          angkatan_filter: angkatan || null,
          prodi_filter: prodi_id || null,
          kelas_filter: kelas_id || null,
        },
        mahasiswa_by_angkatan: mahasiswaByAngkatan,
      },
    };
  } catch (error) {
    console.error('Error fetching laporan kompensasi:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: `Gagal mengambil data: ${message}` };
  }
}