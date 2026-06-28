'use client'

import { useState } from 'react'
import { Menu, X, LogOut } from 'lucide-react'
import Link from 'next/link'
import * as Icons from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import type { MenuItem } from '@/lib/getMenuItems'

interface MobileNavProps {
  menuItems: MenuItem[]
  activePath: string
  nama?: string
}

export default function MobileNav({ menuItems, activePath, nama }: MobileNavProps) {
  const [isOpen, setIsOpen] = useState(false)

  const renderIcon = (iconName: string | null) => {
    if (!iconName) return <Icons.Circle size={20} />
    const Icon = Icons[iconName as keyof typeof Icons] as LucideIcon
    if (Icon) return <Icon size={20} />
    return <Icons.Circle size={20} />
  }

  const isActive = (href: string) =>
    activePath === href || activePath.startsWith(href + '/')

  return (
    <>
      <button
        onClick={() => setIsOpen(true)}
        className="md:hidden p-2 -ml-2 text-slate-600 hover:text-[#2e5299] active:scale-95 transition-all min-w-[44px] min-h-[44px] flex items-center justify-center"
        aria-label="Buka menu"
      >
        <Menu size={24} />
      </button>

      {isOpen && (
        <div className="fixed inset-0 z-50 md:hidden">
          <div
            className="fixed inset-0 bg-black/40 backdrop-blur-sm animate-in fade-in duration-200"
            onClick={() => setIsOpen(false)}
          />
          <div className="fixed inset-y-0 left-0 w-72 bg-[#2e5299] text-white shadow-2xl flex flex-col animate-in slide-in-from-left duration-300">
            <div className="flex items-center justify-between p-6 border-b border-white/10">
              <div className="flex items-center gap-2.5">
                <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-6 h-6 object-contain" />
                <div className="flex flex-col">
                  <span className="text-base font-semibold leading-none">Sistem</span>
                  <span className="text-base font-semibold leading-tight">Kompen</span>
                </div>
              </div>
              <button
                onClick={() => setIsOpen(false)}
                className="p-1.5 rounded-lg hover:bg-white/10 transition-colors min-w-[44px] min-h-[44px] flex items-center justify-center"
                aria-label="Tutup menu"
              >
                <X size={20} />
              </button>
            </div>

            {nama && (
              <div className="px-6 py-4 border-b border-white/10">
                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-white/20 border border-white/20 flex items-center justify-center text-white font-medium">
                    {nama.charAt(0).toUpperCase()}
                  </div>
                  <div className="flex flex-col">
                    <span className="text-sm font-semibold text-white">{nama}</span>
                    <span className="text-[11px] text-white/60">Mahasiswa</span>
                  </div>
                </div>
              </div>
            )}

            <nav className="flex-1 py-4 overflow-y-auto">
              {menuItems.map((item) => (
                <Link
                  key={item.id}
                  href={item.href}
                  onClick={() => setIsOpen(false)}
                  className="block mx-3"
                >
                  <div className={`flex items-center gap-3 px-3 py-3 rounded-xl transition-all duration-200 ${
                    isActive(item.href)
                      ? 'bg-white/15 text-white font-semibold'
                      : 'text-white/70 hover:text-white hover:bg-white/10'
                  }`}>
                    {renderIcon(item.icon)}
                    <span className="text-sm">{item.label}</span>
                  </div>
                </Link>
              ))}
            </nav>

            <div className="p-6 border-t border-white/10">
              <Link
                href="/logout"
                onClick={() => setIsOpen(false)}
                className="flex items-center gap-2 text-white/60 hover:text-white text-xs font-medium transition-colors min-h-[44px]"
              >
                <LogOut size={16} />
                Keluar
              </Link>
            </div>
          </div>
        </div>
      )}
    </>
  )
}
