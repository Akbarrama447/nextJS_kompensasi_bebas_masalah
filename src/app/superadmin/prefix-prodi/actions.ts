'use server'

import prisma from '@/lib/prisma'
import { revalidatePath } from 'next/cache'
import { requireSuperadmin } from '@/lib/session'
import { logAudit } from '@/lib/audit'

const GRUP = 'prefix_prodi'
const KEY = 'mapping'

export interface PrefixProdiItem {
  prefix: string
  prodiKeyword: string
}

export async function getMapping(): Promise<Record<string, string>> {
  try {
    const row = await prisma.pengaturan_sistem.findUnique({
      where: { key: KEY },
    })

    if (!row?.value) return {}

    return JSON.parse(row.value) as Record<string, string>
  } catch {
    return {}
  }
}

export async function saveMapping(mapping: Record<string, string>) {
  try {
    const session = await requireSuperadmin()

    const value = JSON.stringify(mapping)

    await prisma.pengaturan_sistem.upsert({
      where: { key: KEY },
      update: { value, grup: GRUP, keterangan: 'Mapping prefix kelas ke keyword nama prodi' },
      create: {
        grup: GRUP,
        key: KEY,
        value,
        tipe_data: 'json',
        keterangan: 'Mapping prefix kelas ke keyword nama prodi',
      },
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'UPDATE_PREFIX_PRODI_MAPPING',
      target: 'Mapping prefix prodi',
      detail: { mapping },
    })

    revalidatePath('/superadmin/prefix-prodi')
    return { success: true, message: 'Mapping berhasil disimpan!' }
  } catch (error: any) {
    console.error('Error saving mapping:', error)
    return { success: false, error: error.message || 'Gagal menyimpan mapping' }
  }
}
