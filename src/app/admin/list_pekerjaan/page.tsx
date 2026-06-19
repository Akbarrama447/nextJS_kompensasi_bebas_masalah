import Sidebar from "@/components/Sidebar";
import ClientPage from "@/app/admin/list_pekerjaan/ClientPage";
import prisma from '@/lib/prisma'

import { cookies } from 'next/headers'

export default async function Page() {
  const cookieStore = await cookies()
  const staffNip = cookieStore.get('nip')?.value || ""

  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true, nama: true, tahun: true },
  })
  
  const semesterId = activeSemester?.id || 1
  const semesterLabel = activeSemester ? `${activeSemester.nama} - ${activeSemester.tahun}` : ''

  return (
    <Sidebar role="admin" activePath="/admin/list_pekerjaan">
      <ClientPage semesterLabel={semesterLabel} staffNip={staffNip} semesterId={semesterId} />
    </Sidebar>
  );
}