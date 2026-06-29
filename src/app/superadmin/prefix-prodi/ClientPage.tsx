'use client'

import { useState, useTransition } from 'react'
import { PlusCircle, Trash2, Loader2, X, AlertTriangle, CheckCircle2, BookOpen } from 'lucide-react'
import { saveMapping } from './actions'

interface ClientPageProps {
  initialMapping: Record<string, string>
  prodiList: { id: number; nama_prodi: string | null }[]
}

export default function PrefixProdiClientPage({ initialMapping, prodiList }: ClientPageProps) {
  const [items, setItems] = useState<{ prefix: string; prodiKeyword: string }[]>(
    () => Object.entries(initialMapping).map(([prefix, prodiKeyword]) => ({ prefix, prodiKeyword }))
  )
  const [isPending, startTransition] = useTransition()
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error'; text: string } | null>(null)

  const [newPrefix, setNewPrefix] = useState('')
  const [newProdiKeyword, setNewProdiKeyword] = useState('')

  const persist = (updatedItems: { prefix: string; prodiKeyword: string }[]) => {
    const mapping: Record<string, string> = {}
    for (const item of updatedItems) {
      mapping[item.prefix] = item.prodiKeyword
    }

    startTransition(async () => {
      const result = await saveMapping(mapping)
      if (result.success) {
        setFeedback({ type: 'success', text: result.message || '' })
      } else {
        setFeedback({ type: 'error', text: result.error || 'Gagal menyimpan' })
      }
    })
  }

  const addItem = () => {
    const prefix = newPrefix.trim().toUpperCase()
    const keyword = newProdiKeyword.trim()
    if (!prefix || !keyword) return
    if (items.some(i => i.prefix === prefix)) {
      setFeedback({ type: 'error', text: `Prefix "${prefix}" sudah ada!` })
      return
    }

    const updated = [...items, { prefix, prodiKeyword: keyword }]
    setItems(updated)
    setNewPrefix('')
    setNewProdiKeyword('')
    setFeedback(null)
    persist(updated)
  }

  const removeItem = (prefix: string) => {
    const updated = items.filter(i => i.prefix !== prefix)
    setItems(updated)
    setFeedback(null)
    persist(updated)
  }

  const selectProdiKeyword = (prodiNama: string | null) => {
    if (prodiNama) setNewProdiKeyword(prodiNama)
  }

  return (
    <div className="w-full flex flex-col min-h-screen bg-slate-50/50 font-sans text-slate-800 pb-12 animate-in fade-in duration-300">
      {/* HEADER */}
      <div className="px-6 md:px-10 py-8 bg-white border-b border-slate-100 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="text-left">
          <h1 className="text-2xl font-black text-slate-900 tracking-tight">Mapping Prefix Prodi</h1>
          <p className="text-slate-400 text-xs font-bold uppercase tracking-wider mt-1">
            Konfigurasi prefix kelas → prodi untuk import Excel
          </p>
        </div>

        {isPending && (
          <div className="flex items-center gap-2 text-[#2e5299] text-xs font-bold">
            <Loader2 size={14} className="animate-spin" />
            Menyimpan...
          </div>
        )}
      </div>

      <div className="px-6 md:px-10 mt-8 space-y-6">
        {/* FEEDBACK */}
        {feedback && (
          <div className={`p-4 rounded-2xl flex items-center justify-between border shadow-sm animate-in slide-in-from-top duration-300 ${
            feedback.type === 'success'
              ? 'bg-emerald-50 border-emerald-100 text-emerald-800'
              : 'bg-rose-50 border-rose-100 text-rose-800'
          }`}>
            <div className="flex items-center gap-3">
              {feedback.type === 'success' ? (
                <CheckCircle2 size={20} className="text-emerald-500 shrink-0" />
              ) : (
                <AlertTriangle size={20} className="text-rose-500 shrink-0" />
              )}
              <span className="text-sm font-semibold">{feedback.text}</span>
            </div>
            <button onClick={() => setFeedback(null)} className="text-slate-400 hover:text-slate-600">
              <X size={16} />
            </button>
          </div>
        )}

        {/* INFO CARD */}
        <div className="p-4 bg-blue-50 border border-blue-100 rounded-2xl flex items-start gap-3">
          <BookOpen size={18} className="shrink-0 text-blue-600 mt-0.5" />
          <p className="text-xs font-semibold text-blue-800 leading-relaxed">
            Prefix diambil dari 2 huruf pertama nama kelas (misal: <span className="font-bold">IK</span>-1A &rarr; prefix &quot;IK&quot;).
            <br />
            <span className="font-bold">Prodi Keyword</span> digunakan untuk mencari prodi yang cocok (misal: &quot;Teknik Informatika&quot; akan match ke &quot;D4 Teknik Informatika&quot;).
            <br />
            Perubahan langsung tersimpan ke database secara otomatis.
          </p>
        </div>

        {/* ADD NEW MAPPING */}
        <div className="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
          <div className="px-8 py-5 border-b border-slate-100">
            <h3 className="text-sm font-black text-slate-800">Tambah Mapping Baru</h3>
          </div>
          <div className="px-8 py-5 flex flex-col sm:flex-row items-start sm:items-end gap-4">
            <div className="w-full sm:w-40">
              <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Prefix</label>
              <input
                type="text"
                value={newPrefix}
                onChange={(e) => setNewPrefix(e.target.value.toUpperCase())}
                placeholder="contoh: MI"
                maxLength={5}
                className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-bold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300 uppercase"
              />
            </div>
            <div className="w-full sm:flex-1">
              <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Prodi Keyword</label>
              <div className="flex gap-2">
                <input
                  type="text"
                  value={newProdiKeyword}
                  onChange={(e) => setNewProdiKeyword(e.target.value)}
                  placeholder="contoh: Manajemen Informatika"
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                />
              </div>
              {prodiList.length > 0 && (
                <div className="mt-2 flex flex-wrap gap-1.5">
                  {prodiList.map(p => (
                    <button
                      key={p.id}
                      type="button"
                      onClick={() => selectProdiKeyword(p.nama_prodi)}
                      className={`px-2.5 py-1 rounded-lg text-[10px] font-bold uppercase tracking-wider transition-all ${
                        newProdiKeyword === p.nama_prodi
                          ? 'bg-[#2e5299] text-white'
                          : 'bg-slate-100 text-slate-500 hover:bg-slate-200'
                      }`}
                    >
                      {p.nama_prodi}
                    </button>
                  ))}
                </div>
              )}
            </div>
            <button
              onClick={addItem}
              disabled={!newPrefix.trim() || !newProdiKeyword.trim() || isPending}
              className="bg-emerald-600 hover:bg-emerald-700 text-white px-5 py-3 rounded-2xl text-xs font-black uppercase tracking-wider flex items-center gap-2 transition-all active:scale-95 disabled:opacity-40 shrink-0"
            >
              {isPending ? <Loader2 size={14} className="animate-spin" /> : <PlusCircle size={14} />}
              Tambah
            </button>
          </div>
        </div>

        {/* MAPPING TABLE */}
        <div className="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-black uppercase tracking-wider">
                  <th className="py-4 px-6 w-12">No.</th>
                  <th className="py-4 px-6">Prefix</th>
                  <th className="py-4 px-6">Prodi Keyword</th>
                  <th className="py-4 px-6 text-right w-24">Aksi</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {items.length > 0 ? (
                  items.map((item, idx) => (
                    <tr key={item.prefix} className="hover:bg-slate-50/30 transition-colors">
                      <td className="py-4 px-6 text-center font-bold text-xs text-slate-400">{idx + 1}</td>
                      <td className="py-4 px-6">
                        <span className="font-mono text-sm font-bold text-slate-800 bg-slate-100 px-2.5 py-1 rounded-lg">
                          {item.prefix}
                        </span>
                      </td>
                      <td className="py-4 px-6">
                        <span className="text-sm font-semibold text-slate-700">{item.prodiKeyword}</span>
                      </td>
                      <td className="py-4 px-6 text-right">
                        <button
                          onClick={() => removeItem(item.prefix)}
                          disabled={isPending}
                          className="p-2 bg-slate-50 hover:bg-rose-50 text-slate-400 hover:text-rose-600 rounded-xl transition-all disabled:opacity-40"
                          title="Hapus"
                        >
                          <Trash2 size={14} />
                        </button>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan={4} className="py-16 text-center text-slate-400 text-sm font-semibold">
                      Belum ada mapping. Tambahkan prefix baru di atas.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
          {items.length > 0 && (
            <div className="px-6 py-3 border-t border-slate-50 bg-slate-50/30 text-right">
              <span className="text-xs font-semibold text-slate-400">
                Total: {items.length} mapping
              </span>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
