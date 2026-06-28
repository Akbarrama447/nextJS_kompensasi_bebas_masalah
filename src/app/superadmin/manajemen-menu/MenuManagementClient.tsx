'use client'

import { useState, useTransition, useMemo, Fragment } from 'react'
import {
  Menu as MenuIcon, Search, PlusCircle, Edit2, Trash2,
  Shield, X, AlertTriangle, CheckCircle2, ChevronRight,
  ChevronDown, Link2, Unlink, Info, Settings
} from 'lucide-react'
import {
  createMenu, updateMenu, deleteMenu,
  assignMenuToRole, removeMenuFromRole
} from './actions'

interface MenuItem {
  id: number
  key: string
  label: string | null
  icon: string | null
  path: string
  urutan: number | null
  parent_id: number | null
  children?: MenuItem[]
}

interface RoleType {
  id: number
  nama: string | null
}

interface RoleMenuMapping {
  roleId: number | null
  menuId: number | null
}

interface MenuManagementClientProps {
  initialMenus: MenuItem[]
  roles: RoleType[]
  roleMenus: RoleMenuMapping[]
}

export default function MenuManagementClient({
  initialMenus,
  roles,
  roleMenus: initialRoleMenus,
}: MenuManagementClientProps) {
  const [menus, setMenus] = useState<MenuItem[]>(initialMenus)
  const [roleMenus, setRoleMenus] = useState<RoleMenuMapping[]>(initialRoleMenus)

  const [searchTerm, setSearchTerm] = useState('')
  const [activeTab, setActiveTab] = useState<'menus' | 'permissions'>('menus')
  const [expandedRows, setExpandedRows] = useState<Set<number>>(new Set())

  const [isPending, startTransition] = useTransition()
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error'; text: string } | null>(null)

  // Modal states
  const [isMenuModalOpen, setIsMenuModalOpen] = useState(false)
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false)
  const [selectedMenu, setSelectedMenu] = useState<MenuItem | null>(null)

  // Form states
  const [formKey, setFormKey] = useState('')
  const [formLabel, setFormLabel] = useState('')
  const [formIcon, setFormIcon] = useState('')
  const [formPath, setFormPath] = useState('')
  const [formUrutan, setFormUrutan] = useState(0)
  const [formParentId, setFormParentId] = useState<number | ''>('')

  const resetForm = () => {
    setFormKey('')
    setFormLabel('')
    setFormIcon('')
    setFormPath('')
    setFormUrutan(0)
    setFormParentId('')
    setSelectedMenu(null)
  }

  const handleOpenCreate = () => {
    resetForm()
    setIsMenuModalOpen(true)
  }

  const handleOpenEdit = (menu: MenuItem) => {
    resetForm()
    setSelectedMenu(menu)
    setFormKey(menu.key)
    setFormLabel(menu.label || '')
    setFormIcon(menu.icon || '')
    setFormPath(menu.path)
    setFormUrutan(menu.urutan ?? 0)
    setFormParentId(menu.parent_id ?? '')
    setIsMenuModalOpen(true)
  }

  const handleOpenDelete = (menu: MenuItem) => {
    setSelectedMenu(menu)
    setIsDeleteModalOpen(true)
  }

  const toggleExpand = (id: number) => {
    setExpandedRows(prev => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  const handleMenuSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setFeedback(null)

    const payload = {
      key: formKey,
      label: formLabel,
      icon: formIcon || undefined,
      path: formPath,
      urutan: formUrutan,
      parentId: formParentId !== '' ? Number(formParentId) : undefined,
    }

    startTransition(async () => {
      let result
      if (selectedMenu) {
        result = await updateMenu({ menuId: selectedMenu.id, ...payload })
      } else {
        result = await createMenu(payload)
      }

      if (result.success) {
        setFeedback({ type: 'success', text: result.message || '' })
        setIsMenuModalOpen(false)
        resetForm()
        window.location.reload()
      } else {
        setFeedback({ type: 'error', text: result.error || 'Terjadi kesalahan' })
      }
    })
  }

  const handleDeleteConfirm = async () => {
    if (!selectedMenu) return
    setFeedback(null)

    startTransition(async () => {
      const result = await deleteMenu(selectedMenu.id)
      setIsDeleteModalOpen(false)

      if (result.success) {
        setFeedback({ type: 'success', text: result.message || '' })
        setMenus(prev => prev.filter(m => m.id !== selectedMenu.id))
        setSelectedMenu(null)
      } else {
        setFeedback({ type: 'error', text: result.error || 'Terjadi kesalahan' })
      }
    })
  }

  const handleTogglePermission = async (roleId: number, menuId: number, currentlyAssigned: boolean) => {
    startTransition(async () => {
      let result
      if (currentlyAssigned) {
        result = await removeMenuFromRole(roleId, menuId)
        if (result.success) {
          setRoleMenus(prev => prev.filter(rm => !(rm.roleId === roleId && rm.menuId === menuId)))
        }
      } else {
        result = await assignMenuToRole(roleId, menuId)
        if (result.success) {
          setRoleMenus(prev => [...prev, { roleId, menuId }])
        }
      }

      if (result.success) {
        setFeedback({ type: 'success', text: result.message || '' })
      } else {
        setFeedback({ type: 'error', text: result.error || 'Terjadi kesalahan' })
      }
    })
  }

  const isAssigned = (roleId: number, menuId: number) => {
    return roleMenus.some(rm => rm.roleId === roleId && rm.menuId === menuId)
  }

  const allMenusFlat = useMemo(() => {
    const flat: MenuItem[] = []
    menus.forEach(m => {
      flat.push(m)
      ;(m.children ?? []).forEach(c => flat.push(c))
    })
    return flat
  }, [menus])

  const filteredMenus = useMemo(() => {
    if (!searchTerm) return menus
    const q = searchTerm.toLowerCase()
    return menus.filter(m =>
      m.label?.toLowerCase().includes(q) ||
      m.key.toLowerCase().includes(q) ||
      m.path.toLowerCase().includes(q) ||
      (m.children ?? []).some(c =>
        c.label?.toLowerCase().includes(q) ||
        c.key.toLowerCase().includes(q) ||
        c.path.toLowerCase().includes(q)
      )
    )
  }, [menus, searchTerm])

  const parentMenus = allMenusFlat.filter(m => !m.parent_id)

  return (
    <div className="w-full flex flex-col min-h-screen bg-slate-50/50 font-sans text-slate-800 pb-12 animate-in fade-in duration-300">

      {/* HEADER */}
      <div className="px-6 md:px-10 py-8 bg-white border-b border-slate-100 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="text-left">
          <h1 className="text-2xl font-black text-slate-900 tracking-tight">Manajemen Menu</h1>
          <p className="text-slate-400 text-xs font-bold uppercase tracking-wider mt-1">Kelola Menu Sidebar dan Hak Akses Role</p>
        </div>

        <button
          onClick={handleOpenCreate}
          className="bg-[#2e5299] hover:bg-[#1e3d73] text-white px-5 py-3 rounded-2xl shadow-md hover:shadow-lg transition-all duration-300 font-bold text-xs uppercase tracking-wider flex items-center gap-2 self-start sm:self-center active:scale-95"
        >
          <PlusCircle size={16} /> Tambah Menu Baru
        </button>
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

        {/* TABS */}
        <div className="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
          <div className="px-8 border-b border-slate-100 flex gap-4">
            <button
              onClick={() => setActiveTab('menus')}
              className={`py-4 text-xs font-black uppercase tracking-wider border-b-2 transition-all flex items-center gap-2 ${
                activeTab === 'menus'
                  ? 'border-[#2e5299] text-[#2e5299]'
                  : 'border-transparent text-slate-400 hover:text-slate-600'
              }`}
            >
              <MenuIcon size={14} /> Daftar Menu
            </button>
            <button
              onClick={() => setActiveTab('permissions')}
              className={`py-4 text-xs font-black uppercase tracking-wider border-b-2 transition-all flex items-center gap-2 ${
                activeTab === 'permissions'
                  ? 'border-[#2e5299] text-[#2e5299]'
                  : 'border-transparent text-slate-400 hover:text-slate-600'
              }`}
            >
              <Shield size={14} /> Hak Akses Role
            </button>
          </div>

          {/* SEARCH BAR */}
          <div className="px-8 py-4 border-b border-slate-50">
            <div className="relative group max-w-sm">
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Cari menu..."
                className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-2xl text-xs outline-none focus:border-[#2e5299] focus:bg-white transition-all placeholder:text-slate-400 font-semibold"
              />
              <Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-[#2e5299] transition-colors" />
            </div>
          </div>

          {/* TAB: DAFTAR MENU */}
          {activeTab === 'menus' && (
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-black uppercase tracking-wider">
                    <th className="py-4 px-6 text-center w-12">No.</th>
                    <th className="py-4 px-6">Label</th>
                    <th className="py-4 px-6">Key</th>
                    <th className="py-4 px-6">Path</th>
                    <th className="py-4 px-6 text-center">Icon</th>
                    <th className="py-4 px-6 text-center">Urutan</th>
                    <th className="py-4 px-6 text-center">Tipe</th>
                    <th className="py-4 px-6 text-right">Aksi</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-50">
                  {filteredMenus.length > 0 ? (
                    filteredMenus.map((menu, idx) => (
                      <Fragment key={menu.id}>
                        {/* Parent row */}
                        <tr className="hover:bg-slate-50/30 transition-colors">
                          <td className="py-4 px-6 text-center font-bold text-xs text-slate-400">{idx + 1}</td>
                          <td className="py-4 px-6">
                            <div className="flex items-center gap-2">
                              {(menu.children?.length ?? 0) > 0 && (
                                <button
                                  onClick={() => toggleExpand(menu.id)}
                                  className="p-1 hover:bg-slate-100 rounded-lg transition-colors"
                                >
                                  {expandedRows.has(menu.id) ? (
                                    <ChevronDown size={14} className="text-slate-400" />
                                  ) : (
                                    <ChevronRight size={14} className="text-slate-400" />
                                  )}
                                </button>
                              )}
                              <span className="font-bold text-sm text-slate-800">{menu.label}</span>
                            </div>
                          </td>
                          <td className="py-4 px-6">
                            <span className="font-mono text-xs text-slate-500 bg-slate-100 px-2 py-0.5 rounded">{menu.key}</span>
                          </td>
                          <td className="py-4 px-6 text-xs font-semibold text-slate-600">{menu.path}</td>
                          <td className="py-4 px-6 text-center text-xs text-slate-500">{menu.icon || '-'}</td>
                          <td className="py-4 px-6 text-center text-xs font-bold text-slate-600">{menu.urutan ?? 0}</td>
                          <td className="py-4 px-6 text-center">
                            <span className="px-2 py-0.5 bg-blue-50 text-blue-700 text-[10px] font-bold rounded-full uppercase">Parent</span>
                          </td>
                          <td className="py-4 px-6 text-right">
                            <div className="flex justify-end gap-2">
                              <button
                                onClick={() => handleOpenEdit(menu)}
                                className="p-2 bg-slate-50 hover:bg-[#2e5299]/10 text-slate-400 hover:text-[#2e5299] rounded-xl transition-all"
                                title="Edit"
                              >
                                <Edit2 size={14} />
                              </button>
                              <button
                                onClick={() => handleOpenDelete(menu)}
                                className="p-2 bg-slate-50 hover:bg-rose-50 text-slate-400 hover:text-rose-600 rounded-xl transition-all"
                                title="Hapus"
                              >
                                <Trash2 size={14} />
                              </button>
                            </div>
                          </td>
                        </tr>

                        {/* Child rows */}
                        {expandedRows.has(menu.id) && (menu.children ?? []).map((child, cIdx) => (
                          <tr key={child.id} className="bg-slate-50/20 hover:bg-slate-50/50 transition-colors">
                            <td className="py-3 px-6 text-center text-xs text-slate-300">{idx + 1}.{cIdx + 1}</td>
                            <td className="py-3 px-6 pl-14">
                              <span className="font-semibold text-sm text-slate-600">{child.label}</span>
                            </td>
                            <td className="py-3 px-6">
                              <span className="font-mono text-xs text-slate-400 bg-slate-100 px-2 py-0.5 rounded">{child.key}</span>
                            </td>
                            <td className="py-3 px-6 text-xs font-semibold text-slate-500">{child.path}</td>
                            <td className="py-3 px-6 text-center text-xs text-slate-400">{child.icon || '-'}</td>
                            <td className="py-3 px-6 text-center text-xs font-bold text-slate-500">{child.urutan ?? 0}</td>
                            <td className="py-3 px-6 text-center">
                              <span className="px-2 py-0.5 bg-purple-50 text-purple-700 text-[10px] font-bold rounded-full uppercase">Child</span>
                            </td>
                            <td className="py-3 px-6 text-right">
                              <div className="flex justify-end gap-2">
                                <button
                                  onClick={() => handleOpenEdit(child)}
                                  className="p-2 bg-slate-50 hover:bg-[#2e5299]/10 text-slate-400 hover:text-[#2e5299] rounded-xl transition-all"
                                  title="Edit"
                                >
                                  <Edit2 size={14} />
                                </button>
                                <button
                                  onClick={() => handleOpenDelete(child)}
                                  className="p-2 bg-slate-50 hover:bg-rose-50 text-slate-400 hover:text-rose-600 rounded-xl transition-all"
                                  title="Hapus"
                                >
                                  <Trash2 size={14} />
                                </button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </Fragment>
                    ))
                  ) : (
                    <tr>
                      <td colSpan={8} className="py-16 text-center text-slate-400 text-sm font-semibold">
                        Tidak ada menu ditemukan.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          )}

          {/* TAB: HAK AKSES ROLE */}
          {activeTab === 'permissions' && (
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-slate-50/50 border-b border-slate-100 text-slate-400 text-[10px] font-black uppercase tracking-wider">
                    <th className="py-4 px-6 min-w-[200px]">Menu</th>
                    {roles.map(role => (
                      <th key={role.id} className="py-4 px-4 text-center min-w-[100px]">
                        <span className="flex items-center justify-center gap-1">
                          <Shield size={10} />
                          {role.nama || `Role ${role.id}`}
                        </span>
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-50">
                  {allMenusFlat.map(menu => (
                    <tr key={menu.id} className="hover:bg-slate-50/30 transition-colors">
                      <td className="py-3 px-6">
                        <div className="flex items-center gap-2">
                          {menu.parent_id && <span className="text-slate-300 ml-4">└</span>}
                          <span className={`font-semibold text-sm ${menu.parent_id ? 'text-slate-500' : 'text-slate-800'}`}>
                            {menu.label}
                          </span>
                          <span className="font-mono text-[10px] text-slate-400 bg-slate-100 px-1.5 py-0.5 rounded">
                            {menu.key}
                          </span>
                        </div>
                      </td>
                      {roles.map(role => {
                        const assigned = isAssigned(role.id, menu.id)
                        return (
                          <td key={role.id} className="py-3 px-4 text-center">
                            <button
                              onClick={() => handleTogglePermission(role.id, menu.id, assigned)}
                              disabled={isPending}
                              className={`w-8 h-8 rounded-xl flex items-center justify-center mx-auto transition-all active:scale-90 ${
                                assigned
                                  ? 'bg-emerald-100 text-emerald-600 hover:bg-rose-100 hover:text-rose-600'
                                  : 'bg-slate-100 text-slate-300 hover:bg-emerald-50 hover:text-emerald-500'
                              }`}
                              title={assigned ? 'Klik untuk cabut akses' : 'Klik untuk beri akses'}
                            >
                              {assigned ? <Link2 size={14} /> : <Unlink size={14} />}
                            </button>
                          </td>
                        )
                      })}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {/* CREATE/EDIT MENU MODAL */}
      {isMenuModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-300">
          <div className="bg-white w-full max-w-lg rounded-[2rem] border border-slate-100 shadow-2xl overflow-hidden flex flex-col animate-in scale-in duration-300 text-left">

            <div className="px-8 py-6 bg-slate-50 border-b border-slate-100 flex items-center justify-between">
              <div>
                <h3 className="text-base font-black text-slate-900">
                  {selectedMenu ? 'Edit Menu' : 'Tambah Menu Baru'}
                </h3>
                <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wider mt-0.5">
                  {selectedMenu ? 'Perbarui informasi menu' : 'Buat menu baru untuk sidebar'}
                </p>
              </div>
              <button
                onClick={() => setIsMenuModalOpen(false)}
                className="p-2 hover:bg-slate-200/60 text-slate-400 hover:text-slate-700 rounded-xl transition-all"
              >
                <X size={18} />
              </button>
            </div>

            <form onSubmit={handleMenuSubmit} className="p-8 space-y-4 overflow-y-auto max-h-[500px]">

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Key (Unik)</label>
                  <input
                    type="text"
                    required
                    placeholder="contoh: dashboard_admin"
                    value={formKey}
                    onChange={(e) => setFormKey(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                  />
                </div>
                <div>
                  <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Label</label>
                  <input
                    type="text"
                    required
                    placeholder="contoh: Dashboard"
                    value={formLabel}
                    onChange={(e) => setFormLabel(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                  />
                </div>
              </div>

              <div>
                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Path</label>
                <input
                  type="text"
                  required
                  placeholder="contoh: /admin/dashboard"
                  value={formPath}
                  onChange={(e) => setFormPath(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Icon (Lucide)</label>
                  <input
                    type="text"
                    placeholder="contoh: LayoutDashboard"
                    value={formIcon}
                    onChange={(e) => setFormIcon(e.target.value)}
                    className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all placeholder:text-slate-300"
                  />
                </div>
                <div>
                  <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Urutan</label>
                  <input
                    type="number"
                    value={formUrutan}
                    onChange={(e) => setFormUrutan(Number(e.target.value))}
                    className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-semibold focus:border-[#2e5299] focus:bg-white outline-none transition-all"
                  />
                </div>
              </div>

              <div>
                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5">Parent Menu (Opsional)</label>
                <select
                  value={formParentId}
                  onChange={(e) => setFormParentId(e.target.value !== '' ? Number(e.target.value) : '')}
                  className="w-full bg-slate-50 border border-slate-200 rounded-2xl px-4 py-3 text-sm font-bold text-slate-700 focus:border-[#2e5299] outline-none transition-all"
                >
                  <option value="">Tidak ada (Menu Utama)</option>
                  {parentMenus.map(m => (
                    <option key={m.id} value={m.id}>{m.label}</option>
                  ))}
                </select>
              </div>

              <div className="pt-6 border-t border-slate-100 flex items-center justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setIsMenuModalOpen(false)}
                  className="px-5 py-3 border border-slate-200 hover:bg-slate-50 rounded-2xl text-xs font-black uppercase tracking-wider text-slate-500 transition-all active:scale-95"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  disabled={isPending}
                  className="px-6 py-3 bg-[#2e5299] hover:bg-[#1e3d73] text-white rounded-2xl text-xs font-black uppercase tracking-wider shadow-md hover:shadow-lg transition-all active:scale-95 disabled:opacity-50"
                >
                  {isPending ? 'Memproses...' : selectedMenu ? 'Perbarui' : 'Simpan'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* DELETE CONFIRMATION MODAL */}
      {isDeleteModalOpen && selectedMenu && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-300">
          <div className="bg-white w-full max-w-md rounded-[2.5rem] border border-slate-100 shadow-2xl p-8 text-center animate-in scale-in duration-300">
            <div className="w-16 h-16 bg-rose-50 text-rose-600 rounded-3xl flex items-center justify-center mx-auto mb-6">
              <AlertTriangle size={32} />
            </div>

            <h3 className="text-lg font-black text-slate-900 tracking-tight">Hapus Menu?</h3>
            <p className="text-slate-400 text-xs font-semibold mt-2 px-4 leading-relaxed">
              Menu <span className="text-slate-800 font-bold">{selectedMenu.label}</span> akan dihapus beserta semua sub-menu dan relasi role-nya.
            </p>

            <div className="mt-4 p-4 bg-rose-50/50 border border-rose-100 rounded-2xl text-rose-800 text-left flex items-start gap-3">
              <Info size={18} className="shrink-0 text-rose-600 mt-0.5" />
              <div className="text-[11px] font-bold leading-relaxed">
                Tindakan ini tidak dapat dibatalkan. Semua role yang memiliki akses ke menu ini akan kehilangan aksesnya.
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
