'use server'

import prisma from '@/lib/prisma'
import { revalidatePath } from 'next/cache'
import { requireSuperadmin } from '@/lib/session'
import { logAudit } from '@/lib/audit'

export async function createMenu(data: {
  key: string
  label: string
  icon?: string
  path: string
  urutan?: number
  parentId?: number
}) {
  try {
    const session = await requireSuperadmin()

    const { key, label, icon, path, urutan, parentId } = data

    if (!key || !label || !path) {
      return { success: false, error: 'Key, Label, dan Path wajib diisi!' }
    }

    const existing = await prisma.menus.findUnique({ where: { key } })
    if (existing) {
      return { success: false, error: `Menu dengan key "${key}" sudah ada!` }
    }

    await prisma.menus.create({
      data: {
        key,
        label,
        icon: icon || null,
        path,
        urutan: urutan ?? 0,
        parent_id: parentId || null,
      },
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'CREATE_MENU',
      target: label,
      detail: { key, path },
    })

    revalidatePath('/superadmin/manajemen-menu')
    return { success: true, message: 'Menu baru berhasil ditambahkan!' }
  } catch (error: any) {
    console.error('Error in createMenu:', error)
    return { success: false, error: error.message || 'Gagal menambahkan menu' }
  }
}

export async function updateMenu(data: {
  menuId: number
  key: string
  label: string
  icon?: string
  path: string
  urutan?: number
  parentId?: number
}) {
  try {
    const session = await requireSuperadmin()

    const { menuId, key, label, icon, path, urutan, parentId } = data

    if (!menuId || !key || !label || !path) {
      return { success: false, error: 'ID, Key, Label, dan Path wajib diisi!' }
    }

    const existing = await prisma.menus.findFirst({
      where: { key, NOT: { id: menuId } },
    })
    if (existing) {
      return { success: false, error: `Key "${key}" sudah digunakan menu lain!` }
    }

    await prisma.menus.update({
      where: { id: menuId },
      data: {
        key,
        label,
        icon: icon || null,
        path,
        urutan: urutan ?? 0,
        parent_id: parentId || null,
      },
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'UPDATE_MENU',
      target: label,
      detail: { menuId, key, path },
    })

    revalidatePath('/superadmin/manajemen-menu')
    return { success: true, message: 'Menu berhasil diperbarui!' }
  } catch (error: any) {
    console.error('Error in updateMenu:', error)
    return { success: false, error: error.message || 'Gagal memperbarui menu' }
  }
}

export async function deleteMenu(menuId: number) {
  try {
    const session = await requireSuperadmin()

    if (!menuId) {
      return { success: false, error: 'Menu ID wajib dicantumkan!' }
    }

    const menu = await prisma.menus.findUnique({ where: { id: menuId } })
    if (!menu) {
      return { success: false, error: 'Menu tidak ditemukan!' }
    }

    await prisma.$transaction(async (tx) => {
      await tx.role_has_menus.deleteMany({ where: { menus_id: menuId } })
      await tx.menus.deleteMany({ where: { parent_id: menuId } })
      await tx.menus.delete({ where: { id: menuId } })
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'DELETE_MENU',
      target: menu.label || menu.key,
      detail: { menuId },
    })

    revalidatePath('/superadmin/manajemen-menu')
    return { success: true, message: 'Menu berhasil dihapus!' }
  } catch (error: any) {
    console.error('Error in deleteMenu:', error)
    return { success: false, error: error.message || 'Gagal menghapus menu' }
  }
}

export async function assignMenuToRole(roleId: number, menuId: number) {
  try {
    const session = await requireSuperadmin()

    const existing = await prisma.role_has_menus.findFirst({
      where: { role_id: roleId, menus_id: menuId },
    })
    if (existing) {
      return { success: false, error: 'Role sudah memiliki akses ke menu ini!' }
    }

    await prisma.role_has_menus.create({
      data: { role_id: roleId, menus_id: menuId },
    })

    const role = await prisma.roles.findUnique({ where: { id: roleId } })
    const menu = await prisma.menus.findUnique({ where: { id: menuId } })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'ASSIGN_MENU',
      target: `${role?.nama} -> ${menu?.label}`,
      detail: { roleId, menuId },
    })

    revalidatePath('/superadmin/manajemen-menu')
    return { success: true, message: 'Menu berhasil ditambahkan ke role!' }
  } catch (error: any) {
    console.error('Error in assignMenuToRole:', error)
    return { success: false, error: error.message || 'Gagal menambahkan menu ke role' }
  }
}

export async function removeMenuFromRole(roleId: number, menuId: number) {
  try {
    const session = await requireSuperadmin()

    await prisma.role_has_menus.deleteMany({
      where: { role_id: roleId, menus_id: menuId },
    })

    const role = await prisma.roles.findUnique({ where: { id: roleId } })
    const menu = await prisma.menus.findUnique({ where: { id: menuId } })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'REMOVE_MENU',
      target: `${role?.nama} -> ${menu?.label}`,
      detail: { roleId, menuId },
    })

    revalidatePath('/superadmin/manajemen-menu')
    return { success: true, message: 'Menu berhasil dihapus dari role!' }
  } catch (error: any) {
    console.error('Error in removeMenuFromRole:', error)
    return { success: false, error: error.message || 'Gagal menghapus menu dari role' }
  }
}
