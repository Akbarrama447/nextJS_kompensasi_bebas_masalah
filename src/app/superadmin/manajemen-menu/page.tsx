import prisma from '@/lib/prisma'
import MenuManagementClient from './MenuManagementClient'

export const dynamic = 'force-dynamic'

export default async function ManajemenMenuPage() {
  const menus = await prisma.menus.findMany({
    orderBy: { urutan: 'asc' },
    include: {
      other_menus: {
        orderBy: { urutan: 'asc' },
      },
    },
  })

  const roles = await prisma.roles.findMany({
    orderBy: { id: 'asc' },
  })

  const roleMenus = await prisma.role_has_menus.findMany({
    select: {
      role_id: true,
      menus_id: true,
    },
  })

  return (
    <MenuManagementClient
      initialMenus={menus.map(m => ({
        id: m.id,
        key: m.key,
        label: m.label,
        icon: m.icon,
        path: m.path,
        urutan: m.urutan,
        parent_id: m.parent_id,
        children: m.other_menus.map(c => ({
          id: c.id,
          key: c.key,
          label: c.label,
          icon: c.icon,
          path: c.path,
          urutan: c.urutan,
          parent_id: c.parent_id,
        })),
      }))}
      roles={roles.map(r => ({
        id: r.id,
        nama: r.nama,
      }))}
      roleMenus={roleMenus.map(rm => ({
        roleId: rm.role_id,
        menuId: rm.menus_id,
      }))}
    />
  )
}
