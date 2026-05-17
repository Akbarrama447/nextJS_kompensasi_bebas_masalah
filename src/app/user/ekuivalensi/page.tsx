import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import EkuivalensiClient from './EkuivalensiClient'

export default async function EkuivalensiPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value

  const mahasiswa = nim
    ? await prisma.mahasiswa.findUnique({
        where: { nim },
        select: { nama: true },
      })
    : null

  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true, nama: true, tahun: true },
  })

  let kelasId: number | null = null
  let namaKelas = '-'
  let students: { nama: string; nim: string; jam: number }[] = []
  let ekuivalensi: any = null

  if (nim && activeSemester) {
    const registrasi = await prisma.registrasi_mahasiswa.findFirst({
      where: { nim, semester_id: activeSemester.id },
      select: { kelas_id: true },
    })

    if (registrasi?.kelas_id) {
      kelasId = registrasi.kelas_id

      const kelasData = await prisma.kelas.findUnique({
        where: { id: kelasId },
        select: { nama_kelas: true },
      })
      namaKelas = kelasData?.nama_kelas || '-'

      const allRegs = await prisma.registrasi_mahasiswa.findMany({
        where: {
          kelas_id: kelasId,
          semester_id: activeSemester.id,
          status: 'Aktif',
        },
        include: {
          mahasiswa: {
            include: {
              kompen_awal: {
                where: { semester_id: activeSemester.id },
                take: 1,
              },
            },
          },
        },
      })

      const nims = allRegs.map((r) => r.nim).filter(Boolean) as string[]

      const logSum = await prisma.log_potong_jam.groupBy({
        by: ['nim'],
        where: {
          nim: { in: nims },
          semester_id: activeSemester.id,
        },
        _sum: { jam_dikurangi: true },
      })

      const jamSelesaiMap = new Map<string, number>()
      for (const log of logSum) {
        if (log.nim) jamSelesaiMap.set(log.nim, log._sum.jam_dikurangi || 0)
      }

      students = allRegs
        .map((r) => {
          const studentNim = r.nim || ''
          const totalJam = r.mahasiswa?.kompen_awal[0]?.total_jam_wajib || 0
          const jamSelesai = jamSelesaiMap.get(studentNim) || 0
          const sisaJam = Math.max(0, totalJam - jamSelesai)
          return {
            nama: r.mahasiswa?.nama || '',
            nim: studentNim,
            jam: sisaJam,
          }
        })
        .filter((m) => m.jam > 0)

      const ekuivalensiData = await prisma.ekuivalensi_kelas.findFirst({
        where: {
          kelas_id: kelasId,
          semester_id: activeSemester.id,
        },
        include: {
          status_ekuivalensi: { select: { nama: true } },
          kelas: { select: { nama_kelas: true } },
        },
        orderBy: { created_at: 'desc' },
      })

      if (ekuivalensiData) {
        ekuivalensi = {
          id: ekuivalensiData.id,
          status: ekuivalensiData.status_ekuivalensi?.nama || 'Menunggu',
          jam: ekuivalensiData.jam_diakui || 0,
          nominal: Number(ekuivalensiData.nominal_total || 0),
          notaUrl: ekuivalensiData.nota_url || '',
          catatan: ekuivalensiData.catatan || '',
          penanggung_jawab_nim: ekuivalensiData.penanggung_jawab_nim || '',
        }
      }
    }
  }

  const namaMahasiswa = mahasiswa?.nama || 'Mahasiswa'
  const semesterLabel = activeSemester ? `${activeSemester.nama} - ${activeSemester.tahun}` : ''

  return (
    <Sidebar role="mahasiswa" activePath="/user/ekuivalensi">
      <main className="flex-1 flex flex-col">
        <EkuivalensiClient
          namaMahasiswa={namaMahasiswa}
          nim={nim || ''}
          namaKelas={namaKelas}
          students={students}
          ekuivalensi={ekuivalensi}
          semesterLabel={semesterLabel}
        />
      </main>
    </Sidebar>
  )
}
