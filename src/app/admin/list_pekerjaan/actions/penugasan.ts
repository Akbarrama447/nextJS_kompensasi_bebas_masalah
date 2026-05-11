'use server';

import prisma from '@/lib/prisma';
import type {
  PenugasanRow,
  VerifyParams,
  RejectParams,
  VerifyResult,
  GetDaftarPenugasanParams,
  GetDaftarPenugasanResult,
  MahasiswaKompenRow,
  GetDaftarKompenParams,
  GetDaftarKompenResult,
} from '../types';

const STAFF_NIP_DEFAULT = '196801011990031001';

const STATUS_TUGAS = {
  MENUNGGU: 1,
  SEDANG_DIKERJAKAN: 2,
  SELESAI: 3,
  DIVERIFIKASI: 4,
} as const;

async function getActiveSemester() {
  const semester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true },
  });
  
  if (semester) return semester.id;
  
  const firstSemester = await prisma.semester.findFirst({
    select: { id: true },
    orderBy: { id: 'asc' },
  });
  
  return firstSemester?.id || null;
}

async function getStaffNip(): Promise<string> {
  const staff = await prisma.staf.findUnique({
    where: { nip: STAFF_NIP_DEFAULT },
    select: { nip: true },
  });
  
  if (staff) return staff.nip;
  
  const firstStaff = await prisma.staf.findFirst({
    select: { nip: true },
  });
  
  return firstStaff?.nip || STAFF_NIP_DEFAULT;
}

