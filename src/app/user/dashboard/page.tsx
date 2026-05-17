import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import DashboardClient from './DashboardClient'

export default async function DashboardMahasiswa() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value || ''

  const mahasiswa = await prisma.mahasiswa.findUnique({
    where: { nim },
    include: { user: true }
  })

  const namaMahasiswa = mahasiswa?.nama || 'Mahasiswa'

  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true, nama: true, tahun: true },
  })

  const kompenAwal = activeSemester
    ? await prisma.kompen_awal.findFirst({
        where: {
          nim,
          semester_id: activeSemester.id,
        },
        select: { total_jam_wajib: true },
      })
    : null

  const logPotongJam = activeSemester
    ? await prisma.log_potong_jam.aggregate({
        where: {
          nim,
          semester_id: activeSemester.id,
        },
        _sum: { jam_dikurangi: true },
      })
    : null

  const totalJamWajib = kompenAwal?.total_jam_wajib ?? 0
  const totalJamSelesai = logPotongJam?._sum.jam_dikurangi ?? 0
  const sisaJam = totalJamWajib - totalJamSelesai

  const semesterLabel = activeSemester ? `${activeSemester.nama} - ${activeSemester.tahun}` : ''

  return (
    <Sidebar role="mahasiswa" activePath="/user/dashboard">
      <main className="flex-1 flex flex-col">
        <DashboardClient
          namaMahasiswa={namaMahasiswa}
          sisaJam={sisaJam}
          totalJamSelesai={totalJamSelesai}
          totalJamWajib={totalJamWajib}
          semesterLabel={semesterLabel}
        />
      </main>
    </Sidebar>
  )
}
