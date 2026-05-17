import Sidebar from "@/components/Sidebar";
import ClientPage from "@/app/admin/list_pekerjaan/ClientPage";
import prisma from '@/lib/prisma'

export default async function Page() {
  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { nama: true, tahun: true },
  })
  const semesterLabel = activeSemester ? `${activeSemester.nama} - ${activeSemester.tahun}` : ''

  return (
    <Sidebar role="admin" activePath="/admin/list_pekerjaan">
      <ClientPage semesterLabel={semesterLabel} />
    </Sidebar>
  );
}