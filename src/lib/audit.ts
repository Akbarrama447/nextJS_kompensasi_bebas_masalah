export interface AuditLogData {
  actorNip: string
  actorNama: string
  aksi: string
  target: string
  detail?: Record<string, unknown>
}

/**
 * Mencatat aktivitas audit ke sistem.
 * Saat ini menggunakan console.log, bisa di-extend ke database table nantinya.
 */
export async function logAudit(data: AuditLogData): Promise<void> {
  const timestamp = new Date().toISOString()

  console.log(
    JSON.stringify({
      level: 'AUDIT',
      timestamp,
      actor: `${data.actorNama} (${data.actorNip})`,
      action: data.aksi,
      target: data.target,
      detail: data.detail || {},
    })
  )

  // TODO: Simpan ke tabel audit_log ketika tabel sudah tersedia di database
  // Contoh:
  // await prisma.audit_log.create({
  //   data: {
  //     actor_nip: data.actorNip,
  //     actor_nama: data.actorNama,
  //     aksi: data.aksi,
  //     target: data.target,
  //     detail: data.detail ?? {},
  //   }
  // })
}
