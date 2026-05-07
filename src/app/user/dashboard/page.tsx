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
  
  // Query sisa jam dari view v_sisa_kompen
  // TODO: Hitung data statistik dari database dengan semester aktif
  const sisaJam = 0
  const totalJamSelesai = 0
  const totalJamWajib = 0

  return (
    <Sidebar role="mahasiswa" activePath="/user/dashboard">
      <main className="flex-1 flex flex-col">
        <DashboardClient
          namaMahasiswa={namaMahasiswa}
          sisaJam={sisaJam}
          totalJamSelesai={totalJamSelesai}
          totalJamWajib={totalJamWajib}
        />
      </main>
    </Sidebar>
  )
}
