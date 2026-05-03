'use server'

import prisma from '@/lib/prisma'
import { writeFile } from 'fs/promises'
import { join } from 'path'

export async function updateProgresTugas(formData: FormData) {
  const penugasanId = Number(formData.get('id'))
  const statusSekarang = Number(formData.get('status_tugas_id'))
  const imageBase64 = formData.get('image') as string
  
  // 1. Tentukan Status Berikutnya
  // 1 (Menunggu) -> 2 (Proses), 2 (Proses) -> 3 (Selesai)
  const nextStatus = statusSekarang === 1 ? 2 : 3

  try {
    let fileName = null

    // 2. Handle Upload Gambar jika ada
    if (imageBase64) {
      // Decode base64
      const base64Data = imageBase64.replace(/^data:image\/\w+;base64,/, "")
      const buffer = Buffer.from(base64Data, 'base64')
      
      // Buat nama file unik (Pake ID & Timestamp)
      fileName = `bukti_${penugasanId}_${Date.now()}.jpg`
      const path = join(process.cwd(), 'public/uploads', fileName)
      
      // Simpan ke folder /public/uploads
      await writeFile(path, buffer)
    }

    // 3. Update Database via Prisma
    await prisma.penugasan.update({
      where: { id: penugasanId },
      data: {
        status_tugas_id: nextStatus,
        // Asumsi kolom di DB lo namanya 'detail_pengerjaan' untuk nyimpen nama file
        // Atau sesuaikan dengan kolom foto yang ada di schema lo
        detail_pengerjaan: fileName ? { fileName } : undefined, 
        updated_at: new Date()
      }
    })

    return { success: true, nextStatus }
  } catch (error) {
    console.error("Update Error:", error)
    return { success: false }
  }
}