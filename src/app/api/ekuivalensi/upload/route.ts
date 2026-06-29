import { NextRequest, NextResponse } from 'next/server'
import { writeFile, mkdir } from 'fs/promises'
import { join } from 'path'
import prisma from '@/lib/prisma'
import { existsSync } from 'fs'
import { assertMahasiswaInClass, authErrorResponse, requireAuthenticated } from '@/lib/auth'

export async function POST(request: NextRequest) {
  try {
    const actor = await requireAuthenticated()
    const formData = await request.formData()
    const file = formData.get('file') as File
    const ekuivalensiId = formData.get('ekuivalensiId') as string

    if (!file || !ekuivalensiId) {
      return NextResponse.json(
        { message: 'File dan ekuivalensiId diperlukan' },
        { status: 400 }
      )
    }

    const ekuivalensi = await prisma.ekuivalensi_kelas.findUnique({
      where: { id: parseInt(ekuivalensiId) },
      select: {
        id: true,
        kelas_id: true,
        semester_id: true,
      },
    })

    if (!ekuivalensi) {
      return NextResponse.json(
        { message: 'Data ekuivalensi tidak ditemukan' },
        { status: 404 }
      )
    }

    if (actor.type === 'mahasiswa') {
      await assertMahasiswaInClass(actor.nim, ekuivalensi.kelas_id, ekuivalensi.semester_id)
    }

    // Validasi tipe file
    const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/png', 'image/jpg']
    if (!allowedTypes.includes(file.type)) {
      return NextResponse.json(
        { message: 'Tipe file tidak didukung. Hanya PDF, DOC, DOCX, JPG, PNG' },
        { status: 400 }
      )
    }

    // Validasi ukuran (max 10MB)
    const maxSize = 10 * 1024 * 1024
    if (file.size > maxSize) {
      return NextResponse.json(
        { message: 'Ukuran file terlalu besar (max 10MB)' },
        { status: 400 }
      )
    }

    // Buat folder jika belum ada
    const uploadDir = join(process.cwd(), 'public', 'nota')
    if (!existsSync(uploadDir)) {
      await mkdir(uploadDir, { recursive: true })
    }

    // Generate nama file unik
    const timestamp = Date.now()
    const fileExtension = file.name.split('.').pop()
    const fileName = `${ekuivalensiId}-${timestamp}.${fileExtension}`
    const filePath = join(uploadDir, fileName)

    // Simpan file
    const buffer = await file.arrayBuffer()
    await writeFile(filePath, Buffer.from(buffer))

    // Update database
    const notaUrl = `/nota/${fileName}`
    await prisma.ekuivalensi_kelas.update({
      where: { id: ekuivalensi.id },
      data: { nota_url: notaUrl },
    })

    return NextResponse.json(
      { 
        message: 'File berhasil diupload',
        notaUrl,
      },
      { status: 200 }
    )
  } catch (error) {
    const authResponse = authErrorResponse(error)
    if (authResponse) return authResponse

    console.error('Upload error:', error)
    return NextResponse.json(
      { message: 'Terjadi kesalahan saat upload file' },
      { status: 500 }
    )
  }
}
