'use server'

import prisma from '@/lib/prisma'
import { writeFile } from 'fs/promises'
import { join } from 'path'

export async function updateProgresTugas(formData: FormData) {
  const penugasanId = Number(formData.get('id'))
  const statusSekarang = Number(formData.get('status_tugas_id'))
  const imageFile = formData.get('image') as File | null
  
  // 1. Tentukan Status Berikutnya
  // 1 (Menunggu) -> 2 (Proses), 2 (Proses) -> 3 (Selesai)
  const nextStatus = statusSekarang === 1 ? 2 : 3

  try {
    // Fetch detail_pengerjaan yang sudah ada (jangan overwrite)
    const existing = await prisma.penugasan.findUnique({
      where: { id: penugasanId },
      select: { detail_pengerjaan: true }
    })
    const existingData = (existing?.detail_pengerjaan as Record<string, unknown>) || {}

    let fileName = null

    // 2. Handle Upload Gambar jika ada
    if (imageFile) {
      // Langsung convert Blob to Buffer (no base64 decoding needed)
      const buffer = Buffer.from(await imageFile.arrayBuffer())
      
      // Buat nama file unik (Pake ID & Timestamp)
      fileName = `bukti_${penugasanId}_${Date.now()}.jpg`
      const path = join(process.cwd(), 'public/uploads', fileName)
      
      // Simpan ke folder /public/uploads
      await writeFile(path, buffer)
    }

    // 3. Tentukan key foto berdasarkan transisi status
    // Status 1->2 (Mulai) => foto_mulai, Status 2->3 (Selesai) => foto_selesai
    const fotoKey = statusSekarang === 1 ? 'foto_mulai' : 'foto_selesai'

    // 4. Update Database via Prisma (merge, jangan overwrite)
    const nominalRaw = formData.get('nominal')
    const nominal = nominalRaw ? Number(nominalRaw) : null

    await prisma.penugasan.update({
      where: { id: penugasanId },
      data: {
        status_tugas_id: nextStatus,
        detail_pengerjaan: {
          ...existingData,
          ...(fileName ? { [fotoKey]: fileName } : {}),
          ...(nominal !== null ? { nominal } : {})
        }, 
        updated_at: new Date()
      }
    })

    return { success: true, nextStatus }
  } catch (error) {
    console.error("Update Error:", error)
    return { success: false }
  }
}