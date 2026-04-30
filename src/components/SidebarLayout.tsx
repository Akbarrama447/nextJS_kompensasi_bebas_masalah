"use client"

import { useState } from "react"
import { Menu, X } from "lucide-react"

interface SidebarLayoutProps {
  sidebar: React.ReactNode
  children: React.ReactNode
}

export default function SidebarLayout({ sidebar, children }: SidebarLayoutProps) {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <div className="flex min-h-screen bg-[#f1f5f9] font-sans antialiased text-slate-900">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="lg:hidden fixed top-4 left-4 z-50 p-2 bg-[#2e5299] text-white rounded-lg shadow-md hover:bg-[#1D3B81] transition-colors"
      >
        {isOpen ? <X size={24} /> : <Menu size={24} />}
      </button>

      <aside
        className={`
          fixed inset-y-0 left-0 z-40 w-64 bg-[#2e5299] text-white flex flex-col shadow-lg
          transform transition-transform duration-300 ease-in-out
          lg:relative lg:translate-x-0
          ${isOpen ? "translate-x-0" : "-translate-x-full"}
        `}
      >
        {sidebar}
      </aside>

      {isOpen && (
        <div
          onClick={() => setIsOpen(false)}
          className="lg:hidden fixed inset-0 bg-black/50 z-30"
        />
      )}

      <div className="flex-1 flex flex-col min-w-0">
        {children}
      </div>
    </div>
  )
}
