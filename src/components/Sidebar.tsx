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
  let roleId: number | null = null
  let id = '-'

  if (role === 'superadmin') {
    nama = 'Super Admin'
    id = cookieStore.get('superadmin')?.value || '-'
    const superRole = await prisma.roles.findFirst({
      where: { nama: { equals: 'superadmin', mode: 'insensitive' } },
      select: { id: true },
    })
    roleId = superRole?.id ?? null
  } else if (role === 'mahasiswa') {
    const nim = cookieStore.get('nim')?.value
    id = nim || '-'
    if (nim) {
      const mahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim },
        select: { nama: true, user: { select: { role_id: true } } },
      })
      if (mahasiswa) {
        nama = mahasiswa.nama || 'User'
        roleId = mahasiswa.user?.role_id ?? null
      }
    }
  } else {
    const nip = cookieStore.get('nip')?.value
    id = nip || '-'
    if (nip) {
      const staf = await prisma.staf.findUnique({
        where: { nip },
        select: { nama: true, user: { select: { role_id: true } } },
      })
      if (staf) {
        nama = staf.nama || 'Admin'
        roleId = staf.user?.role_id ?? null
      }
    }
  }

  // Menu yang boleh diakses role ini — sepenuhnya dari DB (role_has_menus)
  const allowedMenuIds =
    roleId !== null
      ? await prisma.role_has_menus.findMany({
          where: { role_id: roleId },
          select: { menus_id: true },
        })
      : []

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

  const serializedMenus = menus.map((m) => ({
    id: m.id,
    key: m.key,
    label: m.label,
    icon: m.icon,
    path: m.path,
    urutan: m.urutan,
  }))

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
