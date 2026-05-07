'use server';

import prisma from '@/lib/prisma';
import type { PlottingConfig, PlottingResult } from '../types';

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

interface MhsWithJam {
  nim: string;
  nama: string;
  totalJamWajib: number;
  jamSisa: number;
}

export async function generatePlotting(
  config?: PlottingConfig
): Promise<PlottingResult> {
  try {
    const semesterId = config?.semester_id || await getActiveSemester();
    
    if (!semesterId) {
      return { success: false, error: 'Tidak ada semester aktif' };
    }

    const maxJamPerHari = config?.maxJamPerHari || 8;
    const sortBy = config?.sortBy || 'nim';
    const remainingAssignments: any[] = [];

    const pekerjaanList = await prisma.daftar_pekerjaan.findMany({
      where: {
        is_aktif: true,
        semester_id: semesterId,
        AND: [
          { kuota: { gt: 0 } },
        ],
      },
      include: {
        penugasan: {
          where: {
            status_tugas_id: {
              notIn: [STATUS_TUGAS.SELESAI, STATUS_TUGAS.DIVERIFIKASI],
            },
          },
          select: { id: true, nim: true },
        },
      },
      orderBy: { created_at: 'asc' },
    });

    const pekerjaanReady = pekerjaanList.filter(
      (p) => (p.kuota || 0) > p.penugasan.length
    );

    if (pekerjaanReady.length === 0) {
      return { success: false, error: 'Tidak ada pekerjaan dengan kuota kosong' };
    }

    const assignedNims = new Set<string>();
    for (const p of pekerjaanList) {
      for (const penugasan of p.penugasan) {
        if (penugasan.nim) {
          assignedNims.add(penugasan.nim);
        }
      }
    }

    const kompenAwalList = await prisma.kompen_awal.findMany({
      where: {
        semester_id: semesterId,
        total_jam_wajib: { gt: 0 },
      },
      include: {
        mahasiswa: {
          select: { nim: true, nama: true },
        },
      },
    });

    // Get assigned penugasan separately to avoid invalid include
    const activePenugasan = await prisma.penugasan.findMany({
      where: {
        status_tugas_id: {
          notIn: [STATUS_TUGAS.SELESAI, STATUS_TUGAS.DIVERIFIKASI],
        },
      },
      select: {
        nim: true,
        pekerjaan_id: true,
      },
    });

    // Get pekerjaan info for penugasan
    const pekerjaanIds = [...new Set(activePenugasan.map(p => p.pekerjaan_id).filter(Boolean) as number[])];
    const relatedPekerjaan = await prisma.daftar_pekerjaan.findMany({
      where: { id: { in: pekerjaanIds } },
      select: { id: true, poin_jam: true },
    });
    const pekerjaanMap = new Map(relatedPekerjaan.map(p => [p.id, p.poin_jam || 0]));

    const penugasanByNim = new Map<string, number>();
    for (const penugasan of activePenugasan) {
      if (penugasan.nim && penugasan.pekerjaan_id) {
        const current = penugasanByNim.get(penugasan.nim) || 0;
        const poin = pekerjaanMap.get(penugasan.pekerjaan_id) || 0;
        penugasanByNim.set(penugasan.nim, current + poin);
      }
    }

    const mhsList: MhsWithJam[] = [];
    
    for (const kompen of kompenAwalList) {
      if (!kompen.nim || assignedNims.has(kompen.nim)) continue;
      
      const jamSudahDapat = penugasanByNim.get(kompen.nim) || 0;
      const jamSisa = (kompen.total_jam_wajib || 0) - jamSudahDapat;
      
      if (jamSisa > 0) {
        mhsList.push({
          nim: kompen.nim,
          nama: kompen.mahasiswa?.nama || '',
          totalJamWajib: kompen.total_jam_wajib || 0,
          jamSisa,
        });
      }
    }

    if (mhsList.length === 0) {
      return { 
        success: false, 
        error: 'Tidak ada mahasiswa dengan jam kompen > 0' 
      };
    }

    if (sortBy === 'nim') {
      mhsList.sort((a, b) => (a.nim || '').localeCompare(b.nim || ''));
    } else {
      // Urutkan: yang dapat pekerjaan paling sedikit dulu (prioritas)
      mhsList.sort((a, b) => a.jamSisa - b.jamSisa);
    }

    // Track how many slots each mahasiswa sudah dapat for this plotting session
    // Key: nim, Value: count of assignments
    const mhsAssignedCount = new Map<string, number>();
    let processedCount = 0;
    let assignmentCount = 0;
    const results: any[] = [];

    // DISTRIBUSI ROUND-ROBIN: Each mahasiswa max 1 slot per round
    // Round 1: A, B, C, D,...Z masing-masing 1 slot
    // Round 2: A, B, C, D,...Z masing-masing 1 slot (if still has quota)
    // etc...
    
    for (const pekerjaan of pekerjaanReady) {
      const slotTersedia = (pekerjaan.kuota || 0) - pekerjaan.penugasan.length;
      
      if (slotTersedia <= 0) continue;
      
      const assignments: any[] = [];
      
      // Round-robin: loop through all mhs repeatedly until quota filled
      // Start from different position each round to be fair
      let round = 0;
      let mhsIndex = 0;
      
      while (assignments.length < slotTersedia && mhsIndex < mhsList.length * 2) {
        // Calculate which mhs to check in this round
        const currentIndex = round > 0 ? mhsIndex % mhsList.length : mhsIndex;
        const mhs = mhsList[currentIndex];
        
        // Skip if sudah dapat pekerjaan ini (mhsAssignedCount > 0 means already got 1 slot)
        const sudahDapat = mhsAssignedCount.get(mhs.nim) || 0;
        if (sudahDapat >= round + 1) {
          mhsIndex++;
          continue;
        }
        
        // Check if masih ada jam kompen available
        if (mhs.jamSisa <= 0) {
          mhsIndex++;
          continue;
        }
        
        // Hitung jam yang можно berikan (bukan semua poin, tapi sesuai maxJamPerHari)
        const poinPekerjaan = pekerjaan.poin_jam || 0;
        const jamDiberi = Math.min(poinPekerjaan, mhs.jamSisa, maxJamPerHari);
        
        if (jamDiberi <= 0) {
          mhsIndex++;
          continue;
        }
        
        // Assign this mahasiswa!
        assignments.push({
          nim: mhs.nim,
          nama: mhs.nama,
          jam_diberi: jamDiberi,
        });
        
        // Update counters
        mhsAssignedCount.set(mhs.nim, sudahDapat + 1);
        mhs.jamSisa -= jamDiberi;
        
        // Move to next mhs for next slot
        mhsIndex++;
        
        // If we've gone through all mhs, start new round
        if (mhsIndex >= mhsList.length && assignments.length < slotTersedia) {
          round++;
          mhsIndex = 0;
        }
      }
      
      if (assignments.length > 0) {
        // Validate NIM exists in mahasiswa before insert
        for (const assignment of assignments) {
          const mhsExists = await prisma.mahasiswa.findUnique({
            where: { nim: assignment.nim },
            select: { nim: true },
          });
          
          if (!mhsExists) {
            console.error(`Invalid NIM: ${assignment.nim} - skipping`);
            continue;
          }
          
          await prisma.penugasan.create({
            data: {
              pekerjaan_id: pekerjaan.id,
              nim: assignment.nim,
              status_tugas_id: STATUS_TUGAS.MENUNGGU,
            },
          });
        }
        
        results.push({
          pekerjaan_id: pekerjaan.id,
          pekerjaan: pekerjaan.judul || '',
          assignments,
        });
        
        processedCount++;
      }
    }

    return {
      success: true,
      processedCount,
      assignmentCount: results.reduce((acc, r) => acc + r.assignments.length, 0),
      results,
    };
  } catch (error) {
    console.error('Error generating plotting:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}