'use client'

import { useState, useTransition, useMemo, useEffect } from 'react'
import {
  Users, Search, PlusCircle, Edit2, Trash2, Shield,
  GraduationCap, Building2, BookOpen, X, AlertTriangle,
  ChevronLeft, ChevronRight, CheckCircle2, Info, Lock
} from 'lucide-react'
import { createUser, updateUser, deleteUser } from './actions'

interface RoleType {
  id: number
  nama: string | null
}

interface JurusanType {
  id: number
  nama_jurusan: string | null
}

interface ProdiType {
  id: number
  nama_prodi: string | null
  jurisdiction_id: number | null
}

interface KelasType {
  id: number
  nama_kelas: string | null
  prodi_id: number | null
}

interface UserRow {
  user_id: number
  email: string | null
  role_id: number | null
  role: { id: number; nama: string | null } | null
  mahasiswa: {
    nim: string
    nama: string | null
    registrasi_mahasiswa: Array<{
      kelas: {
        id: number
        nama_kelas: string | null
        prodi: {
          id: number
          nama_prodi: string | null
          jurisdiction: {
            id: number
            nama_jurusan: string | null
          } | null
        } | null
      } | null
    }>
  } | null
  staf: {
    nip: string
    nama: string | null
    tipe_staf: string | null
    jurisdiction: {
      id: number
      nama_jurusan: string | null
    } | null
  } | null
}

interface UsersManagementClientProps {
  initialUsers: UserRow[]
  roles: RoleType[]
  jurusans: JurusanType[]
  prodis: ProdiType[]
  kelases: KelasType[]
}

