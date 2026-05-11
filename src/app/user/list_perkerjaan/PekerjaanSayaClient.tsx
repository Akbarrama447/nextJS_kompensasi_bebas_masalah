'use client'

import { useState, useRef, useCallback, useMemo, useEffect } from 'react'
import Webcam from 'react-webcam'
import { 
  Camera, MapPin, X, Search, 
  RefreshCcw, MapPinned, ChevronLeft, ChevronRight, 
  ChevronDown, Filter, Banknote, FileText 
} from 'lucide-react'
import { updateProgresTugas } from './action'

interface Ruangan {
  nama_ruangan: string | null
}

interface TipePekerjaan {
  nama: string | null
}

interface Semester {
  nama: string | null
}

interface Pekerjaan {
  judul: string | null
  poin_jam: number | null
  ruangan: Ruangan | null
  tipe_pekerjaan: TipePekerjaan | null
  semester: Semester | null
  tipe_pekerjaan_id: number | null
}

interface StatusTugas {
  nama: string | null
}

interface TipePekerjaanItem {
  id: number
  nama: string | null
}

interface Penugasan {
  id: number
  status_tugas_id: number | null
  pekerjaan: Pekerjaan | null
  status_tugas: StatusTugas | null
}

interface UserData {
  nama: string
  nim: string
  info: unknown
}

interface Props {
  initialData: Penugasan[]
  user: UserData
  allTipePekerjaan: TipePekerjaanItem[]
}

