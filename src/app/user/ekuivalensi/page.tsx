import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import EkuivalensiClient from './EkuivalensiClient'

export default async function EkuivalensiPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value

  // 1. Ambil data nama mahasiswa
  const mahasiswa = nim
    ? await prisma.mahasiswa.findUnique({
        where: { nim },
        select: { nama: true },
      })
    : null

  // 2. Ambil semester yang sedang aktif
  const activeSemester = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true },
  })

  // 3. Ambil registrasi kelas mahasiswa di semester aktif
  const registrasi = nim && activeSemester
    ? await prisma.registrasi_mahasiswa.findFirst({
        where: {
          nim,
          semester_id: activeSemester.id,
        },
        select: { kelas_id: true },
      })
    : null

  // 4. Cari ekuivalensi terakhir yang dibuat oleh mahasiswa ini (untuk fallback jika registrasi kosong)
  const ekuivalensiAwal = nim
    ? await prisma.ekuivalensi_kelas.findFirst({
        where: { penanggung_jawab_nim: nim },
        select: { kelas_id: true, semester_id: true },
        orderBy: { created_at: 'desc' },
      })
    : null

  const kelasId = registrasi?.kelas_id || ekuivalensiAwal?.kelas_id
  const semesterId = registrasi?.kelas_id ? activeSemester?.id : ekuivalensiAwal?.semester_id

  // 5. Fetch data ekuivalensi dengan select yang lebih spesifik (Optimasi Memori & Query)
  const ekuivalensi = kelasId && semesterId
    ? await prisma.ekuivalensi_kelas.findMany({
        where: {
          kelas_id: kelasId,
          semester_id: semesterId,
        },
        select: {
          id: true,
          penanggung_jawab_nim: true,
          jam_diakui: true,
          nota_url: true,
          nominal_total: true,
          catatan: true,
          verified_by_nip: true,
          mahasiswa: {
            select: { nama: true }
          },
          kelas: {
            select: { nama_kelas: true }
          },
          semester: {
            select: { nama: true }
          },
          status_ekuivalensi: {
            select: { nama: true }
          }
        },
        orderBy: { created_at: 'desc' },
      })
    : []

  const namaMahasiswa = mahasiswa?.nama || 'Mahasiswa'
  const namaKelas = ekuivalensi.length > 0 ? ekuivalensi[0].kelas?.nama_kelas || '-' : '-'

  return (
    <Sidebar role="mahasiswa" activePath="/user/ekuivalensi">
      <main className="flex-1 flex flex-col">
        <EkuivalensiClient
          namaMahasiswa={namaMahasiswa}
          ekuivalensi={ekuivalensi.map((item) => ({
            id: item.id,
            penanggung_jawab_nim: item.penanggung_jawab_nim || '-',
            nama_kelas: item.kelas?.nama_kelas || '-',
            nama_semester: item.semester?.nama || '-',
            mahasiswa: item.mahasiswa ? { nama: item.mahasiswa.nama || '-' } : undefined,
            jam_diakui: item.jam_diakui || 0,
            status: item.status_ekuivalensi?.nama || 'Menunggu',
            nota_url: item.nota_url,
            nominal_total: item.nominal_total ? Number(item.nominal_total) : null,
            catatan: item.catatan,
            verified_by_nip: item.verified_by_nip,
          }))}
          namaKelas={namaKelas}
        />
      </main>
    </Sidebar>
  )
}