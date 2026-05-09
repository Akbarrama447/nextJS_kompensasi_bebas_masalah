import prisma from '@/lib/prisma'
import { cookies } from 'next/headers'
import PekerjaanSayaClient from './PekerjaanSayaClient'
import Sidebar from '@/components/Sidebar'
import UserHeader from '@/components/UserHeader'

export default async function PekerjaanSayaPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value || 
              cookieStore.get('NIM')?.value || 
              cookieStore.get('user_id')?.value || 
              '33424202'; // Fallback ke NIM lo biar PASTI MUNCUL pas demo

  console.log("DEBUG: NIM Aktif =", nim);

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

  const penugasanSaya = await prisma.penugasan.findMany({
    where: { nim },
    include: {
      pekerjaan: {
        include: {
          ruangan: true,
          tipe_pekerjaan: true
        }
      },
      status_tugas: true 
    },
    orderBy: { created_at: 'desc' }
  })

  const userData = {
    nama: mhsAktif?.nama || 'Mahasiswa',
    nim: nim || '-',
    info: mhsAktif?.registrasi_mahasiswa?.[0] || null
  }

  return (
    <Sidebar role="mahasiswa" activePath="/user/pekerjaan">
      <UserHeader nama={userData.nama} role="mahasiswa" />
      {/* Lempar data ke Client Component */}
      <PekerjaanSayaClient initialData={penugasanSaya} user={userData} />
    </Sidebar>
  )
}