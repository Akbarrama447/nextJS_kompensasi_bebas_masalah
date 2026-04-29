import dotenv from 'dotenv'
dotenv.config({ path: '.env.env' })

import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import { PrismaClient } from '../src/generated/prisma'
import { hash } from 'bcryptjs'

const { Pool } = pg
const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

// Test accounts
const testAccounts = [
  { nim: '2372001', password: '2372001', nama: 'Test User 2372001' },
]

// Menus
const menusData = [
  { key: 'dashboard', label: 'Dashboard', icon: 'LayoutDashboard', path: '/user/dashboard', urutan: 1 },
  { key: 'pekerjaan', label: 'List Pekerjaan', icon: 'Briefcase', path: '/user/pekerjaan', urutan: 2 },
  { key: 'ekuivalensi', label: 'Ekuivalensi', icon: 'BookOpen', path: '/user/ekuivalensi', urutan: 3 },
]

async function seedMenus() {
  console.log('\n📋 Seeding menus...')
  for (const menu of menusData) {
    await prisma.menus.upsert({
      where: { key: menu.key },
      update: { label: menu.label, icon: menu.icon, path: menu.path, urutan: menu.urutan },
      create: { key: menu.key, label: menu.label, icon: menu.icon, path: menu.path, urutan: menu.urutan },
    })
    console.log(`  ✓ Menu: ${menu.label}`)
  }
}

async function seedStudents() {
  console.log('\n👨‍🎓 Seeding test student accounts...')
  for (const account of testAccounts) {
    try {
      // Check if user already exists
      const existingMahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim: account.nim },
        include: { user: true },
      })

      if (existingMahasiswa?.user) {
        console.log(`  ✓ Student ${account.nim} already exists, skipping...`)
        continue
      }

      // Hash password
      const hashedPassword = await hash(account.password, 10)

      // Create user
      const user = await prisma.users.create({
        data: {
          email: `${account.nim}@student.polnes.ac.id`,
          kata_sandi: hashedPassword,
        },
      })

      // Get first class (if available)
      const kelas = await prisma.kelas.findFirst()

      // Create mahasiswa
      await prisma.mahasiswa.upsert({
        where: { nim: account.nim },
        update: { user_id: user.user_id, nama: account.nama },
        create: {
          nim: account.nim,
          user_id: user.user_id,
          nama: account.nama,
          kelas_id: kelas?.id,
        },
      })

      console.log(`  ✓ Student: ${account.nim} (${account.nama}) | Password: ${account.password}`)
    } catch (error) {
      console.error(`  ✗ Error creating ${account.nim}:`, error instanceof Error ? error.message : error)
    }
  }
}

async function main() {
  console.log('🌱 Starting database seeding...')
  await seedMenus()
  await seedStudents()
  console.log('\n✅ Seeding completed successfully!\n')
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
