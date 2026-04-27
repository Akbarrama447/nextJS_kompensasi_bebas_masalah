import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import * as Icons from 'lucide-react'
import Link from 'next/link'
import { LucideIcon, ChevronRight, LogOut } from 'lucide-react'

interface SidebarProps {
  role: 'mahasiswa' | 'admin'
  activePath: string
  children: React.ReactNode
}

export default async function Sidebar({ role, activePath, children }: SidebarProps) {
  const cookieStore = await cookies()
  
  let nama = 'Guest'
  
  if (role === 'mahasiswa') {
    const nim = cookieStore.get('nim')?.value
    if (nim) {
      const mahasiswa = await prisma.mahasiswa.findUnique({ where: { nim } })
      nama = mahasiswa?.nama || 'Guest'
    }
  } else {
    const nip = cookieStore.get('nip')?.value
    if (nip) {
      const staf = await prisma.staf.findUnique({ where: { nip } })
      nama = staf?.nama || 'Admin'
    }
  }

  const menus = await prisma.menus.findMany({
    where: { parent_id: null },
    orderBy: { urutan: 'asc' },
  })

  const id = role === 'mahasiswa' 
    ? cookieStore.get('nim')?.value || '-'
    : cookieStore.get('nip')?.value || '-'

  const renderMenuIcon = (iconName: string) => {
    if (!iconName) return <Icons.Circle size={20} />
    
    if (iconName.match(/\.(png|jpg|svg)$/i)) {
      return <img src={`/${iconName}`} alt="" className="w-5 h-5 object-contain" />
    }
    
    const Icon = Icons[iconName as keyof typeof Icons] as LucideIcon
    if (Icon) return <Icon size={20} />
    
    return <Icons.Circle size={20} />
  }

  return (
    <div className="flex min-h-screen bg-gray-100">
      <aside className="w-64 bg-blue-950 min-h-screen fixed left-0 top-0 flex flex-col">
        <div className="px-4 py-4 border-b border-blue-900 flex items-center gap-3">
          <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-12 h-12 object-contain" />
          <h1 className="text-lg font-bold text-white">Sistem Kompensasi</h1>
        </div>
        
        <nav className="flex-1 px-3 py-4">
          <ul className="space-y-1">
            {menus.map((menu) => {
              const isActive = activePath === menu.path
              return (
                <li key={menu.id}>
                  <Link href={menu.path} className="flex items-center group relative">
                    <div className={`flex items-center gap-3 px-3 py-3 rounded font-medium transition-all w-full ${
                      isActive 
                        ? 'bg-blue-900 text-white border-l-4 border-sky-400' 
                        : 'text-blue-200 hover:bg-blue-900/50'
                    }`}>
                      <span className={isActive ? 'text-sky-400' : ''}>{renderMenuIcon(menu.icon || '')}</span>
                      <span className="flex-1">{menu.label}</span>
                      <ChevronRight size={16} className={`transition-transform ${isActive ? 'opacity-100 text-sky-400' : 'opacity-0 group-hover:opacity-50'}`} />
                    </div>
                    <div className={`w-1.5 h-10 rounded-l transition-all ${isActive ? 'bg-sky-400' : 'bg-blue-800 opacity-0 group-hover:opacity-100'}`} />
                  </Link>
                </li>
              )
            })}
          </ul>
        </nav>

        <div className="p-3 border-t border-blue-900">
          <div className="flex items-center gap-3 px-3 py-3 text-blue-200 mb-2">
            <div className="w-10 h-10 bg-blue-900 rounded-full flex items-center justify-center text-white font-medium">
              {nama.charAt(0).toUpperCase()}
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-white truncate">{nama}</p>
              <p className="text-xs text-blue-300 truncate">{id}</p>
            </div>
          </div>
          <Link href="/logout" className="flex items-center gap-3 px-3 py-2 rounded text-blue-200 hover:bg-blue-900/50 transition-colors">
            <LogOut size={18} />
            <span className="text-sm font-medium">Logout</span>
          </Link>
        </div>
      </aside>
      
      <div className="flex-1 ml-64">
        <header className="bg-white shadow-sm px-6 py-4 flex justify-between items-center"><div></div><div></div></header>
        <main className="p-6">{children}</main>
      </div>
    </div>
  )
}