export async function getDaftarKompen(
  params?: GetDaftarKompenParams
): Promise<GetDaftarKompenResult> {
  const { 
    limit = 10, 
    offset = 0, 
    status_filter = 'semua',
    search = '',
    kelas_id,
  } = params || {};

  try {
    let semesterId: number | undefined;
    
    if (params?.semester_id) {
      semesterId = params.semester_id;
    } else {
      const activeSemester = await prisma.semester.findFirst({
        where: { is_aktif: true },
        select: { id: true },
      });
      semesterId = activeSemester?.id;
      
      if (!semesterId) {
        const firstSemester = await prisma.semester.findFirst({
          orderBy: { id: 'asc' },
          select: { id: true },
        });
        semesterId = firstSemester?.id;
      }
    }

    if (!semesterId) {
      return { data: [], total: 0 };
    }

    // Build where clause for kompen_awal
    const whereClause: any = {
      semester_id: semesterId,
      total_jam_wajib: { gt: 0 },
    };

    // Filter by class if provided
    if (kelas_id) {
      whereClause.mahasiswa = {
        registrasi_mahasiswa: {
          some: {
            kelas_id: kelas_id,
            semester_id: semesterId,
          }
        }
      };
    }

    // Get all kompen_awal for this semester with jam kompen > 0
    const kompenData = await prisma.kompen_awal.findMany({
      where: whereClause,
      include: {
        mahasiswa: {
          select: { nim: true, nama: true },
        },
      },
    });

    // Get all penugasan for this semester
    const allPenugasan = await prisma.penugasan.findMany({
      where: {
        pekerjaan: {
          semester_id: semesterId,
        },
      },
      include: {
        pekerjaan: {
          select: { id: true, judul: true, poin_jam: true },
        },
        status_tugas: {
          select: { id: true, nama: true },
        },
      },
      orderBy: { created_at: 'desc' },
    });

    // Create penugasan map by nim (collect ALL penugasan per student)
    const penugasanByNimGroup = new Map<string, any[]>();
    for (const p of allPenugasan) {
      if (p.nim) {
        if (!penugasanByNimGroup.has(p.nim)) {
          penugasanByNimGroup.set(p.nim, []);
        }
        penugasanByNimGroup.get(p.nim)!.push({
          id: p.id,
          pekerjaan_id: p.pekerjaan?.id || null,
          pekerjaan_judul: p.pekerjaan?.judul || null,
          poin_jam: p.pekerjaan?.poin_jam || null,
          status_tugas_id: p.status_tugas?.id || null,
          status_nama: p.status_tugas?.nama || null,
          created_at: p.created_at?.toISOString() || null,
        });
      }
    }

    // Get total jam already potong for all these NIMs
    const nimList = kompenData.map(k => k.nim).filter((n): n is string => n !== null);
    const logPotong = await prisma.log_potong_jam.groupBy({
      by: ['nim'],
      where: {
        nim: { in: nimList },
        semester_id: semesterId,
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

    // Build the data - all students with kompen (merged with penugasan if exists)
    let filteredData = kompenData.map(kompen => {
      const penugasans = kompen.nim ? (penugasanByNimGroup.get(kompen.nim) || []) : [];
      const jamDikurangi = potongMap.get(kompen.nim!) ?? 0;
      const totalJamWajib = kompen.total_jam_wajib ?? 0;
      const jamSisa = totalJamWajib - jamDikurangi;

      return {
        nim: kompen.nim || '',
        nama: kompen.mahasiswa?.nama || '',
        total_jam_wajib: totalJamWajib,
        jam_sudah_dikurangi: jamDikurangi,
        jam_sisa: jamSisa,
        // List of all assignments
        penugasans: penugasans,
        // Legacy fields for compatibility (take the first one if exists)
        status_tugas_id: penugasans[0]?.status_tugas_id ?? null,
        status_nama: penugasans[0]?.status_nama ?? null,
        pekerjaan_id: penugasans[0]?.pekerjaan_id ?? null,
        pekerjaan_judul: penugasans[0]?.pekerjaan_judul ?? null,
        poin_jam: penugasans[0]?.poin_jam ?? null,
        penugasan_id: penugasans[0]?.id ?? null,
        created_at: penugasans[0]?.created_at ?? null,
      };
    });

    // Apply search filter
    if (search) {
      filteredData = filteredData.filter(d => 
        d.nim?.toLowerCase().includes(search.toLowerCase()) ||
        d.nama?.toLowerCase().includes(search.toLowerCase())
      );
    }

    // Apply status filter
    if (status_filter === 'belum_ditugaskan') {
      filteredData = filteredData.filter(d => d.penugasan_id === null);
    } else if (status_filter === 'sedang_dikerjakan') {
      filteredData = filteredData.filter(d => d.status_tugas_id !== null && d.status_tugas_id !== 3 && d.status_tugas_id !== 4);
    } else if (status_filter === 'selesai') {
      filteredData = filteredData.filter(d => d.status_tugas_id === 3);
    }

    const totalCount = filteredData.length;
    const paginatedData = filteredData.slice(offset, offset + limit);

    return {
      data: paginatedData,
      total: totalCount,
    };
  } catch (error) {
    console.error('Error fetching daftar kompen:', error);
    return { data: [], total: 0 };
  }
}

export async function verifyPenugasan(
  params: VerifyParams
): Promise<VerifyResult> {
  const { penugasan_id } = params;

  try {
    const { cookies } = await import('next/headers')
    const cookieStore = await cookies()
    const nipCookie = cookieStore.get('nip')?.value
    let verifikasi_oleh_nip: string

    if (nipCookie) {
      verifikasi_oleh_nip = nipCookie
    } else {
      verifikasi_oleh_nip = await getStaffNip()
    }
    const penugasan = await prisma.penugasan.findUnique({
      where: { id: penugasan_id },
      include: {
        pekerjaan: {
          select: { semester_id: true, poin_jam: true },
        },
        mahasiswa: {
          select: { nim: true },
        },
      },
    });

    if (!penugasan) {
      return { success: false, error: 'Penugasan tidak ditemukan' };
    }

    if (penugasan.status_tugas_id !== STATUS_TUGAS.SELESAI) {
      return { success: false, error: 'Penugasan belum selesai' };
    }

    const semesterId = penugasan.pekerjaan?.semester_id;
    
    if (!semesterId) {
      return { success: false, error: 'Semester tidak ditemukan' };
    }

    const jamDikurangi = penugasan.pekerjaan?.poin_jam || 0;

    await prisma.$transaction([
      prisma.log_potong_jam.create({
        data: {
          nim: penugasan.nim,
          semester_id: semesterId,
          penugasan_id: penugasan.id,
          jam_dikurangi: jamDikurangi,
          keterangan: 'Potong jam kompen dari verifikasi penugasan',
        },
      }),
      prisma.penugasan.update({
        where: { id: penugasan_id },
        data: {
          status_tugas_id: STATUS_TUGAS.DIVERIFIKASI,
          diverifikasi_oleh_nip: verifikasi_oleh_nip,
          waktu_verifikasi: new Date(),
        },
      }),
    ]);

    return { success: true };
  } catch (error) {
    console.error('Error verifying penugasan:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}

export async function rejectPenugasan(
  params: RejectParams
): Promise<VerifyResult> {
  const { penugasan_id, catatan_verifikasi } = params;

  try {
    const exists = await prisma.penugasan.findUnique({
      where: { id: penugasan_id },
      select: { id: true, status_tugas_id: true },
    });

    if (!exists) {
      return { success: false, error: 'Penugasan tidak ditemukan' };
    }

    if (exists.status_tugas_id !== STATUS_TUGAS.SELESAI) {
      return { success: false, error: 'Penugasan belum selesai' };
    }

    await prisma.penugasan.update({
      where: { id: penugasan_id },
      data: {
        status_tugas_id: STATUS_TUGAS.SEDANG_DIKERJAKAN,
        catatan_verifikasi: catatan_verifikasi,
        diverifikasi_oleh_nip: null,
        waktu_verifikasi: null,
      },
    });

    return { success: true };
  } catch (error) {
    console.error('Error rejecting penugasan:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}