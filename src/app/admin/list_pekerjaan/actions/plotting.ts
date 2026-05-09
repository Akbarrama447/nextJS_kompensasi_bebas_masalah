'use server';

import prisma from '@/lib/prisma';
import type { PlottingConfig, PlottingResult, PlottingPekerjaanResult, PlottingAssignment } from '../types';

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
    const sortBy = config?.sortBy || 'jam_kompen';
    
    let processedCount = 0;

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
      if (!kompen.nim) continue;
      
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
    const results: PlottingPekerjaanResult[] = [];

    // ============================================================
    // ALGORITMA PERBAIKAN (Berdasarkan catatan.md line 173-220)
    // ============================================================
    // 1. Pisahkan: Total jam workload vs Kuota org
    // 2. Pilih N org max sesuai KUOTA
    // 3. Bagi total jam ke N org tsb
    // 4. Sisa jam -> tambahkan ke org dengan jam SISA terbesar (bukan org baru!)
    // 5. Tolerance: +2 jam boleh
    // ============================================================

    const TOLERANCE_PLUS = 2; // max 2 jam boleh lebih dari wajib

    for (const pekerjaan of pekerjaanReady) {
      const slotTersedia = (pekerjaan.kuota || 0) - pekerjaan.penugasan.length;
      const totalJamPekerjaan = pekerjaan.poin_jam || 0;
      
      if (slotTersedia <= 0 || totalJamPekerjaan <= 0) continue;
      
      const assignments: PlottingAssignment[] = [];
      
      // Step 1: Pilih mahasiswa yang eligible (jamSisa >= total poin pekerjaan)
      // Strategi "Closest Fit": Hanya ambil yang hutangnya cukup untuk meng-cover TOTAL jam pekerjaan
      // untuk meminimalkan surplus jam dan memastikan efisiensi.
      const eligibleMhs = mhsList.filter(m => {
        const isEligibleJam = m.jamSisa >= totalJamPekerjaan;
        const isAlreadyInThisJob = pekerjaan.penugasan.some(p => p.nim === m.nim);
        return isEligibleJam && !isAlreadyInThisJob;
      });
      
      if (eligibleMhs.length === 0) continue;
      
      // Step 2: Urutkan - prioritas jam SISA TERKECIL dulu (agar yang sedikit cepat lunas)
      eligibleMhs.sort((a, b) => a.jamSisa - b.jamSisa);
      
      // Step 3: Pilih max N orang sesuai KUOTA
      const jumlahDipilih = Math.min(slotTersedia, eligibleMhs.length);
      const terpilih = eligibleMhs.slice(0, jumlahDipilih);
      
      // Step 4: Distribusikan jam ke N org secara merata
      // Rumus: bagi total jam ke N org, sisanya ke org pertama
      const jamPerOrg = Math.floor(totalJamPekerjaan / jumlahDipilih);
      let sisaJam = totalJamPekerjaan;
      
      for (let i = 0; i < terpilih.length; i++) {
        const mhs = terpilih[i];
        
        // Hitung jam yang bisa diberikan:
        // - pakai jamPerOrg dulu
        // - sisa jam (>0) tambahkan ke org dg jamSisa terbesar
        let jamDiberi = jamPerOrg;
        
        if (i === 0 && sisaJam % jumlahDipilih > 0) {
          // Org pertama dapat sisa bagi
          jamDiberi += (sisaJam % jumlahDipilih);
        }
        
        // Cek tolerance: boleh lebi max +2 dari jamSisa
        const maxBisa = mhs.jamSisa + TOLERANCE_PLUS;
        jamDiberi = Math.min(jamDiberi, maxBisa);
        
        // Validasi akhir
        if (jamDiberi <= 0) continue;
        
        assignments.push({
          nim: mhs.nim,
          nama: mhs.nama,
          jam_diberi: jamDiberi,
        });
        
        // Update counters
        const sudahDapat = mhsAssignedCount.get(mhs.nim) || 0;
        mhsAssignedCount.set(mhs.nim, sudahDapat + 1);
        
        // Kurangi jamSisa lokal (bukan update DB)
        mhs.jamSisa -= jamDiberi;
        sisaJam -= jamDiberi;
      }
      
      // Step 5: Insert ke DB jika ada yang terpilih
      if (assignments.length > 0) {
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

    const totalAssignments = results.reduce((acc, r) => acc + r.assignments.length, 0);
    
    return {
      success: true,
      processedCount,
      assignmentCount: totalAssignments,
      results,
    };
  } catch (error) {
    console.error('Error generating plotting:', error);
    const message = error instanceof Error ? error.message : 'Unknown error';
    return { success: false, error: message };
  }
}