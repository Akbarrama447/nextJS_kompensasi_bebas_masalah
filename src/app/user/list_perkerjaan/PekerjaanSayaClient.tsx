'use client'

import { useState, useRef, useCallback } from 'react'
import Webcam from 'react-webcam'
import { Camera, MapPin, X, Scan, Banknote, FileText, Search, RefreshCcw, MapPinned } from 'lucide-react'
import { updateProgresTugas } from './action'

export default function PekerjaanSayaClient({ initialData, user }: any) {
  const webcamRef = useRef<Webcam>(null)
  
  const [dataTugas, setDataTugas] = useState(initialData || [])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedTugas, setSelectedTugas] = useState<any>(null)
  const [imgSrc, setImgSrc] = useState<string | null>(null)
  const [location, setLocation] = useState<{ lat: number; lng: number } | null>(null)
  const [address, setAddress] = useState<string>("")

  const getLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        async (pos) => {
          const lat = pos.coords.latitude
          const lng = pos.coords.longitude
          setLocation({ lat, lng })

          try {
            const response = await fetch(
              `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`
            )
            const data = await response.json()
            const displayLoc = data.address.village || data.address.suburb || data.address.city_district || data.address.city || "Lokasi Terdeteksi"
            setAddress(displayLoc) 
          } catch (error) {
            setAddress("Koordinat Terkunci")
          }
        },
        (err) => console.error("Gagal ambil GPS:", err)
      )
    }
  }

  const handleAction = (tugas: any) => {
    setSelectedTugas(tugas)
    setImgSrc(null)
    setAddress("Mencari lokasi...")
    getLocation()
    setIsModalOpen(true)
  }

  const capture = useCallback(() => {
    const imageSrc = webcamRef.current?.getScreenshot()
    if (imageSrc) {
      setImgSrc(imageSrc)
      getLocation()
    }
  }, [webcamRef])

  const updateStatus = async (id: number) => {
    if (!selectedTugas) return

    const formData = new FormData()
    formData.append('id', id.toString())
    formData.append('status_tugas_id', selectedTugas.status_tugas_id.toString())
    
    if (imgSrc) {
        formData.append('image', imgSrc)
    }

    const result = await updateProgresTugas(formData)

    if (result.success) {
      const updated = dataTugas.map((t: any) => {
        if (t.id === id) return { ...t, status_tugas_id: result.nextStatus }
        return t
      })
      setDataTugas(updated)
      setIsModalOpen(false)
    } else {
      alert("Gagal simpan ke DB. Pastikan folder public/uploads sudah ada.")
    }
  }

  return (
    <div className="w-full flex flex-col min-h-screen bg-white font-sans text-slate-800">
      
      {/* Header Search */}
      <div className="px-6 md:px-10 py-6 border-b border-slate-100 flex justify-between items-center text-left">
        <div className="relative w-full max-w-xs">
          <input 
            type="text" 
            placeholder="Cari tugas saya..." 
            className="w-full pl-10 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-sm outline-none focus:border-[#2e5299] transition-all" 
          />
          <Search className="absolute left-3.5 top-2.5 text-slate-400" size={16} />
        </div>
      </div>

      {/* Table Section */}
      <div className="p-4 md:p-10 overflow-x-auto flex-1 text-left">
        <div className="min-w-[850px] md:min-w-full border border-slate-200 rounded-2xl overflow-hidden shadow-sm bg-white">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] uppercase tracking-widest font-bold">
                <th className="px-8 py-5">Pekerjaan</th>
                <th className="px-6 py-5 text-center">Poin</th>
                <th className="px-6 py-5 text-center">Status</th>
                <th className="px-8 py-5 text-right">Aksi</th>
              </tr>
            </thead>
            <tbody className="text-sm font-medium text-slate-600">
              {dataTugas.map((t: any) => (
                <tr key={t.id} className="border-b border-slate-50 hover:bg-slate-50/30 transition-colors">
                  <td className="px-8 py-6 text-left">
                    <div className="font-bold text-slate-800 leading-tight text-base">{t.pekerjaan?.judul}</div>
                    <div className="text-[11px] text-slate-400 flex items-center gap-1 mt-1 lowercase font-medium">
                      <MapPin size={12}/> {t.pekerjaan?.ruangan?.nama_ruangan || 'Polines'}
                    </div>
                  </td>
                  <td className="px-6 py-6 text-center text-slate-800 font-bold">{t.pekerjaan?.poin_jam} jam</td>
                  <td className="px-6 py-6 text-center">
                    <span className={`px-3 py-1 rounded-lg text-[9px] font-black uppercase tracking-tighter ${
                      t.status_tugas_id === 2 ? 'bg-blue-50 text-[#2e5299]' : 
                      t.status_tugas_id === 3 ? 'bg-green-50 text-green-600' : 'bg-slate-50 text-slate-300'
                    }`}>
                      {t.status_tugas?.nama || 'Menunggu'}
                    </span>
                  </td>
                  <td className="px-8 py-6 text-right">
                    {t.status_tugas_id <= 2 && (
                      <button 
                        onClick={() => handleAction(t)}
                        className={`px-6 py-2 rounded-xl font-bold text-[10px] uppercase tracking-wider transition-all active:scale-95 ${
                          t.status_tugas_id === 1 ? 'bg-[#2e5299] text-white shadow-md' : 'bg-white border border-slate-200 text-slate-800 hover:bg-slate-50'
                        }`}
                      >
                        {t.status_tugas_id === 1 ? 'Mulai' : 'Akhiri'}
                      </button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {dataTugas.length === 0 && (
            <div className="p-20 text-center text-slate-400 text-sm italic font-medium">
              Belum ada tugas penugasan untuk Anda.
            </div>
          )}
        </div>
      </div>

      {/* MODAL VERIFIKASI */}
      {isModalOpen && (
        <div className="fixed inset-0 z-[100] flex items-end md:items-center justify-center bg-black/20 backdrop-blur-sm p-0 md:p-4 text-left">
          <div className="bg-white rounded-t-[2.5rem] md:rounded-[2rem] shadow-2xl w-full max-w-lg overflow-hidden flex flex-col border border-slate-100 animate-in slide-in-from-bottom duration-300">
            
            <div className="px-8 py-6 flex justify-between items-center border-b border-slate-50 text-left">
              <div className="text-left min-w-0">
                <h3 className="text-lg font-bold text-slate-800 tracking-tight leading-none mb-1 text-left">Verifikasi Progres</h3>
                <p className="text-[10px] text-slate-400 font-bold uppercase truncate text-left">{selectedTugas?.pekerjaan?.judul}</p>
              </div>
              <button onClick={() => setIsModalOpen(false)} className="p-2 text-slate-300 hover:text-slate-800 transition-colors bg-slate-50 rounded-full"><X size={20} /></button>
            </div>
            
            <div className="p-8 space-y-6 overflow-y-auto max-h-[75vh] text-left">
              {/* GPS Info: Nama Lokasi + Koordinat */}
              <div className="flex items-center gap-4 bg-blue-50/50 p-5 rounded-2xl border border-blue-100 text-left">
                <MapPinned size={20} className="text-[#2e5299] shrink-0" />
                <div className="min-w-0 text-left">
                  <p className="text-[9px] font-black text-[#2e5299]/60 uppercase tracking-widest leading-none mb-1.5 text-left">Titik Lokasi Terdeteksi</p>
                  <div className="flex flex-col gap-0.5">
                    <p className="text-[14px] font-bold text-slate-800 leading-tight truncate">
                      {address || "Mencari Alamat..."}
                    </p>
                    <p className="text-[11px] font-medium text-slate-500 font-mono italic">
                      {location ? `${location.lat.toFixed(6)}, ${location.lng.toFixed(6)}` : "Mengunci GPS..."}
                    </p>
                  </div>
                </div>
              </div>

              {/* Camera */}
              <div className="space-y-2 text-left">
                <label className="text-[10px] font-black text-slate-400 uppercase ml-1 flex items-center gap-2 text-left">
                  <Scan size={12} /> Bukti Foto Pekerjaan
                </label>
                <div className="aspect-video bg-slate-50 rounded-[1.5rem] relative overflow-hidden border border-slate-100 shadow-inner group">
                   {imgSrc ? (
                     <img src={imgSrc} alt="Capture" className="w-full h-full object-cover shadow-lg" />
                   ) : (
                     <Webcam audio={false} ref={webcamRef} screenshotFormat="image/jpeg" className="w-full h-full object-cover scale-110" videoConstraints={{ facingMode: "environment" }} />
                   )}
                   
                   <div className="absolute bottom-4 left-4 text-[#2e5299] font-black text-[8px] md:text-[9px] flex flex-col items-start uppercase leading-tight bg-white/95 p-2.5 rounded-xl backdrop-blur-sm shadow-xl border border-white">
                      <span>{new Date().toLocaleDateString('id-ID')}</span>
                      <span className="truncate max-w-[150px]">{address || "AREA TERDETEKSI"}</span>
                      <span className="opacity-70 font-mono text-[7px]">
                        {location ? `${location.lat.toFixed(4)}, ${location.lng.toFixed(4)}` : ""}
                      </span>
                      <span className="text-[#2e5299]/60">{user?.nama?.split(' ')[0] || 'User'}</span>
                   </div>

                   <button onClick={imgSrc ? () => setImgSrc(null) : capture} className="absolute bottom-4 right-4 w-14 h-14 bg-white rounded-2xl shadow-2xl flex items-center justify-center text-[#2e5299] active:scale-90 transition-all border border-slate-50">
                     {imgSrc ? <RefreshCcw size={22} /> : <Camera size={22} />}
                   </button>
                </div>
              </div>

              {/* Eksternal Only */}
              {selectedTugas?.pekerjaan?.tipe_pekerjaan_id === 1 && (
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
            </div>

            <div className="px-8 pb-10 flex gap-4 mt-auto border-t border-slate-50 pt-8 bg-white shrink-0">
               <button onClick={() => setIsModalOpen(false)} className="flex-1 py-4 text-slate-400 font-bold text-[11px] uppercase tracking-widest rounded-2xl hover:bg-slate-50 transition-all">Batal</button>
               <button 
                 onClick={() => updateStatus(selectedTugas.id)} 
                 disabled={!imgSrc} 
                 className={`flex-[2] py-4 rounded-2xl font-bold text-[11px] uppercase tracking-widest shadow-lg active:translate-y-0.5 ${!imgSrc ? 'bg-slate-100 text-slate-300 cursor-not-allowed' : 'bg-[#2e5299] text-white'}`}
               >
                 {selectedTugas?.status_tugas_id === 1 ? 'Simpan & Mulai' : 'Simpan & Selesai'}
               </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}