import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import * as Icons from 'lucide-react'
import Link from 'next/link'
import { LogOut, LucideIcon } from 'lucide-react'

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
    <div className="flex min-h-screen bg-[#f1f5f9] font-sans antialiased text-slate-900">
      <aside className="w-64 bg-[#2e5299] text-white flex flex-col shadow-lg">
        <div className="flex items-center gap-2.5 p-6 mb-2">
          <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-6 h-6 object-contain" />
          <div className="flex flex-col">
            <span className="text-base font-semibold leading-none">Sistem</span>
            <span className="text-base font-semibold leading-tight">Kompen</span>
          </div>
        </div>
        
        <nav className="flex-1">
          <ul className="space-y-1">
            {menus.map((menu) => {
              // Menentukan path berdasarkan role
              let href = menu.path
              if (role === 'admin') {
                if (menu.key === 'pekerjaan') {
                  href = '/admin/list_pekerjaan'
                } else {
                  href = menu.path.replace('/user/', '/admin/')
                }
              }

              const isActive = activePath === href
              return (
                <li key={menu.id}>
                  <Link href={href}>
                    <div className={`flex items-center gap-3 transition-all duration-200 ease-in-out ${isActive ? 'bg-[#f1f5f9] text-[#2e5299] ml-4 py-2.5 px-5 rounded-l-full shadow-lg' : 'px-9 py-3 text-white/80 hover:text-white hover:bg-white/10 hover:translate-x-1 cursor-pointer'}`}>
                      {renderMenuIcon(menu.icon || '')}
                      <span className="font-medium text-[14px]">{menu.label}</span>
                    </div>
                  </Link>
                </li>
              )
            })}
          </ul>
        </nav>

        <div className="p-6 border-t border-white/10">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-9 h-9 rounded-full bg-white/20 border border-white/20 flex items-center justify-center text-white font-medium">
              {nama.charAt(0).toUpperCase()}
            </div>
            <div className="flex flex-col">
              <span className="text-sm font-semibold text-white">{nama}</span>
              <span className="text-[11px] text-white/60">{role === 'mahasiswa' ? 'Mahasiswa' : 'Admin'}</span>
            </div>
          </div>
          <Link href="/logout" className="flex items-center gap-2 text-white/60 hover:text-white text-xs font-medium transition-colors">
            <LogOut size={16} />
            Keluar
          </Link>
        </div>
      </aside>
      
      <div className="flex-1 flex flex-col">
        {children}
      </div>
    </div>
  )
}