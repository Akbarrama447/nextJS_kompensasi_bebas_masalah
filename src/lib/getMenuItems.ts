import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'

export type MenuItem = {
  id: number
  key: string
  label: string
  icon: string | null
  href: string
}

export async function getMenuItems(role: 'mahasiswa' | 'admin' | 'superadmin'): Promise<MenuItem[]> {
  const cookieStore = await cookies()

  let roleId: number
  if (role === 'mahasiswa') {
    roleId = 3
  } else if (role === 'superadmin') {
    roleId = 1
  } else {
    const nip = cookieStore.get('nip')?.value
    if (nip) {
      const staf = await prisma.staf.findUnique({
        where: { nip },
        select: { user: { select: { role_id: true } } },
      })
      roleId = staf?.user?.role_id ?? 2
    } else {
      roleId = 2
    }
  }

  const allowedRows = await prisma.role_has_menus.findMany({
    where: { role_id: roleId },
    select: { menus_id: true },
  })

  const allowedIds = allowedRows
    .map((r) => r.menus_id)
    .filter((id): id is number => id !== null)

  const menus = await prisma.menus.findMany({
    where: {
      parent_id: null,
      ...(allowedIds.length > 0 ? { id: { in: allowedIds } } : {}),
    },
    orderBy: { urutan: 'asc' },
  })

  return menus.map((menu) => {
    let href = menu.path
    if (role === 'admin') {
      if (menu.key === 'pekerjaan' || menu.key === 'dashboard') {
        href = '/admin/list_pekerjaan'
      } else {
        href = menu.path.replace('/user/', '/admin/')
      }
    }
    return { id: menu.id, key: menu.key, label: menu.label, icon: menu.icon, href }
  })
}
