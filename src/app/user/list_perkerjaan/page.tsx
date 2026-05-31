import prisma from '@/lib/prisma'
import { cookies } from 'next/headers'
import PekerjaanSayaClient from './PekerjaanSayaClient'
import Sidebar from '@/components/Sidebar'
import UserHeader from '@/components/UserHeader'

export default async function PekerjaanSayaPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value || ''

  // Tanpa sesi NIM yang valid, jangan tampilkan data siapa pun
  if (!nim) {
    return (
      <Sidebar role="mahasiswa" activePath="/user/list_perkerjaan">
        <UserHeader nama="Mahasiswa" role="mahasiswa" />
        <div className="flex-1 flex items-center justify-center p-10">
          <p className="text-sm text-slate-500">Sesi tidak ditemukan. Silakan login ulang.</p>
        </div>
      </Sidebar>
    )
  }

  const mhsAktif = await prisma.mahasiswa.findUnique({
    where: { nim },
    include: {
      registrasi_mahasiswa: {
        where: { status: "Aktif" },
        include: {
          kelas: {
            include: { prodi: true }
          }
        }
      }
    }
  })

  const allTipePekerjaan = await prisma.ref_tipe_pekerjaan.findMany({
    orderBy: { id: 'asc' }
  })

  const penugasanSaya = await prisma.penugasan.findMany({
    where: { nim },
    include: {
      pekerjaan: {
        include: {
          ruangan: true,
          tipe_pekerjaan: true,
          semester: true
        }
      },
      status_tugas: true
    },
    orderBy: { created_at: 'desc' }
  })

  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { nama: true, tahun: true },
  })
  const semesterLabel = activeSemester ? `${activeSemester.nama} - ${activeSemester.tahun}` : ''

  const userData = {
    nama: mhsAktif?.nama || 'Mahasiswa',
    nim: nim || '-',
    info: mhsAktif?.registrasi_mahasiswa?.[0] || null
  }

  return (
    <Sidebar role="mahasiswa" activePath="/user/list_perkerjaan">
      <UserHeader nama={userData.nama} role="mahasiswa" semesterLabel={semesterLabel} />
      {/* Lempar data ke Client Component */}
      <PekerjaanSayaClient initialData={penugasanSaya} user={userData} allTipePekerjaan={allTipePekerjaan} />
    </Sidebar>
  )
}