export default function UsersManagementClient({
  initialUsers,
  roles,
  jurusans,
  prodis,
  kelases
}: UsersManagementClientProps) {
  const [users, setUsers] = useState<UserRow[]>(initialUsers)
  
  // Real-time filtering states
  const [searchTerm, setSearchTerm] = useState('')
  const [filterRole, setFilterRole] = useState('All')
  const [filterJurusan, setFilterJurusan] = useState('All')
  const [filterProdi, setFilterProdi] = useState('All')
  
  // Pagination states
  const [currentPage, setCurrentPage] = useState(1)
  const [rowsPerPage, setRowsPerPage] = useState(10)

  // Transition & Notification states
  const [isPending, startTransition] = useTransition()
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error'; text: string } | null>(null)

  // Modal control states
  const [isCrudModalOpen, setIsCrudModalOpen] = useState(false)
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false)
  
  // Active selected User for editing or deletion
  const [selectedUser, setSelectedUser] = useState<UserRow | null>(null)

  // Form states for Create/Edit Modal
  const [formRole, setFormRole] = useState<number>(roles[0]?.id || 1)
  const [formEmail, setFormEmail] = useState('')
  const [formPassword, setFormPassword] = useState('')
  const [formNama, setFormNama] = useState('')
  const [formNimOrNip, setFormNimOrNip] = useState('')
  const [formJurusan, setFormJurusan] = useState<number | ''>('')
  const [formProdi, setFormProdi] = useState<number | ''>('')
  const [formKelas, setFormKelas] = useState<number | ''>('')

  // Determine current form role name to toggle inputs
  const currentFormRoleName = useMemo(() => {
    const selected = roles.find(r => r.id === formRole)
    return selected?.nama?.toLowerCase() || ''
  }, [formRole, roles])

  // Reset form states
  const resetForm = () => {
    setFormRole(roles[0]?.id || 1)
    setFormEmail('')
    setFormPassword('')
    setFormNama('')
    setFormNimOrNip('')
    setFormJurusan('')
    setFormProdi('')
    setFormKelas('')
    setSelectedUser(null)
  }

  // Populate form with existing user data for Editing
  const handleOpenEdit = (user: UserRow) => {
    resetForm()
    setSelectedUser(user)
    setFormRole(user.role_id || roles[0]?.id || 1)
    setFormEmail(user.email || '')
    setFormPassword('') // Do not expose password hash
    
    if (user.mahasiswa) {
      setFormNama(user.mahasiswa.nama || '')
      setFormNimOrNip(user.mahasiswa.nim || '')
      const activeReg = user.mahasiswa.registrasi_mahasiswa?.[0]
      if (activeReg?.kelas) {
        setFormKelas(activeReg.kelas.id)
        if (activeReg.kelas.prodi) {
          setFormProdi(activeReg.kelas.prodi.id)
          if (activeReg.kelas.prodi.jurisdiction) {
            setFormJurusan(activeReg.kelas.prodi.jurisdiction.id)
          }
        }
      }
    } else if (user.staf) {
      setFormNama(user.staf.nama || '')
      setFormNimOrNip(user.staf.nip || '')
      if (user.staf.jurisdiction) {
        setFormJurusan(user.staf.jurisdiction.id)
      }
    } else {
      setFormNama('Super Admin')
    }
    
    setIsCrudModalOpen(true)
  }

  const handleOpenCreate = () => {
    resetForm()
    setIsCrudModalOpen(true)
  }

  const handleOpenDelete = (user: UserRow) => {
    setSelectedUser(user)
    setIsDeleteModalOpen(true)
  }

  // Submit form handler
  const handleFormSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setFeedback(null)

    const payload = {
      email: formEmail,
      kataSandi: formPassword,
      roleId: formRole,
      nama: formNama,
      nimOrNip: formNimOrNip || undefined,
      jurusanId: formJurusan !== '' ? Number(formJurusan) : undefined,
      prodiId: formProdi !== '' ? Number(formProdi) : undefined,
      kelasId: formKelas !== '' ? Number(formKelas) : undefined
    }

    startTransition(async () => {
      let result
      if (selectedUser) {
        // Edit Action
        result = await updateUser({
          userId: selectedUser.user_id,
          ...payload
        })
      } else {
        // Create Action
        if (!formPassword) {
          setFeedback({ type: 'error', text: 'Kata Sandi wajib diisi untuk user baru!' })
          return
        }
        result = await createUser(payload)
      }

      if (result.success) {
        setFeedback({ type: 'success', text: result.message || 'Proses sukses!' })
        setIsCrudModalOpen(false)
        resetForm()
        
        // Dynamic re-fetch simulation or state updates from API
        // For real-time updates without fully refreshing page, we reload
        window.location.reload()
      } else {
        setFeedback({ type: 'error', text: result.error || 'Terjadi kesalahan' })
      }
    })
  }

  // Delete handler
  const handleDeleteConfirm = async () => {
    if (!selectedUser) return
    setFeedback(null)

    startTransition(async () => {
      const result = await deleteUser(selectedUser.user_id)
      setIsDeleteModalOpen(false)
      
      if (result.success) {
        setFeedback({ type: 'success', text: result.message || 'User berhasil dihapus' })
        setUsers(prev => prev.filter(u => u.user_id !== selectedUser.user_id))
        setSelectedUser(null)
      } else {
        setFeedback({ type: 'error', text: result.error || 'Terjadi kesalahan' })
      }
    })
  }

  // Filter prodi dynamically based on selected Jurusan in form
  const filteredFormProdis = useMemo(() => {
    if (!formJurusan) return prodis
    return prodis.filter(p => p.jurisdiction_id === Number(formJurusan))
  }, [formJurusan, prodis])

  // Filter kelases dynamically based on selected Prodi in form
  const filteredFormKelases = useMemo(() => {
    if (!formProdi) return kelases
    return kelases.filter(k => k.prodi_id === Number(formProdi))
  }, [formProdi, kelases])

  // ────────────────────────────────────────────────────────
  // DATA FILTERING LOGIC
  // ────────────────────────────────────────────────────────
  const filteredUsers = useMemo(() => {
    return users.filter(user => {
      // 1. Search Query Match
      const name = user.mahasiswa?.nama || user.staf?.nama || 'Superadmin'
      const email = user.email || ''
      const identifier = user.mahasiswa?.nim || user.staf?.nip || ''
      
      const matchesSearch = 
        name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        email.toLowerCase().includes(searchTerm.toLowerCase()) ||
        identifier.toLowerCase().includes(searchTerm.toLowerCase())

      // 2. Role Filter Match
      const matchesRole = 
        filterRole === 'All' || 
        user.role?.nama?.toLowerCase() === filterRole.toLowerCase()

      // 3. Jurusan Filter Match
      let userJurusanId = 'None'
      if (user.staf?.jurisdiction) {
        userJurusanId = String(user.staf.jurisdiction.id)
      } else if (user.mahasiswa?.registrasi_mahasiswa?.[0]?.kelas?.prodi?.jurisdiction) {
        userJurusanId = String(user.mahasiswa.registrasi_mahasiswa[0].kelas.prodi.jurisdiction.id)
      }

      const matchesJurusan = 
        filterJurusan === 'All' || 
        userJurusanId === filterJurusan

      // 4. Prodi Filter Match
      let userProdiId = 'None'
      if (user.mahasiswa?.registrasi_mahasiswa?.[0]?.kelas?.prodi) {
        userProdiId = String(user.mahasiswa.registrasi_mahasiswa[0].kelas.prodi.id)
      }

      const matchesProdi = 
        filterProdi === 'All' || 
        userProdiId === filterProdi

      return matchesSearch && matchesRole && matchesJurusan && matchesProdi
    })
  }, [users, searchTerm, filterRole, filterJurusan, filterProdi])

  // ────────────────────────────────────────────────────────
  // PAGINATION LOGIC
  // ────────────────────────────────────────────────────────
  const paginatedUsers = useMemo(() => {
    const start = (currentPage - 1) * rowsPerPage
    return filteredUsers.slice(start, start + rowsPerPage)
  }, [filteredUsers, currentPage, rowsPerPage])

  const totalPages = Math.ceil(filteredUsers.length / rowsPerPage)

  const handlePageChange = (page: number) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page)
    }
  }

  // Reset pagination to page 1 when search or filters change
  useEffect(() => {
    setCurrentPage(1)
  }, [searchTerm, filterRole, filterJurusan, filterProdi])

  return (
    <div className="w-full flex flex-col min-h-screen bg-slate-50/50 font-sans text-slate-800 pb-12 animate-in fade-in duration-300">
      
      {/* HEADER SECTION */}
      <div className="px-6 md:px-10 py-8 bg-white border-b border-slate-100 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="text-left">
          <h1 className="text-2xl font-black text-slate-900 tracking-tight">Manajemen User</h1>
          <p className="text-slate-400 text-xs font-bold uppercase tracking-wider mt-1">Kelola Akun, Autentikasi, dan Struktur Perguruan Tinggi</p>
        </div>
        
        <button
          onClick={handleOpenCreate}
          className="bg-[#2e5299] hover:bg-[#1e3d73] text-white px-5 py-3 rounded-2xl shadow-md hover:shadow-lg transition-all duration-300 font-bold text-xs uppercase tracking-wider flex items-center gap-2 self-start sm:self-center active:scale-95"
        >
          <PlusCircle size={16} /> Tambah User Baru
        </button>
      </div>

      <div className="px-6 md:px-10 mt-8 space-y-6">
        
        {/* FEEDBACK BANNER */}
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

        {/* SEARCH AND INTERACTIVE MULTI-FILTERS BAR */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex flex-col gap-4">
          <div className="flex items-center gap-3">
            <span className="bg-[#2e5299]/10 text-[#2e5299] text-[10px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full flex items-center gap-1">
              <Users size={10} /> Panel Filter
            </span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            
            {/* Search Input bar */}
            <div className="relative group">
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Cari nama, email, NIM/NIP..."
                className="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs outline-none focus:border-[#2e5299] focus:bg-white transition-all placeholder:text-slate-400 font-semibold"
              />
              <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-[#2e5299] transition-colors" />
            </div>

            {/* Filter by Role */}
            <div>
              <select
                value={filterRole}
                onChange={(e) => setFilterRole(e.target.value)}
                className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs font-bold text-slate-700 outline-none focus:border-[#2e5299] transition-all"
              >
                <option value="All">Semua Role</option>
                {roles.map(r => (
                  <option key={r.id} value={r.nama || ''}>
                    {r.nama === 'mahasiswa' ? 'Mahasiswa' : r.nama === 'admin' ? 'Admin (Staf)' : r.nama || ''}
                  </option>
                ))}
              </select>
            </div>

            {/* Filter by Jurusan */}
            <div>
              <select
                value={filterJurusan}
                onChange={(e) => setFilterJurusan(e.target.value)}
                className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs font-bold text-slate-700 outline-none focus:border-[#2e5299] transition-all"
              >
                <option value="All">Semua Jurusan</option>
                {jurusans.map(j => (
                  <option key={j.id} value={String(j.id)}>{j.nama_jurusan}</option>
                ))}
              </select>
            </div>

            {/* Filter by Prodi */}
            <div>
              <select
                value={filterProdi}
                onChange={(e) => setFilterProdi(e.target.value)}
                className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs font-bold text-slate-700 outline-none focus:border-[#2e5299] transition-all"
              >
                <option value="All">Semua Prodi</option>
                {prodis.map(p => (
                  <option key={p.id} value={String(p.id)}>{p.nama_prodi}</option>
                ))}
              </select>
            </div>

          </div>
        </div>

        {/* USER LIST DATA TABLE CARD */}
        <div className="bg-white rounded-[2rem] border border-slate-100 shadow-sm overflow-hidden flex flex-col">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-black uppercase tracking-wider">
                  <th className="py-5 px-6 text-center">No.</th>
                  <th className="py-5 px-8">Nama & Akun Email</th>
                  <th className="py-5 px-6">Identitas (NIM/NIP)</th>
                  <th className="py-5 px-6 text-center">Role Badge</th>
                  <th className="py-5 px-6">Jurusan & Program Studi</th>
                  <th className="py-5 px-8 text-right">Aksi</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {paginatedUsers.length > 0 ? (
                  paginatedUsers.map((user, idx) => {
                    const isMhs = user.mahasiswa != null
                    const isStaf = user.staf != null
                    
                    const name = user.mahasiswa?.nama || user.staf?.nama || 'Superadmin'
                    const identifier = user.mahasiswa?.nim || user.staf?.nip || '-'
                    const roleLabel = user.role?.nama?.toLowerCase() === 'mahasiswa' 
                      ? 'Mahasiswa' 
                      : user.role?.nama?.toLowerCase() === 'admin' 
                        ? 'Admin' 
                        : user.role?.nama || '-'

                    let academicUnit = 'Superadmin'
                    if (isMhs) {
                      const activeReg = user.mahasiswa?.registrasi_mahasiswa?.[0]
                      if (activeReg?.kelas?.prodi) {
                        academicUnit = `${activeReg.kelas.prodi.nama_prodi} (${activeReg.kelas.nama_kelas})`
                      } else {
                        academicUnit = 'Belum Registrasi Kelas'
                      }
                    } else if (isStaf) {
                      academicUnit = user.staf?.jurisdiction?.nama_jurusan || 'Non-Akademik'
                    }

                    const itemNumber = (currentPage - 1) * rowsPerPage + idx + 1

                    return (
                      <tr key={user.user_id} className="hover:bg-slate-50/30 transition-colors">
                        {/* Row Number */}
                        <td className="py-5 px-6 text-center font-bold text-xs text-slate-400">
                          {itemNumber}
                        </td>

                        {/* Name & Email Profile Details */}
                        <td className="py-5 px-8">
                          <div className="flex items-center gap-3">
                            <div className={`w-10 h-10 rounded-xl flex items-center justify-center font-black text-sm shrink-0 ${
                              isMhs 
                                ? 'bg-blue-50 text-[#2e5299]' 
                                : isStaf 
                                  ? 'bg-purple-50 text-purple-700' 
                                  : 'bg-amber-50 text-amber-700'
                            }`}>
                              {name.substring(0, 2).toUpperCase()}
                            </div>
                            <div className="text-left">
                              <p className="font-bold text-sm text-slate-800 tracking-tight">{name}</p>
                              <p className="text-slate-400 text-xs font-semibold mt-0.5">{user.email}</p>
                            </div>
                          </div>
                        </td>

                        {/* NIM/NIP Identifier */}
                        <td className="py-5 px-6">
                          <span className="font-bold text-xs font-mono text-slate-600 bg-slate-100 px-2.5 py-1 rounded-lg">
                            {identifier}
                          </span>
                        </td>

                        {/* Role Badge */}
                        <td className="py-5 px-6 text-center">
                          <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider ${
                            isMhs 
                              ? 'bg-blue-50 text-[#2e5299] border border-blue-100' 
                              : isStaf 
                                ? 'bg-purple-50 text-purple-700 border border-purple-100' 
                                : 'bg-amber-50 text-amber-700 border border-amber-100'
                          }`}>
                            {isMhs ? <GraduationCap size={12}/> : isStaf ? <Building2 size={12}/> : <Shield size={12}/>}
                            {roleLabel}
                          </span>
                        </td>

                        {/* Academic Unit Location */}
                        <td className="py-5 px-6">
                          <div className="flex items-center gap-2 text-slate-600 font-semibold text-xs">
                            {isMhs ? <BookOpen size={14} className="text-blue-400 shrink-0"/> : isStaf ? <Building2 size={14} className="text-purple-400 shrink-0"/> : <Shield size={14} className="text-amber-400 shrink-0"/>}
                            <span className="truncate max-w-[200px]">{academicUnit}</span>
                          </div>
                        </td>

                        {/* Action buttons */}
                        <td className="py-5 px-8 text-right">
                          <div className="flex justify-end gap-2">
                            <button
                              onClick={() => handleOpenEdit(user)}
                              className="p-2 bg-slate-50 hover:bg-[#2e5299]/10 text-slate-400 hover:text-[#2e5299] rounded-xl transition-all"
                              title="Edit User"
                            >
                              <Edit2 size={14} />
                            </button>
                            
                            {/* Prevent deleting oneself */}
                            <button
                              onClick={() => handleOpenDelete(user)}
                              className="p-2 bg-slate-50 hover:bg-rose-50 text-slate-400 hover:text-rose-600 rounded-xl transition-all"
                              title="Hapus User"
                            >
                              <Trash2 size={14} />
                            </button>
                          </div>
                        </td>

                      </tr>
                    )
                  })
                ) : (
                  <tr>
                    <td colSpan={6} className="py-16 text-center text-slate-400 text-sm font-semibold">
                      Tidak ada user yang cocok dengan kriteria pencarian atau filter.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* TABLE FOOTER & SMOOTH PAGINATION */}
          {totalPages > 1 && (
            <div className="px-8 py-5 border-t border-slate-50 bg-slate-50/30 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <p className="text-xs font-bold text-slate-400">
                Menampilkan <span className="text-slate-700">{Math.min(filteredUsers.length, (currentPage - 1) * rowsPerPage + 1)}</span> sampai <span className="text-slate-700">{Math.min(filteredUsers.length, currentPage * rowsPerPage)}</span> dari <span className="text-slate-700">{filteredUsers.length}</span> data user
              </p>
              
              <div className="flex items-center gap-1.5 self-center sm:self-auto">
                <button
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
                  className="p-2 border border-slate-200 rounded-xl bg-white text-slate-500 hover:bg-slate-50 hover:text-slate-800 disabled:opacity-50 disabled:hover:bg-white disabled:hover:text-slate-500 transition-all"
                >
                  <ChevronLeft size={16} />
                </button>
                
                {Array.from({ length: totalPages }, (_, idx) => idx + 1).map(page => (
                  <button
                    key={page}
                    onClick={() => handlePageChange(page)}
                    className={`px-3.5 py-1.5 text-xs font-bold rounded-xl transition-all ${
                      currentPage === page
                        ? 'bg-[#2e5299] text-white shadow-sm'
                        : 'border border-slate-200 bg-white text-slate-600 hover:bg-slate-50'
                    }`}
                  >
                    {page}
                  </button>
                ))}

                <button
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPages}
                  className="p-2 border border-slate-200 rounded-xl bg-white text-slate-500 hover:bg-slate-50 hover:text-slate-800 disabled:opacity-50 disabled:hover:bg-white disabled:hover:text-slate-500 transition-all"
                >
                  <ChevronRight size={16} />
                </button>
              </div>
            </div>
          )}

        </div>

      </div>

      {/* ────────────────────────────────────────────────────────
          CREATE / EDIT DIALOG (RICH MODAL OVERLAY)
          ──────────────────────────────────────────────────────── */}
      {isCrudModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-300">
          <div className="bg-white w-full max-w-lg rounded-[2rem] border border-slate-100 shadow-2xl overflow-hidden flex flex-col animate-in scale-in duration-300 text-left">
            
            {/* Modal Header */}
            <div className="px-8 py-6 bg-slate-50 border-b border-slate-100 flex items-center justify-between">
              <div>
                <h3 className="text-base font-black text-slate-900">
                  {selectedUser ? 'Edit Detail User' : 'Tambah User Baru'}
                </h3>
                <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wider mt-0.5">
                  {selectedUser ? 'Perbarui informasi dan kredensial akses' : 'Daftarkan pengguna baru ke sistem kompensasi'}
                </p>
              </div>
              <button
                onClick={() => setIsCrudModalOpen(false)}
                className="p-2 hover:bg-slate-200/60 text-slate-400 hover:text-slate-700 rounded-xl transition-all"
              >
                <X size={18} />
              </button>
            </div>

            {/* Modal Body Form */}
            <form onSubmit={handleFormSubmit} className="p-8 space-y-4 overflow-y-auto max-h-[500px]">
              
              {/* Field: Role */}
              <div>
                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Role Pengguna</label>
                <select
                  value={formRole}
                  onChange={(e) => setFormRole(Number(e.target.value))}
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-bold text-slate-700 focus:border-[#2e5299] focus:bg-white outline-none transition-all"
                >
                  {roles.map(r => (
                    <option key={r.id} value={r.id}>
                      {r.nama === 'mahasiswa' ? 'Mahasiswa' : r.nama === 'admin' ? 'Admin / Dosen (Staf)' : r.nama || ''}
                    </option>
                  ))}
                </select>
              </div>

              {/* Field: Full Name */}
              <div>
                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Nama Lengkap</label>
                <input
                  type="text"
                  required
                  placeholder="contoh: Akbar Rama"
                  value={formNama}
                  onChange={(e) => setFormNama(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                />
              </div>

              {/* Field: Email */}
              <div>
                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Alamat Email</label>
                <input
                  type="email"
                  required
                  placeholder="contoh: email@polnes.ac.id"
                  value={formEmail}
                  onChange={(e) => setFormEmail(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                />
              </div>

              {/* Field: Password */}
              <div>
                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 flex items-center justify-between">
                  <span>Kata Sandi (Password)</span>
                  {selectedUser && (
                    <span className="text-[9px] text-[#2e5299] font-black uppercase tracking-widest flex items-center gap-0.5"><Lock size={8}/>Biarkan kosong jika tidak diganti</span>
                  )}
                </label>
                <input
                  type="password"
                  placeholder={selectedUser ? '••••••••' : 'Masukkan password baru'}
                  required={!selectedUser}
                  value={formPassword}
                  onChange={(e) => setFormPassword(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                />
              </div>

              {/* ROLE SPECIFIC: MAHASISWA FIELDS */}
              {currentFormRoleName === 'mahasiswa' && (
                <div className="space-y-4 pt-2 border-t border-slate-100 animate-in fade-in duration-300">
                  
                  {/* NIM */}
                  <div>
                    <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">NIM (Nomor Induk Mahasiswa)</label>
                    <input
                      type="text"
                      required
                      placeholder="contoh: 3372005"
                      value={formNimOrNip}
                      onChange={(e) => setFormNimOrNip(e.target.value)}
                      className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                    />
                  </div>

                  {/* Jurusan & Prodi & Kelas Row grid */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Jurusan</label>
                      <select
                        value={formJurusan}
                        onChange={(e) => {
                          setFormJurusan(e.target.value !== '' ? Number(e.target.value) : '')
                          setFormProdi('')
                          setFormKelas('')
                        }}
                        className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-2.5 text-xs font-bold text-slate-700 outline-none"
                      >
                        <option value="">Pilih Jurusan</option>
                        {jurusans.map(j => (
                          <option key={j.id} value={j.id}>{j.nama_jurusan}</option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Prodi</label>
                      <select
                        value={formProdi}
                        disabled={!formJurusan}
                        onChange={(e) => {
                          setFormProdi(e.target.value !== '' ? Number(e.target.value) : '')
                          setFormKelas('')
                        }}
                        className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-2.5 text-xs font-bold text-slate-700 outline-none disabled:opacity-50"
                      >
                        <option value="">Pilih Prodi</option>
                        {filteredFormProdis.map(p => (
                          <option key={p.id} value={p.id}>{p.nama_prodi}</option>
                        ))}
                      </select>
                    </div>
                  </div>

                  {/* Kelas Select */}
                  <div>
                    <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Kelas</label>
                    <select
                      value={formKelas}
                      disabled={!formProdi}
                      onChange={(e) => setFormKelas(e.target.value !== '' ? Number(e.target.value) : '')}
                      className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-2.5 text-xs font-bold text-slate-700 outline-none disabled:opacity-50"
                    >
                      <option value="">Pilih Kelas</option>
                      {filteredFormKelases.map(k => (
                        <option key={k.id} value={k.id}>{k.nama_kelas}</option>
                      ))}
                    </select>
                  </div>

                </div>
              )}

              {/* ROLE SPECIFIC: STAF/ADMIN FIELDS */}
              {(currentFormRoleName === 'admin' || currentFormRoleName === 'staf') && (
                <div className="space-y-4 pt-2 border-t border-slate-100 animate-in fade-in duration-300">
                  
                  {/* NIP */}
                  <div>
                    <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">NIP (Nomor Induk Pegawai)</label>
                    <input
                      type="text"
                      required
                      placeholder="contoh: 197801012005011002"
                      value={formNimOrNip}
                      onChange={(e) => setFormNimOrNip(e.target.value)}
                      className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                    />
                  </div>

                  {/* Jurusan */}
                  <div>
                    <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Jurusan Dinas</label>
                    <select
                      value={formJurusan}
                      onChange={(e) => setFormJurusan(e.target.value !== '' ? Number(e.target.value) : '')}
                      className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-bold text-slate-700 outline-none"
                    >
                      <option value="">Pilih Jurusan</option>
                      {jurusans.map(j => (
                        <option key={j.id} value={j.id}>{j.nama_jurusan}</option>
                      ))}
                    </select>
                  </div>

                </div>
              )}

              {/* Form Buttons */}
              <div className="pt-6 border-t border-slate-100 flex items-center justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setIsCrudModalOpen(false)}
                  className="px-5 py-3 border border-slate-200 hover:bg-slate-50 rounded-2xl text-xs font-black uppercase tracking-wider text-slate-500 transition-all active:scale-95"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  disabled={isPending}
                  className="px-6 py-3 bg-[#2e5299] hover:bg-[#1e3d73] text-white rounded-2xl text-xs font-black uppercase tracking-wider shadow-md hover:shadow-lg transition-all active:scale-95 disabled:opacity-50"
                >
                  {isPending ? 'Memproses...' : selectedUser ? 'Perbarui Data' : 'Simpan User'}
                </button>
              </div>

            </form>

          </div>
        </div>
      )}

      {/* ────────────────────────────────────────────────────────
          DELETE WARNING CONFIRMATION MODAL OVERLAY
          ──────────────────────────────────────────────────────── */}
      {isDeleteModalOpen && selectedUser && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-300">
          <div className="bg-white w-full max-w-md rounded-[2.5rem] border border-slate-100 shadow-2xl p-8 text-center animate-in scale-in duration-300">
            <div className="w-16 h-16 bg-rose-50 text-rose-600 rounded-3xl flex items-center justify-center mx-auto mb-6">
              <AlertTriangle size={32} />
            </div>
            
            <h3 className="text-lg font-black text-slate-900 tracking-tight">Hapus User Secara Permanen?</h3>
            <p className="text-slate-400 text-xs font-semibold mt-2 px-4 leading-relaxed">
              Tindakan ini berbahaya dan akan menghapus kredensial login <span className="text-slate-800 font-bold">{(selectedUser.mahasiswa?.nama || selectedUser.staf?.nama || 'Superadmin')}</span>.
            </p>

            {/* Warnings Alert */}
            <div className="mt-4 p-4 bg-rose-50/50 border border-rose-100 rounded-2xl text-rose-800 text-left flex items-start gap-3">
              <Info size={18} className="shrink-0 text-rose-600 mt-0.5" />
              <div className="text-[11px] font-bold leading-relaxed">
                Menghapus user akan menghapus data profil terkait (Mahasiswa / Staf NIP) beserta data kompensasi aktif, log pemotongan jam, dan pengerjaan tugas secara kaskade (cascaded).
              </div>
            </div>

            <div className="mt-8 flex items-center justify-center gap-3">
              <button
                onClick={() => setIsDeleteModalOpen(false)}
                className="flex-1 py-3.5 border border-slate-200 hover:bg-slate-50 rounded-2xl text-xs font-black uppercase tracking-wider text-slate-500 transition-all active:scale-95"
              >
                Batal
              </button>
              <button
                onClick={handleDeleteConfirm}
                disabled={isPending}
                className="flex-1 py-3.5 bg-rose-600 hover:bg-rose-700 text-white rounded-2xl text-xs font-black uppercase tracking-wider shadow-md hover:shadow-lg transition-all active:scale-95 disabled:opacity-50"
              >
                {isPending ? 'Menghapus...' : 'Ya, Hapus'}
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  )
}
