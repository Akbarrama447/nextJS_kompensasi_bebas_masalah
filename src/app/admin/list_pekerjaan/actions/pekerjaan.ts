'use server';

import prisma from '@/lib/prisma';
import type {
  PekerjaanForm,
  PekerjaanRow,
  CreateResult,
  DeleteResult,
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

export async function createPekerjaan(
  data: PekerjaanForm
): Promise<CreateResult> {
  try {
    const [semesterId, staffNip] = await Promise.all([
      getActiveSemester(),
      getStaffNip(),
    ]);

    if (!semesterId) {
      return { success: false, error: 'Tidak ada semester aktif' };
    }

    if (!data.tipe_pekerjaan_id) {
      return { success: false, error: 'Tipe pekerjaan wajib dipilih' };
    }

    const tipeExists = await prisma.ref_tipe_pekerjaan.findUnique({
      where: { id: data.tipe_pekerjaan_id },
    });

    if (!tipeExists) {
      return { success: false, error: 'Tipe pekerjaan tidak valid' };
    }

    if (data.ruangan_id) {
      const ruanganExists = await prisma.ruangan.findUnique({
        where: { id: data.ruangan_id },
      });

      if (!ruanganExists) {
        return { success: false, error: 'Ruangan tidak valid' };
      }
    }

    const newPekerjaan = await prisma.daftar_pekerjaan.create({
      data: {
        judul: data.judul,
        deskripsi: data.deskripsi || null,
        tipe_pekerjaan_id: data.tipe_pekerjaan_id,
        poin_jam: data.poin_jam,
        kuota: data.quota || 1,
        tanggal_mulai: data.tanggal_mulai
          ? new Date(data.tanggal_mulai)
          : null,
        tanggal_selesai: data.tanggal_selesai
          ? new Date(data.tanggal_selesai)
          : null,
        ruangan_id: data.ruangan_id || null,
        semester_id: data.semester_id || semesterId,
        staf_nip: staffNip,
        is_aktif: true,
      },
      select: { id: true },
    });

    return { success: true, id: newPekerjaan.id };
  } catch (error) {
    console.error('Error creating pekerjaan:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}

interface PaginationParams {
  limit?: number;
  offset?: number;
}

interface GetDaftarPekerjaanResult {
  data: PekerjaanRow[];
  total: number;
}

export async function getDaftarPekerjaan(
  filters?: {
    semester_id?: number;
    is_aktif?: boolean;
  } & PaginationParams
): Promise<GetDaftarPekerjaanResult | PekerjaanRow[]> {
  const returnAll = filters === undefined;
  const { limit = 10, offset = 0, ...filterRest } = filters || {};

  try {
    let semesterId: number | undefined;

    if (filters?.semester_id) {
      semesterId = filters.semester_id;
    } else {
      const activeSemester = await prisma.semester.findFirst({
        where: { is_aktif: true },
        select: { id: true },
      });
      semesterId = activeSemester?.id;
    }

    const whereClause: any = {};

    if (semesterId) {
      whereClause.semester_id = semesterId;
    }

    if (filters?.is_aktif !== undefined) {
      whereClause.is_aktif = filters.is_aktif;
    }

    const [pekerjaan, totalCount] = await Promise.all([
      prisma.daftar_pekerjaan.findMany({
        where: whereClause,
        include: {
          staf: {
            select: { nip: true, nama: true },
          },
          tipe_pekerjaan: {
            select: { id: true, nama: true },
          },
          ruangan: {
            select: { id: true, nama_ruangan: true },
          },
          penugasan: {
            where: {
              status_tugas_id: {
                notIn: [STATUS_TUGAS.SELESAI, STATUS_TUGAS.DIVERIFIKASI],
              },
            },
            select: { id: true },
          },
        },
        orderBy: { created_at: 'desc' },
        take: limit,
        skip: offset,
      }),
      prisma.daftar_pekerjaan.count({ where: whereClause }),
    ]);

    const mappedData = pekerjaan.map((p) => ({
      id: p.id,
      judul: p.judul || '',
      tipe: p.tipe_pekerjaan?.nama || 'Unknown',
      poin: p.poin_jam || 0,
      kuotatersisa: (p.kuota || 0) - p.penugasan.length,
      kuotatotal: p.kuota || 0,
      tanggal_mulai: p.tanggal_mulai?.toISOString() || null,
      tanggal_selesai: p.tanggal_selesai?.toISOString() || null,
      is_aktif: p.is_aktif || false,
      created_at: p.created_at?.toISOString() || new Date().toISOString(),
      staf: p.staf ? { nip: p.staf.nip, nama: p.staf.nama || '' } : undefined,
      ruangan: p.ruangan
        ? { id: p.ruangan.id, nama_ruangan: p.ruangan.nama_ruangan || '' }
        : undefined,
      tipe_pekerjaan: p.tipe_pekerjaan
        ? { id: p.tipe_pekerjaan.id, nama: p.tipe_pekerjaan.nama || '' }
        : undefined,
    }));

    if (returnAll) {
      return mappedData;
    }

    return {
      data: mappedData,
      total: totalCount,
    };
  } catch (error) {
    console.error('Error fetching daftar pekerjaan:', error);
    return { data: [], total: 0 };
  }
}

export async function updatePekerjaan(
  id: number,
  data: Partial<PekerjaanForm>
): Promise<{ success: boolean; error?: string }> {
  try {
    const exists = await prisma.daftar_pekerjaan.findUnique({
      where: { id },
      select: { id: true },
    });

    if (!exists) {
      return { success: false, error: 'Pekerjaan tidak ditemukan' };
    }

    const updateData: any = {};

    if (data.judul !== undefined) updateData.judul = data.judul;
    if (data.deskripsi !== undefined) updateData.deskripsi = data.deskripsi;
    if (data.tipe_pekerjaan_id !== undefined) {
      const tipeExists = await prisma.ref_tipe_pekerjaan.findUnique({
        where: { id: data.tipe_pekerjaan_id },
      });
      if (!tipeExists) {
        return { success: false, error: 'Tipe pekerjaan tidak valid' };
      }
      updateData.tipe_pekerjaan_id = data.tipe_pekerjaan_id;
    }
    if (data.poin_jam !== undefined) updateData.poin_jam = data.poin_jam;
    if (data.tanggal_mulai !== undefined) {
      updateData.tanggal_mulai = data.tanggal_mulai
        ? new Date(data.tanggal_mulai)
        : null;
    }
    if (data.tanggal_selesai !== undefined) {
      updateData.tanggal_selesai = data.tanggal_selesai
        ? new Date(data.tanggal_selesai)
        : null;
    }
    if (data.ruangan_id !== undefined) {
      if (data.ruangan_id) {
        const ruanganExists = await prisma.ruangan.findUnique({
          where: { id: data.ruangan_id },
        });
        if (!ruanganExists) {
          return { success: false, error: 'Ruangan tidak valid' };
        }
      }
      updateData.ruangan_id = data.ruangan_id || null;
    }

    await prisma.daftar_pekerjaan.update({
      where: { id },
      data: updateData,
    });

    return { success: true };
  } catch (error) {
    console.error('Error updating pekerjaan:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}

export async function deletePekerjaan(id: number): Promise<DeleteResult> {
  try {
    const exists = await prisma.daftar_pekerjaan.findUnique({
      where: { id },
      select: { id: true },
    });

    if (!exists) {
      return { success: false, error: 'Pekerjaan tidak ditemukan' };
    }

    // 1. Cek apakah ada yang sudah SELESAI atau DIVERIFIKASI atau SEDANG DIKERJAKAN
    // Jika sudah ada yang selesai/diverifikasi, HARUS dilarang hapus (integritas data)
    const finalizedAssignments = await prisma.penugasan.count({
      where: {
        pekerjaan_id: id,
        status_tugas_id: {
          in: [STATUS_TUGAS.SELESAI, STATUS_TUGAS.DIVERIFIKASI, STATUS_TUGAS.SEDANG_DIKERJAKAN],
        },
      },
    });

    if (finalizedAssignments > 0) {
      return {
        success: false,
        error: `Pekerjaan tidak bisa dihapus karena sudah ada ${finalizedAssignments} mahasiswa yang menyelesaikan tugas ini.`,
      };
    }

    // 2. Jika ada yang masih MENUNGGU atau SEDANG_DIKERJAKAN, 
    // hapus penugasan mereka terlebih dahulu (Auto-Cancel)
    await prisma.penugasan.deleteMany({
      where: {
        pekerjaan_id: id,
        status_tugas_id: {
          in: [STATUS_TUGAS.MENUNGGU],
        },
      },
    });

    // 3. Soft delete pekerjaannya
    await prisma.daftar_pekerjaan.update({
      where: { id: id },
      data: { is_aktif: false },
    });

    return { success: true };
  } catch (error) {
    console.error('Error deleting pekerjaan:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}