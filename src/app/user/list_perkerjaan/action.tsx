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

    // 3. Update Database via Prisma
    const nominalRaw = formData.get('nominal')
    const nominal = nominalRaw ? Number(nominalRaw) : null

    await prisma.penugasan.update({
      where: { id: penugasanId },
      data: {
        status_tugas_id: nextStatus,
        // Asumsi kolom di DB lo namanya 'detail_pengerjaan' untuk nyimpen nama file
        // Atau sesuaikan dengan kolom foto yang ada di schema lo
        detail_pengerjaan: {
          ...(fileName ? { fileName } : {}),
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