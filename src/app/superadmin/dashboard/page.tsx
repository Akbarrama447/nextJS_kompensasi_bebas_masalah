import Sidebar from '@/components/Sidebar'
import prisma from '@/lib/prisma'
import SuperadminDashboardClient from './SuperadminDashboardClient'

export const dynamic = 'force-dynamic'

export default async function SuperadminDashboardPage() {
  // 1. Fetch active semester
  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true }
  })
  const activeSemesterId = activeSemester?.id || 1

  // 2. Fetch basic metrics counts
  const totalStudents = await prisma.mahasiswa.count()
  const totalStaff = await prisma.staf.count()
  const totalJurusan = await prisma.jurusan.count()
  const totalProdi = await prisma.prodi.count()

  // 3. Calculate cumulative remaining active kompen hours for the active semester
  const totalJamWajibObj = await prisma.kompen_awal.aggregate({
    _sum: {
      total_jam_wajib: true
    },
    where: {
      semester_id: activeSemesterId
    }
  })
  const totalJamWajib = totalJamWajibObj._sum.total_jam_wajib || 0

  const totalJamDikurangiObj = await prisma.log_potong_jam.aggregate({
    _sum: {
      jam_dikurangi: true
    },
    where: {
      semester_id: activeSemesterId
    }
  })
  const totalJamDikurangi = totalJamDikurangiObj._sum.jam_dikurangi || 0
  const totalActiveKompenHours = Math.max(0, Math.round(totalJamWajib - totalJamDikurangi))

  // 4. Fetch all semesters for selector list
  const semesters = await prisma.semester.findMany({
    orderBy: { tahun: 'desc' }
  })

  // 5. Fetch kompen_awal grouped by prodi via registrasi_mahasiswa (fallback to any semester)
  const kompenList = await prisma.kompen_awal.findMany({
    where: { semester_id: activeSemesterId },
    include: {
      mahasiswa: {
        include: {
          registrasi_mahasiswa: {
            include: {
              kelas: { include: { prodi: true } }
            },
            orderBy: { semester_id: 'desc' }
          }
        }
      }
    }
  })

  // 6. Get all log_potong_jam for active semester (for jam calculation)
  const potongList = await prisma.log_potong_jam.findMany({
    where: { semester_id: activeSemesterId }
  })
  const jamPotongMap = new Map<string, number>()
  for (const p of potongList) {
    if (p.nim) {
      jamPotongMap.set(p.nim, (jamPotongMap.get(p.nim) || 0) + (p.jam_dikurangi || 0))
    }
  }

  // Group by prodi (or "Tanpa Prodi" if no registration)
  const prodiMap = new Map<number, { nama: string; mahasiswas: Set<string>; totalJam: number }>()
  for (const k of kompenList) {
    if (!k.nim) continue
    const reg = k.mahasiswa?.registrasi_mahasiswa?.[0]
    const prodiId = reg?.kelas?.prodi?.id
    const prodiNama = reg?.kelas?.prodi?.nama_prodi

    if (!prodiId) {
      if (!prodiMap.has(-1)) prodiMap.set(-1, { nama: 'Tanpa Prodi', mahasiswas: new Set(), totalJam: 0 })
      const entry = prodiMap.get(-1)!
      entry.mahasiswas.add(k.nim)
      entry.totalJam += (k.total_jam_wajib || 0) - (jamPotongMap.get(k.nim) || 0)
      continue
    }

    if (!prodiMap.has(prodiId)) prodiMap.set(prodiId, { nama: prodiNama || 'Unknown', mahasiswas: new Set(), totalJam: 0 })
    const entry = prodiMap.get(prodiId)!
    entry.mahasiswas.add(k.nim)
    entry.totalJam += (k.total_jam_wajib || 0) - (jamPotongMap.get(k.nim) || 0)
  }

  // Build jurusan stats based on all prodi
  const allProdi = await prisma.prodi.findMany({ include: { jurisdiction: true } })
  const jurusanStats = allProdi
    .filter(p => p.jurisdiction)
    .reduce((acc, p) => {
      let jur = acc.find(j => j.id === p.jurisdiction!.id)
      if (!jur) {
        jur = { id: p.jurisdiction!.id, nama: p.jurisdiction!.nama_jurusan, totalProdi: 0, totalMahasiswa: 0, totalJamKompen: 0, prodis: [] }
        acc.push(jur)
      }
      jur.totalProdi++
      const pd = prodiMap.get(p.id)
      const mhsCount = pd?.mahasiswas.size || 0
      const jamCount = pd ? Math.max(0, Math.round(pd.totalJam)) : 0
      jur.totalMahasiswa += mhsCount
      jur.totalJamKompen += jamCount
      jur.prodis.push({ id: p.id, nama: p.nama_prodi, totalKelas: 0, totalMahasiswa: mhsCount, totalJamKompen: jamCount })
      return acc
    }, [] as Array<{ id: number; nama: string | null; totalProdi: number; totalMahasiswa: number; totalJamKompen: number; prodis: Array<{ id: number; nama: string | null; totalKelas: number; totalMahasiswa: number; totalJamKompen: number }> }>)

  // Also include "Tanpa Prodi" if any
  const unk = prodiMap.get(-1)
  if (unk && unk.mahasiswas.size > 0) {
    jurusanStats.push({
      id: 999,
      nama: 'Tanpa Jurusan',
      totalProdi: 1,
      totalMahasiswa: unk.mahasiswas.size,
      totalJamKompen: Math.max(0, Math.round(unk.totalJam)),
      prodis: [{ id: 999, nama: 'Tanpa Prodi', totalKelas: 0, totalMahasiswa: unk.mahasiswas.size, totalJamKompen: Math.max(0, Math.round(unk.totalJam)) }]
    })
  }

  return (
    <Sidebar role="superadmin" activePath="/superadmin/dashboard">
      <SuperadminDashboardClient
        stats={{
          totalStudents,
          totalStaff,
          totalJurusan,
          totalProdi,
          totalActiveKompenHours
        }}
        semesters={semesters.map(s => ({
          id: s.id,
          nama: s.nama,
          tahun: s.tahun,
          periode: s.periode,
          is_aktif: s.is_aktif
        }))}
        jurusanStats={jurusanStats}
      />
    </Sidebar>
  )
}
