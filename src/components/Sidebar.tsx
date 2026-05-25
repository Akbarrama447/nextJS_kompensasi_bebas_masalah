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
    const nip = cookieStore.get('nip')?.value
    console.log("DEBUG: NIP dari Cookie =", nip)

    if (nip) {
      const staf = await prisma.staf.findUnique({ where: { nip } })
      if (staf) {
        nama = staf.nama || 'Admin'
        console.log("DEBUG: Nama STAF Ketemu =", nama)
      }
    }
  }

  let serializedMenus: Array<{
    id: number
    key: string | null
    label: string | null
    icon: string | null
    path: string
    urutan: number | null
  }> = []

  if (role === 'superadmin') {
    serializedMenus = [
      { id: 100, key: 'dashboard', label: 'Dashboard', icon: 'LayoutDashboard', path: '/superadmin/dashboard', urutan: 1 },
      { id: 101, key: 'users', label: 'Manajemen User', icon: 'Users', path: '/superadmin/users', urutan: 2 }
    ]
  } else {
    const menus = await prisma.menus.findMany({
      where: { parent_id: null },
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
    <SidebarClient 
      role={role} 
      activePath={activePath} 
      nama={nama} 
      menus={serializedMenus}
      id={id}
    >
      {children}
    </SidebarClient>
  )
}