import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import SidebarClient from './SidebarClient'

interface SidebarProps {
  role: 'mahasiswa' | 'admin' | 'superadmin'
  activePath?: string
  children: React.ReactNode
}

export default async function Sidebar({ role, activePath = '', children }: SidebarProps) {
  const cookieStore = await cookies()
  
  let nama = 'User' 
  
  if (role === 'superadmin') {
    nama = 'Super Admin'
  } else if (role === 'mahasiswa') {
    const nim = cookieStore.get('nim')?.value
    console.log("DEBUG: NIM dari Cookie =", nim)

    if (nim) {
      const mahasiswa = await prisma.mahasiswa.findUnique({ where: { nim } })
      if (mahasiswa) {
        nama = mahasiswa.nama || 'User'
        console.log("DEBUG: Nama MHS Ketemu =", nama)
      } else {
        console.log("DEBUG: NIM ada tapi di DB GAK KETEMU")
      }
    }
  } else {
    const nipFromCookie = cookieStore.get('nip')?.value
    if (nipFromCookie) {
      const staf = await prisma.staf.findUnique({ where: { nip: nipFromCookie } })
      nama = staf?.nama || 'Admin'
    }
  }

  let roleId: number
  if (role === 'mahasiswa') {
    roleId = 3
  } else {
    const nipVal = cookieStore.get('nip')?.value
    const stafUser = nipVal ? await prisma.staf.findUnique({
      where: { nip: nipVal },
      select: { user: { select: { role_id: true } } },
    }) : null
    roleId = stafUser?.user?.role_id ?? 1
  }

  const allowedMenuIds = await prisma.role_has_menus.findMany({
    where: { role_id: roleId },
    select: { menus_id: true },
  })

  const allowedIds = allowedMenuIds.map((r) => r.menus_id).filter((id): id is number => id !== null)

  const menus = await prisma.menus.findMany({
    where: {
      parent_id: null,
      ...(allowedIds.length > 0 ? { id: { in: allowedIds } } : {}),
    },
    orderBy: { urutan: 'asc' },
  })

    serializedMenus = menus.map(m => ({
      id: m.id,
      key: m.key,
      label: m.label,
      icon: m.icon,
      path: m.path,
      urutan: m.urutan,
    }))
  }

  let id = '-'
  if (role === 'mahasiswa') {
    id = cookieStore.get('nim')?.value || '-'
  } else if (role === 'admin') {
    id = cookieStore.get('nip')?.value || '-'
  } else if (role === 'superadmin') {
    id = cookieStore.get('superadmin')?.value || '-'
  }

  return (
    <div className="flex min-h-screen bg-[#f1f5f9] font-sans antialiased text-slate-900">
      <aside className="hidden md:flex w-64 bg-[#2e5299] text-white flex-col shadow-lg">
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
              const href = menu.path
              const isActive = activePath === href || activePath.startsWith(href + '/') || (menu.key && activePath.includes(menu.key))
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
