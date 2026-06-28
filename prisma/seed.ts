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

// Test accounts - admin & staff
const staffAccounts = [
  {
    nip: 'admin',
    nama: 'Super Admin',
    email: 'admin@admin.com',
    password: 'admin123',
    tipe_staf: 'superadmin',
    jurusan_id: 1,
    role_id: 1 // Super Admin
  },
  {
    nip: '196801011990031001',
    nama: 'Dr. Ahmad Fauzi, M.T.',
    email: 'ahmad.fauzi@polines.ac.id',
    password: 'admin123',
    tipe_staf: 'dosen',
    jurusan_id: 1,
    role_id: 4 // Dosen
  },
  {
    nip: '197505122002121002',
    nama: 'Ir. Siti Aminah, M.Kom.',
    email: 'siti.aminah@polines.ac.id',
    password: 'password123',
    tipe_staf: 'staf',
    jurusan_id: 1,
    role_id: 2 // Staf Jurusan
  },
  {
    nip: '198203042010012001',
    nama: 'Budi Raharjo, S.T.',
    email: 'budi.raharjo@polines.ac.id',
    password: 'password123',
    tipe_staf: 'teknisi',
    jurusan_id: 2,
    role_id: 2 // Staf Jurusan
  }
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
  { id: 1, nama: 'SELESAI' },
  { id: 2, nama: 'GAGAL' },
]

const refStatusEkuivalensi = [
  { id: 1, nama: 'MENUNGGU' },
  { id: 2, nama: 'SEDANG_DIPROSES' },
  { id: 3, nama: 'DISETUJUI' },
  { id: 4, nama: 'DITOLAK' },
]

// Menus for superadmin
const superadminMenus = [
  { key: 'dashboard_superadmin', label: 'Dashboard', icon: 'LayoutDashboard', path: '/superadmin/dashboard', urutan: 1, parent_id: null },
  { key: 'manajemen_menu', label: 'Manajemen Menu', icon: 'Menu', path: '/superadmin/manajemen-menu', urutan: 2, parent_id: null },
  { key: 'manajemen_user', label: 'User', icon: 'Users', path: '/superadmin/users', urutan: 3, parent_id: null },
]

