import prisma from '@/lib/prisma'
import { Prisma } from '@/generated/prisma'

export async function logAudit({
  actorNip,
  actorNama,
  aksi,
  target,
  detail,
}: {
  actorNip: string
  actorNama: string
  aksi: string
  target: string
  detail?: Record<string, unknown>
}) {
  try {
    await prisma.audit_log.create({
      data: {
        actor_nip: actorNip,
        actor_nama: actorNama,
        aksi,
        target,
        detail: (detail as Prisma.InputJsonValue) ?? undefined,
      },
    })
  } catch (error) {
    console.error('Failed to write audit log:', error)
  }
}
