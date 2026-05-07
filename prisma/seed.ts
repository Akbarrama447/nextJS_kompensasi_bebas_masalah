import dotenv from 'dotenv'
dotenv.config({ path: '.env' })

import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import { PrismaClient } from '../src/generated/prisma'
import { hash } from 'bcryptjs'

const { Pool } = pg
const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

// Test accounts - students
const studentAccounts = [
  { nim: '3372001', nama: 'Ahmad Faisal', password: 'password123' },
  { nim: '3372002', nama: 'Budi Santoso', password: 'password123' },
  { nim: '3372003', nama: 'Citra Dewi', password: 'password123' },
]

// Test accounts - admin
const adminAccounts = [
  { nip: '196801011990031001', nama: 'Dr. Admin', password: 'admin123' },
]

// Reference data
const refStatusTugas = [
  { id: 1, nama: 'MENUNGGU' },
  { id: 2, nama: 'SEDANG_DIKERJAKAN' },
  { id: 3, nama: 'SELESAI' },
  { id: 4, nama: 'DIVERIFIKASI' },
]

const refTipePekerjaan = [
  { id: 1, nama: 'Internal' },
  { id: 2, nama: 'Eksternal' },
]

const refStatusImport = [
  { id: 1, nama: 'MENUNGGU' },
  { id: 2, nama: 'SEDANG_DIPROSES' },
  { id: 3, nama: 'SELESAI' },
  { id: 4, nama: 'GAGAL' },
]

const refStatusEkuivalensi = [
  { id: 1, nama: 'MENUNGGU' },
  { id: 2, nama: 'SEDANG_DIPROSES' },
  { id: 3, nama: 'DISETUJUI' },
  { id: 4, nama: 'DITOLAK' },
]

// Menus for admin
const adminMenus = [
  { key: 'dashboard', label: 'Dashboard', icon: 'LayoutDashboard', path: '/admin/dashboard', urutan: 1, parent_id: null },
  { key: 'pekerjaan', label: 'Pekerjaan', icon: 'Briefcase', path: '/admin/pekerjaan', urutan: 2, parent_id: null },
  { key: 'laporan', label: 'Laporan', icon: 'FileText', path: '/admin/laporan', urutan: 3, parent_id: null },
  { key: 'pengaturan', label: 'Pengaturan', icon: 'Settings', path: '/admin/pengaturan', urutan: 4, parent_id: null },
]

// Menus for mahasiswa
const mahasiswaMenus = [
  { key: 'dashboard', label: 'Dashboard', icon: 'LayoutDashboard', path: '/user/dashboard', urutan: 1, parent_id: null },
  { key: 'pekerjaan', label: 'Pekerjaan', icon: 'Briefcase', path: '/user/pekerjaan', urutan: 2, parent_id: null },
  { key: 'ekuivalensi', label: 'Ekuivalensi', icon: 'BookOpen', path: '/user/ekuivalensi', urutan: 3, parent_id: null },
]

// Semester
const semesterData = { id: 1, nama: '2025/2026 Ganjil', tahun: 2025, periode: 'Ganjil', is_aktif: true }

async function seedRefStatus() {
  console.log('\n📋 Seeding reference data...')
  
  // Status Tugas
  for (const status of refStatusTugas) {
    await prisma.ref_status_tugas.upsert({
      where: { id: status.id },
      update: { nama: status.nama },
      create: { id: status.id, nama: status.nama },
    })
    console.log(`  ✓ ref_status_tugas: ${status.nama}`)
  }

  // Tipe Pekerjaan
  for (const tipe of refTipePekerjaan) {
    await prisma.ref_tipe_pekerjaan.upsert({
      where: { id: tipe.id },
      update: { nama: tipe.nama },
      create: { id: tipe.id, nama: tipe.nama },
    })
    console.log(`  ✓ ref_tipe_pekerjaan: ${tipe.nama}`)
  }

  // Status Import
  for (const status of refStatusImport) {
    await prisma.ref_status_import.upsert({
      where: { id: status.id },
      update: { nama: status.nama },
      create: { id: status.id, nama: status.nama },
    })
    console.log(`  ✓ ref_status_import: ${status.nama}`)
  }

  // Status Ekuivalensi
  for (const status of refStatusEkuivalensi) {
    await prisma.ref_status_ekuivalensi.upsert({
      where: { id: status.id },
      update: { nama: status.nama },
      create: { id: status.id, nama: status.nama },
    })
    console.log(`  ✓ ref_status_ekuivalensi: ${status.nama}`)
  }
}

