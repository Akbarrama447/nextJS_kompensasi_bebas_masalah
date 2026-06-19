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

  // 5. Fetch all Jurusan along with Prodi, Kelas, and Student registrations to build aggregate statistics
  const jurusans = await prisma.jurusan.findMany({
    include: {
      prodi: {
        include: {
          kelas: {
            include: {
              registrasi_mahasiswa: {
                where: {
                  semester_id: activeSemesterId
                },
                include: {
                  mahasiswa: {
                    include: {
                      kompen_awal: {
                        where: { semester_id: activeSemesterId }
                      },
                      log_potong_jam: {
                        where: { semester_id: activeSemesterId }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  })

  // 6. Map and aggregate Jurusan & Prodi statistics
  const jurusanStats = jurusans.map(j => {
    const prodis = j.prodi.map(p => {
      const kelases = p.kelas
      const allRegistrasi = kelases.flatMap(k => k.registrasi_mahasiswa)
      
      let totalJamKompen = 0
      allRegistrasi.forEach(r => {
        const mhs = r.mahasiswa
        if (mhs) {
          const jamWajib = mhs.kompen_awal.reduce((acc, k) => acc + (k.total_jam_wajib || 0), 0)
          const jamPotong = mhs.log_potong_jam.reduce((acc, l) => acc + (l.jam_dikurangi || 0), 0)
          totalJamKompen += Math.max(0, jamWajib - jamPotong)
        }
      })

      return {
        id: p.id,
        nama: p.nama_prodi,
        totalKelas: kelases.length,
        totalMahasiswa: allRegistrasi.length,
        totalJamKompen: Math.round(totalJamKompen)
      }
    })

    const totalProdiCount = prodis.length
    const totalMahasiswaCount = prodis.reduce((acc, p) => acc + p.totalMahasiswa, 0)
    const totalJamKompenSum = prodis.reduce((acc, p) => acc + p.totalJamKompen, 0)

    return {
      id: j.id,
      nama: j.nama_jurusan,
      totalProdi: totalProdiCount,
      totalMahasiswa: totalMahasiswaCount,
      totalJamKompen: totalJamKompenSum,
      prodis
    }
  })

  return (
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
  )
}
