'use client'

import { useState } from 'react'
import UserHeader from '@/components/UserHeader'

interface EkuivalensiData {
  id: number | string
  penanggung_jawab_nim: string
  mahasiswa?: { nama: string }
  jam_diakui: number
  status: string
  nota_url?: string | null
  catatan?: string | null
  nama_kelas: string
  nama_semester: string
  nominal_total: number | null
  verified_by_nip?: string | null
}

interface EkuivalensiClientProps {
  namaMahasiswa: string
  ekuivalensi: EkuivalensiData[]
  namaKelas: string
}

export default function EkuivalensiClient({
  namaMahasiswa,
  ekuivalensi,
  namaKelas,
}: EkuivalensiClientProps) {
  
  // Hitung total jam dari seluruh list ekuivalensi
  const totalJam = ekuivalensi.reduce((sum, item) => sum + item.jam_diakui, 0)

  // Ambil data catatan, nota, dan status dari item pertama jika ada data (sebagai representasi kolektif)
  const infoKolektif = ekuivalensi[0] || null

  // Upload state
  const [uploading, setUploading] = useState(false)
  const [uploadMessage, setUploadMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null)
  const [previewOpen, setPreviewOpen] = useState(false)
  const [previewFile, setPreviewFile] = useState<string | null>(null)

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file) return

    setUploading(true)
    setUploadMessage(null)

    const formData = new FormData()
    formData.append('file', file)
    formData.append('ekuivalensiId', String(infoKolektif?.id || ''))

    try {
      const response = await fetch('/api/ekuivalensi/upload', {
        method: 'POST',
        body: formData,
      })

      const data = await response.json()

      if (!response.ok) {
        setUploadMessage({ type: 'error', text: data.message || 'Upload gagal' })
        return
      }

      setUploadMessage({ type: 'success', text: 'File berhasil diupload' })
      // Reload halaman atau update state
      setTimeout(() => window.location.reload(), 1500)
    } catch (error) {
      setUploadMessage({ type: 'error', text: 'Terjadi kesalahan saat upload' })
    } finally {
      setUploading(false)
    }
  }

  const handlePreview = (url: string) => {
    // Ambil path tanpa query parameter terlebih dahulu
    const cleanUrl = url.split('?')[0].toLowerCase()
    const ext = cleanUrl.split('.').pop()
    
    // Jika DOC/DOCX, buka dengan Google Docs Viewer (Memerlukan absolute URL)
    if (['doc', 'docx'].includes(ext || '')) {
      const fullPath = url.startsWith('http') 
        ? url 
        : `${window.location.origin}${url.startsWith('/') ? url : `/${url}`}`
      const encodedUrl = encodeURIComponent(fullPath)
      window.open(`https://docs.google.com/gview?url=${encodedUrl}&embedded=true`, '_blank')
      return
    }
    
    // Untuk PDF & Image, langsung pass relative path mentah saja agar aman
    setPreviewFile(url)
    setPreviewOpen(true)
  }

  return (
    <>
      <UserHeader nama={namaMahasiswa} role="mahasiswa" />

      <div className="p-10 max-w-6xl mx-auto">
        {/* Title Section */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Ekuivalensi</h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">
            Verifikasi pengajuan iuran kolektif
          </p>
        </div>

        {/* --- KONTEN UTAMA: OUTER CARD --- */}
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-6">
          
          {/* Header Kelas */}
          {namaKelas && (
            <h3 className="text-lg font-extrabold text-slate-800 uppercase tracking-wide">
              Kelas {namaKelas}
            </h3>
          )}

          {ekuivalensi.length > 0 ? (
            <>
              {/* --- INNER CARD (Kolom di dalam Kolom) --- */}
              <div className="border border-slate-200 rounded-xl overflow-hidden">
                <table className="min-w-full divide-y divide-slate-200">
                  <thead className="bg-slate-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">
                        Nama
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">
                        NIM
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">
                        Jam
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-slate-100">
                    {ekuivalensi.map((item) => (
                      <tr key={item.id} className="hover:bg-slate-50/50 transition">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-slate-700">
                          {item.mahasiswa?.nama || '-'}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-slate-500">
                          {item.penanggung_jawab_nim}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-slate-700">
                          {item.jam_diakui}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* --- FOOTER GRID (Sesuai Mockup Gambar) --- */}
              <div className="grid grid-cols-1 md:grid-cols-4 border border-slate-200 rounded-xl divide-y md:divide-y-0 md:divide-x divide-slate-200 overflow-hidden text-center">
                
                {/* Total Jam */}
                <div className="flex items-center justify-center p-4 bg-slate-50/40">
                  <span className="text-sm font-bold text-slate-500 mr-3 uppercase">Total</span>
                  <span className="text-lg font-extrabold text-slate-800">{totalJam} Jam</span>
                </div>

                {/* Deskripsi/Catatan */}
                <div className="flex items-center justify-center p-4 text-sm font-bold text-slate-700 uppercase">
                  {infoKolektif?.catatan || 'Tidak Ada Keterangan'}
                </div>

                {/* Bukti Upload */}
                <div className="flex flex-col items-center justify-center p-4 space-y-2">
                  <span className="text-xs font-extrabold text-slate-500 uppercase">Bukti</span>
                  {infoKolektif?.nota_url ? (
                    <div className="flex flex-col items-center space-y-2 w-full">
                      <button
                        onClick={() => handlePreview(infoKolektif.nota_url!)}
                        className="px-4 py-1 text-xs font-extrabold text-slate-600 bg-slate-200 hover:bg-slate-300 transition rounded-md uppercase tracking-wider"
                      >
                        Lihat Bukti
                      </button>
                      <a
                        href={infoKolektif.nota_url}
                        download
                        className="px-3 py-1 text-xs font-bold text-slate-700 bg-slate-100 hover:bg-slate-200 transition rounded-md uppercase tracking-wider"
                      >
                        Download
                      </a>
                      <label className="px-3 py-1 text-xs font-bold text-slate-700 bg-amber-100 hover:bg-amber-200 cursor-pointer transition rounded-md uppercase tracking-wider">
                        Ganti File
                        <input
                          type="file"
                          onChange={handleFileUpload}
                          disabled={uploading}
                          className="hidden"
                          accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                        />
                      </label>
                    </div>
                  ) : (
                    <label className="px-4 py-2 text-xs font-bold text-white bg-blue-500 hover:bg-blue-600 cursor-pointer transition rounded-md uppercase tracking-wider">
                      {uploading ? 'Uploading...' : 'Upload File'}
                      <input
                        type="file"
                        onChange={handleFileUpload}
                        disabled={uploading}
                        className="hidden"
                        accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                      />
                    </label>
                  )}
                  {uploadMessage && (
                    <span className={`text-xs font-bold ${uploadMessage.type === 'success' ? 'text-emerald-600' : 'text-rose-600'}`}>
                      {uploadMessage.text}
                    </span>
                  )}
                </div>

                {/* Status Badge */}
                <div className="flex flex-col items-center justify-center p-4 space-y-1">
                  <span className="text-xs font-extrabold text-slate-500 uppercase">Status</span>
                  <span
                    className={`px-4 py-1 text-xs font-extrabold rounded-md uppercase tracking-wider text-white ${
                      infoKolektif?.status.toLowerCase() === 'ditolak'
                        ? 'bg-rose-500'
                        : infoKolektif?.status.toLowerCase() === 'disetujui'
                        ? 'bg-emerald-500'
                        : 'bg-amber-500'
                    }`}
                  >
                    {infoKolektif?.status || 'Menunggu'}
                  </span>
                </div>

              </div>
            </>
          ) : (
            <div className="border border-dashed border-slate-200 rounded-xl py-12 text-center text-sm text-slate-400">
              Tidak ada data ekuivalensi kelas saat ini.
            </div>
          )}

        </div>
      </div>

      {/* --- PREVIEW MODAL --- */}
      {previewOpen && previewFile && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
          <div className="bg-white rounded-xl max-w-4xl w-full h-[85vh] flex flex-col overflow-hidden shadow-2xl animate-in fade-in zoom-in-95 duration-150">
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b border-slate-200">
              <h3 className="text-lg font-bold text-slate-800">Preview Dokumen</h3>
              <button
                onClick={() => {
                  setPreviewOpen(false)
                  setPreviewFile(null)
                }}
                className="text-slate-400 hover:text-slate-600 text-2xl transition"
              >
                &times;
              </button>
            </div>

            {/* Content Body */}
            <div className="flex-1 overflow-auto bg-slate-100 flex items-center justify-center p-4">
              {(() => {
                const cleanUrl = previewFile.split('?')[0].toLowerCase()
                const isPdf = cleanUrl.endsWith('.pdf')

                if (isPdf) {
                  return (
                    <object
                      data={previewFile}
                      type="application/pdf"
                      className="w-full h-full border-none rounded"
                    >
                      <iframe
                        src={previewFile}
                        className="w-full h-full border-none rounded"
                        title="PDF Fallback Preview"
                      />
                    </object>
                  )
                } else {
                  return (
                    <img
                      src={previewFile}
                      alt="Preview Bukti"
                      className="max-w-full max-h-[70vh] object-contain rounded shadow-sm"
                      onError={(e) => {
                        console.error('Gagal load gambar:', previewFile)
                        const target = e.target as HTMLImageElement
                        target.onerror = null // Stop loop
                        target.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='150' viewBox='0 0 300 150'%3E%3Crect width='300' height='150' fill='%23f1f5f9'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' font-family='sans-serif' font-size='12' fill='%2394a3b8'%3EFile Tidak Ditemukan atau Gagal Load%3C/text%3E%3C/svg%3E"
                      }}
                    />
                  )
                }
              })()}
            </div>
          </div>
        </div>
      )}
    </>
  )
} 