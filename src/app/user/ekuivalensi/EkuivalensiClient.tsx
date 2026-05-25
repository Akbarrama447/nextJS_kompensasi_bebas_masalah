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
  noTelepon?: string
  noTeleponChangeCount?: number
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
  
  const [pendingFile, setPendingFile] = useState<File | null>(null)
  const [showConfirmModal, setShowConfirmModal] = useState(false)

  const [noTelepon, setNoTelepon] = useState(localEkuivalensi?.noTelepon || '')
  const [phoneEditMode, setPhoneEditMode] = useState(false)
  const [phoneError, setPhoneError] = useState('')
  const [phoneUpdating, setPhoneUpdating] = useState(false)

  const MAX_PHONE_CHANGE = 5
  const sisaUbahPhone = localEkuivalensi
    ? MAX_PHONE_CHANGE - (localEkuivalensi.noTeleponChangeCount ?? 0)
    : MAX_PHONE_CHANGE
  const isPenanggungJawab = !!(localEkuivalensi && localEkuivalensi.penanggung_jawab_nim === nim)

  const totalJam = students.reduce((sum, s) => sum + s.jam, 0)

  const handleAjukan = async () => {
    if (!noTelepon.trim()) {
      setPhoneError('Nomor telepon harus diisi')
      return
    }

    setSubmitting(true)
    setUploadMessage(null)
    setPhoneError('')

    try {
      const res = await fetch('/api/ekuivalensi/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nim, noTelepon: noTelepon.trim() }),
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
        noTelepon: noTelepon.trim(),
        noTeleponChangeCount: 0,
      })

      setUploadMessage({ type: 'success', text: 'Pengajuan berhasil! Upload bukti sekarang.' })
      setTimeout(() => setUploadMessage(null), 3000)
    } catch {
      setUploadMessage({ type: 'error', text: 'Terjadi kesalahan koneksi' })
    } finally {
      setSubmitting(false)
    }
  }

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file || !localEkuivalensi) return
    
    setPendingFile(file)
    setShowConfirmModal(true)
    
    // Reset the input value so selecting the same file again still fires change
    event.target.value = ''
  }

  const handleCancelUpload = () => {
    setPendingFile(null)
    setShowConfirmModal(false)
  }

  const handleConfirmUpload = async () => {
    if (!pendingFile || !localEkuivalensi) return
    const fileToUpload = pendingFile

    setPendingFile(null)
    setShowConfirmModal(false)
    setUploading(true)
    setUploadMessage(null)

    const formData = new FormData()
    formData.append('file', fileToUpload)
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

  const handleUpdatePhone = async () => {
    if (!localEkuivalensi) return
    if (!noTelepon.trim()) {
      setPhoneError('Nomor telepon harus diisi')
      return
    }

    setPhoneUpdating(true)
    setPhoneError('')

    try {
      const res = await fetch('/api/ekuivalensi/update-phone', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ekuivalensiId: localEkuivalensi.id,
          noTelepon: noTelepon.trim(),
          nim,
        }),
      })

      const data = await res.json()

      if (!res.ok) {
        setPhoneError(data.message || 'Gagal mengupdate nomor telepon')
        return
      }

      setLocalEkuivalensi((prev) =>
        prev
          ? {
              ...prev,
              noTelepon: data.noTelepon,
              noTeleponChangeCount: data.noTeleponChangeCount,
            }
          : prev
      )

      setPhoneEditMode(false)
      setUploadMessage({ type: 'success', text: `Nomor telepon berhasil diupdate. Sisa ${data.sisaUbah}x perubahan.` })
      setTimeout(() => setUploadMessage(null), 3000)
    } catch {
      setPhoneError('Terjadi kesalahan koneksi')
    } finally {
      setPhoneUpdating(false)
    }
  }

  const formatFileSize = (bytes: number) => {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
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
            <div className="flex items-center gap-3">
              <h3 className="text-lg font-extrabold text-slate-800 uppercase tracking-wide">
                Kelas {namaKelas}
              </h3>
              {localEkuivalensi && isPenanggungJawab && (
                <span className="px-2.5 py-0.5 text-[10px] font-bold text-emerald-700 bg-emerald-100 rounded-full uppercase tracking-wider">
                  Penanggung Jawab
                </span>
              )}
            </div>
          )}

          {students.length > 0 ? (
            <>
              <div className="border border-slate-200 rounded-xl overflow-hidden">
                <table className="min-w-full divide-y divide-slate-200">
                  <thead className="bg-slate-50">
                    <tr>
                      <th className="px-6 py-3 text-center text-xs font-bold text-slate-500 uppercase tracking-wider w-12">No</th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Nama</th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">NIM</th>
                      <th className="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Sisa Jam</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-slate-100">
                    {students.map((s, i) => (
                      <tr key={i} className="hover:bg-slate-50/50 transition">
                        <td className="px-6 py-4 text-center text-sm text-slate-400">{i + 1}</td>
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

                <div className="flex flex-col items-center justify-center p-4 space-y-1">
                  {localEkuivalensi ? (
                    <>
                      {phoneEditMode ? (
                        <div className="flex flex-col items-center gap-1 w-full max-w-[200px]">
                          <input
                            type="text"
                            value={noTelepon}
                            onChange={(e) => { setNoTelepon(e.target.value); setPhoneError('') }}
                            placeholder="No. Telepon"
                            className="w-full px-2 py-1 text-xs border border-slate-300 rounded text-center font-semibold focus:outline-none focus:ring-2 focus:ring-blue-400"
                            autoFocus
                          />
                          {phoneError && <span className="text-[10px] font-bold text-rose-500">{phoneError}</span>}
                          <div className="flex gap-1">
                            <button
                              onClick={handleUpdatePhone}
                              disabled={phoneUpdating}
                              className="px-2 py-0.5 text-[10px] font-bold text-white bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 rounded transition uppercase"
                            >
                              {phoneUpdating ? '...' : 'Simpan'}
                            </button>
                            <button
                              onClick={() => { setPhoneEditMode(false); setNoTelepon(localEkuivalensi?.noTelepon || ''); setPhoneError('') }}
                              className="px-2 py-0.5 text-[10px] font-bold text-slate-500 bg-slate-200 hover:bg-slate-300 rounded transition uppercase"
                            >
                              Batal
                            </button>
                          </div>
                        </div>
                      ) : (
                        <div className="flex flex-col items-center gap-1">
                          <span className="text-[10px] font-extrabold text-slate-500 uppercase">No. Telepon</span>
                          <div className="flex items-center gap-1">
                            <span className="text-sm font-bold text-slate-700">
                              {localEkuivalensi.noTelepon || '-'}
                            </span>
                            {sisaUbahPhone > 0 && (
                              <button
                                onClick={() => { setNoTelepon(localEkuivalensi.noTelepon || ''); setPhoneEditMode(true) }}
                                className="text-[10px] text-blue-500 hover:text-blue-700 font-bold underline"
                                title="Ubah nomor telepon"
                              >
                                Ubah
                              </button>
                            )}
                          </div>
                          <span className={`text-[10px] font-bold ${sisaUbahPhone <= 0 ? 'text-rose-500' : 'text-amber-500'}`}>
                            {sisaUbahPhone > 0
                              ? `Sisa ${sisaUbahPhone}x perubahan`
                              : `Maksimal ${MAX_PHONE_CHANGE}x perubahan`}
                          </span>
                        </div>
                      )}
                    </>
                  ) : (
                    <span className="text-xs font-bold text-slate-400">-</span>
                  )}
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
                          <input type="file" onChange={handleFileChange} disabled={uploading} className="hidden" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
                        </label>
                      </div>
                    ) : (
                      <label className="px-4 py-2 text-xs font-bold text-white bg-blue-500 hover:bg-blue-600 cursor-pointer transition rounded-md uppercase tracking-wider">
                        {uploading ? 'Uploading...' : 'Upload File'}
                        <input type="file" onChange={handleFileChange} disabled={uploading} className="hidden" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" />
                      </label>
                    )
                  ) : (
                    <div className="flex flex-col items-center gap-2 w-full">
                      <input
                        type="text"
                        value={noTelepon}
                        onChange={(e) => { setNoTelepon(e.target.value); setPhoneError('') }}
                        placeholder="No. Telepon Perwakilan"
                        className="w-full px-3 py-2 text-xs border border-slate-300 rounded-lg text-center font-semibold text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-400"
                      />
                      {phoneError && (
                        <span className="text-xs font-bold text-rose-500">{phoneError}</span>
                      )}
                      <button
                        onClick={handleAjukan}
                        disabled={submitting}
                        className="w-full px-4 py-2 text-xs font-bold text-white bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 transition rounded-md uppercase tracking-wider"
                      >
                        {submitting ? 'Memproses...' : 'Ajukan Ekuivalensi'}
                      </button>
                    </div>
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
              {!ekuivalensi ? 'Belum ada pengajuan ekuivalensi untuk kelas ini.' : namaKelas !== '-' ? 'Semua mahasiswa sudah lunas jam kompen.' : 'Kamu belum terdaftar di kelas manapun.'}
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

      {showConfirmModal && pendingFile && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center p-4 z-50 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl animate-in fade-in zoom-in-95 duration-200">
            <div className="flex items-center space-x-3 text-amber-500 mb-4">
              <div className="bg-amber-100 p-2 rounded-full">
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
              </div>
              <h3 className="text-lg font-bold text-slate-800">
                {localEkuivalensi?.notaUrl ? 'Konfirmasi Ganti File' : 'Konfirmasi Upload'}
              </h3>
            </div>
            
            <p className="text-sm text-slate-600 mb-4 leading-relaxed">
              {localEkuivalensi?.notaUrl 
                ? 'Apakah Anda yakin ingin mengganti bukti ekuivalensi yang sudah ada dengan file baru ini?' 
                : 'Apakah Anda yakin ingin mengupload file ini sebagai bukti pengajuan ekuivalensi?'}
            </p>
            
            <div className="bg-slate-50 border border-slate-200 rounded-xl p-4 mb-6 flex items-start space-x-3">
              <div className="bg-blue-100 text-blue-600 p-2 rounded-lg mt-0.5">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-semibold text-slate-700 truncate">{pendingFile.name}</p>
                <p className="text-xs text-slate-500 font-medium">{formatFileSize(pendingFile.size)}</p>
              </div>
            </div>
            
            <div className="flex items-center justify-end space-x-3">
              <button
                type="button"
                onClick={handleCancelUpload}
                className="px-4 py-2 text-sm font-bold text-slate-500 bg-slate-100 hover:bg-slate-200 transition rounded-xl uppercase tracking-wider"
              >
                Batal
              </button>
              <button
                type="button"
                onClick={handleConfirmUpload}
                className="px-4 py-2 text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 transition rounded-xl shadow-md hover:shadow-lg shadow-blue-500/20 uppercase tracking-wider"
              >
                Ya, Upload
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
