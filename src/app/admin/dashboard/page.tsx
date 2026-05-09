import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import DashboardAdminClient from './DashboardAdminClient'

export default async function DashboardAdmin() {
  const cookieStore = await cookies()
  const nip = cookieStore.get('nip')?.value || ''

  const staf = await prisma.staf.findUnique({
    where: { nip },
    include: { user: true }
  })

  const namaAdmin = staf?.nama || 'Admin'

  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true },
  })

  const pekerjaanAktif = activeSemester
    ? await prisma.daftar_pekerjaan.count({
        where: {
          semester_id: activeSemester.id,
          is_aktif: true,
        },
      })
    : 0

  const refStatusTugas = await prisma.ref_status_tugas.findMany({
    orderBy: { id: 'asc' },
  })

  const statusCounts = activeSemester
    ? await Promise.all(
        refStatusTugas.map(async (status) => {
          const count = await prisma.penugasan.count({
            where: {
              pekerjaan: {
                semester_id: activeSemester.id,
              },
              status_tugas_id: status.id,
            },
          })
          return { id: status.id, nama: status.nama, count }
        })
      )
    : refStatusTugas.map(status => ({ id: status.id, nama: status.nama, count: 0 }))

  return (
    <Sidebar role="admin" activePath="/admin/dashboard">
      <main className="flex-1 flex flex-col">
        <DashboardAdminClient
          namaAdmin={namaAdmin}
          pekerjaanAktif={pekerjaanAktif}
          statusCounts={statusCounts}
        />
      </main>
    </Sidebar>
  )
}