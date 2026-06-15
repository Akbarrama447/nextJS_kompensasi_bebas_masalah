import { cookies } from 'next/headers'
import { cache } from 'react'
import prisma from '@/lib/prisma'
import { verifySession } from '@/lib/session'
import SidebarClient from './SidebarClient'

interface SidebarProps {
  role: 'mahasiswa' | 'admin' | 'superadmin'
  activePath?: string
  children: React.ReactNode
}

const getMenusForRole = cache(async (roleId: number) => {
  const allowedMenuIds = await prisma.role_has_menus.findMany({
    where: { role_id: roleId },
    select: { menus_id: true },
  })

  const allowedIds = allowedMenuIds
    .map((r) => r.menus_id)
    .filter((menusId): menusId is number => menusId !== null)

  const menus = await prisma.menus.findMany({
    where: {
      parent_id: null,
      ...(allowedIds.length > 0 ? { id: { in: allowedIds } } : {}),
    },
    orderBy: { urutan: 'asc' },
  })

  return menus.map((m) => ({
    id: m.id,
    key: m.key,
    label: m.label,
    icon: m.icon,
    path: m.path,
    urutan: m.urutan,
  }))
})

const getRoleIdByName = cache(async (name: string) => {
  const role = await prisma.roles.findFirst({
    where: { nama: { equals: name, mode: 'insensitive' } },
    select: { id: true },
  })
  return role?.id ?? null
})

export default async function Sidebar({ role, activePath = '', children }: SidebarProps) {
  const cookieStore = await cookies()
  const sessionToken = cookieStore.get('session')?.value
  const session = sessionToken ? await verifySession(sessionToken) : null

  let nama = 'User'
  let roleId: number | null = null
  let id = '-'

  if (role === 'superadmin') {
    nama = session?.nama || 'Super Admin'
    id = session?.identifier || '-'
    roleId = await getRoleIdByName('superadmin')
  } else if (role === 'mahasiswa') {
    id = session?.identifier || '-'
    if (session?.identifier) {
      const mahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim: session.identifier },
        select: { nama: true, user: { select: { role_id: true } } },
      })
      if (mahasiswa) {
        nama = mahasiswa.nama || 'User'
        roleId = mahasiswa.user?.role_id ?? null
      }
    }
  } else {
    id = session?.identifier || '-'
    if (session?.identifier) {
      const staf = await prisma.staf.findUnique({
        where: { nip: session.identifier },
        select: { nama: true, user: { select: { role_id: true } } },
      })
      if (staf) {
        nama = staf.nama || 'Admin'
        roleId = staf.user?.role_id ?? null
      }
    }
  }

  const serializedMenus = roleId !== null ? await getMenusForRole(roleId) : []

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
