'use client'

import { useState } from 'react'
import UserHeader from '@/components/UserHeader'

interface StudentData {
  nama: string
  nim: string
  jam: number
}

interface EkuivalensiData {
  id: number
  status: string
  jam: number
  nominal: number
  notaUrl: string
  catatan: string
  penanggung_jawab_nim: string
}

interface Props {
  namaMahasiswa: string
  nim: string
  namaKelas: string
  students: StudentData[]
  ekuivalensi: EkuivalensiData | null
  semesterLabel?: string
}

export default function EkuivalensiClient({
  namaMahasiswa,
  nim,
  namaKelas,
  students,
  ekuivalensi,
  semesterLabel,
}: Props) {
  const [uploading, setUploading] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [uploadMessage, setUploadMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)
  const [previewOpen, setPreviewOpen] = useState(false)
  const [previewFile, setPreviewFile] = useState<string | null>(null)
  const [localEkuivalensi, setLocalEkuivalensi] = useState<EkuivalensiData | null>(ekuivalensi)

  const totalJam = students.reduce((sum, s) => sum + s.jam, 0)

  const handleAjukan = async () => {
    setSubmitting(true)
    setUploadMessage(null)

    try {
      const res = await fetch('/api/ekuivalensi/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nim }),
      })

      const data = await res.json()

      if (!res.ok) {
        setUploadMessage({ type: 'error', text: data.message || 'Gagal mengajukan' })
        return
      }

      setLocalEkuivalensi({
        id: data.ekuivalensi.id,
        status: 'Menunggu Verifikasi',
        jam: data.ekuivalensi.jam,
        nominal: data.ekuivalensi.nominal,
        notaUrl: '',
        catatan: '',
        penanggung_jawab_nim: nim,
      })

      setUploadMessage({ type: 'success', text: 'Pengajuan berhasil! Upload bukti sekarang.' })
      setTimeout(() => setUploadMessage(null), 3000)
    } catch {
      setUploadMessage({ type: 'error', text: 'Terjadi kesalahan koneksi' })
    } finally {
      setSubmitting(false)
    }
  }

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file || !localEkuivalensi) return

    setUploading(true)
    setUploadMessage(null)

    const formData = new FormData()
    formData.append('file', file)
    formData.append('ekuivalensiId', String(localEkuivalensi.id))

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
      setLocalEkuivalensi((prev) => prev ? { ...prev, notaUrl: data.notaUrl } : prev)
      setTimeout(() => setUploadMessage(null), 2000)
    } catch {
      setUploadMessage({ type: 'error', text: 'Terjadi kesalahan saat upload' })
    } finally {
      setUploading(false)
    }
  }

  const handlePreview = (url: string) => {
    const cleanUrl = url.split('?')[0].toLowerCase()
    const ext = cleanUrl.split('.').pop()

    if (['doc', 'docx'].includes(ext || '')) {
      const fullPath = url.startsWith('http')
        ? url
        : `${window.location.origin}${url.startsWith('/') ? url : `/${url}`}`
      const encodedUrl = encodeURIComponent(fullPath)
      window.open(`https://docs.google.com/gview?url=${encodedUrl}&embedded=true`, '_blank')
      return
    }

    setPreviewFile(url)
    setPreviewOpen(true)
  }

  return (
    <>
      <UserHeader nama={namaMahasiswa} role="mahasiswa" semesterLabel={semesterLabel} />

      <div className="p-10 max-w-6xl mx-auto">
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-slate-800 mb-0.5">Ekuivalensi</h2>
          <p className="text-sm text-[#2e5299] font-medium opacity-80">
            Pengajuan iuran kolektif pengganti jam kompen
          </p>
        </div>

        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-6">
          {namaKelas !== '-' && (
            <h3 className="text-lg font-extrabold text-slate-800 uppercase tracking-wide">
              Kelas {namaKelas}
            </h3>
          )}

          {students.length > 0 ? (
            <>
              <div className="border border-slate-200 rounded-xl overflow-hidden">
                <table className="min-w-full divide-y divide-slate-200">
                  <thead className="bg-slate-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Nama</th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">NIM</th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Sisa Jam</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-slate-100">
                    {students.map((s, i) => (
                      <tr key={i} className="hover:bg-slate-50/50 transition">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-slate-700">{s.nama}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-slate-500">{s.nim}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-slate-700">{s.jam}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-4 border border-slate-200 rounded-xl divide-y md:divide-y-0 md:divide-x divide-slate-200 overflow-hidden text-center">
                <div className="flex items-center justify-center p-4 bg-slate-50/40">
                  <span className="text-sm font-bold text-slate-500 mr-3 uppercase">Total</span>
                  <span className="text-lg font-extrabold text-slate-800">{totalJam} Jam</span>
                </div>

                <div className="flex items-center justify-center p-4 text-sm font-bold text-slate-700 uppercase">
                  {localEkuivalensi?.catatan || 'Tidak Ada Keterangan'}
                </div>

                <div className="flex flex-col items-center justify-center p-4 space-y-2">
                  <span className="text-xs font-extrabold text-slate-500 uppercase">Bukti</span>
                  {localEkuivalensi ? (
                    localEkuivalensi.notaUrl ? (
                      <div className="flex flex-col items-center space-y-2 w-full">
                        <button
                          onClick={() => handlePreview(localEkuivalensi.notaUrl)}
                          className="px-4 py-1 text-xs font-extrabold text-slate-600 bg-slate-200 hover:bg-slate-300 transition rounded-md uppercase tracking-wider"
                        >
                          Lihat Bukti
                        </button>
                        <a
                          href={localEkuivalensi.notaUrl}
                          download
                          className="px-3 py-1 text-xs font-bold text-slate-700 bg-slate-100 hover:bg-slate-200 transition rounded-md uppercase tracking-wider"
                        >
                          Download
                        </a>
                        <label className="px-3 py-1 text-xs font-bold text-slate-700 bg-amber-100 hover:bg-amber-200 cursor-pointer transition rounded-md uppercase tracking-wider">
                          Ganti File
                          <input type="file" onChange={handleFileUpload} disabled={uploading} className="hidden" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
                        </label>
                      </div>
                    ) : (
                      <label className="px-4 py-2 text-xs font-bold text-white bg-blue-500 hover:bg-blue-600 cursor-pointer transition rounded-md uppercase tracking-wider">
                        {uploading ? 'Uploading...' : 'Upload File'}
                        <input type="file" onChange={handleFileUpload} disabled={uploading} className="hidden" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
                      </label>
                    )
                  ) : (
                    <button
                      onClick={handleAjukan}
                      disabled={submitting}
                      className="px-4 py-2 text-xs font-bold text-white bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 transition rounded-md uppercase tracking-wider"
                    >
                      {submitting ? 'Memproses...' : 'Ajukan Ekuivalensi'}
                    </button>
                  )}
                  {uploadMessage && (
                    <span className={`text-xs font-bold ${uploadMessage.type === 'success' ? 'text-emerald-600' : 'text-rose-600'}`}>
                      {uploadMessage.text}
                    </span>
                  )}
                </div>

                <div className="flex flex-col items-center justify-center p-4 space-y-1">
                  <span className="text-xs font-extrabold text-slate-500 uppercase">Status</span>
                  {localEkuivalensi ? (
                    <span
                      className={`px-4 py-1 text-xs font-extrabold rounded-md uppercase tracking-wider text-white ${
                        localEkuivalensi.status.toLowerCase() === 'ditolak'
                          ? 'bg-rose-500'
                          : localEkuivalensi.status.toLowerCase() === 'disetujui'
                          ? 'bg-emerald-500'
                          : 'bg-amber-500'
                      }`}
                    >
                      {localEkuivalensi.status}
                    </span>
                  ) : (
                    <span className="text-xs text-slate-400">Belum diajukan</span>
                  )}
                </div>
              </div>

              {localEkuivalensi?.catatan && (
                <div className="p-3 border border-red-200 bg-red-50 rounded-lg">
                  <p className="text-xs text-red-500 font-medium">Catatan / Alasan</p>
                  <p className="text-sm text-red-700">{localEkuivalensi.catatan}</p>
                </div>
              )}
            </>
          ) : (
            <div className="border border-dashed border-slate-200 rounded-xl py-12 text-center text-sm text-slate-400">
              {namaKelas !== '-' ? 'Semua mahasiswa sudah lunas jam kompen.' : 'Kamu belum terdaftar di kelas manapun.'}
            </div>
          )}
        </div>
      </div>

      {previewOpen && previewFile && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center p-4 z-50 backdrop-blur-sm">
          <div className="bg-white rounded-xl max-w-4xl w-full h-[85vh] flex flex-col overflow-hidden shadow-2xl animate-in fade-in zoom-in-95 duration-150">
            <div className="flex items-center justify-between p-4 border-b border-slate-200">
              <h3 className="text-lg font-bold text-slate-800">Preview Dokumen</h3>
              <button onClick={() => { setPreviewOpen(false); setPreviewFile(null) }} className="text-slate-400 hover:text-slate-600 text-2xl transition">&times;</button>
            </div>
            <div className="flex-1 overflow-auto bg-slate-100 flex items-center justify-center p-4">
              {(() => {
                const cleanUrl = previewFile.split('?')[0].toLowerCase()
                const isPdf = cleanUrl.endsWith('.pdf')
                if (isPdf) {
                  return (
                    <object data={previewFile} type="application/pdf" className="w-full h-full border-none rounded">
                      <iframe src={previewFile} className="w-full h-full border-none rounded" title="PDF Fallback Preview" />
                    </object>
                  )
                }
                return (
                  <img
                    src={previewFile}
                    alt="Preview Bukti"
                    className="max-w-full max-h-[70vh] object-contain rounded shadow-sm"
                    onError={(e) => {
                      const target = e.target as HTMLImageElement
                      target.onerror = null
                      target.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='150' viewBox='0 0 300 150'%3E%3Crect width='300' height='150' fill='%23f1f5f9'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' font-family='sans-serif' font-size='12' fill='%2394a3b8'%3EFile Tidak Ditemukan%3C/text%3E%3C/svg%3E"
                      }}
                  />
                )
              })()}
            </div>
          </div>
        </div>
      )}
    </>
  )
}