export default function PekerjaanSayaClient({ initialData, user, allTipePekerjaan }: Props) {
  const webcamRef = useRef<Webcam>(null)
  
  const [dataTugas, setDataTugas] = useState<Penugasan[]>(initialData || [])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedTugas, setSelectedTugas] = useState<Penugasan | null>(null)
  const [imgSrc, setImgSrc] = useState<string | null>(null)
  const [location, setLocation] = useState<{ lat: number; lng: number } | null>(null)
  const [address, setAddress] = useState<string>("")

  const [searchTerm, setSearchTerm] = useState("")
  const [filterTipe, setFilterTipe] = useState("Semua")
  const [currentPage, setCurrentPage] = useState(1)
  const [rowsPerPage, setRowsPerPage] = useState(10)

  const listTipe = useMemo(() => {
    const types = allTipePekerjaan.map((t) => t.nama).filter((n): n is string => n !== null)
    return ["Semua", ...types]
  }, [allTipePekerjaan])

  const filteredData = useMemo(() => {
    return dataTugas.filter((t) => {
      const matchSearch = (t.pekerjaan?.judul?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          t.pekerjaan?.ruangan?.nama_ruangan?.toLowerCase().includes(searchTerm.toLowerCase()));
      const matchTipe = filterTipe === "Semua" || t.pekerjaan?.tipe_pekerjaan?.nama === filterTipe;
      return matchSearch && matchTipe;
    })
  }, [searchTerm, filterTipe, dataTugas])

  const totalPages = Math.ceil(filteredData.length / rowsPerPage)
  const startIndex = (currentPage - 1) * rowsPerPage
  const currentRows = filteredData.slice(startIndex, startIndex + rowsPerPage)

  useEffect(() => {
    setCurrentPage(1)
  }, [searchTerm, filterTipe, rowsPerPage])

  const getLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        async (pos) => {
          const lat = pos.coords.latitude
          const lng = pos.coords.longitude
          setLocation({ lat, lng })
          try {
            const controller = new AbortController()
            const timeoutId = setTimeout(() => controller.abort(), 5000)
            const response = await fetch(
              `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`,
              { signal: controller.signal }
            )
            clearTimeout(timeoutId)
            if (!response.ok) throw new Error("Gagal ambil lokasi")
            const data = await response.json()
            const loc = data.address?.village || data.address?.suburb || data.address?.city || data.address?.town || "Lokasi Terdeteksi"
            setAddress(loc)
          } catch {
            setAddress(`${lat.toFixed(4)}, ${lng.toFixed(4)}`)
          }
        },
        () => setAddress("Akses lokasi ditolak")
      )
    } else {
      setAddress("Geolocation tidak didukung")
    }
  }

  const handleAction = (tugas: Penugasan) => {
    setSelectedTugas(tugas)
    setImgSrc(null)
    setAddress("Mencari lokasi...")
    getLocation()
    setIsModalOpen(true)
  }

  const capture = useCallback(() => {
    const imageSrc = webcamRef.current?.getScreenshot()
    if (imageSrc) { setImgSrc(imageSrc); getLocation(); }
  }, [webcamRef])

  const updateStatus = async (id: number) => {
    if (!selectedTugas) return
    const formData = new FormData()
    formData.append('id', id.toString())
    formData.append('status_tugas_id', String(selectedTugas.status_tugas_id ?? 1))
    if (imgSrc) formData.append('image', imgSrc)

    const result = await updateProgresTugas(formData)
    if (result.success) {
      const updated = dataTugas.map((t) => t.id === id ? { ...t, status_tugas_id: result.nextStatus ?? t.status_tugas_id } : t)
      setDataTugas(updated)
      setIsModalOpen(false)
    }
  }

  const isAkhiri = selectedTugas?.status_tugas_id === 2

  return (
    <div className="w-full flex flex-col min-h-screen bg-white font-sans text-slate-800">
      
      <div className="px-6 md:px-10 py-8 bg-white border-b border-slate-100">
        <h1 className="text-2xl font-black text-slate-900 tracking-tight">Pekerjaan Saya</h1>
        <p className="text-slate-400 text-xs font-bold uppercase tracking-widest mt-1">Sistem Kompensasi Mahasiswa</p>
      </div>

      <div className="px-4 md:px-10 py-6">
        <div className="bg-white border border-slate-200 rounded-[2rem] overflow-hidden shadow-sm">
          <div className="p-6 border-b border-slate-100 flex flex-col md:flex-row justify-between items-start md:items-center gap-4 bg-slate-50/30">
            <div className="flex flex-wrap items-center gap-3">
              <div className="relative group">
                <input 
                  type="text" 
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Cari tugas..." 
                  className="pl-11 pr-4 py-3 bg-white border border-slate-200 rounded-2xl text-sm outline-none focus:border-[#2e5299] transition-all w-64" 
                />
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
              </div>

              <div className="relative">
                <select 
                  value={filterTipe}
                  onChange={(e) => setFilterTipe(e.target.value)}
                  className="appearance-none pl-10 pr-10 py-3 bg-white border border-slate-200 rounded-2xl text-sm font-bold text-slate-700 outline-none focus:border-[#2e5299] cursor-pointer"
                >
                  {listTipe.map((tipe) => (
                    <option key={tipe} value={tipe}>{tipe}</option>
                  ))}
                </select>
                <Filter className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={16} />
                <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" size={16} />
              </div>
            </div>

            <div className="flex items-center gap-4">
              <span className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Tampilkan</span>
              <select 
                value={rowsPerPage} 
                onChange={(e) => setRowsPerPage(Number(e.target.value))}
                className="bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs font-bold outline-none"
              >
                <option value={5}>5</option>
                <option value={10}>10</option>
                <option value={20}>20</option>
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] uppercase tracking-widest font-bold">
                  <th className="px-4 py-5 text-center w-12">No</th>
                  <th className="px-8 py-5">Pekerjaan</th>
                  <th className="px-6 py-5 text-center hidden lg:table-cell">Tipe</th>
                  <th className="px-6 py-5 text-center">Poin</th>
                  <th className="px-6 py-5 text-center hidden md:table-cell">Semester</th>
                  <th className="px-6 py-5 text-center hidden xl:table-cell">Status</th>
                  <th className="px-8 py-5 text-right">Aksi</th>
                </tr>
              </thead>
              <tbody className="text-sm font-medium text-slate-600">
                {currentRows.map((t, index) => (
                  <tr key={t.id} className="border-b border-slate-50 hover:bg-slate-50/30 transition-colors">
                    <td className="px-4 py-6 text-center text-slate-500 font-semibold">{startIndex + index + 1}</td>
                    <td className="px-8 py-6 text-left">
                      <div className="font-bold text-slate-800 leading-tight text-base">{t.pekerjaan?.judul}</div>
                      <div className="text-[11px] text-slate-400 flex items-center gap-1 mt-1 lowercase font-medium">
                        <MapPin size={12}/> {t.pekerjaan?.ruangan?.nama_ruangan || 'Polines'}
                      </div>
                    </td>
                    <td className="px-6 py-6 text-center hidden lg:table-cell">
                      <span className={`inline-flex items-center px-2 py-1 rounded-full text-[9px] font-bold uppercase ${
                        t.pekerjaan?.tipe_pekerjaan?.nama === 'Internal' ? 'bg-blue-100 text-blue-700' : 'bg-orange-100 text-orange-700'
                      }`}>
                        {t.pekerjaan?.tipe_pekerjaan?.nama || 'Eksternal'}
                      </span>
                    </td>
                    <td className="px-6 py-6 text-center text-slate-800 font-bold">{t.pekerjaan?.poin_jam} jam</td>
                    <td className="px-6 py-6 text-center hidden md:table-cell text-slate-500 text-xs font-medium uppercase tracking-tighter">smt {t.pekerjaan?.semester?.nama || '-'}</td>
                    <td className="px-6 py-6 text-center hidden xl:table-cell">
                      <span className={`px-3 py-1 rounded-lg text-[9px] font-black uppercase tracking-tighter ${
                        t.status_tugas_id === 2 ? 'bg-blue-50 text-[#2e5299]' :
                        t.status_tugas_id === 3 ? 'bg-green-50 text-green-600' : 'bg-slate-50 text-slate-300'
                      }`}>
                        {t.status_tugas?.nama || 'Menunggu'}
                      </span>
                    </td>
                    <td className="px-8 py-6 text-right whitespace-nowrap">
                      {t.status_tugas_id !== null && t.status_tugas_id <= 2 ? (
                        <button onClick={() => handleAction(t)} className={`px-6 py-2 rounded-xl font-bold text-[10px] uppercase tracking-wider shadow-sm transition-all active:scale-95 ${t.status_tugas_id === 1 ? 'bg-[#2e5299] text-white shadow-md' : 'bg-white border border-slate-200 text-slate-800 hover:bg-slate-50'}`}>
                          {t.status_tugas_id === 1 ? 'Mulai' : 'Akhiri'}
                        </button>
                      ) : (
                        <span className={`inline-flex px-3 py-1.5 rounded-xl text-[10px] font-black uppercase tracking-tight ${
                          t.status_tugas_id === 3 ? 'bg-green-50 text-green-700' :
                          t.status_tugas_id === 4 ? 'bg-blue-50 text-blue-700' :
                          t.status_tugas_id === 5 ? 'bg-red-50 text-red-600' :
                          'bg-slate-50 text-slate-400'
                        }`}>
                          {t.status_tugas?.nama || '-'}
                        </span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="p-6 bg-slate-50/50 flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">
              Total {filteredData.length} Pekerjaan
            </p>
            <div className="flex items-center gap-2">
              <button disabled={currentPage === 1} onClick={() => setCurrentPage(p => p - 1)} className="p-2 bg-white border border-slate-200 rounded-xl disabled:opacity-30"><ChevronLeft size={16} /></button>
              <div className="flex gap-1">
                {[...Array(totalPages)].map((_, i) => (
                  <button key={i} onClick={() => setCurrentPage(i + 1)} className={`w-8 h-8 rounded-lg font-bold text-[10px] ${currentPage === i + 1 ? 'bg-[#2e5299] text-white' : 'bg-white border border-slate-200 text-slate-400'}`}> {i + 1} </button>
                ))}
              </div>
              <button disabled={currentPage === totalPages || totalPages === 0} onClick={() => setCurrentPage(p => p + 1)} className="p-2 bg-white border border-slate-200 rounded-xl disabled:opacity-30"><ChevronRight size={16} /></button>
            </div>
          </div>
        </div>
      </div>

      {isModalOpen && selectedTugas && (
        <div className="fixed inset-0 z-[100] flex items-end md:items-center justify-center bg-black/20 backdrop-blur-sm p-0 md:p-4 text-left">
          <div className="bg-white rounded-t-[2.5rem] md:rounded-[2rem] shadow-2xl w-full max-w-lg overflow-hidden flex flex-col animate-in slide-in-from-bottom duration-300">
             <div className="px-8 py-6 flex justify-between items-center border-b border-slate-50">
               <div className="text-left">
                 <h3 className="text-lg font-bold">{isAkhiri ? 'Upload Bukti' : 'Konfirmasi Mulai'}</h3>
                 <p className="text-[10px] text-slate-400 font-bold uppercase">{selectedTugas.pekerjaan?.judul}</p>
               </div>
               <button onClick={() => setIsModalOpen(false)} className="p-2 bg-slate-50 rounded-full text-slate-300"><X size={20}/></button>
             </div>
             <div className="p-8 space-y-6">
                <div className="bg-blue-50/50 p-5 rounded-2xl border border-blue-100 flex items-center gap-4">
                  <MapPinned className="text-[#2e5299] shrink-0"/>
                  <div className="text-left min-w-0">
                    <p className="text-sm font-bold text-slate-800 truncate">{address}</p>
                    <p className="text-[11px] font-mono text-slate-400 italic">
                      {location ? `${location.lat.toFixed(6)}, ${location.lng.toFixed(6)}` : '-'}
                    </p>
                  </div>
                </div>

                <div className="aspect-video bg-slate-50 rounded-[1.5rem] relative overflow-hidden border border-slate-100 shadow-inner group">
                  {imgSrc ? (
                    <img src={imgSrc} alt="Bukti" className="w-full h-full object-cover"/>
                  ) : (
                    <Webcam audio={false} ref={webcamRef} screenshotFormat="image/jpeg" className="w-full h-full object-cover" />
                  )}
                  <button
                    onClick={imgSrc ? () => setImgSrc(null) : capture}
                    className="absolute bottom-4 right-4 w-14 h-14 bg-white rounded-2xl shadow-xl flex items-center justify-center text-[#2e5299] active:scale-95 transition-all"
                  >
                    {imgSrc ? <RefreshCcw size={22}/> : <Camera size={22}/>}
                  </button>
                </div>

                {/* Eksternal Only */}
                {selectedTugas?.pekerjaan?.tipe_pekerjaan_id === 2 && (
                  <div className="grid grid-cols-1 gap-5 pt-4 border-t border-slate-50 text-left animate-in fade-in slide-in-from-top-4 duration-500">
                    <div className="space-y-1.5 text-left">
                      <label className="text-[10px] font-black text-slate-400 uppercase ml-1 flex items-center gap-2 text-left">
                        <Banknote size={14}/> Nominal (Tanpa Koma)
                      </label>
                      <input type="number" placeholder="50000" className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm outline-none focus:border-[#2e5299] font-bold text-slate-700 text-left" />
                    </div>
                    <div className="space-y-1.5 text-left">
                      <label className="text-[10px] font-black text-slate-400 uppercase ml-1 flex items-center gap-2 text-left">
                        <FileText size={14}/> Keterangan / Nota
                      </label>
                      <textarea placeholder="Rincian..." rows={2} className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm outline-none focus:border-[#2e5299] resize-none font-medium text-left" />
                    </div>
                  </div>
                )}

                <button
                  onClick={() => updateStatus(selectedTugas.id)}
                  disabled={isAkhiri && !imgSrc}
                  className="w-full py-4 bg-[#2e5299] text-white font-black text-xs uppercase tracking-widest rounded-2xl shadow-lg disabled:opacity-50 transition-all"
                >
                  {isAkhiri ? 'Kirim Laporan' : 'Mulai Pekerjaan'}
                </button>
             </div>
          </div>
        </div>
      )}
    </div>
  )
}
