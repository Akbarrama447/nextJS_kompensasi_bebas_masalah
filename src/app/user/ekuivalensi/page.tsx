import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import EkuivalensiClient from './EkuivalensiClient'

export default async function EkuivalensiPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value

  const ekuivalensi = nim
    ? await prisma.ekuivalensi_kelas.findMany({
        where: { penanggung_jawab_nim: nim },
        include: { mahasiswa: true },
      })
    : []

  const namaMahasiswa = ekuivalensi[0]?.mahasiswa?.nama || 'Mahasiswa'

  return (
    <Sidebar role="mahasiswa" activePath="/user/ekuivalensi">
      <main className="flex-1 flex flex-col">
        <EkuivalensiClient
          namaMahasiswa={namaMahasiswa}
          ekuivalensi={ekuivalensi.map((item) => ({
            id: item.id,
            penanggung_jawab_nim: item.penanggung_jawab_nim,
            mahasiswa: item.mahasiswa ? { nama: item.mahasiswa.nama } : undefined,
            jam_diakui: item.jam_diakui,
          }))}
        />
      </main>
    </Sidebar>
  )
}