// Menus for admin
const adminMenus = [
  { key: 'dashboard_admin', label: 'Dashboard', icon: 'LayoutDashboard', path: '/admin/dashboard', urutan: 1, parent_id: null },
  { key: 'pekerjaan_admin', label: 'Pekerjaan', icon: 'Briefcase', path: '/admin/list_pekerjaan', urutan: 2, parent_id: null },
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

  // Roles — sync dengan data di database
  const roles = [
    { id: 1, nama: 'Super Admin', key_menu: ['all'], key_condition: { all: true } },
    { id: 2, nama: 'Staf Jurusan', key_menu: ['daftar_pekerjaan', 'penugasan', 'verifikasi'], key_condition: { jurusan_only: true } },
    { id: 3, nama: 'Mahasiswa', key_menu: ['pekerjaan', 'riwayat', 'profil'], key_condition: { self_only: true } },
    { id: 4, nama: 'Dosen', key_menu: ['verifikasi', 'laporan'], key_condition: { jurusan_only: true } },
  ];
  for (const role of roles) {
    await prisma.roles.upsert({
      where: { id: role.id },
      update: { nama: role.nama, key_menu: role.key_menu, key_condition: role.key_condition },
      create: role,
    });
    console.log(`  ✓ roles: ${role.nama}`)
  }

  // Jurusan
  const jurusans = [
    { id: 1, nama_jurusan: 'Teknik Elektro' },
    { id: 2, nama_jurusan: 'Teknik Mesin' },
    { id: 3, nama_jurusan: 'Teknik Sipil' },
    { id: 4, nama_jurusan: 'Akuntansi' },
    { id: 5, nama_jurusan: 'Administrasi Bisnis' },
  ];
  for (const j of jurusans) {
    await prisma.jurusan.upsert({
      where: { id: j.id },
      update: { nama_jurusan: j.nama_jurusan },
      create: j,
    });
    console.log(`  ✓ jurusan: ${j.nama_jurusan}`)
  }

  // Prodi
  const prodiList = [
    { id: 1, nama_prodi: 'D4 Teknik Informatika', jurisdiction_id: 1 },
    { id: 2, nama_prodi: 'D4 Teknologi Rekayasa Komputer', jurisdiction_id: 1 },
    { id: 3, nama_prodi: 'D3 Telekomunikasi', jurisdiction_id: 1 },
  ];
  for (const p of prodiList) {
    await prisma.prodi.upsert({
      where: { id: p.id },
      update: { nama_prodi: p.nama_prodi, jurisdiction_id: p.jurisdiction_id },
      create: p,
    });
    console.log(`  ✓ prodi: ${p.nama_prodi}`)
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

async function seedStaff() {
  console.log('\n👨‍💼 Seeding staff accounts...')
  for (const account of staffAccounts) {
    try {
      const hashedPassword = await hash(account.password, 10)

      const user = await prisma.users.upsert({
        where: { email: account.email },
        update: { role_id: account.role_id },
        create: {
          email: account.email,
          kata_sandi: hashedPassword,
          role_id: account.role_id,
        },
      })

      await prisma.staf.upsert({
        where: { nip: account.nip },
        update: {
          user_id: user.user_id,
          nama: account.nama,
          tipe_staf: account.tipe_staf,
          jurisdiction_id: account.jurusan_id
        },
        create: {
          nip: account.nip,
          user_id: user.user_id,
          nama: account.nama,
          tipe_staf: account.tipe_staf,
          jurisdiction_id: account.jurusan_id
        },
      })

      console.log(`  ✓ Staff: ${account.nip} (${account.nama}) | Role ID: ${account.role_id}`)
    } catch (e) {
      console.error(`  ✗ Error creating staff ${account.nip}:`, e)
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
      const email = `${account.nim}@student.polnes.ac.id`

      // Cari atau buat User agar aman dari duplikasi email
      let user = await prisma.users.findUnique({
        where: { email }
      })

      if (!user) {
        user = await prisma.users.create({
          data: {
            email,
            kata_sandi: hashedPassword,
            role_id: 3 // Mahasiswa (role_id di DB)
          }
        })
      }

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

  // Seed ALL menus — superadmin, admin, and mahasiswa
  const allMenus = [...superadminMenus, ...adminMenus, ...mahasiswaMenus]

  for (const menu of allMenus) {
    await prisma.menus.create({
      data: menu,
    })
    console.log(`  ✓ Menu: ${menu.label} (${menu.key})`)
  }
}

async function seedRoleHasMenus() {
  console.log('\n🔗 Seeding role_has_menus...')

  await prisma.role_has_menus.deleteMany()

  const roleMenuMap: { role_id: number; keys: string[] }[] = [
    { role_id: 1, keys: ['dashboard_superadmin', 'manajemen_menu', 'manajemen_user'] }, // Super Admin — superadmin access
    { role_id: 2, keys: ['dashboard_admin', 'pekerjaan_admin'] }, // Staf Jurusan
    { role_id: 3, keys: ['dashboard', 'pekerjaan', 'ekuivalensi'] }, // Mahasiswa
    { role_id: 4, keys: ['dashboard_admin', 'pekerjaan_admin'] }, // Dosen
  ]

  for (const entry of roleMenuMap) {
    const menusData = await prisma.menus.findMany({
      where: { key: { in: entry.keys } },
      select: { id: true, key: true },
    })

    for (const menu of menusData) {
      await prisma.role_has_menus.create({
        data: {
          role_id: entry.role_id,
          menus_id: menu.id,
        },
      })
      console.log(`  ✓ role_has_menus: role_id=${entry.role_id} → menu_key=${menu.key}`)
    }
  }
}

async function main() {
  console.log('🌱 Starting database seeding...')
  console.log('================================')

  await seedRefStatus()
  await seedSemester()
  await seedStaff()
  await seedStudents()
  await seedMenus()
  await seedRoleHasMenus()

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