async function seedSemester() {
  console.log('\n📅 Seeding semester...')
  try {
    await prisma.semester.upsert({
      where: { id: semesterData.id },
      update: { 
        nama: semesterData.nama, 
        tahun: semesterData.tahun, 
        periode: semesterData.periode, 
        is_aktif: semesterData.is_aktif 
      },
      create: semesterData,
    })
    console.log(`  ✓ Semester: ${semesterData.nama}`)
  } catch (e) {
    console.error('  ✗ Error seeding semester:', e)
  }
}

async function seedAdmin() {
  console.log('\n👨‍💼 Seeding admin accounts...')
  for (const account of adminAccounts) {
    try {
      const hashedPassword = await hash(account.password, 10)
      
      const user = await prisma.users.create({
        data: {
          email: `${account.nip}@polnes.ac.id`,
          kata_sandi: hashedPassword,
        },
      })

      await prisma.staf.upsert({
        where: { nip: account.nip },
        update: { user_id: user.user_id, nama: account.nama, tipe_staf: 'admin' },
        create: {
          nip: account.nip,
          user_id: user.user_id,
          nama: account.nama,
          tipe_staf: 'admin',
        },
      })

      console.log(`  ✓ Admin: ${account.nip} (${account.nama}) | Password: ${account.password}`)
    } catch (e) {
      console.error(`  ✗ Error creating admin ${account.nip}:`, e)
    }
  }
}

async function seedStudents() {
  console.log('\n👨‍🎓 Seeding student accounts...')
  
  // Get or create default kelas
  const prodi = await prisma.prodi.findFirst()
  let kelasId = null
  
  if (prodi) {
    const kelas = await prisma.kelas.upsert({
      where: { id: 1 },
      update: { prodi_id: prodi.id, nama_kelas: 'Reguler A' },
      create: { id: 1, prodi_id: prodi.id, nama_kelas: 'Reguler A' },
    })
    kelasId = kelas.id
    console.log(`  ✓ Kelas: ${kelas.nama_kelas}`)
  }

  for (const account of studentAccounts) {
    try {
      const hashedPassword = await hash(account.password, 10)
      
      const user = await prisma.users.create({
        data: {
          email: `${account.nim}@student.polnes.ac.id`,
          kata_sandi: hashedPassword,
        },
      })

      await prisma.mahasiswa.upsert({
        where: { nim: account.nim },
        update: { user_id: user.user_id, nama: account.nama },
        create: {
          nim: account.nim,
          user_id: user.user_id,
          nama: account.nama,
        },
      })

      // Create kompen_awal for student
      // Check if kompen_awal exists for this student
      const existingKompen = await prisma.kompen_awal.findFirst({
        where: { nim: account.nim },
      })
      
      // Create kompen_awal for student
      const jamKompen = Math.floor(Math.random() * 16) + 8 // 8-24 jam random
      
      if (!existingKompen) {
        await prisma.kompen_awal.create({
          data: {
            nim: account.nim,
            semester_id: 1,
            total_jam_wajib: jamKompen,
          },
        })
      }

      console.log(`  ✓ Student: ${account.nim} (${account.nama}) | Password: ${account.password} | Jam Kompen: ${jamKompen}jam`)
    } catch (e) {
      console.error(`  ✗ Error creating student ${account.nim}:`, e)
    }
  }
}

async function seedMenus() {
  console.log('\n📱 Seeding menus...')
  
  // Clear existing menus and insert new ones
  await prisma.menus.deleteMany({ where: { parent_id: null } })
  
  const menusToSeed = studentAccounts.length === 0 ? adminMenus : mahasiswaMenus
  
  for (const menu of menusToSeed) {
    await prisma.menus.create({
      data: menu,
    })
    console.log(`  ✓ Menu: ${menu.label} (${menu.key})`)
  }
}

async function main() {
  console.log('🌱 Starting database seeding...')
  console.log('================================')
  
  await seedRefStatus()
  await seedSemester()
  await seedAdmin()
  await seedStudents()
  await seedMenus()
  
  console.log('\n================================')
  console.log('✅ Seeding completed successfully!\n')
}

main()
  .catch((e) => {
    console.error('❌ Error:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
    await pool.end()
  })