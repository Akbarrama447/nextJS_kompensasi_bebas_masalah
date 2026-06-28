'use client'

import { useState } from 'react'
import Link from 'next/link'
import { Menu, X, LogOut, Circle } from 'lucide-react'
import * as Icons from 'lucide-react'
import type { LucideIcon } from 'lucide-react'

interface MenuItem {
  id: number
  label: string
  path: string
  icon: string | null
  key: string | null
}

interface MobileMenuProps {
  menus: MenuItem[]
  role: string
  activePath: string
  nama: string
  roleLabel: string
}

export default function MobileMenu({ menus, role, activePath, nama, roleLabel }: MobileMenuProps) {
  const [isOpen, setIsOpen] = useState(false)

  const renderIcon = (iconName: string | null) => {
    if (!iconName) return <Circle size={20} />
    if (iconName.match(/\.(png|jpg|svg)$/i)) {
      return <img src={`/${iconName}`} alt="" className="w-5 h-5 object-contain" />
    }
    const Icon = Icons[iconName as keyof typeof Icons] as LucideIcon
    if (Icon) return <Icon size={20} />
    return <Circle size={20} />
  }

  return (
    <>
      <button
        onClick={() => setIsOpen(true)}
        className="md:hidden fixed top-3 left-3 z-50 p-2.5 bg-white rounded-xl shadow-lg border border-slate-200 text-slate-700 hover:bg-slate-50 active:scale-95 transition-all"
        aria-label="Buka menu"
      >
        <Menu size={22} />
      </button>

      {isOpen && (
        <div
          className="md:hidden fixed inset-0 z-40 bg-black/40 backdrop-blur-sm"
          onClick={() => setIsOpen(false)}
        />
      )}

      <div
        className={`md:hidden fixed inset-y-0 left-0 z-50 w-72 bg-[#2e5299] text-white flex flex-col shadow-2xl transform transition-transform duration-300 ease-out ${
          isOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex items-center justify-between p-5 border-b border-white/10">
          <div className="flex items-center gap-2.5">
            <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-6 h-6 object-contain" />
            <div className="flex flex-col">
              <span className="text-base font-semibold leading-none">Sistem</span>
              <span className="text-base font-semibold leading-tight">Kompen</span>
            </div>
          </div>
          <button
            onClick={() => setIsOpen(false)}
            className="p-1.5 rounded-lg hover:bg-white/10 transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        <nav className="flex-1 overflow-y-auto py-3">
          <ul className="space-y-0.5 px-3">
            {menus.map((menu) => {
              let href = menu.path
              if (role === 'admin') {
                if (menu.key === 'pekerjaan' || menu.key === 'dashboard') {
                  href = '/admin/list_pekerjaan'
                } else {
                  href = menu.path.replace('/user/', '/admin/')
                }
              }
              const isActive = activePath === href || activePath.startsWith(href + '/') || (menu.key && activePath.includes(menu.key))
              return (
                <li key={menu.id}>
                  <Link href={href} onClick={() => setIsOpen(false)}>
                    <div className={`flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all ${
                      isActive
                        ? 'bg-white/20 text-white shadow-sm'
                        : 'text-white/70 hover:text-white hover:bg-white/10'
                    }`}>
                      {renderIcon(menu.icon || '')}
                      <span>{menu.label}</span>
                    </div>
                  </Link>
                </li>
              )
            })}
          </ul>
        </nav>

        <div className="p-5 border-t border-white/10">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-9 h-9 rounded-full bg-white/20 border border-white/20 flex items-center justify-center text-white font-medium text-sm">
              {nama.charAt(0).toUpperCase()}
            </div>
            <div className="flex flex-col">
              <span className="text-sm font-semibold text-white">{nama}</span>
              <span className="text-[11px] text-white/60">{roleLabel}</span>
            </div>
          </div>
          <Link
            href="/logout"
            onClick={() => setIsOpen(false)}
            className="flex items-center gap-2 text-white/60 hover:text-white text-xs font-medium transition-colors"
          >
            <LogOut size={16} />
            Keluar
          </Link>
        </div>
      </div>
    </>
  )
}
