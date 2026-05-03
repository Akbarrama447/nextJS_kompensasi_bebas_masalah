import Sidebar from '@/components/Sidebar'
import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'

export default async function PekerjaanSayaPage() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value || ''

  const mhsAktif = await prisma.v_mahasiswa_aktif.findUnique({
    where: { nim }
  })

  const penugasanSaya = await prisma.penugasan.findMany({
    where: { nim: nim },
    include: {
      pekerjaan: {
        include: {
          ruangan: true,
          tipe_pekerjaan: true,
          staf: true
        }
      },
      status_tugas: true 
    },
    orderBy: { created_at: 'desc' }
  })

  const namaMahasiswa = mhsAktif?.nama || 'Mahasiswa'

  return (
    <Sidebar role="mahasiswa" activePath="/user/pekerjaan">
      <main className="flex-1 flex flex-col min-h-screen bg-slate-50">
        
        {/* Navbar - Responsive Flex */}
        <header className="bg-white h-16 px-4 md:px-10 flex items-center justify-between border-b border-slate-200 sticky top-0 z-10">
          <div className="flex flex-col min-w-0">
             <span className="text-sm font-bold text-slate-700 truncate">{namaMahasiswa}</span>
             <span className="text-[10px] text-slate-400 font-medium truncate">
                {mhsAktif?.nama_kelas} - {mhsAktif?.nama_prodi}
             </span>
          </div>

          <div className="flex items-center gap-2 md:gap-3 ml-2">
            <div className="hidden xs:flex flex-col text-right">
              <span className="text-[10px] md:text-[11px] text-[#2e5299] font-bold uppercase tracking-wider">Aktif</span>
            </div>
            <div className="w-8 h-8 md:w-9 md:h-9 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-[#2e5299] font-bold text-xs md:text-sm">
              {namaMahasiswa.charAt(0)}
            </div>
          </div>
        </header>

        {/* Content Section - Responsive Padding */}
        <div className="p-4 md:p-10 max-w-6xl w-full mx-auto">
          <div className="mb-6 md:mb-8">
            <h2 className="text-xl md:text-2xl font-bold text-slate-800 mb-1">Tugas Kompensasi</h2>
            <p className="text-xs md:text-sm text-[#2e5299] font-medium opacity-80">
               Daftar pekerjaan yang telah ditugaskan kepada anda
            </p>
          </div>

          {/* Grid Penugasan - 1 Kolom di HP, 2 di Tablet, 3 di Desktop */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
            {penugasanSaya.map((tugas) => (
              <div key={tugas.id} className="bg-white rounded-2xl shadow-sm border border-slate-100 flex flex-col hover:border-[#2e5299]/30 transition-all group relative overflow-hidden">
                
                {/* Status Badge */}
                <div className="absolute top-0 right-0">
                   <div className={`px-3 md:px-4 py-1 rounded-bl-xl text-[9px] md:text-[10px] font-bold uppercase tracking-tight text-white ${
                     tugas.status_tugas_id === 4 ? 'bg-green-500' : 
                     tugas.status_tugas_id === 5 ? 'bg-red-500' : 'bg-[#2e5299]'
                   }`}>
                     {tugas.status_tugas?.nama}
                   </div>
                </div>

                <div className="p-5 md:p-6 flex-1">
                  <div className="mb-3 md:mb-4">
                    <span className="text-[9px] md:text-[10px] uppercase tracking-wider font-bold px-2 py-0.5 rounded-md bg-slate-50 text-slate-400 border border-slate-100">
                      {tugas.pekerjaan?.ref_tipe_pekerjaan?.nama}
                    </span>
                  </div>

                  <h3 className="text-base md:text-lg font-bold text-slate-800 mb-2 group-hover:text-[#2e5299] transition-colors pr-16 line-clamp-2">
                    {tugas.pekerjaan?.judul}
                  </h3>
                  
                  <div className="flex items-center gap-2 mb-4">
                     <div className="w-5 h-5 md:w-6 md:h-6 rounded-full bg-slate-100 flex items-center justify-center text-[9px] md:text-[10px] font-bold text-slate-500">
                        {tugas.pekerjaan?.staf?.nama.charAt(0)}
                     </div>
                     <span className="text-[10px] md:text-[11px] text-slate-500 font-medium truncate">
                        Pemberi: {tugas.pekerjaan?.staf?.nama}
                     </span>
                  </div>

                  {/* Info Row menggunakan Flex-Col di HP jika perlu, tapi Row di sini masih cukup */}
                  <div className="space-y-2 border-t border-slate-50 pt-4">
                    <div className="flex justify-between items-center text-[10px] md:text-[11px]">
                       <span className="text-slate-400">Lokasi:</span>
                       <span className="text-slate-700 font-bold truncate ml-2">
                          {tugas.pekerjaan?.ruangan?.nama_ruangan || '-'}
                       </span>
                    </div>
                    <div className="flex justify-between items-center text-[10px] md:text-[11px]">
                       <span className="text-slate-400">Poin Jam:</span>
                       <span className="text-[#2e5299] font-black">{tugas.pekerjaan?.poin_jam} JAM</span>
                    </div>
                  </div>
                </div>

                <div className="px-5 pb-5 md:px-6 md:pb-6 mt-auto">
                  <button className="w-full py-2 md:py-2.5 rounded-xl text-[11px] md:text-xs font-bold bg-slate-50 text-slate-600 border border-slate-200 hover:bg-[#2e5299] hover:text-white hover:border-[#2e5299] transition-all active:scale-95">
                    Lihat Detail Tugas
                  </button>
                </div>
              </div>
            ))}

            {penugasanSaya.length === 0 && (
              <div className="col-span-full py-16 md:py-20 text-center bg-white rounded-2xl border border-dashed border-slate-200 px-6">
                <div className="w-12 h-12 md:w-16 md:h-16 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-4">
                   <svg className="w-6 h-6 md:w-8 md:h-8 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                   </svg>
                </div>
                <p className="text-slate-500 font-bold text-sm md:text-base">Belum Ada Tugas</p>
                <p className="text-[10px] md:text-[11px] text-slate-400 mt-1">Anda belum menerima penugasan kompensasi dari staf.</p>
              </div>
            )}
          </div>
        </div>
      </main>
    </Sidebar>
  )
}